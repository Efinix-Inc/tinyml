#ifndef LR_H
#define LR_H
#include "tensorflow/lite/kernels/internal/common.h"
#include "ops_api.h"
#include "intc.h"
#include "model/define.h"

OP_STATUS_T lr_drv(
		int size,
		int32_t input_offset,

		int32_t output_shift_identity,
		int32_t output_multiplier_identity,
		int32_t output_shift_alpha,
		int32_t output_multiplier_alpha,
		int32_t output_offset,

		int32_t quantized_activation_max,
		int32_t quantized_activation_min,
		const int8_t *input_data,
		int8_t *output_data
		);

#endif // LR_H
