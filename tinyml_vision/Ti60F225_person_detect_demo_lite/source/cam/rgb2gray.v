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

module rgb2gray #(
   parameter DATA_WIDTH = 10,
   parameter PPC        = 2   //Pixel Per Clock
) (
   input  wire [PPC*DATA_WIDTH-1:0] in_red,
   input  wire [PPC*DATA_WIDTH-1:0] in_green,
   input  wire [PPC*DATA_WIDTH-1:0] in_blue,
   output wire [PPC*DATA_WIDTH-1:0] out_gray
);

genvar i;

generate
   for (i=0; i<PPC; i=i+1)
   begin
      rgb2gray_1PPC #(
         .DATA_WIDTH (DATA_WIDTH)
      ) u_rgb2gray_1PPC (
         .red   (in_red   [((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH]),
         .green (in_green [((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH]),
         .blue  (in_blue  [((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH]),
         .gray  (out_gray [((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH])
      );
   end
endgenerate

endmodule

//Tested for 8-bit per pixel. Other data width to be verified.
module rgb2gray_1PPC #(
   parameter DATA_WIDTH = 10
) (
   input  wire [DATA_WIDTH-1:0] red,
   input  wire [DATA_WIDTH-1:0] green,
   input  wire [DATA_WIDTH-1:0] blue,
   output wire [DATA_WIDTH-1:0] gray
);

wire [2*DATA_WIDTH-1:0] wr;
wire [2*DATA_WIDTH-1:0] wg1;
wire [2*DATA_WIDTH-1:0] wg;
wire [2*DATA_WIDTH-1:0] wb;
wire [2*DATA_WIDTH-1:0] wgray;

assign wr    = ((red<<6)+(red<<3))+((red<<2)+red);
assign wg1   = (green<<5)-(green<<1);
assign wg    = (wg1<<2)+wg1;
assign wb    = (blue<<5)-((blue<<1)+blue);
assign wgray = wr+wg+wb;
assign gray  = wgray[2*DATA_WIDTH-1:DATA_WIDTH];

endmodule
