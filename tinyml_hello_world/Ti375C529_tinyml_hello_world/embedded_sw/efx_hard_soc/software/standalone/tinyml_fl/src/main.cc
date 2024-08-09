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

//Model data
#include "model/mediapipe_face_landmark_model_data.h"

//Static test image data
#include "model/input_geoffrey_hinton_192x192x3.h"

#include "model/face_landmark_detection.h"
#include "platform/tinyml/profiler.h"


#define NET_HEIGHT 192
#define NET_WIDTH 192
#define COORDINATES 3

namespace {
tflite::ErrorReporter *error_reporter = nullptr;
const tflite::Model *model = nullptr;
tflite::MicroInterpreter *interpreter = nullptr;
TfLiteTensor *model_input = nullptr;

//Create an area of memory to use for input, output, and other TensorFlow
//arrays. You'll need to adjust this by combiling, running, and looking
//for errors.
constexpr int kTensorArenaSize = 10000 * 1024;
uint8_t tensor_arena[kTensorArenaSize];
int total_output_layers = 0;
}

void tinyml_init() {
	//Set up logging
	static tflite::MicroErrorReporter micro_error_reporter;
	error_reporter = &micro_error_reporter;

	//Map the model into a usable data structure
	model = tflite::GetModel(mediapipe_face_landmark_model_data);

	if (model->version() != TFLITE_SCHEMA_VERSION) {
		MicroPrintf("Model version does not match Schema\n\r");
		while (1)
			;
	}

	//AllOpsResolver may be used for generalization
	static tflite::AllOpsResolver resolver;
	tflite::MicroOpResolver *op_resolver = nullptr;
	op_resolver = &resolver;

	//Build an interpreter to run the model

	static FullProfiler prof;
	static tflite::MicroInterpreter static_interpreter(model, *op_resolver,
			tensor_arena, kTensorArenaSize,
			error_reporter, nullptr); //Without profiler
//			error_reporter, &prof); //With profiler
	interpreter = &static_interpreter;
	prof.setInterpreter(interpreter);
	prof.setDump(false);

	//Allocate memory from the tensor_arena for the model's tensors
	TfLiteStatus allocate_status = interpreter->AllocateTensors();
	if (allocate_status != kTfLiteOk) {
		MicroPrintf("AllocateTensors() failed\n\r");
		while (1);
	}

	//Assign model input buffer (tensor) to pointer
	model_input = interpreter->input(0);

	//Print loaded model input and output shape
	total_output_layers = interpreter->outputs_size();
	MicroPrintf("\n\rTotal output layers: %d\n\r", total_output_layers);
	MicroPrintf("Input shape: %d %d %d %d %d, type: %d\n\r",
			model_input->dims->size, model_input->dims->data[0],
			model_input->dims->data[1], model_input->dims->data[2],
			model_input->dims->data[3], model_input->type);

	for (int i = 0; i < total_output_layers; ++i)
		MicroPrintf("Output shape %d: %d %d %d %d %d, type: %d\n\r", i,
				interpreter->output(i)->dims->size,
				interpreter->output(i)->dims->data[0],
				interpreter->output(i)->dims->data[1],
				interpreter->output(i)->dims->data[2],
				interpreter->output(i)->dims->data[3],
				interpreter->output(i)->type);
}

