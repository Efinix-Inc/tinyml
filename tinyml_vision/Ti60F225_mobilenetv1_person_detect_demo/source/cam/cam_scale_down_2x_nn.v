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

module cam_scale_down_2x_nn #(
   parameter P_DEPTH        = 8,
   parameter IN_FRAME_WIDTH = 1080 //Multiple of 4 to facilitate for 2PPC 2x scale down
)(
   input                         clk,
   input                         rst_n,
   input       [10:0]            in_x,
   input       [10:0]            in_y,
   input       [P_DEPTH*2-1:0]   in_red,
   input       [P_DEPTH*2-1:0]   in_green,
   input       [P_DEPTH*2-1:0]   in_blue,
   input                         in_valid,
   output reg  [P_DEPTH*2-1:0]   out_red,
   output reg  [P_DEPTH*2-1:0]   out_green,
   output reg  [P_DEPTH*2-1:0]   out_blue,
   output reg                    out_valid
);

//Custom version for scale down by 2x on 2PPC using nearest neighbour method
//Input frame width to be multiple of 4

reg               alternate_valid;
reg [P_DEPTH-1:0] lsb_red;
reg [P_DEPTH-1:0] lsb_green;
reg [P_DEPTH-1:0] lsb_blue;

always@(posedge clk)
begin
   if (~rst_n) begin
      alternate_valid <= 1'b0;
      lsb_red         <= {P_DEPTH{1'b0}};
      lsb_green       <= {P_DEPTH{1'b0}};
      lsb_blue        <= {P_DEPTH{1'b0}};
      out_valid       <= 1'b0;
      out_red         <= {2*P_DEPTH{1'b0}};
      out_green       <= {2*P_DEPTH{1'b0}};
      out_blue        <= {2*P_DEPTH{1'b0}};
   end else begin
      //Keep even pixels and even rows only
      //Assume total number of pixels and rows are even numbers
      alternate_valid <= (in_valid & (in_x==IN_FRAME_WIDTH/2-1)) ? 1'b0 : (in_valid) ? ~alternate_valid : alternate_valid;
      lsb_red         <= (in_valid & (~alternate_valid)) ? in_red   [P_DEPTH-1:0] : lsb_red;
      lsb_green       <= (in_valid & (~alternate_valid)) ? in_green [P_DEPTH-1:0] : lsb_green;
      lsb_blue        <= (in_valid & (~alternate_valid)) ? in_blue  [P_DEPTH-1:0] : lsb_blue;
      out_valid       <= (in_y[0] == 1'b0) & in_valid & alternate_valid;
      out_red         <= {in_red   [P_DEPTH-1:0], lsb_red};
      out_green       <= {in_green [P_DEPTH-1:0], lsb_green};
      out_blue        <= {in_blue  [P_DEPTH-1:0], lsb_blue};
   end
end

endmodule
