////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/evsoc/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

#include "bsp.h"
#include "i2c.h"
#include "riscv.h"
#include "PiCamV3Driver.h"
#include "common.h"

void PiCamV3_WriteRegData(u32 i2c_addr, u16 reg, u8 data)
{
	u8 outdata;

	i2c_masterStartBlocking(i2c_addr);

	i2c_txByte(i2c_addr, IMX708_I2C_ADDRESS << 1);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr)); // Optional check

	i2c_txByte(i2c_addr, (reg >> 8) & 0xFF);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr)); // Optional check

	i2c_txByte(i2c_addr, (reg) & 0xFF);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr)); // Optional check

	i2c_txByte(i2c_addr, data & 0xFF);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr)); // Optional check

	i2c_masterStopBlocking(i2c_addr);
}

u8 PiCamV3_ReadRegData(u32 i2c_addr, u16 reg)
{
	u8 outdata;

	i2c_masterStartBlocking(i2c_addr);

	i2c_txByte(i2c_addr, IMX708_I2C_ADDRESS << 1);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr)); // Optional check

	i2c_txByte(i2c_addr, (reg >> 8) & 0xFF);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr)); // Optional check

	i2c_txByte(i2c_addr, (reg) & 0xFF);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr)); // Optional check

	i2c_masterStopBlocking(i2c_addr);
	i2c_masterStartBlocking(i2c_addr);

	i2c_txByte(i2c_addr, (0x1A << 1) | 0x01);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr)); // Optional check

	i2c_txByte(i2c_addr, 0xFF);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxNack(i2c_addr)); // Optional check
	outdata = i2c_rxData(i2c_addr);

	i2c_masterStopBlocking(i2c_addr);

	return outdata;
}

void PiCamV3_StartStreaming(u32 i2c_addr)
{
	PiCamV3_WriteRegData(i2c_addr, IMX708_MODE_SELECT, IMX708_ACTIVE);
}

void PiCamV3_StopStreaming(u32 i2c_addr)
{
	PiCamV3_WriteRegData(i2c_addr, IMX708_MODE_SELECT, IMX708_SLEEP);
}

void PiCamV3_ConfigCommon(u32 i2c_addr)
{
	for (int i = 0; i < sizeof(mode_common_regs) / sizeof(mode_common_regs[0]); i++)
	{
		PiCamV3_WriteRegData(i2c_addr, mode_common_regs[i].address, mode_common_regs[i].val);
	}
}

void PiCamV3_ConfigFormat(u32 i2c_addr, u8 mode)
{
	// 	MODE
	//  0 : 1920 x 1080 cropped, 50FPS
	//	1 : 1920 x 1080 2x2 binned, 60 FPS
	//  2 : 1920 x 1080 HDR, 50 FPS

	if (mode == 0)
	{
		for (int i = 0; i < sizeof(mode_1920x1080_cropped_regs) / sizeof(mode_1920x1080_cropped_regs[0]); i++)
		{
			PiCamV3_WriteRegData(i2c_addr, mode_1920x1080_cropped_regs[i].address, mode_1920x1080_cropped_regs[i].val);
		}
	}

	else if (mode == 1)
	{
		for (int i = 0; i < sizeof(mode_2x2binned_1920x1080_regs) / sizeof(mode_2x2binned_1920x1080_regs[0]); i++)
		{
			PiCamV3_WriteRegData(i2c_addr, mode_2x2binned_1920x1080_regs[i].address, mode_2x2binned_1920x1080_regs[i].val);
		}
	}

	else if (mode == 2)
	{
		for (int i = 0; i < sizeof(mode_hdr_1920x1080_regs) / sizeof(mode_hdr_1920x1080_regs[0]); i++)
		{
			PiCamV3_WriteRegData(i2c_addr, mode_hdr_1920x1080_regs[i].address, mode_hdr_1920x1080_regs[i].val);
		}
	}
}

void PiCamV3_ConfigLinkFreq(u32 i2c_addr)
{
	for (int i = 0; i < sizeof(link_450Mhz_regs) / sizeof(link_450Mhz_regs[0]); i++)
	{
		PiCamV3_WriteRegData(i2c_addr, link_450Mhz_regs[i].address, link_450Mhz_regs[i].val);
	}
}

void PiCamV3_ConfigQuadBayerRemosaicAdjustment(u32 i2c_addr)
{
	PiCamV3_WriteRegData(i2c_addr, IMX708_LPF_INTENSITY_EN, IMX708_LPF_INTENSITY_ENABLED);
	PiCamV3_WriteRegData(i2c_addr, IMX708_LPF_INTENSITY, 0x04);
}

void PiCamV3_SetPdafGain(u32 i2c_addr)
{
	for (int i = 0; i < 54; i++)
	{
		PiCamV3_WriteRegData(i2c_addr, IMX708_REG_BASE_SPC_GAINS_L + i, pdaf_gains[0][i % 9]);
		PiCamV3_WriteRegData(i2c_addr, IMX708_REG_BASE_SPC_GAINS_R + i, pdaf_gains[1][i % 9]);
	}
}

void PiCamV3_SetExposure(u32 i2c_addr, u16 val)
{
	PiCamV3_WriteRegData(i2c_addr, IMX708_REG_EXPOSURE, (val & 0xFF00) >> 8);
	PiCamV3_WriteRegData(i2c_addr, IMX708_REG_EXPOSURE + 1, val & 0xFF);
}

