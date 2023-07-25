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

module display_hdmi_rgb_to_yuv (
    input logic             iHdmiClk,
    input logic             iRst_n,
    
    // Rgb input
    input logic     [7:0]   iv8Red,
    input logic     [7:0]   iv8Green,
    input logic     [7:0]   iv8Blue,
    input logic             iRgbVd,
    input logic             iRgbVs,
    input logic             iRgbHs,
    
    // HDMI YUV output
    output logic            oHdmiYuvVs,
    output logic            oHdmiYuvHs,
    output logic            oHdmiYuvDe,
    output logic    [15:0]  ov16HdmiYuvData 
);

// Variable Declaration

//RGB to YCbCr
reg	    r_yuv_cnt;
reg	    r_yuv_vs_1P ;
reg	    r_yuv_hs_1P ;
reg	    r_yuv_de_1P ;
reg	    r_yuv_vs_2P ;
reg	    r_yuv_hs_2P ;
reg	    r_yuv_de_2P ;
reg	    r_yuv_vs_3P ;
reg	    r_yuv_hs_3P ;
reg	    r_yuv_de_3P ;
reg	    r_yuv_vs_4P ;
reg	    r_yuv_hs_4P ;
reg	    r_yuv_de_4P ;
reg	    r_yuv_vs_5P ;
reg	    r_yuv_hs_5P ;
reg	    r_yuv_de_5P ;
reg	    r_yuv_vs_6P ;
reg	    r_yuv_hs_6P ;
reg	    r_yuv_de_6P ;
reg	    r_yuv_vs_7P ;
reg	    r_yuv_hs_7P ;
reg	    r_yuv_de_7P ;
reg	    [7:0]	r_r_in;
reg	    [7:0]	r_g_in;
reg	    [7:0]	r_b_in;
reg	    [15:0]	r_yuv_data_6P;
reg     [11:0] 	r_yuv_x_cnt;
reg     [11:0] 	r_yuv_frame_cnt;
reg	    r_yuv_hs_out;
reg	    r_yuv_vs_out;
    
wire    w_de_out;
wire     [7:0]	w_y_out;
wire     [7:0]	w_cb_out;
wire     [7:0]	w_cr_out;

// YCbCr video output
reg            yuv_vs;
reg            yuv_hs;
reg            yuv_de;
reg    [15:0]  yuv_data;


