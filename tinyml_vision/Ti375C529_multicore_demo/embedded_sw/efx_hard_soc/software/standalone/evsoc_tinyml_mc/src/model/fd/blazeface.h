#ifndef BLAZEFACE_H
#define BLAZEFACE_H

typedef struct bf_bf_box {
    float x_min, y_min, x_max, y_max, objectness;
    float *keypoints;
    int original_index;
} bf_box;

float bf_activate_logistic(float value);
void bf_activate_logistic(float *values, const int total);
float bf_calc_iou(bf_box box_1, bf_box box_2);
float bf_calc_diou(bf_box box_1, bf_box box_2);
int bf_compare_objectness(const void *box_1_pointer, const void *box_2_pointer);
void bf_perform_nms(bf_box *boxes, int total_boxes, float iou_threshold);
int bf_compare_x_min(const void *box_1_pointer, const void *box_2_pointer);
bf_box* bf_filter_boxes(bf_box *boxes, int *total_boxes, float objectness_threshold);
void bf_decode_outputs(
    float *detections, float *scores, float *anchors, bf_box *boxes, int total_detections, int detection_size, int net_height, int net_width, float objectness_threshold
);
bf_box* bf_perform_inference(
    float *detections, float *scores, float *anchors, int *total_boxes, int total_detections, int detection_size, int net_height, int net_width, 
    float objectness_threshold, float iou_threshold
);

#endif
