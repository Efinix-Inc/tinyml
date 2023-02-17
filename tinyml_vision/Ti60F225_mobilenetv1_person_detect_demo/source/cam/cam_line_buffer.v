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

module cam_line_buffer #(
   parameter   P_DEPTH     = 10,          //Number of bits per pixel
   parameter   PW          = P_DEPTH*2,   //Number of pixels per clock * Number of bits per pixel - 2PPC
   parameter   FRAME_WIDTH = 640
)(
   input             i_arstn,
   input             i_pclk,
   input             i_vsync,
   input             i_valid,
   input  [PW-1:0]   i_p,
   output            o_vsync,
   output            o_valid,
   output [PW-1:0]   o_p_11,
   output [PW-1:0]   o_p_00,  
   output [PW-1:0]   o_p_01   
);

localparam PIX_COUNT_BIT = $clog2(FRAME_WIDTH/2); //2PPC. Number of address bits required for one image line

reg                       r_vsync_1P;
reg                       r_valid_1P;
reg  [PIX_COUNT_BIT-1:0]  r_addr1_1P;
reg                       r_addr1_sel_1P;
reg  [PIX_COUNT_BIT-1:0]  r_addr2_1P;
reg                       r_addr2_sel_1P;
reg                       r_vsync_2P;
reg                       r_valid_2P;
reg  [PW-1:0]             r_p_01_0P;
reg  [PW-1:0]             r_p_01_1P;
wire [PW-1:0]             w_p_11_1P;
wire [PW-1:0]             w_p_00_1P;
reg  [PIX_COUNT_BIT-1:0]  pixel_count;
wire                      vsync_falling_edge;
wire                      end_of_img_line;

//Dual port RAM for 2 lines buffer
common_true_dual_port_ram #(
   .DATA_WIDTH(PW),
   .ADDR_WIDTH(PIX_COUNT_BIT + 1),
   .WRITE_MODE_1("READ_FIRST"),
   .WRITE_MODE_2("READ_FIRST"),
   .OUTPUT_REG_1("FALSE"),
   .OUTPUT_REG_2("FALSE"),
   .RAM_INIT_FILE("")
) inst_y_buffer (
   .we1   (1'b1),
   .clka  (i_pclk),
   .din1  (r_p_01_0P),
   .addr1 ({r_addr1_sel_1P, r_addr1_1P}),
   .dout1 (w_p_11_1P),
   .we2   (1'b0),
   .clkb  (i_pclk),
   .din2  (r_p_01_0P),
   .addr2 ({r_addr2_sel_1P, r_addr2_1P}),
   .dout2 (w_p_00_1P)
);

assign vsync_falling_edge = r_vsync_1P && ~i_vsync;
assign end_of_img_line    = r_valid_2P && (pixel_count==(FRAME_WIDTH/2)-1);

always@(posedge i_pclk)
begin
   if (~i_arstn)
   begin
      pixel_count    <= {PIX_COUNT_BIT{1'b0}};
      r_vsync_1P     <= 1'b0;
      r_vsync_2P     <= 1'b0;
      r_valid_1P     <= 1'b0;
      r_valid_2P     <= 1'b0;
      r_p_01_0P      <= {PW{1'b0}};
      r_p_01_1P      <= {PW{1'b0}};
      r_addr1_1P     <= {PIX_COUNT_BIT{1'b0}};
      r_addr1_sel_1P <= 1'b0;
      r_addr2_1P     <= {PIX_COUNT_BIT{1'b0}};
      r_addr2_sel_1P <= 1'b1;
   end
   else
   begin
      pixel_count    <= ((r_valid_2P && (pixel_count==(FRAME_WIDTH/2)-1)) || (vsync_falling_edge)) ? {PIX_COUNT_BIT{1'b0}} : 
                        (r_valid_2P)                                                               ? pixel_count + 1'b1    : pixel_count;
      r_vsync_1P     <= i_vsync;
      r_valid_1P     <= i_valid;
      r_p_01_0P      <= i_p;
      
      if (i_valid)
      begin
         r_addr1_1P  <= r_addr1_1P+1'b1;
         r_addr2_1P  <= r_addr2_1P+1'b1;  
      end

      if (end_of_img_line)
      begin
         r_addr1_sel_1P <= ~r_addr1_sel_1P;
         r_addr1_1P     <= {PIX_COUNT_BIT{1'b0}};
      
         r_addr2_sel_1P <= ~r_addr2_sel_1P;
         r_addr2_1P     <= {PIX_COUNT_BIT{1'b0}};
      end
      
      if (r_vsync_2P && !r_vsync_1P)
      begin
         r_p_01_0P      <= {PW{1'b0}};
         r_addr1_1P     <= {PIX_COUNT_BIT{1'b0}};
         r_addr1_sel_1P <= 1'b0;
         r_addr2_1P     <= {PIX_COUNT_BIT{1'b0}};
         r_addr2_sel_1P <= 1'b1;
      end
      
      r_vsync_2P  <= r_vsync_1P;
      r_valid_2P  <= r_valid_1P;
      r_p_01_1P   <= r_p_01_0P;
   end
end

assign o_vsync = r_vsync_2P;
assign o_valid = r_valid_2P;
assign o_p_11  = w_p_11_1P [PW-1:0];
assign o_p_00  = w_p_00_1P [PW-1:0];
assign o_p_01  = r_p_01_1P [PW-1:0];

endmodule
