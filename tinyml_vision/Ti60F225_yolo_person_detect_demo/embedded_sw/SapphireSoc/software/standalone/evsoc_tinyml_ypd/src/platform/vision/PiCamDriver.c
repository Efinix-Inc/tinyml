////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#include "bsp.h"
#include "i2c.h"

#include "riscv.h"
#include "PiCamDriver.h"
#include "common.h"

void PiCam_WriteRegData(u32 i2c_base, u16 reg, u8 data)
{
   u8 outdata;

   i2c_masterStartBlocking(i2c_base);

   i2c_txByte(i2c_base, 0x10 << 1);
   i2c_txNackBlocking(i2c_base);
   assert(i2c_rxAck(i2c_base)); // Optional check

   i2c_txByte(i2c_base, (reg >> 8) & 0xFF);
   i2c_txNackBlocking(i2c_base);
   assert(i2c_rxAck(i2c_base)); // Optional check

   i2c_txByte(i2c_base, (reg) & 0xFF);
   i2c_txNackBlocking(i2c_base);
   assert(i2c_rxAck(i2c_base)); // Optional check

   i2c_txByte(i2c_base, data & 0xFF);
   i2c_txNackBlocking(i2c_base);
   assert(i2c_rxAck(i2c_base)); // Optional check

   i2c_masterStopBlocking(i2c_base);
}

u8 PiCam_ReadRegData(u32 i2c_base, u16 reg)
{
   u8 outdata;

   i2c_masterStartBlocking(i2c_base);

   i2c_txByte(i2c_base, 0x10 << 1);
   i2c_txNackBlocking(i2c_base);
   assert(i2c_rxAck(i2c_base)); // Optional check

   i2c_txByte(i2c_base, (reg >> 8) & 0xFF);
   i2c_txNackBlocking(i2c_base);
   assert(i2c_rxAck(i2c_base)); // Optional check

   i2c_txByte(i2c_base, (reg) & 0xFF);
   i2c_txNackBlocking(i2c_base);
   assert(i2c_rxAck(i2c_base)); // Optional check

   i2c_masterStopBlocking(i2c_base);
   i2c_masterStartBlocking(i2c_base);

   i2c_txByte(i2c_base, (0x10 << 1) | 0x01);
   i2c_txNackBlocking(i2c_base);
   assert(i2c_rxAck(i2c_base)); // Optional check

   i2c_txByte(i2c_base, 0xFF);
   i2c_txNackBlocking(i2c_base);
   assert(i2c_rxNack(i2c_base)); // Optional check
   outdata = i2c_rxData(i2c_base);

   i2c_masterStopBlocking(i2c_base);

   return outdata;
}
void AccessCommSeq(u32 i2c_base)
{
   PiCam_WriteRegData(i2c_base, 0x30EB, 0x05);
   PiCam_WriteRegData(i2c_base, 0x30EB, 0x0C);
   PiCam_WriteRegData(i2c_base, 0x300A, 0xFF);
   PiCam_WriteRegData(i2c_base, 0x300B, 0xFF);
   PiCam_WriteRegData(i2c_base, 0x30EB, 0x05);
   PiCam_WriteRegData(i2c_base, 0x30EB, 0x09);
}

void PiCam_Output_Size(u32 i2c_base, u16 X, u16 Y)
{
   PiCam_WriteRegData(i2c_base, x_output_size_A_1, X >> 8);
   PiCam_WriteRegData(i2c_base, x_output_size_A_0, X & 0xFF);
   PiCam_WriteRegData(i2c_base, y_output_size_A_1, Y >> 8);
   PiCam_WriteRegData(i2c_base, y_output_size_A_0, Y & 0xFF);
}

void PiCam_Output_activePixel(u32 i2c_base, u16 XStart, u16 XEnd, u16 YStart, u16 YEnd)
{
   // Max Active pixel 3280* 2464--imx219
   PiCam_WriteRegData(i2c_base, X_ADD_STA_A_1, XStart >> 8);
   PiCam_WriteRegData(i2c_base, X_ADD_STA_A_0, XStart & 0xFF);
   PiCam_WriteRegData(i2c_base, X_ADD_END_A_1, XEnd >> 8);
   PiCam_WriteRegData(i2c_base, X_ADD_END_A_0, XEnd & 0xFF);

   PiCam_WriteRegData(i2c_base, Y_ADD_STA_A_1, YStart >> 8);
   PiCam_WriteRegData(i2c_base, Y_ADD_STA_A_0, YStart & 0xFF);
   PiCam_WriteRegData(i2c_base, Y_ADD_END_A_1, YEnd >> 8);
   PiCam_WriteRegData(i2c_base, Y_ADD_END_A_0, YEnd & 0xFF);
}

