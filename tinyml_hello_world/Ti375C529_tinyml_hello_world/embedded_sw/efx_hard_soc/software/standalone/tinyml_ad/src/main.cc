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
//#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "tensorflow/lite/micro/testing/micro_test.h"
#include "tensorflow/lite/schema/schema_generated.h"
#include "tensorflow/lite/c/common.h"
#include "tensorflow/lite/micro/debug_log.h"
#include "tensorflow/lite/micro/micro_time.h"
#include "platform/tinyml/profiler.h"

//Model data
#include "model/deep_autoencoder_anomaly_detection_model_data.h"
#include "model/quantization_helper.h"
//Static test image data
#include "model/anomaly_id_01_00000250_s1.h"
#include "model/anomaly_id_01_00000250_s2.h"
#include "model/normal_id_01_00000200_s1.h"
#include "model/normal_id_01_00000200_s2.h"


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
   model = tflite::GetModel(deep_autoencoder_anomaly_detection_model_data);
   
   if (model->version() != TFLITE_SCHEMA_VERSION) {
      MicroPrintf("Model version does not match Schema\n\r");
      while(1);
   }
   
   //User may pull in only needed operations via MicroMutableOpResolver (which should match NN layers)
//   static tflite::MicroMutableOpResolver<5> micro_mutable_op_resolver;
   
