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

module hw_accel_nearest_neighbor_downscale #(
   parameter PIXEL_DATA_WIDTH = 8,
   parameter IN_FRAME_WIDTH   = 8,
   parameter IN_FRAME_HEIGHT  = 8,
   parameter OUT_FRAME_WIDTH  = 3,
   parameter OUT_FRAME_HEIGHT = 3,
   parameter PPC              = 1 //Pixel per clock: Support for 1 and 2 only
)(
   input                                  clk,
   input                                  rst,
   input      [PPC*PIXEL_DATA_WIDTH-1:0]  in_pixel_data,
   input                                  in_pixel_data_valid,
   output reg [PPC*PIXEL_DATA_WIDTH-1:0]  out_pixel_data,
   output reg                             out_pixel_data_valid
);

localparam X_RATIO = ((IN_FRAME_WIDTH<<16)/OUT_FRAME_WIDTH)+1;
localparam Y_RATIO = ((IN_FRAME_HEIGHT<<16)/OUT_FRAME_HEIGHT)+1;

//To use log to determine required number of counter bits
reg [10:0]  in_x_count;
reg [10:0]  in_y_count;
reg [10:0]  out_x_count;
reg [10:0]  out_y_count;

reg [10:0]  mapped_x_index;
reg [10:0]  mapped_y_index;

//Pipelined registers
reg [10:0]                       in_x_count_r;
reg [10:0]                       in_y_count_r;
reg                              in_pixel_data_valid_r;
reg [PPC*PIXEL_DATA_WIDTH-1:0]   in_pixel_data_r;

wire                             out_pixel_data_valid_pre;

//Applicable for 2PPC only
reg  [10:0]                   mapped_x2_index;
wire                          even_pixel_hit;
wire                          odd_pixel_hit;
wire                          both_pixel_hit;
reg                           valid_count;
reg  [PIXEL_DATA_WIDTH-1:0]   out_pixel_data_hold;

