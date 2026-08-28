////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2026 Efinix Inc. All rights reserved.
// See https://github.com/Efinix-Inc/tinyml/blob/main/LICENSE.txt for details.
////////////////////////////////////////////////////////////////////////////////

module hw_accel_rgb2gray #(
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
      hw_accel_rgb2gray_1PPC #(
         .DATA_WIDTH (DATA_WIDTH)
      ) u_hw_accel_rgb2gray_1PPC (
         .red   (in_red   [((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH]),
         .green (in_green [((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH]),
         .blue  (in_blue  [((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH]),
         .gray  (out_gray [((i+1)*DATA_WIDTH)-1:i*DATA_WIDTH])
      );
   end
endgenerate

endmodule

//Tested for 8-bit per pixel. Other data width to be verified.
module hw_accel_rgb2gray_1PPC #(
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
