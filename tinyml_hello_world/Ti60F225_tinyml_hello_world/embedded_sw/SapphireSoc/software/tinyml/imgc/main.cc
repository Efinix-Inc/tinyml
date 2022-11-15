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
#include "model/resnet_image_classify_model_data.h"
#include "model/model_settings.h"

//Static test image data
#include "model/quant_airplane.h"
#include "model/quant_bird.h"
#include "model/quant_car.h"
#include "model/quant_cat.h"
#include "model/quant_deer.h"
#include "model/quant_dog.h"
#include "model/quant_frog.h"
#include "model/quant_horse.h"
#include "model/quant_ship.h"
#include "model/quant_truck.h"



namespace {
   tflite::ErrorReporter* error_reporter = nullptr;
   const tflite::Model* model = nullptr;
   tflite::MicroInterpreter* interpreter = nullptr;
   TfLiteTensor* model_input = nullptr;
   
   //Create an area of memory to use for input, output, and other TensorFlow
   //arrays. You'll need to adjust this by combiling, running, and looking
   //for errors.
   constexpr int kTensorArenaSize = 53 * 1024;
   uint8_t tensor_arena[kTensorArenaSize];
}


void tinyml_init() {
   //Set up logging
   static tflite::MicroErrorReporter micro_error_reporter;
   error_reporter = &micro_error_reporter;
   
   //Map the model into a usable data structure
   model = tflite::GetModel(resnet_image_classify_model_data);
   
   if (model->version() != TFLITE_SCHEMA_VERSION) {
      MicroPrintf("Model version does not match Schema\n\r");
      while(1);
   }
   
   //User may pull in only needed operations via MicroMutableOpResolver (which should match NN layers)
   static tflite::MicroMutableOpResolver<6> micro_mutable_op_resolver;
   
   micro_mutable_op_resolver.AddAveragePool2D();
   micro_mutable_op_resolver.AddConv2D();
   micro_mutable_op_resolver.AddFullyConnected();
   micro_mutable_op_resolver.AddAdd();
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
      "Input shape: %d %d %d %d %d, type: %d\n\r", model_input->dims->size, model_input->dims->data[0], model_input->dims->data[1], model_input->dims->data[2], model_input->dims->data[3], model_input->type
   );
   
   for (int i = 0; i < (interpreter->outputs_size()); ++i)
      MicroPrintf(
         "Output shape %d: %d %d %d, type: %d\n\r", i, interpreter->output(i)->dims->size, interpreter->output(i)->dims->data[0], interpreter->output(i)->dims->data[1], interpreter->output(i)->type
      );
}

extern "C" void main() {

   MicroPrintf("\t--Hello Efinix TinyML--\n\r");
   
   /***********************************************************TFLITE-MICRO TINYML*******************************************************/

   TfLiteStatus invoke_status;

   MicroPrintf("TinyML Setup...");
   tinyml_init();
   MicroPrintf("Done\n\r");

   //For timestamp
   uint64_t timerCmp0, timerCmp1, timerDiff_0_1;
   u32 ms;
   u32 *v;
   
   /*********************************************************STATIC IMAGE INFERENCE 1*****************************************************/
	//Interrupt Initialization
	IntcInitialize();
	//Tinyml_Initial();   
   //Airplane image data
   MicroPrintf("\n\rImage Classification Inference 1 (Airplane)...");

   //Copy test image to tflite model input.
   for (unsigned int i = 0; i < quant_airplane_dat_len; ++i)
      model_input->data.int8[i] = quant_airplane_dat[i];

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   MicroPrintf("Done\n\r");

   //Retrieve inference output
   for (int i = 0; i < kCategoryCount; ++i)
      MicroPrintf("%s score: %d\n\r", kCategoryLabels[i], interpreter->output(0)->data.int8[i]);

   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   
   
   /*********************************************************STATIC IMAGE INFERENCE 2*****************************************************/
   
   //Car image data
   MicroPrintf("\n\rImage Classification Inference 2 (Car)...");
   timerCmp0 = clint_getTime(BSP_CLINT);
   //Copy test image to tflite model input.
   for (unsigned int i = 0; i < quant_car_dat_len; ++i)
      model_input->data.int8[i] = quant_car_dat[i];
//   timerCmp1 = clint_getTime(BSP_CLINT);

   //Perform inference
//   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   MicroPrintf("Done\n\r");
   
   //Retrieve inference output
   for (int i = 0; i < kCategoryCount; ++i)
      MicroPrintf("%s score: %d\n\r", kCategoryLabels[i], interpreter->output(0)->data.int8[i]);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
   
   
   /*********************************************************STATIC IMAGE INFERENCE 3*****************************************************/
   
   //Bird image data
   MicroPrintf("\n\rImage Classification Inference 3 (Bird)...");
   
   //Copy test image to tflite model input.
   for (unsigned int i = 0; i < quant_bird_dat_len; ++i)
      model_input->data.int8[i] = quant_bird_dat[i];

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   MicroPrintf("Done\n\r");
   
   //Retrieve inference output
   for (int i = 0; i < kCategoryCount; ++i)
      MicroPrintf("%s score: %d\n\r", kCategoryLabels[i], interpreter->output(0)->data.int8[i]);
   
   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);

   /*********************************************************STATIC IMAGE INFERENCE 4*****************************************************/

    //Bird image data
    MicroPrintf("\n\rImage Classification Inference 4 (Truck)...");

    //Copy test image to tflite model input.
    for (unsigned int i = 0; i < quant_truck_dat_len; ++i)
       model_input->data.int8[i] = quant_truck_dat[i];

    //Perform inference
    timerCmp0 = clint_getTime(BSP_CLINT);
    invoke_status = interpreter->Invoke();
    timerCmp1 = clint_getTime(BSP_CLINT);

    if (invoke_status != kTfLiteOk) {
      MicroPrintf("Invoke failed on data\n\r");
    }
    MicroPrintf("Done\n\r");

    //Retrieve inference output
    for (int i = 0; i < kCategoryCount; ++i)
       MicroPrintf("%s score: %d\n\r", kCategoryLabels[i], interpreter->output(0)->data.int8[i]);

    timerDiff_0_1 = timerCmp1 - timerCmp0;
    v = (u32 *)&timerDiff_0_1;
    MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
    MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
    MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
    ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
    MicroPrintf("Inference time: %ums\n\r", ms);


    /*********************************************************STATIC IMAGE INFERENCE 5*****************************************************/

     //Bird image data
     MicroPrintf("\n\rImage Classification Inference 5 (Deer)...");

     //Copy test image to tflite model input.
     for (unsigned int i = 0; i < quant_deer_dat_len; ++i)
        model_input->data.int8[i] = quant_deer_dat[i];

     //Perform inference
     timerCmp0 = clint_getTime(BSP_CLINT);
     invoke_status = interpreter->Invoke();
     timerCmp1 = clint_getTime(BSP_CLINT);

     if (invoke_status != kTfLiteOk) {
       MicroPrintf("Invoke failed on data\n\r");
     }
     MicroPrintf("Done\n\r");

     //Retrieve inference output
     for (int i = 0; i < kCategoryCount; ++i)
        MicroPrintf("%s score: %d\n\r", kCategoryLabels[i], interpreter->output(0)->data.int8[i]);

     timerDiff_0_1 = timerCmp1 - timerCmp0;
     v = (u32 *)&timerDiff_0_1;
     MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
     MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
     MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
     ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
     MicroPrintf("Inference time: %ums\n\r", ms);

   //Parameter Calculate
   ops_unload();
 }
