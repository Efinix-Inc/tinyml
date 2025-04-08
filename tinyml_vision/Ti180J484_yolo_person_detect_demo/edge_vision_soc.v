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

// To enable RiscV soft tap connection (for debugger).
//`define SOFT_TAP 1

module edge_vision_soc #(
    parameter RGB2GRAYSCALE          = "DISABLE",
    parameter OUT_FRAME_WIDTH        = 96,
    parameter OUT_FRAME_HEIGHT       = 96,
    parameter MIPI_FRAME_WIDTH  = 1920, // camera input Width
    parameter MIPI_FRAME_HEIGHT = 1080, // camera input Height

    parameter AXI_0_DATA_WIDTH  = 512,  // AXI Width 0 connected to SOC and TinyML Accelerator
    parameter AXI_1_DATA_WIDTH  = 512   // AXI Width 0 connected to DMA

) (
    //Clock Control
    input                               i_soc_clk,
    input                               i_axi0_mem_clk,
    input                               i_hdmi_clk_148p5MHz,
    input                               i_pixel_clk,
    
    input                               rx_cfgclk,
    
    input                               pll_ddr_LOCKED,
    output                              pll_ddr_RSTN,
    input                               pll_osc2_LOCKED,
    output                              pll_osc2_RSTN,
    input                               pll_osc3_LOCKED,
    output                              pll_osc3_RSTN,
    
    input                               i_sys_clk,
    output                              pll_sys_RSTN,
    input                               pll_sys_LOCKED,
    
    input                               mipi_clk,
    input                               i_sys_clk_25mhz,
    
    //Startup Sequencer Signals
    output                              ddr_inst_CFG_RST,       //Active-high DDR configuration controller reset.
    output                              ddr_inst_CFG_START,     //Start the DDR configuration controller.
    input                               ddr_inst_CFG_DONE,      //Indicates the controller configuration is done
    output                              ddr_inst_CFG_SEL,       //To select whether to use internal DDR configuration controller or user register ports for configuration:
                                                                //0: Use internal configuration controller.
                                                                //1: Use register configuration ports (cfg_rst, cfg_start, cfg_done will be disabled).

    //DDR AXI 0
    output                              ddr_inst_ARST_0,
    //DDR AXI 0 Read Address Channel
    output  [32:0]                      ddr_inst_ARADDR_0,      //Read address. It gives the address of the first transfer in a burst transaction.
    output  [1:0]                       ddr_inst_ARBURST_0,     //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
    output  [5:0]                       ddr_inst_ARID_0,        //Address ID. This signal identifies the group of address signals.
    output  [7:0]                       ddr_inst_ARLEN_0,       //Burst length. This signal indicates the number of transfers in a burst.
    input                               ddr_inst_ARREADY_0,     //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
    output  [2:0]                       ddr_inst_ARSIZE_0,      //Burst size. This signal indicates the size of each transfer in the burst.
    output                              ddr_inst_ARVALID_0,     //Address valid. This signal indicates that the channel is signaling valid address and control information.
    output                              ddr_inst_ARLOCK_0,      //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
    output                              ddr_inst_ARAPCMD_0,     //Read auto-precharge.
    output                              ddr_inst_ARQOS_0,       //QoS indentifier for read transaction.

    //DDR AXI 0 Wrtie Address Channel
    output  [32:0]                      ddr_inst_AWADDR_0,      //Write address. It gives the address of the first transfer in a burst transaction.
    output  [1:0]                       ddr_inst_AWBURST_0,     //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
    output  [5:0]                       ddr_inst_AWID_0,        //Address ID. This signal identifies the group of address signals.
    output  [7:0]                       ddr_inst_AWLEN_0,       //Burst length. This signal indicates the number of transfers in a burst.
    input                               ddr_inst_AWREADY_0,     //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
    output  [2:0]                       ddr_inst_AWSIZE_0,      //Burst size. This signal indicates the size of each transfer in the burst.
    output                              ddr_inst_AWVALID_0,     //Address valid. This signal indicates that the channel is signaling valid address and control information.
    output                              ddr_inst_AWLOCK_0,      //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
    output                              ddr_inst_AWAPCMD_0,     //Write auto-precharge.
    output                              ddr_inst_AWQOS_0,       //QoS indentifier for write transaction.
    output  [3:0]                       ddr_inst_AWCACHE_0,     //Memory type. This signal indicates how transactions are required to progress through a system.
    output                              ddr_inst_AWALLSTRB_0,   //Write all strobes asserted.
    output                              ddr_inst_AWCOBUF_0,     //Write coherent bufferable selection.
    
    //DDR AXI 0 Wrtie Response Channel
    input   [5:0]                       ddr_inst_BID_0,         //Response ID tag. This signal is the ID tag of the write response.
    output                              ddr_inst_BREADY_0,      //Response ready. This signal indicates that the master can accept a write response.
    input   [1:0]                       ddr_inst_BRESP_0,       //Read response. This signal indicates the status of the read transfer.
    input                               ddr_inst_BVALID_0,      //Write response valid. This signal indicates that the channel is signaling a valid write response.
    
    //DDR AXI 0 Read Data Channel
    input   [AXI_0_DATA_WIDTH-1:0]      ddr_inst_RDATA_0,       //Read data.
    input   [5:0]                       ddr_inst_RID_0,         //Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
    input                               ddr_inst_RLAST_0,       //Read last. This signal indicates the last transfer in a read burst.
    output                              ddr_inst_RREADY_0,      //Read ready. This signal indicates that the master can accept the read data and response information.
    input   [1:0]                       ddr_inst_RRESP_0,       //Read response. This signal indicates the status of the read transfer.
    input                               ddr_inst_RVALID_0,      //Read valid. This signal indicates that the channel is signaling the required read data.
    
    //DDR AXI 0 Write Data Channel Signals
    
    output  [AXI_0_DATA_WIDTH-1:0]      ddr_inst_WDATA_0,       //Write data. AXI4 port 0 is 256, port 1 is 128.
    output                              ddr_inst_WLAST_0,       //Write last. This signal indicates the last transfer in a write burst.
    input                               ddr_inst_WREADY_0,      //Write ready. This signal indicates that the slave can accept the write data.
    output  [AXI_0_DATA_WIDTH/8-1:0]    ddr_inst_WSTRB_0,       //Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
    output                              ddr_inst_WVALID_0,      //Write valid. This signal indicates that valid write data and strobes are available.
    
    //DDR AXI 1 Read Address Channel
    output                              ddr_inst_ARST_1,
    output	[32:0]                      ddr_inst_ARADDR_1,      //Read address. It gives the address of the first transfer in a burst transaction.
    output	[1:0]                       ddr_inst_ARBURST_1,     //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
    output	[5:0]                       ddr_inst_ARID_1,        //Address ID. This signal identifies the group of address signals.
    output	[7:0]                       ddr_inst_ARLEN_1,       //Burst length. This signal indicates the number of transfers in a burst.
    input	                            ddr_inst_ARREADY_1,     //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
    output	[2:0]                       ddr_inst_ARSIZE_1,      //Burst size. This signal indicates the size of each transfer in the burst.
    output	                            ddr_inst_ARVALID_1,     //Address valid. This signal indicates that the channel is signaling valid address and control information.
    output	                            ddr_inst_ARLOCK_1,      //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
    output	                            ddr_inst_ARAPCMD_1,     //Read auto-precharge.
    output	                            ddr_inst_ARQOS_1,       //QoS indentifier for read transaction.
    
    //DDR AXI 1 Wrtie Address Channel
    output	[32:0]                      ddr_inst_AWADDR_1,      //Write address. It gives the address of the first transfer in a burst transaction.
    output	[1:0]                       ddr_inst_AWBURST_1,     //Burst type. The burst type and the size determine how the address for each transfer within the burst is calculated.
    output	[5:0]                       ddr_inst_AWID_1,        //Address ID. This signal identifies the group of address signals.
    output	[7:0]                       ddr_inst_AWLEN_1,       //Burst length. This signal indicates the number of transfers in a burst.
    input	                            ddr_inst_AWREADY_1,     //Address ready. This signal indicates that the slave is ready to accept an address and associated control signals.
    output	[2:0]                       ddr_inst_AWSIZE_1,      //Burst size. This signal indicates the size of each transfer in the burst.
    output	                            ddr_inst_AWVALID_1,     //Address valid. This signal indicates that the channel is signaling valid address and control information.
    output	                            ddr_inst_AWLOCK_1,      //Lock type. This signal provides additional information about the atomic characteristics of the transfer.
    output	                            ddr_inst_AWAPCMD_1,     //Write auto-precharge.
    output	                            ddr_inst_AWQOS_1,       //QoS indentifier for write transaction.
    output	[3:0]                       ddr_inst_AWCACHE_1,     //Memory type. This signal indicates how transactions are required to progress through a system.
    output	                            ddr_inst_AWALLSTRB_1,   //Write all strobes asserted.
    output	                            ddr_inst_AWCOBUF_1,     //Write coherent bufferable selection.
    
    //DDR AXI 1 Wrtie Response Channel
    input	[5:0]                       ddr_inst_BID_1,         //Response ID tag. This signal is the ID tag of the write response.
    output	                            ddr_inst_BREADY_1,      //Response ready. This signal indicates that the master can accept a write response.
    input	[1:0]                       ddr_inst_BRESP_1,       //Read response. This signal indicates the status of the read transfer.
    input	                            ddr_inst_BVALID_1,      //Write response valid. This signal indicates that the channel is signaling a valid write response.
    
    //DDR AXI 1 Read Data Channel
    input	[AXI_1_DATA_WIDTH-1:0]      ddr_inst_RDATA_1,       //Read data.
    input	[5:0]                       ddr_inst_RID_1,         //Read ID tag. This signal is the identification tag for the read data group of signals generated by the slave.
    input	                            ddr_inst_RLAST_1,       //Read last. This signal indicates the last transfer in a read burst.
    output	                            ddr_inst_RREADY_1,      //Read ready. This signal indicates that the master can accept the read data and response information.
    input	[1:0]                       ddr_inst_RRESP_1,       //Read response. This signal indicates the status of the read transfer.
    input	                            ddr_inst_RVALID_1,      //Read valid. This signal indicates that the channel is signaling the required read data.
    
    //DDR AXI 1 Write Data Channel Signals
    output	[AXI_1_DATA_WIDTH-1:0]      ddr_inst_WDATA_1,       //Write data. AXI4 port 0 is 256, port 1 is 128.
    output	                            ddr_inst_WLAST_1,       //Write last. This signal indicates the last transfer in a write burst.
    input	                            ddr_inst_WREADY_1,      //Write ready. This signal indicates that the slave can accept the write data.
    output	[AXI_1_DATA_WIDTH/8-1:0]    ddr_inst_WSTRB_1,       //Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus.
    output	                            ddr_inst_WVALID_1,      //Write valid. This signal indicates that valid write data and strobes are available.
    
    //SOC port
    output                              system_spi_0_io_sclk_write,
    output                              system_spi_0_io_data_0_writeEnable,
    input                               system_spi_0_io_data_0_read,
    output                              system_spi_0_io_data_0_write,
    output                              system_spi_0_io_data_1_writeEnable,
    input                               system_spi_0_io_data_1_read,
    output                              system_spi_0_io_data_1_write,
    output                              system_spi_0_io_ss,
    
    output                              system_spi_1_io_sclk_write,
    output                              system_spi_1_io_data_0_writeEnable,
    input                               system_spi_1_io_data_0_read,
    output                              system_spi_1_io_data_0_write,
    output                              system_spi_1_io_data_1_writeEnable,
    input                               system_spi_1_io_data_1_read,
    output                              system_spi_1_io_data_1_write,
    output                              system_spi_1_io_ss,
    
    output                              system_uart_0_io_txd,
    input                               system_uart_0_io_rxd,
    
    //CSI Camera interface
    input                               i_cam_sda,
    output                              o_cam_sda_oe,
    input                               i_cam_scl,
    output                              o_cam_scl_oe,
    output                              o_cam_rstn,

    //CSI RX Interface
    //MIPI DPHY RX0
    input                               mipi_dphy_rx_inst1_WORD_CLKOUT_HS,
    output                              mipi_dphy_rx_inst1_FORCE_RX_MODE,
    output                              mipi_dphy_rx_inst1_RESET_N,
    output                              mipi_dphy_rx_inst1_RST0_N,
    input                               mipi_dphy_rx_inst1_ERR_CONTENTION_LP0,
    input                               mipi_dphy_rx_inst1_ERR_CONTENTION_LP1,
    input                               mipi_dphy_rx_inst1_ERR_CONTROL_LAN0,
    input                               mipi_dphy_rx_inst1_ERR_CONTROL_LAN1,
    input                               mipi_dphy_rx_inst1_ERR_ESC_LAN0,
    input                               mipi_dphy_rx_inst1_ERR_ESC_LAN1,
    input                               mipi_dphy_rx_inst1_ERR_SOT_HS_LAN0,
    input                               mipi_dphy_rx_inst1_ERR_SOT_HS_LAN1,
    input                               mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN0,
    input                               mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN1,
    input                               mipi_dphy_rx_inst1_LP_CLK,
    input                               mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN0,
    input                               mipi_dphy_rx_inst1_RX_ACTIVE_HS_LAN1,
    input                               mipi_dphy_rx_inst1_RX_CLK_ACTIVE_HS,
    input                               mipi_dphy_rx_inst1_ESC_LAN0_CLK,
    input                               mipi_dphy_rx_inst1_ESC_LAN1_CLK,
    input [7:0]                         mipi_dphy_rx_inst1_RX_DATA_ESC,
    input [CSI_RX_DATA_WIDTH_LANE-1:0]  mipi_dphy_rx_inst1_RX_DATA_HS_LAN0,
    input [CSI_RX_DATA_WIDTH_LANE-1:0]  mipi_dphy_rx_inst1_RX_DATA_HS_LAN1,
    input                               mipi_dphy_rx_inst1_RX_LPDT_ESC,
    input                               mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN0,
    input                               mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN1,
    input                               mipi_dphy_rx_inst1_RX_SYNC_HS_LAN0,
    input                               mipi_dphy_rx_inst1_RX_SYNC_HS_LAN1,
    input [3:0]                         mipi_dphy_rx_inst1_RX_TRIGGER_ESC,
    input                               mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_CLK_NOT,
    input                               mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN0,
    input                               mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN1,
    input                               mipi_dphy_rx_inst1_RX_ULPS_CLK_NOT,
    input                               mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN0,
    input                               mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN1,
    input                               mipi_dphy_rx_inst1_RX_VALID_ESC,
    input                               mipi_dphy_rx_inst1_RX_VALID_HS_LAN0,
    input                               mipi_dphy_rx_inst1_RX_VALID_HS_LAN1,
    input                               mipi_dphy_rx_inst1_STOPSTATE_CLK,
    input                               mipi_dphy_rx_inst1_STOPSTATE_LAN0,
    input                               mipi_dphy_rx_inst1_STOPSTATE_LAN1,

    // I2C Configuration for HDMI
    input                               i_hdmi_sda,
    output                              o_hdmi_sda_oe,
    input                               i_hdmi_scl,
    output                              o_hdmi_scl_oe,
    
    // HDMI YUV Output
    output                              hdmi_yuv_vs,
    output                              hdmi_yuv_hs,
    output                              hdmi_yuv_de,
    output  [15:0]                      hdmi_yuv_data,
    
    //LED, SW
    output [5:0]                        o_led,
    input  [1:0]                        i_sw,
    
    // Debug Interface
    // Soft Tap
    input                               io_jtag_tms,
    input                               io_jtag_tdi,
    output                              io_jtag_tdo,
    input                               io_jtag_tck,
    
    // Jtag
    input                               jtag_inst1_TCK,
    input                               jtag_inst1_TDI,
    output                              jtag_inst1_TDO,
    input                               jtag_inst1_SEL,
    input                               jtag_inst1_CAPTURE,
    input                               jtag_inst1_SHIFT,
    input                               jtag_inst1_UPDATE,
    input                               jtag_inst1_RESET
);


