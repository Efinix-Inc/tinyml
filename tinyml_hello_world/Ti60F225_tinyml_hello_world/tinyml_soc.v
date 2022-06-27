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


module tinyml_soc (
   input    wire           i_arstn,
   input    wire           i_fb_clk,
   input    wire           i_pll_locked,
   
   input    wire           i_hbramClk,
   input    wire           i_hbramClk_cal,
   input    wire           i_hbramClk90,
   input    wire           i_systemClk,
   input    wire           i_peripheralClk,
   input    wire           i_hbramClk_pll_locked,
   
   output   wire  [2:0]    o_hbc_cal_SHIFT,
   output   wire  [4:0]    o_hbc_cal_SHIFT_SEL,
   output   wire           o_hbc_cal_SHIFT_ENA,
   output   wire           o_hbramClk_pll_rstn,
   
   output   wire           o_pll_rstn,
   
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

`ifndef SIM
   `include "./ip/hbram/hbram_define.vh"
`else
   `include "hbram_define.vh"
`endif

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
wire    [AXI_DBW-1:0]   io_w_payload_data;
wire    [AXI_DBW/8-1:0] io_w_payload_strb;
wire                    io_w_payload_last;
wire                    io_b_valid;
wire                    io_b_ready;
wire    [7:0]           io_b_payload_id;
wire                    io_r_valid;
wire                    io_r_ready;
wire    [AXI_DBW-1:0]   io_r_payload_data;
wire    [7:0]           io_r_payload_id;
wire    [1:0]           io_r_payload_resp;
wire                    io_r_payload_last;
wire    [1:0]           io_b_payload_resp;

wire                    userInterrupt;
wire                    axi4Interrupt;

wire  [15:0]            io_apbSlave_0_PADDR;
wire                    io_apbSlave_0_PSEL;
wire                    io_apbSlave_0_PENABLE;
wire                    io_apbSlave_0_PREADY;
wire                    io_apbSlave_0_PWRITE;
wire  [31:0]            io_apbSlave_0_PWDATA;
wire  [31:0]            io_apbSlave_0_PRDATA;
wire                    io_apbSlave_0_PSLVERROR;

wire                    peripheralReset; 

(* keep , syn_keep *) wire       io_memoryReset /* synthesis syn_keep = 1 */;          
(* keep , syn_keep *) wire [3:0] io_arw_payload_qos /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [2:0] io_arw_payload_prot /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] io_arw_payload_cache /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] io_arw_payload_region /* synthesis syn_keep = 1 */;

////////////////////////////////////////////////////////////////
// Hardware accelerator related
wire  [7:0]             axi_awid;
wire  [31:0]            axi_awaddr;
wire  [7:0]             axi_awlen;
wire  [2:0]             axi_awsize;
wire  [1:0]             axi_awburst;
wire                    axi_awlock;
wire  [3:0]             axi_awcache;
wire  [2:0]             axi_awprot;
wire  [3:0]             axi_awqos;
wire  [3:0]             axi_awregion;
wire                    axi_awvalid;
wire                    axi_awready;
wire  [31:0]            axi_wdata;
wire  [3:0]             axi_wstrb;
wire                    axi_wvalid;
wire                    axi_wlast;
wire                    axi_wready;
wire  [7:0]             axi_bid;
wire  [1:0]             axi_bresp;
wire                    axi_bvalid;
wire                    axi_bready;
wire  [7:0]             axi_arid;
wire  [31:0]            axi_araddr;
wire  [7:0]             axi_arlen;
wire  [2:0]             axi_arsize;
wire  [1:0]             axi_arburst;
wire                    axi_arlock;
wire  [3:0]             axi_arcache;
wire  [2:0]             axi_arprot;
wire  [3:0]             axi_arqos;
wire  [3:0]             axi_arregion;
wire                    axi_arvalid;
wire                    axi_arready;
wire  [7:0]             axi_rid;
wire  [31:0]            axi_rdata;
wire  [1:0]             axi_rresp;
wire                    axi_rlast;
wire                    axi_rvalid;
wire                    axi_rready;

wire                    hw_accel_axi_we;
wire  [31:0]            hw_accel_axi_waddr;
wire  [31:0]            hw_accel_axi_wdata;
wire                    hw_accel_axi_re;
wire  [31:0]            hw_accel_axi_raddr;
wire  [31:0]            hw_accel_axi_rdata;
wire                    hw_accel_axi_rvalid;

//Custom instruction
wire                    cpu_customInstruction_cmd_valid;
wire                    cpu_customInstruction_cmd_ready;
wire  [9:0]             cpu_customInstruction_function_id;
wire  [31:0]            cpu_customInstruction_inputs_0;
wire  [31:0]            cpu_customInstruction_inputs_1;
wire                    cpu_customInstruction_rsp_valid;
wire                    cpu_customInstruction_rsp_ready;
wire  [31:0]            cpu_customInstruction_outputs_0;

////////////////////////////////////////////////////////////////
// AXI interconnect
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

wire                    hw_accel_dma_rready;
wire                    hw_accel_dma_rvalid;
wire  [3:0]             hw_accel_dma_rkeep;
wire  [31:0]            hw_accel_dma_rdata;
wire                    hw_accel_dma_wready;
wire                    hw_accel_dma_wvalid;
wire                    hw_accel_dma_wlast;
wire  [31:0]            hw_accel_dma_wdata;

wire  [3:0]             dma_interrupts;

(* keep , syn_keep *) wire [3:0] dma_awregion /* synthesis syn_keep = 1 */;
(* keep , syn_keep *) wire [3:0] dma_arregion /* synthesis syn_keep = 1 */;

////////////////////////////////////////////////////////////////
// Reset related

`ifndef SIM
   reset_ctrl #(
      .NUM_RST          (8),
      .CYCLE            (1),
      .IN_RST_ACTIVE    (8'b000000),
      .OUT_RST_ACTIVE   (8'b101010)
   ) u_reset_ctrl (
      .i_arst ({{2{i_pll_locked}}}),
      .i_clk  ({{2{i_fb_clk}}}),
      .o_srst ({w_fb_clk_arst,w_fb_clk_arstn})
   );
`else
   assign w_fb_clk_arst          = ~i_arstn;
   assign w_fb_clk_arstn         = i_arstn;
`endif

assign   o_hbramClk_pll_rstn  = i_arstn;
assign   o_led                = 1'b0;
assign   o_pll_rstn           = i_arstn;


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

//Custom instruction
custom_instruction_top u_custom_instruction_top (
   .clk              (i_systemClk),
   .reset            (io_systemReset),
   .cmd_valid        (cpu_customInstruction_cmd_valid),
   .cmd_ready        (cpu_customInstruction_cmd_ready),
   .cmd_function_id  (cpu_customInstruction_function_id),
   .cmd_inputs_0     (cpu_customInstruction_inputs_0),
   .cmd_inputs_1     (cpu_customInstruction_inputs_1),
   .rsp_valid        (cpu_customInstruction_rsp_valid),
   .rsp_ready        (cpu_customInstruction_rsp_ready),
   .rsp_outputs_0    (cpu_customInstruction_outputs_0)
);

SapphireSoc u_risc_v
(
   .io_systemClk                       (i_systemClk),
   .io_asyncReset                      (mcuReset),
   .io_memoryClk                       (io_memoryClk),
   .io_peripheralClk                   (i_peripheralClk),
   .io_peripheralReset                 (peripheralReset),
   .io_memoryReset                     (io_memoryReset),
   .system_uart_0_io_txd               (system_uart_0_io_txd),
   .system_uart_0_io_rxd               (system_uart_0_io_rxd),
   .system_i2c_0_io_sda_write          (),
   .system_i2c_0_io_sda_read           (1'b0),
   .system_i2c_0_io_scl_write          (),
   .system_i2c_0_io_scl_read           (1'b0),
   .io_apbSlave_0_PADDR                (io_apbSlave_0_PADDR),
   .io_apbSlave_0_PSEL                 (io_apbSlave_0_PSEL),
   .io_apbSlave_0_PENABLE              (io_apbSlave_0_PENABLE),
   .io_apbSlave_0_PREADY               (io_apbSlave_0_PREADY),
   .io_apbSlave_0_PWRITE               (io_apbSlave_0_PWRITE),
   .io_apbSlave_0_PWDATA               (io_apbSlave_0_PWDATA),
   .io_apbSlave_0_PRDATA               (io_apbSlave_0_PRDATA),
   .io_apbSlave_0_PSLVERROR            (io_apbSlave_0_PSLVERROR),
   .io_apbSlave_1_PADDR                (),
   .io_apbSlave_1_PSEL                 (),
   .io_apbSlave_1_PENABLE              (),
   .io_apbSlave_1_PREADY               (),
   .io_apbSlave_1_PWRITE               (),
   .io_apbSlave_1_PWDATA               (),
   .io_apbSlave_1_PRDATA               (),
   .io_apbSlave_1_PSLVERROR            (),
   .userInterruptA                     (userInterrupt),
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
   .axiA_awvalid                       (axi_awvalid),
   .axiA_awready                       (axi_awready),
   .axiA_awaddr                        (axi_awaddr),
   .axiA_awid                          (axi_awid),
   .axiA_awregion                      (axi_awregion),
   .axiA_awlen                         (axi_awlen),
   .axiA_awsize                        (axi_awsize),
   .axiA_awburst                       (axi_awburst),
   .axiA_awlock                        (axi_awlock),
   .axiA_awcache                       (axi_awcache),
   .axiA_awqos                         (axi_awqos),
   .axiA_awprot                        (axi_awprot),
   .axiA_wvalid                        (axi_wvalid),
   .axiA_wready                        (axi_wready),
   .axiA_wdata                         (axi_wdata),
   .axiA_wstrb                         (axi_wstrb),
   .axiA_wlast                         (axi_wlast),
   .axiA_bvalid                        (axi_bvalid),
   .axiA_bready                        (axi_bready),
   .axiA_bid                           (axi_bid),
   .axiA_bresp                         (axi_bresp),
   .axiA_arvalid                       (axi_arvalid),
   .axiA_arready                       (axi_arready),
   .axiA_araddr                        (axi_araddr),
   .axiA_arid                          (axi_arid),
   .axiA_arregion                      (axi_arregion),
   .axiA_arlen                         (axi_arlen),
   .axiA_arsize                        (axi_arsize),
   .axiA_arburst                       (axi_arburst),
   .axiA_arlock                        (axi_arlock),
   .axiA_arcache                       (axi_arcache),
   .axiA_arqos                         (axi_arqos),
   .axiA_arprot                        (axi_arprot),
   .axiA_rvalid                        (axi_rvalid),
   .axiA_rready                        (axi_rready),
   .axiA_rdata                         (axi_rdata),
   .axiA_rid                           (axi_rid),
   .axiA_rresp                         (axi_rresp),
   .axiA_rlast                         (axi_rlast),
   .axiAInterrupt                      (axi4Interrupt),
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

axi4_hw_accel #(
   .ADDR_WIDTH (32),
   .DATA_WIDTH (32)
) u_axi4_hw_accel (
   .axi_interrupt (axi4Interrupt),
   .axi_aclk      (i_peripheralClk),
   .axi_resetn    (~peripheralReset),
   .axi_awid      (axi_awid),
   .axi_awaddr    (axi_awaddr),
   .axi_awlen     (axi_awlen),
   .axi_awsize    (axi_awsize),
   .axi_awburst   (axi_awburst),
   .axi_awlock    (axi_awlock),
   .axi_awcache   (axi_awcache),
   .axi_awprot    (axi_awprot),
   .axi_awqos     (axi_awqos),
   .axi_awregion  (axi_awregion),
   .axi_awvalid   (axi_awvalid),
   .axi_awready   (axi_awready),
   .axi_wdata     (axi_wdata),
   .axi_wstrb     (axi_wstrb),
   .axi_wlast     (axi_wlast),
   .axi_wvalid    (axi_wvalid),
   .axi_wready    (axi_wready),
   .axi_bid       (axi_bid),
   .axi_bresp     (axi_bresp),
   .axi_bvalid    (axi_bvalid),
   .axi_bready    (axi_bready),
   .axi_arid      (axi_arid),
   .axi_araddr    (axi_araddr),
   .axi_arlen     (axi_arlen),
   .axi_arsize    (axi_arsize),
   .axi_arburst   (axi_arburst),
   .axi_arlock    (axi_arlock),
   .axi_arcache   (axi_arcache),
   .axi_arprot    (axi_arprot),
   .axi_arqos     (axi_arqos),
   .axi_arregion  (axi_arregion),
   .axi_arvalid   (axi_arvalid),
   .axi_arready   (axi_arready),
   .axi_rid       (axi_rid),
   .axi_rdata     (axi_rdata),
   .axi_rresp     (axi_rresp),
   .axi_rlast     (axi_rlast),
   .axi_rvalid    (axi_rvalid),
   .axi_rready    (axi_rready),
   .usr_we        (hw_accel_axi_we),
   .usr_waddr     (hw_accel_axi_waddr),
   .usr_wdata     (hw_accel_axi_wdata),
   .usr_re        (hw_accel_axi_re),
   .usr_raddr     (hw_accel_axi_raddr),
   .usr_rdata     (hw_accel_axi_rdata),
   .usr_rvalid    (hw_accel_axi_rvalid)
);

//Example pre-processing prior to inference: Scale image from 540x540 to 96x96 resolution, and perform rgb2grayscale conversion
hw_accel_wrapper_tinyml #(
   .FRAME_WIDTH         (540),
   .FRAME_HEIGHT        (540),
   .DMA_TRANSFER_LENGTH ((96*96)/4) //S2MM DMA transfer
) u_hw_accel_wrapper_tinyml (
   .clk                   (i_systemClk),
   .rst                   (io_systemReset),
   .axi_slave_clk         (i_peripheralClk),
   .axi_slave_rst         (peripheralReset),
   .axi_slave_we          (hw_accel_axi_we),
   .axi_slave_waddr       (hw_accel_axi_waddr),
   .axi_slave_wdata       (hw_accel_axi_wdata),
   .axi_slave_re          (hw_accel_axi_re),
   .axi_slave_raddr       (hw_accel_axi_raddr),
   .axi_slave_rdata       (hw_accel_axi_rdata),
   .axi_slave_rvalid      (hw_accel_axi_rvalid),
   .dma_rready            (hw_accel_dma_rready),
   .dma_rvalid            (hw_accel_dma_rvalid),
   .dma_rdata             (hw_accel_dma_rdata),
   .dma_rkeep             (hw_accel_dma_rkeep),
   .dma_wready            (hw_accel_dma_wready),
   .dma_wvalid            (hw_accel_dma_wvalid),
   .dma_wlast             (hw_accel_dma_wlast),
   .dma_wdata             (hw_accel_dma_wdata)
);

////////////////////////////////////////////////////////////////
// DMA controller
assign userInterrupt = |dma_interrupts;

dma u_dma (
   .clk              (io_memoryClk),
   .reset            (io_systemReset),
   .ctrl_clk         (i_peripheralClk),
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
   .dat0_i_clk       (i_systemClk),
   .dat0_i_reset     (io_systemReset),
   .dat0_i_tvalid    (1'b0),
   .dat0_i_tready    (),
   .dat0_i_tdata     (64'd0),
   .dat0_i_tkeep     (8'd0),
   .dat0_i_tdest     (4'd0),
   .dat0_i_tlast     (1'b0),
   //64-bit dma channel (MM2S - from external memory)
   .dat1_o_clk       (i_systemClk),
   .dat1_o_reset     (io_systemReset),
   .dat1_o_tvalid    (),
   .dat1_o_tready    (1'b0),
   .dat1_o_tdata     (),
   .dat1_o_tkeep     (),
   .dat1_o_tdest     (),
   .dat1_o_tlast     (),
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

axi_interconnect #(
   .S_COUNT    (2),
   .M_COUNT    (1),
   .DATA_WIDTH (128),
   .ADDR_WIDTH (32),
   .ID_WIDTH   (8)
) u_axi_interconnect (
   .clk              (io_memoryClk),
   .rst              (io_systemReset),
   //AXI slave interfaces - S0: Connected to RubySoC; S1: Connected to DMA controller
   .s_axi_awid       ({axi_inter_s1_awid   , axi_inter_s0_awid   }),
   .s_axi_awaddr     ({axi_inter_s1_awaddr , axi_inter_s0_awaddr }),
   .s_axi_awlen      ({axi_inter_s1_awlen  , axi_inter_s0_awlen  }),
   .s_axi_awsize     ({axi_inter_s1_awsize , axi_inter_s0_awsize }),
   .s_axi_awburst    ({axi_inter_s1_awburst, axi_inter_s0_awburst}),
   .s_axi_awlock     ({axi_inter_s1_awlock , axi_inter_s0_awlock }),
   .s_axi_awcache    ({axi_inter_s1_awcache, axi_inter_s0_awcache}),
   .s_axi_awprot     ({axi_inter_s1_awprot , axi_inter_s0_awprot }),
   .s_axi_awqos      ({axi_inter_s1_awqos  , axi_inter_s0_awqos  }),
   .s_axi_awvalid    ({axi_inter_s1_awvalid, axi_inter_s0_awvalid}),
   .s_axi_awready    ({axi_inter_s1_awready, axi_inter_s0_awready}),
   .s_axi_wdata      ({axi_inter_s1_wdata  , axi_inter_s0_wdata  }),
   .s_axi_wstrb      ({axi_inter_s1_wstrb  , axi_inter_s0_wstrb  }),
   .s_axi_wlast      ({axi_inter_s1_wlast  , axi_inter_s0_wlast  }),
   .s_axi_wvalid     ({axi_inter_s1_wvalid , axi_inter_s0_wvalid }),
   .s_axi_wready     ({axi_inter_s1_wready , axi_inter_s0_wready }),
   .s_axi_bid        ({axi_inter_s1_bid    , axi_inter_s0_bid    }),
   .s_axi_bresp      ({axi_inter_s1_bresp  , axi_inter_s0_bresp  }),
   .s_axi_bvalid     ({axi_inter_s1_bvalid , axi_inter_s0_bvalid }),
   .s_axi_bready     ({axi_inter_s1_bready , axi_inter_s0_bready }),
   .s_axi_arid       ({axi_inter_s1_arid   , axi_inter_s0_arid   }),
   .s_axi_araddr     ({axi_inter_s1_araddr , axi_inter_s0_araddr }),
   .s_axi_arlen      ({axi_inter_s1_arlen  , axi_inter_s0_arlen  }),
   .s_axi_arsize     ({axi_inter_s1_arsize , axi_inter_s0_arsize }),
   .s_axi_arburst    ({axi_inter_s1_arburst, axi_inter_s0_arburst}),
   .s_axi_arlock     ({axi_inter_s1_arlock , axi_inter_s0_arlock }),
   .s_axi_arcache    ({axi_inter_s1_arcache, axi_inter_s0_arcache}),
   .s_axi_arprot     ({axi_inter_s1_arprot , axi_inter_s0_arprot }),
   .s_axi_arqos      ({axi_inter_s1_arqos  , axi_inter_s0_arqos  }),
   .s_axi_arvalid    ({axi_inter_s1_arvalid, axi_inter_s0_arvalid}),
   .s_axi_arready    ({axi_inter_s1_arready, axi_inter_s0_arready}),
   .s_axi_rid        ({axi_inter_s1_rid    , axi_inter_s0_rid    }),
   .s_axi_rdata      ({axi_inter_s1_rdata  , axi_inter_s0_rdata  }),
   .s_axi_rresp      ({axi_inter_s1_rresp  , axi_inter_s0_rresp  }),
   .s_axi_rlast      ({axi_inter_s1_rlast  , axi_inter_s0_rlast  }),
   .s_axi_rvalid     ({axi_inter_s1_rvalid , axi_inter_s0_rvalid }),
   .s_axi_rready     ({axi_inter_s1_rready , axi_inter_s0_rready }),
   //AXI master interface - Connect to HyperRAM controller
   .m_axi_awid       (axi_inter_m_awid),
   .m_axi_awaddr     (axi_inter_m_awaddr),
   .m_axi_awlen      (axi_inter_m_awlen),
   .m_axi_awsize     (axi_inter_m_awsize),
   .m_axi_awburst    (axi_inter_m_awburst),
   .m_axi_awlock     (axi_inter_m_awlock),
   .m_axi_awcache    (axi_inter_m_awcache),
   .m_axi_awprot     (axi_inter_m_awprot),
   .m_axi_awqos      (axi_inter_m_awqos),
   .m_axi_awregion   (axi_inter_m_awregion),
   .m_axi_awvalid    (axi_inter_m_awvalid),
   .m_axi_awready    (axi_inter_m_awready),
   .m_axi_wdata      (axi_inter_m_wdata),
   .m_axi_wstrb      (axi_inter_m_wstrb),
   .m_axi_wlast      (axi_inter_m_wlast),
   .m_axi_wvalid     (axi_inter_m_wvalid),
   .m_axi_wready     (axi_inter_m_wready),
   .m_axi_bid        (axi_inter_m_bid),
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
   .m_axi_arqos      (axi_inter_m_arqos),
   .m_axi_arregion   (axi_inter_m_arregion),
   .m_axi_arvalid    (axi_inter_m_arvalid),
   .m_axi_arready    (axi_inter_m_arready),
   .m_axi_rid        (axi_inter_m_rid),
   .m_axi_rdata      (axi_inter_m_rdata),
   .m_axi_rresp      (axi_inter_m_rresp),
   .m_axi_rlast      (axi_inter_m_rlast),
   .m_axi_rvalid     (axi_inter_m_rvalid),
   .m_axi_rready     (axi_inter_m_rready)
);

//Convert from half duplex to full duplex of memory controller interface (Connect to HyperRAM controller)
axi_full_to_half_duplex #(
   .DATA_WIDTH (128),
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
