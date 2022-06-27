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

module rgb_gain #(
   parameter   P_DEPTH     = 10,
   parameter   PW          = P_DEPTH*4,   //4PPC
   parameter   FRAME_WIDTH = 640
)(
   input           i_pclk,
   input           i_arstn,
   input           i_vs,
   input           i_valid,
   input [PW-1:0]  i_data,
   input [2:0]     blue_gain,
   input [2:0]     green_gain,
   input [2:0]     red_gain,
   output          o_vs,
   output          o_valid,
   output [PW-1:0] o_data
);

localparam PIX_COUNT_BIT = $clog2(FRAME_WIDTH/4); //4PPC

wire [P_DEPTH:0]         odd_line_byte_3;
wire [P_DEPTH:0]         odd_line_byte_2;
wire [P_DEPTH:0]         odd_line_byte_1;
wire [P_DEPTH:0]         odd_line_byte_0;

wire [P_DEPTH-1:0]       odd_line_pix_3;
wire [P_DEPTH-1:0]       odd_line_pix_2;
wire [P_DEPTH-1:0]       odd_line_pix_1;
wire [P_DEPTH-1:0]       odd_line_pix_0;

wire [P_DEPTH:0]         even_line_byte_3;
wire [P_DEPTH:0]         even_line_byte_2;
wire [P_DEPTH:0]         even_line_byte_1;
wire [P_DEPTH:0]         even_line_byte_0;

wire [P_DEPTH-1:0]       even_line_pix_3;
wire [P_DEPTH-1:0]       even_line_pix_2;
wire [P_DEPTH-1:0]       even_line_pix_1;
wire [P_DEPTH-1:0]       even_line_pix_0;

wire [P_DEPTH-1:0]       byte_3_div_1;
wire [P_DEPTH-1:0]       byte_3_div_2;
wire [P_DEPTH-1:0]       byte_3_div_4;
wire [P_DEPTH-1:0]       byte_2_div_1;
wire [P_DEPTH-1:0]       byte_2_div_2;
wire [P_DEPTH-1:0]       byte_2_div_4;
wire [P_DEPTH-1:0]       byte_1_div_1;
wire [P_DEPTH-1:0]       byte_1_div_2;
wire [P_DEPTH-1:0]       byte_1_div_4;
wire [P_DEPTH-1:0]       byte_0_div_1;
wire [P_DEPTH-1:0]       byte_0_div_2;
wire [P_DEPTH-1:0]       byte_0_div_4;

reg  [PIX_COUNT_BIT-1:0] pixel_count;
wire                     vsync_falling_edge;
wire                     end_of_img_line;
reg                      i_vs_r;
reg                      r_line_cnt;

assign vsync_falling_edge = i_vs_r && !i_vs;
assign end_of_img_line    = i_valid && (pixel_count==(FRAME_WIDTH/4)-1);

