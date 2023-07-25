////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022 github-efx
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////

module display_hdmi_data_unpack
#(
	parameter PIXEL_BIT		= 6'd32,
	parameter PACK_BIT		= 8'd64,
	parameter FIFO_WIDTH	= 4'd10
)
(
	input	in_pclk,
	input	in_rstn,
	
	input 	[FIFO_WIDTH-1:0]	in_x,
	input 	[FIFO_WIDTH-1:0]	in_y,
	input 						in_valid,
	input 						in_de,
	input 						in_hs,
	input 						in_vs,
	input	[PACK_BIT-1:0]		in_data,
	
	output 	[FIFO_WIDTH-1:0]	out_x,
	output 	[FIFO_WIDTH-1:0]	out_y,
	output 						out_valid,
	output 						out_de,
	output 						out_hs,
	output 						out_vs,
	output	[PIXEL_BIT-1:0]		out_data
);

parameter	PACK_DIV	= PACK_BIT / PIXEL_BIT;

/* VGA counter for the output display sync signals generator */
reg [FIFO_WIDTH-2:0]	r_x_total;
reg [FIFO_WIDTH-1:0]	r_out_x;
reg [FIFO_WIDTH-1:0]	r_out_y;
reg [FIFO_WIDTH-1:0]	r_in_x_1P;
reg [3:0] 				r_pcnt;
reg [3:0] 				r_pcnt_1P;
reg [3:0] 				r_pcnt_2P;
reg [3:0] 				r_pcnt_3P;
reg [3:0] 				r_pcnt_4P;
reg [3:0] 				r_pcnt_5P;
reg						r_line_start;
reg						r_line_end;
reg						r_out_end;
reg						r_out_vs_1P;
reg						r_out_vs_2P;
reg						r_out_vs_3P;
reg						r_out_vs_4P;
reg						r_out_vs_5P;
reg						r_out_vs_6P;
reg						r_out_hs_1P;
reg						r_out_hs_2P;
reg						r_out_hs_3P;
reg						r_out_hs_4P;
reg						r_out_hs_5P;
reg						r_out_hs_6P;
reg						r_out_de;
reg						r_out_de_1P;
reg						r_out_de_2P;
reg						r_out_de_3P;
reg						r_out_de_4P;
reg						r_out_de_5P;
reg						r_out_valid;
reg						r_out_valid_1P;
reg						r_out_valid_2P;
reg						r_out_valid_3P;
reg						r_out_valid_4P;
reg	[FIFO_WIDTH-1:0]	r_in_y_4P;
reg	[FIFO_WIDTH-1:0]	r_out_x_1P;
reg	[FIFO_WIDTH-1:0]	r_out_x_2P;
reg	[FIFO_WIDTH-1:0]	r_out_x_3P;
reg	[FIFO_WIDTH-1:0]	r_out_x_4P;
reg	[FIFO_WIDTH-1:0]	r_out_x_5P;
reg	[FIFO_WIDTH-1:0]	r_out_x_6P;
reg	[FIFO_WIDTH-1:0]	r_out_x_7P;
reg	[FIFO_WIDTH-1:0]	r_out_x_8P;
reg	[FIFO_WIDTH-1:0]	r_out_y_4P;
reg	[PACK_BIT-1:0]		r_out_data_3P;
reg	[PACK_BIT-1:0]		r_out_data_4P;
reg						r_de_1P;
reg 					r_in_vs;
reg 					r_in_hs;
reg 					r_in_de;
reg 					r_in_vs_1P;
reg 					r_in_hs_1P;
reg 					r_in_de_1P;
reg 					r_in_vs_2P;
reg 					r_in_hs_2P;
reg 					r_in_de_2P;
reg 					r_in_vs_3P;
reg 					r_in_hs_3P;
reg 					r_in_de_3P;

wire					w_vs;
wire					w_hs;
wire					w_de;
wire[PACK_BIT-1:0]		w_out_data;
wire[FIFO_WIDTH-1:0]	w_out_x;

