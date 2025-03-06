/*
 * crop_scale_util.h
 *
 *  Created on: 19 Nov 2024
 *      Author: mfaiz
 */

#ifndef SRC_MODEL_CROP_SCALE_UTIL_H_
#define SRC_MODEL_CROP_SCALE_UTIL_H_

#include <stdlib.h>
#include <stdint.h>
#include "riscv.h"
#include "soc.h"
#include "bsp.h"
#include <math.h>
#include "arena.h"


//Crop image based on offset.
//This API supports different channels between input and output. E.g; if we have 4-channel input (R-G-B-A) and require 3-channel output (R-G-B), it will treat the last one as don't care
uint8_t* crop_image_rgba(const uint8_t* input_data, int center_x , int center_y , int offset, int square_size, int channels, int *output_width, int *output_height, int output_channel) {
	u32 hartId = csr_read(mhartid);
    int left = center_x - offset;
    int top = center_y - offset;
    int right = center_x + offset;
    int bottom = center_y + offset;
    *output_width = right - left;
    *output_height = bottom - top;

    int crop_size = (*output_width) * (*output_height) * output_channel;

    uint8_t* cropped_rgb_image = (uint8_t*)arena_calloc(arena[hartId],crop_size, sizeof(uint8_t));

    int index = 0;

    for (int y = top; y < bottom; ++y) {
        for (int x = left; x < right; ++x) {
            // Ensure the coordinates are within the bounds of the original image
            if (x >= 0 && x < square_size && y >= 0 && y < square_size) {
                for (int c = 0; c < output_channel; ++c) {
                	cropped_rgb_image[index++] = input_data[(y * square_size + x) * channels + c];
                }
            }
        }
    }
    return cropped_rgb_image;

}
// Nearest-neighbor resizing for an image
// input_data: original image data (width x height x channels)
// input_width, input_height, input_channels: dimensions of the original image
// output_data: pointer to store the resized image data
// output_width, output_height: dimensions of the resized image
//This API supports different channels between input and output. E.g; if we have 4-channel input (R-G-B-A) and require 3-channel output (R-G-B), it will treat the last one as don't care
uint8_t* nearest_neighbor_resize(const uint8_t *input_data, int input_width, int input_height, int input_channels,
                             int output_width, int output_height, int output_channels) {

	u32 hartId = csr_read(mhartid);
	int size = output_width * output_height * output_channels;
	uint8_t *output_data = (uint8_t*)arena_calloc(arena[hartId],size, sizeof(uint8_t));
    for (int y_out = 0; y_out < output_height; y_out++) {
        for (int x_out = 0; x_out < output_width; x_out++) {
            // Find the corresponding pixel in the original image (nearest-neighbor)
            int x_in = (x_out * input_width) / output_width;
            int y_in = (y_out * input_height) / output_height;

            // Calculate the position in the input image (1D array for each pixel's channels)
            int input_pos = (y_in * input_width + x_in) * input_channels;
            // Calculate the position in the output image (1D array for each pixel's channels)
            int output_pos = (y_out * output_width + x_out) * output_channels;

            // Copy pixel data from input to output (RGB or grayscale, depending on channels)
            for (int c = 0; c < output_channels; c++) {
                output_data[output_pos + c] = input_data[input_pos + c];
            }
        }
    }
    return output_data;
}







#endif /* SRC_MODEL_CROP_SCALE_UTIL_H_ */