// 5 RL
display_hdmi_color_coding_converter #(
    .Y_OFFSET   (8'd16),
    .ROM_A00    ("source/display/hdmi/mif_yuv/rom_a00.mem"),
    .ROM_A01    ("source/display/hdmi/mif_yuv/rom_a01.mem"),
    .ROM_A02    ("source/display/hdmi/mif_yuv/rom_a02.mem"),
    .ROM_A10    ("source/display/hdmi/mif_yuv/rom_a10.mem"),
    .ROM_A11    ("source/display/hdmi/mif_yuv/rom_a11.mem"),
    .ROM_A12    ("source/display/hdmi/mif_yuv/rom_a12.mem"),
    .ROM_A20    ("source/display/hdmi/mif_yuv/rom_a20.mem"),
    .ROM_A21    ("source/display/hdmi/mif_yuv/rom_a21.mem"),
    .ROM_A22    ("source/display/hdmi/mif_yuv/rom_a22.mem")
) inst_RGB_to_YCbCr_in0 (
    .i_arst         (~iRst_n),
    .i_pclk         (iHdmiClk),
    .i_en           (1'b1),
 
    .i_rgb2yuv_de   (iRgbVd),//(wVgaGenVd),

    .i_rgb2yuv_r    (iv8Red),
    .i_rgb2yuv_g    (iv8Green),
    .i_rgb2yuv_b    (iv8Blue),
    
    .o_rgb2yuv_de   (w_de_out	),
    .o_rgb2yuv_y    (w_y_out	),
    .o_rgb2yuv_u    (w_cb_out	),
    .o_rgb2yuv_v    (w_cr_out	),
    
    .i_yuv2rgb_de   (1'b0),
    .i_yuv2rgb_y    ('b0),
    .i_yuv2rgb_u    ('b0),
    .i_yuv2rgb_v    ('b0),
    .o_yuv2rgb_de   (),
    .o_yuv2rgb_r    (),
    .o_yuv2rgb_g    (),
    .o_yuv2rgb_b    ()
);

/* Remap 2 pixels per clock to odd and even yuv pixels */
always @(posedge iHdmiClk) begin 
    if(~iRst_n)	begin
        r_yuv_cnt		<= 1'b0;
        r_yuv_vs_1P     <= 1'b0;
        r_yuv_hs_1P     <= 1'b0;
        r_yuv_de_1P     <= 1'b0;
        r_yuv_vs_2P     <= 1'b0;
        r_yuv_hs_2P     <= 1'b0;
        r_yuv_de_2P     <= 1'b0;
        r_yuv_vs_3P     <= 1'b0;
        r_yuv_hs_3P     <= 1'b0;
        r_yuv_de_3P     <= 1'b0;
        r_yuv_vs_4P     <= 1'b0;
        r_yuv_hs_4P     <= 1'b0;
        r_yuv_de_4P     <= 1'b0;
        r_yuv_vs_5P     <= 1'b0;
        r_yuv_hs_5P     <= 1'b0;
        r_yuv_de_5P     <= 1'b0;
        r_yuv_vs_6P     <= 1'b0;
        r_yuv_hs_6P     <= 1'b0;
        r_yuv_de_6P     <= 1'b0;
        r_yuv_vs_7P     <= 1'b0;
        r_yuv_hs_7P     <= 1'b0;
        r_yuv_de_7P     <= 1'b0;
        r_yuv_x_cnt		<= 11'b0;
        r_yuv_frame_cnt	<= 11'b0;
        r_yuv_hs_out    <= 1'b0;
        r_yuv_vs_out    <= 1'b0;
        r_yuv_data_6P	<= 16'b0;
    end	else begin
        r_yuv_vs_1P     <= iRgbVs ;
        r_yuv_hs_1P     <= iRgbHs ;
        r_yuv_vs_2P     <= r_yuv_vs_1P ;
        r_yuv_hs_2P     <= r_yuv_hs_1P ;
        r_yuv_vs_3P     <= r_yuv_vs_2P ;
        r_yuv_hs_3P     <= r_yuv_hs_2P ;
        r_yuv_vs_4P     <= r_yuv_vs_3P ;
        r_yuv_hs_4P     <= r_yuv_hs_3P ;
        r_yuv_vs_5P     <= r_yuv_vs_4P ;
        r_yuv_hs_5P     <= r_yuv_hs_4P ;
        r_yuv_vs_6P     <= r_yuv_vs_5P ;
        r_yuv_hs_6P     <= r_yuv_hs_5P ;
        r_yuv_de_6P     <= w_de_out ;
        r_yuv_vs_7P     <= r_yuv_vs_6P ;
        r_yuv_hs_7P     <= r_yuv_hs_6P ;
        
        if (w_de_out) begin
            r_yuv_cnt	<= ~r_yuv_cnt;
            r_yuv_x_cnt	<= r_yuv_x_cnt + 1'b1;
        end else begin
            r_yuv_cnt	<= 1'b0;
            r_yuv_x_cnt	<= 11'b0;
        end
        
        if (r_yuv_cnt)
            r_yuv_data_6P	<= {w_cr_out, w_y_out};
        else
            r_yuv_data_6P	<= {w_cb_out, w_y_out};
                
        yuv_vs  	<= ~r_yuv_vs_6P;
        yuv_hs  	<= ~r_yuv_hs_6P;
        yuv_de  	<= r_yuv_de_6P;
        yuv_data	<= r_yuv_data_6P;
        
        if (~r_yuv_vs_6P && r_yuv_vs_7P)
            r_yuv_frame_cnt	<= r_yuv_frame_cnt + 1'b1;
    end
end

assign  oHdmiYuvVs = yuv_vs;
assign  oHdmiYuvHs = yuv_hs;
assign  oHdmiYuvDe = yuv_de;
assign  ov16HdmiYuvData = yuv_data;

endmodule