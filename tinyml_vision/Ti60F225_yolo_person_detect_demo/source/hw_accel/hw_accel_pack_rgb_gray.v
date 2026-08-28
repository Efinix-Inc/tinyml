////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/tinyml/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

module hw_accel_pack_rgb_gray #(
   parameter PACK_MODE = 0 //0: R->G->B (pack to 32-bit); 1: B->G->R (pack to 32-bit); 2: Grayscale (pack 4 pixels)
)(
   input             clk,
   input             rst,
   
   //Number of valid in data to be in multiple of 4 for correct packing
   input             in_pixel_data_valid,
   //RGB888 pixel
   input      [23:0] in_rgb_pixel_data,
   //Grayscale pixel
   input      [7:0]  in_gray_pixel_data,
   
   //Order: Least significant byte first; Mode 0: {R,B,G,R}...; Mode 1: {B,R,G,B}...
   output reg [31:0] out_packed_data,
   output reg        out_packed_data_valid
);

reg [23:0] in_rgb_pixel_data_r;
reg [7:0]  in_gray_pixel_data_r1;
reg [7:0]  in_gray_pixel_data_r2;
reg [7:0]  in_gray_pixel_data_r3;
reg [1:0]  pack_count;

always@(posedge clk) begin
   if(rst) begin
      pack_count <= 2'd0;
   end else begin
      pack_count <= (in_pixel_data_valid) ? pack_count + 1'b1 : pack_count;
   end
end

generate
   if (PACK_MODE==0) begin          //RGB: R->G->B
      always@(posedge clk) begin
         if(rst) begin
            in_rgb_pixel_data_r     <= 24'd0;
            out_packed_data         <= 32'd0;
            out_packed_data_valid   <= 1'b0;
         end else begin
            in_rgb_pixel_data_r     <= (in_pixel_data_valid) ? in_rgb_pixel_data[23:0] : in_rgb_pixel_data_r;
            out_packed_data         <= (pack_count == 2'd1) ? {in_rgb_pixel_data[7:0] , in_rgb_pixel_data_r}        :
                                       (pack_count == 2'd2) ? {in_rgb_pixel_data[15:0], in_rgb_pixel_data_r[23:8]}  :
                                       (pack_count == 2'd3) ? {in_rgb_pixel_data[23:0], in_rgb_pixel_data_r[23:16]} : 32'hFF;//32'd0;
            out_packed_data_valid   <= (pack_count > 2'd0) & in_pixel_data_valid;
         end
      end
   end else if (PACK_MODE==1) begin //RGB: B->G->R
      always@(posedge clk) begin
         if(rst) begin
            in_rgb_pixel_data_r     <= 24'd0;
            out_packed_data         <= 32'd0;
            out_packed_data_valid   <= 1'b0;
         end else begin
            in_rgb_pixel_data_r     <= (in_pixel_data_valid) ? in_rgb_pixel_data[23:0] : in_rgb_pixel_data_r;
            out_packed_data         <= (pack_count == 2'd1)  ? {in_rgb_pixel_data[23:16], in_rgb_pixel_data_r[7:0], in_rgb_pixel_data_r[15:8], in_rgb_pixel_data_r[23:16]} :
                                       (pack_count == 2'd2)  ? {in_rgb_pixel_data[15:8] , in_rgb_pixel_data[23:16], in_rgb_pixel_data_r[7:0] , in_rgb_pixel_data_r[15:8]}  :
                                       (pack_count == 2'd3)  ? {in_rgb_pixel_data[7:0]  , in_rgb_pixel_data[15:8] , in_rgb_pixel_data[23:16] , in_rgb_pixel_data_r[7:0]}   : 32'd0;
            out_packed_data_valid   <= (pack_count > 2'd0) & in_pixel_data_valid;
         end
      end
   end else begin //(PACK_MODE==2)  //Grayscale
      always@(posedge clk) begin
         if(rst) begin
            in_gray_pixel_data_r1   <= 8'd0;
            in_gray_pixel_data_r2   <= 8'd0;
            in_gray_pixel_data_r3   <= 8'd0;
            out_packed_data         <= 32'd0;
            out_packed_data_valid   <= 1'b0;
         end else begin
            in_gray_pixel_data_r1   <= (in_pixel_data_valid) ? in_gray_pixel_data    : in_gray_pixel_data_r1;
            in_gray_pixel_data_r2   <= (in_pixel_data_valid) ? in_gray_pixel_data_r1 : in_gray_pixel_data_r2;
            in_gray_pixel_data_r3   <= (in_pixel_data_valid) ? in_gray_pixel_data_r2 : in_gray_pixel_data_r3;
            out_packed_data         <= {in_gray_pixel_data, in_gray_pixel_data_r1, in_gray_pixel_data_r2, in_gray_pixel_data_r3};
            out_packed_data_valid   <= (pack_count == 2'd3) & in_pixel_data_valid;
         end
      end
   end
endgenerate

endmodule
