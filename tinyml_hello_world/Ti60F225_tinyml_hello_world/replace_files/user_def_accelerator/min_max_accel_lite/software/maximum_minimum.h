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
#ifndef TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_MAXIMUM_MINIMUM_H_
#define TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_MAXIMUM_MINIMUM_H_

#include "tensorflow/lite/kernels/internal/common.h"
#include "tensorflow/lite/kernels/internal/types.h"
#include "riscv.h"


//For user-defined accelerator =  10'b1x_xxxx_xxxx
//Custom instruction in software is defined as func3 [0:2] , func7 [9:3]
//Thus, the instruction implemented should be :
//  Func3 : {3'dxxx} 
// 0x0 = To select between signed integer or unsigned integer. Sending input0[0] as 0 will result in unsigned operation , whereas sending input0[0] as 1 will result in signed operation
// 0x1 = To perform maximum operation. input0 and input1 will be sent in 32-bit format , and will perform 8-bit maximum operation (split on hardware)
// 0x2 = To perform minimum operation. input0 and input1 will be sent in 32-bit format , and will perform 8-bit maximum operation (split on hardware)
// Func7 : {7'dxxx_xxxx}
// {7'd100_1000} : (For user-defined accelerator selection)
#define CUSTOM_MAX(el1, el2)              opcode_R(CUSTOM0, 0x01, 0x48, el1, el2)
#define CUSTOM_MIN(el1, el2)              opcode_R(CUSTOM0, 0x02, 0x48, el1, el2)
#define SET_SIGNED_INT()                  opcode_R(CUSTOM0, 0x00, 0x48, 1, 0)
#define SET_UNSIGNED_INT()                opcode_R(CUSTOM0, 0x00, 0x48, 0, 0)

//Define the flags to turn on the accelerator. To turn off the accelerator and perform pure software run, comment it out.
#define USER_DEF_MIN_MAX_LITE 1

namespace tflite {
namespace reference_ops {

template <bool Max, typename T, typename Op, int N = 5>
void MaximumMinimumBroadcastSlow(const RuntimeShape& unextended_input1_shape,
                                 const T* input1_data,
                                 const RuntimeShape& unextended_input2_shape,
                                 const T* input2_data,
                                 const RuntimeShape& unextended_output_shape,
                                 T* output_data, Op op) {
  //Used for user-defined min max lite accelerator
  int32_t *ret_data = (int32_t*) output_data;
  int32_t *data1    = (int32_t*) input1_data;
  int32_t *data2    = (int32_t*) input2_data;


  // Uses element-wise calculation if broadcast is not required.
  if (unextended_input1_shape == unextended_input2_shape) {
    const int flat_size =
        MatchingElementsSize(unextended_input1_shape, unextended_input2_shape,
                             unextended_output_shape);
#ifdef USER_DEF_MIN_MAX_LITE
    if(std::is_same<T, int8_t>::value){
  	  SET_SIGNED_INT();
    }
    else{
  	  SET_UNSIGNED_INT();
    }

    for (int i = 0; i < flat_size/4; ++i) {
    	ret_data[i] = CUSTOM_MAX(data1[i],data2[i]);
    }
#else
    for (int i = 0; i < flat_size; ++i) {
      output_data[i] = op(input1_data[i], input2_data[i]);
    }
#endif
  } else {
    TFLITE_DCHECK_LE(unextended_input1_shape.DimensionsCount(), N);
    TFLITE_DCHECK_LE(unextended_input2_shape.DimensionsCount(), N);
    TFLITE_DCHECK_LE(unextended_output_shape.DimensionsCount(), N);

    NdArrayDesc<N> desc1;
    NdArrayDesc<N> desc2;
    NdArrayDesc<N> output_desc;
    NdArrayDescsForElementwiseBroadcast(
        unextended_input1_shape, unextended_input2_shape, &desc1, &desc2);
    CopyDimsToDesc(RuntimeShape::ExtendedShape(N, unextended_output_shape),
                   &output_desc);

    auto maxmin_func = [&](int indexes[N]) {
      output_data[SubscriptToIndex(output_desc, indexes)] =
          op(input1_data[SubscriptToIndex(desc1, indexes)],
             input2_data[SubscriptToIndex(desc2, indexes)]);
    };
    NDOpsHelper<N>(output_desc, maxmin_func);
  }
}

}  // namespace reference_ops
}  // namespace tflite

#endif  // TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_MAXIMUM_MINIMUM_H_
