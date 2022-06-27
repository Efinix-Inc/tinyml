/*
 * PiCamDriver.h
 *
 *  Created on: 14 May 2020
 *      Author: root
 */

#ifndef SRC_PICAMDRIVER_H_
#define SRC_PICAMDRIVER_H_
#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h" //BSP



//Status Registers – [0x0000-0x001B] (Read Only Dynamic Registers)
#define MODEL_ID1					0x0000	//[15:8]
#define MODEL_ID0					0x0001	//[7:0]
#define Lot_ID2						0x0004	//[23:16]
#define Lot_ID1						0x0005	//[15:8]
#define Lot_ID0						0x0006	//[7:0]
#define Wafer_Num					0x0007
#define Chip_Number1				0x000D	//[15:8]
#define Chip_Number0				0x000E	//[7:0]
#define FRM_CNT						0x0018
#define Chip_number					0x0019
#define DT_PEDESTAL1				0x001A	//[9:8]
#define DT_PEDESTAL0				0x001B	//[7:0]

// Frame Format Description – [0x0040-0x0047] (Read only)
#define FRM_FMT_TYPE				0x0040
#define FRM_FMT_SUBTYPE				0x0041
#define FRM_FMT_DESC0_1				0x0042	//[15:8]
#define FRM_FMT_DESC0_0				0x0043	//[7:0]
#define FRM_FMT_DESC1_1				0x0044	//[15:8]
#define FRM_FMT_DESC1_0				0x0045	//[7:0]
#define FRM_FMT_DESC2_1				0x0046	//[15:8]
#define FRM_FMT_DESC2_0				0x0047	//[7:0]


//Analogue Gain Description Registers – [0x0080-0x0093]	(Read Only)
#define analogue_gain_capability	0x0081	//[7:0]
#define analogue_gain_code_min		0x0085	//[7:0]
#define analogue_gain_code_max		0x0086	//[7:0]
#define analogue_gain_code_step		0x0088	//[7:0]
#define analogue_gain_code_type		0x008A	//[7:0]
#define analogue_gain_code_m0		0x008C	//[7:0]
#define analogue_gain_code_c0		0x008E	//[7:0]
#define analogue_gain_code_m1		0x0090	//[7:0]
#define analogue_gain_code_c1		0x0092	//[7:0]

//Data Format Description – [0x00C0-0x00D1]	(Read Only)
#define DT_FMT_TYPE					0x00C0
#define DT_FMT_SUBTYPE				0x00C1
#define DT_FMT_DESC0_1				0x00C2	//[15:8]
#define DT_FMT_DESC0_0				0x00C3	//[7:0]
#define DT_FMT_DESC1_1				0x00C4	//[15:8]
#define DT_FMT_DESC1_0				0x00C5	//[7:0]

//General Set-up Registers – [0x0100-0x0106]	(Read and Write)
#define mode_select					0x0100
#define software_reset				0x0103
#define corrupted_frame_status		0x0104
#define mask_corrupted_frames		0x0105
#define fast_standby_enable			0x0106

//Output Set-up Registers – [0x0110-0x0147]		(Read and Write)
#define CSI_CH_ID					0x0110	//[1:0]
#define CSI_SIG_MODE				0x0111	//[1:0]
#define CSI_LANE_MODE				0x0114	//[1:0]
#define TCLK_POST_1					0x0118	//[8]
#define TCLK_POST_0					0x0119	//[7:0]
#define THS_PREPARE_1				0x011A	//[8]
#define THS_PREPARE_0				0x011B	//[7:0]
#define THS_ZERO_MIN_1				0x011C	//[8]
#define THS_ZERO_MIN_0				0x011D	//[7:0]
#define THS_TRAIL_1					0x011E	//[8]
#define THS_TRAIL_0					0x011F	//[7:0]
#define TCLK_TRAIL_MIN_1			0x0120	//[8]
#define TCLK_TRAIL_MIN_0			0x0121	//[7:0]
#define TCLK_PREPARE_1				0x0122	//[8]
#define TCLK_PREPARE_0				0x0123	//[7:0]
#define TCLK_ZERO_1					0x0124	//[8]
#define TCLK_ZERO_0					0x0125	//[7:0]
#define TLPX_1						0x0126	//[8]
#define TLPX_0						0x0127	//[7:0]
#define DPHY_CTRL					0x0128	//[0]	0: auto 1:manual
#define EXCK_FREQ_1					0x012A	//[15:8]
#define EXCK_FREQ_0					0x012B	//[7:0]
#define TEMPERATURE					0x0140	//[7] Enable [6:0] val
#define READOUT_V_CNT_1				0x0142	//[15:8]
#define READOUT_V_CNT_0				0x0143	//[7:0]
#define VSYNC_POL					0x0144	//[0]	0:low active 1:high active
#define	FLASH_POL					0x0145	//[0]	0:High-active 1:Lo-active
#define	VSYNC						0x0147	//[0]	0:Vsync 1:Reserved