///////////////////////
// Variable declaration
///////////////////////

// Resolution Parameter (Vesa Standard)
wire w_hdmi_clk;

localparam  FRAME_WIDTH     = 1080; //1920;
localparam  FRAME_HEIGHT    = 1080;

localparam  VIDEO_MAX_HRES  = 11'd1920;
localparam  VIDEO_HSP       = 8'd44;
localparam  VIDEO_HBP       = 8'd148;
localparam  VIDEO_HFP       = 8'd88;

localparam  VIDEO_MAX_VRES  = 11'd1080;
localparam  VIDEO_VSP       = 6'd5;
localparam  VIDEO_VBP       = 6'd36;
localparam  VIDEO_VFP       = 6'd4;

assign w_hdmi_clk = i_hdmi_clk_148p5MHz; // HDMI Clock 148.5 MHz

// Reset Related
wire io_systemReset;
wire io_memoryReset;
wire w_sysclk_arstn;
wire w_sysclk_arst;
wire io_asyncResetn;
wire i_arstn;
wire mipi_rstn;

// CSI Controller
localparam CSI_RX_PIXEL_DATAWIDTH     = CAM_PIXEL_RX_MEM_DATAWIDTH;
localparam CSI_RX_PIXEL_PER_CLK       = 4;
localparam CSI_RX_TOTAL_DATAWIDTH     = CSI_RX_PIXEL_DATAWIDTH * CSI_RX_PIXEL_PER_CLK;
localparam CSI_RX_NUM_DATA_LANE       = 2;
localparam CSI_RX_DATA_WIDTH_LANE     = 16;
localparam CAM_PIXEL_RX_DATAWIDTH     = 10;   //RAW10, RAW12
localparam CAM_PIXEL_RX_MEM_DATAWIDTH = 8;

