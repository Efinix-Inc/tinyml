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


module cam_picam #(
   //Input resolution from camera MIPI interface
   parameter MIPI_FRAME_WIDTH     = 11'd1920,  
   parameter MIPI_FRAME_HEIGHT    = 11'd1080,
   //Output resolution to DDR - Pre-processed & Scale/Cropped
   parameter FRAME_WIDTH          = 11'd640,
   parameter FRAME_HEIGHT         = 11'd480,
   //0: Crop to output resolution; 1: Scale to output resolution
   parameter CROP_SCALE           = 0,
   //Should match with firmware DMA transfer length
   parameter DMA_TRANSFER_LENGTH  = 1920,
   //Should match with mipi_pclk clock rate
   parameter MIPI_PCLK_CLK_RATE   = 75000000
) (
   input  wire        mipi_pclk,
   input  wire        rst_n,
 
   //Input camera frame data from MIPI interface
   input  wire [63:0] mipi_cam_data,
   input  wire        mipi_cam_valid,
   input  wire        mipi_cam_vs,
   input  wire        mipi_cam_hs,
   input  wire [5:0]  mipi_cam_type,
   input  wire [17:0] mipi_cam_error,
   input  wire [1:0]  mipi_cam_vc,
   input  wire [3:0]  mipi_cam_count,

`ifdef SIM
   //Simulation frame data from testbench
   input wire        sim_cam_hsync,
   input wire        sim_cam_vsync,
   input wire        sim_cam_valid,
   input wire [15:0] sim_cam_r_pix,
   input wire [15:0] sim_cam_g_pix,
   input wire [15:0] sim_cam_b_pix,
`endif
   
   //DMA Stream Channals 
   output  reg              stream_wr_en_ch0,
   output  reg   [48-1:0]   stream_wr_data_ch0,

   output  reg              stream_wr_en_ch1,
   output  reg   [48-1:0]   stream_wr_data_ch1,

   
   //DMA
   input  wire        cam_dma_wready,
   output wire        cam_dma_wvalid,
   output wire        cam_dma_wlast,
   output wire [63:0] cam_dma_wdata,
   

   //RISC-V slave control & Debug
   input  wire [15:0] rgb_control,
   input  wire        trigger_capture_frame,
   input  wire        continuous_capture_frame,
   input  wire        rgb_gray,
   input  wire        cam_dma_init_done,
   
   output reg  [31:0] frames_per_second,
   output reg         debug_cam_pixel_remap_fifo_overflow,
   output reg         debug_cam_pixel_remap_fifo_underflow,
   output reg         debug_cam_dma_fifo_overflow,
   output reg         debug_cam_dma_fifo_underflow,
   output reg         debug_cam_scaler_fifo_overflow,
   output reg         debug_cam_scaler_fifo_underflow,
   output reg  [31:0] debug_cam_dma_fifo_rcount,
   output reg  [31:0] debug_cam_dma_fifo_wcount,
   output wire [31:0] debug_cam_dma_status
);

localparam CAM_DMA_COUNT_BIT = $clog2(DMA_TRANSFER_LENGTH);
localparam CAM_X_COUNT_BIT   = $clog2(MIPI_FRAME_WIDTH/4); //4PPC
localparam CAM_Y_COUNT_BIT   = $clog2(MIPI_FRAME_HEIGHT);

reg  [39:0]                 cam_data;
reg                         cam_valid;
reg                         cam_vs;
reg                         cam_vs_r;
wire                        cam_vs_fall_edge;
reg                         cam_hs;
reg                         cam_hs_r;
wire                        cam_hs_fall_edge;
wire [31:0]                 cam_data8;
reg  [CAM_X_COUNT_BIT-1:0]  cam_x_count;
reg  [CAM_Y_COUNT_BIT-1:0]  cam_y_count;

reg                         gain_trigger;
reg  [2:0]                  red_gain;
reg  [2:0]                  green_gain;
reg  [2:0]                  blue_gain;
reg                         gain_trigger_synced;
reg  [2:0]                  red_gain_synced;
reg  [2:0]                  green_gain_synced;
reg  [2:0]                  blue_gain_synced;
reg  [2:0]                  red_gain_r;
reg  [2:0]                  green_gain_r;
reg  [2:0]                  blue_gain_r;
wire [31:0]                 rgb_gain_data;
wire                        rgb_gain_data_valid;