void PiCam_Output_activePixelX(u32 i2c_base, u16 XStart, u16 XEnd)
{
   // Max Active pixel 3280* 2464--imx219
   PiCam_WriteRegData(i2c_base, X_ADD_STA_A_1, XStart >> 8);
   PiCam_WriteRegData(i2c_base, X_ADD_STA_A_0, XStart & 0xFF);
   PiCam_WriteRegData(i2c_base, X_ADD_END_A_1, XEnd >> 8);
   PiCam_WriteRegData(i2c_base, X_ADD_END_A_0, XEnd & 0xFF);
}

void PiCam_Output_activePixelY(u32 i2c_base, u16 YStart, u16 YEnd)
{
   // Max Active pixel 3280* 2464--imx219
   PiCam_WriteRegData(i2c_base, Y_ADD_STA_A_1, YStart >> 8);
   PiCam_WriteRegData(i2c_base, Y_ADD_STA_A_0, YStart & 0xFF);
   PiCam_WriteRegData(i2c_base, Y_ADD_END_A_1, YEnd >> 8);
   PiCam_WriteRegData(i2c_base, Y_ADD_END_A_0, YEnd & 0xFF);
}

void PiCam_SetBinningMode(u32 i2c_base, u8 Xmode, u8 Ymode)
{
   // 0:no-binning
   // 1:x2-binning
   // 2:x4-binning
   // 3:x2 analog (special)

   if (Xmode >= 3)
      Xmode = 3;
   if (Ymode >= 3)
      Ymode = 3;

   PiCam_WriteRegData(i2c_base, BINNING_MODE_H_A, Xmode);
   PiCam_WriteRegData(i2c_base, BINNING_MODE_V_A, Ymode);
}

void PiCam_Output_ColorBarSize(u32 i2c_base, u16 X, u16 Y)
{
   PiCam_WriteRegData(i2c_base, TP_WINDOW_WIDTH_1, X >> 8);
   PiCam_WriteRegData(i2c_base, TP_WINDOW_WIDTH_0, X & 0xFF);
   PiCam_WriteRegData(i2c_base, TP_WINDOW_HEIGHT_1, Y >> 8);
   PiCam_WriteRegData(i2c_base, TP_WINDOW_HEIGHT_0, Y & 0xFF);
}

void PiCam_TestPattern(u32 i2c_base, u8 Enable, u8 mode, u16 X, u16 Y)
{
   // 0000h - no pattern (default)
   // 0001h - solid color
   // 0002h - 100 % color bars
   // 0003h - fade to grey color bar
   // 0004h - PN9
   // 0005h - 16 split color bar
   // 0006h - 16 split inverted color bar
   // 0007h - column counter
   // 0008h - inverted column counter
   // 0009h - PN31

   PiCam_WriteRegData(i2c_base, test_pattern_Ena, 0x00);

   if (Enable == 0)
      mode = 0;

   PiCam_WriteRegData(i2c_base, test_pattern_mode, mode);

   PiCam_Output_ColorBarSize(i2c_base, X, Y);
}

void PiCam_Gainfilter(u32 i2c_base, u8 AGain, u16 DGain)
{
   PiCam_WriteRegData(i2c_base, ANA_GAIN_GLOBAL_A, AGain & 0xFF);
   PiCam_WriteRegData(i2c_base, DIG_GAIN_GLOBAL_A_1, (DGain >> 8) & 0x0F);
   PiCam_WriteRegData(i2c_base, DIG_GAIN_GLOBAL_A_0, DGain & 0xFF);
}

