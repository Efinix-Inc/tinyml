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

module hw_accel #(
   parameter DATA_WIDTH    = 32,
   parameter FRAME_WIDTH   = 540,
   parameter FRAME_HEIGHT  = 540
)(
   input  wire                   clk,
   input  wire                   rst,
   input  wire [DATA_WIDTH-1:0]  pixel_in,
   input  wire                   pixel_in_valid,
   output wire [DATA_WIDTH-1:0]  pixel_out,
   output wire                   pixel_out_valid
);

wire [23:0] pixel_out_scale_96x96;
wire        pixel_out_scale_96x96_valid;
wire [7:0]  pixel_out_grayscale_96x96;

hw_accel_nearest_neighbor_downscale #(
   .PIXEL_DATA_WIDTH       (24), //RGB888
   .IN_FRAME_WIDTH         (FRAME_WIDTH),
   .IN_FRAME_HEIGHT        (FRAME_HEIGHT),
   .OUT_FRAME_WIDTH        (96),
   .OUT_FRAME_HEIGHT       (96),
   .PPC                    (1)
) u_hw_accel_nearest_neighbor_downscale (
   .clk                    (clk),
   .rst                    (rst),
   .in_pixel_data          (pixel_in[23:0]),
   .in_pixel_data_valid    (pixel_in_valid),
   .out_pixel_data         (pixel_out_scale_96x96),
   .out_pixel_data_valid   (pixel_out_scale_96x96_valid)
);
  

//Pack grayscale pixel (8-bit) to 32-bit (4PPC) 
hw_accel_pack_rgb_gray #(
   .PACK_MODE(0) //0: R->G->B (pack to 32-bit); 1: B->G->R (pack to 32-bit); 2: Grayscale (pack 4 pixels)
) u_hw_accel_pack_rgb_gray (
   .clk                    (clk),
   .rst                    (rst),
   .in_pixel_data_valid    (pixel_out_scale_96x96_valid),
   .in_rgb_pixel_data      (pixel_out_scale_96x96),
   .in_gray_pixel_data     (8'd0),
   .out_packed_data        (pixel_out),
   .out_packed_data_valid  (pixel_out_valid)
);

endmodule