reg                         cam_alternate_clock; 
wire                        cam_pixel_remap_fifo_wvalid;
wire [31:0]                 cam_pixel_remap_fifo_wdata;
wire                        cam_pixel_remap_fifo_re;
wire                        cam_pixel_remap_fifo_rvalid;
wire [31:0]                 cam_pixel_remap_fifo_rdata;
wire                        cam_pixel_remap_fifo_empty;
wire                        cam_pixel_remap_fifo_overflow;
wire                        cam_pixel_remap_fifo_underflow;
reg                         cam_pixel_remap_fifo_rvalid_r;
reg  [15:0]                 cam_pixel_remap_fifo_rdata_r;
wire                        cam_pixel_remap_2ppc_valid;
wire [15:0]                 cam_pixel_remap_2ppc_data;

wire                        line_buffer_rstn;
wire [15:0]                 line_buffer_pixel_out_11;
wire [15:0]                 line_buffer_pixel_out_00;
wire [15:0]                 line_buffer_pixel_out_01;
wire                        line_buffer_pixel_out_valid;
wire [15:0]                 rgb_pixel_r_out;
wire [15:0]                 rgb_pixel_g_out;
wire [15:0]                 rgb_pixel_b_out;
wire [15:0]                 rgb_pixel_r_out_m;
wire [15:0]                 rgb_pixel_g_out_m;
wire [15:0]                 rgb_pixel_b_out_m;
wire                        rgb_pixel_out_valid;
wire [15:0]                 gray_pixel_out;

reg                         trigger_capture_frame_r1;
reg                         trigger_capture_frame_r2;
reg                         trigger_capture_frame_r3;
reg                         trigger_capture_frame_hold;
reg                         continuous_capture_frame_r1;
reg                         continuous_capture_frame_r2;
reg                         continuous_capture_frame_hold;
reg                         capture_frame;
reg                         rgb_gray_r;
reg                         rgb_gray_synced;
wire                        cam_dma_fifo_wvalid;
wire [47:0]                 cam_dma_fifo_wdata;
wire                        cam_dma_fifo_re;
wire                        cam_dma_fifo_rvalid;
wire [47:0]                 cam_dma_fifo_rdata;
wire                        cam_dma_fifo_empty;
wire                        cam_dma_fifo_overflow;
wire                        cam_dma_fifo_underflow;
wire                        cam_scaler_fifo_overflow;
wire                        cam_scaler_fifo_underflow;
reg [CAM_DMA_COUNT_BIT-1:0] cam_dma_count;
reg                         cam_dma_init_done_r1;
reg                         cam_dma_init_done_r2;
reg                         cam_dma_init_done_r3;
reg                         cam_dma_write;

