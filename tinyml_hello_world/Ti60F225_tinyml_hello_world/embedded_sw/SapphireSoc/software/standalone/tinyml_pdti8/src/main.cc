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
#include <math.h>
#include "clint.h"
#include "print.h"
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

//Static test image data
#include "model/person_image_data.h"
#include "model/no_person_image_data.h"
#include "model/no_people1_data.h"
#include "model/no_people2_data.h"
#include "model/people1_data.h"
#include "model/people2_data.h"

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
   int total_output_layers = 0;
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
   total_output_layers = interpreter->outputs_size();
   MicroPrintf("\n\rTotal output layers: %d\n\r", total_output_layers);
   MicroPrintf(
      "Input shape: %d %d %d %d %d, type: %d\n\r", model_input->dims->size, model_input->dims->data[0], model_input->dims->data[1], model_input->dims->data[2], model_input->dims->data[3], model_input->type
   );
   
   for (int i = 0; i < total_output_layers; ++i)
      MicroPrintf(
         "Output shape %d: %d %d %d, type: %d\n\r", i, interpreter->output(i)->dims->size, interpreter->output(i)->dims->data[0], interpreter->output(i)->dims->data[1], interpreter->output(i)->type
      );
}

extern "C" void main() {
	
   MicroPrintf("\t--Hello Efinix TinyML--\n\r");
   
   /***********************************************************TFLITE-MICRO TINYML*******************************************************/

   TfLiteStatus invoke_status;
   int8_t person_score;
   int8_t person_score_percent;
   int8_t no_person_score;

   MicroPrintf("TinyML Setup...");
   u32 hartId = csr_read(mhartid);
   tinyml_init();
   init_accel(hartId);
   print_accel(hartId);
   MicroPrintf("Done\n\r");

   //For timestamp
   uint64_t timerCmp0, timerCmp1, timerDiff_0_1;
   u32 ms;
   u32 *v;
   
	//Interrupt Initialization
	IntcInitialize();

   /*********************************************************STATIC IMAGE INFERENCE 1*****************************************************/
   
   //Person image data from tflite micro example
   MicroPrintf("\n\r[OUTPUT_0]Person Detection Inference 1 (Person)...\n\r");
   
   //Copy test image to tflite model input. Input size to person detection model 96*96=9216
   for (unsigned int i = 0; i < g_person_data_size; ++i)
      model_input->data.int8[i] = g_person_data[i]; //Input image data (from tflite micro example) is pre-normalized

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d,\n\r ", person_score);
   MicroPrintf("No Person Score : %d;\n\r", no_person_score);
   MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", person_score_percent);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   
   
   /*********************************************************STATIC IMAGE INFERENCE 2*****************************************************/
   
   //No person image data from tflite micro example
   MicroPrintf("\n\r[OUTPUT_1]Person Detection Inference 2 (No Person)...\n\r");
   
   //Copy test image to tflite model input. Input size to person detection model 96*96=9216
   for (unsigned int i = 0; i < g_no_person_data_size; ++i)
      model_input->data.int8[i] = g_no_person_data[i]; //Input image data (from tflite micro example) is pre-normalized

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d,\n\r", person_score);
   MicroPrintf("No Person Score : %d;\n\r", no_person_score);
   MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", person_score_percent);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   
   
   /*********************************************************STATIC IMAGE INFERENCE 3*****************************************************/
   
   //Person image data extracted from online image
   MicroPrintf("\n\r[OUTPUT_2]Person Detection Inference 3 (Person)...\n\r");
   
   //Copy test image to tflite model input. Input size to person detection model 96*96=9216
   for (unsigned int i = 0; i < people1_data_size; ++i)
      model_input->data.int8[i] = people1_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d,\n\r ", person_score);
   MicroPrintf("No Person Score : %d;\n\r", no_person_score);
   MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", person_score_percent);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   
   /*********************************************************STATIC IMAGE INFERENCE 4*****************************************************/
   
   //Person image data extracted from online image
   MicroPrintf("\n\r[OUTPUT_3]Person Detection Inference 4 (Person)...\n\r");
   
   //Copy test image to tflite model input. Input size to person detection model 96*96=9216
   for (unsigned int i = 0; i < people2_data_size; ++i)
      model_input->data.int8[i] = people2_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d,\n\r ", person_score);
   MicroPrintf("No Person Score : %d;\n\r", no_person_score);
   MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", person_score_percent);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   
   
   /*********************************************************STATIC IMAGE INFERENCE 5*****************************************************/
   
   //No person image data extracted from online image
   MicroPrintf("\n\r[OUTPUT_4]Person Detection Inference 5 (No Person)...\n\r");
   
   //Copy test image to tflite model input. Input size to person detection model 96*96=9216
   for (unsigned int i = 0; i < no_people1_data_size; ++i)
      model_input->data.int8[i] = no_people1_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d,\n\r ", person_score);
   MicroPrintf("No Person Score : %d;\n\r", no_person_score);
   MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", person_score_percent);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   
   
   /*********************************************************STATIC IMAGE INFERENCE 6*****************************************************/
   
   //No person image data extracted from online image
   MicroPrintf("\n\r[OUTPUT_5]Person Detection Inference 6 (No Person)...\n\r");
   
   //Copy test image to tflite model input. Input size to person detection model 96*96=9216
   for (unsigned int i = 0; i < no_people2_data_size; ++i)
      model_input->data.int8[i] = no_people2_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d,\n\r ", person_score);
   MicroPrintf("No Person Score : %d;\n\r", no_person_score);
   MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", person_score_percent);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   MicroPrintf("Hello world complete\n\r");
   ops_unload();
 }
