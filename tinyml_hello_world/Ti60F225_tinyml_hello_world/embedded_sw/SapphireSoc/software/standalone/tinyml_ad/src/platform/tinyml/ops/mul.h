#ifndef MUL_H
#define MUL_H
#include "tensorflow/lite/kernels/internal/common.h"
#include "ops_api.h"
#include "intc.h"
#include "model/define.h"

OP_STATUS_T mul_drv(
		int32_t input1_offset,
		int32_t input2_offset,

		int32_t output_shift,
		int32_t output_multiplier,
		int32_t output_offset,

		int32_t quantized_activation_max,
		int32_t quantized_activation_min,
		int32_t bmax,
		int32_t ymax,
		int32_t xmax,
		int32_t cmax,
		const int *strides1,
		const int *strides2,
		const int8_t *input1_data,
		const int8_t *input2_data,
		int8_t *output_data
		);

OP_STATUS_T mul_drv_elementwise(
		int size,
		int32_t input1_offset,
		int32_t input2_offset,

		int32_t output_shift,
		int32_t output_multiplier,
		int32_t output_offset,

		int32_t quantized_activation_max,
		int32_t quantized_activation_min,
		const int8_t *input1_data,
		const int8_t *input2_data,
		int8_t *output_data
		);
#endif // MUL_H
