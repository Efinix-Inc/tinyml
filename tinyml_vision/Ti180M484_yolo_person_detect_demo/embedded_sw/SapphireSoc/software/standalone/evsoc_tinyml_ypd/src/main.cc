/* Copyright 2019 The TensorFlow Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/

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
//#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/testing/micro_test.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/c/common.h"
#include "tensorflow/lite/micro/debug_log.h"
#include "tensorflow/lite/micro/micro_time.h"
#include "platform/tinyml/profiler.h"

//Model data
#include "model/yolo_person_detect_model_data.h"

//Yolo layer
#include "model/yolo.h"


#define SCALE 1
#define CLASSES 1
#define TOTAL_ANCHORS 3
#define NET_HEIGHT 96
#define NET_WIDTH 96
#define OBJECTNESS_THRESHOLD 0.25
#define IOU_THRESHOLD 0.5

#define YOLO_PICO_INPUT_BYTES 96*96*3

#define FRAME_WIDTH     1080
#define FRAME_HEIGHT    1080


//Set to 4 for multi-buffering; Set to 1 for single buffering (shared for camera frame capture, display, and tinyML pre-processing input).
#define NUM_BUFFER   4
//Start address to be divided evenly by 8. Otherwise DMA tkeep might be shifted, not handled in display and hw_accel blocks.
//BUFFER_START_ADDR should not overlap with memory space allocated for RISC-V program (default.ld)
#define BUFFER_START_ADDR        0x01100000
//Memory gap between BUFFER_START_ADDR and TINYML_INPUT_START_ADDR must sufficient to accommate NUM_BUFFER*FRAME_WIDTH*FRAME_HEIGHT*4 bytes data
#define TINYML_INPUT_START_ADDR  0x03000000



#define BBOX_MAX 16
#define BBOX_CMD_ADDRESS    0x03100000
//The box buffer consist of command , data , and dummy data as padding to ensure that the total data transfer is always even
//DMA controller perform 128-bit word transfer, and our DMA channel will transfer 64-bit word to annotator
//Each transfer initiated from DMA controller will be 128-bit word, thus we need to ensure an even number of transfer
#define TOTAL_BOX_BUFFER   8 + (BBOX_MAX*8) + (64-8)
#define bbox_array ((volatile uint64_t*)BBOX_CMD_ADDRESS)

#define IMAGE_SIZE (FRAME_WIDTH*FRAME_HEIGHT)*4
#define IMAGE_CMD_OFFSET (0)
#define IMAGE_START_OFFSET (IMAGE_CMD_OFFSET + 8)
#define IMAGE_END_OFFSET (IMAGE_START_OFFSET + IMAGE_SIZE)
// The image consists of command, data and dummy data to ensure total data transfer is even , following DMA controller spec.
#define IMAGE_DUMMY_OFFSET (IMAGE_END_OFFSET + (64-8))
#define TOTAL_BUFFER_SIZE (IMAGE_DUMMY_OFFSET - IMAGE_CMD_OFFSET)

#define tinyml_input_array ((volatile uint8_t*)TINYML_INPUT_START_ADDR)

#define buffer_array       ((volatile uint32_t*)BUFFER_START_ADDR)

uint8_t camera_buffer = 0;
uint8_t display_buffer = 0;
uint8_t next_display_buffer = 0;
uint8_t draw_buffer = 0;
uint8_t bbox_overlay_busy = 0;
uint8_t bbox_overlay_updated = 0;

namespace {
   tflite::ErrorReporter* error_reporter = nullptr;
   const tflite::Model* model = nullptr;
   tflite::MicroInterpreter* interpreter = nullptr;
   TfLiteTensor* model_input = nullptr;

   //Create an area of memory to use for input, output, and other TensorFlow
   //arrays. You'll need to adjust this by combiling, running, and looking
   //for errors.
   constexpr int kTensorArenaSize = 10000 * 1024;
   uint8_t tensor_arena[kTensorArenaSize];
   int total_output_layers = 0;
   float anchors[2][TOTAL_ANCHORS * 2] = {{115, 73, 119, 199, 242, 238}, {12, 18, 37, 49, 52, 132}};
}


void tinyml_init() {
   //Set up logging
   static tflite::MicroErrorReporter micro_error_reporter;
   error_reporter = &micro_error_reporter;

   //Map the model into a usable data structure
   model = tflite::GetModel(yolo_person_detect_model_data);

   if (model->version() != TFLITE_SCHEMA_VERSION) {
      MicroPrintf("Model version does not match Schema\n\r");
      while(1);
   }


   //AllOpsResolver may be used for generalization
   static tflite::AllOpsResolver resolver;
   tflite::MicroOpResolver* op_resolver = nullptr;
   op_resolver = &resolver;

   //Build an interpreter to run the model

   FullProfiler prof;
   static tflite::MicroInterpreter static_interpreter(
      model, *op_resolver, tensor_arena, kTensorArenaSize,
      error_reporter, nullptr); //Without profiler
      //error_reporter, &prof); //With profiler
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
   total_output_layers = interpreter->outputs_size();
   MicroPrintf("\n\rTotal output layers: %d\n\r", total_output_layers);
   MicroPrintf(
      "Input shape: %d %d %d %d %d, type: %d\n\r", model_input->dims->size, model_input->dims->data[0], model_input->dims->data[1], model_input->dims->data[2], model_input->dims->data[3], model_input->type
   );

   for (int i = 0; i < total_output_layers; ++i)
      MicroPrintf(
         "Output shape %d: %d %d %d %d %d, type: %d\n\r", i, interpreter->output(i)->dims->size, interpreter->output(i)->dims->data[0],
         interpreter->output(i)->dims->data[1], interpreter->output(i)->dims->data[2], interpreter->output(i)->dims->data[3], interpreter->output(i)->type
      );
}

u32 buf(u32 i) {
   return BUFFER_START_ADDR +  TOTAL_BUFFER_SIZE*i;
}

static void flush_data_cache(){
   asm(".word(0x500F)");
}

u32 buf_offset(u32 i, u32 offset)
{
    return buf(i) + offset;
}

char* buf_offset_char(u32 i, u32 offset)
{
    return (char*)buf_offset(i, offset);
}

u32* buf_offset_u32(u32 i, u32 offset)
{
    return (u32*)buf_offset(i, offset);
}

u64* buf_offset_u64(u32 i, u32 offset)
{
    return (u64*)buf_offset(i, offset);
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
   send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, buf(display_buffer), TOTAL_BUFFER_SIZE, 1, 0, 0);
}

void trigger_next_box_dma() {
   if (bbox_overlay_updated) {
      send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, BBOX_CMD_ADDRESS, TOTAL_BOX_BUFFER, 0, 1, 0); //Wait till complete
      bbox_overlay_updated = 0;
   }
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

   recv_dma(DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, buf_offset(camera_buffer, IMAGE_START_OFFSET), IMAGE_SIZE, 1, 0, 0);

   //Indicate start of S2MM DMA to camera building block via APB3 slave
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);

   //Trigger storage of one captured frame via APB3 slave
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);
}


void color_pattern(volatile u32* buf){
   for (int y=0; y<FRAME_HEIGHT; y++) {
     for (int x=0; x<FRAME_WIDTH; x++) {
       if ((x<3 && y<3) || (x>=FRAME_WIDTH-3 && y<3) || (x<3 && y>=FRAME_HEIGHT-3) || (x>=FRAME_WIDTH-3 && y>=FRAME_HEIGHT-3)) {
         buf [y*FRAME_WIDTH + x] = 0x000000FF; //RED
       } else if (x<(FRAME_WIDTH/4)) {
         buf [y*FRAME_WIDTH + x] = 0x0000FF00; //GREEN
       } else if (x<(FRAME_WIDTH/4 *2)) {
         buf [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
       } else if (x<(FRAME_WIDTH/4 *3)) {
         buf [y*FRAME_WIDTH + x] = 0x000000FF; //RED
       } else {
         buf [y*FRAME_WIDTH + x] = 0x00FF0000; //BLUE
       }
     }
   }
}

void init_image(void)
{
    for(int i=0; i<NUM_BUFFER; i++)
    {
    *buf_offset_u64(i, IMAGE_CMD_OFFSET) = 1;
    //Initialize dummy data to be sent with command and data
    *buf_offset_u64(i, IMAGE_DUMMY_OFFSET) = 0;
    }
    color_pattern(buf_offset_u32(display_buffer, IMAGE_START_OFFSET));
}

void init_bbox(void)
{
   //Initialize all box coordinate to invalid, as well as dummy data to be sent with command and data.
   for(int j=0;j<=(BBOX_MAX+1);j++)
   {
      if(j==0){
         bbox_array[j] = 0x0000000000000002;
      } else{
       bbox_array[j] = 0xffffffffffffffff; //Invalid bounding box
    }
   }
   bbox_overlay_updated=1;
}


void init() {
   /************************************************************SETUP PICAM************************************************************/

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
   init_image();

   MicroPrintf("Done\n\r");
   //Initialize bbox_overlay_buffer - Trigger DMA for initialized bbox_overlay_buffer content to display annotator module!!!
   MicroPrintf("Initialize Bbox to invalid ...");
   init_bbox();
   MicroPrintf("Done\n\r");
   //Trigger display DMA once then the rest handled by interrupt sub-rountine
   MicroPrintf("Trigger display DMA...");
   send_dma(DMASG_DISPLAY_MM2S_CHANNEL, DMASG_DISPLAY_MM2S_PORT, buf(display_buffer), TOTAL_BUFFER_SIZE, 1, 0, 0);
   display_mm2s_active = 1;
   MicroPrintf("Done\n\r");

   msDelay(3000); //Display colour bar for 3 seconds
   
   /*********************************************************TRIGGER CAMERA CAPTURE*****************************************************/
   
   //SELECT RGB or grayscale output from camera pre-processing block.
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG3_OFFSET, 0x00000000);   //RGB

   //Trigger camera DMA once then the rest handled by interrupt sub-rountine
   MicroPrintf("Trigger camera DMA...");
   recv_dma(DMASG_CAM_S2MM_CHANNEL, DMASG_CAM_S2MM_PORT, buf_offset(camera_buffer, IMAGE_START_OFFSET), IMAGE_SIZE, 1, 0, 0);
   cam_s2mm_active = 1;

   //Indicate start of S2MM DMA to camera building block via APB3 slave
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000001);
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG4_OFFSET, 0x00000000);

   //Trigger storage of one captured frame via APB3 slave
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000001);
   EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG2_OFFSET, 0x00000000);

   MicroPrintf("Done\n\r");

   /***********************************************************TFLITE-MICRO TINYML*******************************************************/

   MicroPrintf("TinyML Setup...");
   tinyml_init();
   MicroPrintf("Done\n\r");
}

