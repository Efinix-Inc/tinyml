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

module display_dsi #(
   parameter FRAME_WIDTH   = 640,
   parameter FRAME_HEIGHT  = 480,
   parameter DISPLAY_PANEL = "dsi_panel_1080p"
)(
   input  wire          clk,
   input  wire          rst_n,
   
   input  wire          panel_confdone,
   input  wire          panel_on_off_sw,
   output reg           rstn_video,
   output reg  [8:0]    frame_cnt,
   input  wire          set_red_green,
   
   //DMA
   input  wire [63:0]   display_dma_rdata,
   input  wire          display_dma_rvalid,
   input  wire [7:0]    display_dma_rkeep,
   output wire          display_dma_rready,
   
   //Debug registers
   output reg           debug_display_dma_fifo_overflow,
   output reg           debug_display_dma_fifo_underflow,
   output reg  [31:0]   debug_display_dma_fifo_rcount,
   output reg  [31:0]   debug_display_dma_fifo_wcount,

   //DSI video output
   output wire          o_hs,
   output wire          o_vs,
   output wire          o_valid,
   output wire [15:0]   o_r,
   output wire [15:0]   o_g,
   output wire [15:0]   o_b
);

//-----------------------------------//
// dsi_panel_1080p
// 1080*1920 60Hz fps
//-----------------------------------//
localparam H_SyncPulse  = 10'd100;
localparam H_BackPorch  = 10'd100;
localparam H_ActivePix  = 12'd1080;
localparam H_FrontPorch = 10'd200;
localparam V_SyncPulse  = 10'd3;
localparam V_BackPorch  = 10'd5;
localparam V_ActivePix  = 12'd1920;
localparam V_FrontPorch = 10'd6;

localparam LinePeriod   = H_SyncPulse + H_BackPorch + H_ActivePix +  H_FrontPorch;
localparam Hde_Start    = H_SyncPulse + H_BackPorch;
localparam Hde_End      = H_SyncPulse + H_BackPorch + H_ActivePix;
localparam FramePeriod  = V_SyncPulse + V_BackPorch + V_ActivePix +  V_FrontPorch;
localparam Vde_Start    = V_SyncPulse + V_BackPorch;
localparam Vde_End      = V_SyncPulse + V_BackPorch + V_ActivePix;

localparam DISP_FIFO_DEPTH       = 1024;
localparam FIFO_COUNT_BIT        = $clog2(DISP_FIFO_DEPTH);

//Active display resolution after 2x scale-up
localparam DISPLAY_FRAME_WIDTH   = 2*FRAME_WIDTH;
localparam DISPLAY_FRAME_HEIGHT  = 2*FRAME_HEIGHT;

localparam IMG_OFFSET_Y  = 420;   //Offset of full display resolution height

wire [15:0]                display_dma_red;
wire [15:0]                display_dma_green;
wire [15:0]                display_dma_blue;
wire                       display_dma_pixel_valid;
wire                       display_dma_fifo_wvalid;
wire [47:0]                display_dma_fifo_wdata;
wire                       display_dma_fifo_re;
wire                       display_dma_fifo_rvalid;
wire [47:0]                display_dma_fifo_rdata;
wire [FIFO_COUNT_BIT-1:0]  display_dma_fifo_dcount;
wire                       display_dma_fifo_overflow;
wire                       display_dma_fifo_underflow;
wire                       display_vs_fall_edge;
reg                        display_valid_frames;
wire [15:0]                display_scale_red;
wire [15:0]                display_scale_green;
wire [15:0]                display_scale_blue;
wire                       display_scale_valid;
wire                       display_scale_in_ready;

reg   [10:0]               hs_cnt;
reg                        panel_on_off_sw_r1;
reg                        panel_on_off_sw_r2;
reg                        panel_off;
reg                        frame_cnt_incr_r1;
reg                        frame_cnt_incr_r2;
reg                        frame_cnt_incr_r3;

wire                       vga_gen_vs;
wire                       vga_gen_hs;
wire                       vga_gen_valid;
wire  [10:0]               vga_gen_x;
wire  [10:0]               vga_gen_y;

reg                        vga_gen_hs_r1;
reg                        vga_gen_hs_r2;
reg                        vga_gen_hs_r3;
reg                        vga_gen_hs_r4;
reg                        vga_gen_vs_r1;
reg                        vga_gen_vs_r2;
reg                        vga_gen_vs_r3;
reg                        vga_gen_valid_r1;
reg                        vga_gen_valid_r2;
reg                        vga_gen_valid_r3;
reg  [47:0]                display_pixel;
reg  [47:0]                display_red_green;

