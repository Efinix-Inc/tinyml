///////////////////////////////////////////////////////////////////////////////////
// Copyright 2024 Efinix.Inc. All Rights Reserved.
// You may obtain a copy of the license at
//    https://www.efinixinc.com/software-license.html
///////////////////////////////////////////////////////////////////////////////////

#include <stdlib.h>
#include <stdint.h>
#include "riscv.h"
#include "soc.h"
#include "bsp.h"
#include "plic.h"
#include "uart.h"
#include <math.h>
#include "print.h"
#include "clint.h"
#include "common.h"
#include "PiCamDriver.h"
#include "apb3_cam.h"
#include "i2c.h"
#include "i2cDemo.h"
extern "C" {
#include "dmasg.h"
}
#include "axi4_hw_accel.h"

//Tinyml Header File
#include "intc.h"
#include "tinyml.h"
#include "ops/ops_api.h"

//Import TensorFlow lite libraries
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
//#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/testing/micro_test.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/c/common.h"
#include "tensorflow/lite/micro/debug_log.h"
#include "tensorflow/lite/micro/micro_time.h"
#include "platform/tinyml/profiler.h"


//Model data
#include "model/mobilenetv1_person_detect_model_data.h"
#include "model/model_settings.h"

#define PERSON_DETECT_INPUT_BYTES 96*96

#define FRAME_WIDTH     1080
#define FRAME_HEIGHT    1080

//Set to 4 for multi-buffering; Set to 1 for single buffering (shared for camera frame capture, display, and tinyML pre-processing input).
#define NUM_BUFFER   4
//Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display and hw_accel blocks.
//BUFFER_START_ADDR should not overlap with memory space allocated for RISC-V program (default.ld)
#define BUFFER_START_ADDR        0x01100000
//Memory gap between BUFFER_START_ADDR and TINYML_INPUT_START_ADDR must sufficient to accommate NUM_BUFFER*FRAME_WIDTH*FRAME_HEIGHT*4 bytes data
//for 1080x1080 : 0x01100000 + 0x011CC400 = 0x022CC400 -- minimum requirement
#define TINYML_INPUT_START_ADDR  0x03000000


#define buffer_array       ((volatile uint32_t*)BUFFER_START_ADDR)
#define tinyml_input_array ((volatile uint8_t*)TINYML_INPUT_START_ADDR)

#define downscaled_image_array ((volatile uint32_t*)DOWSCALED_IMAGE_START_ADDR)

uint8_t camera_buffer = 0;
uint8_t display_buffer = 0;
uint8_t next_display_buffer = 0;
uint8_t draw_buffer = 0;

namespace {
   tflite::ErrorReporter* error_reporter = nullptr;
   const tflite::Model* model = nullptr;
   tflite::MicroInterpreter* interpreter = nullptr;
   TfLiteTensor* model_input = nullptr;
   
   //Create an area of memory to use for input, output, and other TensorFlow
   //arrays. You'll need to adjust this by combiling, running, and looking
   //for errors.
   constexpr int kTensorArenaSize = 136 * 1024;
   uint8_t tensor_arena[kTensorArenaSize];
}


