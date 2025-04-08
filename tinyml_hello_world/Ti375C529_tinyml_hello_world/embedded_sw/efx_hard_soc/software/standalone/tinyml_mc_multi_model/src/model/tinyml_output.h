/*
 * tinyml_output.h
 *
 *  Created on: Oct 17, 2024
 *      Author: mfaiz
 */

#ifndef SRC_MODEL_TINYML_OUTPUT_H_
#define SRC_MODEL_TINYML_OUTPUT_H_

#include "bsp.h"
#include "tensorflow/lite/c/common.h"
#include "tensorflow/lite/micro/micro_interpreter.h"

#include "ypd/yolo.h"
#include "fl/face_landmark_detection.h"
#include "pdti8/model_settings.h"
#include "imgc/model_settings.h"

#include "model/arena.h"
#include "model/tinyml_init.h"
#include "model/model_setup.h"


/**********************************************************************STRUCTURE TO HOLD RESULT *************************************************************/


// Base result structure for common properties
struct BaseResult {
	TfLiteStatus status;
	uint64_t time_start;
	uint64_t time_end;
	int8_t done;
};



struct yolo_result : BaseResult {
	uint64_t yolo_layer_time_start;
	uint64_t yolo_layer_time_end;
	box* boxes;
	int total_boxes;
	layer* yolo_layers;
};

struct fl_result : BaseResult {
	uint64_t fl_layer_time_start;
	uint64_t fl_layer_time_end;
	float face_landmarks[1404];
	float face_flags[1404];
	int total[2];
};

struct pdt8_result : BaseResult {
	int8_t person_score;
	int8_t person_score_percent;
	int8_t no_person_score;
	int person;
};

struct imgc_result : BaseResult {
	int img_class;
	int8_t output[kCategoryCountImgc];
};

/**********************************************************************INVOKE *************************************************************/

// Generic invoke function template
template<typename T>
void invoke_model(volatile TfliteMicroModel* model, volatile T* result) {
	result->done = 0;
	result->time_start = clint_getTime(BSP_CLINT);
	result->status = model->interpreter->Invoke();
	result->time_end = clint_getTime(BSP_CLINT);
	result->done = 1;
}


/**********************************************************************LAST LAYER *************************************************************/



//YOLO///
void run_yolo_layer(volatile TfliteMicroModel* model, volatile yolo_result * result, float anchors[2][YOLO_TOTAL_ANCHORS * 2]) {
	asm("fence r,r");
	u32 hartIds = csr_read(mhartid);
	result->yolo_layers = (layer*)arena_calloc(arena[hartIds],model->total_output_layers, sizeof(layer));
	if(result->yolo_layers == NULL){
		MicroPrintf("Failed Yolo layer allocation on Core %d\n\r", hartIds);
	}

	for (int i = 0; i < model->total_output_layers; ++i) {
		result->yolo_layers[i].channels = model->interpreter->output(i)->dims->data[0];
		result->yolo_layers[i].height = model->interpreter->output(i)->dims->data[1];
		result->yolo_layers[i].width = model->interpreter->output(i)->dims->data[2];
		result->yolo_layers[i].classes = YOLO_CLASSES;
		result->yolo_layers[i].boxes_per_scale = model->interpreter->output(i)->dims->data[3] / (5 + result->yolo_layers[i].classes);
		result->yolo_layers[i].total_anchors = YOLO_TOTAL_ANCHORS;
		result->yolo_layers[i].scale = YOLO_SCALE;
		result->yolo_layers[i].anchors = anchors[i];

		int total = (
				model->interpreter->output(i)->dims->data[0] * model->interpreter->output(i)->dims->data[1] * model->interpreter->output(i)->dims->data[2] * model->interpreter->output(i)->dims->data[3]
		);
		asm("fence r,r");
		result->yolo_layers[i].outputs = (float*)arena_calloc(arena[hartIds],total, sizeof(float));
		if(result->yolo_layers[i].outputs == NULL){
			MicroPrintf("Failed Yolo layer output allocation on Core %d\n\r", hartIds);
		}
		TfLiteAffineQuantization params = *(static_cast<TfLiteAffineQuantization *>(model->interpreter->output(i)->quantization.params));
		for (int j = 0; j < total; ++j)
			result->yolo_layers[i].outputs[j] = ((float)model->interpreter->output(i)->data.int8[j] - params.zero_point->data[0]) * params.scale->data[0];
	}
	int total_boxes = 0;
	result->yolo_layer_time_start = clint_getTime(BSP_CLINT);
	result->boxes = perform_inference(result->yolo_layers, model->total_output_layers, &total_boxes, model->input->dims->data[1], model->input->dims->data[2], YOLO_OBJECTNESS_THRESHOLD, YOLO_IOU_THRESHOLD);
	result->yolo_layer_time_end = clint_getTime(BSP_CLINT);
	result->total_boxes = total_boxes;
}


