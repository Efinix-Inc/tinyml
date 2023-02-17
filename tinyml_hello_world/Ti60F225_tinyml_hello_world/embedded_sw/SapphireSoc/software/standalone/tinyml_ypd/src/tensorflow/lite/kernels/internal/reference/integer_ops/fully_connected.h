/* Copyright 2019 The TensorFlow Authors. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
==============================================================================*/
#ifndef TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_INTEGER_OPS_FULLY_CONNECTED_H_
#define TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_INTEGER_OPS_FULLY_CONNECTED_H_

#include "tensorflow/lite/kernels/internal/common.h"
#include "print.h"
#include "clint.h"
#include "riscv.h"

#include "platform/tinyml/ops/fully_connected.h"

namespace tflite {
namespace reference_integer_ops {

inline void FullyConnected(
    const FullyConnectedParams& params, const RuntimeShape& input_shape,
    const int8_t* input_data, const RuntimeShape& filter_shape,
    const int8_t* filter_data, const RuntimeShape& bias_shape,
    const int32_t* bias_data, const RuntimeShape& output_shape,
    int8_t* output_data) {
  
    //uart_writeStr(BSP_UART_TERMINAL, "\n---Fully connected get here!!---\n\r");
    //uint64_t timerCmp0, timerCmp1, timerDiff_0_1;
    //timerCmp0 = clint_getTime(BSP_CLINT);
        
    const int32_t input_offset = params.input_offset;
    const int32_t filter_offset = params.weights_offset;
    const int32_t output_offset = params.output_offset;
    const int32_t output_multiplier = params.output_multiplier;
    const int output_shift = params.output_shift;
    const int32_t output_activation_min = params.quantized_activation_min;
    const int32_t output_activation_max = params.quantized_activation_max;
    TFLITE_DCHECK_GE(filter_shape.DimensionsCount(), 2);
    TFLITE_DCHECK_EQ(output_shape.DimensionsCount(), 2);
    
    TFLITE_DCHECK_LE(output_activation_min, output_activation_max);
    const int filter_dim_count = filter_shape.DimensionsCount();
    const int batches = output_shape.Dims(0);
    const int output_depth = output_shape.Dims(1);
    TFLITE_DCHECK_LE(output_depth, filter_shape.Dims(filter_dim_count - 2));
    const int accum_depth = filter_shape.Dims(filter_dim_count - 1);
    
    int32_t* acc_store;
    acc_store = (int32_t *) malloc( sizeof(int32_t)*(output_depth*batches) ); // allocate enough memory acc_store
  
    // tinyml driver
    auto res = fully_connected_drv  (   
                                        input_offset,
                                        filter_offset,
                                        output_offset,
                                        output_multiplier,
                                        output_shift,
                                        output_activation_min,
                                        output_activation_max,
                                        batches,
                                        output_depth,
                                        accum_depth,
                                        input_data,
                                        filter_data,
                                        bias_data,
                                        acc_store
                                    );


	if(res == OP_OK) {
		for (int b = 0; b < batches; ++b) {
			for (int out_c = 0; out_c < output_depth; ++out_c) {
			int32_t acc = 0;
				acc = acc_store[out_c + (output_depth * b)];
				acc = MultiplyByQuantizedMultiplier(acc, output_multiplier, output_shift);
				acc += output_offset;
				acc = std::max(acc, output_activation_min);
				acc = std::min(acc, output_activation_max);
				output_data[out_c + output_depth * b] = static_cast<int8_t>(acc);
			}
		}
		return;
	} else if( res == OP_BYPASS) {
		return;
	}
  
    for (int b = 0; b < batches; ++b) {
        for (int out_c = 0; out_c < output_depth; ++out_c) {
            int32_t acc = 0;
            for (int d = 0; d < accum_depth; ++d) {
                int32_t input_val = input_data[b * accum_depth + d];
                int32_t filter_val = filter_data[out_c * accum_depth + d];
                acc += (filter_val + filter_offset) * (input_val + input_offset);
            }
            if (bias_data) {
                acc += bias_data[out_c];
            }
            acc = MultiplyByQuantizedMultiplier(acc, output_multiplier, output_shift);
            acc += output_offset;
            acc = std::max(acc, output_activation_min);
            acc = std::min(acc, output_activation_max);
            output_data[out_c + output_depth * b] = static_cast<int8_t>(acc);
        }
    }
  
  //timerCmp1 = clint_getTime(BSP_CLINT);
  //uart_writeStr(BSP_UART_TERMINAL, "FC clock cycle: "); //Timestamp
  //timerDiff_0_1 = timerCmp1 - timerCmp0;
  //print_dec(timerDiff_0_1);
  //uart_writeStr(BSP_UART_TERMINAL, "\n\r");
}

inline void FullyConnected(
    const FullyConnectedParams& params, const RuntimeShape& input_shape,
    const int16_t* input_data, const RuntimeShape& filter_shape,
    const int8_t* filter_data, const RuntimeShape& bias_shape,
    const int64_t* bias_data, const RuntimeShape& output_shape,
    int16_t* output_data) {
    const int32_t filter_offset = params.weights_offset;
    const int32_t output_multiplier = params.output_multiplier;
    const int output_shift = params.output_shift;
    const int32_t output_activation_min = params.quantized_activation_min;
    const int32_t output_activation_max = params.quantized_activation_max;
    TFLITE_DCHECK_GE(filter_shape.DimensionsCount(), 2);
    TFLITE_DCHECK_EQ(output_shape.DimensionsCount(), 2);
    
    TFLITE_DCHECK_LE(output_activation_min, output_activation_max);
    const int filter_dim_count = filter_shape.DimensionsCount();
    const int batches = output_shape.Dims(0);
    const int output_depth = output_shape.Dims(1);
    TFLITE_DCHECK_LE(output_depth, filter_shape.Dims(filter_dim_count - 2));
    const int accum_depth = filter_shape.Dims(filter_dim_count - 1);
    for (int b = 0; b < batches; ++b) {
        for (int out_c = 0; out_c < output_depth; ++out_c) {
            int64_t acc = 0;
            for (int d = 0; d < accum_depth; ++d) {
                int32_t input_val = input_data[b * accum_depth + d];
                int32_t filter_val = filter_data[out_c * accum_depth + d];
                acc += (filter_val + filter_offset) * input_val;
            }
            if (bias_data) {
                acc += bias_data[out_c];
            }
            int32_t acc_scaled =
                MultiplyByQuantizedMultiplier(acc, output_multiplier, output_shift);
            acc_scaled = std::max(acc_scaled, output_activation_min);
            acc_scaled = std::min(acc_scaled, output_activation_max);
            output_data[out_c + output_depth * b] = static_cast<int16_t>(acc_scaled);
        }
    }
}

}  // namespace reference_integer_ops
}  // namespace tflite

#endif  // TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_INTEGER_OPS_FULLY_CONNECTED_H_