always@(posedge i_pclk)
begin
   if (~i_arstn)
   begin
      pixel_count <= {PIX_COUNT_BIT{1'b0}};
      i_vs_r      <= 1'b0;
      r_line_cnt  <= 1'b0;
   end else begin
      pixel_count <= ((i_valid && (pixel_count==(FRAME_WIDTH/4)-1)) || (vsync_falling_edge)) ? {PIX_COUNT_BIT{1'b0}} : (i_valid) ? pixel_count + 1'b1 : pixel_count;
      i_vs_r      <= i_vs;
      r_line_cnt  <= (i_vs_r && !i_vs) ? 1'b0 : (end_of_img_line) ? ~r_line_cnt : r_line_cnt;
   end
end

//RGB gain filter
assign byte_3_div_1 = i_data[PW-1:P_DEPTH*3];
assign byte_3_div_2 = byte_3_div_1 >> 1;
assign byte_3_div_4 = byte_3_div_1 >> 2;
assign byte_2_div_1 = i_data[P_DEPTH*3-1:P_DEPTH*2];
assign byte_2_div_2 = byte_2_div_1 >> 1;
assign byte_2_div_4 = byte_2_div_1 >> 2;
assign byte_1_div_1 = i_data[P_DEPTH*2-1:P_DEPTH];
assign byte_1_div_2 = byte_1_div_1 >> 1;
assign byte_1_div_4 = byte_1_div_1 >> 2;
assign byte_0_div_1 = i_data[P_DEPTH-1:0];
assign byte_0_div_2 = byte_0_div_1 >> 1;
assign byte_0_div_4 = byte_0_div_1 >> 2;

assign odd_line_byte_3 = green_gain[2] ? 
          byte_3_div_1+(byte_3_div_2 & {P_DEPTH{green_gain[1]}})+(byte_3_div_4 & {P_DEPTH{green_gain[0]}}):
          byte_3_div_1-byte_3_div_4-(byte_3_div_2 & {P_DEPTH{~green_gain[1]}})-(byte_3_div_4 & {P_DEPTH{~green_gain[0]}});
assign odd_line_byte_2 = red_gain[2] ? 
          byte_2_div_1+(byte_2_div_2 & {P_DEPTH{red_gain[1]}})+(byte_2_div_4 & {P_DEPTH{red_gain[0]}}):
          byte_2_div_1-byte_2_div_4-(byte_2_div_2 & {P_DEPTH{~red_gain[1]}})-(byte_2_div_4 & {P_DEPTH{~red_gain[0]}});
assign odd_line_byte_1 = green_gain[2] ? 
          byte_1_div_1+(byte_1_div_2 & {P_DEPTH{green_gain[1]}})+(byte_1_div_4 & {P_DEPTH{green_gain[0]}}):
          byte_1_div_1-byte_1_div_4-(byte_1_div_2 & {P_DEPTH{~green_gain[1]}})-(byte_1_div_4 & {P_DEPTH{~green_gain[0]}});
assign odd_line_byte_0 = red_gain[2] ? 
          byte_0_div_1+(byte_0_div_2 & {P_DEPTH{red_gain[1]}})+(byte_0_div_4 & {P_DEPTH{red_gain[0]}}):
          byte_0_div_1-byte_0_div_4-(byte_0_div_2 & {P_DEPTH{~red_gain[1]}})-(byte_0_div_4 & {P_DEPTH{~red_gain[0]}});
assign even_line_byte_3 = blue_gain[2] ? 
          byte_3_div_1+(byte_3_div_2 & {P_DEPTH{blue_gain[1]}})+(byte_3_div_4 & {P_DEPTH{blue_gain[0]}}):
          byte_3_div_1-byte_3_div_4-(byte_3_div_2 & {P_DEPTH{~blue_gain[1]}})-(byte_3_div_4 & {P_DEPTH{~blue_gain[0]}});
assign even_line_byte_2 = green_gain[2] ? 
          byte_2_div_1+(byte_2_div_2 & {P_DEPTH{green_gain[1]}})+(byte_2_div_4 & {P_DEPTH{green_gain[0]}}):
          byte_2_div_1-byte_2_div_4-(byte_2_div_2 & {P_DEPTH{~green_gain[1]}})-(byte_2_div_4 & {P_DEPTH{~green_gain[0]}});
assign even_line_byte_1 = blue_gain[2] ? 
          byte_1_div_1+(byte_1_div_2 & {P_DEPTH{blue_gain[1]}})+(byte_1_div_4 & {P_DEPTH{blue_gain[0]}}):
          byte_1_div_1-byte_1_div_4-(byte_1_div_2 & {P_DEPTH{~blue_gain[1]}})-(byte_1_div_4 & {P_DEPTH{~blue_gain[0]}});
assign even_line_byte_0 = green_gain[2] ? 
          byte_0_div_1+(byte_0_div_2 & {P_DEPTH{green_gain[1]}})+(byte_0_div_4 & {P_DEPTH{green_gain[0]}}):
          byte_0_div_1-byte_0_div_4-(byte_0_div_2 & {P_DEPTH{~green_gain[1]}})-(byte_0_div_4 & {P_DEPTH{~green_gain[0]}});

assign odd_line_pix_3  = odd_line_byte_3[P_DEPTH]  ? {P_DEPTH{1'b1}} : odd_line_byte_3[P_DEPTH-1:0];
assign odd_line_pix_2  = odd_line_byte_2[P_DEPTH]  ? {P_DEPTH{1'b1}} : odd_line_byte_2[P_DEPTH-1:0];
assign odd_line_pix_1  = odd_line_byte_1[P_DEPTH]  ? {P_DEPTH{1'b1}} : odd_line_byte_1[P_DEPTH-1:0];
assign odd_line_pix_0  = odd_line_byte_0[P_DEPTH]  ? {P_DEPTH{1'b1}} : odd_line_byte_0[P_DEPTH-1:0];
assign even_line_pix_3 = even_line_byte_3[P_DEPTH] ? {P_DEPTH{1'b1}} : even_line_byte_3[P_DEPTH-1:0];
assign even_line_pix_2 = even_line_byte_2[P_DEPTH] ? {P_DEPTH{1'b1}} : even_line_byte_2[P_DEPTH-1:0];
assign even_line_pix_1 = even_line_byte_1[P_DEPTH] ? {P_DEPTH{1'b1}} : even_line_byte_1[P_DEPTH-1:0];
assign even_line_pix_0 = even_line_byte_0[P_DEPTH] ? {P_DEPTH{1'b1}} : even_line_byte_0[P_DEPTH-1:0];


assign o_vs    = i_vs;
assign o_valid = i_valid;
assign o_data  = (r_line_cnt) ? {even_line_pix_3,even_line_pix_2,even_line_pix_1,even_line_pix_0} : {odd_line_pix_3, odd_line_pix_2, odd_line_pix_1, odd_line_pix_0};
//assign o_data = (~r_line_cnt) ? {even_line_pix_3,even_line_pix_2,even_line_pix_1,even_line_pix_0} : {odd_line_pix_3, odd_line_pix_2, odd_line_pix_1, odd_line_pix_0};

endmodule