generate

   if(PPC==1)
   begin
      always@(posedge clk) begin
         if (rst) begin
            in_x_count              <= 11'd0;
            in_y_count              <= 11'd0;
            out_x_count             <= 11'd0;
            out_y_count             <= 11'd0;
            out_pixel_data          <= {PPC*PIXEL_DATA_WIDTH{1'b0}};
            out_pixel_data_valid    <= 1'b0;
            mapped_x_index          <= 11'd0;
            mapped_y_index          <= 11'd0;
            in_x_count_r            <= 11'd0;
            in_y_count_r            <= 11'd0;
            in_pixel_data_valid_r   <= 1'b0;
            in_pixel_data_r         <= {PPC*PIXEL_DATA_WIDTH{1'b0}};
         end else begin
            in_x_count              <= (in_pixel_data_valid & (in_x_count==IN_FRAME_WIDTH-1)) ? 11'd0 : 
                                       (in_pixel_data_valid)                                  ? in_x_count + 1'b1 : in_x_count;
            in_y_count              <= (in_pixel_data_valid & (in_x_count==IN_FRAME_WIDTH-1) & (in_y_count==IN_FRAME_HEIGHT-1)) ? 11'd0 : 
                                       (in_pixel_data_valid & (in_x_count==IN_FRAME_WIDTH-1))                                   ? in_y_count + 1'b1 : in_y_count;
            out_x_count             <= (out_pixel_data_valid_pre & (out_x_count==OUT_FRAME_WIDTH-1)) ? 11'd0 : 
                                       (out_pixel_data_valid_pre)                                    ? out_x_count + 1'b1 : out_x_count;
            out_y_count             <= (out_pixel_data_valid_pre & (out_x_count==OUT_FRAME_WIDTH-1) & (out_y_count==OUT_FRAME_HEIGHT-1)) ? 11'd0 : 
                                       (out_pixel_data_valid_pre & (out_x_count==OUT_FRAME_WIDTH-1))                                     ? out_y_count + 1'b1 : out_y_count;
            out_pixel_data_valid    <= out_pixel_data_valid_pre;
            out_pixel_data          <= (out_pixel_data_valid_pre) ? in_pixel_data_r : {PIXEL_DATA_WIDTH{1'b0}}; //in_pixel_data_r;
            mapped_x_index          <= (out_x_count*X_RATIO) >> 16;  //To optimize with known X_RATIO, user may map multiplication by constant to shift add.
            mapped_y_index          <= (out_y_count*Y_RATIO) >> 16;  //To optimize with known Y_RATIO, user may map multiplication by constant to shift add.
            
            in_x_count_r            <= in_x_count;
            in_y_count_r            <= in_y_count;
            in_pixel_data_valid_r   <= in_pixel_data_valid;
            in_pixel_data_r         <= in_pixel_data;
         end
      end
      
      assign out_pixel_data_valid_pre = (in_x_count_r == mapped_x_index) & (in_y_count_r == mapped_y_index) & in_pixel_data_valid_r;
   
   end else begin //(PPC==2)
      always@(posedge clk) begin
         if (rst) begin
            in_x_count              <= 11'd0;
            in_y_count              <= 11'd0;
            out_x_count             <= 11'd0;
            out_y_count             <= 11'd0;
            out_pixel_data          <= {PPC*PIXEL_DATA_WIDTH{1'b0}};
            out_pixel_data_valid    <= 1'b0;
            out_pixel_data_hold     <= {PIXEL_DATA_WIDTH{1'b0}};
            valid_count             <= 1'b0;
            mapped_x_index          <= 11'd0;
            mapped_x2_index         <= 11'd0;
            mapped_y_index          <= 11'd0;
            in_x_count_r            <= 11'd0;
            in_y_count_r            <= 11'd0;
            in_pixel_data_valid_r   <= 1'b0;
            in_pixel_data_r         <= {PPC*PIXEL_DATA_WIDTH{1'b0}};
         end else begin
            in_x_count           <= (in_pixel_data_valid & (in_x_count==IN_FRAME_WIDTH/2-1)) ? 11'd0 : 
                                    (in_pixel_data_valid)                                    ? in_x_count + 1'b1 : in_x_count;
            in_y_count           <= (in_pixel_data_valid & (in_x_count==IN_FRAME_WIDTH/2-1) & (in_y_count==IN_FRAME_HEIGHT-1)) ? 11'd0 : 
                                    (in_pixel_data_valid & (in_x_count==IN_FRAME_WIDTH/2-1))                                   ? in_y_count + 1'b1 : in_y_count;                                    
            out_x_count          <= (out_pixel_data_valid_pre & (out_x_count==OUT_FRAME_WIDTH/2-1)) ? 11'd0 : 
                                    (out_pixel_data_valid_pre)                                      ? out_x_count + 1'b1 : out_x_count;
            out_y_count          <= (out_pixel_data_valid_pre & (out_x_count==OUT_FRAME_WIDTH/2-1) & (out_y_count==OUT_FRAME_HEIGHT-1)) ? 11'd0 : 
                                    (out_pixel_data_valid_pre & (out_x_count==OUT_FRAME_WIDTH/2-1))                                     ? out_y_count + 1'b1 : out_y_count;

            valid_count          <= (!valid_count & both_pixel_hit)  ? 1'b0 :
                                    (valid_count & both_pixel_hit)   ? 1'b1 :
                                    (even_pixel_hit | odd_pixel_hit) ? valid_count + 1'b1 : valid_count;
            
            //Hold output data until a pair is formed for 2PPC outputs
            out_pixel_data_hold  <= ((valid_count & both_pixel_hit) | (!valid_count & (!even_pixel_hit) & odd_pixel_hit)) ? in_pixel_data_r[2*PIXEL_DATA_WIDTH-1:PIXEL_DATA_WIDTH] :
                                    (!valid_count & (!odd_pixel_hit) & even_pixel_hit)                                    ? in_pixel_data_r[PIXEL_DATA_WIDTH-1:0]                  : out_pixel_data_hold;
            
            out_pixel_data       <= (!valid_count & both_pixel_hit)                    ? in_pixel_data_r :
                                    (valid_count & (both_pixel_hit | even_pixel_hit))  ? {in_pixel_data_r[PIXEL_DATA_WIDTH-1:0], out_pixel_data_hold} :
                                    (valid_count & odd_pixel_hit)                      ? {in_pixel_data_r[2*PIXEL_DATA_WIDTH-1:PIXEL_DATA_WIDTH], out_pixel_data_hold} : {PPC*PIXEL_DATA_WIDTH{1'b0}};
                                    
            mapped_x_index       <= ((out_x_count*2)*X_RATIO) >> 16;    //To optimize with known X_RATIO, user may map multiplication by constant to shift add.
            mapped_x2_index      <= ((out_x_count*2+1)*X_RATIO) >> 16;  //To optimize with known X_RATIO, user may map multiplication by constant to shift add.
            mapped_y_index       <= (out_y_count*Y_RATIO) >> 16;        //To optimize with known Y_RATIO, user may map multiplication by constant to shift add.
            
            in_x_count_r            <= in_x_count;
            in_y_count_r            <= in_y_count;
            in_pixel_data_valid_r   <= in_pixel_data_valid;
            in_pixel_data_r         <= in_pixel_data;
            
            out_pixel_data_valid <= out_pixel_data_valid_pre;
         end
      end
      
      assign even_pixel_hit            = (((in_x_count_r*2) == mapped_x_index) | ((in_x_count_r*2) == mapped_x2_index)) & (in_y_count_r == mapped_y_index) & in_pixel_data_valid_r;
      assign odd_pixel_hit             = (((in_x_count_r*2+1) == mapped_x_index) | ((in_x_count_r*2+1) == mapped_x2_index)) & (in_y_count_r == mapped_y_index) & in_pixel_data_valid_r;
      assign both_pixel_hit            = even_pixel_hit & odd_pixel_hit;
      
      assign out_pixel_data_valid_pre  = both_pixel_hit | (valid_count & (even_pixel_hit | odd_pixel_hit));
   
   end

endgenerate

endmodule