#ifndef ADD_H
#define ADD_H
#include "ops_api.h"
#include "intc.h"
#include "model/define.h"

OP_STATUS_T add_drv(
		int size,
		const int8_t *input1_data,
		const int8_t *input2_data,
		int8_t *output_data,
		int32_t input1_offset,
		int32_t input2_offset,
		int32_t output_offset,
		int32_t output_multiplier,
		int32_t output_shift,
		int32_t left_shift,
		int32_t input1_multiplier,
		int32_t input1_shift,
		int32_t input2_multiplier,
		int32_t input2_shift,
		int32_t quantized_activation_min,
		int32_t quantized_activation_max
		);
#endif // ADD_H
