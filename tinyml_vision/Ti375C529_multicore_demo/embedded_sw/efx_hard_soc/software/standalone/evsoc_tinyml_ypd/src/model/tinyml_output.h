/*
 * tinyml_output.h
 *
 *  Created on: Oct 17, 2024
 *      Author: mfaiz
 */

#ifndef SRC_MODEL_TINYML_OUTPUT_H_
#define SRC_MODEL_TINYML_OUTPUT_H_

#include "bsp.h"

#include "ypd/yolo.h"
#include "fl/face_landmark_detection.h"
#include "fd/blazeface.h"
#include "fd/ssd_anchors.h"
#include "tensorflow/lite/c/common.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "model/arena.h"
#include "model/tinyml_init.h"
#include "model/model_setup.h"

//Structure for face landmark cropped image
struct box_image {
	int center_x;
	int center_y;
	float box_width;
	float box_height;
	int width;
	int height;
	int offset;
};

/**********************************************************************STRUCTURE TO HOLD RESULT *************************************************************/


// Base result structure for common properties
struct BaseResult {
    TfLiteStatus status;
    uint64_t time_start;
    uint64_t time_end;
    int8_t done;
};


struct fl_result : BaseResult {
	uint64_t fl_layer_time_start;
	uint64_t fl_layer_time_end;
	float face_landmarks[1404];
	float face_flags[1404];
	int total[2];
	uint8_t  landmark_valid = 0;
	uint32_t landmark_x[NUM_LANDMARK];
	uint32_t landmark_y[NUM_LANDMARK];
	int left; //Needed to offset on original image
	int top; //Needed to offset on original image
};

struct yolo_result : BaseResult {
	uint64_t yolo_layer_time_start;
	uint64_t yolo_layer_time_end;
	box* boxes;
	int total_boxes;
	layer* yolo_layers;
};

struct fd_result : BaseResult {
	uint64_t fd_layer_time_start;
	uint64_t fd_layer_time_end;
	bf_box* boxes;
	int total_boxes;
	int total_keypoint_values;
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


//Face Landmark//
void run_landmark_output(volatile TfliteMicroModel* model, volatile fl_result * result, volatile box_image* image) {
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
						((float) model->interpreter->output(i)->data.int8[j]
								- params.zero_point->data[0])
								* params.scale->data[0]
								/ model->input->dims->data[(
										j % COORDINATES != 1 ? 1 : 2)];

			//Scale landmark points according to display resolution (being sent through DMA)
			for (int k=0; k<NUM_LANDMARK; k++) {
			   result->landmark_x[k] = result->face_landmarks[k*3]   * image->width;
			   result->landmark_y[k] = result->face_landmarks[k*3+1] * image->height;
			}


		} else if (i == 1) {
//			result->face_flags = (float*)arena_calloc(arena[hartIds],result->total[i], sizeof(float));
			for (int j = 0; j < result->total[i]; ++j)
				result->face_flags[j] = ((float) model->interpreter->output(i)->data.int8[j]
						- params.zero_point->data[0]) * params.scale->data[0];
			fl_activate_logistic((float*)result->face_flags, result->total[i]);
			//Update the top and left coordinates for offset.
			if (result->face_flags[0] > FACE_FLAG_THRESH) //Assume only one landmark flag is produced
				result->landmark_valid = 1;

			else
				result->landmark_valid = 0;
		}


	}
	result->fl_layer_time_end = clint_getTime(BSP_CLINT);
//	arena_clear(arena[hartIds]);

}