void draw_boxes(box* boxes,int total_boxes){
   //To store coordinates information
   float min_val = 0.00;
   float max_val = 1.00;
   uint16_t x_min;
   uint16_t x_max;
   uint16_t y_min;
   uint16_t y_max;
   uint64_t box_coordinates;
   float objectness_tresh=0.5;
   int count_boxes=0;

   for (int i = 0; i<=(BBOX_MAX); i++) {

      if(boxes[i].x_min < min_val || boxes[i].y_min < min_val || boxes[i].x_max < min_val|| boxes[i].y_max <min_val || boxes[i].x_min > max_val || boxes[i].y_min > max_val ||  i>total_boxes || boxes[i].objectness < objectness_tresh ){
         bbox_array[i+1] = 0xffffffffffffffff;
      }
      else {
         x_min = (boxes[i].x_min)*FRAME_WIDTH;
         y_min = (boxes[i].y_min)*FRAME_HEIGHT;
         x_max = (boxes[i].x_max)*FRAME_WIDTH;
         y_max = (boxes[i].y_max)*FRAME_HEIGHT;
   
         if(x_max > FRAME_WIDTH){
            x_max = (FRAME_WIDTH-1);
         }
         if(y_max > FRAME_HEIGHT){
            y_max = (FRAME_HEIGHT-1);
         }
         box_coordinates = (uint64_t) x_min << 48 | (uint64_t) y_min << 32 | (uint64_t) x_max << 16 |(uint64_t) y_max << 0;
         bbox_array[i+1] = box_coordinates;
         count_boxes++;
      }
   }
   MicroPrintf("Total Boxes : %d\n\r",count_boxes);
   bbox_overlay_updated=1;
}

