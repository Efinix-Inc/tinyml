#ifndef DEPTHWISE_H
#define DEPTHWISE_H

#include "ops_api.h"
#include "intc.h"
#include "model/define.h"

OP_STATUS_T depthwise_drv(
		const int stride_width,
		const int stride_height,
		const int dilation_width_factor,
		const int dilation_height_factor,
		const int pad_width,
		const int pad_height,
		const int depth_multiplier,
		const int32_t input_offset,
		const int32_t output_offset,
		const int32_t output_activation_min,
		const int32_t output_activation_max,

		const int batches,
		const int input_depth,
		const int output_depth,
		const int input_width,
		const int input_height,
		const int filter_width,
		const int filter_height,
		const int output_width,
		const int output_height,

		const int32_t* output_multiplier,
		const int32_t* output_shift,
		const int8_t* input_data,
		const int8_t* filter_data,
		const int32_t* bias_data,
		const int32_t *input_shape,
		const int32_t *output_shape,
		const int32_t *filter_shape,

		int8_t* output_data
		);

#endif // DEPTHWISE_H