void PiCamV3_SetAnalogueGain(u32 i2c_addr, u16 val)
{
	if (val > IMX708_ANA_GAIN_MAX)
		val = IMX708_ANA_GAIN_MAX;

	if (val < IMX708_ANA_GAIN_MIN)
		val = IMX708_ANA_GAIN_MIN;

	PiCamV3_WriteRegData(i2c_addr, IMX708_REG_ANALOG_GAIN, (val & 0xFF00) >> 8);
	PiCamV3_WriteRegData(i2c_addr, IMX708_REG_ANALOG_GAIN + 1, val & 0xFF);
}

void PiCamV3_SetDigitalGain(u32 i2c_addr, u16 val)
{
	if (val > IMX708_DGTL_GAIN_MAX)
		val = IMX708_DGTL_GAIN_MAX;

	if (val < IMX708_DGTL_GAIN_MIN)
		val = IMX708_DGTL_GAIN_MIN;

	PiCamV3_WriteRegData(i2c_addr, IMX708_REG_DIGITAL_GAIN, (val & 0xFF00) >> 8);
	PiCamV3_WriteRegData(i2c_addr, IMX708_REG_DIGITAL_GAIN + 1, val & 0xFF);
}

void PiCamV3_OnActuator(u32 i2c_addr)
{
	// Turn on actuator
	i2c_masterStartBlocking(i2c_addr);
	i2c_txByte(i2c_addr, DW9807_I2C_ADDRESS << 1);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_txByte(i2c_addr, DW9807_CTL_ADDR);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_txByte(i2c_addr, DW9807_ACTIVE);
	i2c_txNackBlocking(i2c_addr);
	i2c_masterStopBlocking(i2c_addr);
}

void PiCamV3_OffActuator(u32 i2c_addr)
{
	// Turn off actuator
	i2c_masterStartBlocking(i2c_addr);
	i2c_txByte(i2c_addr, DW9807_I2C_ADDRESS << 1);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_txByte(i2c_addr, DW9807_CTL_ADDR);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_txByte(i2c_addr, DW9807_SLEEP);
	i2c_txNackBlocking(i2c_addr);
	i2c_masterStopBlocking(i2c_addr);
}

void PiCamV3_SetFocusStep(u32 i2c_addr, u32 focus_step)
{
	if (focus_step >= DW9807_MAX_FOCUS_POS)
		focus_step = DW9807_MAX_FOCUS_POS;
	else if (focus_step <= 0)
		focus_step = 0;

	i2c_masterStartBlocking(i2c_addr);
	i2c_txByte(i2c_addr, DW9807_I2C_ADDRESS << 1);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_txByte(i2c_addr, DW9807_MSB_ADDR);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_txByte(i2c_addr, (focus_step >> 8) & 0x03);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_masterStopBlocking(i2c_addr);

	i2c_masterStartBlocking(i2c_addr);
	i2c_txByte(i2c_addr, DW9807_I2C_ADDRESS << 1);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_txByte(i2c_addr, DW9807_LSB_ADDR);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_txByte(i2c_addr, focus_step & 0xFF);
	i2c_txNackBlocking(i2c_addr);
	assert(i2c_rxAck(i2c_addr));
	i2c_masterStopBlocking(i2c_addr);
}

/* Under Development
u32 PiCamV3_GetFrameRate()
{
	u32 LINE_LENGTH = 0x3D20; //reg 0x0342 and 0x0343
	u32 WIDTH = 1920;
	u32 HEIGHT = 1080;
	u32 H_BLANK = LINE_LENGTH - WIDTH;
	u32 V_BLANK = 40;
	// frame rate = px_rate/(line length * frame length)
	u32 frame_rate = IMX708_INITIAL_PIXEL_RATE / ((WIDTH + H_BLANK )* (HEIGHT + V_BLANK) );
	return frame_rate;
}

void PiCamV3_SetExposureRange(u32 mode)
{
	u32 HEIGHT = 1080;
	u32 V_BLANK = 58;
	u32 exposure_max;

	exposure_max = HEIGHT +  V_BLANK - IMX708_EXPOSURE_OFFSET;
}

void PiCamV3_SetTestPattern(void)
{
	//PiCamV3_WriteRegData(IMX708_REG_TEST_PATTERN, IMX708_TEST_PATTERN_DISABLE);
	PiCamV3_WriteRegData(IMX708_REG_TEST_PATTERN, IMX708_TEST_PATTERN_SOLID_COLOR);
}
*/

void PiCamV3_Init(u32 i2c_addr)
{

	PiCamV3_StopStreaming(i2c_addr);

	PiCamV3_ConfigCommon(i2c_addr);

	PiCamV3_SetPdafGain(i2c_addr);

	PiCamV3_ConfigFormat(i2c_addr, 1);

	PiCamV3_ConfigLinkFreq(i2c_addr);

	PiCamV3_ConfigQuadBayerRemosaicAdjustment(i2c_addr);

	PiCamV3_OnActuator(i2c_addr);

	PiCamV3_SetFocusStep(i2c_addr, 700);

	PiCamV3_OffActuator(i2c_addr);

	//	PiCamV3_StartStreaming();

}