void landmark_output(int enable_printing) {
	for (int i = 0; i < total_output_layers; ++i) {
		int total = (interpreter->output(i)->dims->data[0]
				* interpreter->output(i)->dims->data[1]
				* interpreter->output(i)->dims->data[2]
				* interpreter->output(i)->dims->data[3]);

		TfLiteAffineQuantization params =
				*(static_cast<TfLiteAffineQuantization*>(interpreter->output(i)->quantization.params));


		if (i == 0) {
			float *face_landmarks = (float*) calloc(total, sizeof(float));
			for (int j = 0; j < total; ++j)
				face_landmarks[j] =
						((float) interpreter->output(i)->data.int8[j]
								- params.zero_point->data[0])
								* params.scale->data[0]
								/ model_input->dims->data[(
										j % COORDINATES != 1 ? 1 : 2)];
			if(enable_printing == 1){
				int counter =0;
				MicroPrintf("[OUTPUT_0] :");
				for (int j = 0; j < total; ++j) {

					print_float(face_landmarks[j]);
//					MicroPrintf("[END]\n\r");
					if (j < total - 1) {
						if (j % COORDINATES != 2) {
							MicroPrintf(", ");
						} else {
							MicroPrintf(",\n\r");
						}
					} else {
						MicroPrintf(",\n\r");
					}
			}
				MicroPrintf(";\n\r");
			}
		} else if (i == 1) {
			float *face_flags = (float*) calloc(total, sizeof(float));
			for (int j = 0; j < total; ++j)
				face_flags[j] = ((float) interpreter->output(i)->data.int8[j]
						- params.zero_point->data[0]) * params.scale->data[0];
			activate_logistic(face_flags, total);

			if(enable_printing == 1) {
				MicroPrintf("[OUTPUT_1] :");
				for (int j = 0; j < total; ++j) {
					print_float(face_flags[j]);
					MicroPrintf(";\n\r");
				}
			}
		}

	}

}

extern "C" void main() {

	MicroPrintf("\t--Hello Efinix TinyML--\n\r");

	MicroPrintf("TinyML Setup...");
	tinyml_init();
	MicroPrintf("Done\n\n\r");

	TfLiteStatus invoke_status;
	uint64_t timerCmp0, timerCmp1, timerDiff_0_1;
	uint64_t timerCmp2, timerCmp3, timerDiff_2_3;
	u32 ms;

	//Interrupt Initialization
	IntcInitialize();
	
	/*************************************************************RUN INFERENCE*************************************************************/

	//Test image data
	MicroPrintf("Face Landmark Detection Inference...\n\r");

	//Copy test image to tflite model input.
	for (unsigned int i = 0; i < input_geoffrey_hinton_192x192x3_len; ++i)
		model_input->data.int8[i] = input_geoffrey_hinton_192x192x3[i]; //Pre-normalized to [-128,127]

	//Perform inference
	timerCmp0 = clint_getTime(BSP_CLINT);
	invoke_status = interpreter->Invoke();
	timerCmp1 = clint_getTime(BSP_CLINT);

	if (invoke_status != kTfLiteOk) {
		MicroPrintf("Invoke failed on data\n\r");
	}
	MicroPrintf("Done\n\r");

	//Output layer
	MicroPrintf("Pass data to output layer...\n\r");
	timerCmp2 = clint_getTime(BSP_CLINT);
	landmark_output(0);
	timerCmp3 = clint_getTime(BSP_CLINT);
	landmark_output(1);
	MicroPrintf("Done\n\r");

	timerDiff_0_1 = timerCmp1 - timerCmp0;
	u32 *v = (u32*) &timerDiff_0_1;
	MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v[1], v[0]); //Timestamp
	//processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ
	MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
	MicroPrintf(
			"NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
	ms = timerDiff_0_1 / (SYSTEM_CLINT_HZ / 1000);
	MicroPrintf("Inference time (front layers): %ums\n\r", ms);

	timerDiff_2_3 = timerCmp3 - timerCmp2;
	u32 *v2 = (u32*) &timerDiff_2_3;
	MicroPrintf("Inference clock cycle (hex): %x, %x\n\r", v2[1], v2[0]); //Timestamp
	//processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ
	MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);
	MicroPrintf(
			"NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");
	ms = timerDiff_2_3 / (SYSTEM_CLINT_HZ / 1000);
	MicroPrintf("Inference time (output layer): %ums\n\r", ms);
	MicroPrintf("Hello world complete\n\r");
	ops_unload();
}
