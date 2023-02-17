///////////////////////////////////////////////////////////////////////////////////
// Copyright 2022 Efinix.Inc. All Rights Reserved.
// You may obtain a copy of the license at
//    https://www.efinixinc.com/software-license.html
///////////////////////////////////////////////////////////////////////////////////

#ifndef YOLO_H
#define YOLO_H

typedef struct layer {
    int channels, height, width, classes, boxes_per_scale, total_anchors;
    float scale, *anchors, *outputs;
} layer;

typedef struct box {
    float x_min, y_min, x_max, y_max, objectness;
    float *class_probabilities;
    int sort_class_index;
} box;

int get_index(int height, int width, int classes, int location, int entry);
void activate_logistic(float *values, const int total);
void apply_scale(float *values, const int total, float alpha, float beta);
void decode_yolo_outputs(float *outputs, float *anchors, int channel, int height, int width, int classes, int total_anchors, int net_height, int net_width, float scale);
box* create_boxes(layer *layers, int total, float objectness_threshold);
int fill_boxes(
    float *values, float *anchors, int channel, int height, int width, int classes, int net_height, int net_width, box *boxes, int offset, float objectness_threshold
);
float calc_iou(box box_1, box box_2);
float calc_diou(box box_1, box box_2);
int compare_class_probability(const void *box_1_pointer, const void *box_2_pointer);
void perform_nms(box *boxes, int total_boxes, int classes, float iou_threshold);
box* filter_boxes(box *boxes, int *total_boxes, int classes, float objectness_threshold);
box* perform_inference(layer *layers, int total, int *total_boxes, int net_height, int net_width, float min_objectness_threshold, float iou_threshold);

#endif
