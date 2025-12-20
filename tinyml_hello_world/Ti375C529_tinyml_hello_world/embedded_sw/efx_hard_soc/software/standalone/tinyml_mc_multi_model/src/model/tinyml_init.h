#ifndef SRC_MODEL_TINYML_INIT_H_
#define SRC_MODEL_TINYML_INIT_H_

#include "bsp.h"
#include "tensorflow/lite/micro/micro_error_reporter.h"
#include "tensorflow/lite/micro/micro_interpreter.h"
#include "tensorflow/lite/micro/all_ops_resolver.h"

// model data
#include "ypd/yolo_person_detect_model_data.h"
#include "fl/mediapipe_face_landmark_model_data.h"
#include "fd/mediapipe_face_detection_model_data.h"

//Model setup
#include "model_setup.h"

//Yolo//
#define YOLO_SCALE 1
#define YOLO_CLASSES 1
#define YOLO_TOTAL_ANCHORS 3
#define YOLO_OBJECTNESS_THRESHOLD 0.25
#define YOLO_IOU_THRESHOLD 0.5

//FD//
#define FD_OBJECTNESS_THRESHOLD 0.8
#define FD_IOU_THRESHOLD 0.01

//FL//
#define COORDINATES 3
#define NUM_LANDMARK                468
#define FACE_FLAG_THRESH            0.2

namespace {
// Create arena for each core
constexpr int kTensorArenaSize0 = 240000;//150000
constexpr int kTensorArenaSize1 = 470000;
constexpr int kTensorArenaSize2 = 10000000;//650000
constexpr int kTensorArenaSize3 = 10000000;
uint8_t yolo_core0_tensor_arena[kTensorArenaSize0];
uint8_t face_detection_core1_tensor_arena[kTensorArenaSize1];
uint8_t face_landmark_core2_tensor_arena[kTensorArenaSize2];
uint8_t face_landmark_core3_tensor_arena[kTensorArenaSize3];

// Create error reporters for each core
static tflite::MicroErrorReporter error_reporter_yolo_core0;
static tflite::MicroErrorReporter error_reporter_face_detection_core1;
static tflite::MicroErrorReporter error_reporter_face_landmark_core2;
static tflite::MicroErrorReporter error_reporter_face_landmark_core3;

// Create model structure for each core
TfliteMicroModel yolo_core0;
TfliteMicroModel face_detection_core1;
TfliteMicroModel face_landmark_core2;
TfliteMicroModel face_landmark_core3;

// anchors
float yolo_anchors[2][YOLO_TOTAL_ANCHORS * 2] = {{115, 73, 119, 199, 242, 238}, {12, 18, 37, 49, 52, 132}};
}



void setup_model(
		TfliteMicroModel* model,
	    const uint8_t* model_data,
	    uint8_t* tensor_arena,
	    size_t tensor_arena_size,
	    bool use_profiler,
	    const char* model_name) {

    if (!setup_tflite_micro_model(
            model,
            model_data,
			tensor_arena,
			tensor_arena_size,
			use_profiler,
			model_name
        )) {
        MicroPrintf("[%s] Setup failed\n\r", model_name);
        return;
    }
}


//Multicore model initialization
void initialize_multicore_model(){
    //Initialize all cores model

    //Core 0: Yolo
    setup_tflite_micro_model(
        &yolo_core0,
        yolo_person_detect_model_data,
        yolo_core0_tensor_arena,
        kTensorArenaSize0,
        true,
        "YOLO");

    //Core 1: Face Detection
    setup_tflite_micro_model(
        &face_detection_core1,
        mediapipe_face_detection_model_data,
        face_detection_core1_tensor_arena,
        kTensorArenaSize1,
        false,
        "FACE DETECTION");

    //Core 2: Face Landmark
    setup_tflite_micro_model(
        &face_landmark_core2,
        mediapipe_face_landmark_model_data,
        face_landmark_core2_tensor_arena,
        kTensorArenaSize2,
        false,
        "FACE LANDMARK 1");

    //Core 3: Face Landmark
    setup_tflite_micro_model(
        &face_landmark_core3,
        mediapipe_face_landmark_model_data,
        face_landmark_core3_tensor_arena,
        kTensorArenaSize3,
        false,
        "FACE LANDMARK 2");
}

#endif