//Face Landmark//
void run_landmark_output(volatile TfliteMicroModel* model, volatile fl_result * result) {
	u32 hartIds = csr_read(mhartid);
	result->fl_layer_time_start = clint_getTime(BSP_CLINT);
	for (int i = 0; i < model->total_output_layers; ++i) {
		result->total[i] = (model->interpreter->output(i)->dims->data[0]
							* model->interpreter->output(i)->dims->data[1]
							* model->interpreter->output(i)->dims->data[2]
							* model->interpreter->output(i)->dims->data[3]);

		TfLiteAffineQuantization params =
				*(static_cast<TfLiteAffineQuantization*>(model->interpreter->output(i)->quantization.params));


		if (i == 0) {
			for (int j = 0; j < result->total[i]; ++j)
				result->face_landmarks[j] =
						((float) model->interpreter->output(i)->data.int8[j] - params.zero_point->data[0])
						* params.scale->data[0]
						/ model->input->dims->data[(j % COORDINATES != 1 ? 1 : 2)];
		} else if (i == 1) {
			for (int j = 0; j < result->total[i]; ++j)
				result->face_flags[j] = ((float) model->interpreter->output(i)->data.int8[j]
										- params.zero_point->data[0]) * params.scale->data[0];
			fl_activate_logistic((float*)result->face_flags, result->total[i]);
		}

	}
	result->fl_layer_time_end = clint_getTime(BSP_CLINT);
}


/**********************************************************************OUTPUT *************************************************************/



void print_inference_time(const char* label, u64 start_time, u64 end_time) {
	// Calculate the time difference in clock cycles
	u64 timer_diff = end_time - start_time;

	// Print the inference clock cycle (hex)
	u32 *v = (u32 *)&timer_diff;
	MicroPrintf("%s - Inference clock cycle (hex): %x, %x\n\r", label, v[1], v[0]);

	// Print SYSTEM_CLINT_HZ in hex
	MicroPrintf("SYSTEM_CLINT_HZ (hex): %x\n\r", SYSTEM_CLINT_HZ);

	// Display note for conversion
	MicroPrintf("NOTE: processing_time (second) = timestamp_clock_cycle/SYSTEM_CLINT_HZ\n\r");

	// Calculate the processing time in milliseconds
	u32 ms = timer_diff / (SYSTEM_CLINT_HZ / 1000);
	MicroPrintf("%s - Inference time: %ums\n\r", label, ms);
}

