///////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2024 github-efx
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

// To enable RiscV soft tap connection (for debugger).
//`define SOFT_TAP 1

module edge_vision_soc #(
    parameter RGB2GRAYSCALE          = "DISABLE",
    parameter OUT_FRAME_WIDTH        = 192,
    parameter OUT_FRAME_HEIGHT       = 192,
    parameter MIPI_FRAME_WIDTH  = 1920, // camera input Width
    parameter MIPI_FRAME_HEIGHT = 1080, // camera input Height
	parameter AXI_0_DATA_WIDTH  = 512 // AXI Width 0 connected to SOC and TinyML Accelerator
)	   
(
`ifndef SOFT_TAP        
output		                    jtagCtrl_tdi,
input		                    jtagCtrl_tdo,
output		                    jtagCtrl_enable,
output		                    jtagCtrl_capture,
output		                    jtagCtrl_shift,
output		                    jtagCtrl_update,
output		                    jtagCtrl_reset,
input		                    ut_jtagCtrl_tdi,
output		                    ut_jtagCtrl_tdo,
input		                    ut_jtagCtrl_enable,
input		                    ut_jtagCtrl_capture,
input		                    ut_jtagCtrl_shift,
input		                    ut_jtagCtrl_update,
input		                    ut_jtagCtrl_reset,
`else               
output                          io_jtag_tdi,
input                           io_jtag_tdo,
output                          io_jtag_tms,
input                           pin_io_jtag_tdi,
output                          pin_io_jtag_tdo,
input                           pin_io_jtag_tms,
`endif              
input		                    io_cfuClk,
input		                    io_cfuReset,
input		                    cpu0_customInstruction_cmd_valid,
output		                    cpu0_customInstruction_cmd_ready,
input [9:0]                     cpu0_customInstruction_function_id,
input [31:0]                    cpu0_customInstruction_inputs_0,
input [31:0]                    cpu0_customInstruction_inputs_1,
output		                    cpu0_customInstruction_rsp_valid,
input		                    cpu0_customInstruction_rsp_ready,
output [31:0]                   cpu0_customInstruction_outputs_0,

output		                    io_ddrMasters_0_aw_valid,
input		                    io_ddrMasters_0_aw_ready,
output [31:0]                   io_ddrMasters_0_aw_payload_addr,
output [3:0]                    io_ddrMasters_0_aw_payload_id,
output [3:0]                    io_ddrMasters_0_aw_payload_region,
output [7:0]                    io_ddrMasters_0_aw_payload_len,
output [2:0]                    io_ddrMasters_0_aw_payload_size,
output [1:0]                    io_ddrMasters_0_aw_payload_burst,
output		                    io_ddrMasters_0_aw_payload_lock,
output [3:0]                    io_ddrMasters_0_aw_payload_cache,
output [3:0]                    io_ddrMasters_0_aw_payload_qos,
output [2:0]                    io_ddrMasters_0_aw_payload_prot,
output		                    io_ddrMasters_0_aw_payload_allStrb,
output		                    io_ddrMasters_0_w_valid,
input		                    io_ddrMasters_0_w_ready,
output [127:0]                  io_ddrMasters_0_w_payload_data,
output [15:0]                   io_ddrMasters_0_w_payload_strb,
output		                    io_ddrMasters_0_w_payload_last,
input		                    io_ddrMasters_0_b_valid,
output		                    io_ddrMasters_0_b_ready,
input [3:0]                     io_ddrMasters_0_b_payload_id,
input [1:0]                     io_ddrMasters_0_b_payload_resp,
output		                    io_ddrMasters_0_ar_valid,
input		                    io_ddrMasters_0_ar_ready,
output [31:0]                   io_ddrMasters_0_ar_payload_addr,
output [3:0]                    io_ddrMasters_0_ar_payload_id,
output [3:0]                    io_ddrMasters_0_ar_payload_region,
output [7:0]                    io_ddrMasters_0_ar_payload_len,
output [2:0]                    io_ddrMasters_0_ar_payload_size,
output [1:0]                    io_ddrMasters_0_ar_payload_burst,
output		                    io_ddrMasters_0_ar_payload_lock,
output [3:0]                    io_ddrMasters_0_ar_payload_cache,
output [3:0]                    io_ddrMasters_0_ar_payload_qos,
output [2:0]                    io_ddrMasters_0_ar_payload_prot,
input		                    io_ddrMasters_0_r_valid,
output		                    io_ddrMasters_0_r_ready,
input [127:0]                   io_ddrMasters_0_r_payload_data,
input [3:0]                     io_ddrMasters_0_r_payload_id,
input [1:0]                     io_ddrMasters_0_r_payload_resp,
input		                    io_ddrMasters_0_r_payload_last,
input		                    io_ddrMasters_0_clk,
input		                    io_ddrMasters_0_reset,
output		                    system_spi_0_io_sclk_write,
output		                    system_spi_0_io_data_0_writeEnable,
input		                    system_spi_0_io_data_0_read,
output		                    system_spi_0_io_data_0_write,
output		                    system_spi_0_io_data_1_writeEnable,
input		                    system_spi_0_io_data_1_read,
output		                    system_spi_0_io_data_1_write,
output		                    system_spi_0_io_data_2_writeEnable,
input		                    system_spi_0_io_data_2_read,
output		                    system_spi_0_io_data_2_write,
output		                    system_spi_0_io_data_3_writeEnable,
input		                    system_spi_0_io_data_3_read,
output		                    system_spi_0_io_data_3_write,
output [3:0]                    system_spi_0_io_ss,
output		                    system_uart_0_io_txd,
input		                    system_uart_0_io_rxd,
input [31:0]                    axiA_awaddr,
input [7:0]	                    axiA_awlen,
input [2:0]	                    axiA_awsize,
input [1:0]	                    axiA_awburst,
input		                    axiA_awlock,
input [3:0]	                    axiA_awcache,
input [2:0]	                    axiA_awprot,
input [3:0]	                    axiA_awqos,
input [3:0]	                    axiA_awregion,
input		                    axiA_awvalid,
output		                    axiA_awready,
input [31:0]                    axiA_wdata,
input [3:0]                     axiA_wstrb,
input		                    axiA_wvalid,
input		                    axiA_wlast,
output		                    axiA_wready,
output [1:0]                    axiA_bresp,
output		                    axiA_bvalid,
input		                    axiA_bready,
input [31:0]                    axiA_araddr,
input [7:0]	                    axiA_arlen,
input [2:0]	                    axiA_arsize,
input [1:0]	                    axiA_arburst,
input		                    axiA_arlock,
input [3:0]	                    axiA_arcache,
input [2:0]	                    axiA_arprot,
input [3:0]	                    axiA_arqos,
input [3:0]	                    axiA_arregion,
input		                    axiA_arvalid,
output		                    axiA_arready,
output [31:0]                   axiA_rdata,
output [1:0]                    axiA_rresp,
output		                    axiA_rlast,
output		                    axiA_rvalid,
input		                    axiA_rready,
output                          axiAInterrupt,
input                           cfg_done,
output                          cfg_start,
output                          cfg_sel,
output                          cfg_reset,
output		                    userInterruptA,
output		                    userInterruptB,
output		                    userInterruptC,
output		                    userInterruptD,
output		                    userInterruptE,

//MIPI RX - Camera      
input    wire                   cam_ck_LP_P_IN,
input    wire                   cam_ck_LP_N_IN,
output   wire                   cam_ck_HS_TERM,
output   wire                   cam_ck_HS_ENA,
input    wire                   cam_ck_CLKOUT,

input    wire  [7:0]            cam_d0_HS_IN,
input    wire  [7:0]            cam_d0_HS_IN_1,
input    wire  [7:0]            cam_d0_HS_IN_2,
input    wire  [7:0]            cam_d0_HS_IN_3,
input    wire                   cam_d0_LP_P_IN,
input    wire                   cam_d0_LP_N_IN,
output   wire                   cam_d0_HS_TERM,
output   wire                   cam_d0_HS_ENA,
output   wire                   cam_d0_RST,
output   wire                   cam_d0_FIFO_RD,
input    wire                   cam_d0_FIFO_EMPTY,

input    wire  [7:0]            cam_d1_HS_IN,
input    wire  [7:0]            cam_d1_HS_IN_1,
input    wire  [7:0]            cam_d1_HS_IN_2,
input    wire  [7:0]            cam_d1_HS_IN_3,
input    wire                   cam_d1_LP_P_IN,
input    wire                   cam_d1_LP_N_IN,
output   wire                   cam_d1_HS_TERM,
output   wire                   cam_d1_HS_ENA,
output   wire                   cam_d1_RST,
output   wire                   cam_d1_FIFO_RD,
input    wire                   cam_d1_FIFO_EMPTY,

//CSI Camera interface      
input                           i_cam_sda,
output                          o_cam_sda_oe,
input                           i_cam_scl,
output                          o_cam_scl_oe,
output	                        o_cam_scl,
output	                        o_cam_sda,
output                          o_cam_rstn,

// I2C Configuration for HDMI
input                           i_hdmi_sda,
output                          o_hdmi_sda_oe,
input                           i_hdmi_scl,
output                          o_hdmi_scl_oe,


input                           hdmi_yuv_hs_IN,
output                          hdmi_yuv_vs_OE,
input                           hdmi_yuv_vs_IN,
output                          hdmi_yuv_hs_OE,
output                          hdmi_yuv_vs_OUT,
output                          hdmi_yuv_hs_OUT,

output                          hdmi_yuv_de,
output  [15:0]                  hdmi_yuv_data,


input                           pll_hdmi_LOCKED,
output                          pll_hdmi_RSTN,
input                           pll_osc_LOCKED,
output                          pll_osc_RSTN,


input                           rx_cfgclk,
input                           i_sys_clk,
input                           io_memoryClk,
input                           i_pixel_clk,
input                           i_soc_clk,
input                           i_hdmi_clk_148p5MHz,
input                           i_sys_clk_25mhz,

input		                    io_peripheralClk,
input                           io_peripheralReset,
input                           io_systemReset,
output                          io_asyncReset,
output  reg                     sysClk_reset_ok,
output  reg                     periClk_reset_ok,
input                           io_gpio_sw_n, 
input                           pll_peripheral_locked,
input                           pll_system_locked,


//DDR AXI 0
output soc_ddr_inst1_ARSTN_0,
//DDR AXI 0 Read Address Channel
output  [32:0]                  soc_ddr_inst1_ARADDR_0,   //Read address. It gives the address of the first transfer in a burst transaction.
output  [1:0]                   soc_ddr_inst1_ARBURST_0,   //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
output  [5:0]                   soc_ddr_inst1_ARID_0,      //Address ID. This signal identifies the group of address signals.
output  [7:0]                   soc_ddr_inst1_ARLEN_0,     //Burst length. This signal indicates the number of transfers in a burst.
input                           soc_ddr_inst1_ARREADY_0,         //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
output  [2:0]                   soc_ddr_inst1_ARSIZE_0,     //Burst size. This signal indicates the size of each transfer in the burst.
output                          soc_ddr_inst1_ARVALID_0,         //Address valid. This signal indicates that the channel is signaling valid address and control information.
output                          soc_ddr_inst1_ARLOCK_0,          //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
output                          soc_ddr_inst1_ARAPCMD_0,         //Read auto-precharge.
output                          soc_ddr_inst1_ARQOS_0,           //QoS indentifier for read transaction.

//DDR AXI 0 Wrtie Address Channel
output  [32:0]                  soc_ddr_inst1_AWADDR_0,   //Write address. It gives the address of the first transfer in a burst transaction.
output  [1:0]                   soc_ddr_inst1_AWBURST_0,   //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
output  [5:0]                   soc_ddr_inst1_AWID_0,      //Address ID. This signal identifies the group of address signals.
output  [7:0]                   soc_ddr_inst1_AWLEN_0,     //Burst length. This signal indicates the number of transfers in a burst.
input                           soc_ddr_inst1_AWREADY_0,         //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
output  [2:0]                   soc_ddr_inst1_AWSIZE_0,    //Burst size. This signal indicates the size of each transfer in the burst.
output                          soc_ddr_inst1_AWVALID_0,         //Address valid. This signal indicates that the channel is signaling valid address and control information.
output                          soc_ddr_inst1_AWLOCK_0,          //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
output                          soc_ddr_inst1_AWAPCMD_0,         //Write auto-precharge.
output                          soc_ddr_inst1_AWQOS_0,           //QoS indentifier for write transaction.
output  [3:0]                   soc_ddr_inst1_AWCACHE_0,   //Memory type. This signal indicates how transactions are required to progress through a system.
output                          soc_ddr_inst1_AWALLSTRB_0,       //Write all strobes asserted.
output                          soc_ddr_inst1_AWCOBUF_0,         //Write coherent bufferable selection.

//DDR AXI 0 Wrtie Response Channel
input   [5:0]                   soc_ddr_inst1_BID_0,        //Response ID tag. This signal is the ID tag of the write response.
output                          soc_ddr_inst1_BREADY_0,          //Response ready. This signal indicates that the master can accept a write response.
input   [1:0]                   soc_ddr_inst1_BRESP_0,      //Read response. This signal indicates the status of the read transfer.
input                           soc_ddr_inst1_BVALID_0,          //Write response valid. This signal indicates that the channel is signaling a valid write response.

//DDR AXI 0 Read Data Channel
input   [AXI_0_DATA_WIDTH-1:0]  soc_ddr_inst1_RDATA_0,    //Read data.
input   [5:0]                   soc_ddr_inst1_RID_0,                       //Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
input                           soc_ddr_inst1_RLAST_0,                           //Read last. This signal indicates the last transfer in a read burst.
output                          soc_ddr_inst1_RREADY_0,                          //Read ready. This signal indicates that the master can accept the read data and response information.
input   [1:0]                   soc_ddr_inst1_RRESP_0,                     //Read response. This signal indicates the status of the read transfer.
input                           soc_ddr_inst1_RVALID_0,                          //Read valid. This signal indicates that the channel is signaling the required read data.

//DDR AXI 0 Write Data Channel Signals

output  [AXI_0_DATA_WIDTH-1:0]  soc_ddr_inst1_WDATA_0,   //Write data. AXI4 port 0 is 256, port 1 is 128.
output                          soc_ddr_inst1_WLAST_0,                           //Write last. This signal indicates the last transfer in a write burst.
input                           soc_ddr_inst1_WREADY_0,                          //Write ready. This signal indicates that the slave can accept the write data.
output  [AXI_0_DATA_WIDTH/8-1:0]soc_ddr_inst1_WSTRB_0,  //Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
output                          soc_ddr_inst1_WVALID_0                        //Write valid. This signal indicates that valid write data and strobes are available.
   


);


localparam PERI_FREQ        = 250;

localparam  FRAME_WIDTH     = 1080;
localparam  FRAME_HEIGHT    = 1080;

localparam  VIDEO_MAX_HRES  = 11'd1920;
localparam  VIDEO_HSP       = 8'd44;
localparam  VIDEO_HBP       = 8'd148;
localparam  VIDEO_HFP       = 8'd88;

localparam  VIDEO_MAX_VRES  = 11'd1080;
localparam  VIDEO_VSP       = 6'd5;
localparam  VIDEO_VBP       = 6'd36;
localparam  VIDEO_VFP       = 6'd4;

// CSI Controller

// CSI Controller
localparam CSI_RX_PIXEL_DATAWIDTH     = CAM_PIXEL_RX_MEM_DATAWIDTH;
localparam CSI_RX_PIXEL_PER_CLK       = 4;
localparam CSI_RX_TOTAL_DATAWIDTH     = CSI_RX_PIXEL_DATAWIDTH * CSI_RX_PIXEL_PER_CLK;
localparam CSI_RX_NUM_DATA_LANE       = 2;
localparam CSI_RX_DATA_WIDTH_LANE     = 16;
localparam CAM_PIXEL_RX_DATAWIDTH     = 10;   //RAW10, RAW12
localparam CAM_PIXEL_RX_MEM_DATAWIDTH = 8;


//APB0
wire [19:0] io_apbSlave_0_PADDR;
wire		io_apbSlave_0_PSEL;
wire		io_apbSlave_0_PENABLE;
wire		io_apbSlave_0_PREADY;
wire		io_apbSlave_0_PWRITE;
wire [31:0] io_apbSlave_0_PWDATA;
wire [31:0] io_apbSlave_0_PRDATA;
wire		io_apbSlave_0_PSLVERROR;

//APB1
wire [19:0] io_apbSlave_1_PADDR;
wire		io_apbSlave_1_PSEL;
wire		io_apbSlave_1_PENABLE;
wire		io_apbSlave_1_PREADY;
wire		io_apbSlave_1_PWRITE;
wire [31:0] io_apbSlave_1_PWDATA;
wire [31:0] io_apbSlave_1_PRDATA;
wire		io_apbSlave_1_PSLVERROR;


wire [3:0]  dma_interrupts;	
wire        w_hdmi_clk;

assign pll_hdmi_RSTN    =   1'b1;
assign pll_osc_RSTN     =   1'b1;
assign w_hdmi_clk = i_hdmi_clk_148p5MHz; // HDMI Clock 148.5 MHz

//////////////////
//Configure AXI0//
//////////////////
assign soc_ddr_inst1_ARSTN_0 = ~io_systemReset;
wire [7:0] dma_arid;
wire [7:0] dma_awid;

assign dma_arid = 8'hE0;
assign dma_awid = 8'hE1;

assign soc_ddr_inst1_ARID_0 = {dma_arid[7:6], dma_arid[3:0]};
assign soc_ddr_inst1_AWID_0 = {dma_awid[7:6], dma_awid[3:0]};

assign soc_ddr_inst1_ARADDR_0[32] = 1'b0;
assign soc_ddr_inst1_AWADDR_0[32] = 1'b0;

assign soc_ddr_inst1_AWAPCMD_0 =   1'b0;
assign soc_ddr_inst1_ARAPCMD_0 =   1'b0;
assign soc_ddr_inst1_AWALLSTRB_0 = 1'b0;
assign soc_ddr_inst1_AWCOBUF_0   = 1'b0;



////////////////
//Reset Related
//////////////////


wire                       io_asyncResetn_evsoc;
wire                       mipi_rstn;
wire                       i_arstn;


assign io_asyncResetn_evsoc   =  ~io_asyncReset & pll_osc_LOCKED & pll_hdmi_LOCKED;

assign i_arstn                = (io_asyncResetn_evsoc & (!mipi_rstn)) ;
assign o_cam_rstn             = i_arstn;
 



// Camera Input Prepocessing
wire                                    cam_dma_wready;
wire                                    cam_dma_wvalid;
wire                                    cam_dma_wlast;
wire [63:0]                             cam_dma_wdata;
wire [63:0]                             w_mapped_raw_data;

// Picam Debug register to APB status registers.
wire                                    debug_cam_dma_fifo_overflow;
wire                                    debug_cam_dma_fifo_underflow;
wire [31:0]                             debug_cam_dma_fifo_rcount;
wire [31:0]                             debug_cam_dma_fifo_wcount;
wire [31:0]                             debug_cam_dma_status;

// Display Hdmi                 
wire [63:0]                             display_dma_rdata;
wire                                    display_dma_rvalid;
wire [7:0]                              display_dma_rkeep;
wire                                    display_dma_rready;


wire [31:0]                             debug_cam_display_fifo_status;
wire                                    debug_display_dma_fifo_underflow;
wire                                    debug_display_dma_fifo_overflow;
wire                                    wRstDebugReg;
wire                                    debug_cam_pixel_remap_fifo_underflow;
wire                                    debug_cam_pixel_remap_fifo_overflow;
wire                                    debug_cam_dma_fifo_underflow;
wire                                    debug_cam_dma_fifo_overflow;
wire  [31:0]                            debug_display_dma_fifo_rcount; 
wire  [31:0]                            debug_display_dma_fifo_wcount;

wire[2:0]	                            w_hdmi_i2c_state;
wire		                            w_hdmi_confdone;

wire                                    hdmi_yuv_vs;
wire                                    hdmi_yuv_hs;

assign                                  hdmi_yuv_vs_OE = !hdmi_yuv_vs;
assign                                  hdmi_yuv_hs_OE = !hdmi_yuv_hs;

assign                                  hdmi_yuv_vs_OUT = 0;
assign                                  hdmi_yuv_hs_OUT = 0;
//Hardware accelerator
wire                                    hw_accel_dma_rready;
wire                                    hw_accel_dma_rvalid;
wire [3:0]                              hw_accel_dma_rkeep;
wire [31:0]                             hw_accel_dma_rdata;
wire                                    hw_accel_dma_wready;
wire                                    hw_accel_dma_wvalid;
wire                                    hw_accel_dma_wlast;
wire [31:0]                             hw_accel_dma_wdata;
wire                                    hw_accel_axi_we;
wire [31:0]                             hw_accel_axi_waddr;
wire [31:0]                             hw_accel_axi_wdata;
wire                                    hw_accel_axi_re;
wire [31:0]                             hw_accel_axi_raddr;
wire [31:0]                             hw_accel_axi_rdata;
wire                                    hw_accel_axi_rvalid;

wire                                    debug_dma_hw_accel_in_fifo_underflow;
wire                                    debug_dma_hw_accel_in_fifo_overflow;
wire                                    debug_dma_hw_accel_out_fifo_underflow;
wire                                    debug_dma_hw_accel_out_fifo_overflow;
wire  [31:0]                            debug_dma_hw_accel_in_fifo_wcount;
wire  [31:0]                            debug_dma_hw_accel_out_fifo_rcount;

wire [15:0]                             rgb_control;
wire                                    trigger_capture_frame;
wire                                    continuous_capture_frame;
wire                                    rgb_gray;
wire                                    cam_dma_init_done;
wire [31:0]                             frames_per_second;
wire [31:0]                             set_offset_display_rgb;
wire                                    hw_accel_dma_init_done;

wire                                    w_rx_out_de;
wire                                    w_rx_out_vs;
wire                                    w_rx_out_hs;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0]   w_rx_out_data_00;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0]   w_rx_out_data_01;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0]   w_rx_out_data_10;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0]   w_rx_out_data_11;
wire [5:0]                              rx_out_dt;

////////////////////////////////////////////////////////////////
// MIPI RX - Camera
wire  [7:0]                             w_cam_d0_HS_IN;
wire  [7:0]                             w_cam_d1_HS_IN;
reg                                     w_cam_confdone;
wire                                    w_cam_ck_HS_ENA_0;
wire                                    w_cam_ck_HS_TERM_0;
wire  [1:0]                             w_cam_d_HS_ENA_0;

wire  [5:0]                             w_mipi_rx_dt;
wire                                    w_mipi_rx_vs;
wire                                    w_mipi_rx_hs;
wire                                    w_mipi_rx_de;
wire  [63:0]                            w_mipi_rx_data;

reg   [10:0]                            r_rx_x_mipi;
reg   [10:0]                            r_rx_y_mipi;
reg                                     r_rx_hs;
reg                                     r_rx_vs;  

(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_P_IN_0_1P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_N_IN_0_1P;
(* async_reg = "true" *)reg   [15:0]   r_mipi_rx_data_HS_IN_0_1P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_P_IN_0_2P;
(* async_reg = "true" *)reg   [1:0]    r_mipi_rx_data_LP_N_IN_0_2P;
(* async_reg = "true" *)reg   [15:0]   r_mipi_rx_data_HS_IN_0_2P;

////////////////////////////////////////////////////////////////
// MIPI CSI RX Channel - Camera

always@(negedge i_arstn or posedge cam_ck_CLKOUT)
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
      r_mipi_rx_data_LP_P_IN_0_1P   <= {cam_d1_LP_P_IN, cam_d0_LP_P_IN}; 
      r_mipi_rx_data_LP_N_IN_0_1P   <= {cam_d1_LP_N_IN, cam_d0_LP_N_IN};
      r_mipi_rx_data_HS_IN_0_1P     <= {w_cam_d1_HS_IN[7:0], w_cam_d0_HS_IN[7:0]};
               
      r_mipi_rx_data_LP_P_IN_0_2P   <= r_mipi_rx_data_LP_P_IN_0_1P;
      r_mipi_rx_data_LP_N_IN_0_2P   <= r_mipi_rx_data_LP_N_IN_0_1P;
      r_mipi_rx_data_HS_IN_0_2P     <= r_mipi_rx_data_HS_IN_0_1P;
   end
end

assign   w_cam_d0_HS_IN    = {cam_d0_HS_IN_3, cam_d0_HS_IN_2, cam_d0_HS_IN_1, cam_d0_HS_IN};
assign   w_cam_d1_HS_IN    = {cam_d1_HS_IN_3, cam_d1_HS_IN_2, cam_d1_HS_IN_1, cam_d1_HS_IN};

assign   cam_ck_HS_TERM  = w_cam_ck_HS_ENA_0;
assign   cam_ck_HS_ENA   = w_cam_ck_HS_ENA_0;
assign   cam_d0_HS_TERM  = w_cam_d_HS_ENA_0[0];
assign   cam_d1_HS_TERM  = w_cam_d_HS_ENA_0[1];
assign   cam_d0_HS_ENA   = w_cam_d_HS_ENA_0[0];
assign   cam_d1_HS_ENA   = w_cam_d_HS_ENA_0[1];
assign   cam_d0_RST      = ~i_arstn;
assign   cam_d1_RST      = ~i_arstn;             



csi2_rx_cam #(
) u_csi2_rx_cam (
   .reset_n             (i_arstn),
   .clk                 (i_pixel_clk),
   .reset_byte_HS_n     (i_arstn),
   .clk_byte_HS         (cam_ck_CLKOUT),
   .reset_pixel_n       (i_arstn),
   .clk_pixel           (i_pixel_clk),
   
   .Rx_LP_CLK_P         (cam_ck_LP_P_IN),
   .Rx_LP_CLK_N         (cam_ck_LP_N_IN),
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
   .fifo_rd_enable      ({cam_d1_FIFO_RD,    cam_d0_FIFO_RD}),
   .fifo_rd_empty       ({cam_d1_FIFO_EMPTY, cam_d0_FIFO_EMPTY}),
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
   
   .hsync_vc0           (w_rx_out_hs),
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
   .vsync_vc0           (w_rx_out_vs),
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
   .datatype            (rx_out_dt),
   .pixel_per_clk       (),
   .pixel_data          (w_mapped_raw_data),
   .pixel_data_valid    (w_rx_out_de),
   .irq                 ()
);



cam_picam # (
    .MIPI_FRAME_WIDTH                       (MIPI_FRAME_WIDTH),             //Input frame resolution from MIPI
    .MIPI_FRAME_HEIGHT                      (MIPI_FRAME_HEIGHT),            //Input frame resolution from MIPI
    .FRAME_WIDTH                            (FRAME_WIDTH),                  //Output frame resolution to external memory
    .FRAME_HEIGHT                           (FRAME_HEIGHT),                 //Output frame resolution to external memory
    .DMA_TRANSFER_LENGTH                    ((FRAME_WIDTH*FRAME_HEIGHT)/2), //2PPC
    .MIPI_PCLK_CLK_RATE                     (32'd100_000_000)               // as mipi_pclk is 100MHz
) u_cam (
    .mipi_pclk                              (i_pixel_clk),
    .rst_n                                  (i_arstn),
    .mipi_cam_data                          (w_mapped_raw_data),
    .mipi_cam_valid                         (w_rx_out_de),
    .mipi_cam_vs                            (w_rx_out_vs),
    .mipi_cam_hs                            (w_rx_out_hs),
    .mipi_cam_type                          (rx_out_dt),

    .cam_dma_wready                         (cam_dma_wready),
    .cam_dma_wvalid                         (cam_dma_wvalid),
    .cam_dma_wlast                          (cam_dma_wlast),
    .cam_dma_wdata                          (cam_dma_wdata),

    .rgb_control                            (rgb_control),
    .trigger_capture_frame                  (trigger_capture_frame),
    .continuous_capture_frame               (continuous_capture_frame),
    .rgb_gray                               (rgb_gray),
    .cam_dma_init_done                      (cam_dma_init_done),
    .frames_per_second                      (frames_per_second),
    .debug_cam_pixel_remap_fifo_overflow    (debug_cam_pixel_remap_fifo_overflow),
    .debug_cam_pixel_remap_fifo_underflow   (debug_cam_pixel_remap_fifo_underflow),
    .debug_cam_dma_fifo_overflow            (debug_cam_dma_fifo_overflow),
    .debug_cam_dma_fifo_underflow           (debug_cam_dma_fifo_underflow),
    .debug_cam_dma_fifo_rcount              (debug_cam_dma_fifo_rcount),
    .debug_cam_dma_fifo_wcount              (debug_cam_dma_fifo_wcount),
    .debug_cam_dma_status                   (debug_cam_dma_status)
);

/////////////
// Camera I2C
/////////////


/* I2C initialization for ADV7511 */
display_hdmi_adv7511_config #(
    .INITIAL_CODE   ("source/display/hdmi/display_hdmi_adv7511_reg.mem")
) inst_adv7511_config (
    .i_arst         (~i_arstn),
    .i_sysclk       (i_sys_clk_25mhz),
    .i_pll_locked   (pll_system_locked),
    .o_state        (),
    .o_confdone     (w_hdmi_confdone),
    
    .i_sda          (i_hdmi_sda),
    .o_sda_oe       (o_hdmi_sda_oe),
    .i_scl          (i_hdmi_scl),
    .o_scl_oe       (o_hdmi_scl_oe),
    .o_rstn         ()
);


// Diplay post process from DMA to HDMI Port
display_hdmi_yuv #(
    .FRAME_WIDTH     (FRAME_WIDTH),
    .FRAME_HEIGHT    (FRAME_HEIGHT),

    .VIDEO_MAX_HRES  (VIDEO_MAX_HRES),
    .VIDEO_HSP       (VIDEO_HSP),
    .VIDEO_HBP       (VIDEO_HBP),
    .VIDEO_HFP       (VIDEO_HFP),

    .VIDEO_MAX_VRES  (VIDEO_MAX_VRES),
    .VIDEO_VSP       (VIDEO_VSP),
    .VIDEO_VBP       (VIDEO_VBP),
    .VIDEO_VFP       (VIDEO_VFP)
    
) inst_display_hdmi_yuv(
    .iHdmiClk                           (w_hdmi_clk),
    .iRst_n                             (i_arstn),
    
    // control offset display to red or green 
    .set_offset_display_rgb             (set_offset_display_rgb),
    
    //DMA RGB Input
    .ivDisplayDmaRdData                 (display_dma_rdata),
    .iDisplayDmaRdValid                 (display_dma_rvalid),
    .iv7DisplayDmaRdKeep                (display_dma_rkeep),
    .oDisplayDmaRdReady                 (display_dma_rready),
    
    // Status.
    .iRstDebugReg                       (1'b0),
    .oDebugDisplayDmaFifoUnderflow      (debug_display_dma_fifo_underflow),
    .oDebugDisplayDmaFifoOverflow       (debug_display_dma_fifo_overflow),
    .ov32DebugDisplayDmaFifoRCount      (debug_display_dma_fifo_rcount), 
    .ov32DebugDisplayDmaFifoWCount      (debug_display_dma_fifo_wcount),

    // Output to HDMI
    .oHdmiYuvVs                         (hdmi_yuv_vs),
    .oHdmiYuvHs                         (hdmi_yuv_hs),
    .oHdmiYuvDe                         (hdmi_yuv_de),
    .ov16HdmiYuvData                    (hdmi_yuv_data)
);






dma u_dma(

    .clk                (io_memoryClk),
    .reset              (io_systemReset),
    
    .ctrl_clk           (io_peripheralClk),
    .ctrl_reset         (io_peripheralReset),

    //APB Slave
    .ctrl_PADDR         (io_apbSlave_0_PADDR),
    .ctrl_PSEL          (io_apbSlave_0_PSEL),
    .ctrl_PENABLE       (io_apbSlave_0_PENABLE),
    .ctrl_PREADY        (io_apbSlave_0_PREADY),
    .ctrl_PWRITE        (io_apbSlave_0_PWRITE),
    .ctrl_PWDATA        (io_apbSlave_0_PWDATA),
    .ctrl_PRDATA        (io_apbSlave_0_PRDATA),
    .ctrl_PSLVERROR     (io_apbSlave_0_PSLVERROR),
    .ctrl_interrupts    (dma_interrupts),

    //DMA AXI memory Interface 
    .read_arvalid       (soc_ddr_inst1_ARVALID_0),
    .read_araddr        (soc_ddr_inst1_ARADDR_0[31:0]),
    .read_arready       (soc_ddr_inst1_ARREADY_0),
    .read_arregion      (),
    .read_arlen         (soc_ddr_inst1_ARLEN_0),
    .read_arsize        (soc_ddr_inst1_ARSIZE_0),
    .read_arburst       (soc_ddr_inst1_ARBURST_0),
    .read_arlock        (soc_ddr_inst1_ARLOCK_0),
    .read_arcache       ( ),
    .read_arqos         (soc_ddr_inst1_ARQOS_0),
    .read_arprot        ( ),
    
    .read_rready        (soc_ddr_inst1_RREADY_0),
    .read_rvalid        (soc_ddr_inst1_RVALID_0),
    .read_rdata         (soc_ddr_inst1_RDATA_0),
    .read_rlast         (soc_ddr_inst1_RLAST_0),
    .read_rresp         (soc_ddr_inst1_RRESP_0),
    
    .write_awvalid      (soc_ddr_inst1_AWVALID_0),
    .write_awready      (soc_ddr_inst1_AWREADY_0),
    .write_awaddr       (soc_ddr_inst1_AWADDR_0[31:0]),
    .write_awregion     (),
    .write_awlen        (soc_ddr_inst1_AWLEN_0),
    .write_awsize       (soc_ddr_inst1_AWSIZE_0),
    .write_awburst      (soc_ddr_inst1_AWBURST_0),
    .write_awlock       (soc_ddr_inst1_AWLOCK_0),
    .write_awcache      (soc_ddr_inst1_AWCACHE_0),
    .write_awqos        (soc_ddr_inst1_AWQOS_0),
    .write_awprot       (),
    
    .write_wvalid       (soc_ddr_inst1_WVALID_0),
    .write_wready       (soc_ddr_inst1_WREADY_0),
    .write_wdata        (soc_ddr_inst1_WDATA_0),
    .write_wstrb        (soc_ddr_inst1_WSTRB_0),
    .write_wlast        (soc_ddr_inst1_WLAST_0),
    
    .write_bvalid       (soc_ddr_inst1_BVALID_0),
    .write_bready       (soc_ddr_inst1_BREADY_0),
    .write_bresp        (soc_ddr_inst1_BRESP_0),

	
    //64bits Camera Video Stream In
    .dat0_i_clk         (i_pixel_clk),
    .dat0_i_reset       (~i_arstn),
    
    .dat0_i_tvalid      (cam_dma_wvalid),
    .dat0_i_tready      (cam_dma_wready),
    .dat0_i_tdata       (cam_dma_wdata),
    .dat0_i_tkeep       ({8{cam_dma_wvalid}}),
    .dat0_i_tdest       (4'd0),
    .dat0_i_tlast       (cam_dma_wlast),
	
     //64-bit dma channel (MM2S - from external memory)
    .dat1_o_clk         (w_hdmi_clk),
    .dat1_o_reset       (~i_arstn),
    .dat1_o_tvalid      (display_dma_rvalid),
    .dat1_o_tready      (display_dma_rready),
    .dat1_o_tdata       (display_dma_rdata),
    .dat1_o_tkeep       (display_dma_rkeep),
    .dat1_o_tdest       ( ),
    .dat1_o_tlast       ( ),
    


   //32-bit dma channel (S2MM - to DDR)
   .dat2_i_clk          (i_soc_clk),
   .dat2_i_reset        (io_systemReset),
   .dat2_i_tvalid       (hw_accel_dma_wvalid),
   .dat2_i_tready       (hw_accel_dma_wready),
   .dat2_i_tdata        (hw_accel_dma_wdata),
   .dat2_i_tkeep        ({4{hw_accel_dma_wvalid}}),
   .dat2_i_tdest        (4'd0),
   .dat2_i_tlast        (hw_accel_dma_wlast),
   
   //32-bit dma channel (MM2S - from DDR)
   .dat3_o_clk          (i_soc_clk),
   .dat3_o_reset        (io_systemReset),
   .dat3_o_tvalid       (hw_accel_dma_rvalid),
   .dat3_o_tready       (hw_accel_dma_rready),
   .dat3_o_tdata        (hw_accel_dma_rdata),
   .dat3_o_tkeep        (hw_accel_dma_rkeep),
   .dat3_o_tdest        (),
   .dat3_o_tlast        ()
   
);

// For control and status register
common_apb3 #(
   .ADDR_WIDTH                              (16),
   .DATA_WIDTH                              (32),
   .NUM_REG                                 (7)
) u_apb3_cam_display (
    .clk                                    (io_peripheralClk),
    .resetn                                 (~io_peripheralReset),
    
    // Output Control
    .mipi_rstn                              (mipi_rstn),
    .rgb_control                            (rgb_control),
    .trigger_capture_frame                  (trigger_capture_frame),
    .continuous_capture_frame               (continuous_capture_frame),
    .rgb_gray                               (rgb_gray),
    .cam_dma_init_done                      (cam_dma_init_done),
    .hw_accel_dma_init_done                 (hw_accel_dma_init_done),
    .frames_per_second                      (frames_per_second),
    .set_offset_display_rgb                 (set_offset_display_rgb),

    // Input Info Data
    .debug_fifo_status                      (debug_cam_display_fifo_status),
    .debug_cam_dma_fifo_rcount              (debug_cam_dma_fifo_rcount),
    .debug_cam_dma_fifo_wcount              (debug_cam_dma_fifo_wcount),
    .debug_display_dma_fifo_rcount          (debug_display_dma_fifo_rcount),
    .debug_display_dma_fifo_wcount          (debug_display_dma_fifo_wcount),
    .debug_dma_hw_accel_in_fifo_wcount      (debug_dma_hw_accel_in_fifo_wcount),
    .debug_dma_hw_accel_out_fifo_rcount     (debug_dma_hw_accel_out_fifo_rcount),
    .debug_cam_dma_status                   (debug_cam_dma_status),

    // Apb 3 interface
    .PADDR                                  (io_apbSlave_1_PADDR),
    .PSEL                                   (io_apbSlave_1_PSEL),
    .PENABLE                                (io_apbSlave_1_PENABLE),
    .PREADY                                 (io_apbSlave_1_PREADY),
    .PWRITE                                 (io_apbSlave_1_PWRITE),
    .PWDATA                                 (io_apbSlave_1_PWDATA),
    .PRDATA                                 (io_apbSlave_1_PRDATA),
    .PSLVERROR                              (io_apbSlave_1_PSLVERROR)
);

assign debug_cam_display_fifo_status= {22'd0,  debug_dma_hw_accel_out_fifo_overflow,debug_dma_hw_accel_out_fifo_underflow,
                                            debug_dma_hw_accel_in_fifo_overflow,debug_dma_hw_accel_in_fifo_underflow,
                                            debug_cam_pixel_remap_fifo_underflow, debug_cam_pixel_remap_fifo_overflow, 
                                            debug_cam_dma_fifo_underflow, debug_cam_dma_fifo_overflow, 
                                            debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow};
											   



wire [18:0]     userInterrupt;
reg             lastUserInterruptFired;
reg  [31:0]     sysClk_cnt;
reg  [31:0]     periClk_cnt;

/*                                                                                  */
/* Check aliveness of system and peripheral reset                                   */
/*                                                                                  */
always@(posedge io_peripheralClk or posedge io_peripheralReset)
begin  
    if(io_peripheralReset)
    begin
        periClk_cnt <= 'd0;
        periClk_reset_ok <= 1'b0;        
    end
    else
    begin
        if(periClk_cnt == (PERI_FREQ*1000000)-1)
        begin
            periClk_cnt <= 'd0;
            periClk_reset_ok <= ~periClk_reset_ok;            
        end
        else
        begin
            periClk_cnt <= periClk_cnt + 1'b1;
            periClk_reset_ok <= periClk_reset_ok;                        
        end
    end
end

always@(posedge i_sys_clk_25mhz or posedge io_systemReset)
begin  
    if(io_systemReset)
    begin
        sysClk_cnt <= 'd0;
        sysClk_reset_ok <= 1'b0;        
    end
    else
    begin
        if(sysClk_cnt == (PERI_FREQ*1000000)-1)
        begin
            sysClk_cnt <= 'd0;
            sysClk_reset_ok <= ~sysClk_reset_ok;            
        end
        else
        begin
            sysClk_cnt <= sysClk_cnt + 1'b1;
            sysClk_reset_ok <= sysClk_reset_ok;                        
        end
    end
end

// AXI for TinyML Accelerator
localparam AXI_TINYML_DATA_WIDTH =  128;

wire [7:0]                          axi_tinyml_awid;
wire [31:0]                         axi_tinyml_awaddr;
wire [7:0]                          axi_tinyml_awlen;
wire [2:0]                          axi_tinyml_awsize;
wire [1:0]                          axi_tinyml_awburst;
wire                                axi_tinyml_awlock;
wire [3:0]                          axi_tinyml_awcache;
wire [2:0]                          axi_tinyml_awprot;
wire [3:0]                          axi_tinyml_awqos;
wire                                axi_tinyml_awvalid;
wire                                axi_tinyml_awready;
wire [AXI_TINYML_DATA_WIDTH-1:0]    axi_tinyml_wdata;
wire [AXI_TINYML_DATA_WIDTH/8-1:0]  axi_tinyml_wstrb;
wire                                axi_tinyml_wlast;
wire                                axi_tinyml_wvalid;
wire                                axi_tinyml_wready;

wire [7:0]                          axi_tinyml_bid;
wire [1:0]                          axi_tinyml_bresp;
wire                                axi_tinyml_bvalid;
wire                                axi_tinyml_bready;
wire [7:0]                          axi_tinyml_arid;
wire [31:0]                         axi_tinyml_araddr;
wire [7:0]                          axi_tinyml_arlen;
wire [2:0]                          axi_tinyml_arsize;
wire [1:0]                          axi_tinyml_arburst;
wire                                axi_tinyml_arlock;
wire [3:0]                          axi_tinyml_arcache;
wire [2:0]                          axi_tinyml_arprot;
wire [3:0]                          axi_tinyml_arqos;
wire                                axi_tinyml_arvalid;
wire                                axi_tinyml_arready;
wire [7:0]                          axi_tinyml_rid;
wire [AXI_TINYML_DATA_WIDTH-1:0]    axi_tinyml_rdata;
wire [1:0]                          axi_tinyml_rresp;
wire                                axi_tinyml_rlast;
wire                                axi_tinyml_rvalid;
wire                                axi_tinyml_rready;
wire                                cpu0_customInstruction_cmd_int;

 
//////////////////////////
//AXI MASTER <-> TINYML/// 
//////////////////////////

assign io_ddrMasters_0_aw_valid          =  (axi_tinyml_awvalid);   
assign io_ddrMasters_0_aw_payload_addr   =  (axi_tinyml_awaddr);   
assign io_ddrMasters_0_aw_payload_id     =  (4'd0);                 
assign io_ddrMasters_0_aw_payload_region = (4'h0);
assign io_ddrMasters_0_aw_payload_len    = (axi_tinyml_awlen);     
assign io_ddrMasters_0_aw_payload_size   = (axi_tinyml_awsize);    
assign io_ddrMasters_0_aw_payload_burst  = (axi_tinyml_awburst);   
assign io_ddrMasters_0_aw_payload_lock   = (axi_tinyml_awlock);    
assign io_ddrMasters_0_aw_payload_cache  = (axi_tinyml_awcache);  
assign io_ddrMasters_0_aw_payload_qos    = (4'h0);
assign io_ddrMasters_0_aw_payload_prot   = (axi_tinyml_awprot);    
assign io_ddrMasters_0_aw_payload_allStrb= (1'b0);
assign io_ddrMasters_0_w_valid           = (axi_tinyml_wvalid);   
assign io_ddrMasters_0_w_payload_data    = (axi_tinyml_wdata);     
assign io_ddrMasters_0_w_payload_strb    = (axi_tinyml_wstrb);    
assign io_ddrMasters_0_w_payload_last    = (axi_tinyml_wlast);     
assign io_ddrMasters_0_b_ready           = (axi_tinyml_bready);    
assign io_ddrMasters_0_ar_valid          = (axi_tinyml_arvalid);  
assign io_ddrMasters_0_ar_payload_addr   = (axi_tinyml_araddr);   
assign io_ddrMasters_0_ar_payload_id     = (4'd0);                 
assign io_ddrMasters_0_ar_payload_region = (4'h0);
assign io_ddrMasters_0_ar_payload_len    = (axi_tinyml_arlen);    
assign io_ddrMasters_0_ar_payload_size   = (axi_tinyml_arsize);    
assign io_ddrMasters_0_ar_payload_burst  = (axi_tinyml_arburst);   
assign io_ddrMasters_0_ar_payload_lock   = (axi_tinyml_arlock);    
assign io_ddrMasters_0_ar_payload_cache  = (axi_tinyml_arcache);   
assign io_ddrMasters_0_ar_payload_qos    = (4'h0);
assign io_ddrMasters_0_ar_payload_prot   = (axi_tinyml_arprot);   
assign io_ddrMasters_0_r_ready           = (axi_tinyml_rready);    
                                                                                



//////////////////
//HW ACCELERATOR 
/////////////////
//For yolo person detection model
//Scale from FRAME_WIDTH x FRAME_HEIGHT to 96x96 resolution

hw_accel_wrapper #(
    .RGB2GRAYSCALE       (RGB2GRAYSCALE),
    .OUT_FRAME_WIDTH     (OUT_FRAME_WIDTH),
    .OUT_FRAME_HEIGHT    (OUT_FRAME_HEIGHT),
    .FRAME_WIDTH         (FRAME_WIDTH),
    .FRAME_HEIGHT        (FRAME_HEIGHT),
    .DMA_TRANSFER_LENGTH ((192*192*3)/4) //S2MM DMA transfer for mediapipe face landmark demo
) u_hw_accel_wrapper (
    .clk                                         (i_soc_clk),
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


assign userInterruptD = cpu0_customInstruction_cmd_int;
assign userInterruptE = |dma_interrupts;


/////////////////////////////////////
// TinyML Acclerator Custom instruction
///////////////////////////////////////
tinyml_top  #(
    .AXI_DW          (AXI_TINYML_DATA_WIDTH)
) u_tinyml_top (

   .clk              (io_cfuClk),
   .reset            (io_cfuReset),
   
   .cmd_valid        (cpu0_customInstruction_cmd_valid),
   .cmd_ready        (cpu0_customInstruction_cmd_ready),
   .cmd_function_id  (cpu0_customInstruction_function_id),
   .cmd_inputs_0     (cpu0_customInstruction_inputs_0),
   .cmd_inputs_1     (cpu0_customInstruction_inputs_1),
   .cmd_int          (cpu0_customInstruction_cmd_int),
   .rsp_valid        (cpu0_customInstruction_rsp_valid),
   .rsp_ready        (cpu0_customInstruction_rsp_ready),
   .rsp_outputs_0    (cpu0_customInstruction_outputs_0),

   .m_axi_clk        (io_ddrMasters_0_clk),
   .m_axi_rstn       (!io_ddrMasters_0_reset),
   .m_axi_awvalid    (axi_tinyml_awvalid),
   .m_axi_awaddr     (axi_tinyml_awaddr),
   .m_axi_awlen      (axi_tinyml_awlen),
   .m_axi_awsize     (axi_tinyml_awsize),
   .m_axi_awburst    (axi_tinyml_awburst),
   .m_axi_awprot     (axi_tinyml_awprot),
   .m_axi_awlock     (axi_tinyml_awlock),
   .m_axi_awcache    (axi_tinyml_awcache),
   .m_axi_awready    (io_ddrMasters_0_aw_ready),
   .m_axi_wdata      (axi_tinyml_wdata),
   .m_axi_wstrb      (axi_tinyml_wstrb),
   .m_axi_wlast      (axi_tinyml_wlast),
   .m_axi_wvalid     (axi_tinyml_wvalid),
   .m_axi_wready     (io_ddrMasters_0_w_ready), 
   .m_axi_bresp      (io_ddrMasters_0_b_payload_resp), 
   .m_axi_bvalid     (io_ddrMasters_0_b_valid), 
   .m_axi_bready     (axi_tinyml_bready),
   .m_axi_arvalid    (axi_tinyml_arvalid),
   .m_axi_araddr     (axi_tinyml_araddr),
   .m_axi_arlen      (axi_tinyml_arlen),
   .m_axi_arsize     (axi_tinyml_arsize),
   .m_axi_arburst    (axi_tinyml_arburst),
   .m_axi_arprot     (axi_tinyml_arprot),
   .m_axi_arlock     (axi_tinyml_arlock),
   .m_axi_arcache    (axi_tinyml_arcache),
   .m_axi_arready    (io_ddrMasters_0_ar_ready), 
   .m_axi_rvalid     (io_ddrMasters_0_r_valid), 
   .m_axi_rdata      (io_ddrMasters_0_r_payload_data), 
   .m_axi_rlast      (io_ddrMasters_0_r_payload_last),
   .m_axi_rresp      (io_ddrMasters_0_r_payload_resp), 
   .m_axi_rready     (axi_tinyml_rready)
);



////////////////////
// SLB CONNECTION //
////////////////////
EfxSapphireHpSoc_slb u_top_peripherals(

.system_i2c_0_io_sda_writeEnable(o_cam_sda_oe),
.system_i2c_0_io_sda_write(o_cam_sda),
.system_i2c_0_io_sda_read(i_cam_sda),
.system_i2c_0_io_scl_writeEnable(o_cam_scl_oe),
.system_i2c_0_io_scl_write(o_cam_scl),
.system_i2c_0_io_scl_read(i_cam_scl),
.system_spi_0_io_sclk_write(system_spi_0_io_sclk_write),
.system_spi_0_io_data_0_writeEnable(system_spi_0_io_data_0_writeEnable),
.system_spi_0_io_data_0_read(system_spi_0_io_data_0_read),
.system_spi_0_io_data_0_write(system_spi_0_io_data_0_write),
.system_spi_0_io_data_1_writeEnable(system_spi_0_io_data_1_writeEnable),
.system_spi_0_io_data_1_read(system_spi_0_io_data_1_read),
.system_spi_0_io_data_1_write(system_spi_0_io_data_1_write),
.system_spi_0_io_data_2_writeEnable(system_spi_0_io_data_2_writeEnable),
.system_spi_0_io_data_2_read(system_spi_0_io_data_2_read),
.system_spi_0_io_data_2_write(system_spi_0_io_data_2_write),
.system_spi_0_io_data_3_writeEnable(system_spi_0_io_data_3_writeEnable),
.system_spi_0_io_data_3_read(system_spi_0_io_data_3_read),
.system_spi_0_io_data_3_write(system_spi_0_io_data_3_write),
.system_spi_0_io_ss(system_spi_0_io_ss),
.io_apbSlave_0_PADDR(io_apbSlave_0_PADDR),
.io_apbSlave_0_PSEL(io_apbSlave_0_PSEL),
.io_apbSlave_0_PENABLE(io_apbSlave_0_PENABLE),
.io_apbSlave_0_PREADY(io_apbSlave_0_PREADY),
.io_apbSlave_0_PWRITE(io_apbSlave_0_PWRITE),
.io_apbSlave_0_PWDATA(io_apbSlave_0_PWDATA),
.io_apbSlave_0_PRDATA(io_apbSlave_0_PRDATA),
.io_apbSlave_0_PSLVERROR(io_apbSlave_0_PSLVERROR),
.io_apbSlave_1_PADDR(io_apbSlave_1_PADDR),
.io_apbSlave_1_PSEL(io_apbSlave_1_PSEL),
.io_apbSlave_1_PENABLE(io_apbSlave_1_PENABLE),
.io_apbSlave_1_PREADY(io_apbSlave_1_PREADY),
.io_apbSlave_1_PWRITE(io_apbSlave_1_PWRITE),
.io_apbSlave_1_PWDATA(io_apbSlave_1_PWDATA),
.io_apbSlave_1_PRDATA(io_apbSlave_1_PRDATA),
.io_apbSlave_1_PSLVERROR(io_apbSlave_1_PSLVERROR),
.userInterruptA(userInterruptA),
.userInterruptB(userInterruptB),
.userInterruptC(userInterruptC),
`ifndef SOFT_TAP
.jtagCtrl_tdi(jtagCtrl_tdi),
.jtagCtrl_tdo(jtagCtrl_tdo),
.jtagCtrl_enable(jtagCtrl_enable),
.jtagCtrl_capture(jtagCtrl_capture),
.jtagCtrl_shift(jtagCtrl_shift),
.jtagCtrl_update(jtagCtrl_update),
.jtagCtrl_reset(jtagCtrl_reset),
.ut_jtagCtrl_tdi(ut_jtagCtrl_tdi),
.ut_jtagCtrl_tdo(ut_jtagCtrl_tdo),
.ut_jtagCtrl_enable(ut_jtagCtrl_enable),
.ut_jtagCtrl_capture(ut_jtagCtrl_capture),
.ut_jtagCtrl_shift(ut_jtagCtrl_shift),
.ut_jtagCtrl_update(ut_jtagCtrl_update),
.ut_jtagCtrl_reset(ut_jtagCtrl_reset),
`else
.io_jtag_tdi(io_jtag_tdi),
.io_jtag_tdo(io_jtag_tdo),
.io_jtag_tms(io_jtag_tms),
.pin_io_jtag_tdi(pin_io_jtag_tdi),
.pin_io_jtag_tdo(pin_io_jtag_tdo),
.pin_io_jtag_tms(pin_io_jtag_tms),
`endif
.system_uart_0_io_txd(system_uart_0_io_txd),
.system_uart_0_io_rxd(system_uart_0_io_rxd),
.axiA_awvalid(axiA_awvalid),
.axiA_awready(axiA_awready),
.axiA_awaddr(axiA_awaddr),
.axiA_awlen(axiA_awlen),
.axiA_awsize(axiA_awsize),
.axiA_awcache(axiA_awcache),
.axiA_awprot(axiA_awprot),
.axiA_wvalid(axiA_wvalid),
.axiA_wready(axiA_wready),
.axiA_wdata(axiA_wdata),
.axiA_wstrb(axiA_wstrb),
.axiA_wlast(axiA_wlast),
.axiA_bvalid(axiA_bvalid),
.axiA_bready(axiA_bready),
.axiA_bresp(axiA_bresp),
.axiA_arvalid(axiA_arvalid),
.axiA_arready(axiA_arready),
.axiA_araddr(axiA_araddr),
.axiA_arlen(axiA_arlen),
.axiA_arsize(axiA_arsize),
.axiA_arcache(axiA_arcache),
.axiA_arprot(axiA_arprot),
.axiA_rvalid(axiA_rvalid),
.axiA_rready(axiA_rready),
.axiA_rdata(axiA_rdata),
.axiA_rresp(axiA_rresp),
.axiA_rlast(axiA_rlast),
.axiAInterrupt(axiAInterrupt),
.cfg_done(cfg_done),
.cfg_start(cfg_start),
.cfg_sel(cfg_sel),
.cfg_reset(cfg_reset),
.io_peripheralClk(io_peripheralClk),
.io_peripheralReset(io_peripheralReset),
.io_asyncReset(io_asyncReset),
.io_gpio_sw_n(io_gpio_sw_n), 
.pll_peripheral_locked(pll_peripheral_locked),
.pll_system_locked(pll_system_locked)
);

endmodule