wire                                  w_rx_out_de;
wire                                  w_rx_out_vs;
wire                                  w_rx_out_hs;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_00;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_01;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_10;
wire [CAM_PIXEL_RX_MEM_DATAWIDTH-1:0] w_rx_out_data_11;
wire [5:0]                            rx_out_dt;

//ddr4 config
wire [31:0]                           io_ddrA_ar_payload_addr_i;
wire [31:0]                           io_ddrA_aw_payload_addr_i;
wire [7:0]                            io_ddrA_ar_payload_id_i;
wire [7:0]                            io_ddrA_aw_payload_id_i;
wire [7:0]                            io_ddrA_b_payload_id_i;
wire [7:0]                            io_ddrA_r_payload_id_i;
wire                                  ddr_cfg_ok;

// Camera Input Preprocessing
wire                                  cam_dma_wready;
wire                                  cam_dma_wvalid;
wire                                  cam_dma_wlast;
wire [63:0]                           cam_dma_wdata;
wire [63:0]                           w_mapped_raw_data;

// Display Hdmi
wire                                  bbox_dma_tvalid;
wire                                  bbox_dma_tready;
wire                                  bbox_dma_tlast;
wire [63:0]                           bbox_dma_tdata;
wire [63:0]                           display_dma_rdata;
wire                                  display_dma_rvalid;
//wire [7:0]                            display_dma_rkeep;
wire                                  display_dma_rready;
wire [31:0]                           debug_cam_display_fifo_status;
wire                                  debug_display_dma_fifo_underflow;
wire                                  debug_display_dma_fifo_overflow;
wire                                  wRstDebugReg;
wire                                  debug_cam_pixel_remap_fifo_underflow;
wire                                  debug_cam_pixel_remap_fifo_overflow;
wire                                  debug_cam_dma_fifo_underflow;
wire                                  debug_cam_dma_fifo_overflow;
wire  [31:0]                          debug_display_dma_fifo_rcount; 
wire  [31:0]                          debug_display_dma_fifo_wcount;

// Picam Debug register to APB status registers.
wire                                  debug_cam_dma_fifo_overflow;
wire                                  debug_cam_dma_fifo_underflow;
wire [31:0]                           debug_cam_dma_fifo_rcount;
wire [31:0]                           debug_cam_dma_fifo_wcount;
wire [31:0]                           debug_cam_dma_status;

wire [15:0]                           rgb_control;
wire                                  trigger_capture_frame;
wire                                  continuous_capture_frame;
wire                                  rgb_gray;
wire                                  cam_dma_init_done;
wire [31:0]                           frames_per_second;
wire [31:0]                           set_offset_display_rgb;
wire                                  hw_accel_dma_init_done;


// Sapphire Soc

//APB Slave 0  (DMA)
wire    [15:0]                        w_dma_apbSlave_PADDR;
wire    [0:0]                         w_dma_apbSlave_PSEL;
wire                                  w_dma_apbSlave_PENABLE;
wire                                  w_dma_apbSlave_PREADY;
wire                                  w_dma_apbSlave_PWRITE;
wire    [31:0]                        w_dma_apbSlave_PWDATA;
wire    [31:0]                        w_dma_apbSlave_PRDATA;
wire                                  w_dma_apbSlave_PSLVERROR;
wire                                  w_dma_ctrl_interrupt;

//APB Slave 1  (Regsisters Test)
wire    [15:0]                        w_apbSlave_1_PADDR;
wire    [0:0]                         w_apbSlave_1_PSEL;
wire                                  w_apbSlave_1_PENABLE;
wire                                  w_apbSlave_1_PREADY;
wire                                  w_apbSlave_1_PWRITE;
wire    [31:0]                        w_apbSlave_1_PWDATA;
wire    [31:0]                        w_apbSlave_1_PRDATA;
wire                                  w_apbSlave_1_PSLVERROR;

//AXI Slave 0
wire [7:0]                            axi_awid;
wire [31:0]                           axi_awaddr;
wire [7:0]                            axi_awlen;
wire [2:0]                            axi_awsize;
wire [1:0]                            axi_awburst;
wire                                  axi_awlock;
wire [3:0]                            axi_awcache;
wire [2:0]                            axi_awprot;
wire [3:0]                            axi_awqos;
wire [3:0]                            axi_awregion;
wire                                  axi_awvalid;
wire                                  axi_awready;
wire [31:0]                           axi_wdata;
wire [3:0]                            axi_wstrb;
wire                                  axi_wvalid;
wire                                  axi_wlast;
wire                                  axi_wready;
wire [7:0]                            axi_bid;
wire [1:0]                            axi_bresp;
wire                                  axi_bvalid;
wire                                  axi_bready;
wire [7:0]                            axi_arid;
wire [31:0]                           axi_araddr;
wire [7:0]                            axi_arlen;
wire [2:0]                            axi_arsize;
wire [1:0]                            axi_arburst;
wire                                  axi_arlock;
wire [3:0]                            axi_arcache;
wire [2:0]                            axi_arprot;
wire [3:0]                            axi_arqos;
wire [3:0]                            axi_arregion;
wire                                  axi_arvalid;
wire                                  axi_arready;
wire [7:0]                            axi_rid;
wire [31:0]                           axi_rdata;
wire [1:0]                            axi_rresp;
wire                                  axi_rlast;
wire                                  axi_rvalid;
wire                                  axi_rready;
wire                                  axi4Interrupt;

