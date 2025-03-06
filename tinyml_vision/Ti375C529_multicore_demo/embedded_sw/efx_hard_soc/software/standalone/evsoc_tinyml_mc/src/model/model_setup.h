/*
 * model_setup.h
 *
 *  Created on: 23 Nov 2024
 *      Author: mfaiz
 */

#ifndef SRC_MODEL_MODEL_SETUP_H_
#define SRC_MODEL_MODEL_SETUP_H_


#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
//#include "tensorflow/lite/micro/micro_mutable_op_resolver.h"
#include "tensorflow/lite/micro/all_ops_resolver.h"
#include "bsp.h"



struct TfliteMicroModel {
    tflite::MicroInterpreter* interpreter;
    TfLiteTensor* input;
    int total_output_layers;
    tflite::ErrorReporter* error_reporter;
    tflite::AllOpsResolver ops_resolver;
    int input_width;
    int input_height;
    int input_channels;
    int input_size;
};

bool setup_tflite_micro_model(
    TfliteMicroModel* model,
    const uint8_t* model_data,
    uint8_t* tensor_arena,
    size_t tensor_arena_size,
    bool use_profiler,
    const char* model_name
) {


    tflite::InitializeTarget();
    tflite::MicroErrorReporter* micro_error_reporters = new tflite::MicroErrorReporter;

    // Setup error reporter using indexed static resource
    model->error_reporter = micro_error_reporters;



    // Load the model
    const tflite::Model* tflite_model = tflite::GetModel(model_data);
    if (tflite_model->version() != TFLITE_SCHEMA_VERSION) {
        TF_LITE_REPORT_ERROR(
            model->error_reporter,
            "[%s] Model provided is schema version %d not equal to supported version %d.\n\r",
            model_name,
            tflite_model->version(),
            TFLITE_SCHEMA_VERSION
        );
        return false;
    }

    //Setup profiler
    FullProfiler* profilers = new FullProfiler;

    //Setup all_ops_resolver
    tflite::AllOpsResolver* ops_resolvers = new tflite::AllOpsResolver;

    // Create new interpreter
    tflite::MicroInterpreter* interpreters = new tflite::MicroInterpreter(
        tflite_model,
        *ops_resolvers,
        tensor_arena,
        tensor_arena_size,
        micro_error_reporters,
        use_profiler ? profilers : nullptr
    );

    // Set the model's interpreter reference
    model->interpreter = interpreters;

    // Allocate tensors
    TfLiteStatus allocate_status = model->interpreter->AllocateTensors();
    if (allocate_status != kTfLiteOk) {
        TF_LITE_REPORT_ERROR(model->error_reporter, "[%s] AllocateTensors() failed\n\r", model_name);
        return false;
    }

    // Setup input tensor and get output layers count
    model->input = model->interpreter->input(0);
    model->total_output_layers = model->interpreter->outputs_size();

    // Print model information
    MicroPrintf("[%s] Total output layers: %d\n\r", model_name, model->total_output_layers);
    MicroPrintf(
        "[%s] Input shape: %d %d %d %d %d, type: %d\n\r",
        model_name,
        model->input->dims->size,
        model->input->dims->data[0],
        model->input->dims->data[1],
        model->input->dims->data[2],
        model->input->dims->data[3],
        model->input->type
    );

    for (int i = 0; i < model->total_output_layers; ++i) {
        MicroPrintf(
            "[%s] Output shape %d: %d %d %d %d, type: %d\n\r",
            model_name,
            i,
            model->interpreter->output(i)->dims->size,
            model->interpreter->output(i)->dims->data[0],
            model->interpreter->output(i)->dims->data[1],
            model->interpreter->output(i)->dims->data[2],
            model->interpreter->output(i)->type
        );
    }

    model->input_width = model->input->dims->data[2];
    model->input_height = model->input->dims->data[1];
    model->input_channels = model->input->dims->data[3];
    model->input_size = model->input->dims->data[0] *
                       model->input->dims->data[1] *
                       model->input->dims->data[2] *
                       model->input->dims->data[3];
    return true;
}


void assign_model_input(TfliteMicroModel* model, uint8_t* raw_input) {
	for(int i = 0 ; i < model->input_size ; i++) {
		model->input->data.int8[i] = raw_input[i] - 128;
	}

}

#endif /* SRC_MODEL_MODEL_SETUP_H_ */
