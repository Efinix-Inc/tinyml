/////////////////////////////////////////////////////////////////////////////
//
// Copyright (C) 2013-2019 Efinix Inc. All rights reserved.
//
// i2c_phy.v
//
// *******************************
// Revisions:
// 1.0 Initial rev
// *******************************
/////////////////////////////////////////////////////////////////////////////

module i2c_wrapper
#(
	parameter	DEVICE_ADDRESS	= 8'h00,		// TODO
	parameter	ADDRESSING		= 7,			// 7/10
												// 10-bit, ADDRESS_CYCLE = 2, S11110AAWK_AAAAAAAAK_RRRRRRRRK TODO
												// 7-bit, SAAAAAAAWK_RRRRRRRRK
	parameter	SYSCLK_FREQ		= 100,			// MHz
	parameter	MODE			= "ULTRA_FAST",	// STANDARD		100kbit/s
												// FAST			400kbit/s
												// FAST_PLUS	1Mbit/s
												// HIGH_SPEED	3.4Mbit/s
												// ULTRA_FAST	5Mbit/s
	parameter	SLAVE_ENABLE	= "FALSE"
)
(
	input	i_arst,
	input	i_sysclk,
	
	input	i_m_en,
	input	i_m_wr,
	input	i_last,
	input	[ADDRESSING-1:0]i_addr,
	input	[7:0]i_data,
//	output	o_s_en,
//	output	o_s_wr,
	output	o_ack,
	output	o_last,
	output	[7:0]o_data,
	
	output	[3:0]o_dbg_i2c_state,
	output	[7:0]o_dbg_rsr,
	
	input	i_sda,
	output	o_sda_oe,
	input	i_scl,
	output	o_scl_oe
);