//Hardware accelerator
wire                                  hw_accel_dma_rready;
wire                                  hw_accel_dma_rvalid;
wire [3:0]                            hw_accel_dma_rkeep;
wire [31:0]                           hw_accel_dma_rdata;
wire                                  hw_accel_dma_wready;
wire                                  hw_accel_dma_wvalid;
wire                                  hw_accel_dma_wlast;
wire [31:0]                           hw_accel_dma_wdata;
wire                                  hw_accel_axi_we;
wire [31:0]                           hw_accel_axi_waddr;
wire [31:0]                           hw_accel_axi_wdata;
wire                                  hw_accel_axi_re;
wire [31:0]                           hw_accel_axi_raddr;
wire [31:0]                           hw_accel_axi_rdata;
wire                                  hw_accel_axi_rvalid;

wire                                  debug_dma_hw_accel_in_fifo_underflow;
wire                                  debug_dma_hw_accel_in_fifo_overflow;
wire                                  debug_dma_hw_accel_out_fifo_underflow;
wire                                  debug_dma_hw_accel_out_fifo_overflow;
wire  [31:0]                          debug_dma_hw_accel_in_fifo_wcount;
wire  [31:0]                          debug_dma_hw_accel_out_fifo_rcount;

wire                                  peripheralClk;
wire                                  peripheralReset; 

//Custom instruction
wire                                  cpu_customInstruction_cmd_valid;
wire                                  cpu_customInstruction_cmd_ready;
wire  [9:0]                           cpu_customInstruction_function_id;
wire  [31:0]                          cpu_customInstruction_inputs_0;
wire  [31:0]                          cpu_customInstruction_inputs_1;
wire                                  cpu_customInstruction_rsp_valid;
wire                                  cpu_customInstruction_rsp_ready;
wire  [31:0]                          cpu_customInstruction_outputs_0;
wire                                  cpu_customInstruction_cmd_int;

// AXI for TinyML Accelerator
localparam AXI_TINYML_DATA_WIDTH =  512;

wire [7:0]                            axi_tinyml_awid;
wire [31:0]                           axi_tinyml_awaddr;
wire [7:0]                            axi_tinyml_awlen;
wire [2:0]                            axi_tinyml_awsize;
wire [1:0]                            axi_tinyml_awburst;
wire                                  axi_tinyml_awlock;
wire [3:0]                            axi_tinyml_awcache;
wire [2:0]                            axi_tinyml_awprot;
wire [3:0]                            axi_tinyml_awqos;
wire                                  axi_tinyml_awvalid;
wire                                  axi_tinyml_awready;
wire [AXI_TINYML_DATA_WIDTH-1:0]      axi_tinyml_wdata;
wire [AXI_TINYML_DATA_WIDTH/8-1:0]    axi_tinyml_wstrb;
wire                                  axi_tinyml_wlast;
wire                                  axi_tinyml_wvalid;
wire                                  axi_tinyml_wready;

wire [7:0]                            axi_tinyml_bid;
wire [1:0]                            axi_tinyml_bresp;
wire                                  axi_tinyml_bvalid;
wire                                  axi_tinyml_bready;
wire [7:0]                            axi_tinyml_arid;
wire [31:0]                           axi_tinyml_araddr;
wire [7:0]                            axi_tinyml_arlen;
wire [2:0]                            axi_tinyml_arsize;
wire [1:0]                            axi_tinyml_arburst;
wire                                  axi_tinyml_arlock;
wire [3:0]                            axi_tinyml_arcache;
wire [2:0]                            axi_tinyml_arprot;
wire [3:0]                            axi_tinyml_arqos;
wire                                  axi_tinyml_arvalid;
wire                                  axi_tinyml_arready;
wire [7:0]                            axi_tinyml_rid;
wire [AXI_TINYML_DATA_WIDTH-1:0]      axi_tinyml_rdata;
wire [1:0]                            axi_tinyml_rresp;
wire                                  axi_tinyml_rlast;
wire                                  axi_tinyml_rvalid;
wire                                  axi_tinyml_rready;

// AXI for Soc
localparam AXI_SOC_DATA_WIDTH =  AXI_0_DATA_WIDTH;

wire [7:0]                            axi_soc_awid;
wire [31:0]                           axi_soc_awaddr;
wire [7:0]                            axi_soc_awlen;
wire [2:0]                            axi_soc_awsize;
wire [1:0]                            axi_soc_awburst;
wire                                  axi_soc_awlock;
wire [3:0]                            axi_soc_awcache;
wire [2:0]                            axi_soc_awprot;
wire [3:0]                            axi_soc_awqos;
wire                                  axi_soc_awvalid;
wire                                  axi_soc_awready;
wire [AXI_SOC_DATA_WIDTH-1:0]         axi_soc_wdata;
wire [AXI_SOC_DATA_WIDTH/8-1:0]       axi_soc_wstrb;
wire                                  axi_soc_wlast;
wire                                  axi_soc_wvalid;
wire                                  axi_soc_wready;

wire [7:0]                            axi_soc_bid;
wire [1:0]                            axi_soc_bresp;
wire                                  axi_soc_bvalid;
wire                                  axi_soc_bready;
wire [7:0]                            axi_soc_arid;
wire [31:0]                           axi_soc_araddr;
wire [7:0]                            axi_soc_arlen;
wire [2:0]                            axi_soc_arsize;
wire [1:0]                            axi_soc_arburst;
wire                                  axi_soc_arlock;
wire [3:0]                            axi_soc_arcache;
wire [2:0]                            axi_soc_arprot;
wire [3:0]                            axi_soc_arqos;
wire                                  axi_soc_arvalid;
wire                                  axi_soc_arready;
wire [7:0]                            axi_soc_rid;
wire [AXI_SOC_DATA_WIDTH-1:0]         axi_soc_rdata;
wire [1:0]                            axi_soc_rresp;
wire                                  axi_soc_rlast;
wire                                  axi_soc_rvalid;
wire                                  axi_soc_rready;

// Camera I2C
wire                                  mipi_i2c_0_io_sda_writeEnable;
wire                                  mipi_i2c_0_io_sda_read;
wire                                  mipi_i2c_0_io_scl_writeEnable;
wire                                  mipi_i2c_0_io_scl_read;

// Dma
wire  [3:0]                           dma_interrupts;
wire                                  userInterruptA;
wire                                  userInterruptB;

////////////////
//Reset Related
//////////////////
assign pll_ddr_RSTN     = 1'b1;
assign pll_osc2_RSTN    = 1'b1;
assign pll_osc3_RSTN    = 1'b1;

assign pll_sys_RSTN     = 1'b1;

assign io_asyncResetn   = i_sw[0] & pll_sys_LOCKED & pll_ddr_LOCKED & pll_osc2_LOCKED & pll_osc3_LOCKED;
assign w_sysclk_arst    = ~( io_asyncResetn );
assign w_sysclk_arstn   = ~w_sysclk_arst;

assign i_arstn = (w_sysclk_arstn & (!mipi_rstn)) ;
assign o_cam_rstn = i_arstn;

