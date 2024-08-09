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

module display_hdmi_i2c_wrapper
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

module i2c_phy
#(
	parameter	DEVICE_ADDRESS	= 8'h00,	// TODO
	parameter	ADDRESSING		= 7,		// 7/10
											// 10-bit, ADDRESS_CYCLE = 2, S11110AAWK_AAAAAAAAK_RRRRRRRRK TODO
											// 7-bit, SAAAAAAAWK_RRRRRRRRK
	parameter	SYSCLK_FREQ		= 100,		// MHz
	parameter	I2C_FREQ		= 100,		// KHz
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

function integer log2;
	input	integer	val;
	integer	i;
	begin
		log2 = 0;
		for (i=0; 2**i<val; i=i+1)
			log2 = i+1;
	end
endfunction

localparam	s_IDLE			= 5'b00000;

localparam	s_M_START		= 5'b00001;
localparam	s_M_ADDR		= 5'b00010;
localparam	s_M_ADDR_ACK	= 5'b00011;
localparam	s_M_ADDR10		= 5'b01001;
localparam	s_M_ADDR10_ACK	= 5'b01010;
localparam	s_M_WR			= 5'b00100;
localparam	s_M_WR_ACK		= 5'b00101;
localparam	s_M_RD			= 5'b00110;
localparam	s_M_RD_ACK		= 5'b00111;
localparam	s_M_START_R		= 5'b01000;
localparam	s_M_STOP		= 5'b01001;

localparam	s_S_START		= 5'b10001;
localparam	s_S_ADDR		= 5'b10010;
localparam	s_S_ADDR_ACK	= 5'b10011;
localparam	s_S_ADDR10		= 5'b11001;
localparam	s_S_ADDR10_ACK	= 5'b11010;
localparam	s_S_WR			= 5'b10100;
localparam	s_S_WR_ACK		= 5'b10101;
localparam	s_S_RD			= 5'b10110;
localparam	s_S_RD_ACK		= 5'b10111;
localparam	s_S_START_R		= 5'b11000;
localparam	s_S_STOP		= 5'b11001;

localparam	b_CLK	= log2(SYSCLK_FREQ*1000/I2C_FREQ)-1'b1;

reg		[3:0]r_i2c_state_1P;
reg		[15:0]r_i2c_clk_1P;
reg		r_sda_oe_1P;
reg		r_scl_oe_1P;

reg		[2:0]r_bit_cnt_1P;
reg		r_wr_1P;
reg		[ADDRESSING-1:0]r_addr_1P;
reg		[7:0]r_wdata_1P;
reg		[7:0]r_wsr_1P;
reg		[7:0]r_rsr_1P;
reg		[7:0]r_rdata_1P;

reg		r_slave_ack_1P;
reg		r_slave_last_1P;

reg		r_m_en_1P;
reg		r_m_en_re_1P;

reg		r_i2c_clk_2P;