generate
	if (MODE == "FAST")
	begin
		i2c_phy
		#(
			.DEVICE_ADDRESS	(DEVICE_ADDRESS),
			.ADDRESSING		(ADDRESSING),
			.SYSCLK_FREQ	(SYSCLK_FREQ),
			.I2C_FREQ		(400),
			.SLAVE_ENABLE	(SLAVE_ENABLE)
		)
		inst_i2c_fast
		(
			.i_arst		(i_arst),
			.i_sysclk	(i_sysclk),
			.i_m_en		(i_m_en),
			.i_m_wr		(i_m_wr),
			.i_last		(i_last),
			.i_addr		(i_addr),
			.i_data		(i_data),
//			.o_s_en		(o_s_en),
//			.o_s_wr		(o_s_wr),
			.o_ack		(o_ack),
			.o_last		(o_last),
			.o_data		(o_data),
			.o_dbg_i2c_state	(o_dbg_i2c_state),
			.o_dbg_rsr			(o_dbg_rsr),
			.i_sda		(i_sda),
			.o_sda_oe	(o_sda_oe),
			.i_scl		(i_scl),
			.o_scl_oe	(o_scl_oe)
		);
	end
	else if (MODE == "FAST_PLUS")
	begin
		i2c_phy
		#(
			.DEVICE_ADDRESS	(DEVICE_ADDRESS),
			.ADDRESSING		(ADDRESSING),
			.SYSCLK_FREQ	(SYSCLK_FREQ),
			.I2C_FREQ		(1000),
			.SLAVE_ENABLE	(SLAVE_ENABLE)
		)
		inst_i2c_fast_plus
		(
			.i_arst		(i_arst),
			.i_sysclk	(i_sysclk),
			.i_m_en		(i_m_en),
			.i_m_wr		(i_m_wr),
			.i_last		(i_last),
			.i_addr		(i_addr),
			.i_data		(i_data),
//			.o_s_en		(o_s_en),
//			.o_s_wr		(o_s_wr),
			.o_ack		(o_ack),
			.o_last		(o_last),
			.o_data		(o_data),
			.o_dbg_i2c_state	(o_dbg_i2c_state),
			.o_dbg_rsr			(o_dbg_rsr),
			.i_sda		(i_sda),
			.o_sda_oe	(o_sda_oe),
			.i_scl		(i_scl),
			.o_scl_oe	(o_scl_oe)
		);
	end
	else if (MODE == "HIGH_SPEED")
	begin
		i2c_phy
		#(
			.DEVICE_ADDRESS	(DEVICE_ADDRESS),
			.ADDRESSING		(ADDRESSING),
			.SYSCLK_FREQ	(SYSCLK_FREQ),
			.I2C_FREQ		(3400),
			.SLAVE_ENABLE	(SLAVE_ENABLE)
		)
		inst_i2c_high_speed
		(
			.i_arst		(i_arst),
			.i_sysclk	(i_sysclk),
			.i_m_en		(i_m_en),
			.i_m_wr		(i_m_wr),
			.i_last		(i_last),
			.i_addr		(i_addr),
			.i_data		(i_data),
//			.o_s_en		(o_s_en),
//			.o_s_wr		(o_s_wr),
			.o_ack		(o_ack),
			.o_last		(o_last),
			.o_data		(o_data),
			.o_dbg_i2c_state	(o_dbg_i2c_state),
			.o_dbg_rsr			(o_dbg_rsr),
			.i_sda		(i_sda),
			.o_sda_oe	(o_sda_oe),
			.i_scl		(i_scl),
			.o_scl_oe	(o_scl_oe)
		);
	end
	else if (MODE == "ULTRA_FAST")
	begin
		i2c_phy
		#(
			.DEVICE_ADDRESS	(DEVICE_ADDRESS),
			.ADDRESSING		(ADDRESSING),
			.SYSCLK_FREQ	(SYSCLK_FREQ),
			.I2C_FREQ		(5000),
			.SLAVE_ENABLE	(SLAVE_ENABLE)
		)
		inst_i2c_ultra_fast
		(
			.i_arst		(i_arst),
			.i_sysclk	(i_sysclk),
			.i_m_en		(i_m_en),
			.i_m_wr		(i_m_wr),
			.i_last		(i_last),
			.i_addr		(i_addr),
			.i_data		(i_data),
//			.o_s_en		(o_s_en),
//			.o_s_wr		(o_s_wr),
			.o_ack		(o_ack),
			.o_last		(o_last),
			.o_data		(o_data),
			.o_dbg_i2c_state	(o_dbg_i2c_state),
			.o_dbg_i2c_rsr		(o_dbg_rsr),
			.i_sda		(i_sda),
			.o_sda_oe	(o_sda_oe),
			.i_scl		(i_scl),
			.o_scl_oe	(o_scl_oe)
		);
	end
	else
	begin
		i2c_phy
		#(
			.DEVICE_ADDRESS	(DEVICE_ADDRESS),
			.ADDRESSING		(ADDRESSING),
			.SYSCLK_FREQ	(SYSCLK_FREQ),
			.I2C_FREQ		(100),
			.SLAVE_ENABLE	(SLAVE_ENABLE)
		)
		inst_i2c_standard
		(
			.i_arst		(i_arst),
			.i_sysclk	(i_sysclk),
			.i_m_en		(i_m_en),
			.i_m_wr		(i_m_wr),
			.i_last		(i_last),
			.i_addr		(i_addr),
			.i_data		(i_data),
//			.o_s_en		(o_s_en),
//			.o_s_wr		(o_s_wr),
			.o_ack		(o_ack),
			.o_last		(o_last),
			.o_data		(o_data),
			.o_dbg_i2c_state	(o_dbg_i2c_state),
			.o_dbg_rsr			(o_dbg_rsr),
			.i_sda		(i_sda),
			.o_sda_oe	(o_sda_oe),
			.i_scl		(i_scl),
			.o_scl_oe	(o_scl_oe)
		);
	end
endgenerate

endmodule

//////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2019 Efinix Inc. All rights reserved.
//
// This   document  contains  proprietary information  which   is
// protected by  copyright. All rights  are reserved.  This notice
// refers to original work by Efinix, Inc. which may be derivitive
// of other work distributed under license of the authors.  In the
// case of derivative work, nothing in this notice overrides the
// original author's license agreement.  Where applicable, the 
// original license agreement is included in it's original 
// unmodified form immediately below this header.
//
// WARRANTY DISCLAIMER.  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND 
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH 
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES, 
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF 
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR 
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED 
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.
//
// LIMITATION OF LIABILITY.  
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY 
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT 
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY 
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT, 
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY 
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF 
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR 
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN 
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER 
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR 
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT 
//     APPLY TO LICENSEE.
//
/////////////////////////////////////////////////////////////////////////////
