/* Copyright 2020 The MLPerf Authors. All Rights Reserved.
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
/// \file
/// \brief Visual wakewords model settings.

#ifndef V0_1_KWS_MODEL_SETTINGS_H_
#define V0_1_KWS_MODEL_SETTINGS_H_

// All of these values are derived from the values used during model training,
// if you change your model you'll need to update these constants.
constexpr int kNumCols = 10;
constexpr int kNumRows = 49;
constexpr int kNumChannels = 1;

constexpr int kKwsInputSize = kNumCols * kNumRows * kNumChannels;

constexpr int kdown = 0;
constexpr int kgo      = 1;
constexpr int kleft     = 2;
constexpr int kno      = 3;
constexpr int koff     = 4;
constexpr int kon      = 5;
constexpr int kright     = 6;
constexpr int kstop    = 7;
constexpr int kup     = 8;
constexpr int kyes    = 9;
constexpr int ksilence     = 10;
constexpr int kunknown    = 11;
constexpr int kCategoryCount = 12;
extern const char* kCategoryLabels[kCategoryCount];

#endif  // V0_1_KWS_MODEL_SETTINGS_H_
