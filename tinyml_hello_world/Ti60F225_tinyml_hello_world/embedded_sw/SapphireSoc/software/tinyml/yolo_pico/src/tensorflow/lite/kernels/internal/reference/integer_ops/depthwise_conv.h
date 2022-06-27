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
#ifndef TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_INTEGER_OPS_DEPTHWISE_CONV_H_
#define TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_INTEGER_OPS_DEPTHWISE_CONV_H_

#include "tensorflow/lite/kernels/internal/common.h"
#include "print.h"
#include "clint.h"

namespace tflite {
namespace reference_integer_ops {
void DepthwiseConvPerChannel(
   const DepthwiseParams& params, const int32_t* output_multiplier,
   const int32_t* output_shift, const RuntimeShape& input_shape,
   const int8_t* input_data, const RuntimeShape& filter_shape,
   const int8_t* filter_data, const RuntimeShape& bias_shape,
   const int32_t* bias_data, const RuntimeShape& output_shape,
   int8_t* output_data);

void DepthwiseConvPerChannel(
   const DepthwiseParams& params, const int32_t* output_multiplier,
   const int32_t* output_shift, const RuntimeShape& input_shape,
   const int16_t* input_data, const RuntimeShape& filter_shape,
   const int8_t* filter_data, const RuntimeShape& bias_shape,
   const std::int64_t* bias_data, const RuntimeShape& output_shape,
   int16_t* output_data);

void DepthwiseConvHybridPerChannel(
   const DepthwiseParams& params, float* scaling_factors_ptr,
   const RuntimeShape& input_shape, const int8_t* input_data,
   const RuntimeShape& filter_shape, const int8_t* filter_data,
   const RuntimeShape& bias_shape, const float* bias_data,
   const RuntimeShape& output_shape, float* output_data,
   const float* per_channel_scale, int32_t* input_offset);

}  // namespace reference_integer_ops
}  // namespace tflite

#endif  // TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_INTEGER_OPS_DEPTHWISE_CONV_H_