//Yolo Person detection///
void run_yolo_layer(volatile TfliteMicroModel* model, volatile yolo_result * result, float anchors[2][YOLO_TOTAL_ANCHORS * 2]) {
	asm("fence r,r");
	u32 hartIds = csr_read(mhartid);
	result->yolo_layers = (layer*)arena_calloc(arena[hartIds],model->total_output_layers, sizeof(layer));
		  if(result->yolo_layers == NULL){
		  		MicroPrintf("Failed Yolo layer allocation on Core %d\n\r",hartIds);
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
	  		MicroPrintf("Failed Yolo layer output allocation on Core %d\n\r",hartIds);
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
//   arena_clear(arena[hartIds]);

}


//Yolo Person detection///
void run_fd_layer(volatile TfliteMicroModel* model, volatile fd_result * result) {
	asm("fence r,r");
	u32 hartIds = csr_read(mhartid);
    int total_results = 0;
    int detection_size = 0;
    for (int i = 0; i < model->total_output_layers; ++i) {
        if (model->interpreter->output(i)->dims->data[2] > 1) {
            total_results += model->interpreter->output(i)->dims->data[1];
            detection_size = model->interpreter->output(i)->dims->data[2];
        }
    }
	float* detections = (float*)arena_calloc(arena[hartIds],total_results * detection_size, sizeof(float));
    float* scores = (float*)arena_calloc(arena[hartIds],total_results, sizeof(float));
    int detection_index = 0;
    int score_index = 0;

	for (int i = 0; i < model->total_output_layers; ++i) {
		int total = (model->interpreter->output(i)->dims->data[0] * model->interpreter->output(i)->dims->data[1] * model->interpreter->output(i)->dims->data[2]);
		TfLiteAffineQuantization params =
				*(static_cast<TfLiteAffineQuantization*>(model->interpreter->output(i)->quantization.params));
		if (model->interpreter->output(i)->dims->data[2] == detection_size) {
			for (int j = 0; j < total; ++j){
                float value = ((float)model->interpreter->output(i)->data.int8[j] - params.zero_point->data[0]) * params.scale->data[0];
                detections[detection_index + j] = value;
			}
			detection_index += total;
		} else {
			for (int j = 0; j < total; ++j) {
                float value = ((float)model->interpreter->output(i)->data.int8[j] - params.zero_point->data[0]) * params.scale->data[0];
                scores[score_index + j] = value;
			}
			score_index += total;
		}
	}
    int total_keypoint_values = detection_size - 4;
    int total_boxes = 0;

	result->fd_layer_time_start = clint_getTime(BSP_CLINT);
    result->boxes = bf_perform_inference(
        detections, scores, (float*)ssd_anchors, &total_boxes, score_index, detection_size, model->input->dims->data[1], model->input->dims->data[2], FD_OBJECTNESS_THRESHOLD,
        FD_IOU_THRESHOLD
    );
	result->fd_layer_time_end = clint_getTime(BSP_CLINT);
    result->total_keypoint_values = total_keypoint_values;
	result->total_boxes = total_boxes;
//   arena_clear(arena[hartIds]);

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


//Face Landmark
void show_output_fl(volatile TfliteMicroModel* model, volatile fl_result * result)
{
	if (result->status != kTfLiteOk)
	{
	     MicroPrintf("Invoke failed on data\n\r");
	}
	else
	{
		//For timestamp
		uint64_t timerDiff_0_1,timerDiff_2_3;
		u32 ms;
		u32 *v;
		for (int i = 0; i < model->total_output_layers; ++i) {
			if(i == 0){
			MicroPrintf("[OUTPUT_0]Face Landmarks:\n\r");
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
				MicroPrintf("[OUTPUT_1]Face Flags:\n\r");
				for (int j = 0; j < result->total[i]; ++j) {
					print_float(result->face_flags[j]);
					MicroPrintf(";\n\r");
				}
			}
		}

		//Front layer inference
	   print_inference_time("Front Layer",result->time_start,result->time_end);

	   //Last layer inference
	   print_inference_time("Face Landmark Layer",result->fl_layer_time_start,result->fl_layer_time_end);

	}
}


//Face detection
void show_output_fd(volatile fd_result * result)
{
	if (result->status != kTfLiteOk)
	{
	     MicroPrintf("Invoke failed on data\n\r");
	}
	else
	{
		//For timestamp
		uint64_t timerDiff_0_1,timerDiff_2_3;
		u32 ms;
		u32 *v;

		MicroPrintf("\n\r[OUTPUT_0]Boxes:\n\r");

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
	   }

		MicroPrintf("\n\r[OUTPUT_1]Keypoints:\n\r");
	    for (int i = 0; i < result->total_boxes; ++i) {
	        for (int j = 0; j < result->total_keypoint_values; ++j) {
	            print_float(result->boxes[i].keypoints[j]);
	            if (j < result->total_keypoint_values - 1)
	                MicroPrintf(", ");
	            else
	                if (i < result->total_boxes - 1)
	                    MicroPrintf(", \n\r");
	        }
	    }


	   MicroPrintf("\n\r[OUTPUT_2]Total_boxes : %d\n\r", result->total_boxes);

		//Front layer inference
	   print_inference_time("Front Layer",result->time_start,result->time_end);

	   //Last layer inference
	   print_inference_time("Face Detection Layer",result->fd_layer_time_start,result->fd_layer_time_end);


	}
}

//Yolo
void show_output_yolo(volatile yolo_result * result)
{
	if (result->status != kTfLiteOk)
	{
	     MicroPrintf("Invoke failed on data\n\r");
	}
	else
	{
		//For timestamp
		uint64_t timerDiff_0_1,timerDiff_2_3;
		u32 ms;
		u32 *v;

	   MicroPrintf("\n\r[OUTPUT_0]Boxes:\n\r");
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
	   MicroPrintf("[OUTPUT_1]Total_boxes = %d;\n\n\r", result->total_boxes);

		//Front layer inference
	   print_inference_time("Front Layer",result->time_start,result->time_end);

	   //Last layer inference
	   print_inference_time("Yolo Layer",result->yolo_layer_time_start,result->yolo_layer_time_end);


	}
}


#endif /* SRC_MODEL_TINYML_OUTPUT_H_ */
