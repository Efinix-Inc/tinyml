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


module edge_vision_soc #(
   parameter RGB2GRAYSCALE          = "DISABLE",
   parameter OUT_FRAME_WIDTH        = 96,
   parameter OUT_FRAME_HEIGHT       = 96,
   //Input frame resolution from MIPI Rx.
   parameter MIPI_FRAME_WIDTH      = 1920,  
   parameter MIPI_FRAME_HEIGHT     = 1080,
   //Actual frame resolution used for subsequent processing (after cropping/scaling).
   parameter FRAME_WIDTH           = 540, //Multiple of 2 - To match with 2PPC pixel data.
   parameter FRAME_HEIGHT          = 540,  //Multiple of 2 - To preserve bayer format prior to raw2rgb conversion.
      parameter AXI_DATA_WIDTH  	      = 128, // AXI Width  connected to SOC, TinyML Accelerator, and DMA
   parameter MIPI_PCLK_CLK_RATE    = 100000000
)(
   input    wire           i_arstn,
   input    wire           i_fb_clk,
   input    wire           i_sysclk_div_2,
   input    wire           i_mipi_rx_pclk,
   input    wire           i_pll_locked,
   
   input    wire           i_mipi_clk,
   input    wire           i_mipi_txc_sclk,
   input    wire           i_mipi_txd_sclk,
   input    wire           i_mipi_tx_pclk,
   input    wire           i_mipi_tx_pll_locked,
   
   input    wire           i_hbramClk,
   input    wire           i_hbramClk_cal,
   input    wire           i_hbramClk90,
   input    wire           i_systemClk,
   input    wire           i_hbramClk_pll_locked,
   
   output   wire  [2:0]    o_hbc_cal_SHIFT,
   output   wire  [4:0]    o_hbc_cal_SHIFT_SEL,
   output   wire           o_hbc_cal_SHIFT_ENA,
   output   wire           o_hbramClk_pll_rstn,
   
   output   wire           o_lcd_rstn,
   output   wire           o_pll_rstn,
   output   wire           o_mipi_pll_rstn,
   
   //Camera configuration
   output  wire            mipi_i2c_0_io_sda_writeEnable,
   input   wire            mipi_i2c_0_io_sda_read,
   output  wire            mipi_i2c_0_io_scl_writeEnable,
   input   wire            mipi_i2c_0_io_scl_read,
   output  wire            o_cam_rstn,
   
   //MIPI RX - Camera
   input    wire           i_cam_ck_LP_P_IN,
   input    wire           i_cam_ck_LP_N_IN,
   output   wire           o_cam_ck_HS_TERM,
   output   wire           o_cam_ck_HS_ENA,
   input    wire           i_cam_ck_CLKOUT_0,
   
   input    wire  [7:0]    i_cam_d0_HS_IN_0,
   input    wire  [7:0]    i_cam_d0_HS_IN_1,
   input    wire  [7:0]    i_cam_d0_HS_IN_2,
   input    wire  [7:0]    i_cam_d0_HS_IN_3,
   input    wire           i_cam_d0_LP_P_IN,
   input    wire           i_cam_d0_LP_N_IN,
   output   wire           o_cam_d0_HS_TERM,
   output   wire           o_cam_d0_HS_ENA,
   output   wire           o_cam_d0_RST,
   output   wire           o_cam_d0_FIFO_RD,
   input    wire           i_cam_d0_FIFO_EMPTY,
   
   input    wire  [7:0]    i_cam_d1_HS_IN_0,
   input    wire  [7:0]    i_cam_d1_HS_IN_1,
   input    wire  [7:0]    i_cam_d1_HS_IN_2,
   input    wire  [7:0]    i_cam_d1_HS_IN_3,
   input    wire           i_cam_d1_LP_P_IN,
   input    wire           i_cam_d1_LP_N_IN,
   output   wire           o_cam_d1_HS_TERM,
   output   wire           o_cam_d1_HS_ENA,
   output   wire           o_cam_d1_RST,
   output   wire           o_cam_d1_FIFO_RD,
   input    wire           i_cam_d1_FIFO_EMPTY,

`ifdef SIM
   //Simulation frame data from testbench
   input    wire           sim_cam_hsync,
   input    wire           sim_cam_vsync,
   input    wire           sim_cam_valid,
   input    wire  [15:0]   sim_cam_r_pix,
   input    wire  [15:0]   sim_cam_g_pix,
   input    wire  [15:0]   sim_cam_b_pix,
`endif
   
   //MIPI TX - Display Panel
   output   wire           mipi_dp_clk_LP_P_OUT,
   output   wire           mipi_dp_clk_LP_N_OUT,
   output   wire  [7:0]    mipi_dp_clk_HS_OUT,
   output   wire           mipi_dp_clk_HS_OE,
   output   wire           mipi_dp_data3_LP_P_OUT,
   output   wire           mipi_dp_data2_LP_P_OUT,
   output   wire           mipi_dp_data1_LP_P_OUT,
   output   wire           mipi_dp_data0_LP_P_OUT,
   output   wire           mipi_dp_data3_LP_N_OUT,
   output   wire           mipi_dp_data2_LP_N_OUT,
   output   wire           mipi_dp_data1_LP_N_OUT,
   output   wire           mipi_dp_data0_LP_N_OUT,
   output   wire  [7:0]    mipi_dp_data0_HS_OUT,
   output   wire  [7:0]    mipi_dp_data1_HS_OUT,
   output   wire  [7:0]    mipi_dp_data2_HS_OUT,
   output   wire  [7:0]    mipi_dp_data3_HS_OUT,
   output   wire           mipi_dp_data3_HS_OE,
   output   wire           mipi_dp_data2_HS_OE,
   output   wire           mipi_dp_data1_HS_OE,
   output   wire           mipi_dp_data0_HS_OE,
   
   output   wire           mipi_dp_clk_RST,
   output   wire           mipi_dp_data0_RST,
   output   wire           mipi_dp_data1_RST,
   output   wire           mipi_dp_data2_RST,
   output   wire           mipi_dp_data3_RST,
   output   wire           mipi_dp_clk_LP_P_OE,
   output   wire           mipi_dp_clk_LP_N_OE,
   output   wire           mipi_dp_data3_LP_P_OE,
   output   wire           mipi_dp_data3_LP_N_OE,
   output   wire           mipi_dp_data2_LP_P_OE,
   output   wire           mipi_dp_data2_LP_N_OE,
   output   wire           mipi_dp_data1_LP_P_OE,
   output   wire           mipi_dp_data1_LP_N_OE,
   output   wire           mipi_dp_data0_LP_P_OE,
   output   wire           mipi_dp_data0_LP_N_OE,
   
   input    wire           mipi_dp_data0_LP_P_IN,
   input    wire           mipi_dp_data0_LP_N_IN,
   
   output   wire           hbc_rst_n,
   output   wire           hbc_cs_n,
   output   wire           hbc_ck_p_HI,
   output   wire           hbc_ck_p_LO,
   output   wire           hbc_ck_n_HI,
   output   wire           hbc_ck_n_LO,
   output   wire  [1:0]    hbc_rwds_OUT_HI,
   output   wire  [1:0]    hbc_rwds_OUT_LO,
   input    wire  [1:0]    hbc_rwds_IN_HI,
   input    wire  [1:0]    hbc_rwds_IN_LO,
   output   wire  [1:0]    hbc_rwds_OE,
   output   wire  [15:0]   hbc_dq_OUT_HI,
   output   wire  [15:0]   hbc_dq_OUT_LO,
   input    wire  [15:0]   hbc_dq_IN_HI,
   input    wire  [15:0]   hbc_dq_IN_LO,
   output   wire  [15:0]   hbc_dq_OE,
   
   input    wire           sw1,
   input    wire           sw6,
   input    wire           sw7,
   
   output   wire           o_led,
   output   wire           hbc_cal_pass,
   
   output   wire           system_uart_0_io_txd,
   input    wire           system_uart_0_io_rxd,
   output   wire           system_spi_0_io_sclk_write,
   output   wire           system_spi_0_io_data_0_writeEnable,
   input    wire           system_spi_0_io_data_0_read,
   output   wire           system_spi_0_io_data_0_write,
   output   wire           system_spi_0_io_data_1_writeEnable,
   input    wire           system_spi_0_io_data_1_read,
   output   wire           system_spi_0_io_data_1_write,
   output   wire           system_spi_0_io_ss,
   
`ifndef SOFT_TAP
   input    wire           jtag_inst1_TCK,
   input    wire           jtag_inst1_TDI,
   output   wire           jtag_inst1_TDO,
   input    wire           jtag_inst1_SEL,
   input    wire           jtag_inst1_CAPTURE,
   input    wire           jtag_inst1_SHIFT,
   input    wire           jtag_inst1_UPDATE,
   input    wire           jtag_inst1_RESET
`else
   input    wire           io_jtag_tms,
   input    wire           io_jtag_tdi,
   output   wire           io_jtag_tdo,
   input    wire           io_jtag_tck
`endif
);


////////////////////////////////////////////////////////////////
// System & Debugger
wire                    w_sysclk_arstn;
wire                    w_sysclk_arst;
wire                    w_fb_clk_arstn;
wire                    w_fb_clk_arst;
wire                    w_fb_dp_arstn;
wire                    w_fb_dp_arst;
wire                    w_sys_dp_arstn;
wire                    w_sys_dp_arst;
wire                    w_mipi_rx_pclk_arstn;
wire                    w_mipi_rx_pclk_arst;

////////////////////////////////////////////////////////////////
// MIPI RX - Camera
wire  [7:0]             w_cam_d0_HS_IN;
wire  [7:0]             w_cam_d1_HS_IN;
reg                     w_cam_confdone;
wire                    w_cam_ck_HS_ENA_0;
wire                    w_cam_ck_HS_TERM_0;
wire  [1:0]             w_cam_d_HS_ENA_0;

wire  [5:0]             w_mipi_rx_dt;
wire                    w_mipi_rx_vs;
wire                    w_mipi_rx_hs;
wire                    w_mipi_rx_de;
wire  [63:0]            w_mipi_rx_data;

reg   [10:0]            r_rx_x_mipi;
reg   [10:0]            r_rx_y_mipi;
reg                     r_rx_hs;
reg                     r_rx_vs;  

(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_P_IN_0_1P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_N_IN_0_1P;
(* async_reg = "true" *)reg   [15:0]   r_mipi_rx_data_HS_IN_0_1P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_P_IN_0_2P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_N_IN_0_2P;
(* async_reg = "true" *)reg   [15:0]   r_mipi_rx_data_HS_IN_0_2P;

wire  [31:0]            debug_cam_display_fifo_status;
wire  [15:0]            rgb_control;
wire                    trigger_capture_frame;
wire                    continuous_capture_frame;
wire                    rgb_gray;
wire                    cam_dma_init_done;
wire  [31:0]            frames_per_second;
wire                    cam_confdone;
wire                    enable_cam;



wire                    mipi_i2c_0_io_sda_write;
wire                    mipi_i2c_0_io_scl_write;

////////////////////////////////////////////////////////////////
// DSI Tx - Display Panel
wire  [7:0]             w_aid;
wire  [31:0]            w_aaddr;
wire  [7:0]             w_alen;
wire  [2:0]             w_asize;
wire  [1:0]             w_aburst;
wire  [1:0]             w_alock;
wire                    w_avalid;
wire                    w_aready;
wire                    w_atype;

wire  [7:0]             w_wid;
wire  [AXI_DATA_WIDTH-1:0]     w_wdata;
wire  [AXI_DATA_WIDTH/8-1:0]   w_wstrb;
wire                    w_wlast;
wire                    w_wvalid;
wire                    w_wready;

wire  [7:0]             w_rid;
wire  [AXI_DATA_WIDTH-1:0]     w_rdata;
wire                    w_rlast;
wire                    w_rvalid;
wire                    w_rready;
wire  [1:0]             w_rresp;

wire  [7:0]             w_bid;
wire                    w_bvalid;
wire                    w_bready;

wire  [31:0]            w_axi_rdata;
wire                    w_axi_awready;
wire                    w_axi_wready;
wire                    w_axi_arready;
wire                    w_axi_rvalid;
wire                    w_axi_bvalid;
wire  [6:0]             w_axi_awaddr;
wire                    w_axi_awvalid;
wire  [31:0]            w_axi_wdata;
wire                    w_axi_wvalid;
wire                    w_axi_bready;
wire  [6:0]             w_axi_araddr;
wire                    w_axi_arvalid;
wire                    w_axi_rready;

wire                    w_confdone;
reg   [19:0]            r_rst_cnt;
reg                     r_lcd_rstn;
wire                    r_rstn_video;

wire                    dp_vs;
wire                    dp_hs;
wire                    dp_data_valid;
wire  [15:0]            dp_r_data;
wire  [15:0]            dp_g_data;
wire  [15:0]            dp_b_data;
wire  [8:0]             dp_frame_cnt;

////////////////////////////////////////////////////////////////
// RISC-V SoC
wire                    mcuReset;
wire                    io_memoryClk;
wire                    io_systemReset;
wire                    io_arw_valid;
wire                    io_arw_ready;
wire    [31:0]          io_arw_payload_addr;
wire    [7:0]           io_arw_payload_id;
wire    [7:0]           io_arw_payload_len;
wire    [2:0]           io_arw_payload_size;
wire    [1:0]           io_arw_payload_burst;
wire    [1:0]           io_arw_payload_lock;
wire                    io_arw_payload_write;
wire    [7:0]           io_w_payload_id;
wire                    io_w_valid;
wire                    io_w_ready;
wire    [AXI_DATA_WIDTH-1:0]   io_w_payload_data;
wire    [AXI_DATA_WIDTH/8-1:0] io_w_payload_strb;
wire                    io_w_payload_last;
wire                    io_b_valid;
wire                    io_b_ready;
wire    [7:0]           io_b_payload_id;
wire                    io_r_valid;
wire                    io_r_ready;
wire    [AXI_DATA_WIDTH-1:0]   io_r_payload_data;
wire    [7:0]           io_r_payload_id;
wire    [1:0]           io_r_payload_resp;
wire                    io_r_payload_last;
wire    [1:0]           io_b_payload_resp;

wire                    userInterruptA;
wire                    userInterruptB;
wire                    axi4Interrupt;

wire  [15:0]            io_apbSlave_0_PADDR;
wire                    io_apbSlave_0_PSEL;
wire                    io_apbSlave_0_PENABLE;
wire                    io_apbSlave_0_PREADY;
wire                    io_apbSlave_0_PWRITE;
wire  [31:0]            io_apbSlave_0_PWDATA;
wire  [31:0]            io_apbSlave_0_PRDATA;
wire                    io_apbSlave_0_PSLVERROR;
wire  [15:0]            io_apbSlave_1_PADDR;
wire                    io_apbSlave_1_PSEL;
wire                    io_apbSlave_1_PENABLE;
wire                    io_apbSlave_1_PREADY;
wire                    io_apbSlave_1_PWRITE;
wire  [31:0]            io_apbSlave_1_PWDATA;
wire  [31:0]            io_apbSlave_1_PRDATA;
wire                    io_apbSlave_1_PSLVERROR;

wire                    peripheralClk;
wire                    peripheralReset; 

(* keep , syn_keep *) wire       io_memoryReset /* synthesis syn_keep = 1 */;          
(* keep , syn_keep *) wire [3:0] io_arw_payload_qos /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [2:0] io_arw_payload_prot /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] io_arw_payload_cache /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] io_arw_payload_region /* synthesis syn_keep = 1 */;

////////////////////////////////////////////////////////////////
//Custom instruction
wire                    cpu_customInstruction_cmd_valid;
wire                    cpu_customInstruction_cmd_ready;
wire  [9:0]             cpu_customInstruction_function_id;
wire  [31:0]            cpu_customInstruction_inputs_0;
wire  [31:0]            cpu_customInstruction_inputs_1;
wire                    cpu_customInstruction_rsp_valid;
wire                    cpu_customInstruction_rsp_ready;
wire  [31:0]            cpu_customInstruction_outputs_0;
wire                    cpu_customInstruction_cmd_int;

////////////////////////////////////////////////////////////////
// AXI interconnect

localparam AXI_TINYML_DATA_WIDTH = 128;

wire                    soc_io_arw_valid;
wire                    soc_io_arw_ready;
wire  [31:0]            soc_io_arw_payload_addr;
wire  [7:0]             soc_io_arw_payload_id;
wire  [7:0]             soc_io_arw_payload_len;
wire  [2:0]             soc_io_arw_payload_size;
wire  [1:0]             soc_io_arw_payload_burst;
wire                    soc_io_arw_payload_lock;
wire                    soc_io_arw_payload_write;
wire  [3:0]             soc_io_arw_payload_cache;
wire  [3:0]             soc_io_arw_payload_qos;
wire  [2:0]             soc_io_arw_payload_prot;
wire                    soc_io_w_valid;
wire                    soc_io_w_ready;
wire  [127:0]           soc_io_w_payload_data;
wire  [15:0]            soc_io_w_payload_strb;
wire                    soc_io_w_payload_last;
wire                    soc_io_b_valid;
wire                    soc_io_b_ready;
wire  [7:0]             soc_io_b_payload_id;
wire                    soc_io_r_valid;
wire                    soc_io_r_ready;
wire  [127:0]           soc_io_r_payload_data;
wire  [7:0]             soc_io_r_payload_id;
wire  [1:0]             soc_io_r_payload_resp;
wire                    soc_io_r_payload_last;
wire  [1:0]             soc_io_b_payload_resp;

wire [7:0]              axi_inter_s0_awid;
wire [31:0]             axi_inter_s0_awaddr;
wire [7:0]              axi_inter_s0_awlen;
wire [2:0]              axi_inter_s0_awsize;
wire [1:0]              axi_inter_s0_awburst;
wire                    axi_inter_s0_awlock;
wire [3:0]              axi_inter_s0_awcache;
wire [2:0]              axi_inter_s0_awprot;
wire [3:0]              axi_inter_s0_awqos;
wire                    axi_inter_s0_awvalid;
wire                    axi_inter_s0_awready;
wire [127:0]            axi_inter_s0_wdata;
wire [15:0]             axi_inter_s0_wstrb;
wire                    axi_inter_s0_wlast;
wire                    axi_inter_s0_wvalid;
wire                    axi_inter_s0_wready;
wire [7:0]              axi_inter_s0_bid;
wire [1:0]              axi_inter_s0_bresp;
wire                    axi_inter_s0_bvalid;
wire                    axi_inter_s0_bready;
wire [7:0]              axi_inter_s0_arid;
wire [31:0]             axi_inter_s0_araddr;
wire [7:0]              axi_inter_s0_arlen;
wire [2:0]              axi_inter_s0_arsize;
wire [1:0]              axi_inter_s0_arburst;
wire                    axi_inter_s0_arlock;
wire [3:0]              axi_inter_s0_arcache;
wire [2:0]              axi_inter_s0_arprot;
wire [3:0]              axi_inter_s0_arqos;
wire                    axi_inter_s0_arvalid;
wire                    axi_inter_s0_arready;
wire [7:0]              axi_inter_s0_rid;
wire [127:0]            axi_inter_s0_rdata;
wire [1:0]              axi_inter_s0_rresp;
wire                    axi_inter_s0_rlast;
wire                    axi_inter_s0_rvalid;
wire                    axi_inter_s0_rready;

wire [7:0]              axi_inter_s1_awid;
wire [31:0]             axi_inter_s1_awaddr;
wire [7:0]              axi_inter_s1_awlen;
wire [2:0]              axi_inter_s1_awsize;
wire [1:0]              axi_inter_s1_awburst;
wire                    axi_inter_s1_awlock;
wire [3:0]              axi_inter_s1_awcache;
wire [2:0]              axi_inter_s1_awprot;
wire [3:0]              axi_inter_s1_awqos;
wire                    axi_inter_s1_awvalid;
wire                    axi_inter_s1_awready;
wire [127:0]            axi_inter_s1_wdata;
wire [15:0]             axi_inter_s1_wstrb;
wire                    axi_inter_s1_wlast;
wire                    axi_inter_s1_wvalid;
wire                    axi_inter_s1_wready;
wire [7:0]              axi_inter_s1_bid;
wire [1:0]              axi_inter_s1_bresp;
wire                    axi_inter_s1_bvalid;
wire                    axi_inter_s1_bready;
wire [7:0]              axi_inter_s1_arid;
wire [31:0]             axi_inter_s1_araddr;
wire [7:0]              axi_inter_s1_arlen;
wire [2:0]              axi_inter_s1_arsize;
wire [1:0]              axi_inter_s1_arburst;
wire                    axi_inter_s1_arlock;
wire [3:0]              axi_inter_s1_arcache;
wire [2:0]              axi_inter_s1_arprot;
wire [3:0]              axi_inter_s1_arqos;
wire                    axi_inter_s1_arvalid;
wire                    axi_inter_s1_arready;
wire [7:0]              axi_inter_s1_rid;
wire [127:0]            axi_inter_s1_rdata;
wire [1:0]              axi_inter_s1_rresp;
wire                    axi_inter_s1_rlast;
wire                    axi_inter_s1_rvalid;
wire                    axi_inter_s1_rready;

wire [7:0]              axi_inter_s2_awid;
wire [31:0]             axi_inter_s2_awaddr;
wire [7:0]              axi_inter_s2_awlen;
wire [2:0]              axi_inter_s2_awsize;
wire [1:0]              axi_inter_s2_awburst;
wire                    axi_inter_s2_awlock;
wire [3:0]              axi_inter_s2_awcache;
wire [2:0]              axi_inter_s2_awprot;
wire [3:0]              axi_inter_s2_awqos;
wire                    axi_inter_s2_awvalid;
wire                    axi_inter_s2_awready;
wire [AXI_TINYML_DATA_WIDTH-1:0]            axi_inter_s2_wdata;
wire [AXI_TINYML_DATA_WIDTH/8-1:0]             axi_inter_s2_wstrb;
wire                    axi_inter_s2_wlast;
wire                    axi_inter_s2_wvalid;
wire                    axi_inter_s2_wready;
wire [7:0]              axi_inter_s2_bid;
wire [1:0]              axi_inter_s2_bresp;
wire                    axi_inter_s2_bvalid;
wire                    axi_inter_s2_bready;
wire [7:0]              axi_inter_s2_arid;
wire [31:0]             axi_inter_s2_araddr;
wire [7:0]              axi_inter_s2_arlen;
wire [2:0]              axi_inter_s2_arsize;
wire [1:0]              axi_inter_s2_arburst;
wire                    axi_inter_s2_arlock;
wire [3:0]              axi_inter_s2_arcache;
wire [2:0]              axi_inter_s2_arprot;
wire [3:0]              axi_inter_s2_arqos;
wire                    axi_inter_s2_arvalid;
wire                    axi_inter_s2_arready;
wire [7:0]              axi_inter_s2_rid;
wire [AXI_TINYML_DATA_WIDTH-1:0]            axi_inter_s2_rdata;
wire [1:0]              axi_inter_s2_rresp;
wire                    axi_inter_s2_rlast;
wire                    axi_inter_s2_rvalid;
wire                    axi_inter_s2_rready;

wire [7:0]              axi_inter_m_awid;
wire [31:0]             axi_inter_m_awaddr;
wire [7:0]              axi_inter_m_awlen;
wire [2:0]              axi_inter_m_awsize;
wire [1:0]              axi_inter_m_awburst;
wire                    axi_inter_m_awlock;
wire [3:0]              axi_inter_m_awcache;
wire [2:0]              axi_inter_m_awprot;
wire [3:0]              axi_inter_m_awqos;
wire [3:0]              axi_inter_m_awregion;
wire                    axi_inter_m_awvalid;
wire                    axi_inter_m_awready;
wire [127:0]            axi_inter_m_wdata;
wire [15:0]             axi_inter_m_wstrb;
wire                    axi_inter_m_wlast;
wire                    axi_inter_m_wvalid;
wire                    axi_inter_m_wready;
wire [7:0]              axi_inter_m_bid;
wire [1:0]              axi_inter_m_bresp;
wire                    axi_inter_m_bvalid;
wire                    axi_inter_m_bready;
wire [7:0]              axi_inter_m_arid;
wire [31:0]             axi_inter_m_araddr;
wire [7:0]              axi_inter_m_arlen;
wire [2:0]              axi_inter_m_arsize;
wire [1:0]              axi_inter_m_arburst;
wire                    axi_inter_m_arlock;
wire [3:0]              axi_inter_m_arcache;
wire [2:0]              axi_inter_m_arprot;
wire [3:0]              axi_inter_m_arqos;
wire [3:0]              axi_inter_m_arregion;
wire                    axi_inter_m_arvalid;
wire                    axi_inter_m_arready;
wire [7:0]              axi_inter_m_rid;
wire [127:0]            axi_inter_m_rdata;
wire [1:0]              axi_inter_m_rresp;
wire                    axi_inter_m_rlast;
wire                    axi_inter_m_rvalid;
wire                    axi_inter_m_rready;

(* keep , syn_keep *) wire [3:0] soc_io_arw_payload_region /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [7:0] soc_io_w_payload_id /* synthesis syn_keep = 1 */;

////////////////////////////////////////////////////////////////
// DMA controller
wire                    bbox_dma_tvalid;
wire                    bbox_dma_tready;
wire                    bbox_dma_tlast;
wire [63:0]             bbox_dma_tdata;

wire [63:0]             display_dma_rdata;
wire                    display_dma_rvalid;
//wire [7:0]              display_dma_rkeep;
wire                    display_dma_rready;
wire                    debug_display_dma_fifo_overflow;
wire                    debug_display_dma_fifo_underflow;
wire [31:0]             debug_display_dma_fifo_rcount;
wire [31:0]             debug_display_dma_fifo_wcount;
wire                    set_red_green;

wire                    cam_dma_wready;
wire                    cam_dma_wvalid;
wire                    cam_dma_wlast;
wire [63:0]             cam_dma_wdata;
wire                    debug_cam_dma_fifo_overflow;
wire                    debug_cam_dma_fifo_underflow;
wire [31:0]             debug_cam_dma_fifo_rcount;
wire [31:0]             debug_cam_dma_fifo_wcount;
wire [31:0]             debug_cam_dma_status;

wire                    hw_accel_dma_rready;
wire                    hw_accel_dma_rvalid;
wire  [3:0]             hw_accel_dma_rkeep;
wire  [31:0]            hw_accel_dma_rdata;
wire                    hw_accel_dma_wready;
wire                    hw_accel_dma_wvalid;
wire                    hw_accel_dma_wlast;
wire  [31:0]            hw_accel_dma_wdata;

wire                    debug_dma_hw_accel_in_fifo_underflow;
wire                    debug_dma_hw_accel_in_fifo_overflow;
wire                    debug_dma_hw_accel_out_fifo_underflow;
wire                    debug_dma_hw_accel_out_fifo_overflow;
wire  [31:0]            debug_dma_hw_accel_in_fifo_wcount;
wire  [31:0]            debug_dma_hw_accel_out_fifo_rcount;

wire  [3:0]             dma_interrupts;

(* keep , syn_keep *) wire [3:0] dma_awregion /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] dma_arregion /* synthesis syn_keep = 1 */;

////////////////////////////////////////////////////////////////
// Reset related

`ifndef SIM
   common_reset_ctrl #(
      .NUM_RST          (8),
      .CYCLE            (1),
      .IN_RST_ACTIVE    (8'b000000),
      .OUT_RST_ACTIVE   (8'b101010)
   ) common_reset_ctrl (
      .i_arst ({{2{w_cam_confdone}}, {2{i_pll_locked}}, {4{r_rst_cnt[19]}}}),
      .i_clk  ({{2{i_mipi_rx_pclk}}, {2{i_fb_clk}}, {2{i_fb_clk}}, {2{i_sysclk_div_2}}}),
      .o_srst ({  w_mipi_rx_pclk_arst, w_mipi_rx_pclk_arstn,
                  w_fb_clk_arst,       w_fb_clk_arstn,
                  w_fb_dp_arst,        w_fb_dp_arstn,
                  w_sys_dp_arst,       w_sys_dp_arstn})
   );
`else
   assign w_mipi_rx_pclk_arst    = ~i_arstn;
   assign w_mipi_rx_pclk_arstn   = i_arstn;
   assign w_fb_clk_arst          = ~i_arstn;
   assign w_fb_clk_arstn         = i_arstn;
   assign w_fb_dp_arst           = ~i_arstn;
   assign w_fb_dp_arstn          = i_arstn;
   assign w_sys_dp_arst          = ~i_arstn;
   assign w_sys_dp_arstn         = i_arstn;
`endif

assign   mipi_dp_clk_RST      = ~i_arstn;
assign   mipi_dp_data0_RST    = ~i_arstn;
assign   mipi_dp_data1_RST    = ~i_arstn;
assign   mipi_dp_data2_RST    = ~i_arstn;
assign   mipi_dp_data3_RST    = ~i_arstn;

assign   o_hbramClk_pll_rstn  = i_arstn;
assign   o_lcd_rstn           = r_lcd_rstn;
assign   o_led                = dp_frame_cnt[4];
assign   o_pll_rstn           = i_arstn;
assign   o_mipi_pll_rstn      = i_arstn;
assign   o_cam_rstn           = i_arstn & enable_cam;


////////////////////////////////////////////////////////////////
// MIPI CSI RX Channel - Camera

always@(negedge i_arstn or posedge i_cam_ck_CLKOUT_0)
begin
   if (~i_arstn)
   begin
      r_mipi_rx_data_LP_P_IN_0_1P   <= 2'b0;
      r_mipi_rx_data_LP_N_IN_0_1P   <= 2'b0;
      r_mipi_rx_data_HS_IN_0_1P     <= {16{1'b0}};
      
      r_mipi_rx_data_LP_P_IN_0_2P   <= 2'b0;
      r_mipi_rx_data_LP_N_IN_0_2P   <= 2'b0;
      r_mipi_rx_data_HS_IN_0_2P     <= {16{1'b0}};
   end
   else
   begin
      r_mipi_rx_data_LP_P_IN_0_1P   <= {i_cam_d1_LP_P_IN, i_cam_d0_LP_P_IN}; 
      r_mipi_rx_data_LP_N_IN_0_1P   <= {i_cam_d1_LP_N_IN, i_cam_d0_LP_N_IN};
      r_mipi_rx_data_HS_IN_0_1P     <= {w_cam_d1_HS_IN[7:0], w_cam_d0_HS_IN[7:0]};
               
      r_mipi_rx_data_LP_P_IN_0_2P   <= r_mipi_rx_data_LP_P_IN_0_1P;
      r_mipi_rx_data_LP_N_IN_0_2P   <= r_mipi_rx_data_LP_N_IN_0_1P;
      r_mipi_rx_data_HS_IN_0_2P     <= r_mipi_rx_data_HS_IN_0_1P;
   end
end

assign   w_cam_d0_HS_IN    = {i_cam_d0_HS_IN_3, i_cam_d0_HS_IN_2, i_cam_d0_HS_IN_1, i_cam_d0_HS_IN_0};
assign   w_cam_d1_HS_IN    = {i_cam_d1_HS_IN_3, i_cam_d1_HS_IN_2, i_cam_d1_HS_IN_1, i_cam_d1_HS_IN_0};

assign   o_cam_ck_HS_TERM  = w_cam_ck_HS_ENA_0;
assign   o_cam_ck_HS_ENA   = w_cam_ck_HS_ENA_0;
assign   o_cam_d0_HS_TERM  = w_cam_d_HS_ENA_0[0];
assign   o_cam_d1_HS_TERM  = w_cam_d_HS_ENA_0[1];
assign   o_cam_d0_HS_ENA   = w_cam_d_HS_ENA_0[0];
assign   o_cam_d1_HS_ENA   = w_cam_d_HS_ENA_0[1];
assign   o_cam_d0_RST      = ~i_arstn;
assign   o_cam_d1_RST      = ~i_arstn;             

csi2_rx_cam #(
) u_csi2_rx_cam (
   .reset_n             (i_arstn),
   .clk                 (i_mipi_clk),
   .reset_byte_HS_n     (i_arstn),
   .clk_byte_HS         (i_cam_ck_CLKOUT_0),
   .reset_pixel_n       (w_mipi_rx_pclk_arstn),
   .clk_pixel           (i_mipi_rx_pclk),
   
   .Rx_LP_CLK_P         (i_cam_ck_LP_P_IN),
   .Rx_LP_CLK_N         (i_cam_ck_LP_N_IN),
   .Rx_HS_enable_C      (w_cam_ck_HS_ENA_0),
   .LVDS_termen_C       (w_cam_ck_HS_TERM_0),

   .Rx_LP_D_P           (r_mipi_rx_data_LP_P_IN_0_2P),
   .Rx_LP_D_N           (r_mipi_rx_data_LP_N_IN_0_2P),
   .Rx_HS_D_0           (r_mipi_rx_data_HS_IN_0_2P[7:0]),
   .Rx_HS_D_1           (r_mipi_rx_data_HS_IN_0_2P[15:8]),
   .Rx_HS_D_2           (),
   .Rx_HS_D_3           (),
   .Rx_HS_D_4           (),
   .Rx_HS_D_5           (),
   .Rx_HS_D_6           (),
   .Rx_HS_D_7           (),
   .Rx_HS_enable_D      (w_cam_d_HS_ENA_0),
   .LVDS_termen_D       (),
   .fifo_rd_enable      ({o_cam_d1_FIFO_RD,    o_cam_d0_FIFO_RD}),
   .fifo_rd_empty       ({i_cam_d1_FIFO_EMPTY, i_cam_d0_FIFO_EMPTY}),
   .DLY_enable_D        (),
   .DLY_inc_D           (),
   .u_dly_enable_D      (),
   .u_dly_inc_D         (),
   
   .axi_clk             (1'b0),
   .axi_reset_n         (1'b0),
   .axi_awaddr          (6'b0),
   .axi_awvalid         (1'b0),
   .axi_awready         (),
   .axi_wdata           (32'b0),
   .axi_wvalid          (1'b0),
   .axi_wready          (),
   
   .axi_bvalid          (),
   .axi_bready          (1'b0),
   .axi_araddr          (6'b0),
   .axi_arvalid         (1'b0),
   .axi_arready         (),
   .axi_rdata           (),
   .axi_rvalid          (),
   .axi_rready          (1'b0),
   
   .hsync_vc0           (w_mipi_rx_hs),
   .hsync_vc1           (),
   .hsync_vc2           (),
   .hsync_vc3           (),
   .hsync_vc4           (),
   .hsync_vc5           (),
   .hsync_vc6           (),
   .hsync_vc7           (),
   .hsync_vc8           (),
   .hsync_vc9           (),
   .hsync_vc10          (),
   .hsync_vc11          (),
   .hsync_vc12          (),
   .hsync_vc13          (),
   .hsync_vc14          (),
   .hsync_vc15          (),
   .vsync_vc0           (w_mipi_rx_vs),
   .vsync_vc1           (),
   .vsync_vc2           (),
   .vsync_vc3           (),
   .vsync_vc4           (),
   .vsync_vc5           (),
   .vsync_vc6           (),
   .vsync_vc7           (),
   .vsync_vc8           (),
   .vsync_vc9           (),
   .vsync_vc10          (),
   .vsync_vc11          (),
   .vsync_vc12          (),
   .vsync_vc13          (),
   .vsync_vc14          (),
   .vsync_vc15          (),
   .vc                  (),
   .vcx                 (),
   .word_count          (),
   .shortpkt_data_field (),
   .datatype            (w_mipi_rx_dt),
   .pixel_per_clk       (),
   .pixel_data          (w_mipi_rx_data),
   .pixel_data_valid    (w_mipi_rx_de),
   .irq                 ()
);

////////////////////////////////////////////////////////////////
// Camera
      
assign mipi_i2c_0_io_sda_writeEnable = !mipi_i2c_0_io_sda_write;
assign mipi_i2c_0_io_scl_writeEnable = !mipi_i2c_0_io_scl_write;

always@(posedge i_systemClk)
begin
   if (io_systemReset)
   begin
      w_cam_confdone <= 1'b0;
   end else begin
      w_cam_confdone <= (cam_confdone) ? 1'b1 : w_cam_confdone;
   end
end

cam_picam # (
   .MIPI_FRAME_WIDTH     (MIPI_FRAME_WIDTH),             //Input frame resolution from MIPI
   .MIPI_FRAME_HEIGHT    (MIPI_FRAME_HEIGHT),            //Input frame resolution from MIPI
   .FRAME_WIDTH          (FRAME_WIDTH),                  //Output frame resolution to external memory
   .FRAME_HEIGHT         (FRAME_HEIGHT),                 //Output frame resolution to external memory
   .DMA_TRANSFER_LENGTH  ((FRAME_WIDTH*FRAME_HEIGHT)/2), //2PPC
   .MIPI_PCLK_CLK_RATE   (32'd100_000_000)               // as mipi_pclk is 100MHz
) u_cam (
   .mipi_pclk                             (i_mipi_rx_pclk),
   .rst_n                                 (w_mipi_rx_pclk_arstn),
   .mipi_cam_data                         (w_mipi_rx_data),
   .mipi_cam_valid                        (w_mipi_rx_de),
   .mipi_cam_vs                           (w_mipi_rx_vs),
   .mipi_cam_hs                           (w_mipi_rx_hs),
   .mipi_cam_type                         (w_mipi_rx_dt),
`ifdef SIM
   //Simulation frame data from testbench
   .sim_cam_hsync                         (sim_cam_hsync),
   .sim_cam_vsync                         (sim_cam_vsync),
   .sim_cam_valid                         (sim_cam_valid),
   .sim_cam_r_pix                         (sim_cam_r_pix),
   .sim_cam_g_pix                         (sim_cam_g_pix),
   .sim_cam_b_pix                         (sim_cam_b_pix),
`endif
   .cam_dma_wready                        (cam_dma_wready),
   .cam_dma_wvalid                        (cam_dma_wvalid),
   .cam_dma_wlast                         (cam_dma_wlast),
   .cam_dma_wdata                         (cam_dma_wdata),
   .rgb_control                           (rgb_control),
   .trigger_capture_frame                 (trigger_capture_frame),
   .continuous_capture_frame              (continuous_capture_frame),
   .rgb_gray                              (rgb_gray),
   .cam_dma_init_done                     (cam_dma_init_done),
   .frames_per_second                     (frames_per_second),
   .debug_cam_pixel_remap_fifo_overflow   (debug_cam_pixel_remap_fifo_overflow),
   .debug_cam_pixel_remap_fifo_underflow  (debug_cam_pixel_remap_fifo_underflow),
   .debug_cam_dma_fifo_overflow           (debug_cam_dma_fifo_overflow),
   .debug_cam_dma_fifo_underflow          (debug_cam_dma_fifo_underflow),
   .debug_cam_dma_fifo_rcount             (debug_cam_dma_fifo_rcount),
   .debug_cam_dma_fifo_wcount             (debug_cam_dma_fifo_wcount),
   .debug_cam_dma_status                  (debug_cam_dma_status)
);

////////////////////////////////////////////////////////////////
// Display

// Reset
always@(negedge i_arstn or posedge i_fb_clk)
begin
   if (~i_arstn)
   begin
      r_rst_cnt   <= {20{1'b0}};
      r_lcd_rstn  <= 1'b0;
   end
   else
   begin    
      if (~r_rst_cnt[19])
      begin
         r_rst_cnt   <= r_rst_cnt + 1'b1;
         
         if (r_rst_cnt[18] && r_rst_cnt[17])
            r_lcd_rstn  <= 1'b0;
         else
            r_lcd_rstn  <= 1'b1;
      end
      else
         r_lcd_rstn  <= 1'b1;
   end
end

// Panel driver initialization
display_panel_config #(
   .INITIAL_CODE  ("source/display/dsi/display_dsi_panel_1080p_reg.mem"),
   .REG_DEPTH     (9'd15)
) u_panel_config (
   .i_axi_clk        (i_fb_clk),
   .i_restn          (w_fb_dp_arstn),
   
   .i_axi_awready    (w_axi_awready),
   .i_axi_wready     (w_axi_wready),
   .i_axi_bvalid     (w_axi_bvalid),
   .o_axi_awaddr     (w_axi_awaddr),
   .o_axi_awvalid    (w_axi_awvalid),
   .o_axi_wdata      (w_axi_wdata),
   .o_axi_wvalid     (w_axi_wvalid),
   .o_axi_bready     (w_axi_bready),
   
   .i_axi_arready    (w_axi_arready),
   .i_axi_rdata      (w_axi_rdata),
   .i_axi_rvalid     (w_axi_rvalid),
   .o_axi_araddr     (w_axi_araddr),
   .o_axi_arvalid    (w_axi_arvalid),
   .o_axi_rready     (w_axi_rready),
   
   .o_addr_cnt       (),
   .o_state          (),
   .o_confdone       (w_confdone),
   
   .i_dbg_we         (0),
   .i_dbg_din        (0),
   .i_dbg_addr       (0),
   .o_dbg_dout       (),
   .i_dbg_reconfig   (0)
);

display_annotator #(
   .FRAME_WIDTH  (FRAME_WIDTH),
   .FRAME_HEIGHT (FRAME_HEIGHT),
   .MAX_BBOX     (16)
) u_display_annotator (
   .clk        (i_sysclk_div_2),
   .rst        (~w_sys_dp_arstn),
   .in_valid   (bbox_dma_tvalid),
   .in_last    (bbox_dma_tlast),
   .in_data    (bbox_dma_tdata),
   .in_ready   (bbox_dma_tready),
   .out_valid  (display_dma_rvalid),
   .out_data   (display_dma_rdata),
   .out_ready  (display_dma_rready)
);

display_dsi #(
   .FRAME_WIDTH  (FRAME_WIDTH),
   .FRAME_HEIGHT (FRAME_HEIGHT)
) u_display (
   .clk                                   (i_sysclk_div_2),
   .rst_n                                 (w_sys_dp_arstn),
   .panel_confdone                        (w_confdone),
   .panel_on_off_sw                       (sw1),
   .rstn_video                            (r_rstn_video),
   .frame_cnt                             (dp_frame_cnt),
   .set_red_green                         (set_red_green),
   
   .display_dma_rdata                     (display_dma_rdata),
   .display_dma_rvalid                    (display_dma_rvalid),
   .display_dma_rkeep                     (8'hFF),
   .display_dma_rready                    (display_dma_rready),
   
   .debug_display_dma_fifo_overflow       (debug_display_dma_fifo_overflow),
   .debug_display_dma_fifo_underflow      (debug_display_dma_fifo_underflow),
   .debug_display_dma_fifo_rcount         (debug_display_dma_fifo_rcount),
   .debug_display_dma_fifo_wcount         (debug_display_dma_fifo_wcount),
   
   .o_hs                                  (dp_hs),
   .o_vs                                  (dp_vs),
   .o_valid                               (dp_data_valid),
   .o_r                                   (dp_r_data),
   .o_g                                   (dp_g_data),
   .o_b                                   (dp_b_data)
);

////////////////////////////////////////////////////////////////
// MIPI DSI TX Channel - Display panel
dsi_tx_display u_dsi_tx_display (
   .reset_n          (w_sys_dp_arstn),
   .clk              (i_mipi_clk),     //100
   .reset_byte_HS_n  (w_sys_dp_arstn),
   .clk_byte_HS      (i_mipi_tx_pclk), //1000/8=125
   .reset_pixel_n    (r_rstn_video),
   .clk_pixel        (i_sysclk_div_2), //1000/16=62.5
   // LVDS clock lane   
   .Tx_LP_CLK_P      (mipi_dp_clk_LP_P_OUT),
   .Tx_LP_CLK_P_OE   (mipi_dp_clk_LP_P_OE),
   .Tx_LP_CLK_N      (mipi_dp_clk_LP_N_OUT),
   .Tx_LP_CLK_N_OE   (mipi_dp_clk_LP_N_OE),
   .Tx_HS_C          (mipi_dp_clk_HS_OUT),
   .Tx_HS_enable_C   (mipi_dp_clk_HS_OE),
   
   // ----- DLane -----------
   // LVDS data lane
   .Tx_LP_D_P        ({mipi_dp_data3_LP_P_OUT, mipi_dp_data2_LP_P_OUT, mipi_dp_data1_LP_P_OUT, mipi_dp_data0_LP_P_OUT}),
   .Tx_LP_D_P_OE     ({mipi_dp_data3_LP_P_OE, mipi_dp_data2_LP_P_OE, mipi_dp_data1_LP_P_OE, mipi_dp_data0_LP_P_OE}),
   .Tx_LP_D_N        ({mipi_dp_data3_LP_N_OUT, mipi_dp_data2_LP_N_OUT, mipi_dp_data1_LP_N_OUT, mipi_dp_data0_LP_N_OUT}),
   .Tx_LP_D_N_OE     ({mipi_dp_data3_LP_N_OE, mipi_dp_data2_LP_N_OE, mipi_dp_data1_LP_N_OE, mipi_dp_data0_LP_N_OE}),
   .Tx_HS_D_0        (mipi_dp_data0_HS_OUT),
   .Tx_HS_D_1        (mipi_dp_data1_HS_OUT),
   .Tx_HS_D_2        (mipi_dp_data2_HS_OUT),
   .Tx_HS_D_3        (mipi_dp_data3_HS_OUT),
   //.Tx_HS_D_4        (),
   //.Tx_HS_D_5        (),
   //.Tx_HS_D_6        (),
   //.Tx_HS_D_7        (),
   // control signal to LVDS IO
   .Tx_HS_enable_D   ({mipi_dp_data3_HS_OE, mipi_dp_data2_HS_OE, mipi_dp_data1_HS_OE, mipi_dp_data0_HS_OE}),
   .Rx_LP_D_P        (mipi_dp_data0_LP_P_IN),
   .Rx_LP_D_N        (mipi_dp_data0_LP_N_IN),
   
   //AXI4-Lite Interface
   .axi_clk          (i_fb_clk      ), 
   .axi_reset_n      (w_fb_clk_arstn),
   .axi_awaddr       (w_axi_awaddr  ),//Write Address. byte address.
   .axi_awvalid      (w_axi_awvalid ),//Write address valid.
   .axi_awready      (w_axi_awready ),//Write address ready.
   .axi_wdata        (w_axi_wdata   ),//Write data bus.
   .axi_wvalid       (w_axi_wvalid  ),//Write valid.
   .axi_wready       (w_axi_wready  ),//Write ready.
                    
   .axi_bvalid       (w_axi_bvalid  ),//Write response valid.
   .axi_bready       (w_axi_bready  ),//Response ready.      
   .axi_araddr       (w_axi_araddr  ),//Read address. byte address.
   .axi_arvalid      (w_axi_arvalid ),//Read address valid.
   .axi_arready      (w_axi_arready ),//Read address ready.
   .axi_rdata        (w_axi_rdata   ),//Read data.
   .axi_rvalid       (w_axi_rvalid  ),//Read valid.
   .axi_rready       (w_axi_rready  ),//Read ready.
   
   .hsync            (~dp_hs),
   .vsync            (~dp_vs),
   .vc               (2'b0),
   .datatype         (6'h3E),
   .pixel_data       ({16'b0, dp_b_data[15:8], dp_g_data[15:8], dp_r_data[15:8], dp_b_data[7:0], dp_g_data[7:0], dp_r_data[7:0]}),
   .pixel_data_valid (dp_data_valid),
   .haddr            (1080),
   .TurnRequest_dbg  (1'b0),
   .TurnRequest_done (),
   .irq              ()
);

////////////////////////////////////////////////////////////////
// APB3 for camera & display
wire hw_accel_dma_init_done;

assign debug_cam_display_fifo_status = {22'd0,debug_dma_hw_accel_out_fifo_overflow,debug_dma_hw_accel_out_fifo_underflow,debug_dma_hw_accel_in_fifo_overflow,debug_dma_hw_accel_in_fifo_underflow, debug_cam_pixel_remap_fifo_underflow, debug_cam_pixel_remap_fifo_overflow, debug_cam_dma_fifo_underflow, debug_cam_dma_fifo_overflow, 
                                        debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow};

//Shared for both camera and display
common_apb3 #(
   .ADDR_WIDTH (16),
   .DATA_WIDTH (32),
   .NUM_REG    (7)
) u_apb3_cam_display (
//   .select_demo_mode                  ({user_dip1,user_dip0}),
   .enable_cam                          (enable_cam),
   .cam_confdone                        (cam_confdone),
   .rgb_control                         (rgb_control),
   .trigger_capture_frame               (trigger_capture_frame),
   .continuous_capture_frame            (continuous_capture_frame),
   .rgb_gray                            (rgb_gray),
   .set_red_green                       (set_red_green),
   .cam_dma_init_done                   (cam_dma_init_done),
   .hw_accel_dma_init_done              (hw_accel_dma_init_done),
   .frames_per_second                   (frames_per_second),
   .debug_fifo_status                   (debug_cam_display_fifo_status),
   .debug_cam_dma_fifo_rcount           (debug_cam_dma_fifo_rcount),
   .debug_cam_dma_fifo_wcount           (debug_cam_dma_fifo_wcount),
   .debug_cam_dma_status                (debug_cam_dma_status),
   .debug_display_dma_fifo_rcount       (debug_display_dma_fifo_rcount),
   .debug_display_dma_fifo_wcount       (debug_display_dma_fifo_wcount),
   .debug_dma_hw_accel_in_fifo_wcount   (debug_dma_hw_accel_in_fifo_wcount),
   .debug_dma_hw_accel_out_fifo_rcount  (debug_dma_hw_accel_out_fifo_rcount),
   .clk                                 (peripheralClk),
   .resetn                              (~peripheralReset),
   .PADDR                               (io_apbSlave_1_PADDR),
   .PSEL                                (io_apbSlave_1_PSEL),
   .PENABLE                             (io_apbSlave_1_PENABLE),
   .PREADY                              (io_apbSlave_1_PREADY),
   .PWRITE                              (io_apbSlave_1_PWRITE),
   .PWDATA                              (io_apbSlave_1_PWDATA),
   .PRDATA                              (io_apbSlave_1_PRDATA),
   .PSLVERROR                           (io_apbSlave_1_PSLVERROR)
);

////////////////////////////////////////////////////////////////
// HyperRAM contoller

assign io_memoryClk      = i_hbramClk;   //Reuse existing PLL output clock
assign io_b_payload_resp = 2'b00;

hbram u_hbram (
   .rst                    (io_memoryReset),
   .ram_clk                (i_hbramClk), 
   .ram_clk_cal            (i_hbramClk_cal),
   .io_axi_clk             (io_memoryClk),
   .io_arw_valid           (io_arw_valid),
   .io_arw_ready           (io_arw_ready),
   .io_arw_payload_addr    (io_arw_payload_addr),
   .io_arw_payload_id      (io_arw_payload_id),
   .io_arw_payload_len     (io_arw_payload_len),
   .io_arw_payload_size    (io_arw_payload_size),
   .io_arw_payload_burst   (io_arw_payload_burst),
   .io_arw_payload_lock    (io_arw_payload_lock),
   .io_arw_payload_write   (io_arw_payload_write),
   .io_w_payload_id        (io_w_payload_id),
   .io_w_valid             (io_w_valid),
   .io_w_ready             (io_w_ready),
   .io_w_payload_data      (io_w_payload_data),
   .io_w_payload_strb      (io_w_payload_strb),
   .io_w_payload_last      (io_w_payload_last),
   .io_b_valid             (io_b_valid),
   .io_b_ready             (io_b_ready),
   .io_b_payload_id        (io_b_payload_id),
   .io_r_valid             (io_r_valid),
   .io_r_ready             (io_r_ready),
   .io_r_payload_data      (io_r_payload_data),
   .io_r_payload_id        (io_r_payload_id),
   .io_r_payload_resp      (io_r_payload_resp),
   .io_r_payload_last      (io_r_payload_last),
   .dyn_pll_phase_en       (1'b1),
   .dyn_pll_phase_sel      (3'b010),                                                             
   .hbc_cal_SHIFT_ENA      (o_hbc_cal_SHIFT_ENA),
   .hbc_cal_SHIFT          (o_hbc_cal_SHIFT),
   .hbc_cal_SHIFT_SEL      (o_hbc_cal_SHIFT_SEL),
   .hbc_cal_pass           (hbc_cal_pass),
   .hbc_cal_debug_info     (),                            
   .hbc_rst_n              (hbc_rst_n), 
   .hbc_cs_n               (hbc_cs_n),
   .hbc_ck_p_HI            (hbc_ck_p_HI),
   .hbc_ck_p_LO            (hbc_ck_p_LO),
   .hbc_ck_n_HI            (hbc_ck_n_HI),
   .hbc_ck_n_LO            (hbc_ck_n_LO),
   .hbc_rwds_OUT_HI        (hbc_rwds_OUT_HI),
   .hbc_rwds_OUT_LO        (hbc_rwds_OUT_LO),
   .hbc_rwds_IN_HI         (hbc_rwds_IN_HI),
   .hbc_rwds_IN_LO         (hbc_rwds_IN_LO),
   .hbc_rwds_OE            (hbc_rwds_OE),
   .hbc_dq_OUT_HI          (hbc_dq_OUT_HI),
   .hbc_dq_OUT_LO          (hbc_dq_OUT_LO),
   .hbc_dq_IN_HI           (hbc_dq_IN_HI),
   .hbc_dq_IN_LO           (hbc_dq_IN_LO),
   .hbc_dq_OE              (hbc_dq_OE)
);

////////////////////////////////////////////////////////////////
// RISC-V SoC
assign mcuReset = ~(i_hbramClk_pll_locked & i_pll_locked & i_arstn);

//Share 100MHz clock
//If this is updated, user to ensure corresponding clock pin is set in related peripheral(s) such as SPI in Interface Designer.
assign peripheralClk = i_mipi_rx_pclk;

assign userInterruptA = cpu_customInstruction_cmd_int;
assign userInterruptB = |dma_interrupts;

//Custom instruction
tinyml_top #(
    .AXI_DW          (AXI_TINYML_DATA_WIDTH)
) u_tinyml_top (
   .clk              (i_systemClk),
   .reset            (io_systemReset),
   .cmd_valid        (cpu_customInstruction_cmd_valid),
   .cmd_ready        (cpu_customInstruction_cmd_ready),
   .cmd_function_id  (cpu_customInstruction_function_id),
   .cmd_inputs_0     (cpu_customInstruction_inputs_0),
   .cmd_inputs_1     (cpu_customInstruction_inputs_1),
   .cmd_int          (cpu_customInstruction_cmd_int),
   .rsp_valid        (cpu_customInstruction_rsp_valid),
   .rsp_ready        (cpu_customInstruction_rsp_ready),
   .rsp_outputs_0    (cpu_customInstruction_outputs_0),
   .m_axi_clk        (io_memoryClk),
   .m_axi_rstn       (!io_systemReset),
   .m_axi_awvalid    (axi_inter_s2_awvalid),
   .m_axi_awaddr     (axi_inter_s2_awaddr),
   .m_axi_awlen      (axi_inter_s2_awlen),
   .m_axi_awsize     (axi_inter_s2_awsize),
   .m_axi_awburst    (axi_inter_s2_awburst),
   .m_axi_awprot     (axi_inter_s2_awprot),
   .m_axi_awlock     (axi_inter_s2_awlock),
   .m_axi_awcache    (axi_inter_s2_awcache),
   .m_axi_awready    (axi_inter_s2_awready),
   .m_axi_wdata      (axi_inter_s2_wdata),
   .m_axi_wstrb      (axi_inter_s2_wstrb),
   .m_axi_wlast      (axi_inter_s2_wlast),
   .m_axi_wvalid     (axi_inter_s2_wvalid),
   .m_axi_wready     (axi_inter_s2_wready),
   .m_axi_bresp      (axi_inter_s2_bresp),
   .m_axi_bvalid     (axi_inter_s2_bvalid),
   .m_axi_bready     (axi_inter_s2_bready),
   .m_axi_arvalid    (axi_inter_s2_arvalid),
   .m_axi_araddr     (axi_inter_s2_araddr),
   .m_axi_arlen      (axi_inter_s2_arlen),
   .m_axi_arsize     (axi_inter_s2_arsize),
   .m_axi_arburst    (axi_inter_s2_arburst),
   .m_axi_arprot     (axi_inter_s2_arprot),
   .m_axi_arlock     (axi_inter_s2_arlock),
   .m_axi_arcache    (axi_inter_s2_arcache),
   .m_axi_arready    (axi_inter_s2_arready),
   .m_axi_rvalid     (axi_inter_s2_rvalid),
   .m_axi_rdata      (axi_inter_s2_rdata),
   .m_axi_rlast      (axi_inter_s2_rlast),
   .m_axi_rresp      (axi_inter_s2_rresp),
   .m_axi_rready     (axi_inter_s2_rready)
);

SapphireSoc u_risc_v
(
   .io_systemClk                       (i_systemClk),
   .io_asyncReset                      (mcuReset),
   .io_memoryClk                       (io_memoryClk),
   .io_peripheralClk                   (peripheralClk),
   .io_peripheralReset                 (peripheralReset),
   .io_memoryReset                     (io_memoryReset),
   .system_uart_0_io_txd               (system_uart_0_io_txd),
   .system_uart_0_io_rxd               (system_uart_0_io_rxd),
   .system_i2c_0_io_sda_write          (mipi_i2c_0_io_sda_write),
   .system_i2c_0_io_sda_read           (mipi_i2c_0_io_sda_read),
   .system_i2c_0_io_scl_write          (mipi_i2c_0_io_scl_write),
   .system_i2c_0_io_scl_read           (mipi_i2c_0_io_scl_read),
   .io_apbSlave_0_PADDR                (io_apbSlave_0_PADDR),
   .io_apbSlave_0_PSEL                 (io_apbSlave_0_PSEL),
   .io_apbSlave_0_PENABLE              (io_apbSlave_0_PENABLE),
   .io_apbSlave_0_PREADY               (io_apbSlave_0_PREADY),
   .io_apbSlave_0_PWRITE               (io_apbSlave_0_PWRITE),
   .io_apbSlave_0_PWDATA               (io_apbSlave_0_PWDATA),
   .io_apbSlave_0_PRDATA               (io_apbSlave_0_PRDATA),
   .io_apbSlave_0_PSLVERROR            (io_apbSlave_0_PSLVERROR),
   .io_apbSlave_1_PADDR                (io_apbSlave_1_PADDR),
   .io_apbSlave_1_PSEL                 (io_apbSlave_1_PSEL),
   .io_apbSlave_1_PENABLE              (io_apbSlave_1_PENABLE),
   .io_apbSlave_1_PREADY               (io_apbSlave_1_PREADY),
   .io_apbSlave_1_PWRITE               (io_apbSlave_1_PWRITE),
   .io_apbSlave_1_PWDATA               (io_apbSlave_1_PWDATA),
   .io_apbSlave_1_PRDATA               (io_apbSlave_1_PRDATA),
   .io_apbSlave_1_PSLVERROR            (io_apbSlave_1_PSLVERROR),
   .userInterruptA                     (userInterruptA),
   .userInterruptB                     (userInterruptB),
   .io_systemReset                     (io_systemReset),
   .io_ddrA_arw_valid                  (soc_io_arw_valid),
   .io_ddrA_arw_ready                  (soc_io_arw_ready),
   .io_ddrA_arw_payload_addr           (soc_io_arw_payload_addr),
   .io_ddrA_arw_payload_id             (soc_io_arw_payload_id),
   .io_ddrA_arw_payload_region         (soc_io_arw_payload_region),
   .io_ddrA_arw_payload_len            (soc_io_arw_payload_len),
   .io_ddrA_arw_payload_size           (soc_io_arw_payload_size),
   .io_ddrA_arw_payload_burst          (soc_io_arw_payload_burst),
   .io_ddrA_arw_payload_lock           (soc_io_arw_payload_lock),
   .io_ddrA_arw_payload_cache          (soc_io_arw_payload_cache),
   .io_ddrA_arw_payload_qos            (soc_io_arw_payload_qos),
   .io_ddrA_arw_payload_prot           (soc_io_arw_payload_prot),
   .io_ddrA_arw_payload_write          (soc_io_arw_payload_write),
   .io_ddrA_w_valid                    (axi_inter_s0_wvalid),
   .io_ddrA_w_ready                    (axi_inter_s0_wready),
   .io_ddrA_w_payload_data             (axi_inter_s0_wdata),
   .io_ddrA_w_payload_strb             (axi_inter_s0_wstrb),
   .io_ddrA_w_payload_last             (axi_inter_s0_wlast),
   .io_ddrA_b_valid                    (axi_inter_s0_bvalid),
   .io_ddrA_b_ready                    (axi_inter_s0_bready),
   .io_ddrA_b_payload_id               (axi_inter_s0_bid),
   .io_ddrA_b_payload_resp             (axi_inter_s0_bresp),
   .io_ddrA_r_valid                    (axi_inter_s0_rvalid),
   .io_ddrA_r_ready                    (axi_inter_s0_rready),
   .io_ddrA_r_payload_data             (axi_inter_s0_rdata),
   .io_ddrA_r_payload_id               (axi_inter_s0_rid),
   .io_ddrA_r_payload_resp             (axi_inter_s0_rresp),
   .io_ddrA_r_payload_last             (axi_inter_s0_rlast),
   .io_ddrA_w_payload_id               (soc_io_w_payload_id),
   .system_spi_0_io_sclk_write         (system_spi_0_io_sclk_write),
   .system_spi_0_io_data_0_writeEnable (system_spi_0_io_data_0_writeEnable),
   .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read),
   .system_spi_0_io_data_0_write       (system_spi_0_io_data_0_write),
   .system_spi_0_io_data_1_writeEnable (system_spi_0_io_data_1_writeEnable),
   .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read),
   .system_spi_0_io_data_1_write       (system_spi_0_io_data_1_write),
   .system_spi_0_io_ss                 (system_spi_0_io_ss),
   .cpu0_customInstruction_cmd_valid   (cpu_customInstruction_cmd_valid),
   .cpu0_customInstruction_cmd_ready   (cpu_customInstruction_cmd_ready),
   .cpu0_customInstruction_function_id (cpu_customInstruction_function_id),
   .cpu0_customInstruction_inputs_0    (cpu_customInstruction_inputs_0),
   .cpu0_customInstruction_inputs_1    (cpu_customInstruction_inputs_1),
   .cpu0_customInstruction_rsp_valid   (cpu_customInstruction_rsp_valid),
   .cpu0_customInstruction_rsp_ready   (cpu_customInstruction_rsp_ready),
   .cpu0_customInstruction_outputs_0   (cpu_customInstruction_outputs_0),
`ifndef SOFT_TAP
  .jtagCtrl_tck                        (jtag_inst1_TCK),
  .jtagCtrl_tdi                        (jtag_inst1_TDI),
  .jtagCtrl_tdo                        (jtag_inst1_TDO),
  .jtagCtrl_enable                     (jtag_inst1_SEL),
  .jtagCtrl_capture                    (jtag_inst1_CAPTURE),
  .jtagCtrl_shift                      (jtag_inst1_SHIFT),
  .jtagCtrl_update                     (jtag_inst1_UPDATE),
  .jtagCtrl_reset                      (jtag_inst1_RESET)
`else
  .io_jtag_tms                         (io_jtag_tms),
  .io_jtag_tdi                         (io_jtag_tdi),
  .io_jtag_tdo                         (io_jtag_tdo),
  .io_jtag_tck                         (io_jtag_tck)
`endif
);

////////////////////////////////////////////////////////////////
// Hardware Accelerator

//For yolo person detection model
//Scale from FRAME_WIDTHxFRAME_HEIGHT to 96x96 resolution
hw_accel_wrapper #(
   .RGB2GRAYSCALE       (RGB2GRAYSCALE),
   .OUT_FRAME_WIDTH     (OUT_FRAME_WIDTH),
   .OUT_FRAME_HEIGHT    (OUT_FRAME_HEIGHT),
   .FRAME_WIDTH         (FRAME_WIDTH),
   .FRAME_HEIGHT        (FRAME_HEIGHT),
   .DMA_TRANSFER_LENGTH ((96*96*3)/4) //S2MM DMA transfer for yolo person detection demo
) u_hw_accel_wrapper (
   .clk                                         (i_systemClk),
   .rst                                         (io_systemReset),
   .hw_accel_dma_init_done                      (hw_accel_dma_init_done),
   .dma_rready                                  (hw_accel_dma_rready),
   .dma_rvalid                                  (hw_accel_dma_rvalid),
   .dma_rdata                                   (hw_accel_dma_rdata),
   .dma_rkeep                                   (hw_accel_dma_rkeep),
   .dma_wready                                  (hw_accel_dma_wready),
   .dma_wvalid                                  (hw_accel_dma_wvalid),
   .dma_wlast                                   (hw_accel_dma_wlast),
   .dma_wdata                                   (hw_accel_dma_wdata),
   
   // Debug Register
   .debug_dma_hw_accel_in_fifo_underflow        (debug_dma_hw_accel_in_fifo_underflow),
   .debug_dma_hw_accel_in_fifo_overflow         (debug_dma_hw_accel_in_fifo_overflow),
   .debug_dma_hw_accel_out_fifo_underflow       (debug_dma_hw_accel_out_fifo_underflow),
   .debug_dma_hw_accel_out_fifo_overflow        (debug_dma_hw_accel_out_fifo_overflow),
   .debug_dma_hw_accel_in_fifo_wcount           (debug_dma_hw_accel_in_fifo_wcount),
   .debug_dma_hw_accel_out_fifo_rcount          (debug_dma_hw_accel_out_fifo_rcount)
);

////////////////////////////////////////////////////////////////
// DMA controller

dma u_dma (
   .clk              (io_memoryClk),
   .reset            (io_systemReset),
   .ctrl_clk         (peripheralClk),
   .ctrl_reset       (peripheralReset),
   .ctrl_PADDR       (io_apbSlave_0_PADDR),
   .ctrl_PSEL        (io_apbSlave_0_PSEL),
   .ctrl_PENABLE     (io_apbSlave_0_PENABLE),
   .ctrl_PREADY      (io_apbSlave_0_PREADY),
   .ctrl_PWRITE      (io_apbSlave_0_PWRITE),
   .ctrl_PWDATA      (io_apbSlave_0_PWDATA),
   .ctrl_PRDATA      (io_apbSlave_0_PRDATA),
   .ctrl_PSLVERROR   (io_apbSlave_0_PSLVERROR),
   .ctrl_interrupts  (dma_interrupts),
   .read_arvalid     (axi_inter_s1_arvalid),
   .read_arready     (axi_inter_s1_arready),
   .read_araddr      (axi_inter_s1_araddr),
   .read_arregion    (dma_arregion),         //Keep from synthesized away
   .read_arlen       (axi_inter_s1_arlen),
   .read_arsize      (axi_inter_s1_arsize),
   .read_arburst     (axi_inter_s1_arburst),
   .read_arlock      (axi_inter_s1_arlock),
   .read_arcache     (axi_inter_s1_arcache),
   .read_arqos       (axi_inter_s1_arqos),
   .read_arprot      (axi_inter_s1_arprot),
   .read_rvalid      (axi_inter_s1_rvalid),
   .read_rready      (axi_inter_s1_rready),
   .read_rdata       (axi_inter_s1_rdata),
   .read_rresp       (axi_inter_s1_rresp),
   .read_rlast       (axi_inter_s1_rlast),
   .write_awvalid    (axi_inter_s1_awvalid),
   .write_awready    (axi_inter_s1_awready),
   .write_awaddr     (axi_inter_s1_awaddr),
   .write_awregion   (dma_awregion),         //Keep from synthesized away
   .write_awlen      (axi_inter_s1_awlen),
   .write_awsize     (axi_inter_s1_awsize),
   .write_awburst    (axi_inter_s1_awburst),
   .write_awlock     (axi_inter_s1_awlock),
   .write_awcache    (axi_inter_s1_awcache),
   .write_awqos      (axi_inter_s1_awqos),
   .write_awprot     (axi_inter_s1_awprot),
   .write_wvalid     (axi_inter_s1_wvalid),
   .write_wready     (axi_inter_s1_wready),
   .write_wdata      (axi_inter_s1_wdata),
   .write_wstrb      (axi_inter_s1_wstrb),
   .write_wlast      (axi_inter_s1_wlast),
   .write_bvalid     (axi_inter_s1_bvalid),
   .write_bready     (axi_inter_s1_bready),
   .write_bresp      (axi_inter_s1_bresp), 
   //64-bit dma channel (S2MM - to external memory)
   .dat0_i_clk       (i_mipi_rx_pclk),
   .dat0_i_reset     (~w_mipi_rx_pclk_arstn),
   .dat0_i_tvalid    (cam_dma_wvalid),
   .dat0_i_tready    (cam_dma_wready),
   .dat0_i_tdata     (cam_dma_wdata),
   .dat0_i_tkeep     ({8{cam_dma_wvalid}}),
   .dat0_i_tdest     (4'd0),
   .dat0_i_tlast     (cam_dma_wlast),
   //64-bit dma channel (MM2S - from external memory)
   .dat1_o_clk       (i_sysclk_div_2),
   .dat1_o_reset     (~w_sys_dp_arstn),
   .dat1_o_tvalid    (bbox_dma_tvalid),
   .dat1_o_tready    (bbox_dma_tready),
   .dat1_o_tdata     (bbox_dma_tdata),
   .dat1_o_tkeep     (),
   .dat1_o_tdest     (),
   .dat1_o_tlast     (bbox_dma_tlast),
   //32-bit dma channel (S2MM - to external memory)
   .dat2_i_clk       (i_systemClk),
   .dat2_i_reset     (io_systemReset),
   .dat2_i_tvalid    (hw_accel_dma_wvalid),
   .dat2_i_tready    (hw_accel_dma_wready),
   .dat2_i_tdata     (hw_accel_dma_wdata),
   .dat2_i_tkeep     ({4{hw_accel_dma_wvalid}}),
   .dat2_i_tdest     (4'd0),
   .dat2_i_tlast     (hw_accel_dma_wlast),
   //32-bit dma channel (MM2S - from external memory)
   .dat3_o_clk       (i_systemClk),
   .dat3_o_reset     (io_systemReset),
   .dat3_o_tvalid    (hw_accel_dma_rvalid),
   .dat3_o_tready    (hw_accel_dma_rready),
   .dat3_o_tdata     (hw_accel_dma_rdata),
   .dat3_o_tkeep     (hw_accel_dma_rkeep),
   .dat3_o_tdest     (),
   .dat3_o_tlast     ()
);

////////////////////////////////////////////////////////////////
// AXI interconnect - Bridge across HyperRAM controller, RISC-V SoC, and DMA controller

//Convert from half duplex to full duplex - Connected to RubySoC
assign axi_inter_s0_awid    = (soc_io_arw_payload_write) ? soc_io_arw_payload_id    :  'h0;
assign axi_inter_s0_awaddr  = (soc_io_arw_payload_write) ? soc_io_arw_payload_addr  :  'h0;
assign axi_inter_s0_awlen   = (soc_io_arw_payload_write) ? soc_io_arw_payload_len   :  'h0;
assign axi_inter_s0_awsize  = (soc_io_arw_payload_write) ? soc_io_arw_payload_size  :  'h0;
assign axi_inter_s0_awburst = (soc_io_arw_payload_write) ? soc_io_arw_payload_burst :  'h0;
assign axi_inter_s0_awlock  = (soc_io_arw_payload_write) ? soc_io_arw_payload_lock  : 1'b0;
assign axi_inter_s0_awcache = (soc_io_arw_payload_write) ? soc_io_arw_payload_cache :  'h0;
assign axi_inter_s0_awprot  = (soc_io_arw_payload_write) ? soc_io_arw_payload_prot  :  'h0;
assign axi_inter_s0_awqos   = (soc_io_arw_payload_write) ? soc_io_arw_payload_qos   :  'h0;
assign axi_inter_s0_awvalid = (soc_io_arw_payload_write) ? soc_io_arw_valid         : 1'b0;
 
assign axi_inter_s0_arid    = (~soc_io_arw_payload_write) ? soc_io_arw_payload_id    :  'h0;
assign axi_inter_s0_araddr  = (~soc_io_arw_payload_write) ? soc_io_arw_payload_addr  :  'h0;
assign axi_inter_s0_arlen   = (~soc_io_arw_payload_write) ? soc_io_arw_payload_len   :  'h0;
assign axi_inter_s0_arsize  = (~soc_io_arw_payload_write) ? soc_io_arw_payload_size  :  'h0;
assign axi_inter_s0_arburst = (~soc_io_arw_payload_write) ? soc_io_arw_payload_burst :  'h0;
assign axi_inter_s0_arlock  = (~soc_io_arw_payload_write) ? soc_io_arw_payload_lock  : 1'b0;
assign axi_inter_s0_arcache = (~soc_io_arw_payload_write) ? soc_io_arw_payload_cache :  'h0;
assign axi_inter_s0_arprot  = (~soc_io_arw_payload_write) ? soc_io_arw_payload_prot  :  'h0;
assign axi_inter_s0_arqos   = (~soc_io_arw_payload_write) ? soc_io_arw_payload_qos   :  'h0;
assign axi_inter_s0_arvalid = (~soc_io_arw_payload_write) ? soc_io_arw_valid         : 1'b0;

assign soc_io_arw_ready = (soc_io_arw_payload_write) ? axi_inter_s0_awready : axi_inter_s0_arready;

assign axi_inter_s1_awid  = 8'hE0; //Don't care for DMA controller
assign axi_inter_s1_arid  = 8'hE1; //Don't care for DMA controller

axi_interconnect_beta #(
    .S_COUNT                            (3                                                 ),
    .SLAVE_ASYN_ARRAY                   ({1'b0,1'b0,1'b0}                                  ),
    .S_AXI_DW_ARRAY                     ({AXI_TINYML_DATA_WIDTH,AXI_DATA_WIDTH,AXI_DATA_WIDTH}    ),
    .CB_DW                              (AXI_DATA_WIDTH                                    ),
    .M_AXI_DW                           (AXI_DATA_WIDTH                                    ),
    .ARB_MODE                           (1                                                 ),
    .FAMILY                             ("TITANIUM"                                        ),
    .RD_QUEUE_FIFO_RAM_STYLE            ("block_ram"                                       ),
    .RD_QUEUE_FIFO_DEPTH                (256                                               )
) u_axi_interconnect (
   //AXI slave interfaces - S0: Connected to RISC-V SoC; S1: Connected to DMA controller; S2: Connected to TinyML accelerator
   .s_axi_clk       ({io_memoryClk         , io_memoryClk        , io_memoryClk        }),
   .s_axi_rstn      ({!io_systemReset      , !io_systemReset     , !io_systemReset     }),
   .s_axi_awaddr     ({axi_inter_s2_awaddr , axi_inter_s1_awaddr , axi_inter_s0_awaddr }),
   .s_axi_awlen      ({axi_inter_s2_awlen  , axi_inter_s1_awlen  , axi_inter_s0_awlen  }),
   .s_axi_awvalid    ({axi_inter_s2_awvalid, axi_inter_s1_awvalid, axi_inter_s0_awvalid}),
   .s_axi_awready    ({axi_inter_s2_awready, axi_inter_s1_awready, axi_inter_s0_awready}),
   .s_axi_wdata      ({axi_inter_s2_wdata  , axi_inter_s1_wdata  , axi_inter_s0_wdata  }),
   .s_axi_wstrb      ({axi_inter_s2_wstrb  , axi_inter_s1_wstrb  , axi_inter_s0_wstrb  }),
   .s_axi_wlast      ({axi_inter_s2_wlast  , axi_inter_s1_wlast  , axi_inter_s0_wlast  }),
   .s_axi_wvalid     ({axi_inter_s2_wvalid , axi_inter_s1_wvalid , axi_inter_s0_wvalid }),
   .s_axi_wready     ({axi_inter_s2_wready , axi_inter_s1_wready , axi_inter_s0_wready }),
   .s_axi_bresp      ({axi_inter_s2_bresp  , axi_inter_s1_bresp  , axi_inter_s0_bresp  }),
   .s_axi_bvalid     ({axi_inter_s2_bvalid , axi_inter_s1_bvalid , axi_inter_s0_bvalid }),
   .s_axi_bready     ({axi_inter_s2_bready , axi_inter_s1_bready , axi_inter_s0_bready }),
   .s_axi_araddr     ({axi_inter_s2_araddr , axi_inter_s1_araddr , axi_inter_s0_araddr }),
   .s_axi_arlen      ({axi_inter_s2_arlen  , axi_inter_s1_arlen  , axi_inter_s0_arlen  }),
   .s_axi_arvalid    ({axi_inter_s2_arvalid, axi_inter_s1_arvalid, axi_inter_s0_arvalid}),
   .s_axi_arready    ({axi_inter_s2_arready, axi_inter_s1_arready, axi_inter_s0_arready}),
   .s_axi_rdata      ({axi_inter_s2_rdata  , axi_inter_s1_rdata  , axi_inter_s0_rdata  }),
   .s_axi_rresp      ({axi_inter_s2_rresp  , axi_inter_s1_rresp  , axi_inter_s0_rresp  }),
   .s_axi_rlast      ({axi_inter_s2_rlast  , axi_inter_s1_rlast  , axi_inter_s0_rlast  }),
   .s_axi_rvalid     ({axi_inter_s2_rvalid , axi_inter_s1_rvalid , axi_inter_s0_rvalid }),
   .s_axi_rready     ({axi_inter_s2_rready , axi_inter_s1_rready , axi_inter_s0_rready }),
   //AXI master interface - Connect to HyperRAM controller
   .m_axi_clk        (io_memoryClk),
   .m_axi_rstn       (!io_systemReset),

   .m_axi_awid       (axi_inter_m_awid),
   .m_axi_awaddr     (axi_inter_m_awaddr),
   .m_axi_awlen      (axi_inter_m_awlen),
   .m_axi_awsize     (axi_inter_m_awsize),
   .m_axi_awburst    (axi_inter_m_awburst),
   .m_axi_awlock     (axi_inter_m_awlock),
   .m_axi_awcache    (axi_inter_m_awcache),
   .m_axi_awprot     (axi_inter_m_awprot),
   .m_axi_awvalid    (axi_inter_m_awvalid),
   .m_axi_awready    (axi_inter_m_awready),
   .m_axi_wdata      (axi_inter_m_wdata),
   .m_axi_wstrb      (axi_inter_m_wstrb),
   .m_axi_wlast      (axi_inter_m_wlast),
   .m_axi_wvalid     (axi_inter_m_wvalid),
   .m_axi_wready     (axi_inter_m_wready),
   .m_axi_bresp      (axi_inter_m_bresp),
   .m_axi_bvalid     (axi_inter_m_bvalid),
   .m_axi_bready     (axi_inter_m_bready),
   .m_axi_arid       (axi_inter_m_arid),
   .m_axi_araddr     (axi_inter_m_araddr),
   .m_axi_arlen      (axi_inter_m_arlen),
   .m_axi_arsize     (axi_inter_m_arsize),
   .m_axi_arburst    (axi_inter_m_arburst),
   .m_axi_arlock     (axi_inter_m_arlock),
   .m_axi_arcache    (axi_inter_m_arcache),
   .m_axi_arprot     (axi_inter_m_arprot),
   .m_axi_arvalid    (axi_inter_m_arvalid),
   .m_axi_arready    (axi_inter_m_arready),
   .m_axi_rdata      (axi_inter_m_rdata),
   .m_axi_rresp      (axi_inter_m_rresp),
   .m_axi_rlast      (axi_inter_m_rlast),
   .m_axi_rvalid     (axi_inter_m_rvalid),
   .m_axi_rready     (axi_inter_m_rready)
);

//Convert from half duplex to full duplex of memory controller interface (Connect to HyperRAM controller)
axi_full_to_half_duplex #(
   .DATA_WIDTH (AXI_DATA_WIDTH),
   .ADDR_WIDTH (32),
   .ID_WIDTH   (8)
) u_axi_full_to_half_duplex (
   .clk                       (io_memoryClk),
   .rst                       (io_systemReset),
   .io_ddr_arw_valid          (io_arw_valid),
   .io_ddr_arw_ready          (io_arw_ready),
   .io_ddr_arw_payload_addr   (io_arw_payload_addr),
   .io_ddr_arw_payload_id     (io_arw_payload_id),
   .io_ddr_arw_payload_len    (io_arw_payload_len),
   .io_ddr_arw_payload_size   (io_arw_payload_size),
   .io_ddr_arw_payload_burst  (io_arw_payload_burst),
   .io_ddr_arw_payload_lock   (io_arw_payload_lock),
   .io_ddr_arw_payload_write  (io_arw_payload_write),
   .io_ddr_w_payload_id       (io_w_payload_id),
   .io_ddr_w_valid            (io_w_valid),
   .io_ddr_w_ready            (io_w_ready),
   .io_ddr_w_payload_data     (io_w_payload_data),
   .io_ddr_w_payload_strb     (io_w_payload_strb),
   .io_ddr_w_payload_last     (io_w_payload_last),
   .io_ddr_b_valid            (io_b_valid),
   .io_ddr_b_ready            (io_b_ready),
   .io_ddr_b_payload_id       (io_b_payload_id),
   .io_ddr_r_valid            (io_r_valid),
   .io_ddr_r_ready            (io_r_ready),
   .io_ddr_r_payload_data     (io_r_payload_data),
   .io_ddr_r_payload_id       (io_r_payload_id),
   .io_ddr_r_payload_resp     (io_r_payload_resp),
   .io_ddr_r_payload_last     (io_r_payload_last),
   .s_axi_awid                (axi_inter_m_awid),
   .s_axi_awaddr              (axi_inter_m_awaddr),
   .s_axi_awlen               (axi_inter_m_awlen),
   .s_axi_awsize              (axi_inter_m_awsize),
   .s_axi_awburst             (axi_inter_m_awburst),
   .s_axi_awlock              (axi_inter_m_awlock),
   .s_axi_awcache             (axi_inter_m_awcache),
   .s_axi_awprot              (axi_inter_m_awprot),
   .s_axi_awqos               (axi_inter_m_awqos),
   .s_axi_awregion            (axi_inter_m_awregion),
   .s_axi_awvalid             (axi_inter_m_awvalid),
   .s_axi_awready             (axi_inter_m_awready),
   .s_axi_wdata               (axi_inter_m_wdata),
   .s_axi_wstrb               (axi_inter_m_wstrb),
   .s_axi_wlast               (axi_inter_m_wlast),
   .s_axi_wvalid              (axi_inter_m_wvalid),
   .s_axi_wready              (axi_inter_m_wready),
   .s_axi_bid                 (axi_inter_m_bid),
   .s_axi_bresp               (axi_inter_m_bresp),
   .s_axi_bvalid              (axi_inter_m_bvalid),
   .s_axi_bready              (axi_inter_m_bready),
   .s_axi_arid                (axi_inter_m_arid),
   .s_axi_araddr              (axi_inter_m_araddr),
   .s_axi_arlen               (axi_inter_m_arlen),
   .s_axi_arsize              (axi_inter_m_arsize),
   .s_axi_arburst             (axi_inter_m_arburst),
   .s_axi_arlock              (axi_inter_m_arlock), 
   .s_axi_arcache             (axi_inter_m_arcache),
   .s_axi_arprot              (axi_inter_m_arprot),
   .s_axi_arqos               (axi_inter_m_arqos),
   .s_axi_arregion            (axi_inter_m_arregion),
   .s_axi_arvalid             (axi_inter_m_arvalid),
   .s_axi_arready             (axi_inter_m_arready),
   .s_axi_rid                 (axi_inter_m_rid),
   .s_axi_rdata               (axi_inter_m_rdata),
   .s_axi_rresp               (axi_inter_m_rresp),
   .s_axi_rlast               (axi_inter_m_rlast),
   .s_axi_rvalid              (axi_inter_m_rvalid),
   .s_axi_rready              (axi_inter_m_rready)
);

endmodule
