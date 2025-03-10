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

#include "tensorflow/lite/micro/examples/micro_speech/micro_features/no_micro_features_data.h"

// Golden test values for the expected spectrogram from a "no" sample file
// speech_commands_test_set_v0.02/no/f9643d42_nohash_4.wav.

const int g_no_micro_f9643d42_nohash_4_width = 40;
const int g_no_micro_f9643d42_nohash_4_height = 49;
const signed char g_no_micro_f9643d42_nohash_4_data[] = {
    103,  78,   64,   76,   75,   54,   53,   67,   77,   60,   56,   70,
    76,   71,   68,   58,   74,   32,   23,   -2,   -18,  11,   13,   15,
    9,    20,   5,    -7,   -18,  -2,   -10,  -18,  -10,  -12,  9,    7,
    -33,  -12,  -4,   -18,  57,   17,   55,   62,   70,   45,   61,   37,
    67,   52,   48,   47,   55,   46,   57,   47,   73,   17,   27,   20,
    19,   8,    15,   -6,   -1,   10,   -12,  -29,  -6,   -23,  -18,  -3,
    -1,   5,    3,    -4,   -12,  -8,   -1,   -14,  65,   48,   58,   43,
    48,   19,   39,   39,   57,   57,   58,   55,   67,   58,   49,   50,
    70,   27,   9,    16,   37,   4,    25,   4,    11,   9,    7,    -33,
    -7,   -12,  3,    -6,   -29,  -7,   -7,   -18,  -12,  -18,  -2,   -1,
    0,    31,   60,   -8,   51,   59,   70,   40,   71,   57,   52,   38,
    66,   48,   17,   6,    59,   8,    15,   7,    18,   4,    18,   -23,
    -8,   -4,   -3,   -12,  -3,   -26,  1,    10,   2,    -29,  -29,  -37,
    -7,   -4,   6,    -33,  67,   44,   59,   -4,   64,   51,   68,   55,
    74,   9,    40,   15,   57,   33,   60,   18,   40,   25,   27,   -20,
    25,   -16,  6,    17,   -10,  -12,  -23,  -43,  -23,  -23,  -29,  -37,
    -4,   -16,  -16,  -60,  -20,  -23,  -10,  -29,  -12,  15,   12,   -37,
    27,   15,   61,   44,   50,   8,    48,   22,   49,   -18,  46,   33,
    42,   34,   46,   -8,   4,    -18,  -43,  -43,  -10,  1,    -10,  -16,
    -10,  -77,  -16,  -33,  11,   -26,  -23,  -37,  0,    -8,   -16,  -29,
    42,   40,   68,   24,   47,   46,   53,   -128, 30,   2,    42,   21,
    21,   -4,   43,   2,    43,   5,    32,   -26,  7,    -37,  -43,  -23,
    -2,   -8,   2,    -37,  -50,  -60,  -1,   -7,   -33,  -77,  -6,   -18,
    -16,  -50,  -12,  -33,  53,   8,    52,   18,   51,   35,   69,   26,
    44,   8,    27,   -128, 21,   -33,  17,   -14,  38,   -128, -14,  -18,
    17,   -20,  -14,  -37,  8,    -60,  -33,  -33,  -33,  -43,  -12,  -29,
    -12,  -128, -33,  -60,  -26,  -77,  -26,  -50,  57,   29,   11,   30,
    53,   -10,  45,   15,   18,   -10,  42,   2,    31,   -29,  10,   -4,
    42,   -37,  -50,  -128, -4,   -43,  -20,  -77,  -14,  -26,  -33,  -128,
    -12,  -43,  -8,   -33,  -33,  -60,  -43,  -77,  -12,  -60,  -26,  -50,
    40,   -23,  36,   35,   50,   -2,   37,   27,   26,   -77,  49,   -7,
    28,   -43,  6,    11,   41,   -37,  33,   -26,  -14,  -12,  -6,   -33,
    -16,  -26,  -20,  -77,  -14,  -43,  -8,   -50,  -14,  -37,  -26,  -77,
    -26,  -77,  -14,  -29,  50,   -60,  25,   -26,  57,   38,   51,   1,
    50,   1,    53,   -18,  30,   -23,  11,   -128, 18,   -43,  20,   -26,
    -10,  -26,  -12,  -128, -50,  -60,  -37,  -77,  -20,  -43,  -50,  -128,
    -77,  -128, -77,  -128, -33,  -77,  -20,  -60,  53,   -10,  -37,  -128,
    10,   -128, 60,   18,   -8,   13,   37,   -37,  8,    -128, 3,    -77,
    32,   -29,  14,   10,   -12,  -77,  -37,  -77,  -37,  -60,  -23,  -128,
    -43,  -50,  -16,  -77,  -6,   -33,  0,    -60,  -43,  -128, -16,  -60,
    20,   -2,   51,   19,   43,   2,    63,   20,   60,   -4,   42,   -50,
    4,    -128, 2,    -3,   32,   -33,  -26,  -128, -18,  -128, -33,  -43,
    -7,   -60,  -50,  -77,  -29,  -77,  -23,  -128, -16,  -26,  -23,  -60,
    -37,  -77,  -37,  -128, -1,   -33,  39,   48,   60,   5,    8,    -128,
    44,   11,   4,    0,    13,   -77,  -2,   -20,  33,   -128, -33,  -77,
    -8,   -128, -14,  -128, -33,  -18,  -12,  -77,  -16,  -128, -37,  -128,
    -12,  -77,  -60,  -128, -23,  -60,  -23,  -128, 36,   -50,  46,   -128,
    66,   39,   18,   -14,  -12,  -77,  -20,  -6,   24,   -128, 28,   -26,
    21,   -77,  -6,   -33,  1,    -128, -43,  -128, -1,   -50,  -37,  -128,
    -50,  -128, -33,  -128, -18,  -128, -60,  -8,   -7,   -60,  -60,  -128,
    -6,   -29,  20,   -1,   73,   40,   -43,  -14,  33,   -43,  33,   -3,
    15,   -29,  29,   -43,  20,   -60,  -29,  -128, -20,  -26,  4,    -77,
    -16,  -60,  -33,  -50,  -29,  -128, -60,  -128, -77,  -128, -37,  -50,
    0,    -77,  -33,  -128, 39,   8,    47,   10,   62,   16,   2,    1,
    10,   7,    4,    -7,   6,    -128, -77,  -50,  19,   -77,  -77,  -128,
    -77,  -128, -50,  -128, -60,  -60,  -33,  -50,  -37,  -128, -128, -128,
    -60,  -128, -37,  -60,  -18,  -128, -33,  -77,  37,   23,   29,   -128,
    -128, -128, -16,  -128, -16,  -33,  21,   -20,  -8,   -60,  -2,   -60,
    11,   -128, -50,  -128, -50,  -128, -29,  -77,  -16,  -128, -26,  -128,
    -50,  -77,  -43,  -128, -128, -128, -50,  -128, -33,  -128, -33,  -50,
    -23,  -128, 24,   -128, -128, -77,  4,    -23,  32,   -128, 1,    -26,
    -14,  -128, 10,   -77,  -4,   -128, 1,    -50,  -8,   -77,  -77,  -77,
    -23,  -128, -50,  -43,  -33,  -128, -43,  -128, -128, -128, -43,  -128,
    -50,  -128, -128, -128, 44,   15,   14,   -128, 9,    -128, 21,   0,
    29,   -7,   18,   -7,   -7,   -128, -33,  -50,  14,   -60,  -60,  -128,
    -60,  -128, -37,  -128, -43,  -128, -20,  -128, -50,  -128, -43,  -77,
    -26,  -128, -60,  -50,  -60,  -128, -77,  -128, -3,   -128, 14,   -77,
    -26,  11,   47,   -77,  -7,   -77,  45,   -43,  -12,  14,   37,   -60,
    22,   -4,   5,    -77,  -14,  -128, -10,  -60,  22,   -77,  -12,  -60,
    -50,  -128, -60,  -128, -60,  -128, -43,  -128, -50,  -128, -77,  -50,
    27,   -37,  33,   -128, 4,    -29,  -4,   -50,  -20,  -128, 6,    -37,
    -33,  -128, -50,  -128, 34,   15,   -43,  -128, -20,  -50,  -3,   -37,
    -37,  -77,  -77,  -128, -43,  -128, -128, -128, 4,    -26,  -26,  27,
    0,    -128, -29,  -60,  35,   -26,  23,   -128, -29,  -77,  19,   14,
    28,   -128, -16,  -7,   31,   -1,   17,   11,   60,   44,   8,    11,
    18,   -128, -33,  -60,  -1,   -128, -43,  -128, -23,  -128, -128, -128,
    59,   43,   35,   61,   37,   -77,  -77,  -50,  116,  88,   98,   69,
    78,   53,   78,   40,   48,   7,    29,   -18,  -2,   -14,  5,    12,
    65,   35,   31,   -12,  33,   -2,   -6,   -1,   44,   -29,  -14,  -60,
    -4,   -43,  -37,  -128, 29,   18,   38,   51,   8,    -128, -12,  -37,
    115,  91,   113,  77,   89,   36,   60,   44,   49,   36,   27,   31,
    63,   30,   62,   14,   55,   49,   42,   0,    45,   17,   -23,  1,
    30,   -37,  -50,  -77,  -8,   -60,  9,    -60,  -12,  -50,  13,   4,
    23,   -6,   28,   13,   107,  78,   101,  73,   89,   46,   63,   17,
    34,   -43,  -6,   30,   67,   40,   77,   21,   53,   39,   38,   12,
    -6,   5,    28,   -2,   18,   -43,  0,    -128, -29,  -77,  18,   -128,
    -2,   -77,  39,   35,   38,   35,   50,   29,   100,  70,   94,   69,
    86,   50,   45,   38,   45,   12,   58,   64,   74,   36,   77,   45,
    78,   62,   8,    -60,  38,   6,    21,   7,    8,    -37,  -1,   -20,
    48,   -37,  8,    -10,  8,    13,   45,   39,   38,   22,   49,   25,
    94,   63,   87,   66,   84,   -128, 29,   20,   55,   51,   80,   36,
    62,   30,   81,   72,   68,   37,   51,   27,   54,   22,   16,   -29,
    4,    9,    57,   15,   35,   -43,  -77,  -20,  4,    6,    37,   -1,
    40,   31,   47,   14,   89,   68,   96,   83,   111,  96,   115,  87,
    99,   76,   105,  84,   105,  86,   113,  91,   108,  87,   110,  78,
    80,   46,   22,   74,   88,   72,   103,  86,   80,   68,   48,   24,
    68,   48,   55,   36,   108,  90,   90,   63,   83,   63,   87,   64,
    90,   92,   113,  88,   102,  79,   109,  83,   100,  89,   109,  60,
    56,   21,   75,   62,   81,   45,   63,   73,   93,   65,   94,   80,
    89,   81,   73,   3,    43,   60,   102,  70,   84,   67,   99,   74,
    78,   57,   79,   50,   93,   82,   98,   56,   77,   70,   91,   71,
    85,   82,   86,   13,   45,   -18,  48,   40,   53,   28,   85,   60,
    65,   52,   86,   78,   76,   46,   73,   19,   35,   54,   75,   40,
    71,   60,   82,   37,   69,   42,   62,   40,   96,   70,   85,   77,
    70,   68,   103,  84,   94,   69,   81,   -128, -128, -128, -43,  -37,
    40,   2,    48,   45,   76,   37,   65,   16,   43,   18,   58,   20,
    27,   12,   71,   31,   53,   44,   88,   47,   50,   33,   39,   8,
    89,   57,   88,   69,   72,   63,   100,  68,   81,   -77,  -10,  -128,
    -128, -128, -128, -128, 13,   -77,  8,    27,   60,   28,   41,   -128,
    -37,  -128, 28,   -43,  -18,  -128, 47,   -37,  45,   27,   51,   -29,
    15,   39,   52,   30,   49,   -33,  65,   15,   76,   71,   90,   19,
    46,   -128, -16,  -128, -128, -128, -128, -128, -128, -128, -18,  -128,
    -20,  -128, 32,   -128, 21,   -33,  45,   -128, -128, -128, -12,  -128,
    -6,   -14,  43,   -128, -128, -128, -128, -128, 52,   -18,  69,   -43,
    78,   55,   42,   -128, -29,  -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, 14,   -128, -16,  -128, -128, -128, 7,    -128,
    -128, -128, -128, -128, -128, -128, 12,   -128, -128, -128, -128, -16,
    59,   -50,  35,   -128, 42,   0,    47,   -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -33,  -128, -23,  -128,
    -128, -128, -23,  -128, -128, -128, -128, -128, -128, -128, -33,  -128,
    -128, -128, -128, -128, -128, -128, -8,   -128, 36,   -50,  -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -37,  -128, -128, -60,  -10,  -128, -128, -128, -128, -128,
    -128, -128, 21,   -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -12,  -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -77,  -128, -128, -128, -29,  -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -29,  -128, -128, -128, -128, -128, -128, -128, -128, -128, -50,  -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128, -128,
    -128, -128, -128, -128,
};