void main() {

   MicroPrintf("\t--Hello Efinix Edge Vision TinyML--\n\r");
   u32 rdata;
   init();

   TfLiteStatus invoke_status;

   //For timestamp
   uint64_t timerCmp0, timerCmp1, timerDiff_0_1;
   uint64_t timerCmp2, timerCmp3, timerDiff_2_3;
   u32 ms;
   bbox_overlay_updated = 0;
   
   while(1) {

      /***********************************************HW ACCELERATOR - TINYML PRE-PROCESSING********************************************/

      //Yolo Pico Person Detection Model: Perform RGB3grayscale conversion + Scaling & Cropping
      //Input: 540x540x3; Output: 96x96x3
      MicroPrintf("\n\rHardware Accelerator - TinyML Pre-processing...");
   
      //Trigger HW accel MM2S DMA
      send_dma(DMASG_HW_ACCEL_MM2S_CHANNEL, DMASG_HW_ACCEL_MM2S_PORT, buf(draw_buffer), (FRAME_WIDTH*FRAME_HEIGHT)*4, 0, 0, 0);
   
      //Trigger HW accel S2MM DMA
      recv_dma(DMASG_HW_ACCEL_S2MM_CHANNEL, DMASG_HW_ACCEL_S2MM_PORT, TINYML_INPUT_START_ADDR, YOLO_PICO_INPUT_BYTES, 0, 0, 0);
   
      //Indicate start of S2MM DMA to HW accel building block via APB3 slave
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG6_OFFSET, 0x00000001);
      EXAMPLE_APB3_REGW(EXAMPLE_APB3_SLV, EXAMPLE_APB3_SLV_REG6_OFFSET, 0x00000000);


      //Wait for DMA transfer completion
      while(dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_MM2S_CHANNEL) || dmasg_busy(DMASG_BASE, DMASG_HW_ACCEL_S2MM_CHANNEL));
      flush_data_cache();
      MicroPrintf("Done\n\r");

      /*******************************************************TINYML INFERENCE**********************************************************/

      MicroPrintf("TinyML Inference...");

      //Copy test image to tflite model input.
      for (unsigned int i = 0; i < YOLO_PICO_INPUT_BYTES; ++i)
         model_input->data.int8[i] = tinyml_input_array[i] - 128; //Input normalization: From range [0,255] to [-128,127]

      //Perform inference
      timerCmp0 = clint_getTime(BSP_CLINT);
      invoke_status = interpreter->Invoke();
      timerCmp1 = clint_getTime(BSP_CLINT);

      if (invoke_status != kTfLiteOk) {
        MicroPrintf("Invoke failed on data\n\r");
      }
      MicroPrintf("Done\n\n\r");

      //Yolo layer
      MicroPrintf("Pass data to Yolo layer...");

      layer* yolo_layers = (layer*)calloc(total_output_layers, sizeof(layer));
      for (int i = 0; i < total_output_layers; ++i) {
         yolo_layers[i].channels = interpreter->output(i)->dims->data[0];
         yolo_layers[i].height = interpreter->output(i)->dims->data[1];
         yolo_layers[i].width = interpreter->output(i)->dims->data[2];
         yolo_layers[i].classes = CLASSES;
         yolo_layers[i].boxes_per_scale = interpreter->output(i)->dims->data[3] / (5 + yolo_layers[i].classes);
         yolo_layers[i].total_anchors = TOTAL_ANCHORS;
         yolo_layers[i].scale = SCALE;
         yolo_layers[i].anchors = anchors[i];

         int total = (
            interpreter->output(i)->dims->data[0] * interpreter->output(i)->dims->data[1] * interpreter->output(i)->dims->data[2] * interpreter->output(i)->dims->data[3]
         );

         yolo_layers[i].outputs = (float*)calloc(total, sizeof(float));
         TfLiteAffineQuantization params = *(static_cast<TfLiteAffineQuantization *>(interpreter->output(i)->quantization.params));

         for (int j = 0; j < total; ++j)
            yolo_layers[i].outputs[j] = ((float)interpreter->output(i)->data.int8[j] - params.zero_point->data[0]) * params.scale->data[0];
      }

      MicroPrintf("Done\n\r");

      int total_boxes = 0;

      MicroPrintf("Yolo layer inference...");
      timerCmp2 = clint_getTime(BSP_CLINT);
      box* boxes = perform_inference(yolo_layers, total_output_layers, &total_boxes, model_input->dims->data[1], model_input->dims->data[2], OBJECTNESS_THRESHOLD, IOU_THRESHOLD);
      timerCmp3 = clint_getTime(BSP_CLINT);
      MicroPrintf("Done\n\n\r");

      //Pass bounding boxes info to annotator
      draw_boxes(boxes,total_boxes);
   
      timerDiff_0_1 = timerCmp1 - timerCmp0;
      u32 *v = (u32 *)&timerDiff_0_1;
      MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]); //Timestamp
      //processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ
      MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
      MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
      ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
      MicroPrintf("inference time (front layers): %ums\n\r", ms);
   
      timerDiff_2_3 = timerCmp3 - timerCmp2;
      u32 *v2 = (u32 *)&timerDiff_2_3;
      MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v2[1], v2[0]); //Timestamp
      //processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ
      MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
      MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
      ms = timerDiff_2_3/(SYSTEM_CLINT_HZ/1000);
      MicroPrintf("inference time (Yolo layer): %ums\n\r", ms);

      //Clear all the memory allocation content
      for (int i = 0; i < total_output_layers; ++i) {
        free(yolo_layers[i].outputs);
      }
      free(yolo_layers);
      free(boxes);
      
      //Switch draw buffer to latest complete frame
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