// 2PPC
display_vga_gen #(
   .H_SyncPulse   (H_SyncPulse/2),
   .H_BackPorch   (H_BackPorch/2),
   .H_ActivePix   (H_ActivePix/2),
   .H_FrontPorch  (H_FrontPorch/2),
   .V_SyncPulse   (V_SyncPulse),
   .V_BackPorch   (V_BackPorch),
   .V_ActivePix   (V_ActivePix),
   .V_FrontPorch  (V_FrontPorch),
   .P_Cnt         (3'd1)
) u_vga_gen (
   .in_pclk    (clk),
   .in_rstn    (panel_confdone),
   .out_x      (vga_gen_x),
   .out_y      (vga_gen_y),
   .out_valid  (),
   .out_de     (vga_gen_valid),
   .out_hs     (vga_gen_hs),  //Active high
   .out_vs     (vga_gen_vs)   //Active high
);

always@(negedge rst_n or posedge clk)
begin
   if (~rst_n)
   begin
      rstn_video                          <= 1'b0;
      hs_cnt                              <= 11'd0;
      frame_cnt                           <= 9'd0;
      frame_cnt_incr_r1                   <= 1'b0;
      frame_cnt_incr_r2                   <= 1'b0;
      frame_cnt_incr_r3                   <= 1'b0;
      panel_on_off_sw_r1                  <= 1'b1;
      panel_on_off_sw_r2                  <= 1'b1;
      panel_off                           <= 1'b0;
      vga_gen_hs_r1                       <= 1'b0;
      vga_gen_hs_r2                       <= 1'b0;
      vga_gen_hs_r3                       <= 1'b0;
      vga_gen_hs_r4                       <= 1'b0;
      vga_gen_vs_r1                       <= 1'b0;
      vga_gen_vs_r2                       <= 1'b0;
      vga_gen_vs_r3                       <= 1'b0;
      vga_gen_valid_r1                    <= 1'b0;
      vga_gen_valid_r2                    <= 1'b0;
      vga_gen_valid_r3                    <= 1'b0;
      display_pixel                       <= 48'd0;
      display_valid_frames                <= 1'b0;
      display_red_green                   <= 48'hffffffffffff;
      debug_display_dma_fifo_underflow    <= 1'b0;
      debug_display_dma_fifo_overflow     <= 1'b0;
      debug_display_dma_fifo_rcount       <= 32'd0;
      debug_display_dma_fifo_wcount       <= 32'd0;
   end else begin
      panel_on_off_sw_r1                  <= panel_on_off_sw;
      panel_on_off_sw_r2                  <= panel_on_off_sw_r1;
      vga_gen_hs_r1                       <= vga_gen_hs;
      vga_gen_hs_r2                       <= vga_gen_hs_r1;
      vga_gen_hs_r3                       <= vga_gen_hs_r2;
      vga_gen_hs_r4                       <= vga_gen_hs_r3;
      vga_gen_vs_r1                       <= vga_gen_vs;
      vga_gen_vs_r2                       <= vga_gen_vs_r1;
      vga_gen_vs_r3                       <= vga_gen_vs_r2;
      vga_gen_valid_r1                    <= vga_gen_valid;
      vga_gen_valid_r2                    <= vga_gen_valid_r1;
      vga_gen_valid_r3                    <= vga_gen_valid_r2;
      display_pixel                       <= (display_dma_fifo_rvalid) ? display_dma_fifo_rdata : display_red_green; //Fill bottom region of mini DSI display panel with person detection result (red/green)
      
`ifndef SIM
      display_valid_frames                <= (display_vs_fall_edge && (display_dma_fifo_dcount > ((DISP_FIFO_DEPTH/2)))) ? 1'b1 : display_valid_frames;
`else
      display_valid_frames                <= (display_dma_fifo_dcount > ((DISP_FIFO_DEPTH/2))); //Facilitate display DMA fifo data flush out during simulation
