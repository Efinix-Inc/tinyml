
#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h" //From BSP
#include "riscv.h"
#include "PiCamDriver.h"
#include "common.h"



void PiCam_WriteRegData(u16 reg,u8 data)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, 0x10<<1);
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

u8 PiCam_ReadRegData(u16 reg)
{
	u8 outdata;

    i2c_masterStartBlocking(I2C_CTRL_MIPI);

    i2c_txByte(I2C_CTRL_MIPI, 0x10<<1);
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

	i2c_txByte(I2C_CTRL_MIPI, (0x10<<1) | 0x01);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxAck(I2C_CTRL_MIPI)); // Optional check

	i2c_txByte(I2C_CTRL_MIPI, 0xFF);
	i2c_txNackBlocking(I2C_CTRL_MIPI);
	assert(i2c_rxNack(I2C_CTRL_MIPI)); // Optional check
	outdata = i2c_rxData(I2C_CTRL_MIPI);

	i2c_masterStopBlocking(I2C_CTRL_MIPI);

	return outdata;
}
void AccessCommSeq(void)
{
	PiCam_WriteRegData(0x30EB, 0x05);
	PiCam_WriteRegData(0x30EB, 0x0C);
	PiCam_WriteRegData(0x300A, 0xFF);
	PiCam_WriteRegData(0x300B, 0xFF);
	PiCam_WriteRegData(0x30EB, 0x05);
	PiCam_WriteRegData(0x30EB, 0x09);
}

void PiCam_Output_Size(u16 X,u16 Y)
{
	PiCam_WriteRegData(x_output_size_A_1	, X>>8);
	PiCam_WriteRegData(x_output_size_A_0	, X & 0xFF);
	PiCam_WriteRegData(y_output_size_A_1	, Y>>8);
	PiCam_WriteRegData(y_output_size_A_0	, Y & 0xFF);
}

void PiCam_Output_activePixel(u16 XStart,u16 XEnd, u16 YStart, u16 YEnd)
{

	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(X_ADD_STA_A_1	, XStart>>8);
	PiCam_WriteRegData(X_ADD_STA_A_0	, XStart&0xFF);
	PiCam_WriteRegData(X_ADD_END_A_1	, XEnd>>8);
	PiCam_WriteRegData(X_ADD_END_A_0	, XEnd&0xFF);

	PiCam_WriteRegData(Y_ADD_STA_A_1	, YStart>>8);
	PiCam_WriteRegData(Y_ADD_STA_A_0	, YStart&0xFF);
	PiCam_WriteRegData(Y_ADD_END_A_1	, YEnd>>8);
	PiCam_WriteRegData(Y_ADD_END_A_0	, YEnd&0xFF);
}

void PiCam_Output_activePixelX(u16 XStart,u16 XEnd)
{
	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(X_ADD_STA_A_1	, XStart>>8);
	PiCam_WriteRegData(X_ADD_STA_A_0	, XStart&0xFF);
	PiCam_WriteRegData(X_ADD_END_A_1	, XEnd>>8);
	PiCam_WriteRegData(X_ADD_END_A_0	, XEnd&0xFF);
}

void PiCam_Output_activePixelY(u16 YStart,u16 YEnd)
{
	//Max Active pixel 3280* 2464--imx219

	PiCam_WriteRegData(Y_ADD_STA_A_1	, YStart>>8);
	PiCam_WriteRegData(Y_ADD_STA_A_0	, YStart&0xFF);
	PiCam_WriteRegData(Y_ADD_END_A_1	, YEnd>>8);
	PiCam_WriteRegData(Y_ADD_END_A_0	, YEnd&0xFF);
}

void PiCam_SetBinningMode(u8 Xmode, u8 Ymode)
{
	//0:no-binning
	//1:x2-binning
	//2:x4-binning
	//3:x2 analog (special)

	if(Xmode>=3)	Xmode=3;
	if(Ymode>=3)	Ymode=3;

	PiCam_WriteRegData(BINNING_MODE_H_A, Xmode);
	PiCam_WriteRegData(BINNING_MODE_V_A, Ymode);
}

void PiCam_Output_ColorBarSize(u16 X,u16 Y)
{
	PiCam_WriteRegData(TP_WINDOW_WIDTH_1	, X>>8);
	PiCam_WriteRegData(TP_WINDOW_WIDTH_0	, X & 0xFF);
	PiCam_WriteRegData(TP_WINDOW_HEIGHT_1	, Y>>8);
	PiCam_WriteRegData(TP_WINDOW_HEIGHT_0	, Y & 0xFF);
}

