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

module crop
#(
   parameter   P_DEPTH  = 10,
   parameter   X_START  = 0,
   parameter   X_WIN    = 240,
   parameter   Y_START  = 0,
   parameter   Y_WIN    = 540
)
(
   input                      in_pclk,
   input                      in_arstn,
      
   input [10:0]               in_x,
   input [10:0]               in_y,
   input                      in_valid,
   input [P_DEPTH-1:0]        in_data_00,
   input [P_DEPTH-1:0]        in_data_01,
   input [P_DEPTH-1:0]        in_data_10,
   
   output reg [10:0]          out_x,
   output reg [10:0]          out_y,
   output reg                 out_valid,
   output reg                 out_hs,
   output reg [P_DEPTH-1:0]   out_data_00,
   output reg [P_DEPTH-1:0]   out_data_01,
   output reg [P_DEPTH-1:0]   out_data_10
);

reg               r_v_active;
reg [10:0]        r_x_1P;
reg [10:0]        r_y_1P;
reg               r_valid_1P;
reg [P_DEPTH-1:0] r_data_00_1P;
reg [P_DEPTH-1:0] r_data_01_1P;
reg [P_DEPTH-1:0] r_data_10_1P;

always@(posedge in_pclk)
begin
   if (~in_arstn)
   begin
      r_v_active     <= 1'b0;
      out_y          <= 11'b0;
      r_x_1P         <= 11'b0;
      r_y_1P         <= 11'b0;
      r_valid_1P     <= 1'b0;
      r_data_00_1P   <= {P_DEPTH{1'b0}};
      r_data_01_1P   <= {P_DEPTH{1'b0}};
      r_data_10_1P   <= {P_DEPTH{1'b0}};
   end
   else
   begin 
      r_x_1P         <= in_x;
      r_y_1P         <= in_y;
      r_valid_1P     <= in_valid;
      r_data_00_1P   <= in_data_00;
      r_data_01_1P   <= in_data_01;
      r_data_10_1P   <= in_data_10;    
      
      // Start of crop
      if ((in_y == Y_START) && (in_x == X_START) && in_valid)
         r_v_active  <= 1'b1;
      // End of crop    
      if ((r_y_1P == (Y_START + Y_WIN - 1'b1)) && (r_x_1P == (X_START + X_WIN - 1'b1)) && r_valid_1P)
         r_v_active  <= 1'b0;
      // X and y counts for crop 
      if (r_v_active)
      begin
         if (out_x == (X_WIN - 1'b1))
            out_y <= out_y + 1'b1;
         
         if ((r_x_1P >= X_START) && (r_x_1P <= (X_START + X_WIN - 1'b1)))
         begin
            out_hs   <= 1'b1;
            
            if (r_valid_1P)
            begin
               out_x       <= r_x_1P - X_START;
               out_valid   <= r_valid_1P;
               out_data_00 <= r_data_00_1P;
               out_data_01 <= r_data_01_1P;
               out_data_10 <= r_data_10_1P;
            end
            else
               out_valid   <= 1'b0;
         end
         else
         begin
            out_x       <= 11'b0;
            out_valid   <= 1'b0;
            out_hs      <= 1'b0;
            out_data_00 <= {P_DEPTH{1'b0}};
            out_data_01 <= {P_DEPTH{1'b0}};
            out_data_10 <= {P_DEPTH{1'b0}};
         end
      end
      else        
      begin
         out_y       <= 11'b0;
         out_x       <= 11'b0;
         out_valid   <= 1'b0;
         out_hs      <= 1'b0;
         out_data_00 <= {P_DEPTH{1'b0}};
         out_data_01 <= {P_DEPTH{1'b0}};
         out_data_10 <= {P_DEPTH{1'b0}};
      end   
   end
end
endmodule