void tinyml_init() {
   //Set up logging
   static tflite::MicroErrorReporter micro_error_reporter;
   error_reporter = &micro_error_reporter;
   
   //Map the model into a usable data structure
   model = tflite::GetModel(mobilenetv1_person_detect_model_data);
   
   if (model->version() != TFLITE_SCHEMA_VERSION) {
      MicroPrintf("Model version does not match Schema\n\r");
      while(1);
   }
   
   //User may pull in only needed operations via MicroMutableOpResolver (which should match NN layers)
   static tflite::MicroMutableOpResolver<5> micro_mutable_op_resolver;
   
   micro_mutable_op_resolver.AddAveragePool2D();
   micro_mutable_op_resolver.AddConv2D();
   micro_mutable_op_resolver.AddDepthwiseConv2D();
   micro_mutable_op_resolver.AddReshape();
   micro_mutable_op_resolver.AddSoftmax();
   
   ////AllOpsResolver may be used for generalization
   //static tflite::AllOpsResolver resolver;
   //tflite::MicroOpResolver* op_resolver = nullptr;
   //op_resolver = &resolver;
   
   //Build an interpreter to run the model
   
   static FullProfiler prof;
   static tflite::MicroInterpreter static_interpreter(
      model, micro_mutable_op_resolver, tensor_arena, kTensorArenaSize,
      error_reporter, nullptr); //Without profiler
//      error_reporter, &prof); //With profiler
   interpreter = &static_interpreter;
   prof.setInterpreter(interpreter);
   prof.setDump(false);


   //Allocate memory from the tensor_arena for the model's tensors
   TfLiteStatus allocate_status = interpreter->AllocateTensors();
   if (allocate_status != kTfLiteOk) {
      MicroPrintf("AllocateTensors() failed\n\r");
      while(1);
   }
   
   //Assign model input buffer (tensor) to pointer
   model_input = interpreter->input(0);
   
   //Print loaded model input and output shape
   MicroPrintf("\n\rTotal output layers: %d\n\r", interpreter->outputs_size());
   MicroPrintf(
      "Input shape: %d %d %d %d %d, type: %d\n", model_input->dims->size, model_input->dims->data[0], model_input->dims->data[1], model_input->dims->data[2], model_input->dims->data[3], model_input->type
   );
   
   for (int i = 0; i < (interpreter->outputs_size()); ++i)
      MicroPrintf(
         "Output shape %d: %d %d %d, type: %d\n\r", i, interpreter->output(i)->dims->size, interpreter->output(i)->dims->data[0], interpreter->output(i)->dims->data[1], interpreter->output(i)->type
      );
}

u32 buf(u32 i) {
   return BUFFER_START_ADDR +  FRAME_WIDTH*FRAME_HEIGHT*4*i;
}

static void flush_data_cache(){
   asm(".word(0x500F)");
}

void send_dma(u32 channel, u32 port, u32 addr, u32 size, int interrupt, int wait, int self_restart) {
   dmasg_input_memory(DMASG_BASE, channel, addr, 16);
   dmasg_output_stream(DMASG_BASE, channel, port, 0, 0, 1);
   
   if(interrupt) {
      dmasg_interrupt_config(DMASG_BASE, channel, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
   }
   
   if(self_restart) {
      dmasg_direct_start(DMASG_BASE, channel, size, 1);
   } else {
      dmasg_direct_start(DMASG_BASE, channel, size, 0);
   }
   
   if(wait) {
      while(dmasg_busy(DMASG_BASE, channel));
      flush_data_cache();
   }
}

void recv_dma(u32 channel, u32 port, u32 addr, u32 size, int interrupt, int wait, int self_restart) {
   dmasg_input_stream(DMASG_BASE, channel, port, 1, 0);
   dmasg_output_memory(DMASG_BASE, channel, addr, 16);
   
   if(interrupt){
      dmasg_interrupt_config(DMASG_BASE, channel, DMASG_CHANNEL_INTERRUPT_CHANNEL_COMPLETION_MASK);
   }

   if(self_restart) {
      dmasg_direct_start(DMASG_BASE, channel, size, 1);
   } else {
      dmasg_direct_start(DMASG_BASE, channel, size, 0);
   }

   if(wait){
      while(dmasg_busy(DMASG_BASE, channel));
      flush_data_cache();
   }
}

void trigger_next_display_dma() {
   display_buffer = next_display_buffer;
   send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, buf(display_buffer), (FRAME_WIDTH*FRAME_HEIGHT)*4, 1, 0, 0);
}

void trigger_next_cam_dma() {
   next_display_buffer = camera_buffer;
   
   for(int i=0; i<NUM_BUFFER; i++)
   {
      if(i!=display_buffer && i!=next_display_buffer && i!=draw_buffer)
      {
         camera_buffer = i;
         break;
      }
   }

   recv_dma(DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, buf(camera_buffer), (FRAME_WIDTH*FRAME_HEIGHT)*4, 1, 0, 0);

   //Indicate start of S2MM DMA to camera building block via APB3 slave
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);

   //Trigger storage of one captured frame via APB3 slave
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);
}


