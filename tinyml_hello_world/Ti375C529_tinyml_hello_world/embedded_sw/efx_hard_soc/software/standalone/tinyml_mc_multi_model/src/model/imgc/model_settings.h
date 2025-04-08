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

#ifndef IMAGE_CLASSIFICATION_MODEL_SETTINGS_H_
#define IMAGE_CLASSIFICATION_MODEL_SETTINGS_H_

// Keeping these as constant expressions allow us to allocate fixed-sized arrays
// on the stack for our working memory.

// All of these values are derived from the values used during model training,
// if you change your model you'll need to update these constants.
constexpr int kNumColsImgc = 32;
constexpr int kNumRowsImgc = 32;
constexpr int kNumChannelsImgc = 3;

constexpr int kMaxImageSizeImgc = kNumColsImgc * kNumRowsImgc * kNumChannelsImgc;

constexpr int kCategoryCountImgc = 10;
constexpr int kAirplaneIndex = 0;
constexpr int kCarIndex      = 1;
constexpr int kBirdIndex     = 2;
constexpr int kCatIndex      = 3;
constexpr int kDeerIndex     = 4;
constexpr int kDogIndex      = 5;
constexpr int kFrogIndex     = 6;
constexpr int kHorseIndex    = 7;
constexpr int kShipIndex     = 8;
constexpr int kTruckIndex    = 9;

const char* kCategoryLabelsImgc[kCategoryCountImgc] = {
   "quant_airplane",
   "quant_car",
   "quant_bird",
   "quant_cat",
   "quant_deer",
   "quant_dog",
   "quant_frog",
   "quant_horse",
   "quant_ship",
   "quant_truck"
};

#endif  // IMAGE_CLASSIFICATION_MODEL_SETTINGS_H_