//Frame Bank Control Registers - [0x0150-0x0153]	(Read and Write)
#define FRAME_BANK_CTRL				0x0150	//[1:0]	[1]Status [0]Enable
#define FRAME_BANK_FRM_CNT			0x0151	//[7:0]
#define FRAME_BANK_FAST_TRACKING	0x0152	//[0]

//Frame Bank Registers Group “A”- [0x0154-0x018D]	(Read and Write)

#define FRAME_DURATION_A			0x0154
#define	COMP_ENABLE_A				0x0155
#define	ANA_GAIN_GLOBAL_A			0x0157
#define	DIG_GAIN_GLOBAL_A_1			0x0158	//[11:8]
#define	DIG_GAIN_GLOBAL_A_0			0x0159	//[7:0]
#define	COARSE_INTEGRATION_TIME_A_1	0x015A	//[15:8]
#define	COARSE_INTEGRATION_TIME_A_0	0x015B	//[15:8]
#define	SENSOR_MODE_A				0x015D	//[0]	0:ERS
#define	FRM_LENGTH_A_1				0x0160	//[15:8]
#define	FRM_LENGTH_A_0				0x0161	//[7:0]


#define LINE_LENGTH_A_1				0x0162//[15:8]
#define LINE_LENGTH_A_0				0x0163//[7:0]
#define X_ADD_STA_A_1				0x0164//[11:8]
#define X_ADD_STA_A_0				0x0165//[7:0]
#define X_ADD_END_A_1				0x0166//[11:8]
#define X_ADD_END_A_0				0x0167//[7:0]
#define Y_ADD_STA_A_1				0x0168//[11:8]
#define Y_ADD_STA_A_0				0x0169//[7:0]
#define Y_ADD_END_A_1				0x016A//[11:8]
#define Y_ADD_END_A_0				0x016B//[7:0]
#define x_output_size_A_1			0x016C//[11:8]
#define x_output_size_A_0			0x016D//[7:0]
#define y_output_size_A_1			0x016E//[11:8]
#define y_output_size_A_0			0x016F//[7:0]


#define	X_ODD_INC_A					0x0170
#define	Y_ODD_INC_A					0x0171
#define	IMG_ORIENTATION_A			0x0172	//[1:0]
#define	BINNING_MODE_H_A			0x0174	//[1:0]
#define	BINNING_MODE_V_A			0x0175	//[1:0]
#define	BINNING_CAL_MODE_H_A		0x0176	//[0]
#define	BINNING_CAL_MODE_V_A		0x0177	//[0]
#define	ANA_GAIN_GLOBAL_SHORT_A		0x0189
#define	COARSE_INTEG_TIME_SHORT_A_1	0x018A	//[15:8]
#define	COARSE_INTEG_TIME_SHORT_A_0	0x018B	//[7:0]
#define	CSI_DATA_FORMAT_A_1 		0x018C	//[15:8]
#define	CSI_DATA_FORMAT_A_0			0x018D	//[7:0]

//Frame Bank Registers Group “B”- [0x0254-0x028D]	(Read and Write)

#define FRAME_DURATION_B			0x0254
#define	COMP_ENABLE_B				0x0255
#define	ANA_GAIN_GLOBAL_B			0x0257
#define	DIG_GAIN_GLOBAL_B_1			0x0258	//[11:8]
#define	DIG_GAIN_GLOBAL_B_0			0x0259	//[7:0]
#define	COARSE_INTEGRATION_TIME_B_1	0x025A	//[15:8]
#define	COARSE_INTEGRATION_TIME_B_0	0x025B	//[15:8]
#define	SENSOR_MODE_B				0x025D	//[0]	0:ERS
#define	FRM_LENGTH_B_1				0x0260	//[15:8]
#define	FRM_LENGTH_B_0				0x0261	//[7:0]