// For cam1
void PiCam_init(u32 i2c_base)
{

   PiCam_WriteRegData(i2c_base, mode_select, 0x00);
   AccessCommSeq(i2c_base);
   PiCam_WriteRegData(i2c_base, CSI_LANE_MODE, 0x01);
   PiCam_WriteRegData(i2c_base, DPHY_CTRL, 0x00);
   PiCam_WriteRegData(i2c_base, EXCK_FREQ_1, 0x18);
   PiCam_WriteRegData(i2c_base, EXCK_FREQ_0, 0x00);
   PiCam_WriteRegData(i2c_base, FRM_LENGTH_A_1, 0x04);
   PiCam_WriteRegData(i2c_base, FRM_LENGTH_A_0, 0x59);

   PiCam_WriteRegData(i2c_base, LINE_LENGTH_A_1, 0x0D);
   PiCam_WriteRegData(i2c_base, LINE_LENGTH_A_0, 0x78);

   //   PiCam_Output_activePixel(i2c_base, 0, 3279, 0, 2463);
   PiCam_Output_activePixel(i2c_base, 680, 2599, 692, 1771); // Capture centre of sensor

   PiCam_Output_Size(i2c_base, 1920, 1080);
   // PiCam_Output_Size(i2c_base, 1280, 720);
   // PiCam_Output_Size(i2c_base, 640, 480);

   PiCam_WriteRegData(i2c_base, X_ODD_INC_A, 0x01);
   PiCam_WriteRegData(i2c_base, Y_ODD_INC_A, 0x01);

   // 0: No binning; 1: x2 binning; 2: x4 binning; 3: x2 binning (analog special)
   PiCam_SetBinningMode(i2c_base, 0, 0);

   PiCam_WriteRegData(i2c_base, CSI_DATA_FORMAT_A_1, 0x0A);
   PiCam_WriteRegData(i2c_base, CSI_DATA_FORMAT_A_0, 0x0A);

   PiCam_WriteRegData(i2c_base, VTPXCK_DIV, 0x05);
   PiCam_WriteRegData(i2c_base, VTSYCK_DIV, 0x01);
   PiCam_WriteRegData(i2c_base, PREPLLCK_VT_DIV, 0x03);
   PiCam_WriteRegData(i2c_base, PREPLLCK_OP_DIV, 0x03);
   PiCam_WriteRegData(i2c_base, PLL_VT_MPY_1, 0x00);
   PiCam_WriteRegData(i2c_base, PLL_VT_MPY_0, 0x39);
   PiCam_WriteRegData(i2c_base, OPPXCK_DIV, 0x0A);
   PiCam_WriteRegData(i2c_base, OPSYCK_DIV, 0x01);
   PiCam_WriteRegData(i2c_base, PLL_OP_MPY_1, 0x00);
   PiCam_WriteRegData(i2c_base, PLL_OP_MPY_0, 0x72);

   PiCam_WriteRegData(i2c_base, OPPXCK_DIV, 0x0A);
   PiCam_WriteRegData(i2c_base, OPSYCK_DIV, 0x01);
   PiCam_WriteRegData(i2c_base, PLL_OP_MPY_1, 0x00);
   PiCam_WriteRegData(i2c_base, PLL_OP_MPY_0, 0x72);

   PiCam_WriteRegData(i2c_base, mode_select, 0x01);

   PiCam_Gainfilter(i2c_base, 0xB9, 0x200);

   PiCam_WriteRegData(i2c_base, LINE_LENGTH_A_1, 0x0D);
   PiCam_WriteRegData(i2c_base, LINE_LENGTH_A_0, 0x78);

   /*
      //Shorter camera exposure time, suitable for standard light condition. Higher frame rate.
      PiCam_WriteRegData(i2c_base, FRM_LENGTH_A_1, 0x03);
      PiCam_WriteRegData(i2c_base, FRM_LENGTH_A_0, 0x71);
      PiCam_WriteRegData(i2c_base, COARSE_INTEGRATION_TIME_A_1, 0x04);
      PiCam_WriteRegData(i2c_base, COARSE_INTEGRATION_TIME_A_0, 0x54);
   */

   // Longer camera exposure time, suitable for low light condition. Trade-off with lower frame rate.
   PiCam_WriteRegData(i2c_base, FRM_LENGTH_A_1, 0x06);
   PiCam_WriteRegData(i2c_base, FRM_LENGTH_A_0, 0xE3);
   PiCam_WriteRegData(i2c_base, COARSE_INTEGRATION_TIME_A_1, 0x04);
   PiCam_WriteRegData(i2c_base, COARSE_INTEGRATION_TIME_A_0, 0x54);

   PiCam_WriteRegData(i2c_base, IMG_ORIENTATION_A, 0x00);
}
