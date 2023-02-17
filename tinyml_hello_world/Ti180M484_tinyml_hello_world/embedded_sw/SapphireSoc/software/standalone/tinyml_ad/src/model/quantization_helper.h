#include <limits.h>
#include <math.h>

inline float DequantizeInt8ToFloat(int8_t value, float scale, int zero_point) {
  return static_cast<float>(value - zero_point) * scale;
}

inline int8_t QuantizeFloatToInt8(float value, float scale, int zero_point) {
  int32_t result = round(value / scale) + zero_point;
  if (result < INT8_MIN) {
    result = INT8_MIN;
  }
  if (result > INT8_MAX) {
    result = INT8_MAX;
  }
  return static_cast<int8_t>(result);
}