//   micro_mutable_op_resolver.AddAveragePool2D();
//   micro_mutable_op_resolver.AddConv2D();
//   micro_mutable_op_resolver.AddDepthwiseConv2D();
//   micro_mutable_op_resolver.AddReshape();
//   micro_mutable_op_resolver.AddSoftmax();
   
   ////AllOpsResolver may be used for generalization
   static tflite::AllOpsResolver resolver;
   tflite::MicroOpResolver* op_resolver = nullptr;
   op_resolver = &resolver;
   
   //Build an interpreter to run the model
   
   FullProfiler prof;
   static tflite::MicroInterpreter static_interpreter(
      model, resolver, tensor_arena, kTensorArenaSize,
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

void main() {
   
   MicroPrintf("\t--Hello Efinix TinyML--\n\r");
   
   /***********************************************************TFLITE-MICRO TINYML*******************************************************/

   TfLiteStatus invoke_status;

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
   float float_input[anomaly_id_01_00000250_s1_len];
   float diffsum;
   TfLiteAffineQuantization params = *(static_cast<TfLiteAffineQuantization *>(interpreter->output(0)->quantization.params));
	//Interrupt Initialization
	IntcInitialize();

   /*********************************************************STATIC IMAGE INFERENCE 1*****************************************************/
   
   MicroPrintf("\n\rAnamoly Detection Inference 1 ...");
   //Copy test image to input
   for (unsigned int i = 0; i < anomaly_id_01_00000250_s1_len; i++){
	   float_input[i]=DequantizeInt8ToFloat(anomaly_id_01_00000250_s1[i], model_input->params.scale, model_input->params.zero_point);
	   model_input->data.int8[i] = anomaly_id_01_00000250_s1[i];
   }

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   MicroPrintf("Done\n\r");
   
   //Compute output
   diffsum = 0;
   for (unsigned int i = 0; i < anomaly_id_01_00000250_s1_len; i++){
	   float converted = DequantizeInt8ToFloat(interpreter->output(0)->data.int8[i], params.scale->data[0], params.zero_point->data[0]);
	   float diff = converted - float_input[i];
	   diffsum += (diff * diff);
   }
   diffsum /= anomaly_id_01_00000250_s1_len;
   MicroPrintf("[OUTPUT_0]Anamoly Detection Slice 1 Score :");
   print_float(diffsum);
   MicroPrintf(";\n\r");

   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);
      /*********************************************************STATIC INFERENCE 2*****************************************************/
   
   MicroPrintf("\n\rAnamoly Detection Inference 2 ...");
   //Copy test image to input
   for (unsigned int i = 0; i < anomaly_id_01_00000250_s2_len; i++){
	   float_input[i]=DequantizeInt8ToFloat(anomaly_id_01_00000250_s2[i], model_input->params.scale, model_input->params.zero_point);
	   model_input->data.int8[i] = anomaly_id_01_00000250_s2[i];
   }

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   MicroPrintf("Done\n\r");
   
   //Compute output
   diffsum = 0;
   for (unsigned int i = 0; i < anomaly_id_01_00000250_s2_len; i++){
	   float converted = DequantizeInt8ToFloat(interpreter->output(0)->data.int8[i], params.scale->data[0], params.zero_point->data[0]);
	   float diff = converted - float_input[i];
	   diffsum += (diff * diff);
   }
   diffsum /= anomaly_id_01_00000250_s2_len;
   MicroPrintf("[OUTPUT_1]Anamoly Detection Slice 2 Score :");
   print_float(diffsum);
   MicroPrintf(";\n\r");

   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);

      /*********************************************************STATIC INFERENCE 3*****************************************************/
   
   MicroPrintf("\n\rNormal Detection Inference 1 ...");
   //Copy test image to input
   for (unsigned int i = 0; i < normal_id_01_00000200_s1_len; i++){
	   float_input[i]=DequantizeInt8ToFloat(normal_id_01_00000200_s1[i], model_input->params.scale, model_input->params.zero_point);
	   model_input->data.int8[i] = normal_id_01_00000200_s1[i];
   }

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   MicroPrintf("Done\n\r");
   
   //Compute output
   diffsum = 0;
   for (unsigned int i = 0; i < normal_id_01_00000200_s1_len; i++){
	   float converted = DequantizeInt8ToFloat(interpreter->output(0)->data.int8[i], params.scale->data[0], params.zero_point->data[0]);
	   float diff = converted - float_input[i];
	   diffsum += (diff * diff);
   }
   diffsum /= normal_id_01_00000200_s1_len;
   MicroPrintf("[OUTPUT_2]Normal_Detection_Slice_1_Score :");
   print_float(diffsum);
   MicroPrintf(";\n\r");

   timerDiff_0_1 = timerCmp1 - timerCmp0;
   v = (u32 *)&timerDiff_0_1;
   MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]);
   MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
   MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
   ms = timerDiff_0_1/(SYSTEM_CLINT_HZ/1000);
   MicroPrintf("Inference time: %ums\n\r", ms);

      /*********************************************************STATIC INFERENCE 4*****************************************************/
   
   MicroPrintf("\n\rNormal Detection Inference 2 ...");
   //Copy test image to input
   for (unsigned int i = 0; i < normal_id_01_00000200_s2_len; i++){
	   float_input[i]=DequantizeInt8ToFloat(normal_id_01_00000200_s2[i], model_input->params.scale, model_input->params.zero_point);
	   model_input->data.int8[i] = normal_id_01_00000200_s2[i];
   }

   //Perform inference
   timerCmp0 = clint_getTime(BSP_CLINT);
   invoke_status = interpreter->Invoke();
   timerCmp1 = clint_getTime(BSP_CLINT);

   if (invoke_status != kTfLiteOk) {
     MicroPrintf("Invoke failed on data\n\r");
   }
   MicroPrintf("Done\n\r");
   
   //Compute output
   diffsum = 0;
   for (unsigned int i = 0; i < normal_id_01_00000200_s2_len; i++){
	   float converted = DequantizeInt8ToFloat(interpreter->output(0)->data.int8[i], params.scale->data[0], params.zero_point->data[0]);
	   float diff = converted - float_input[i];
	   diffsum += (diff * diff);
   }
   diffsum /= normal_id_01_00000200_s2_len;
   MicroPrintf("[OUTPUT_3]Normal Detection Slice 2 Score :");
   print_float(diffsum);
   MicroPrintf(";\n\r");

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