`endif

      debug_display_dma_fifo_underflow    <= (display_dma_fifo_underflow)    ? 1'b1 : debug_display_dma_fifo_underflow;
      debug_display_dma_fifo_overflow     <= (display_dma_fifo_overflow)     ? 1'b1 : debug_display_dma_fifo_overflow;
      debug_display_dma_fifo_rcount       <= (display_dma_fifo_rvalid)       ? debug_display_dma_fifo_rcount + 1'b1 : debug_display_dma_fifo_rcount;
      debug_display_dma_fifo_wcount       <= (display_dma_fifo_wvalid)       ? debug_display_dma_fifo_wcount + 1'b1 : debug_display_dma_fifo_wcount;
      
      frame_cnt_incr_r1                   <= (vga_gen_y == V_ActivePix-1) && (vga_gen_x == (H_ActivePix/2)-1);
      frame_cnt_incr_r2                   <= frame_cnt_incr_r1;
      frame_cnt_incr_r3                   <= frame_cnt_incr_r2;
      
      if (panel_on_off_sw_r1 && ~panel_on_off_sw_r2)
         panel_off <= ~panel_off;   //Set display to black if panel_off equals to 1
      
      if (frame_cnt_incr_r3)
         frame_cnt <= frame_cnt + 1'b1;
               
      if (frame_cnt && vga_gen_hs_r3 && ~vga_gen_hs_r4)
         hs_cnt <= hs_cnt + 1'b1;
      
      if (hs_cnt == V_FrontPorch)
         rstn_video <= 1'b1;
      
      if(display_vs_fall_edge)
         display_red_green <= set_red_green ? 48'h0000ffff0000 : 48'h00000000ffff;
   end
end

assign display_dma_red           = {display_dma_rdata [39:32], display_dma_rdata [7:0]};
assign display_dma_green         = {display_dma_rdata [47:40], display_dma_rdata [15:8]};
assign display_dma_blue          = {display_dma_rdata [55:48], display_dma_rdata [23:16]};
assign display_dma_pixel_valid   = display_dma_rvalid && (&display_dma_rkeep) && display_dma_rready;

//To facilitate incoming data from DMA
`ifndef SIM
   assign display_dma_rready = display_scale_in_ready;
`else
   assign display_dma_rready = 1'b1;
`endif

//Frame resolution is scaled down in camera pre-processing block to reduce overall memory/processing bandwidth requirement
//Incoming frame data from DMA is scaled up from 540x540 to 1080x1080 for display purposes
//Nearest neighbour method - 2 pixels per clock, scale up by 2x vertically and 2x horizontally
//Non-strict backpressure for out_ready. Might have one/two additional valid data out after out_ready goes down.
//Output data is valid when out_valid is high, regardless of out_ready

cam_scale_up_2x_nn #(
   .P_DEPTH        (8),
   .IN_FRAME_WIDTH (FRAME_WIDTH)
) u_display_upscaling (
   .clk        (clk),
   .rst_n      (rst_n),
   .in_red     (display_dma_red),
   .in_green   (display_dma_green),
   .in_blue    (display_dma_blue),
   .in_valid   (display_dma_pixel_valid),
   .in_ready   (display_scale_in_ready),
   .out_red    (display_scale_red),
   .out_green  (display_scale_green),
   .out_blue   (display_scale_blue),
   .out_valid  (display_scale_valid),
   .out_ready  (display_dma_fifo_dcount < (DISP_FIFO_DEPTH-10))
);

assign display_dma_fifo_wdata    = {display_scale_blue, display_scale_green, display_scale_red};
assign display_dma_fifo_wvalid   = display_scale_valid;
assign display_dma_fifo_re       = vga_gen_valid && (vga_gen_x<(DISPLAY_FRAME_WIDTH/2)) && display_valid_frames 
                                    && (vga_gen_y>=IMG_OFFSET_Y && vga_gen_y<(IMG_OFFSET_Y+DISPLAY_FRAME_HEIGHT));
assign display_vs_fall_edge      = vga_gen_vs_r1 && ~vga_gen_vs;

display_dma_fifo u_display_dma_fifo (
   .almost_full_o  (),
   .full_o         (),
   .overflow_o     (display_dma_fifo_overflow),
   .wr_ack_o       (),
   .empty_o        (),
   .almost_empty_o (),
   .underflow_o    (display_dma_fifo_underflow),
   .rd_valid_o     (display_dma_fifo_rvalid),
   .rdata          (display_dma_fifo_rdata),
   .clk_i          (clk),
   .wr_en_i        (display_dma_fifo_wvalid),
   .rd_en_i        (display_dma_fifo_re),
   .a_rst_i        (~rst_n),
   .wdata          (display_dma_fifo_wdata),
   .datacount_o    (display_dma_fifo_dcount)
);

assign o_r     = (~panel_off) ? display_pixel[15:0]  : 16'd0;
assign o_g     = (~panel_off) ? display_pixel[31:16] : 16'd0;
assign o_b     = (~panel_off) ? display_pixel[47:32] : 16'd0;
assign o_valid = vga_gen_valid_r3;
assign o_vs    = vga_gen_vs_r3;
assign o_hs    = vga_gen_hs_r3;

endmodule