#define LINE_LENGTH_B_1				0x0262//[15:8]
#define LINE_LENGTH_B_0				0x0263//[7:0]
#define X_ADD_STA_B_1				0x0264//[11:8]
#define X_ADD_STA_B_0				0x0265//[7:0]
#define X_ADD_END_B_1				0x0266//[11:8]
#define X_ADD_END_B_0				0x0267//[7:0]
#define Y_ADD_STA_B_1				0x0268//[11:8]
#define Y_ADD_STA_B_0				0x0269//[7:0]
#define Y_ADD_END_B_1				0x026A//[11:8]
#define Y_ADD_END_B_0				0x026B//[7:0]
#define x_output_size_B_1			0x026C//[11:8]
#define x_output_size_B_0			0x026D//[7:0]
#define y_output_size_B_1			0x026E//[11:8]
#define y_output_size_B_0			0x026F//[7:0]


#define	X_ODD_INC_B					0x0270
#define	Y_ODD_INC_B					0x0271
#define	IMG_ORIENTATION_B			0x0272	//[1:0]
#define	BINNING_MODE_H_B			0x0274	//[1:0]
#define	BINNING_MODE_V_B			0x0275	//[1:0]
#define	BINNING_CAL_MODE_H_B		0x0276	//[0]
#define	BINNING_CAL_MODE_V_B		0x0277	//[0]
#define	ANA_GAIN_GLOBAL_SHORT_B		0x0289
#define	COARSE_INTEG_TIME_SHORT_B_1	0x028A	//[15:8]
#define	COARSE_INTEG_TIME_SHORT_B_0	0x028B	//[7:0]
#define	CSI_DATA_FORMAT_B_1 		0x028C	//[15:8]
#define	CSI_DATA_FORMAT_B_0			0x028D	//[7:0]

//Clock Set-up Registers – [0x0300-0x0313]	(Read and Write)


#define VTPXCK_DIV					0x0301
#define VTSYCK_DIV					0x0303
#define PREPLLCK_VT_DIV				0x0304
#define PREPLLCK_OP_DIV				0x0305
#define PLL_VT_MPY_1				0x0306	//[10:8]
#define PLL_VT_MPY_0				0x0307	//[7:0]
#define OPPXCK_DIV					0x0309	//[4:0]
#define OPSYCK_DIV					0x030B	//[1:0]
#define PLL_OP_MPY_1				0x030C	//[10:8]
#define PLL_OP_MPY_0				0x030D	//[7:0]


//Flash Control (ERS) Registers – [0x0320-0x0338]	(Read and Write)

#define FLASH_START_TRIG			0x0320
#define FLASH_STATUS				0x0321
#define FLASH_STROBE_DIV			0x0322//[7:0]
#define FLASH_STROBE_OUTPUT_ENABLE	0x0324
#define FLASH_MODE					0x032E	//[1:0] 0:shutter single 1:shutter continue 2:vcnt single
#define FLASH_REF_MODE				0x032F	//[0]
#define FLASH_STROBE_REF_1			0x0330	//[15:8]
#define FLASH_STROBE_REF_0			0x0331	//[7:0]
#define FLASH_STROBE_LATENCY_RS_1	0x0332	//[15:8]
#define FLASH_STROBE_LATENCY_RS_0	0x0333	//[7:0]
#define FLASH_STROBE_HI_PERIOD_RS_1	0x0334	//[15:8]
#define FLASH_STROBE_HI_PERIOD_RS_0	0x0335	//[7:0]
#define FLASH_STROBE_LO_PERIOD_RS_1	0x0336	//[15:8]
#define FLASH_STROBE_LO_PERIOD_RS_0	0x0337	//[7:0]
#define FLASH_STROBE_COUNT_RS		0x0338

//Even increment Registers – [0x0381-0x0383]	(Read Only)
#define	X_EVN_INC					0x0381	//[2:0]
#define	Y_EVN_INC					0x0383	//[2:0]

