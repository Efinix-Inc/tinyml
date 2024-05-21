
#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h" //From BSP
#include "riscv.h"
#include "PiCamV3Driver.h"
#include "common.h"

void PiCamV3_WriteRegData(u16 reg,u8 data)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, IMX708_I2C_ADDRESS<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, data & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
}

u8 PiCamV3_ReadRegData(u16 reg)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, IMX708_I2C_ADDRESS<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg>>8) & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, (reg) & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_masterStopBlocking(I2C_CTRL_MIPI);
	i2c_masterStartBlocking(I2C_CTRL_MIPI);

	i2c_txByte(I2C_CTRL_MIPI, (0x1A<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
	outdata = i2c_rxData(I2C_CTRL_MIPI);

	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return outdata;
}

void PiCamV3_StartStreaming()
{
	PiCamV3_WriteRegData(IMX708_MODE_SELECT, IMX708_ACTIVE);
}

void PiCamV3_StopStreaming()
{
	PiCamV3_WriteRegData(IMX708_MODE_SELECT, IMX708_SLEEP);
}

void PiCamV3_ConfigCommon()
{
	for (int i = 0; i < sizeof(mode_common_regs)/sizeof(mode_common_regs[0]); i++) {
		PiCamV3_WriteRegData(mode_common_regs[i].address,mode_common_regs[i].val);
	}
}

void PiCamV3_ConfigFormat(u8 mode)
{
	// 	MODE
	//  0 : 1920 x 1080 cropped, 50FPS
	//	1 : 1920 x 1080 2x2 binned, 60 FPS
	//  2 : 1920 x 1080 HDR, 50 FPS

	if (mode == 0) {
		for (int i = 0; i < sizeof(mode_1920x1080_cropped_regs)/sizeof(mode_1920x1080_cropped_regs[0]); i++) {
			PiCamV3_WriteRegData(mode_1920x1080_cropped_regs[i].address,mode_1920x1080_cropped_regs[i].val);
		}
	}

	else if (mode == 1) {
		for (int i = 0; i < sizeof(mode_2x2binned_1920x1080_regs)/sizeof(mode_2x2binned_1920x1080_regs[0]); i++) {
			PiCamV3_WriteRegData(mode_2x2binned_1920x1080_regs[i].address,mode_2x2binned_1920x1080_regs[i].val);
		}
	}

	else if (mode == 2) {
		for (int i = 0; i < sizeof(mode_hdr_1920x1080_regs)/sizeof(mode_hdr_1920x1080_regs[0]); i++) {
			PiCamV3_WriteRegData(mode_hdr_1920x1080_regs[i].address,mode_hdr_1920x1080_regs[i].val);
		}
	}

}

void PiCamV3_ConfigLinkFreq()
{
	for (int i = 0; i < sizeof(link_450Mhz_regs)/sizeof(link_450Mhz_regs[0]); i++) {
		PiCamV3_WriteRegData(link_450Mhz_regs[i].address,link_450Mhz_regs[i].val);
	}
}

void PiCamV3_ConfigQuadBayerRemosaicAdjustment()
{
	PiCamV3_WriteRegData(IMX708_LPF_INTENSITY_EN, IMX708_LPF_INTENSITY_ENABLED);
	PiCamV3_WriteRegData(IMX708_LPF_INTENSITY, 0x04);
}

void PiCamV3_SetPdafGain()
{
	for (int i = 0; i < 54 ;i++) {
		PiCamV3_WriteRegData(IMX708_REG_BASE_SPC_GAINS_L + i, pdaf_gains[0][i%9]);
		PiCamV3_WriteRegData(IMX708_REG_BASE_SPC_GAINS_R + i, pdaf_gains[1][i%9]);
	}
}

void PiCamV3_SetExposure(u16 val)
{
	PiCamV3_WriteRegData(IMX708_REG_EXPOSURE, (val & 0xFF00) >> 8);
	PiCamV3_WriteRegData(IMX708_REG_EXPOSURE + 1, val & 0xFF);
}

void PiCamV3_SetAnalogueGain(u16 val)
{
	if (val > IMX708_ANA_GAIN_MAX)
		val = IMX708_ANA_GAIN_MAX;

	if (val < IMX708_ANA_GAIN_MIN)
		val = IMX708_ANA_GAIN_MIN;

	PiCamV3_WriteRegData(IMX708_REG_ANALOG_GAIN , (val & 0xFF00) >> 8);
	PiCamV3_WriteRegData(IMX708_REG_ANALOG_GAIN + 1 , val & 0xFF);

}

void PiCamV3_SetDigitalGain(u16 val)
{
	if (val > IMX708_DGTL_GAIN_MAX)
		val = IMX708_DGTL_GAIN_MAX;

	if (val < IMX708_DGTL_GAIN_MIN)
			val = IMX708_DGTL_GAIN_MIN;

	PiCamV3_WriteRegData(IMX708_REG_DIGITAL_GAIN , (val & 0xFF00) >> 8);
	PiCamV3_WriteRegData(IMX708_REG_DIGITAL_GAIN + 1 , val & 0xFF);

}

void PiCamV3_OnActuator()
{
	// Turn on actuator
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
	i2c_txByte(I2C_CTRL_MIPI, DW9807_I2C_ADDRESS<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_txByte(I2C_CTRL_MIPI, DW9807_CTL_ADDR);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_txByte(I2C_CTRL_MIPI, DW9807_ACTIVE);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
}

void PiCamV3_OffActuator()
{
	// Turn off actuator
	i2c_masterStartBlocking(I2C_CTRL_MIPI);
	i2c_txByte(I2C_CTRL_MIPI, DW9807_I2C_ADDRESS<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_txByte(I2C_CTRL_MIPI, DW9807_CTL_ADDR);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_txByte(I2C_CTRL_MIPI, DW9807_SLEEP);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
}

void PiCamV3_SetFocusStep(u32 focus_step)
{
	if (focus_step >= DW9807_MAX_FOCUS_POS)
		focus_step = DW9807_MAX_FOCUS_POS;
	else if (focus_step <= 0)
		focus_step = 0;

	i2c_masterStartBlocking(I2C_CTRL_MIPI);
	i2c_txByte(I2C_CTRL_MIPI, DW9807_I2C_ADDRESS<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_txByte(I2C_CTRL_MIPI, DW9807_MSB_ADDR);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_txByte(I2C_CTRL_MIPI, (focus_step >> 8) & 0x03);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	i2c_masterStartBlocking(I2C_CTRL_MIPI);
	i2c_txByte(I2C_CTRL_MIPI, DW9807_I2C_ADDRESS<<1);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_txByte(I2C_CTRL_MIPI, DW9807_LSB_ADDR);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_txByte(I2C_CTRL_MIPI, focus_step & 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI));
	i2c_masterStopBlocking(I2C_CTRL_MIPI);
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

void PiCamV3_Init()
{

	PiCamV3_StopStreaming();

	PiCamV3_ConfigCommon();

	PiCamV3_SetPdafGain();

	PiCamV3_ConfigFormat(1);

	PiCamV3_ConfigLinkFreq();

	PiCamV3_ConfigQuadBayerRemosaicAdjustment();

	PiCamV3_OnActuator();

	PiCamV3_SetFocusStep(300);

	PiCamV3_OffActuator();

//	PiCamV3_StartStreaming();

	uart_writeStr(BSP_UART_TERMINAL, "\n\rDone Camera Init");
}