void main() {

   MicroPrintf("\t--Hello Efinix Edge Vision SoC TinyML--\n\r");
   
   /************************************************************SETUP PICAM************************************************************/
   u32 rdata;

   MicroPrintf("Camera Setting...");
   
   // Reset mipi
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0x00000001);// assert reset
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG1_OFFSET, 0x00000000);//de-assert reset

   //Camera I2C configuration
   mipi_i2c_init();
   PiCam_init();
   
   //SET camera pre-processing RGB gain value
   Set_RGBGain(1,5,3,4);
   
   MicroPrintf("Done\n\r");

   /*************************************************************SETUP DMA*************************************************************/

   MicroPrintf("DMA Setting...");
   
   dma_init();
   
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL, 0, 0);
   dmasg_priority(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL,  3, 0);
   dmasg_priority(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL,      0, 0);
   
   MicroPrintf("Done\n\r");

   /***********************************************************TRIGGER DISPLAY*******************************************************/

   MicroPrintf("Initialize display memory content...");

   //Initialize test image in buffer_array (default buffer 0) 
   for (int y=0; y<FRAME_HEIGHT; y++) {
      for (int x=0; x<FRAME_WIDTH; x++) {
         if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) {
            buffer_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
         } else if (x<(FRAME_WIDTH/4)) {
            buffer_array [y*FRAME_WIDTH + x] = 0x0000FF00; //GREEN
         } else if (x<(FRAME_WIDTH/4 *2)) {
            buffer_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
         } else if (x<(FRAME_WIDTH/4 *3)) {
            buffer_array [y*FRAME_WIDTH + x] = 0x000000FF; //RED
         } else {
            buffer_array [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
         }
      }
   }

   MicroPrintf("Done\n\r");
   
   //Trigger display DMA once then the rest handled by interrupt sub-rountine
   MicroPrintf("Trigger display DMA...");
   send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, buf(display_buffer), (FRAME_WIDTH*FRAME_HEIGHT)*4, 1, 0, 0);
   display_mm2s_active = 1;
   MicroPrintf("Done\n\r");

   msDelay(3000); //Display colour bar for 3 seconds
   
    /*********************************************************TRIGGER CAMERA CAPTURE*****************************************************/
    
    //SELECT RGB or grayscale output from camera pre-processing block.
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000);   //RGB
    
    //Trigger camera DMA once then the rest handled by interrupt sub-rountine
    MicroPrintf("Trigger camera DMA...");
    recv_dma(DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, buf(camera_buffer), (FRAME_WIDTH*FRAME_HEIGHT)*4, 1, 0, 0);
    cam_s2mm_active = 1;
 
    //Indicate start of S2MM DMA to camera building block via APB3 slave
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);
 
    //Trigger storage of one captured frame via APB3 slave
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
    EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);
    
    MicroPrintf("Done\n\r");
 
    /***********************************************************TFLITE-MICRO TINYML*******************************************************/
 
    TfLiteStatus invoke_status;
    int8_t person_score;
    int8_t person_score_percent;
    int8_t no_person_score;
    int8_t colour_status;
 
    MicroPrintf("TinyML Setup...");
    tinyml_init();
    MicroPrintf("Done\n\r");
 
    //For timestamp
    uint64_t timerCmp0, timerCmp1, timerDiff_0_1;
    u32 ms;
 
    while(1) {
 
       /***********************************************HW ACCELERATOR - TINYML PRE-PROCESSING********************************************/
 
       //Person Detection Model: Perform RGB3grayscale conversion + Scaling & Cropping
       //Input: 540x540x3; Output: 96x96x1
       MicroPrintf("\n\rHardware Accelerator - TinyML Pre-processing...");
       
       //Trigger HW accel MM2S DMA
       send_dma(DMASG_HW_ACCEL_MM2S_CHANNEL, DMASG_HW_ACCEL_MM2S_PORT, buf(draw_buffer), (FRAME_WIDTH*FRAME_HEIGHT)*4, 0, 0, 0);
       
       //Trigger HW accel S2MM DMA
       recv_dma(DMASG_HW_ACCEL_S2MM_CHANNEL, DMASG_HW_ACCEL_S2MM_PORT, TINYML_INPUT_START_ADDR, PERSON_DETECT_INPUT_BYTES, 0, 0, 0);
       
       //Indicate start of S2MM DMA to HW accel building block via APB3 slave
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG6_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG6_OFFSET, 0x00000000);
       
 
       //Wait for DMA transfer completion
       while(dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL) || dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL));
       flush_data_cache();
 
       MicroPrintf("Done\n\r");
 
       /*******************************************************TINYML INFERENCE**********************************************************/
 
       MicroPrintf("TinyML Inference...");
 
       //Copy test image to tflite model input. Input size to person detection model 96*96=9216
       for (unsigned int i = 0; i < PERSON_DETECT_INPUT_BYTES; ++i)
          model_input->data.int8[i] = tinyml_input_array[i] - 128; //Input normalization: From range [0,255] to [-128,127]
       
       //Perform inference
       timerCmp0 = clint_getTime(BSP_CLINT);
       invoke_status = interpreter->Invoke();
       timerCmp1 = clint_getTime(BSP_CLINT);
 
       if (invoke_status != kTfLiteOk) {
         MicroPrintf("Invoke failed on data\n\r");
       }
       MicroPrintf("Done\n\n\r");
 
       //Retrieve inference output
       no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
       person_score    = interpreter->output(0)->data.int8[kPersonIndex];
       
       person_score_percent = ((person_score + 128) * 100) >> 8;
       
       MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", person_score_percent);
       
       //Display person detection result on mini DSI display panel. Red: No person detected; Green: Person detected
       if (person_score_percent>49) {
             EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG5_OFFSET, 0x0100FF00); //Person detected
       } else {
             EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG5_OFFSET, 0x010000FF); //No person detected
       }
       
       timerDiff_0_1 = timerCmp1 - timerCmp0;
       u32 *v = (u32 *)&timerDiff_0_1;
       MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
       MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
       MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
       ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
       MicroPrintf("Inference time: %ums\n\r", ms);
       
       draw_buffer = next_display_buffer;
    }

   /**********************************************Check APB3 Slave Status (Camera, Display & HW Accelerator)******************************************/