`ifndef SIM

//Camera data sync to FPGA fabric mipi_pclk
always @(posedge mipi_pclk)
begin
   if (~rst_n) begin
      cam_data            <= 40'd0;
      cam_valid           <= 1'b0;
      cam_vs              <= 1'b0;
      cam_vs_r            <= 1'b0;
      gain_trigger        <= 1'b0;
      red_gain            <= 3'd0;
      green_gain          <= 3'd0;
      blue_gain           <= 3'd0;
      gain_trigger_synced <= 1'b0;
      red_gain_synced     <= 3'd0;
      green_gain_synced   <= 3'd0;
      blue_gain_synced    <= 3'd0;
      red_gain_r          <= 3'd6;
      green_gain_r        <= 3'd5;
      blue_gain_r         <= 3'd6;
   end else begin
      cam_data            <= mipi_cam_data[39:0];   //Keep valid least significant 4 x 10 bits data (RAW10, 4PPC)
      cam_valid           <= mipi_cam_valid  && (mipi_cam_type == 6'h2B);  //For RAW10 data type
      cam_vs              <= mipi_cam_vs;
      cam_vs_r            <= cam_vs;
      cam_hs              <= mipi_cam_hs;
      cam_hs_r            <= cam_hs;

      gain_trigger        <= rgb_control[0];
      red_gain            <= rgb_control[6:4];
      green_gain          <= rgb_control[10:8];
      blue_gain           <= rgb_control[14:12];
      gain_trigger_synced <= gain_trigger;
      red_gain_synced     <= red_gain;
      green_gain_synced   <= green_gain;
      blue_gain_synced    <= blue_gain;      
      
      if (gain_trigger_synced) begin
         red_gain_r   <= red_gain_synced;
         green_gain_r <= green_gain_synced;
         blue_gain_r  <= blue_gain_synced;
      end else begin
         red_gain_r   <= 3'd6;
         green_gain_r <= 3'd5;   //RAW of the camera has more green pixel
         blue_gain_r  <= 3'd6;
      end
   end
end

assign cam_hs_fall_edge = cam_hs_r && ~cam_hs;
assign cam_vs_fall_edge = cam_vs_r && ~cam_vs;
assign cam_data8        = {cam_data[39:32], cam_data[29:22], cam_data[19:12], cam_data[9:2]};  //Keep MSB 8-bit per pixel only

//RGB gain - No extra clock cycle latency
cam_rgb_gain #(
   .P_DEPTH     (8),   //4PPC
   .FRAME_WIDTH (MIPI_FRAME_WIDTH)
) u_rgb_gain (
   .i_arstn    (rst_n),
   .i_pclk     (mipi_pclk),
   .i_vs       (cam_vs),
   .i_valid    (cam_valid),
   .i_data     (cam_data8),
   .red_gain   (red_gain_r),
   .green_gain (green_gain_r),
   .blue_gain  (blue_gain_r),
   .o_vs       (),
   .o_valid    (rgb_gain_data_valid),
   .o_data     (rgb_gain_data)
);

//Map from 4PPC to 2PPC
always @(posedge mipi_pclk)
begin
   if (~rst_n)
   begin
      cam_alternate_clock           <= 1'b0;
      cam_pixel_remap_fifo_rvalid_r <= 1'b0;
      cam_pixel_remap_fifo_rdata_r  <= 16'd0;
   end else begin
      cam_alternate_clock           <= ~cam_alternate_clock;
      cam_pixel_remap_fifo_rvalid_r <= cam_pixel_remap_fifo_rvalid;
      cam_pixel_remap_fifo_rdata_r  <= cam_pixel_remap_fifo_rdata [31:16]; //Store most significant half word only
   end
end

assign cam_pixel_remap_fifo_wvalid = capture_frame && rgb_gain_data_valid;
assign cam_pixel_remap_fifo_wdata  = rgb_gain_data;
assign cam_pixel_remap_fifo_re     = (~cam_pixel_remap_fifo_empty) && cam_alternate_clock;
assign cam_pixel_remap_2ppc_valid  = cam_pixel_remap_fifo_rvalid || cam_pixel_remap_fifo_rvalid_r;
assign cam_pixel_remap_2ppc_data   = (cam_pixel_remap_fifo_rvalid) ? cam_pixel_remap_fifo_rdata [15:0] : cam_pixel_remap_fifo_rdata_r;

cam_pixel_remap_fifo u_cam_pixel_remap_fifo (
   .almost_full_o  (),
   .full_o         (),
   .overflow_o     (cam_pixel_remap_fifo_overflow),
   .wr_ack_o       (),
   .empty_o        (cam_pixel_remap_fifo_empty),
   .almost_empty_o (),
   .underflow_o    (cam_pixel_remap_fifo_underflow),
   .rd_valid_o     (cam_pixel_remap_fifo_rvalid),
   .rdata          (cam_pixel_remap_fifo_rdata),
   .clk_i          (mipi_pclk),
   .wr_en_i        (cam_pixel_remap_fifo_wvalid),
   .rd_en_i        (cam_pixel_remap_fifo_re),
   .a_rst_i        (~rst_n),
   .wdata          (cam_pixel_remap_fifo_wdata),
   .datacount_o    ()
);

//Adjusted vsync signal for 2PPC outputs
localparam MIPI_FRAME_PIX_COUNT_2PPC    = MIPI_FRAME_HEIGHT*(MIPI_FRAME_WIDTH/2);
localparam DELAY_VSYNC_2PPC             = 20;
localparam PIX_COUNT_2PPC_BIT           = $clog2(MIPI_FRAME_PIX_COUNT_2PPC);
localparam VSYNC_2PPC_COUNT_BIT         = $clog2(DELAY_VSYNC_2PPC);

reg [PIX_COUNT_2PPC_BIT-1:0]   count_2PPC;
reg                            vsync_2PPC_pre;
reg                            delay_count_en;
reg [VSYNC_2PPC_COUNT_BIT-1:0] delay_count;
wire                           cam_vs_2PPC;

assign cam_vs_2PPC = delay_count_en && (delay_count==DELAY_VSYNC_2PPC-1);

always @(posedge mipi_pclk)
begin
   if (~rst_n)
   begin
      count_2PPC     <= {PIX_COUNT_2PPC_BIT{1'b0}};
      vsync_2PPC_pre <= 1'b0;
      delay_count_en <= 1'b0;
      delay_count    <= {VSYNC_2PPC_COUNT_BIT{1'b0}};
   end else begin
      count_2PPC     <= (cam_pixel_remap_2ppc_valid && (count_2PPC == MIPI_FRAME_PIX_COUNT_2PPC-1)) ? {PIX_COUNT_2PPC_BIT{1'b0}} :
                        (cam_pixel_remap_2ppc_valid) ? count_2PPC + 1'b1 : count_2PPC;
      vsync_2PPC_pre <= cam_pixel_remap_2ppc_valid && (count_2PPC == MIPI_FRAME_PIX_COUNT_2PPC-1);
      delay_count_en <= (cam_vs_2PPC) ? 1'b0                         : (vsync_2PPC_pre) ? 1'b1               : delay_count_en;
      delay_count    <= (cam_vs_2PPC) ? {VSYNC_2PPC_COUNT_BIT{1'b0}} : (delay_count_en) ? delay_count + 1'b1 : delay_count;
   end
end

cam_line_buffer #(
   .P_DEPTH     (8),
   .FRAME_WIDTH (MIPI_FRAME_WIDTH)
) u_raw_to_rgb_line_buffer (
   .i_arstn (rst_n),
   .i_pclk  (mipi_pclk),   
   .i_vsync (cam_vs_2PPC),
   .i_valid (cam_pixel_remap_2ppc_valid),
   .i_p     (cam_pixel_remap_2ppc_data),
   .o_vsync (),
   .o_valid (line_buffer_pixel_out_valid),
   .o_p_11  (line_buffer_pixel_out_11),
   .o_p_00  (line_buffer_pixel_out_00),
   .o_p_01  (line_buffer_pixel_out_01)
);

cam_raw_to_rgb #(
   .P_DEPTH      (8),
   .FRAME_WIDTH  (MIPI_FRAME_WIDTH),
   .FRAME_HEIGHT (MIPI_FRAME_HEIGHT)
) u_raw_to_rgb (
   .i_arstn (rst_n),
   .i_pclk  (mipi_pclk),
   .i_vsync (cam_vs_2PPC),
   .i_valid (line_buffer_pixel_out_valid),
   .i_p_11  (line_buffer_pixel_out_11),
   .i_p_00  (line_buffer_pixel_out_00),
   .i_p_01  (line_buffer_pixel_out_01),
   .o_vsync (),
   .o_valid (rgb_pixel_out_valid),
   .o_r     (rgb_pixel_r_out_m),
   .o_g     (rgb_pixel_g_out_m),
   .o_b     (rgb_pixel_b_out_m)
);

//Crop or Scale to output resolution
reg [10:0] mipi_x_count;
reg [10:0] mipi_y_count;

always @(posedge mipi_pclk)
begin
   if (~rst_n)
   begin
      mipi_x_count   <= 11'd0;
      mipi_y_count   <= 11'd0;
   end else begin
      //Incoming frame data 2PPC
      mipi_x_count   <= (rgb_pixel_out_valid && (mipi_x_count == MIPI_FRAME_WIDTH/2-1))                                          ? 11'd0                 :
                        (rgb_pixel_out_valid)                                                                                    ? mipi_x_count + 1'b1   : mipi_x_count;
      mipi_y_count   <= (rgb_pixel_out_valid && (mipi_y_count == MIPI_FRAME_HEIGHT-1) && (mipi_x_count == MIPI_FRAME_WIDTH/2-1)) ? 11'd0                 :
                        (rgb_pixel_out_valid && (mipi_x_count == MIPI_FRAME_WIDTH/2-1))                                          ? mipi_y_count + 1'b1   : mipi_y_count;
   end
end

generate
   if (CROP_SCALE == 0) begin
      //Cropping - 2 pixels per clock
      cam_crop #(
         .P_DEPTH    (16),
         .X_START    (0),
         .Y_START    (0),
         .X_WIN      (FRAME_WIDTH/2),
         .Y_WIN      (FRAME_HEIGHT)
      ) u_cam_crop (
         .in_pclk       (mipi_pclk),
         .in_arstn      (rst_n),
         .in_x          (mipi_x_count),
         .in_y          (mipi_y_count),
         .in_valid      (rgb_pixel_out_valid),
         .in_data_00    (rgb_pixel_r_out_m[15:0]),
         .in_data_01    (rgb_pixel_g_out_m[15:0]),
         .in_data_10    (rgb_pixel_b_out_m[15:0]),
         .out_x         (),
         .out_y         (),
         .out_valid     (cam_dma_fifo_wvalid),
         .out_hs        (),
         .out_data_00   (rgb_pixel_r_out[15:0]),
         .out_data_01   (rgb_pixel_g_out[15:0]),
         .out_data_10   (rgb_pixel_b_out[15:0])
      );
      
      //Terminate non-related signals
      assign cam_scaler_fifo_overflow  = 1'b0;
      assign cam_scaler_fifo_underflow = 1'b0;
      
   end else begin
      //Scaler for MSB RED data
      scaling #(
         .P_DEPTH    (8),
         .X_TOTAL    (MIPI_FRAME_WIDTH/2),
         .Y_TOTAL    (MIPI_FRAME_HEIGHT),
         .X_SCALE    (FRAME_WIDTH/2),
         .Y_SCALE    (FRAME_HEIGHT)
      ) u_cam_scale_msb_red (
         .in_pclk       (mipi_pclk),
         .in_arstn      (rst_n),
         .in_x          (mipi_x_count),
         .in_y          (mipi_y_count),
         .in_valid      (rgb_pixel_out_valid),
         .in_data       (rgb_pixel_r_out_m[15:8]),
         .out_x         (),
         .out_y         (),
         .out_valid     (cam_dma_fifo_wvalid),
         .out_data      (rgb_pixel_r_out[15:8]),
         .overflow_o    (cam_scaler_fifo_overflow),
         .underflow_o   (cam_scaler_fifo_underflow)
      );
      
      //Scaler for LSB RED data
      scaling #(
         .P_DEPTH    (8),
         .X_TOTAL    (MIPI_FRAME_WIDTH/2),
         .Y_TOTAL    (MIPI_FRAME_HEIGHT),
         .X_SCALE    (FRAME_WIDTH/2),
         .Y_SCALE    (FRAME_HEIGHT)
      ) u_cam_scale_lsb_red (
         .in_pclk       (mipi_pclk),
         .in_arstn      (rst_n),
         .in_x          (mipi_x_count),
         .in_y          (mipi_y_count),
         .in_valid      (rgb_pixel_out_valid),
         .in_data       (rgb_pixel_r_out_m[7:0]),
         .out_x         (),
         .out_y         (),
         .out_valid     (),
         .out_data      (rgb_pixel_r_out[7:0]),
         .overflow_o    (),
         .underflow_o   ()
      );
      
      //Scaler for MSB GREEN data
      scaling #(
         .P_DEPTH    (8),
         .X_TOTAL    (MIPI_FRAME_WIDTH/2),
         .Y_TOTAL    (MIPI_FRAME_HEIGHT),
         .X_SCALE    (FRAME_WIDTH/2),
         .Y_SCALE    (FRAME_HEIGHT)
      ) u_cam_scale_msb_green (
         .in_pclk       (mipi_pclk),
         .in_arstn      (rst_n),
         .in_x          (mipi_x_count),
         .in_y          (mipi_y_count),
         .in_valid      (rgb_pixel_out_valid),
         .in_data       (rgb_pixel_g_out_m[15:8]),
         .out_x         (),
         .out_y         (),
         .out_valid     (),
         .out_data      (rgb_pixel_g_out[15:8]),
         .overflow_o    (),
         .underflow_o   ()
      );
      
      //Scaler for LSB GREEN data
      scaling #(
         .P_DEPTH    (8),
         .X_TOTAL    (MIPI_FRAME_WIDTH/2),
         .Y_TOTAL    (MIPI_FRAME_HEIGHT),
         .X_SCALE    (FRAME_WIDTH/2),
         .Y_SCALE    (FRAME_HEIGHT)
      ) u_cam_scale_lsb_green (
         .in_pclk       (mipi_pclk),
         .in_arstn      (rst_n),
         .in_x          (mipi_x_count),
         .in_y          (mipi_y_count),
         .in_valid      (rgb_pixel_out_valid),
         .in_data       (rgb_pixel_g_out_m[7:0]),
         .out_x         (),
         .out_y         (),
         .out_valid     (),
         .out_data      (rgb_pixel_g_out[7:0]),
         .overflow_o    (),
         .underflow_o   ()
      );
      
      //Scaler for MSB BLUE data
      scaling #(
         .P_DEPTH    (8),
         .X_TOTAL    (MIPI_FRAME_WIDTH/2),
         .Y_TOTAL    (MIPI_FRAME_HEIGHT),
         .X_SCALE    (FRAME_WIDTH/2),
         .Y_SCALE    (FRAME_HEIGHT)
      ) u_cam_scale_msb_blue (
         .in_pclk       (mipi_pclk),
         .in_arstn      (rst_n),
         .in_x          (mipi_x_count),
         .in_y          (mipi_y_count),
         .in_valid      (rgb_pixel_out_valid),
         .in_data       (rgb_pixel_b_out_m[15:8]),
         .out_x         (),
         .out_y         (),
         .out_valid     (),
         .out_data      (rgb_pixel_b_out[15:8]),
         .overflow_o    (),
         .underflow_o   ()
      );
      
      //Scaler for LSB BLUE data
      scaling #(
         .P_DEPTH    (8),
         .X_TOTAL    (MIPI_FRAME_WIDTH/2),
         .Y_TOTAL    (MIPI_FRAME_HEIGHT),
         .X_SCALE    (FRAME_WIDTH/2),
         .Y_SCALE    (FRAME_HEIGHT)
      ) u_cam_scale_lsb_blue (
         .in_pclk       (mipi_pclk),
         .in_arstn      (rst_n),
         .in_x          (mipi_x_count),
         .in_y          (mipi_y_count),
         .in_valid      (rgb_pixel_out_valid),
         .in_data       (rgb_pixel_b_out_m[7:0]),
         .out_x         (),
         .out_y         (),
         .out_valid     (),
         .out_data      (rgb_pixel_b_out[7:0]),
         .overflow_o    (),
         .underflow_o   ()
      );
   end
endgenerate

cam_rgb2gray #(
   .DATA_WIDTH (8),
   .PPC        (2)
) u_rgb2gray (
   .in_red   (rgb_pixel_r_out),
   .in_green (rgb_pixel_g_out),
   .in_blue  (rgb_pixel_b_out),
   .out_gray (gray_pixel_out)
);

//Select RGB or grayscale output
assign cam_dma_fifo_wdata  = (rgb_gray_synced) ? {gray_pixel_out[15:8],  gray_pixel_out[15:8],  gray_pixel_out[15:8],  gray_pixel_out[7:0],  gray_pixel_out[7:0],  gray_pixel_out[7:0]} :
                                                 {rgb_pixel_b_out[15:8], rgb_pixel_g_out[15:8], rgb_pixel_r_out[15:8], rgb_pixel_b_out[7:0], rgb_pixel_g_out[7:0], rgb_pixel_r_out[7:0]};

`else