always@(posedge i_arst or posedge i_sysclk)
begin
	if (i_arst)
	begin
		r_i2c_state_1P	<= s_IDLE;
		r_i2c_clk_1P	<= {16{1'b0}};
		r_sda_oe_1P		<= 1'b0;
		r_scl_oe_1P		<= 1'b0;
		
		r_bit_cnt_1P	<= {3{1'b0}};
		r_wr_1P			<= 1'b0;
		r_addr_1P		<= {ADDRESSING{1'b0}};
		r_wdata_1P		<= {8{1'b0}};
		r_wsr_1P		<= {8{1'b0}};
		r_rsr_1P		<= {8{1'b0}};
		r_rdata_1P		<= {8{1'b0}};
		
		r_slave_ack_1P	<= 1'b0;
		r_slave_last_1P	<= 1'b0;
		
		r_m_en_1P		<= 1'b0;
		r_m_en_re_1P	<= 1'b0;
		
		r_i2c_clk_2P	<= 1'b0;
	end
	else
	begin
		r_slave_ack_1P	<= 1'b0;
		r_slave_last_1P	<= 1'b0;
		r_i2c_clk_2P	<= r_i2c_clk_1P[b_CLK];
		r_m_en_1P		<= i_m_en;
		
		case (r_i2c_state_1P)
			s_IDLE:
			begin
				r_i2c_clk_1P	<= {16{1'b0}};
				
				if (i_m_en)
				begin
					r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
					
					// Clock Synchronization
					if (~i_scl && ~r_scl_oe_1P)
						r_i2c_clk_1P	<= {16{1'b0}};
					else if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
					begin
						r_i2c_state_1P	<= s_M_START;
						r_i2c_clk_1P	<= {16{1'b0}};
						r_sda_oe_1P		<= 1'b0;
						r_scl_oe_1P		<= 1'b0;
						
						r_wr_1P			<= i_m_wr;
						r_addr_1P		<= i_addr;
						r_wdata_1P		<= i_data;
					end
				end
			end
			
			s_M_START:
			begin
				r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
				if (ADDRESSING == 10)
					r_wsr_1P	<= {5'b1110, r_addr_1P[ADDRESSING-1-:2], r_wr_1P};
				else
					r_wsr_1P	<= {r_addr_1P, r_wr_1P};
				
				if (r_i2c_clk_1P[b_CLK] && ~r_i2c_clk_2P)
					r_sda_oe_1P		<= 1'b1;
				
				if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
				begin
					// Arbitration
					if (~i_sda)
					begin
						r_i2c_state_1P	<= s_M_ADDR;
						r_sda_oe_1P		<= ~r_wsr_1P[7];
						r_wsr_1P		<= {r_wsr_1P[6:0], 1'b0};
						r_scl_oe_1P		<= ~r_i2c_clk_1P[b_CLK];
						
						r_bit_cnt_1P	<= {3{1'b0}};
					end
					else
					begin
						r_i2c_state_1P	<= s_M_START;
						r_sda_oe_1P		<= 1'b0;
						r_scl_oe_1P		<= 1'b0;
					end
				end
			end
			
			s_M_ADDR:
			begin
				r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
				r_scl_oe_1P		<= ~r_i2c_clk_1P[b_CLK];
				
				if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
				begin
					r_sda_oe_1P		<= ~r_wsr_1P[7];
					r_bit_cnt_1P	<= r_bit_cnt_1P+1'b1;
					
					r_wsr_1P		<= {r_wsr_1P[6:0], 1'b0};
					// Arbitration
					if (~i_sda == r_sda_oe_1P)
					begin
						if (r_bit_cnt_1P == 3'd7)
						begin
							r_i2c_state_1P	<= s_M_ADDR_ACK;
							r_sda_oe_1P		<= 1'b0;
							r_wsr_1P		<= r_wdata_1P;
							r_rsr_1P		<= {8{1'b0}};
						end
					end
					else
					begin
						r_i2c_state_1P	<= s_M_START;
						r_sda_oe_1P		<= 1'b0;
						r_scl_oe_1P		<= 1'b0;
					end
				end
			end
			
			s_M_ADDR_ACK:
			begin
				r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
				r_scl_oe_1P		<= ~r_i2c_clk_1P[b_CLK];
				
				if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
				begin
					if (~i_sda)
					begin
						if (i_m_en)
						begin
							if (i_m_wr)
							begin
								r_i2c_state_1P	<= s_M_RD;
								r_sda_oe_1P		<= 1'b0;
							end
							else
							begin
								r_i2c_state_1P	<= s_M_WR;
								r_sda_oe_1P		<= ~r_wsr_1P[7];
								r_wsr_1P		<= {r_wsr_1P[6:0], 1'b0};
							end
						end
						else
						begin
							r_i2c_state_1P	<= s_M_STOP;
							r_sda_oe_1P		<= 1'b1;
//							r_scl_oe_1P		<= 1'b0;
						end
					end
					else
					begin
						r_i2c_state_1P	<= s_M_STOP;
						r_sda_oe_1P		<= 1'b1;
//						r_scl_oe_1P		<= 1'b0;
						r_slave_last_1P	<= 1'b1;
					end
				end
			end
			
			s_M_WR:
			begin
				r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
				r_scl_oe_1P		<= ~r_i2c_clk_1P[b_CLK];
				
				if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
				begin
					r_sda_oe_1P		<= ~r_wsr_1P[7];
					r_bit_cnt_1P	<= r_bit_cnt_1P+1'b1;
					
					r_wsr_1P		<= {r_wsr_1P[6:0], 1'b0};
					// Arbitration
					if (~i_sda == r_sda_oe_1P)
					begin
						if (r_bit_cnt_1P == 3'd7)
						begin
							r_i2c_state_1P	<= s_M_WR_ACK;
							r_sda_oe_1P		<= 1'b0;
						end
					end
					else
					begin
						r_i2c_state_1P	<= s_M_START;
						r_sda_oe_1P		<= 1'b0;
						r_scl_oe_1P		<= 1'b0;
					end
				end
			end
			
			s_M_WR_ACK:
			begin
				r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
				r_scl_oe_1P		<= ~r_i2c_clk_1P[b_CLK];
				
				r_wr_1P			<= i_m_wr;
				r_addr_1P		<= i_addr;
				r_wdata_1P		<= i_data;
				r_wsr_1P		<= r_wdata_1P;
				
				if (~r_m_en_1P & i_m_en)
					r_m_en_re_1P	<= 1'b1;
				
				if (r_i2c_clk_1P[b_CLK] && ~r_i2c_clk_2P)
				begin
					r_slave_ack_1P	<= 1'b1;
					r_slave_last_1P	<= i_sda;
				end
				
				if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
				begin
					if (~i_sda)
					begin
						r_m_en_re_1P	<= 1'b0;
						if (r_m_en_re_1P)
						begin
							r_i2c_state_1P	<= s_M_START_R;
							r_sda_oe_1P		<= 1'b0;
						end
						else if (i_m_en)
						begin
							if (i_m_wr)
							begin
								r_i2c_state_1P	<= s_M_START_R;
								r_sda_oe_1P		<= 1'b0;
							end
							else
							begin
								r_i2c_state_1P	<= s_M_WR;
								r_sda_oe_1P		<= ~r_wsr_1P[7];
								r_wsr_1P		<= {r_wsr_1P[6:0], 1'b0};
							end
						end
						else
						begin
							r_i2c_state_1P	<= s_M_STOP;
							r_sda_oe_1P		<= 1'b1;
//							r_scl_oe_1P		<= 1'b0;
						end
					end
					else
					begin
						r_i2c_state_1P	<= s_M_STOP;
						r_sda_oe_1P		<= 1'b1;
//						r_scl_oe_1P		<= 1'b0;
					end
				end
			end
			
			s_M_RD:
			begin
				r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
				r_scl_oe_1P		<= ~r_i2c_clk_1P[b_CLK];
				
				if (r_i2c_clk_1P[b_CLK] && ~r_i2c_clk_2P)
					r_rsr_1P	<= {r_rsr_1P[6:0], i_sda};
				
				if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
				begin
					r_bit_cnt_1P	<= r_bit_cnt_1P+1'b1;
					
					if (r_bit_cnt_1P == 3'd7)
					begin
						r_i2c_state_1P	<= s_M_RD_ACK;
						r_sda_oe_1P		<= ~i_last;
						
						r_wr_1P			<= i_m_wr;
						r_addr_1P		<= i_addr;
						r_wdata_1P		<= i_data;
					end
				end
			end
			
			s_M_RD_ACK:
			begin
				r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
				r_scl_oe_1P		<= ~r_i2c_clk_1P[b_CLK];
				
				r_wr_1P			<= i_m_wr;
				r_addr_1P		<= i_addr;
				r_wdata_1P		<= i_data;
				
				if (~r_m_en_1P & i_m_en)
					r_m_en_re_1P	<= 1'b1;
				
				if (r_i2c_clk_1P[b_CLK] && ~r_i2c_clk_2P)
				begin
					r_rdata_1P		<= r_rsr_1P;
					r_slave_ack_1P	<= 1'b1;
				end
					
				if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
				begin
					r_m_en_re_1P	<= 1'b0;
					if (r_m_en_re_1P)
					begin
						r_i2c_state_1P	<= s_M_START_R;
						r_sda_oe_1P		<= 1'b0;
					end
					else if (i_m_en)
					begin
						if (i_m_wr)
						begin
							r_i2c_state_1P	<= s_M_RD;
							r_rsr_1P		<= {8{1'b0}};
						end
						else
						begin
							r_i2c_state_1P	<= s_M_START_R;
							r_sda_oe_1P		<= 1'b0;
						end
					end
					else
					begin
						r_i2c_state_1P	<= s_M_STOP;
						r_sda_oe_1P		<= 1'b1;
//						r_scl_oe_1P		<= 1'b0;
					end
				end
			end
			
			s_M_START_R:
			begin
				r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
				r_scl_oe_1P		<= ~r_i2c_clk_1P[b_CLK];
				
				if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
				begin
					r_i2c_state_1P	<= s_M_START;
					r_sda_oe_1P		<= 1'b0;
					r_scl_oe_1P		<= 1'b0;
				end
			end
			
			s_M_STOP:
			begin
				r_i2c_clk_1P	<= r_i2c_clk_1P+1'b1;
				r_scl_oe_1P		<= ~r_i2c_clk_1P[b_CLK];
				
//				if (r_i2c_clk_1P[b_CLK] && ~r_i2c_clk_2P)
//					r_sda_oe_1P		<= 1'b0;
				
				if (~r_i2c_clk_1P[b_CLK] && r_i2c_clk_2P)
				begin
					r_i2c_state_1P	<= s_IDLE;
					r_sda_oe_1P		<= 1'b0;
					r_scl_oe_1P		<= 1'b0;
				end
			end
			
			default:
			begin
				r_i2c_state_1P	<= s_IDLE;
				r_i2c_clk_1P	<= {16{1'b0}};
				r_sda_oe_1P		<= 1'b0;
				r_scl_oe_1P		<= 1'b0;
				
				r_bit_cnt_1P	<= {3{1'b0}};
				r_wr_1P			<= 1'b0;
				r_addr_1P		<= {ADDRESSING{1'b0}};
				r_wdata_1P		<= {8{1'b0}};
				r_wsr_1P		<= {8{1'b0}};
				r_rsr_1P		<= {8{1'b0}};
				r_rdata_1P		<= {8{1'b0}};
				
				r_m_en_re_1P	<= 1'b0;
			end
		endcase
	end
end

assign	o_dbg_i2c_state	= r_i2c_state_1P;
assign	o_dbg_rsr		= r_rsr_1P;

assign	o_ack		= r_slave_ack_1P;
assign	o_last		= r_slave_last_1P;
assign	o_data		= r_rdata_1P;

assign	o_sda_oe	= r_sda_oe_1P;
assign	o_scl_oe	= r_scl_oe_1P;

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