/* VGA counter for the output display sync signals generator */
/* r_x_cnt for HSYNC and DEN */  
always @ (posedge in_pclk)
begin
	if(~in_rstn)
	begin    
		r_x_total		<= {(FIFO_WIDTH-1){1'b0}};
		r_out_x			<= {FIFO_WIDTH{1'b0}};
		r_out_y			<= {FIFO_WIDTH{1'b0}};
		r_in_x_1P		<= {FIFO_WIDTH{1'b0}};
		r_in_y_4P		<= {FIFO_WIDTH{1'b0}};
		r_out_x_1P		<= {FIFO_WIDTH{1'b0}};
		r_out_x_2P		<= {FIFO_WIDTH{1'b0}};
		r_out_x_3P		<= {FIFO_WIDTH{1'b0}};
		r_out_x_4P		<= {FIFO_WIDTH{1'b0}};
		r_out_x_5P		<= {FIFO_WIDTH{1'b0}};
		r_out_x_6P		<= {FIFO_WIDTH{1'b0}};
		r_out_x_7P		<= {FIFO_WIDTH{1'b0}};
		r_out_x_8P		<= {FIFO_WIDTH{1'b0}};
		r_out_y_4P		<= {FIFO_WIDTH{1'b0}};
		r_out_data_3P	<= {PACK_BIT{1'b0}};
		r_out_data_4P	<= {PACK_BIT{1'b0}};
		r_pcnt			<= 4'b0;
		r_line_start	<= 1'b0;
		r_line_end		<= 1'b0;
		r_out_end		<= 1'b0;
		r_out_vs_1P		<= 1'b0;
		r_out_vs_2P		<= 1'b0;
		r_out_vs_3P		<= 1'b0;
		r_out_vs_4P		<= 1'b0;
		r_out_vs_5P		<= 1'b0;
		r_out_vs_6P		<= 1'b0;
	    r_out_hs_1P		<= 1'b0;
	    r_out_hs_2P		<= 1'b0;
	    r_out_hs_3P		<= 1'b0;
	    r_out_hs_4P		<= 1'b0;
	    r_out_hs_5P		<= 1'b0;
	    r_out_hs_6P		<= 1'b0;
	    r_out_de		<= 1'b0;
	    r_out_de_1P		<= 1'b0;
		r_out_de_2P		<= 1'b0;
		r_out_de_3P		<= 1'b0;
		r_out_de_4P		<= 1'b0;
		r_out_de_5P		<= 1'b0;
		r_out_valid		<= 1'b0;
		r_out_valid_1P	<= 1'b0;
		r_out_valid_2P	<= 1'b0;
		r_out_valid_3P	<= 1'b0;
		r_out_valid_4P	<= 1'b0;
		r_pcnt_1P		<= 4'b0;
		r_pcnt_2P		<= 4'b0;
		r_pcnt_3P		<= 4'b0;
		r_pcnt_4P		<= 4'b0;
		r_pcnt_5P		<= 4'b0;
		r_de_1P			<= 1'b0;
		r_in_vs_1P      <= 1'b0;
		r_in_hs_1P      <= 1'b0;
		r_in_de_1P      <= 1'b0;
		r_in_vs_2P      <= 1'b0;
		r_in_hs_2P      <= 1'b0;
		r_in_de_2P      <= 1'b0;
		r_in_vs_3P      <= 1'b0;
		r_in_hs_3P      <= 1'b0;
		r_in_de_3P      <= 1'b0;
	end	
	else
	begin
		if (in_valid)
			r_in_x_1P	<= in_x;
		r_de_1P		<= w_de;
		
		r_out_vs_1P		<= w_vs;
		r_out_vs_2P		<= r_out_vs_1P;
		r_out_vs_3P		<= r_out_vs_2P;
		r_out_vs_4P		<= r_out_vs_3P;
		r_out_vs_5P		<= r_out_vs_4P;
		r_out_vs_6P		<= r_out_vs_5P;
	    r_out_hs_1P		<= w_hs;
	    r_out_hs_2P		<= r_out_hs_1P;
	    r_out_hs_3P		<= r_out_hs_2P;
	    r_out_hs_4P		<= r_out_hs_3P;
	    r_out_hs_5P		<= r_out_hs_4P;
	    r_out_hs_6P		<= r_out_hs_5P;
	    r_out_de_1P		<= r_out_de;
		r_out_de_2P		<= r_out_de_1P;
		r_out_de_3P		<= r_out_de_2P;
		r_out_de_4P		<= r_out_de_3P;
		r_out_de_5P		<= r_out_de_4P;
		r_out_valid_1P	<= r_out_valid;
		r_out_valid_2P	<= r_out_valid_1P;
		r_out_valid_3P	<= r_out_valid_2P;
		r_out_valid_4P	<= r_out_valid_3P;
		r_pcnt_1P		<= r_pcnt;
		r_pcnt_2P		<= r_pcnt_1P;
		r_pcnt_3P		<= r_pcnt_2P;
		r_pcnt_4P		<= r_pcnt_3P;
		r_pcnt_5P		<= r_pcnt_4P;
		r_out_x_1P		<= r_out_x;// * PACK_DIV + r_pcnt;		
		r_out_x_2P		<= r_out_x_1P;
		r_out_x_3P		<= r_out_x_2P;
		r_out_x_4P		<= r_out_x_3P;
		r_out_x_5P		<= r_out_x_4P;
		r_out_x_6P		<= r_out_x_5P;
		r_out_x_7P		<= r_out_x_6P;
		r_out_x_8P		<= r_out_x_7P;
		
		r_in_vs_1P	<= in_vs;
		r_in_hs_1P	<= in_hs;
		r_in_de_1P	<= in_de;
		r_in_vs_2P	<= r_in_vs_1P;
		r_in_hs_2P	<= r_in_hs_1P;
		r_in_de_2P	<= r_in_de_1P;
		r_in_vs_3P	<= r_in_vs_2P;
		r_in_hs_3P	<= r_in_hs_2P;
		r_in_de_3P	<= r_in_de_2P;
		
		if (in_de && ~r_in_de_1P)
			r_line_start	<= 1'b1;
			
		if (~in_de && r_in_de_1P)
		begin
			r_line_end	<= 1'b1;
			r_x_total	<= r_in_x_1P;
		end
		
		if (~r_out_de_1P && r_out_de_2P)
			r_out_end	<= 1'b1;
		
		if (w_de && ~r_de_1P)
			r_out_de	<= 1'b1;
			
		if (r_out_de)
		begin
			if (r_pcnt == (PACK_DIV - 1'b1))
				r_pcnt 		<= 2'b0;
			else
				r_pcnt 		<= r_pcnt + 1'b1;
			
			if (r_pcnt == 2'b0)				
				r_out_valid	<= 1'b1;
			else
				r_out_valid	<= 1'b0;
			
			if (r_out_x > r_x_total+1)
			begin
				r_out_de	<= 1'b0;
				r_out_x		<= {FIFO_WIDTH{1'b0}};
				r_out_y 	<= r_out_y + 1'b1;
			end
			else
			if (r_out_valid)
				r_out_x		<= r_out_x + 1'b1;
		end
		else
		begin
			r_pcnt 		<= 2'b0;
			r_out_valid	<= 1'b0;
		end
		
		if (~w_vs)
			r_out_y	<= {FIFO_WIDTH{1'b0}};
		
		if (r_out_valid_2P)
			r_out_data_3P	<= w_out_data;
		else			
			r_out_data_3P[PIXEL_BIT*(PACK_DIV-1)-1:0]	<= r_out_data_3P[PIXEL_BIT*(PACK_DIV)-1:PIXEL_BIT];
		
		r_out_data_4P[PIXEL_BIT-1:0]	<= r_out_data_3P[PIXEL_BIT-1:0];
		
		if (~r_out_de_3P && r_out_de_4P)
			r_out_y_4P	<= r_out_y_4P + 1'b1;
		
		if (~r_out_vs_3P)
			r_out_y_4P	<= {FIFO_WIDTH{1'b0}};
	end
end

/* 1 line delay */
display_hdmi_dual_clock_fifo
#(	
	.DATA_WIDTH(1),
    .ADDR_WIDTH(FIFO_WIDTH)
) 
dual_clock_fifo_in0 
(
	.i_arst 	(~in_rstn),
	.i_wclk 	(in_pclk),
	.i_we 		(r_line_start),
	.i_wdata 	(r_in_de_3P),  
	.i_rclk 	(in_pclk),  
	.i_re 		(r_line_end),  
	.o_rdata 	(w_de)
);

display_hdmi_dual_clock_fifo
#(	
	.DATA_WIDTH(2),
    .ADDR_WIDTH(FIFO_WIDTH)
) 
dual_clock_fifo_in1 
(
	.i_arst 	(~in_rstn),
	.i_wclk 	(in_pclk),
	.i_we 		(r_line_start),
	.i_wdata 	({r_in_vs_3P, r_in_hs_3P}),  
	.i_rclk 	(in_pclk),  
	.i_re 		(r_line_end),  
	.o_rdata 	({w_vs, w_hs})
);

common_shift_reg
#(
	.D_WIDTH(2),
	.TAPE(PACK_DIV*3)
)
inst_shift_reg_00
(                                                                    
	.i_arst	(~in_rstn),                                               
	.i_clk	(in_pclk),
	.i_en	(1'b1),

	.i_d({w_vs, w_hs}),
	.o_q({out_vs, out_hs})                  	
);

common_shift_reg
#(
	.D_WIDTH(FIFO_WIDTH),
	.TAPE(PACK_DIV)
)
inst_shift_reg_01
(                                                                    
	.i_arst	(~in_rstn),                                               
	.i_clk	(in_pclk),
	.i_en	(1'b1),

	.i_d(r_out_x_3P),
	.o_q(w_out_x)                  	
);

/* 1 line buffer */
common_simple_dual_port_ram
#(
	. DATA_WIDTH   	(PACK_BIT),
	. ADDR_WIDTH	(FIFO_WIDTH)
)
inst_line_buffer_00
(
	.wclk	(in_pclk	),
	.we		(in_valid	),
	.waddr	(in_x		),
	.wdata	(in_data	),
		
	.rclk	(in_pclk	),
	.re		(r_out_de	),
	.raddr	(r_out_x	),
	.rdata	(w_out_data	)
);

assign	out_x		= w_out_x*PACK_DIV + r_pcnt_5P;
assign	out_y		= r_out_y_4P;
//assign	out_vs		= w_vs;
//assign	out_hs		= w_hs;
assign	out_valid	= r_out_de_5P && (w_out_x*PACK_DIV + r_pcnt_5P < (r_x_total+1)*PACK_DIV);
assign	out_de		= r_out_de_5P && (w_out_x*PACK_DIV + r_pcnt_5P < (r_x_total+1)*PACK_DIV);
assign	out_data	= r_out_data_4P;
endmodule
