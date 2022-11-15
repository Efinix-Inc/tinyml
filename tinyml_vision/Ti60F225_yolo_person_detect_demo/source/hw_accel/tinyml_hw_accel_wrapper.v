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

module tinyml_hw_accel_wrapper
#(
   parameter AXI_ADDR_WIDTH         = 32,
   parameter DATA_WIDTH             = 32,  //For DMA and AXI
   parameter FRAME_WIDTH            = 640,
   parameter FRAME_HEIGHT           = 480,
   parameter DMA_TRANSFER_LENGTH    = 1920
) (
   input  wire                      clk,
   input  wire                      rst,
//   input  wire                      axi_slave_clk,
//   input  wire                      axi_slave_rst,
   
   //AXI-related signals
//   input  wire                      axi_slave_we,
//   input  wire [AXI_ADDR_WIDTH-1:0] axi_slave_waddr,
//   input  wire [DATA_WIDTH-1:0]     axi_slave_wdata,
//   input  wire                      axi_slave_re,
//   input  wire [AXI_ADDR_WIDTH-1:0] axi_slave_raddr,
//   output reg  [DATA_WIDTH-1:0]     axi_slave_rdata,
//   output reg                       axi_slave_rvalid,

   input  wire                      hw_accel_dma_init_done,
   
   //DMA-related signals
   output reg                       dma_rready,
   input  wire                      dma_rvalid,
   input  wire [(DATA_WIDTH/8)-1:0] dma_rkeep,
   input  wire [DATA_WIDTH-1:0]     dma_rdata,
   input  wire                      dma_wready,
   output wire                      dma_wvalid,
   output wire                      dma_wlast,
   output wire [DATA_WIDTH-1:0]     dma_wdata,
   
   // Debug Register
   output reg                       debug_dma_hw_accel_in_fifo_underflow,
   output reg                       debug_dma_hw_accel_in_fifo_overflow,
   output reg                       debug_dma_hw_accel_out_fifo_underflow,
   output reg                       debug_dma_hw_accel_out_fifo_overflow,
   
   output reg  [31:0]               debug_dma_hw_accel_in_fifo_wcount,
   output reg  [31:0]               debug_dma_hw_accel_out_fifo_rcount
);

   localparam DMA_WR_WORDS_COUNT_BIT = $clog2(DMA_TRANSFER_LENGTH);
   localparam INT_DATA_WIDTH         = 32;
   localparam SOBEL_THRESH           = 100;

   reg                               axi_slave_re_r;
   reg  [DMA_WR_WORDS_COUNT_BIT-1:0] dma_wr_words_count;
   reg                               rst_after_each_frame;
   reg                               dma_write;
   reg  [INT_DATA_WIDTH-1:0]         sobel_thresh_val;
   reg  [1:0]                        hw_accel_mode; //2'd0: Sobel only; 2'd1: Sobel+Dilation; Otherwise: Sobel+Erosion
   reg                               hw_accel_dma_init_done;
   reg                               hw_accel_dma_init_done_r1;
   reg                               hw_accel_dma_init_done_r2;
   reg                               hw_accel_dma_init_done_r3;
   reg  [INT_DATA_WIDTH-1:0]         sobel_thresh_val_r;
   reg  [INT_DATA_WIDTH-1:0]         sobel_thresh_val_synced;
   reg  [1:0]                        hw_accel_mode_r;
   reg  [1:0]                        hw_accel_mode_synced;
   
   wire                              axi_slave_re_pulse;
   wire                              dma_in_fifo_underflow;
   wire                              dma_in_fifo_overflow;
   wire                              dma_in_fifo_prog_full;
   wire                              dma_in_fifo_empty;
   reg                               dma_in_fifo_we;
   reg  [INT_DATA_WIDTH-1:0]         dma_in_fifo_wdata;
   wire                              dma_in_fifo_re;
   wire [INT_DATA_WIDTH-1:0]         dma_in_fifo_rdata;
   wire                              dma_in_fifo_rvalid;
   wire                              dma_out_fifo_underflow;
   wire                              dma_out_fifo_overflow;
   wire                              dma_out_fifo_prog_full;
   wire                              dma_out_fifo_empty;
   wire                              dma_out_fifo_we;
   wire [INT_DATA_WIDTH-1:0]         dma_out_fifo_wdata;
   wire                              dma_out_fifo_re;
   wire [INT_DATA_WIDTH-1:0]         dma_out_fifo_rdata;
   wire                              dma_out_fifo_rvalid;
   wire                              rst_hw_accel;
   wire [3:0]                        debug_hw_accel_fifo_status;
   
   //assign axi_slave_re_pulse         = ~axi_slave_re_r && axi_slave_re; //Detect rising edge. Observed input axi_slave_re might be asserted unexpectedly more than 1 clock cycle
   assign rst_hw_accel               = rst || rst_after_each_frame;     //Reset after every output frame.