//Integration Time Registers – [0x0388-0x0389]	(Read only)
#define	FINE_INTEG_TIME_1			0x0388//[15:8]
#define	FINE_INTEG_TIME_0			0x0389//[7:0]

//Test Pattern Registers – [0x0600-0x0627]	(Read and Write)
#define test_pattern_Ena			0x0600	//[0]
#define test_pattern_mode			0x0601	//[7:0]
#define TD_R_1						0x0602	//[9:8]
#define TD_R_0						0x0603	//[7:0]
#define TD_GR_1						0x0604	//[9:8]
#define TD_GR_0						0x0605	//[7:0]
#define TD_B_1						0x0606	//[9:8]
#define TD_B_0						0x0607	//[7:0]
#define TD_GB_1						0x0608	//[9:8]
#define TD_GB_0						0x0609	//[7:0]
#define H_CUR_WIDTH_1				0x060A	//[15:8]
#define H_CUR_WIDTH_0				0x060B	//[7:0]
#define H_CUR_POS_1					0x060C	//[15:8]
#define H_CUR_POS_0					0x060D	//[7:0]
#define V_CUR_WIDTH_1				0x060E	//[15:8]
#define V_CUR_WIDTH_0				0x060F	//[7:0]
#define V_CUR_POS_1					0x0601  //[15:8]
#define V_CUR_POS_0					0x0602  //[7:0]
#define TP_WINDOW_X_OFFSET_1		0x0620  //[11:8]
#define TP_WINDOW_X_OFFSET_0		0x0621	//[7:0]
#define TP_WINDOW_Y_OFFSET_1		0x0622	//[11:8]
#define TP_WINDOW_Y_OFFSET_0		0x0623	//[7:0]
#define TP_WINDOW_WIDTH_1			0x0624	//[11:8]
#define TP_WINDOW_WIDTH_0			0x0625	//[7:0]
#define TP_WINDOW_HEIGHT_1			0x0626	//[11:8]
#define TP_WINDOW_HEIGHT_0			0x0627	//[7:0]

//Integration Time Parameter Limit Registers – [0x1000-0x1007]	(Read Only)

#define	integration_time_capability				0x1001
#define	coarse_integration_time_min_1			0x1004	//[15:8]
#define	coarse_integration_time_min_0			0x1005	//[7:0]
#define	coarse_integration_time_max_margin_1	0x1006	//[15:8]
#define	coarse_integration_time_max_margin_0	0x1007	//[7:0]

//Digital Gain Parameter Limit Registers – [0x1080-0x1089]	(Read Only)

#define	digital_gain_capability					0x1081	//[0]
#define	digital_gain_min_1						0x1084	//[15:8]
#define	digital_gain_min_0						0x1085	//[7:0]
#define	digital_gain_max_1						0x1086	//[15:8]
#define	digital_gain_max_0						0x1087	//[7:0]
#define	digital_gain_step_size_1				0x1088	//[15:8]
#define	digital_gain_step_size_0				0x1089	//[7:0]

//Pre-PLL and PLL Clock Set-up Capability Registers – [0x1100-0x111F]	(Read Only)

#define min_ext_clk_freq_mhz_3					0x1100	//[31:24]
#define min_ext_clk_freq_mhz_2					0x1101	//[23:16]
#define min_ext_clk_freq_mhz_1					0x1102	//[15:8]
#define min_ext_clk_freq_mhz_0					0x1103	//[7:0]
#define max_ext_clk_freq_mhz_3					0x1104	//[31:24]
#define max_ext_clk_freq_mhz_2                  0x1105	//[23:16]
#define max_ext_clk_freq_mhz_1                  0x1106	//[15:8]
#define max_ext_clk_freq_mhz_0                  0x1107	//[7:0]
#define min_pre_pll_clk_div_1					0x1108	//[15:8]
#define min_pre_pll_clk_div_0					0x1109	//[7:0]
#define max_pre_pll_clk_div_1					0x110A	//[15:8]
#define max_pre_pll_clk_div_0					0x110B	//[7:0]

#define min_pll_ip_freq_mhz_3					0x110C	//[31:24]
#define min_pll_ip_freq_mhz_2                   0x110D	//[23:16]
#define min_pll_ip_freq_mhz_1                   0x110E	//[15:8]
#define min_pll_ip_freq_mhz_0                   0x110F	//[7:0]