reg sim_cam_vsync_r;

always @(posedge mipi_pclk) begin
   sim_cam_vsync_r <= sim_cam_vsync;
end

rgb2gray #(
   .DATA_WIDTH (8),
   .PPC        (2)
) u_rgb2gray (
   .in_red   (sim_cam_r_pix),
   .in_green (sim_cam_g_pix),
   .in_blue  (sim_cam_b_pix),
   .out_gray (gray_pixel_out)
);

assign cam_vs_fall_edge    = sim_cam_vsync_r && ~sim_cam_vsync;
assign cam_dma_fifo_wvalid = capture_frame && sim_cam_valid;
//Select RGB or grayscale output
assign cam_dma_fifo_wdata  = (rgb_gray_synced) ? {gray_pixel_out[15:8], gray_pixel_out[15:8], gray_pixel_out[15:8], gray_pixel_out[7:0], gray_pixel_out[7:0], gray_pixel_out[7:0]} :
                                                 {sim_cam_b_pix[15:8] , sim_cam_g_pix[15:8],  sim_cam_r_pix[15:8],  sim_cam_b_pix[7:0],  sim_cam_g_pix[7:0],  sim_cam_r_pix[7:0]};

`endif

//Store frame to DDR through DMA
always @(posedge mipi_pclk)
begin
   if (~rst_n) 
   begin
      trigger_capture_frame_r1      <= 1'b0;
      trigger_capture_frame_r2      <= 1'b0;
      trigger_capture_frame_r3      <= 1'b0;
      trigger_capture_frame_hold    <= 1'b0;
      continuous_capture_frame_r1   <= 1'b0;
      continuous_capture_frame_r2   <= 1'b0;
      continuous_capture_frame_hold <= 1'b0;
      capture_frame                 <= 1'b0;
      rgb_gray_r                    <= 1'b0;
      rgb_gray_synced               <= 1'b0;
   end else begin
      trigger_capture_frame_r1      <= trigger_capture_frame;
      trigger_capture_frame_r2      <= trigger_capture_frame_r1;
      trigger_capture_frame_r3      <= trigger_capture_frame_r2;
      trigger_capture_frame_hold    <= (~trigger_capture_frame_r3 && trigger_capture_frame_r2) ? 1'b1 : (cam_dma_fifo_wvalid) ? 1'b0 : trigger_capture_frame_hold;
      continuous_capture_frame_r1   <= continuous_capture_frame;
      continuous_capture_frame_r2   <= continuous_capture_frame_r1;
      continuous_capture_frame_hold <= (continuous_capture_frame_r2) ? 1'b1 : continuous_capture_frame_hold;
      capture_frame                 <= ((trigger_capture_frame_hold | continuous_capture_frame_hold) & cam_vs_fall_edge) ? 1'b1 : 
                                       (capture_frame & cam_vs_fall_edge & (~continuous_capture_frame_hold))             ? 1'b0 : capture_frame;
      rgb_gray_r                    <= rgb_gray;
      rgb_gray_synced               <= rgb_gray_r;
   end
end

//IMPORTANT TO CHECK FIFO OVERFLOW FLAG
//Mode FWFT
//DATA_WIDTH = 48
//DEPTH - Might be further cut down
always @(posedge mipi_pclk or negedge rst_n)
begin
    if(!rst_n)
    begin
        stream_wr_en_ch0   <= 1'b0;
        stream_wr_data_ch0 <= {48{1'b0}};
        stream_wr_en_ch1   <= 1'b0;
        stream_wr_data_ch1 <= {48{1'b0}};
    end 
    else 
    begin
        stream_wr_en_ch0   <=cam_dma_fifo_wvalid;
        stream_wr_data_ch0 <= cam_dma_fifo_wdata;
        stream_wr_en_ch1   <= cam_dma_fifo_wvalid;
        stream_wr_data_ch1 <= cam_dma_fifo_wdata;
    
    end 

end 

  
cam_dma_fifo u_cam_dma_fifo (
   .almost_full_o  (),
   .full_o         (),
   .overflow_o     (cam_dma_fifo_overflow),
   .wr_ack_o       (),
   .empty_o        (cam_dma_fifo_empty),
   .almost_empty_o (),
   .underflow_o    (cam_dma_fifo_underflow),
   .rd_valid_o     (cam_dma_fifo_rvalid),
   .rdata          (cam_dma_fifo_rdata),
   .clk_i          (mipi_pclk),
   .wr_en_i        (cam_dma_fifo_wvalid),
   .rd_en_i        (cam_dma_fifo_re),
   .a_rst_i        (~rst_n),
   .wdata          (cam_dma_fifo_wdata),
   .datacount_o    ()
);

reg [31:0] timer_count;
reg [31:0] frame_count;

always@(posedge mipi_pclk)
begin
   if(~rst_n) begin
      cam_dma_count                        <= {CAM_DMA_COUNT_BIT{1'b0}};
      cam_dma_init_done_r1                 <= 1'b0;
      cam_dma_init_done_r2                 <= 1'b0;
      cam_dma_init_done_r3                 <= 1'b0;
      cam_dma_write                        <= 1'b0;
      debug_cam_pixel_remap_fifo_overflow  <= 1'b0;
      debug_cam_pixel_remap_fifo_underflow <= 1'b0;
      debug_cam_dma_fifo_overflow          <= 1'b0;
      debug_cam_dma_fifo_underflow         <= 1'b0;
      debug_cam_scaler_fifo_overflow       <= 1'b0;
      debug_cam_scaler_fifo_underflow      <= 1'b0;
      debug_cam_dma_fifo_rcount            <= 32'd0;
      debug_cam_dma_fifo_wcount            <= 32'd0;
      timer_count                          <= 32'd0;
      frame_count                          <= 32'd0;
      frames_per_second                    <= 32'd0;
   end else begin
      cam_dma_init_done_r1                 <= cam_dma_init_done;
      cam_dma_init_done_r2                 <= cam_dma_init_done_r1;
      cam_dma_init_done_r3                 <= cam_dma_init_done_r2;
      cam_dma_write                        <= (~cam_dma_init_done_r3 && cam_dma_init_done_r2)            ? 1'b1 :
                                              (cam_dma_wvalid && (cam_dma_count==DMA_TRANSFER_LENGTH-1)) ? 1'b0 : cam_dma_write;
      
      //To determine cam_dma_wlast
      cam_dma_count                        <= (cam_dma_wvalid && (cam_dma_count==DMA_TRANSFER_LENGTH-1)) ? {CAM_DMA_COUNT_BIT{1'b0}}                           :
                                              (cam_dma_wvalid)                                           ? cam_dma_count + {{CAM_DMA_COUNT_BIT-1{1'b0}}, 1'b1} : cam_dma_count;
      
      //Debug registers
      debug_cam_pixel_remap_fifo_overflow  <= (cam_pixel_remap_fifo_overflow)   ? 1'b1 : debug_cam_pixel_remap_fifo_overflow;
      debug_cam_pixel_remap_fifo_underflow <= (cam_pixel_remap_fifo_underflow)  ? 1'b1 : debug_cam_pixel_remap_fifo_underflow;
      debug_cam_dma_fifo_overflow          <= (cam_dma_fifo_overflow)           ? 1'b1 : debug_cam_dma_fifo_overflow;
      debug_cam_dma_fifo_underflow         <= (cam_dma_fifo_underflow)          ? 1'b1 : debug_cam_dma_fifo_underflow;
      debug_cam_scaler_fifo_overflow       <= (cam_scaler_fifo_overflow)        ? 1'b1 : debug_cam_scaler_fifo_overflow;
      debug_cam_scaler_fifo_underflow      <= (cam_scaler_fifo_underflow)       ? 1'b1 : debug_cam_scaler_fifo_underflow;
      debug_cam_dma_fifo_rcount            <= (cam_dma_wvalid)                  ? debug_cam_dma_fifo_rcount + 1'b1 : debug_cam_dma_fifo_rcount;
      debug_cam_dma_fifo_wcount            <= (cam_dma_fifo_wvalid)             ? debug_cam_dma_fifo_wcount + 1'b1 : debug_cam_dma_fifo_wcount;

      //Frame counter - Assume frame rate > 1 FPS
      timer_count                          <= (timer_count == MIPI_PCLK_CLK_RATE) ? 32'd0 : timer_count + 1'b1;
      frame_count                          <= (timer_count == MIPI_PCLK_CLK_RATE) ? 32'd0 : (cam_vs_fall_edge) ? frame_count + 1'b1 : frame_count;
      frames_per_second                    <= (timer_count == MIPI_PCLK_CLK_RATE) ? frame_count : frames_per_second;
   end
end

assign debug_cam_dma_status = {29'd0, cam_dma_fifo_empty, cam_dma_write, cam_dma_wready};

assign cam_dma_fifo_re = cam_dma_write && cam_dma_wready && ~cam_dma_fifo_empty;
assign cam_dma_wvalid  = cam_dma_fifo_rvalid && cam_dma_fifo_re;
assign cam_dma_wdata   = {8'd0, cam_dma_fifo_rdata[47:24], 8'd0, cam_dma_fifo_rdata[23:0]};
assign cam_dma_wlast   = cam_dma_wvalid && (cam_dma_count==DMA_TRANSFER_LENGTH-1);

endmodule