//   assign debug_hw_accel_fifo_status = {debug_dma_hw_accel_in_fifo_underflow, debug_dma_hw_accel_in_fifo_overflow, debug_dma_hw_accel_out_fifo_underflow, debug_dma_hw_accel_out_fifo_overflow};
   
   //Debug registers
   always@(posedge clk or posedge rst) 
   begin
      if (rst) begin
         debug_dma_hw_accel_in_fifo_underflow  <= 1'b0;
         debug_dma_hw_accel_in_fifo_overflow   <= 1'b0;
         debug_dma_hw_accel_out_fifo_underflow <= 1'b0;
         debug_dma_hw_accel_out_fifo_overflow  <= 1'b0;
         debug_dma_hw_accel_in_fifo_wcount     <= 32'd0;
         debug_dma_hw_accel_out_fifo_rcount    <= 32'd0;
      end else begin
         debug_dma_hw_accel_in_fifo_underflow  <= (dma_in_fifo_underflow)  ? 1'b1 : debug_dma_hw_accel_in_fifo_underflow;
         debug_dma_hw_accel_in_fifo_overflow   <= (dma_in_fifo_overflow)   ? 1'b1 : debug_dma_hw_accel_in_fifo_overflow;
         debug_dma_hw_accel_out_fifo_underflow <= (dma_out_fifo_underflow) ? 1'b1 : debug_dma_hw_accel_out_fifo_underflow;
         debug_dma_hw_accel_out_fifo_overflow  <= (dma_out_fifo_overflow)  ? 1'b1 : debug_dma_hw_accel_out_fifo_overflow;
         debug_dma_hw_accel_in_fifo_wcount     <= (dma_in_fifo_we)         ? debug_dma_hw_accel_in_fifo_wcount  + 1'b1 : debug_dma_hw_accel_in_fifo_wcount;
         debug_dma_hw_accel_out_fifo_rcount    <= (dma_out_fifo_re)        ? debug_dma_hw_accel_out_fifo_rcount + 1'b1 : debug_dma_hw_accel_out_fifo_rcount;
      end
   end
   
   //AXI slave read/write from/to HW accelerator
   //always@(posedge axi_slave_clk or posedge axi_slave_rst) 
   //begin
   //   if (axi_slave_rst) begin
   //      axi_slave_re_r         <= 1'b0;
   //      axi_slave_rvalid       <= 1'b0;
   //      axi_slave_rdata        <= {DATA_WIDTH{1'b0}};
   //      sobel_thresh_val       <= SOBEL_THRESH;
   //      hw_accel_mode          <= 2'd0;
   //      hw_accel_dma_init_done <= 1'b0;
   //   end else begin
   //      //AXI slave
   //      axi_slave_re_r   <= axi_slave_re;
   //      axi_slave_rvalid <= axi_slave_re_pulse;   //Read data ready after 1 clock cycle latency
   //      //Default value
   //      axi_slave_rdata        <= {DATA_WIDTH{1'b0}};
   //      sobel_thresh_val       <= sobel_thresh_val;
   //      hw_accel_mode          <= hw_accel_mode;
   //      hw_accel_dma_init_done <= hw_accel_dma_init_done;
   //      
   //      //AXI write to HW accelerator
   //      if (axi_slave_we) begin
   //         case(axi_slave_waddr[5:2])
   //            4'd0 : sobel_thresh_val       <= axi_slave_wdata [INT_DATA_WIDTH-1:0];
   //            4'd1 : hw_accel_mode          <= axi_slave_wdata [1:0];
   //            4'd2 : hw_accel_dma_init_done <= axi_slave_wdata [0];
   //            default: 
   //            begin
   //               sobel_thresh_val       <= sobel_thresh_val;
   //               hw_accel_mode          <= hw_accel_mode;
   //               hw_accel_dma_init_done <= hw_accel_dma_init_done;
   //            end
   //         endcase
   //      end
   //      
   //      //AXI read from HW accelerator
   //      if (axi_slave_re_pulse) begin
   //         case(axi_slave_raddr[5:2])
   //            4'd3 : axi_slave_rdata <= 32'hABCD_1234; //To check if slave read works correctly
   //            4'd4 : axi_slave_rdata <= {28'd0, debug_hw_accel_fifo_status};
   //            4'd5 : axi_slave_rdata <= debug_dma_hw_accel_in_fifo_wcount;
   //            4'd6 : axi_slave_rdata <= debug_dma_hw_accel_out_fifo_rcount;
   //            default: axi_slave_rdata <= {DATA_WIDTH{1'b0}};
   //         endcase
   //      end
   //   end
   //end
   
   //DMA - Write to DDR & Control
   always@(posedge clk or posedge rst)
   begin
      if (rst) begin
         dma_wr_words_count        <= {DMA_WR_WORDS_COUNT_BIT{1'b0}};
         dma_write                 <= 1'b0;
         rst_after_each_frame      <= 1'b0;
         hw_accel_dma_init_done_r1 <= 1'b0;
         hw_accel_dma_init_done_r2 <= 1'b0;
         hw_accel_dma_init_done_r3 <= 1'b0;
         //sobel_thresh_val_r        <= {INT_DATA_WIDTH{1'b0}};
         //sobel_thresh_val_synced   <= {INT_DATA_WIDTH{1'b0}};
         //hw_accel_mode_r           <= 2'd0;
         //hw_accel_mode_synced      <= 2'd0;
         dma_rready                <= 1'b0;
         dma_in_fifo_we            <= 1'b0;
         dma_in_fifo_wdata         <= {INT_DATA_WIDTH{1'b0}};
      end else begin
         //DMA
         dma_wr_words_count        <= (dma_wvalid && (dma_wr_words_count==DMA_TRANSFER_LENGTH-1))                  ? {DMA_WR_WORDS_COUNT_BIT{1'b0}}                                :
                                      (dma_wvalid)                                                                 ? dma_wr_words_count + {{DMA_WR_WORDS_COUNT_BIT-1{1'b0}}, 1'b1} :
                                                                                                                     dma_wr_words_count;
         dma_write                 <= (~hw_accel_dma_init_done_r3 && hw_accel_dma_init_done_r2)   ? 1'b1 :
                                      (dma_wvalid && (dma_wr_words_count==DMA_TRANSFER_LENGTH-1)) ? 1'b0 : dma_write;
         rst_after_each_frame      <= dma_wlast && (dma_wr_words_count==(FRAME_HEIGHT*FRAME_WIDTH)-1);
         dma_rready                <= ~dma_in_fifo_prog_full && ~dma_out_fifo_prog_full;
         dma_in_fifo_we            <= dma_rvalid && (&dma_rkeep) && dma_rready; //Advanced DMA behavior
         dma_in_fifo_wdata         <= dma_rdata [INT_DATA_WIDTH-1:0];
         
         //Synchronizer
         hw_accel_dma_init_done_r1 <= hw_accel_dma_init_done;
         hw_accel_dma_init_done_r2 <= hw_accel_dma_init_done_r1;
         hw_accel_dma_init_done_r3 <= hw_accel_dma_init_done_r2;
         //sobel_thresh_val_r        <= sobel_thresh_val;
         //sobel_thresh_val_synced   <= sobel_thresh_val_r;
         //hw_accel_mode_r           <= hw_accel_mode;
         //hw_accel_mode_synced      <= hw_accel_mode_r;
      end
   end
   
   //DMA read/input fifo
   assign dma_in_fifo_re = ~dma_in_fifo_empty && ~dma_out_fifo_prog_full;

   hw_accel_dma_in_fifo u_dma_in_fifo (
      .almost_full_o  (),
      .prog_full_o    (dma_in_fifo_prog_full),
      .full_o         (),
      .overflow_o     (dma_in_fifo_overflow),
      .wr_ack_o       (),
      .empty_o        (dma_in_fifo_empty),
      .almost_empty_o (),
      .underflow_o    (dma_in_fifo_underflow),
      .rd_valid_o     (dma_in_fifo_rvalid),
      .rdata          (dma_in_fifo_rdata),
      .clk_i          (clk),
      .wr_en_i        (dma_in_fifo_we),
      .rd_en_i        (dma_in_fifo_re),
      .a_rst_i        (rst_hw_accel),
      .wdata          (dma_in_fifo_wdata),
      .datacount_o    ()
   );
   
   //DMA write/output fifo - FWFT mode
   //Threshold for dma_out_fifo_prog_full need to consider pipeline stages within HW accelerator, which might continue to flush out several data after input valid comes to a halt 
   assign dma_out_fifo_re = dma_write && dma_wready && ~dma_out_fifo_empty;   //Advanced DMA behavior 
   assign dma_wvalid      = dma_out_fifo_rvalid && dma_out_fifo_re;
   assign dma_wlast       = dma_wvalid && (dma_wr_words_count==DMA_TRANSFER_LENGTH-1);
   assign dma_wdata       = {{INT_DATA_WIDTH{1'b0}}, dma_out_fifo_rdata, dma_out_fifo_rdata, dma_out_fifo_rdata}; //Assume DATA_WIDTH = 4*INT_DATA_WIDTH
   
   hw_accel_dma_out_fifo u_dma_out_fifo (
      .almost_full_o  (),
      .prog_full_o    (dma_out_fifo_prog_full),
      .full_o         (),
      .overflow_o     (dma_out_fifo_overflow),
      .wr_ack_o       (),
      .empty_o        (dma_out_fifo_empty),
      .almost_empty_o (),
      .underflow_o    (dma_out_fifo_underflow),
      .rd_valid_o     (dma_out_fifo_rvalid),
      .rdata          (dma_out_fifo_rdata),
      .clk_i          (clk),
      .wr_en_i        (dma_out_fifo_we),
      .rd_en_i        (dma_out_fifo_re),
      .a_rst_i        (rst_hw_accel),
      .wdata          (dma_out_fifo_wdata),
      .datacount_o    ()
   );

   //Hardware accelerator
   tinyml_hw_accel
   # (
      .DATA_WIDTH    (INT_DATA_WIDTH),
      .FRAME_WIDTH   (FRAME_WIDTH),
      .FRAME_HEIGHT  (FRAME_HEIGHT)
   ) u_tinyml_hw_accel (
      .clk              (clk),
      .rst              (rst_hw_accel),
      .pixel_in         (dma_in_fifo_rdata),
      .pixel_in_valid   (dma_in_fifo_rvalid),
      .pixel_out        (dma_out_fifo_wdata),
      .pixel_out_valid  (dma_out_fifo_we)
   );

endmodule