/////////////
//ddr4 config
/////////////
common_ti180_ddr_config (
    .i_sys_clk                  (i_sys_clk),
    .io_memoryReset             (io_memoryReset),
    .io_asyncResetn             (io_asyncResetn),

    .ddr_inst_ARST_0            (ddr_inst_ARST_0),
    .ddr_inst_ARADDR_0          (ddr_inst_ARADDR_0),
    .ddr_inst_ARID_0            (ddr_inst_ARID_0),
    .ddr_inst_ARAPCMD_0         (ddr_inst_ARAPCMD_0),
    
    .ddr_inst_BID_0             (ddr_inst_BID_0),
    
    .ddr_inst_RID_0             (ddr_inst_RID_0),
    
    .ddr_inst_AWADDR_0          (ddr_inst_AWADDR_0),
    .ddr_inst_AWID_0            (ddr_inst_AWID_0),
    .ddr_inst_AWAPCMD_0         (ddr_inst_AWAPCMD_0),
    .ddr_inst_AWALLSTRB_0       (ddr_inst_AWALLSTRB_0),
    .ddr_inst_AWCOBUF_0         (ddr_inst_AWCOBUF_0),
    
    //DDR AXI 1 Read Address Channel
    .ddr_inst_ARST_1            (ddr_inst_ARST_1),
    .ddr_inst_ARADDR_1          (ddr_inst_ARADDR_1),
    .ddr_inst_ARID_1            (ddr_inst_ARID_1),
    .ddr_inst_ARAPCMD_1         (ddr_inst_ARAPCMD_1),
    
    //DDR AXI 1 Wrtie Address Channel
    .ddr_inst_AWADDR_1          (ddr_inst_AWADDR_1),
    .ddr_inst_AWID_1            (ddr_inst_AWID_1),
    .ddr_inst_AWAPCMD_1         (ddr_inst_AWAPCMD_1),
    .ddr_inst_AWALLSTRB_1       (ddr_inst_AWALLSTRB_1),
    .ddr_inst_AWCOBUF_1         (ddr_inst_AWCOBUF_1),
    
    .ddr_inst_CFG_RST           (ddr_inst_CFG_RST),
    .ddr_inst_CFG_START         (ddr_inst_CFG_START),
    .ddr_inst_CFG_DONE          (ddr_inst_CFG_DONE),
    .ddr_inst_CFG_SEL           (ddr_inst_CFG_SEL),
    
    .io_ddrA_ar_payload_addr_i  (io_ddrA_ar_payload_addr_i),
    .io_ddrA_aw_payload_addr_i  (io_ddrA_aw_payload_addr_i),
    .io_ddrA_ar_payload_id_i    (io_ddrA_ar_payload_id_i),
    .io_ddrA_aw_payload_id_i    (io_ddrA_aw_payload_id_i),
    .io_ddrA_b_payload_id_i     (io_ddrA_b_payload_id_i),
    .io_ddrA_r_payload_id_i     (io_ddrA_r_payload_id_i),
    
    .ddr_cfg_ok                 (ddr_cfg_ok)
);

///////////////////////////////////////////////////////////
// LED Status (active high) all LEDS light up == status OK
///////////////////////////////////////////////////////////
assign o_led[5] = ddr_cfg_ok;
assign o_led[4] = 'b1;
assign o_led[3] = 'b1;
assign o_led[2] = 'b1;
assign o_led[1] = 'b1;
assign o_led[0] = 'b1;

//////////////////////////////////////////////
// CSI controllers ouptut interface port
//////////////////////////////////////////////
cam_csi_rx_controllers #(
    .NUM_CHANNEL            (1),
    .NUM_RX_PER_CHANNEL     (CSI_RX_NUM_DATA_LANE),
    .DATAWIDTH_PER_CHANNEL  (CSI_RX_DATA_WIDTH_LANE),
    .PIXEL_RX_DATAWIDTH     (CAM_PIXEL_RX_DATAWIDTH),       //RAW10, RAW12
    .PIXEL_OUT_DATAWIDTH    (CAM_PIXEL_RX_MEM_DATAWIDTH)    //DATAWIDTH will be store to Memory
) inst_csi_rx_controllersn(

    .rstn               (i_arstn),
    .clk                (i_pixel_clk),
    .clk_pixel          (i_pixel_clk),

    // DPHY interface port
    .clk_byte_HS        (mipi_dphy_rx_inst1_WORD_CLKOUT_HS),
    .reset_byte_HS_n    (mipi_dphy_rx_inst1_RST0_N),
    .resetb_rx          (mipi_dphy_rx_inst1_RESET_N),

    .RxDataHS0          (mipi_dphy_rx_inst1_RX_DATA_HS_LAN0),  //full 16 bit
    .RxDataHS1          (mipi_dphy_rx_inst1_RX_DATA_HS_LAN1),
    .RxValidHS0         (mipi_dphy_rx_inst1_RX_VALID_HS_LAN0),
    .RxValidHS1         (mipi_dphy_rx_inst1_RX_VALID_HS_LAN1),

    .RxSyncHS           ({mipi_dphy_rx_inst1_RX_SYNC_HS_LAN1,mipi_dphy_rx_inst1_RX_SYNC_HS_LAN0 }),
    .RxUlpsClkNot       ({mipi_dphy_rx_inst1_RX_ULPS_CLK_NOT }),
    .RxUlpsActiveClkNot ({mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_CLK_NOT}),
    .RxErrEsc           ({mipi_dphy_rx_inst1_ERR_ESC_LAN1,mipi_dphy_rx_inst1_ERR_ESC_LAN0 }),
    .RxErrControl       ({mipi_dphy_rx_inst1_ERR_CONTROL_LAN1,mipi_dphy_rx_inst1_ERR_CONTROL_LAN0 }),
    .RxErrSotSyncHS     ({mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN1,mipi_dphy_rx_inst1_ERR_SOT_SYNC_HS_LAN0 }),
    .RxUlpsEsc          ({mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN1,mipi_dphy_rx_inst1_RX_ULPS_ESC_LAN0 }),
    .RxUlpsActiveNot    ({mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN1,mipi_dphy_rx_inst1_RX_ULPS_ACTIVE_NOT_LAN0 }),
    .RxSkewCalHS        ({mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN1,mipi_dphy_rx_inst1_RX_SKEW_CAL_HS_LAN0 }),
    .RxStopState        ({mipi_dphy_rx_inst1_STOPSTATE_LAN1,mipi_dphy_rx_inst1_STOPSTATE_LAN0 }),

    // CSI controller ouptut interface port
    .rx_out_de          (w_rx_out_de),
    .rx_out_vs          (w_rx_out_vs),
    .rx_out_hs          (w_rx_out_hs),
    .rx_out_data_00     (w_rx_out_data_00),
    .rx_out_data_01     (w_rx_out_data_01),
    .rx_out_data_10     (w_rx_out_data_10),
    .rx_out_data_11     (w_rx_out_data_11),
    .rx_out_dt          (rx_out_dt)
);


//////////////////////////////
// Camera Input Preprocessing
//////////////////////////////
assign w_mapped_raw_data = {24'h0, w_rx_out_data_11[7:0],2'b0, w_rx_out_data_10[7:0],2'b0, w_rx_out_data_01[7:0],2'b0, w_rx_out_data_00[7:0],2'b0};

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


//////////////////
//  DIPLAY (HDMI)
//////////////////

/* I2C initialization for ADV7511 */
display_hdmi_adv7511_config #(
    .INITIAL_CODE   ("source/display/hdmi/display_hdmi_adv7511_reg.mem")
) inst_adv7511_config (
    .i_arst         (w_sysclk_arst),
    .i_sysclk       (i_sys_clk_25mhz),
    .i_pll_locked   (pll_sys_LOCKED),
    .o_state        (),
    .o_confdone     (w_hdmi_confdone),
    
    .i_sda          (i_hdmi_sda),
    .o_sda_oe       (o_hdmi_sda_oe),
    .i_scl          (i_hdmi_scl),
    .o_scl_oe       (o_hdmi_scl_oe),
    .o_rstn         ()
);