//YOLO///
void show_output_yolo(volatile yolo_result * result, uint32_t data){
	if (result->status != kTfLiteOk) {
		MicroPrintf("Invoke failed on data\n\r");
	} else {
		MicroPrintf("\n\r[Core_0][OUTPUT_%d_0]Boxes:\n\r", data);
		for (int i = 0; i < result->total_boxes; ++i) {
			print_float(result->boxes[i].x_min);
			MicroPrintf(", ");
			print_float(result->boxes[i].y_min);
			MicroPrintf(", ");
			print_float(result->boxes[i].x_max);
			MicroPrintf(", ");
			print_float(result->boxes[i].y_max);
			MicroPrintf(", ");
			print_float(result->boxes[i].objectness);
			MicroPrintf(", ");

			for (int c = 0; c < YOLO_CLASSES; ++c) {
				print_float(result->boxes[i].class_probabilities[c]);
				if (c < YOLO_CLASSES - 1)
					MicroPrintf(", ");
				else
					MicroPrintf("\n\r");
			}
		}
		MicroPrintf(";\n\r");
		MicroPrintf("[Core_0][OUTPUT_%d_1]Total_boxes : %d;\n\n\r", data, result->total_boxes);

		//Front layer inference
	   print_inference_time("[Core_0] Yolo Front Layers",result->time_start,result->time_end);

	   //Last layer inference
	   print_inference_time("[Core_0] Yolo Last Layer",result->yolo_layer_time_start,result->yolo_layer_time_end);
	}
}

//FL//
void show_output_fl(volatile TfliteMicroModel* model, uint32_t data, volatile fl_result * result) {
	if (result->status != kTfLiteOk) {
		MicroPrintf("Invoke failed on data\n\r");
	} else {
		for (int i = 0; i < model->total_output_layers; ++i) {
			if(i == 0){
				MicroPrintf("[Core_1][OUTPUT_%d_0]geoffrey_hinton_tflite_quant_face_landmarks:\n\r", data);
				for (int j = 0; j < result->total[i]; ++j) {
					print_float(result->face_landmarks[j]);

					if (j < result->total[i] - 1) {
						if (j % COORDINATES != 2)
							MicroPrintf(", ");
						else
							MicroPrintf(",\n\r");

					} else {
						MicroPrintf(",\n\r");
					}
				}
				MicroPrintf(";\n\r");
			}
			if (i == 1) {
				MicroPrintf("[Core_1][OUTPUT_%d_1]geoffrey_hinton_tflite_quant_face_flag:\n\r", data);
				for (int j = 0; j < result->total[i]; ++j) {
					print_float(result->face_flags[j]);
					MicroPrintf(";\n\r");
				}
			}
		}

		//Front layer inference
		print_inference_time("[Core_1] Face Landmark Front Layers",result->time_start,result->time_end);

		//Last layer inference
		print_inference_time("[Core_1] Face Landmark Last Layer",result->fl_layer_time_start,result->fl_layer_time_end);
	}
}


//PDTI8//
void show_output_pdt8(volatile TfliteMicroModel* model, uint32_t data, volatile pdt8_result * result) {
	if (result->status != kTfLiteOk) {
		MicroPrintf("Invoke failed on data\n\r");
	} else {
		MicroPrintf("\n\r[Core_2][OUTPUT_%d]Person Detection Inference %d ...\n\r", data, data + 1);
		char* person_str = "Person";
		if(result->person == 0){
			person_str = "No Person";
		}
		MicroPrintf("%s Detection Inference ...\n\r",person_str);
		MicroPrintf("Person Score    : %d,\n\r",result->person_score);
		MicroPrintf("No Person Score : %d;\n\r", result->no_person_score);
		MicroPrintf("Person Detection Score (Percentage): %d%%\n\r", result->person_score_percent);

		print_inference_time("[Core_2] Person Detection", result->time_start, result->time_end);
	}
}

//IMGC//
void show_output_imgc(volatile TfliteMicroModel* model, uint32_t data, volatile imgc_result * result) {
	if (result->status != kTfLiteOk) {
		MicroPrintf("Invoke failed on data\n\r");
	} else {
		MicroPrintf("\n\r[Core_3][OUTPUT_%d]Image Classification Inference %d (%s)...\n\r", data, data + 1, kCategoryLabelsImgc[result->img_class]);
		for (int i = 0; i < kCategoryCountImgc; ++i)
			MicroPrintf("%s score: %d,\n\r", kCategoryLabelsImgc[i], result->output[i]);
		MicroPrintf(";\n\r");
		print_inference_time("[Core_3] Image Classification", result->time_start, result->time_end);
	}
}



#endif /* SRC_MODEL_TINYML_OUTPUT_H_ */
