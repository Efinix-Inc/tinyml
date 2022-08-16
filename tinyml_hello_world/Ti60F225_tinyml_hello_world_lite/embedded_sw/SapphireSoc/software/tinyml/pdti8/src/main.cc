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
#include <math.h>
#include "clint.h"
#include "print.h"

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

//Model data
#include "model/mobilenetv1_person_detect_model_data.h"
#include "model/model_settings.h"

//Static test image data
#include "model/person_image_data.h"
#include "model/no_person_image_data.h"
#include "model/person2_image_data.h"
#include "model/no_person2_image_data.h"

//TinyML accelerator flags
#include "accel.h"
int enable_hwaccel=1; //0: Run on full software , 1: Run on Hardware
int parallel_core=4; // Adjust number of cores matching with hardware
int const_log2_parallel = pow_of_2(parallel_core); //Parallel core power computation



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
const char *opname;
class FullProfiler : public tflite::MicroProfiler {
public:
   virtual u64 BeginEvent(const char *a) {
      opname = a;
      return tflite::GetCurrentTimeTicks();
   }
   virtual void EndEvent(u64 st) {
      auto ed = tflite::GetCurrentTimeTicks();
      u32 tn = ed - st;
      u32 diff = tn / (tflite::ticks_per_second()/1000);
      MicroPrintf("%s:\t%u\n\r", opname, diff);
   }
   static void operator delete(void *) {
   }
};

//Workaround for undefined trap function
extern "C" {
void trap() {bsp_putString("ERROR: Dummy trap function\n\r");}
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
   
   FullProfiler prof;
   static tflite::MicroInterpreter static_interpreter(
      model, micro_mutable_op_resolver, tensor_arena, kTensorArenaSize,
      error_reporter, nullptr); //Without profiler
      //error_reporter, &prof); //With profiler
   interpreter = &static_interpreter;
   
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

void main() {

   MicroPrintf("\t--Hello Efinix TinyML--\n\r");
   
   /***********************************************************TFLITE-MICRO TINYML*******************************************************/

   TfLiteStatus invoke_status;
   int8_t person_score;
   int8_t person_score_percent;
   int8_t no_person_score;

   MicroPrintf("TinyML Setup...");
   tinyml_init();
   MicroPrintf("Done\n\r");

   //For timestamp
   uint64_t timerCmp0, timerCmp1, timerDiff_0_1;
   u32 ms;
   u32 *v;
   
   /*********************************************************STATIC IMAGE INFERENCE 1*****************************************************/
   
   //Person image data from tflite micro example
   MicroPrintf("\n\rPerson Detection Inference 1 (Person)...");
   
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
   MicroPrintf("Done\n\r");
   
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d\n\r", person_score);
   MicroPrintf("No Person Score : %d\n\r", no_person_score);
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
   MicroPrintf("\n\rPerson Detection Inference 2 (No Person)...");
   
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
   MicroPrintf("Done\n\r");
   
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d\n\r", person_score);
   MicroPrintf("No Person Score : %d\n\r", no_person_score);
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
   MicroPrintf("\n\rPerson Detection Inference 3 (Person)...");
   
   //Copy test image to tflite model input. Input size to person detection model 96*96=9216
   for (unsigned int i = 0; i < person2_img_data_size; ++i)
      model_input->data.int8[i] = person2_img_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   MicroPrintf("Done\n\r");
   
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d\n\r", person_score);
   MicroPrintf("No Person Score : %d\n\r", no_person_score);
   MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", person_score_percent);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   
   /*********************************************************STATIC IMAGE INFERENCE 4*****************************************************/
   
   //No person image data extracted from online image
   MicroPrintf("\n\rPerson Detection Inference 4 (No Person)...");
   
   //Copy test image to tflite model input. Input size to person detection model 96*96=9216
   for (unsigned int i = 0; i < no_person2_img_data_size; ++i)
      model_input->data.int8[i] = no_person2_img_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   MicroPrintf("Done\n\r");
   
   //Retrieve inference output
   no_person_score = interpreter->output(0)->data.int8[kNotAPersonIndex];
   person_score    = interpreter->output(0)->data.int8[kPersonIndex];
   
   person_score_percent = ((person_score + 128) * 100) >> 8;
   
   MicroPrintf("Person Score    : %d\n\r", person_score);
   MicroPrintf("No Person Score : %d\n\r", no_person_score);
   MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", person_score_percent);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   
 }