void PiCam_TestPattern(u8 Enable,u8 mode,u16 X,u16 Y)
{
	//0000h - no pattern (default)
	//0001h - solid color
	//0002h - 100 % color bars
	//0003h - fade to grey color bar
	//0004h - PN9
	//0005h - 16 split color bar
	//0006h - 16 split inverted color bar
	//0007h - column counter
	//0008h - inverted column counter
	//0009h - PN31

	PiCam_WriteRegData(test_pattern_Ena, 0x00);

	if(Enable==0)	mode=0;

	PiCam_WriteRegData(test_pattern_mode, mode);

	PiCam_Output_ColorBarSize(X,Y);
}

void PiCam_Gainfilter(u8 AGain, u16 DGain)
{
	PiCam_WriteRegData(ANA_GAIN_GLOBAL_A, AGain&0xFF);
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_1, (DGain>>8)&0x0F);
	PiCam_WriteRegData(DIG_GAIN_GLOBAL_A_0, DGain&0xFF);
}



void PiCam_init(void)
{
   PiCam_WriteRegData(mode_select, 0x00);
   AccessCommSeq();
   PiCam_WriteRegData(CSI_LANE_MODE, 0x01);
   PiCam_WriteRegData(DPHY_CTRL, 0x00);
   PiCam_WriteRegData(EXCK_FREQ_1, 0x18);
   PiCam_WriteRegData(EXCK_FREQ_0, 0x00);
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x04);
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0x59);

   PiCam_WriteRegData(LINE_LENGTH_A_1, 0x0D);
   PiCam_WriteRegData(LINE_LENGTH_A_0, 0x78);

   //PiCam_Output_activePixel(0, 3279, 0, 2463);
   PiCam_Output_activePixel(680, 3279, 0, 2463); //Use offset to have central view for 1920 frame width

   PiCam_Output_Size(1920, 1080);
   //PiCam_Output_Size(1280, 720);
   //PiCam_Output_Size(640, 480);

   PiCam_WriteRegData(X_ODD_INC_A, 0x01);
   PiCam_WriteRegData(Y_ODD_INC_A, 0x01);

   //0: No binning; 1: x2 binning; 2: x4 binning; 3: x2 binning (analog special)
   PiCam_SetBinningMode(0, 0);

   PiCam_WriteRegData(CSI_DATA_FORMAT_A_1, 0x0A);
   PiCam_WriteRegData(CSI_DATA_FORMAT_A_0, 0x0A);

   PiCam_WriteRegData(VTPXCK_DIV, 0x05);
   PiCam_WriteRegData(VTSYCK_DIV, 0x01);
   PiCam_WriteRegData(PREPLLCK_VT_DIV, 0x03);
   PiCam_WriteRegData(PREPLLCK_OP_DIV, 0x03);
   PiCam_WriteRegData(PLL_VT_MPY_1, 0x00);
   PiCam_WriteRegData(PLL_VT_MPY_0, 0x39);
   PiCam_WriteRegData(OPPXCK_DIV, 0x0A);
   PiCam_WriteRegData(OPSYCK_DIV, 0x01);
   PiCam_WriteRegData(PLL_OP_MPY_1, 0x00);
   PiCam_WriteRegData(PLL_OP_MPY_0, 0x72);

   PiCam_WriteRegData(OPPXCK_DIV, 0x0A);
   PiCam_WriteRegData(OPSYCK_DIV, 0x01);
   PiCam_WriteRegData(PLL_OP_MPY_1, 0x00);
   PiCam_WriteRegData(PLL_OP_MPY_0, 0x72);

   PiCam_WriteRegData(mode_select, 0x01);

   PiCam_Gainfilter(0xB9, 0x200);

   PiCam_WriteRegData(LINE_LENGTH_A_1, 0x0D);
   PiCam_WriteRegData(LINE_LENGTH_A_0, 0x78);
   
/*
   //Shorter camera exposure time. Higher frame rate. 48 fps
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x03);
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0x71);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_1, 0x04);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_0, 0x54);
*/
/*
   //Longer camera exposure time. Trade-off with lower frame rate. 30fps
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x06);
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0xE3);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_1, 0x04);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_0, 0x54);
*/

   //Longer camera exposure time, suitable for low light condition. Trade-off with lower frame rate. 20 fps
   PiCam_WriteRegData(FRM_LENGTH_A_1, 0x0A);
   PiCam_WriteRegData(FRM_LENGTH_A_0, 0xA8);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_1, 0x0A);
   PiCam_WriteRegData(COARSE_INTEGRATION_TIME_A_0, 0x54);

   PiCam_WriteRegData(IMG_ORIENTATION_A, 0x00);
}
