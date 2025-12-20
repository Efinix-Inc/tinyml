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

//fd
#include "fd/input_geoffrey_hinton_128x128x3.h"


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

void set_fd_input(TfliteMicroModel* model)
{
	for (unsigned int i = 0; i < input_geoffrey_hinton_128x128x3_len; i++)
		model->input->data.int8[i] = input_geoffrey_hinton_128x128x3[i];
}


#endif /* SRC_MODEL_TINYML_INPUT_H_ */