display_annotator #(
   .FRAME_WIDTH  (FRAME_WIDTH),
   .FRAME_HEIGHT (FRAME_HEIGHT),
   .MAX_BBOX     (16)
) u_display_annotator (
   .clk        (w_hdmi_clk),
   .rst        (~i_arstn),
   
   .in_valid   (bbox_dma_tvalid),
   .in_last    (bbox_dma_tlast),
   .in_data    (bbox_dma_tdata),
   .in_ready   (bbox_dma_tready),
   
   .out_valid  (display_dma_rvalid),
   .out_data   (display_dma_rdata),
   .out_ready  (display_dma_rready)
);

// Diplay post process from DMA to HDMI Port
display_hdmi_yuv #(
    .FRAME_WIDTH     (MIPI_FRAME_WIDTH),
    .FRAME_HEIGHT    (MIPI_FRAME_HEIGHT),

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
    .iv7DisplayDmaRdKeep                (8'hFF),
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

/////////////
// Camera I2C
/////////////

// Mapped
assign o_cam_sda_oe                  = mipi_i2c_0_io_sda_writeEnable;
assign mipi_i2c_0_io_sda_read        = i_cam_sda;
assign mipi_i2c_0_io_scl_read        = i_cam_scl;
assign o_cam_scl_oe                  = mipi_i2c_0_io_scl_writeEnable;

assign mipi_i2c_0_io_sda_writeEnable = !mipi_i2c_0_io_sda_write;
assign mipi_i2c_0_io_scl_writeEnable = !mipi_i2c_0_io_scl_write;

////////////////////
// Sapphire SOC inst
////////////////////

assign peripheralClk = i_sys_clk;// 100MHz

SapphireSoc SapphireSoc_inst (

    //Soc Clock and Reset
    .io_systemClk                       (i_soc_clk),
    .io_asyncReset                      (w_sysclk_arst),
    .io_memoryClk                       (i_axi0_mem_clk),
    .io_memoryReset                     (io_memoryReset),
    .io_systemReset                     (io_systemReset),
    .io_peripheralClk                   (peripheralClk),
    .io_peripheralReset                 (peripheralReset),
    
    // Uart
    .system_uart_0_io_txd               (system_uart_0_io_txd),
     .system_uart_0_io_rxd              (system_uart_0_io_rxd),
    
    // Pi Camera I2C
    .system_i2c_0_io_sda_write          (mipi_i2c_0_io_sda_write),
    .system_i2c_0_io_sda_read           (mipi_i2c_0_io_sda_read),
    .system_i2c_0_io_scl_write          (mipi_i2c_0_io_scl_write),
    .system_i2c_0_io_scl_read           (mipi_i2c_0_io_scl_read),


    // SPI
    .system_spi_0_io_sclk_write         (system_spi_0_io_sclk_write),
    .system_spi_0_io_data_0_writeEnable (system_spi_0_io_data_0_writeEnable),
    .system_spi_0_io_data_0_read        (system_spi_0_io_data_0_read),
    .system_spi_0_io_data_0_write       (system_spi_0_io_data_0_write),
    .system_spi_0_io_data_1_writeEnable (system_spi_0_io_data_1_writeEnable),
    .system_spi_0_io_data_1_read        (system_spi_0_io_data_1_read),
    .system_spi_0_io_data_1_write       (system_spi_0_io_data_1_write),
    .system_spi_0_io_ss                 (system_spi_0_io_ss),
    
    .system_spi_1_io_sclk_write         (system_spi_1_io_sclk_write),
    .system_spi_1_io_data_0_writeEnable (system_spi_1_io_data_0_writeEnable),
    .system_spi_1_io_data_0_read        (system_spi_1_io_data_0_read),
    .system_spi_1_io_data_0_write       (system_spi_1_io_data_0_write),
    .system_spi_1_io_data_1_writeEnable (system_spi_1_io_data_1_writeEnable),
    .system_spi_1_io_data_1_read        (system_spi_1_io_data_1_read),
    .system_spi_1_io_data_1_write       (system_spi_1_io_data_1_write),
    .system_spi_1_io_ss                 (system_spi_1_io_ss),
    
    .userInterruptA                     (userInterruptA),
    .userInterruptB                     (userInterruptB),

    .io_ddrA_ar_valid                   (axi_soc_arvalid),
    .io_ddrA_ar_ready                   (axi_soc_arready),
    .io_ddrA_ar_payload_addr            (axi_soc_araddr),
    .io_ddrA_ar_payload_id              (axi_soc_arid),
    .io_ddrA_ar_payload_region          (),
    .io_ddrA_ar_payload_len             (axi_soc_arlen),
    .io_ddrA_ar_payload_size            (axi_soc_arsize),
    .io_ddrA_ar_payload_burst           (axi_soc_arburst),
    .io_ddrA_ar_payload_lock            (axi_soc_arlock),
    .io_ddrA_ar_payload_cache           (axi_soc_arcache),
    .io_ddrA_ar_payload_qos             (axi_soc_arqos),
    .io_ddrA_ar_payload_prot            (axi_soc_arprot),
    
    .io_ddrA_aw_valid                   (axi_soc_awvalid),
    .io_ddrA_aw_ready                   (axi_soc_awready),
    .io_ddrA_aw_payload_addr            (axi_soc_awaddr),
    .io_ddrA_aw_payload_id              (axi_soc_awid),
    .io_ddrA_aw_payload_region          (),
    .io_ddrA_aw_payload_len             (axi_soc_awlen),
    .io_ddrA_aw_payload_size            (axi_soc_awsize),
    .io_ddrA_aw_payload_burst           (axi_soc_awburst),
    .io_ddrA_aw_payload_lock            (axi_soc_awlock),
    .io_ddrA_aw_payload_cache           (axi_soc_awcache),
    .io_ddrA_aw_payload_qos             (axi_soc_awqos),
    .io_ddrA_aw_payload_prot            (axi_soc_awprot),

    .io_ddrA_w_valid                    (axi_soc_wvalid),
    .io_ddrA_w_ready                    (axi_soc_wready),
    .io_ddrA_w_payload_data             (axi_soc_wdata),
    .io_ddrA_w_payload_strb             (axi_soc_wstrb),
    .io_ddrA_w_payload_last             (axi_soc_wlast),

    .io_ddrA_b_valid                    (axi_soc_bvalid),
    .io_ddrA_b_ready                    (axi_soc_bready),
    .io_ddrA_b_payload_id               (axi_soc_bid),
    .io_ddrA_b_payload_resp             (axi_soc_bresp),

    .io_ddrA_r_valid                    (axi_soc_rvalid),
    .io_ddrA_r_ready                    (axi_soc_rready),
    .io_ddrA_r_payload_data             (axi_soc_rdata),
    .io_ddrA_r_payload_id               (axi_soc_rid),
    .io_ddrA_r_payload_resp             (axi_soc_rresp),
    .io_ddrA_r_payload_last             (axi_soc_rlast),
     //.io_ddrA_w_payload_id             (),

    // APB 3 Slave 0
    .io_apbSlave_0_PADDR                (w_dma_apbSlave_PADDR),
    .io_apbSlave_0_PSEL                 (w_dma_apbSlave_PSEL),
    .io_apbSlave_0_PENABLE              (w_dma_apbSlave_PENABLE),
    .io_apbSlave_0_PREADY               (w_dma_apbSlave_PREADY),
    .io_apbSlave_0_PWRITE               (w_dma_apbSlave_PWRITE),
    .io_apbSlave_0_PWDATA               (w_dma_apbSlave_PWDATA),
    .io_apbSlave_0_PRDATA               (w_dma_apbSlave_PRDATA),
    .io_apbSlave_0_PSLVERROR            (w_dma_apbSlave_PSLVERROR),
    
    // APB 3 Slave 1
    .io_apbSlave_1_PADDR                (w_apbSlave_1_PADDR),
    .io_apbSlave_1_PSEL                 (w_apbSlave_1_PSEL),
    .io_apbSlave_1_PENABLE              (w_apbSlave_1_PENABLE),
    .io_apbSlave_1_PREADY               (w_apbSlave_1_PREADY),
    .io_apbSlave_1_PWRITE               (w_apbSlave_1_PWRITE),
    .io_apbSlave_1_PWDATA               (w_apbSlave_1_PWDATA),
    .io_apbSlave_1_PRDATA               (w_apbSlave_1_PRDATA),
    .io_apbSlave_1_PSLVERROR            (w_apbSlave_1_PSLVERROR),
    
    // Custom Instruction (To TinyML HW Accelerator)
   .cpu0_customInstruction_cmd_valid    (cpu_customInstruction_cmd_valid),
   .cpu0_customInstruction_cmd_ready    (cpu_customInstruction_cmd_ready),
   .cpu0_customInstruction_function_id  (cpu_customInstruction_function_id),
   .cpu0_customInstruction_inputs_0     (cpu_customInstruction_inputs_0),
   .cpu0_customInstruction_inputs_1     (cpu_customInstruction_inputs_1),
   .cpu0_customInstruction_rsp_valid    (cpu_customInstruction_rsp_valid),
   .cpu0_customInstruction_rsp_ready    (cpu_customInstruction_rsp_ready),
   .cpu0_customInstruction_outputs_0    (cpu_customInstruction_outputs_0),
    
    `ifdef SOFT_TAP
        .io_jtag_tck                    (io_jtag_tck),
        .io_jtag_tdi                    (io_jtag_tdi),
        .io_jtag_tdo                    (io_jtag_tdo),
        .io_jtag_tms                    (io_jtag_tms)
    `else 
        .jtagCtrl_tck                   (jtag_inst1_TCK),
        .jtagCtrl_tdi                   (jtag_inst1_TDI),
        .jtagCtrl_tdo                   (jtag_inst1_TDO),
        .jtagCtrl_enable                (jtag_inst1_SEL),
        .jtagCtrl_capture               (jtag_inst1_CAPTURE),
        .jtagCtrl_shift                 (jtag_inst1_SHIFT),
        .jtagCtrl_update                (jtag_inst1_UPDATE),
        .jtagCtrl_reset                 (jtag_inst1_RESET) 
    `endif
);

////////////////
// APB3 Slave 1
///////////////

assign debug_cam_display_fifo_status= {22'd0,  debug_dma_hw_accel_out_fifo_overflow,debug_dma_hw_accel_out_fifo_underflow,
                                            debug_dma_hw_accel_in_fifo_overflow,debug_dma_hw_accel_in_fifo_underflow,
                                            debug_cam_pixel_remap_fifo_underflow, debug_cam_pixel_remap_fifo_overflow, 
                                            debug_cam_dma_fifo_underflow, debug_cam_dma_fifo_overflow, 
                                            debug_display_dma_fifo_underflow, debug_display_dma_fifo_overflow};
                                            
// For control and status register
common_apb3 #(
   .ADDR_WIDTH                              (16),
   .DATA_WIDTH                              (32),
   .NUM_REG                                 (7)
) u_apb3_cam_display (
    .clk                                    (peripheralClk),
    .resetn                                 (~peripheralReset),
    
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
    .PADDR                                  (w_apbSlave_1_PADDR),
    .PSEL                                   (w_apbSlave_1_PSEL),
    .PENABLE                                (w_apbSlave_1_PENABLE),
    .PREADY                                 (w_apbSlave_1_PREADY),
    .PWRITE                                 (w_apbSlave_1_PWRITE),
    .PWDATA                                 (w_apbSlave_1_PWDATA),
    .PRDATA                                 (w_apbSlave_1_PRDATA),
    .PSLVERROR                              (w_apbSlave_1_PSLVERROR)
);

///////
// Dma 
///////
assign userInterruptA = cpu_customInstruction_cmd_int;
assign userInterruptB = |dma_interrupts;

dma u_dma(

    .clk                (i_axi0_mem_clk),
    .reset              (io_memoryReset),
    
    .ctrl_clk           (peripheralClk),
    .ctrl_reset         (peripheralReset),

    //APB Slave
    .ctrl_PADDR         (w_dma_apbSlave_PADDR),
    .ctrl_PSEL          (w_dma_apbSlave_PSEL),
    .ctrl_PENABLE       (w_dma_apbSlave_PENABLE),
    .ctrl_PREADY        (w_dma_apbSlave_PREADY),
    .ctrl_PWRITE        (w_dma_apbSlave_PWRITE),
    .ctrl_PWDATA        (w_dma_apbSlave_PWDATA),
    .ctrl_PRDATA        (w_dma_apbSlave_PRDATA),
    .ctrl_PSLVERROR     (w_dma_apbSlave_PSLVERROR),
    .ctrl_interrupts    (dma_interrupts),

    //DMA AXI memory Interface 
    .read_arvalid       (ddr_inst_ARVALID_1),
    .read_araddr        (ddr_inst_ARADDR_1[31:0]),
    .read_arready       (ddr_inst_ARREADY_1),
    .read_arregion      (),
    .read_arlen         (ddr_inst_ARLEN_1),
    .read_arsize        (ddr_inst_ARSIZE_1),
    .read_arburst       (ddr_inst_ARBURST_1),
    .read_arlock        (ddr_inst_ARLOCK_1),
    .read_arcache       ( ),
    .read_arqos         (ddr_inst_ARQOS_1),
    .read_arprot        ( ),
    
    .read_rready        (ddr_inst_RREADY_1),
    .read_rvalid        (ddr_inst_RVALID_1),
    .read_rdata         (ddr_inst_RDATA_1),
    .read_rlast         (ddr_inst_RLAST_1),
    .read_rresp         (ddr_inst_RRESP_1),
    
    .write_awvalid      (ddr_inst_AWVALID_1),
    .write_awready      (ddr_inst_AWREADY_1),
    .write_awaddr       (ddr_inst_AWADDR_1[31:0]),
    .write_awregion     (),
    .write_awlen        (ddr_inst_AWLEN_1),
    .write_awsize       (ddr_inst_AWSIZE_1),
    .write_awburst      (ddr_inst_AWBURST_1),
    .write_awlock       (ddr_inst_AWLOCK_1),
    .write_awcache      (ddr_inst_AWCACHE_1),
    .write_awqos        (ddr_inst_AWQOS_1),
    .write_awprot       (),
    
    .write_wvalid       (ddr_inst_WVALID_1),
    .write_wready       (ddr_inst_WREADY_1),
    .write_wdata        (ddr_inst_WDATA_1),
    .write_wstrb        (ddr_inst_WSTRB_1),
    .write_wlast        (ddr_inst_WLAST_1),
    
    .write_bvalid       (ddr_inst_BVALID_1),
    .write_bready       (ddr_inst_BREADY_1),
    .write_bresp        (ddr_inst_BRESP_1),


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
    .dat1_o_tvalid      (bbox_dma_tvalid),
    .dat1_o_tready      (bbox_dma_tready),
    .dat1_o_tdata       (bbox_dma_tdata),
    .dat1_o_tkeep       (),
    .dat1_o_tdest       (),
    .dat1_o_tlast       (bbox_dma_tlast),
    
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
    .DMA_TRANSFER_LENGTH ((96*96*3)/4) //S2MM DMA transfer for yolo person detection demo
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

///////////////////////////////////////
// TinyML Accelerator Custom instruction
///////////////////////////////////////
tinyml_accelerator_channels#(
  .AXI_DW_M             (AXI_TINYML_DATA_WIDTH)
) u_tinyml_top_channels(

   .clk              (i_soc_clk),
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
   
   .m_axi_clk        (i_axi0_mem_clk),
   .m_axi_rstn       (!io_systemReset),
   .m_axi_awvalid    (axi_tinyml_awvalid),
   .m_axi_awaddr     (axi_tinyml_awaddr),
   .m_axi_awlen      (axi_tinyml_awlen),
   .m_axi_awsize     (axi_tinyml_awsize),
   .m_axi_awburst    (axi_tinyml_awburst),
   .m_axi_awprot     (axi_tinyml_awprot),
   .m_axi_awlock     (axi_tinyml_awlock),
   .m_axi_awcache    (axi_tinyml_awcache),
   .m_axi_awready    (axi_tinyml_awready),
   .m_axi_wdata      (axi_tinyml_wdata),
   .m_axi_wstrb      (axi_tinyml_wstrb),
   .m_axi_wlast      (axi_tinyml_wlast),
   .m_axi_wvalid     (axi_tinyml_wvalid),
   .m_axi_wready     (axi_tinyml_wready),
   .m_axi_bresp      (axi_tinyml_bresp),
   .m_axi_bvalid     (axi_tinyml_bvalid),
   .m_axi_bready     (axi_tinyml_bready),
   .m_axi_arvalid    (axi_tinyml_arvalid),
   .m_axi_araddr     (axi_tinyml_araddr),
   .m_axi_arlen      (axi_tinyml_arlen),
   .m_axi_arsize     (axi_tinyml_arsize),
   .m_axi_arburst    (axi_tinyml_arburst),
   .m_axi_arprot     (axi_tinyml_arprot),
   .m_axi_arlock     (axi_tinyml_arlock),
   .m_axi_arcache    (axi_tinyml_arcache),
   .m_axi_arready    (axi_tinyml_arready),
   .m_axi_rvalid     (axi_tinyml_rvalid),
   .m_axi_rdata      (axi_tinyml_rdata),
   .m_axi_rlast      (axi_tinyml_rlast),
   .m_axi_rresp      (axi_tinyml_rresp),
   .m_axi_rready     (axi_tinyml_rready)
);

/////////////////////////////////////////////////////
// AXI Interconnect/ Arbiter TinyML / SOC <-> DDR IO
/////////////////////////////////////////////////////
axi_interconnect_beta #(
    .S_COUNT                            (2                                  ),
    .SLAVE_ASYN_ARRAY                   ({1'b0,1'b0}                        ),
    .S_AXI_DW_ARRAY                     ({AXI_0_DATA_WIDTH,AXI_0_DATA_WIDTH}              ),
    .CB_DW                              (AXI_0_DATA_WIDTH                       ),
    .M_AXI_DW                           (AXI_0_DATA_WIDTH                       ),
    .ARB_MODE                           (1                                  ),
    .FAMILY                             ("TITANIUM"                         ),
    .RD_QUEUE_FIFO_RAM_STYLE            ("block_ram"                        ),
    .RD_QUEUE_FIFO_DEPTH                (256                                )
) u_axi_interconnect (

   //AXI slave interfaces - S0: Connected to RubySoC; S1: Connected to DMA controller
   .s_axi_clk        ({i_axi0_mem_clk         , i_axi0_mem_clk        }),
   .s_axi_rstn       ({!io_systemReset             , !io_systemReset            }),
   .s_axi_awaddr     ({axi_tinyml_awaddr    ,axi_soc_awaddr}),
   .s_axi_awlen      ({axi_tinyml_awlen     ,axi_soc_awlen}),
   .s_axi_awvalid    ({axi_tinyml_awvalid   ,axi_soc_awvalid}),
   .s_axi_awready    ({axi_tinyml_awready   ,axi_soc_awready}),
   .s_axi_wdata      ({axi_tinyml_wdata     ,axi_soc_wdata}),
   .s_axi_wstrb      ({axi_tinyml_wstrb     ,axi_soc_wstrb}),
   .s_axi_wlast      ({axi_tinyml_wlast     ,axi_soc_wlast}),
   .s_axi_wvalid     ({axi_tinyml_wvalid    ,axi_soc_wvalid}),
   .s_axi_wready     ({axi_tinyml_wready    ,axi_soc_wready}),
   .s_axi_bresp      ({axi_tinyml_bresp     ,axi_soc_bresp}),
   .s_axi_bvalid     ({axi_tinyml_bvalid    ,axi_soc_bvalid}),
   .s_axi_bready     ({axi_tinyml_bready    ,axi_soc_bready}),
   .s_axi_araddr     ({axi_tinyml_araddr    ,axi_soc_araddr}),
   .s_axi_arlen      ({axi_tinyml_arlen     ,axi_soc_arlen}),
   .s_axi_arvalid    ({axi_tinyml_arvalid   ,axi_soc_arvalid}),
   .s_axi_arready    ({axi_tinyml_arready   ,axi_soc_arready}),
   .s_axi_rdata      ({axi_tinyml_rdata     ,axi_soc_rdata}),
   .s_axi_rresp      ({axi_tinyml_rresp     ,axi_soc_rresp}),
   .s_axi_rlast      ({axi_tinyml_rlast     ,axi_soc_rlast}),
   .s_axi_rvalid     ({axi_tinyml_rvalid    ,axi_soc_rvalid}),
   .s_axi_rready     ({axi_tinyml_rready    ,axi_soc_rready}),
   
   //AXI master interface - Connect to DDR controller
   .m_axi_clk        (i_axi0_mem_clk                       ),
   .m_axi_rstn       (!io_systemReset                           ),
   .m_axi_awid       (io_ddrA_aw_payload_id_i),
   .m_axi_awaddr     (io_ddrA_aw_payload_addr_i),
   .m_axi_awlen      (ddr_inst_AWLEN_0),
   .m_axi_awsize     (ddr_inst_AWSIZE_0),
   .m_axi_awburst    (ddr_inst_AWBURST_0),
   .m_axi_awlock     (ddr_inst_AWLOCK_0),
   .m_axi_awcache    (ddr_inst_AWCACHE_0),
   .m_axi_awprot     (),
   .m_axi_awvalid    (ddr_inst_AWVALID_0),
   .m_axi_awready    (ddr_inst_AWREADY_0),
   
   .m_axi_wdata      (ddr_inst_WDATA_0),
   .m_axi_wstrb      (ddr_inst_WSTRB_0),
   .m_axi_wlast      (ddr_inst_WLAST_0),
   .m_axi_wvalid     (ddr_inst_WVALID_0),
   .m_axi_wready     (ddr_inst_WREADY_0),
   
   .m_axi_bresp      (ddr_inst_BRESP_0),
   .m_axi_bvalid     (ddr_inst_BVALID_0),
   .m_axi_bready     (ddr_inst_BREADY_0),
   
   .m_axi_arid       (io_ddrA_ar_payload_id_i),
   .m_axi_araddr     (io_ddrA_ar_payload_addr_i),
   .m_axi_arlen      (ddr_inst_ARLEN_0),
   .m_axi_arsize     (ddr_inst_ARSIZE_0),
   .m_axi_arburst    (ddr_inst_ARBURST_0),
   .m_axi_arlock     (ddr_inst_ARLOCK_0),
   .m_axi_arcache    (),
   .m_axi_arprot     (),
   .m_axi_arvalid    (ddr_inst_ARVALID_0),
   .m_axi_arready    (ddr_inst_ARREADY_0),
   
   .m_axi_rdata      (ddr_inst_RDATA_0),
   .m_axi_rresp      (ddr_inst_RRESP_0),
   .m_axi_rlast      (ddr_inst_RLAST_0),
   .m_axi_rvalid     (ddr_inst_RVALID_0),
   .m_axi_rready     (ddr_inst_RREADY_0)
);

endmodule