/*
   MicroPrintf("\nCamera and display APB3 status..\n\r");

   //Verify slave read operation. Expecting 32'hABCD_5678
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG16_OFFSET);
   MicroPrintf("test_value : %x\n\r", rdata);

   //{28'd0, debug_cam_dma_fifo_underflow, debug_cam_dma_fifo_overflow, debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow}
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG7_OFFSET);
   MicroPrintf("debug_fifo_status : %x\n\r", rdata);

   //debug_cam_dma_fifo_rcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG8_OFFSET);
   MicroPrintf("debug_cam_dma_fifo_rcount : %x\n\r", rdata);

   //debug_cam_dma_fifo_wcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG9_OFFSET);
   MicroPrintf("debug_cam_dma_fifo_wcount : %x\n\r", rdata);

   //debug_display_dma_fifo_rcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG10_OFFSET);
   MicroPrintf("debug_display_dma_fifo_rcount : %x\n\r", rdata);

   //debug_display_dma_fifo_wcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG11_OFFSET);
   MicroPrintf("debug_display_dma_fifo_wcount : %x\n\r", rdata);

   //debug_cam_dma_status
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG12_OFFSET);
   MicroPrintf("debug_cam_dma_status : %x\n\r", rdata);

   //frames_per_second
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG13_OFFSET);
   MicroPrintf("frames_per_second : %x\n\r", rdata);
   
   //debug_dma_hw_accel_in_fifo_wcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG14_OFFSET);
   MicroPrintf("debug_dma_hw_accel_in_fifo_wcount : %x\n\r", rdata);
   
   //debug_dma_hw_accel_out_fifo_rcount
   rdata = example_register_read(EXAMPLE_APB3_SLV_REG15_OFFSET);
   MicroPrintf("debug_dma_hw_accel_out_fifo_rcount : %x\n\r", rdata);
*/

}