#define max_pll_ip_freq_mhz_3					0x1110	//[31:24]
#define max_pll_ip_freq_mhz_2                   0x1111	//[23:16]
#define max_pll_ip_freq_mhz_1                   0x1112	//[15:8]
#define max_pll_ip_freq_mhz_0                   0x1113	//[7:0]

#define min_pll_multiplier_1					0x1114	//[15:8]
#define min_pll_multiplier_0                    0x1115	//[7:0]
#define max_pll_multiplier_1					0x1116	//[15:8]
#define max_pll_multiplier_0                    0x1117	//[7:0]
#define min_pll_op_freq_mhz_3					0x1118	//[31:24]
#define min_pll_op_freq_mhz_2                   0x1119	//[23:16]
#define min_pll_op_freq_mhz_1                   0x111A	//[15:8]
#define min_pll_op_freq_mhz_0                   0x111B	//[7:0]

#define max_pll_op_freq_mhz_3					0x111C	//[31:24]
#define max_pll_op_freq_mhz_2	                0x111D	//[23:16]
#define max_pll_op_freq_mhz_1                   0x111E	//[15:8]
#define max_pll_op_freq_mhz_0                   0x111F	//[7:0]

//Read Domain Clock Set-up Capability Registers – [0x1120-0x1137]	(Read only)

#define min_vt_sys_clk_div_1					0x1120	//[15:8]
#define min_vt_sys_clk_div_0                    0x1121	//[7:0]
#define max_vt_sys_clk_div_1					0x1122	//[15:8]
#define max_vt_sys_clk_div_0                    0x1123	//[7:0]

#define min_vt_sys_clk_freq_mhz_3				0x1124	//[31:24]
#define min_vt_sys_clk_freq_mhz_2               0x1125	//[23:16]
#define min_vt_sys_clk_freq_mhz_1               0x1126	//[15:8]
#define min_vt_sys_clk_freq_mhz_0               0x1127	//[7:0]

#define max_vt_sys_clk_freq_mhz_3				0x1128	//[31:24]
#define max_vt_sys_clk_freq_mhz_2               0x1129	//[23:16]
#define max_vt_sys_clk_freq_mhz_1               0x112A	//[15:8]
#define max_vt_sys_clk_freq_mhz_0               0x112B	//[7:0]

#define min_vt_pix_clk_freq_mhz_3				0x112C	//[31:24]
#define min_vt_pix_clk_freq_mhz_2               0x112D	//[23:16]
#define min_vt_pix_clk_freq_mhz_1               0x112E	//[15:8]
#define min_vt_pix_clk_freq_mhz_0               0x112F	//[7:0]

#define max_vt_pix_clk_freq_mhz_3				0x1130	//[31:24]
#define max_vt_pix_clk_freq_mhz_2               0x1131	//[23:16]
#define max_vt_pix_clk_freq_mhz_1               0x1132	//[15:8]
#define max_vt_pix_clk_freq_mhz_0               0x1133	//[7:0]

#define min_vt_pix_clk_div_1					0x1134	//[15:8]
#define min_vt_pix_clk_div_0                    0x1135	//[7:0]
#define max_vt_pix_clk_div_1					0x1136	//[15:8]
#define max_vt_pix_clk_div_0	                0x1137	//[7:0]

//Frame Timing Parameter Limit Registers – [0x1140-0x114B]	(Read Only)

#define min_frame_length_lines_1				0x1140	//[15:8]
#define min_frame_length_lines_0				0x1141	//[7:0]
#define max_frame_length_lines_1				0x1142	//[15:8]
#define max_frame_length_lines_0				0x1143	//[7:0]
#define min_line_length_pck_1					0x1144	//[15:8]
#define min_line_length_pck_0                   0x1145	//[7:0]
#define max_line_length_pck_1					0x1146	//[15:8]
#define max_line_length_pck_0                   0x1147	//[7:0]
#define min_line_blanking_pck_1					0x1148	//[15:8]
#define min_line_blanking_pck_0                 0x1149	//[7:0]
#define min_frame_blanking_lines_1				0x114A	//[15:8]
#define min_frame_blanking_lines_0              0x114B	//[7:0]

//Output Clock Set-up Capability Registers – [0x1160-0x1177]	(Read Only)

