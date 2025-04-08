#ifndef SRC_MODEL_TINYML_INIT_H_
#define SRC_MODEL_TINYML_INIT_H_

#include "bsp.h"

// model data
#include "ypd/yolo_person_detect_model_data.h"
#include "fl/mediapipe_face_landmark_model_data.h"
#include "pdti8/mobilenetv1_person_detect_model_data.h"
#include "imgc/resnet_image_classify_model_data.h"

//Model setup
#include "model_setup.h"

//Yolo//
#define YOLO_SCALE 1
#define YOLO_CLASSES 1
#define YOLO_TOTAL_ANCHORS 3
#define YOLO_OBJECTNESS_THRESHOLD 0.25
#define YOLO_IOU_THRESHOLD 0.5

//FL//
#define COORDINATES 3
#define NUM_LANDMARK                468
#define FACE_FLAG_THRESH            0.2


namespace {
// Create arena for each core
constexpr int kTensorArenaSize0 = 150000; //144456
constexpr int kTensorArenaSize1 = 650000; //641128
constexpr int kTensorArenaSize2 = 85000; //82048
constexpr int kTensorArenaSize3 = 55000; //54176
uint8_t yolo_core0_tensor_arena[kTensorArenaSize0];
uint8_t face_landmark_core1_tensor_arena[kTensorArenaSize1];
uint8_t person_detection_core2_tensor_arena[kTensorArenaSize2];
uint8_t image_classification_core3_tensor_arena[kTensorArenaSize3];

// Create model structure for each core
TfliteMicroModel yolo_core0;
TfliteMicroModel face_landmark_core1;
TfliteMicroModel person_detection_core2;
TfliteMicroModel image_classification_core3;

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
	setup_model(&yolo_core0, yolo_person_detect_model_data, yolo_core0_tensor_arena, kTensorArenaSize0, false, "YOLO");

    //Core 1: Face landmark
	setup_model(&face_landmark_core1, mediapipe_face_landmark_model_data, face_landmark_core1_tensor_arena, kTensorArenaSize1, false, "FACE LANDMARK");

    //Core 2: Person Detection
	setup_model(&person_detection_core2, mobilenetv1_person_detect_model_data, person_detection_core2_tensor_arena, kTensorArenaSize2, false, "PERSON DETECTION");

    //Core 3: Image Classification
	setup_model(&image_classification_core3, resnet_image_classify_model_data, image_classification_core3_tensor_arena, kTensorArenaSize3, false, "IMAGE CLASSIFICATION");
}


#endif
