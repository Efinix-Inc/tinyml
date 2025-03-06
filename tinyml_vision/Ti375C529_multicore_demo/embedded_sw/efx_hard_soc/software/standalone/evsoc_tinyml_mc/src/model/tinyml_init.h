#ifndef SRC_MODEL_TINYML_INIT_H_
#define SRC_MODEL_TINYML_INIT_H_

#include "bsp.h"


//Model
#include "fl/mediapipe_face_landmark_model_data.h"
#include "ypd/yolo_person_detect_model_data.h"
#include "fd/mediapipe_face_detection_model_data.h"


//Model setup
#include "model_setup.h"


//Yolo//
#define YOLO_SCALE 1
#define YOLO_CLASSES 1
#define YOLO_TOTAL_ANCHORS 3
#define YOLO_OBJECTNESS_THRESHOLD 0.5
#define YOLO_IOU_THRESHOLD 0.3


//FD//
#define FD_OBJECTNESS_THRESHOLD 0.8
#define FD_IOU_THRESHOLD 0.01
//#define FD_OBJECTNESS_THRESHOLD 0.7
//#define FD_IOU_THRESHOLD 0.3

//FL//
#define COORDINATES 3
#define NUM_LANDMARK                468
#define FACE_FLAG_THRESH            0.2

//Captured size
#define FRAME_WIDTH     1080
#define FRAME_HEIGHT    1080
#define FRAME_CHANNELS  4

namespace {
constexpr int kTensorArenaSize0 = 150000; //144456;
constexpr int kTensorArenaSize1 = 470000; //469696;
constexpr int kTensorArenaSize2 = 650000; //641128;

    // Create arena for each core
    uint8_t yolo_core0_tensor_arena[kTensorArenaSize0],face_detection_core1_tensor_arena[kTensorArenaSize1],face_landmark_core2_tensor_arena[kTensorArenaSize2],face_landmark_core3_tensor_arena[kTensorArenaSize2];

    // Create model structure for each core
    TfliteMicroModel yolo_core0,face_detection_core1, face_landmark_core2,face_landmark_core3;

    // Anchor for yolo
    float yolo_anchors[2][YOLO_TOTAL_ANCHORS * 2] = {{115, 73, 119, 199, 242, 238}, {12, 18, 37, 49, 52, 132}};
}


void setup_yolo_core0() {
    if (!setup_tflite_micro_model(
            &yolo_core0,
            yolo_person_detect_model_data,
			yolo_core0_tensor_arena,
			kTensorArenaSize0,
            false,
            "Yolo"
        )) {
        MicroPrintf("[Yolo] Setup failed\n\r");
        return;
    }
}

void setup_face_detection_core1() {
    if (!setup_tflite_micro_model(
            &face_detection_core1,
            mediapipe_face_detection_model_data,
			face_detection_core1_tensor_arena,
			kTensorArenaSize1,
            false,
            "Face Detection"
        )) {
        MicroPrintf("[Face Detection] Setup failed\n\r");
        return;
    }
}

void setup_face_landmark_core2() {
    if (!setup_tflite_micro_model(
            &face_landmark_core2,
            mediapipe_face_landmark_model_data,
			face_landmark_core2_tensor_arena,
			kTensorArenaSize2,
            false,
            "Face Landmark"
        )) {
        MicroPrintf("[Face Landmark] Setup failed\n\r");
        return;
    }
}

void setup_face_landmark_core3() {
    if (!setup_tflite_micro_model(
            &face_landmark_core3,
            mediapipe_face_landmark_model_data,
			face_landmark_core3_tensor_arena,
			kTensorArenaSize2,
            false,
            "Face Landmark"
        )) {
        MicroPrintf("[Face Landmark] Setup failed\n\r");
        return;
    }
}

//Multicore model initialization
void initialize_multicore_model(){
	//Initialize all cores model

	//Core 0: Yolo
	setup_yolo_core0();

    //Core 1: Face detection
	setup_face_detection_core1();

    //Core 2: Face landmark
    setup_face_landmark_core2();

    //Core 3: Face landmark
    setup_face_landmark_core3();
}


#endif
