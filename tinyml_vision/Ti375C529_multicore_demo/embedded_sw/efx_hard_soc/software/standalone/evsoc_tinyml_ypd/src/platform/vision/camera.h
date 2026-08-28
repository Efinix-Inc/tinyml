////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#ifndef CAMERA_H
#define CAMERA_H

#include "i2c.h"

typedef enum
{
    CAMERA_NONE = 0,
    CAMERA_IMX219 = 1, // PiCam v2
    CAMERA_IMX708 = 2, // PiCam v3
    /*CAMERA_TYPE = * */
} CameraType;

typedef struct
{
    CameraType type;
    u8 slaveAddress;
    const char *name;
} CameraInfo;

#if __cplusplus
extern "C" {
#endif

void cam0_init(u32 i2cCtrl);
void cam1_init(u32 i2cCtrl);

#if __cplusplus
}
#endif

#endif