#define	min_op_sys_clk_div_1					0x1160	//[15:8]
#define	min_op_sys_clk_div_0                    0x1161	//[7:0]
#define	max_op_sys_clk_div_1					0x1162	//[15:8]
#define	max_op_sys_clk_div_0                    0x1163	//[7:0]

#define	min_op_sys_clk_freq_mhz_3				0x1164	//[31:24]
#define	min_op_sys_clk_freq_mhz_2               0x1165	//[23:16]
#define	min_op_sys_clk_freq_mhz_1               0x1166	//[15:8]
#define	min_op_sys_clk_freq_mhz_0               0x1167	//[7:0]
#define	max_op_sys_clk_freq_mhz_3				0x1168	//[31:24]
#define	max_op_sys_clk_freq_mhz_2               0x1169	//[23:16]
#define	max_op_sys_clk_freq_mhz_1               0x116A	//[15:8]
#define	max_op_sys_clk_freq_mhz_0               0x116B	//[7:0]
#define	min_op_pix_clk_freq_mhz_3				0x116C	//[31:24]
#define	min_op_pix_clk_freq_mhz_2               0x116D	//[23:16]
#define	min_op_pix_clk_freq_mhz_1               0x116E	//[15:8]
#define	min_op_pix_clk_freq_mhz_0               0x116F	//[7:0]
#define	max_op_pix_clk_freq_mhz_3				0x1170	//[31:24]
#define	max_op_pix_clk_freq_mhz_2               0x1171	//[23:16]
#define	max_op_pix_clk_freq_mhz_1               0x1172	//[15:8]
#define	max_op_pix_clk_freq_mhz_0               0x1173	//[7:0]
#define	min_op_pix_clk_div_1					0x1174	//[15:8]
#define	min_op_pix_clk_div_0                    0x1175	//[7:0]
#define	max_op_pix_clk_div_1					0x1176	//[15:8]
#define	max_op_pix_clk_div_0                    0x1177	//[7:0]

//Image Size Parameter Limit Registers – [0x1180-0x118F]		(Read Only)
#define x_addr_min_1							0x1180	//[15:8]
#define x_addr_min_0                            0x1181	//[7:0]
#define y_addr_min_1                            0x1182	//[15:8]
#define y_addr_min_0                            0x1183	//[7:0]
#define x_addr_max_1                            0x1184	//[15:8]
#define x_addr_max_0                            0x1185	//[7:0]
#define y_addr_max_1							0x1186	//[15:8]
#define y_addr_max_0                            0x1187	//[7:0]
#define min_x_output_size_1                     0x1188	//[15:8]
#define min_x_output_size_0                     0x1189	//[7:0]
#define min_y_output_size_1                     0x118A	//[15:8]
#define min_y_output_size_0                     0x118B	//[7:0]
#define max_x_output_size_1						0x118C	//[15:8]
#define max_x_output_size_0                     0x118D	//[7:0]
#define max_y_output_size_1                     0x118E	//[15:8]
#define max_y_output_size_0                     0x118F	//[7:0]

//Sub-Sampling Parameter Limit Registers – [0x11C0-0x11C7]	(Read Only)
#define min_even_inc_1							0x11C0	//[15:8]
#define min_even_inc_0                          0x11C1	//[7:0]
#define max_even_inc_1                          0x11C2	//[15:8]
#define max_even_inc_0                          0x11C3	//[7:0]
#define min_odd_inc_1                           0x11C4	//[15:8]
#define min_odd_inc_0                           0x11C5	//[7:0]
#define max_odd_inc_1                           0x11C6	//[15:8]
#define max_odd_inc_0                           0x11C7	//[7:0]

//Image Compression Capability Registers – [0x1300-0x1301]	(Read Only)
#define compression_capability					0x1301	//[0]


void PiCam_WriteRegData(u16 reg,u8 data);
u8 PiCam_ReadRegData(u16 reg);
void PiCam_init(void);

void PiCam_Output_activePixelX(u16 XStart,u16 XEnd);
void PiCam_Output_activePixelY(u16 YStart,u16 YEnd);
void PiCam_TestPattern(u8 Enable,u8 mode,u16 X,u16 Y);

#endif /* SRC_PICAMDRIVER_H_ */

