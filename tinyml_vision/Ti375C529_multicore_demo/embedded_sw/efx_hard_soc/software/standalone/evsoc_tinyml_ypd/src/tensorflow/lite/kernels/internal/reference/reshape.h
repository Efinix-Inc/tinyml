/* Copyright 2017 The TensorFlow Authors. All Rights Reserved.

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
#ifndef TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_RESHAPE_H_
#define TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_RESHAPE_H_

#include "tensorflow/lite/c/common.h"
#include "../../../../../platform/tinyml/ops/reshape.h"
#include "tensorflow/lite/kernels/internal/common.h"
#include "tensorflow/lite/kernels/internal/types.h"
namespace tflite {
namespace reference_ops {

void ReshapeFunction(	const TfLiteEvalTensor* input_address,
                        TfLiteEvalTensor* output_address,
                        int32_t input_bytes) {
  // Uses element-wise calculation if broadcast is not required.
  if (input_address->data.raw != output_address->data.raw) {
	const void* input1_address = input_address->data.raw;
	void* output1_address = output_address->data.raw;

    if (reshape_drv(input1_address, output1_address, input_bytes) != OP_OK) {
		  memcpy(output1_address, input1_address, input_bytes);
    }
  }
}
}  // namespace reference_ops
}  // namespace tflite

#endif  // TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_RESHAPE_H_
