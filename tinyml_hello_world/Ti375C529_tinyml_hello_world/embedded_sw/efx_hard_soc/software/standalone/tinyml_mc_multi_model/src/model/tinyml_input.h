/*
 * tinyml_input.h
 *
 *  Created on: Oct 17, 2024
 *      Author: mfaiz
 */

#ifndef SRC_MODEL_TINYML_INPUT_H_
#define SRC_MODEL_TINYML_INPUT_H_


//ypd
#include "ypd/input_img_000000018380_96x96x3.h"

//fl
#include "fl/input_geoffrey_hinton_192x192x3.h"

//pdti8
#include "pdti8/person_image_data.h"
#include "pdti8/no_person_image_data.h"
#include "pdti8/no_people1_data.h"
#include "pdti8/no_people2_data.h"
#include "pdti8/people1_data.h"
#include "pdti8/people2_data.h"

//imgc
#include "imgc/quant_airplane.h"
#include "imgc/quant_bird.h"
#include "imgc/quant_car.h"
#include "imgc/quant_cat.h"
#include "imgc/quant_deer.h"
#include "imgc/quant_dog.h"
#include "imgc/quant_frog.h"
#include "imgc/quant_horse.h"
#include "imgc/quant_ship.h"
#include "imgc/quant_truck.h"

#include "tensorflow/lite/c/common.h"
#include "tinyml_output.h"

void set_yolo_input(TfliteMicroModel* model)
{
	   for (unsigned int i = 0; i < input_img_000000018380_96x96x3_len; ++i)
	      model->input->data.int8[i] = input_img_000000018380_96x96x3[i];  //Pre-normalized to [-128,127]
}

void set_fl_input(TfliteMicroModel* model)
{
	for (unsigned int i = 0; i < input_geoffrey_hinton_192x192x3_len; ++i)
		model->input->data.int8[i] = input_geoffrey_hinton_192x192x3[i]; //Pre-normalized to [-128,127]
}

void set_pdt8_input(TfliteMicroModel* model, uint32_t data, volatile pdt8_result * result)
{

	int8_t pattern = data%6;

	switch (pattern)
	{
		case 0:
			//Copy test image to tflite model input. Input size to person detection model 96*96=9216
			for (unsigned int i = 0; i < g_person_data_size; ++i)
				model->input->data.int8[i] = g_person_data[i]; //Input image data (from tflite micro example) is pre-normalized
			result->person = 1;
			break;
		case 1:
			 for (unsigned int i = 0; i < g_no_person_data_size; ++i)
				 model->input->data.int8[i] = g_no_person_data[i]; //Input image data (from tflite micro example) is pre-normalized
				result->person = 0;
			break;
		case 2:
			for (unsigned int i = 0; i < people1_data_size; ++i)
				model->input->data.int8[i] = people1_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]
				result->person = 1;
			break;
		case 3:
			for (unsigned int i = 0; i < people2_data_size; ++i)
				model->input->data.int8[i] = people2_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]
				result->person = 1;
			break;
		case 4:
			for (unsigned int i = 0; i < no_people1_data_size; ++i)
				model->input->data.int8[i] = no_people1_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]
				result->person = 0;
			break;
		case 5:
			for (unsigned int i = 0; i < no_people2_data_size; ++i)
				model->input->data.int8[i] = no_people2_data[i] - 128; //Input normalization: From range [0,255] to [-128,127]
				result->person = 0;
			break;
		default:
			break;

	}

}

void set_imgc_input(TfliteMicroModel* model, uint32_t data, volatile imgc_result * result)
{
	int8_t pattern = data%10;
	switch (pattern)
	{
		case 0:
			//Copy test image to tflite model input. Input size to person detection model 96*96=9216
		   for (unsigned int i = 0; i < quant_airplane_dat_len; ++i)
			  model->input->data.int8[i] = quant_airplane_dat[i];
		   result->img_class = 0;
			break;
		case 1:
		   for (unsigned int i = 0; i < quant_car_dat_len; ++i)
			   model->input->data.int8[i] = quant_car_dat[i];
			result->img_class = 1;
			break;
		case 2:
		   for (unsigned int i = 0; i < quant_bird_dat_len; ++i)
			   model->input->data.int8[i] = quant_bird_dat[i];
		   result->img_class = 2;
			break;
		case 3:
		    for (unsigned int i = 0; i < quant_truck_dat_len; ++i)
		    	model->input->data.int8[i] = quant_truck_dat[i];
			result->img_class = 9;
			break;
		case 4:
		     for (unsigned int i = 0; i < quant_deer_dat_len; ++i)
		    	 model->input->data.int8[i] = quant_deer_dat[i];
			result->img_class = 4;
			break;
		case 5:
		    for (unsigned int i = 0; i < quant_ship_dat_len; ++i)
		    	model->input->data.int8[i] = quant_ship_dat[i];
			result->img_class = 8;
			break;
		case 6:
		     for (unsigned int i = 0; i < quant_horse_dat_len; ++i)
		    	 model->input->data.int8[i] = quant_horse_dat[i];
			result->img_class = 7;
			break;
		case 7:
			for (unsigned int i = 0; i < quant_cat_dat_len; ++i)
				model->input->data.int8[i] = quant_cat_dat[i];
			result->img_class = 3;
			break;
		case 8:
			for (unsigned int i = 0; i < quant_dog_dat_len; ++i)
				model->input->data.int8[i] = quant_dog_dat[i];
			result->img_class = 5;
			break;
		case 9:
			for (unsigned int i = 0; i < quant_frog_dat_len; ++i)
				model->input->data.int8[i] = quant_frog_dat[i];
			result->img_class = 6;
			break;

		default:
			break;
	}

}


#endif /* SRC_MODEL_TINYML_INPUT_H_ */
