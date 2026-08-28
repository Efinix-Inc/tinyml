/* Copyright 2018 The TensorFlow Authors. All Rights Reserved.
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
#ifndef TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_INTEGER_OPS_POOLING_H_
#define TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_INTEGER_OPS_POOLING_H_
#include <limits>
#include "tensorflow/lite/kernels/internal/common.h"
namespace tflite {
namespace reference_integer_ops {


inline __attribute__((noinline)) void AveragePool(
    const PoolParams& params, const RuntimeShape& input_shape,
    const int8_t* input_data, const RuntimeShape& output_shape,
    int8_t* output_data) {
  TFLITE_DCHECK_LE(params.quantized_activation_min,
                   params.quantized_activation_max);
  TFLITE_DCHECK_EQ(input_shape.DimensionsCount(), 4);
  TFLITE_DCHECK_EQ(output_shape.DimensionsCount(), 4);
  const int batches = MatchingDim(input_shape, 0, output_shape, 0);
  const int depth = MatchingDim(input_shape, 3, output_shape, 3);
  const int input_height = input_shape.Dims(1);
  const int input_width = input_shape.Dims(2);
  const int output_height = output_shape.Dims(1);
  const int output_width = output_shape.Dims(2);
  const int stride_height = params.stride_height;
  const int stride_width = params.stride_width;
  for (int batch = 0; batch < batches; ++batch) {
    for (int out_y = 0; out_y < output_height; ++out_y) {
      for (int out_x = 0; out_x < output_width; ++out_x) {
        for (int channel = 0; channel < depth; ++channel) {
          const int in_x_origin =
              (out_x * stride_width) - params.padding_values.width;
          const int in_y_origin =
              (out_y * stride_height) - params.padding_values.height;
          // Compute the boundaries of the filter region clamped so as to
          // ensure that the filter window fits in the input array.
          const int filter_x_start = std::max(0, -in_x_origin);
          const int filter_x_end =
              std::min(params.filter_width, input_width - in_x_origin);
          const int filter_y_start = std::max(0, -in_y_origin);
          const int filter_y_end =
              std::min(params.filter_height, input_height - in_y_origin);
          int32_t acc = 0;
          int filter_count = 0;
          for (int filter_y = filter_y_start; filter_y < filter_y_end;
               ++filter_y) {
            for (int filter_x = filter_x_start; filter_x < filter_x_end;
                 ++filter_x) {
              const int in_x = in_x_origin + filter_x;
              const int in_y = in_y_origin + filter_y;
              acc +=
                  input_data[Offset(input_shape, batch, in_y, in_x, channel)];
              filter_count++;
            }
          }
          // Round to the closest integer value.
          acc = acc > 0 ? (acc + filter_count / 2) / filter_count
                        : (acc - filter_count / 2) / filter_count;
          acc = std::max(acc, params.quantized_activation_min);
          acc = std::min(acc, params.quantized_activation_max);
          output_data[Offset(output_shape, batch, out_y, out_x, channel)] =
              static_cast<int8_t>(acc);
        }
      }
    }
  }
}

inline __attribute__((noinline)) void MaxPool(
    const PoolParams& params, const RuntimeShape& input_shape,
    const int8_t* input_data, const RuntimeShape& output_shape,
    int8_t* output_data) {
  TFLITE_DCHECK_LE(params.quantized_activation_min,
                   params.quantized_activation_max);
  TFLITE_DCHECK_GE(params.quantized_activation_min,
                   std::numeric_limits<int8_t>::min());
  TFLITE_DCHECK_LE(params.quantized_activation_max,
                   std::numeric_limits<int8_t>::max());
  TFLITE_DCHECK_EQ(input_shape.DimensionsCount(), 4);
  TFLITE_DCHECK_EQ(output_shape.DimensionsCount(), 4);
  const int batches = MatchingDim(input_shape, 0, output_shape, 0);
  const int depth = MatchingDim(input_shape, 3, output_shape, 3);
  const int input_height = input_shape.Dims(1);
  const int input_width = input_shape.Dims(2);
  const int output_height = output_shape.Dims(1);
  const int output_width = output_shape.Dims(2);
  const int stride_height = params.stride_height;
  const int stride_width = params.stride_width;

  const int pad_w = params.padding_values.width;
  const int pad_h = params.padding_values.height;
  const int8_t act_min = static_cast<int8_t>(params.quantized_activation_min);
  const int8_t act_max = static_cast<int8_t>(params.quantized_activation_max);

  const int in_row_stride = input_width * depth;
  const int in_img_stride = input_height * in_row_stride;
  const int out_row_stride = output_width * depth;
  const int out_img_stride = output_height * out_row_stride;

  for (int batch = 0; batch < batches; ++batch) {
    const int8_t* in_batch = input_data + batch * in_img_stride;
    int8_t* out_batch = output_data + batch * out_img_stride;

    for (int out_y = 0; out_y < output_height; ++out_y) {
      const int in_y_origin = (out_y * stride_height) - pad_h;
      int8_t* out_row = out_batch + out_y * out_row_stride;

      // Window rows clamped once per output ROW.
      const int fy0 = std::max(0, -in_y_origin);
      const int fy1 = std::min(params.filter_height, input_height - in_y_origin);

      for (int out_x = 0; out_x < output_width; ++out_x) {
        const int in_x_origin = (out_x * stride_width) - pad_w;
        int8_t* out_px = out_row + out_x * depth;

        const int fx0 = std::max(0, -in_x_origin);
        const int fx1 = std::min(params.filter_width, input_width - in_x_origin);

        const int8_t* win = in_batch + (in_y_origin + fy0) * in_row_stride +
                            (in_x_origin + fx0) * depth;
        const int ny = fy1 - fy0;
        const int nx = fx1 - fx0;

        if (ny == 2 && nx == 2) {
          const int8_t* r0 = win;
          const int8_t* r1 = win + in_row_stride;
          for (int c = 0; c < depth; ++c) {
            const int8_t a = r0[c], b = r0[c + depth];
            const int8_t u = r1[c], v = r1[c + depth];
            int8_t m = a > b ? a : b;
            const int8_t n = u > v ? u : v;
            if (n > m) m = n;
            if (m < act_min) m = act_min;
            if (m > act_max) m = act_max;
            out_px[c] = m;
          }
          continue;
        }

        for (int c = 0; c < depth; ++c) {
          const int8_t* rp = win + c;
          int8_t m = std::numeric_limits<int8_t>::lowest();
          for (int fy = 0; fy < ny; ++fy, rp += in_row_stride) {
            const int8_t* p = rp;
            for (int fx = 0; fx < nx; ++fx, p += depth) {
              const int8_t val = *p;
              if (val > m) m = val;
            }
          }
          if (m < act_min) m = act_min;
          if (m > act_max) m = act_max;
          out_px[c] = m;
        }
      }
    }
  }
}

inline __attribute__((noinline)) void AveragePool(
    const PoolParams& params, const RuntimeShape& input_shape,
    const int16_t* input_data, const RuntimeShape& output_shape,
    int16_t* output_data) {
  TFLITE_DCHECK_LE(params.quantized_activation_min,
                   params.quantized_activation_max);
  TFLITE_DCHECK_EQ(input_shape.DimensionsCount(), 4);
  TFLITE_DCHECK_EQ(output_shape.DimensionsCount(), 4);
  const int batches = MatchingDim(input_shape, 0, output_shape, 0);
  const int depth = MatchingDim(input_shape, 3, output_shape, 3);
  const int input_height = input_shape.Dims(1);
  const int input_width = input_shape.Dims(2);
  const int output_height = output_shape.Dims(1);
  const int output_width = output_shape.Dims(2);
  const int stride_height = params.stride_height;
  const int stride_width = params.stride_width;
  for (int batch = 0; batch < batches; ++batch) {
    for (int out_y = 0; out_y < output_height; ++out_y) {
      for (int out_x = 0; out_x < output_width; ++out_x) {
        for (int channel = 0; channel < depth; ++channel) {
          const int in_x_origin =
              (out_x * stride_width) - params.padding_values.width;
          const int in_y_origin =
              (out_y * stride_height) - params.padding_values.height;
          // Compute the boundaries of the filter region clamped so as to
          // ensure that the filter window fits in the input array.
          const int filter_x_start = std::max(0, -in_x_origin);
          const int filter_x_end =
              std::min(params.filter_width, input_width - in_x_origin);
          const int filter_y_start = std::max(0, -in_y_origin);
          const int filter_y_end =
              std::min(params.filter_height, input_height - in_y_origin);
          int32_t acc = 0;
          int filter_count = 0;
          for (int filter_y = filter_y_start; filter_y < filter_y_end;
               ++filter_y) {
            for (int filter_x = filter_x_start; filter_x < filter_x_end;
                 ++filter_x) {
              const int in_x = in_x_origin + filter_x;
              const int in_y = in_y_origin + filter_y;
              acc +=
                  input_data[Offset(input_shape, batch, in_y, in_x, channel)];
              filter_count++;
            }
          }
          // Round to the closest integer value.
          acc = acc > 0 ? (acc + filter_count / 2) / filter_count
                        : (acc - filter_count / 2) / filter_count;
          acc = std::max(acc, params.quantized_activation_min);
          acc = std::min(acc, params.quantized_activation_max);
          output_data[Offset(output_shape, batch, out_y, out_x, channel)] =
              static_cast<int16_t>(acc);
        }
      }
    }
  }
}

inline __attribute__((noinline)) void MaxPool(
    const PoolParams& params, const RuntimeShape& input_shape,
    const int16_t* input_data, const RuntimeShape& output_shape,
    int16_t* output_data) {
  TFLITE_DCHECK_LE(params.quantized_activation_min,
                   params.quantized_activation_max);
  TFLITE_DCHECK_GE(params.quantized_activation_min,
                   std::numeric_limits<int16_t>::min());
  TFLITE_DCHECK_LE(params.quantized_activation_max,
                   std::numeric_limits<int16_t>::max());
  TFLITE_DCHECK_EQ(input_shape.DimensionsCount(), 4);
  TFLITE_DCHECK_EQ(output_shape.DimensionsCount(), 4);
  const int batches = MatchingDim(input_shape, 0, output_shape, 0);
  const int depth = MatchingDim(input_shape, 3, output_shape, 3);
  const int input_height = input_shape.Dims(1);
  const int input_width = input_shape.Dims(2);
  const int output_height = output_shape.Dims(1);
  const int output_width = output_shape.Dims(2);
  const int stride_height = params.stride_height;
  const int stride_width = params.stride_width;
  for (int batch = 0; batch < batches; ++batch) {
    for (int out_y = 0; out_y < output_height; ++out_y) {
      for (int out_x = 0; out_x < output_width; ++out_x) {
        for (int channel = 0; channel < depth; ++channel) {
          const int in_x_origin =
              (out_x * stride_width) - params.padding_values.width;
          const int in_y_origin =
              (out_y * stride_height) - params.padding_values.height;
          // Compute the boundaries of the filter region clamped so as to
          // ensure that the filter window fits in the input array.
          const int filter_x_start = std::max(0, -in_x_origin);
          const int filter_x_end =
              std::min(params.filter_width, input_width - in_x_origin);
          const int filter_y_start = std::max(0, -in_y_origin);
          const int filter_y_end =
              std::min(params.filter_height, input_height - in_y_origin);
          int16_t max = std::numeric_limits<int16_t>::lowest();
          for (int filter_y = filter_y_start; filter_y < filter_y_end;
               ++filter_y) {
            for (int filter_x = filter_x_start; filter_x < filter_x_end;
                 ++filter_x) {
              const int in_x = in_x_origin + filter_x;
              const int in_y = in_y_origin + filter_y;
              max = std::max(
                  max,
                  input_data[Offset(input_shape, batch, in_y, in_x, channel)]);
            }
          }
          max = std::max<int16_t>(max, params.quantized_activation_min);
          max = std::min<int16_t>(max, params.quantized_activation_max);
          output_data[Offset(output_shape, batch, out_y, out_x, channel)] =
              static_cast<int16_t>(max);
        }
      }
    }
  }
}
}  // namespace reference_integer_ops
}  // namespace tflite
#endif  // TENSORFLOW_LITE_KERNELS_INTERNAL_REFERENCE_INTEGER_OPS_POOLING_H_