// Generator : SpinalHDL dev    git head : a69f4b9a329be784802c37cd8038b7dc9aec3094
// Component : Axi4PeripheralTop

`timescale 1ns/1ps

module Axi4PeripheralTop (
  input  wire          axi_awvalid,
  output wire          axi_awready,
  input  wire [23:0]   axi_awaddr,
  input  wire [7:0]    axi_awlen,
  input  wire [2:0]    axi_awsize,
  input  wire [3:0]    axi_awcache,
  input  wire [2:0]    axi_awprot,
  input  wire          axi_wvalid,
  output wire          axi_wready,
  input  wire [31:0]   axi_wdata,
  input  wire [3:0]    axi_wstrb,
  input  wire          axi_wlast,
  output wire          axi_bvalid,
  input  wire          axi_bready,
  output wire [1:0]    axi_bresp,
  input  wire          axi_arvalid,
  output wire          axi_arready,
  input  wire [23:0]   axi_araddr,
  input  wire [7:0]    axi_arlen,
  input  wire [2:0]    axi_arsize,
  input  wire [3:0]    axi_arcache,
  input  wire [2:0]    axi_arprot,
  output wire          axi_rvalid,
  input  wire          axi_rready,
  output wire [31:0]   axi_rdata,
  output wire [1:0]    axi_rresp,
  output wire          axi_rlast,
  output wire          system_uart_0_io_txd,
  input  wire          system_uart_0_io_rxd,
  output wire          system_i2c_0_io_sda_write,
  input  wire          system_i2c_0_io_sda_read,
  output wire          system_i2c_0_io_scl_write,
  input  wire          system_i2c_0_io_scl_read,
  output wire [11:0]   io_apbSlave_1_PADDR,
  output wire [0:0]    io_apbSlave_1_PSEL,
  output wire          io_apbSlave_1_PENABLE,
  input  wire          io_apbSlave_1_PREADY,
  output wire          io_apbSlave_1_PWRITE,
  output wire [31:0]   io_apbSlave_1_PWDATA,
  input  wire [31:0]   io_apbSlave_1_PRDATA,
  input  wire          io_apbSlave_1_PSLVERROR,
  output wire [15:0]   io_apbSlave_0_PADDR,
  output wire [0:0]    io_apbSlave_0_PSEL,
  output wire          io_apbSlave_0_PENABLE,
  input  wire          io_apbSlave_0_PREADY,
  output wire          io_apbSlave_0_PWRITE,
  output wire [31:0]   io_apbSlave_0_PWDATA,
  input  wire [31:0]   io_apbSlave_0_PRDATA,
  input  wire          io_apbSlave_0_PSLVERROR,
  output wire          system_uart_0_io_interrupt,
  output wire          system_spi_0_io_interrupt,
  output wire [0:0]    system_spi_0_io_sclk_write,
  output wire          system_spi_0_io_data_0_writeEnable,
  input  wire [0:0]    system_spi_0_io_data_0_read,
  output wire [0:0]    system_spi_0_io_data_0_write,
  output wire          system_spi_0_io_data_1_writeEnable,
  input  wire [0:0]    system_spi_0_io_data_1_read,
  output wire [0:0]    system_spi_0_io_data_1_write,
  output wire          system_spi_0_io_data_2_writeEnable,
  input  wire [0:0]    system_spi_0_io_data_2_read,
  output wire [0:0]    system_spi_0_io_data_2_write,
  output wire          system_spi_0_io_data_3_writeEnable,
  input  wire [0:0]    system_spi_0_io_data_3_read,
  output wire [0:0]    system_spi_0_io_data_3_write,
  output wire [3:0]    system_spi_0_io_ss,
  output wire          system_i2c_0_io_interrupt,
  input  wire          clk,
  input  wire          reset
);

  wire                streamArbiter_io_inputs_0_ready;
  wire                streamArbiter_io_inputs_1_ready;
  wire                streamArbiter_io_output_valid;
  wire       [23:0]   streamArbiter_io_output_payload_addr;
  wire       [7:0]    streamArbiter_io_output_payload_len;
  wire       [2:0]    streamArbiter_io_output_payload_size;
  wire       [3:0]    streamArbiter_io_output_payload_cache;
  wire       [2:0]    streamArbiter_io_output_payload_prot;
  wire       [0:0]    streamArbiter_io_chosen;
  wire       [1:0]    streamArbiter_io_chosenOH;
  wire                axiToBmb_io_axi_arw_ready;
  wire                axiToBmb_io_axi_w_ready;
  wire                axiToBmb_io_axi_b_valid;
  wire       [1:0]    axiToBmb_io_axi_b_payload_resp;
  wire                axiToBmb_io_axi_r_valid;
  wire       [31:0]   axiToBmb_io_axi_r_payload_data;
  wire       [1:0]    axiToBmb_io_axi_r_payload_resp;
  wire                axiToBmb_io_axi_r_payload_last;
  wire                axiToBmb_io_bmb_cmd_valid;
  wire                axiToBmb_io_bmb_cmd_payload_last;
  wire       [0:0]    axiToBmb_io_bmb_cmd_payload_fragment_source;
  wire       [0:0]    axiToBmb_io_bmb_cmd_payload_fragment_opcode;
  wire       [23:0]   axiToBmb_io_bmb_cmd_payload_fragment_address;
  wire       [9:0]    axiToBmb_io_bmb_cmd_payload_fragment_length;
  wire       [31:0]   axiToBmb_io_bmb_cmd_payload_fragment_data;
  wire       [3:0]    axiToBmb_io_bmb_cmd_payload_fragment_mask;
  wire                axiToBmb_io_bmb_rsp_ready;
  wire                bmbHandle_decoder_io_input_cmd_ready;
  wire                bmbHandle_decoder_io_input_rsp_valid;
  wire                bmbHandle_decoder_io_input_rsp_payload_last;
  wire       [0:0]    bmbHandle_decoder_io_input_rsp_payload_fragment_source;
  wire       [0:0]    bmbHandle_decoder_io_input_rsp_payload_fragment_opcode;
  wire       [31:0]   bmbHandle_decoder_io_input_rsp_payload_fragment_data;
  wire                bmbHandle_decoder_io_outputs_0_cmd_valid;
  wire                bmbHandle_decoder_io_outputs_0_cmd_payload_last;
  wire       [0:0]    bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_source;
  wire       [0:0]    bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_address;
  wire       [9:0]    bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_length;
  wire       [31:0]   bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_data;
  wire       [3:0]    bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_mask;
  wire                bmbHandle_decoder_io_outputs_0_rsp_ready;
  wire                bmbHandle_unburstify_io_input_cmd_ready;
  wire                bmbHandle_unburstify_io_input_rsp_valid;
  wire                bmbHandle_unburstify_io_input_rsp_payload_last;
  wire       [0:0]    bmbHandle_unburstify_io_input_rsp_payload_fragment_source;
  wire       [0:0]    bmbHandle_unburstify_io_input_rsp_payload_fragment_opcode;
  wire       [31:0]   bmbHandle_unburstify_io_input_rsp_payload_fragment_data;
  wire                bmbHandle_unburstify_io_output_cmd_valid;
  wire                bmbHandle_unburstify_io_output_cmd_payload_last;
  wire       [0:0]    bmbHandle_unburstify_io_output_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbHandle_unburstify_io_output_cmd_payload_fragment_address;
  wire       [1:0]    bmbHandle_unburstify_io_output_cmd_payload_fragment_length;
  wire       [31:0]   bmbHandle_unburstify_io_output_cmd_payload_fragment_data;
  wire       [3:0]    bmbHandle_unburstify_io_output_cmd_payload_fragment_mask;
  wire       [2:0]    bmbHandle_unburstify_io_output_cmd_payload_fragment_context;
  wire                bmbHandle_unburstify_io_output_rsp_ready;
  wire                bmbPeripheral_bmb_decoder_io_input_cmd_ready;
  wire                bmbPeripheral_bmb_decoder_io_input_rsp_valid;
  wire                bmbPeripheral_bmb_decoder_io_input_rsp_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_decoder_io_input_rsp_payload_fragment_opcode;
  wire       [31:0]   bmbPeripheral_bmb_decoder_io_input_rsp_payload_fragment_data;
  wire       [2:0]    bmbPeripheral_bmb_decoder_io_input_rsp_payload_fragment_context;
  wire                bmbPeripheral_bmb_decoder_io_outputs_0_cmd_valid;
  wire                bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_address;
  wire       [1:0]    bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_length;
  wire       [31:0]   bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_data;
  wire       [3:0]    bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_mask;
  wire       [2:0]    bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_context;
  wire                bmbPeripheral_bmb_decoder_io_outputs_0_rsp_ready;
  wire                bmbPeripheral_bmb_decoder_io_outputs_1_cmd_valid;
  wire                bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_address;
  wire       [1:0]    bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_length;
  wire       [31:0]   bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_data;
  wire       [3:0]    bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_mask;
  wire       [2:0]    bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_context;
  wire                bmbPeripheral_bmb_decoder_io_outputs_1_rsp_ready;
  wire                bmbPeripheral_bmb_decoder_io_outputs_2_cmd_valid;
  wire                bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_address;
  wire       [1:0]    bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_length;
  wire       [31:0]   bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_data;
  wire       [3:0]    bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_mask;
  wire       [2:0]    bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_context;
  wire                bmbPeripheral_bmb_decoder_io_outputs_2_rsp_ready;
  wire                bmbPeripheral_bmb_decoder_io_outputs_3_cmd_valid;
  wire                bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_address;
  wire       [1:0]    bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_length;
  wire       [31:0]   bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_data;
  wire       [3:0]    bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_mask;
  wire       [2:0]    bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_context;
  wire                bmbPeripheral_bmb_decoder_io_outputs_3_rsp_ready;
  wire                bmbPeripheral_bmb_decoder_io_outputs_4_cmd_valid;
  wire                bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_address;
  wire       [1:0]    bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_length;
  wire       [31:0]   bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_data;
  wire       [3:0]    bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_mask;
  wire       [2:0]    bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_context;
  wire                bmbPeripheral_bmb_decoder_io_outputs_4_rsp_ready;
  wire                system_uart_0_io_logic_io_bus_cmd_ready;
  wire                system_uart_0_io_logic_io_bus_rsp_valid;
  wire                system_uart_0_io_logic_io_bus_rsp_payload_last;
  wire       [0:0]    system_uart_0_io_logic_io_bus_rsp_payload_fragment_opcode;
  wire       [31:0]   system_uart_0_io_logic_io_bus_rsp_payload_fragment_data;
  wire       [2:0]    system_uart_0_io_logic_io_bus_rsp_payload_fragment_context;
  wire                system_uart_0_io_logic_io_uart_txd;
  wire                system_uart_0_io_logic_system_uart_0_io_interrupt_source;
  wire                system_spi_0_io_logic_io_ctrl_cmd_ready;
  wire                system_spi_0_io_logic_io_ctrl_rsp_valid;
  wire                system_spi_0_io_logic_io_ctrl_rsp_payload_last;
  wire       [0:0]    system_spi_0_io_logic_io_ctrl_rsp_payload_fragment_opcode;
  wire       [31:0]   system_spi_0_io_logic_io_ctrl_rsp_payload_fragment_data;
  wire       [2:0]    system_spi_0_io_logic_io_ctrl_rsp_payload_fragment_context;
  wire       [0:0]    system_spi_0_io_logic_io_spi_sclk_write;
  wire       [3:0]    system_spi_0_io_logic_io_spi_ss;
  wire       [0:0]    system_spi_0_io_logic_io_spi_data_0_write;
  wire                system_spi_0_io_logic_io_spi_data_0_writeEnable;
  wire       [0:0]    system_spi_0_io_logic_io_spi_data_1_write;
  wire                system_spi_0_io_logic_io_spi_data_1_writeEnable;
  wire       [0:0]    system_spi_0_io_logic_io_spi_data_2_write;
  wire                system_spi_0_io_logic_io_spi_data_2_writeEnable;
  wire       [0:0]    system_spi_0_io_logic_io_spi_data_3_write;
  wire                system_spi_0_io_logic_io_spi_data_3_writeEnable;
  wire                system_spi_0_io_logic_system_spi_0_io_interrupt_source;
  wire                system_i2c_0_io_logic_io_ctrl_cmd_ready;
  wire                system_i2c_0_io_logic_io_ctrl_rsp_valid;
  wire                system_i2c_0_io_logic_io_ctrl_rsp_payload_last;
  wire       [0:0]    system_i2c_0_io_logic_io_ctrl_rsp_payload_fragment_opcode;
  wire       [31:0]   system_i2c_0_io_logic_io_ctrl_rsp_payload_fragment_data;
  wire       [2:0]    system_i2c_0_io_logic_io_ctrl_rsp_payload_fragment_context;
  wire                system_i2c_0_io_logic_io_i2c_scl_write;
  wire                system_i2c_0_io_logic_io_i2c_sda_write;
  wire                system_i2c_0_io_logic_system_i2c_0_io_interrupt_source;
  wire                io_apbSlave_1_logic_io_input_cmd_ready;
  wire                io_apbSlave_1_logic_io_input_rsp_valid;
  wire                io_apbSlave_1_logic_io_input_rsp_payload_last;
  wire       [0:0]    io_apbSlave_1_logic_io_input_rsp_payload_fragment_opcode;
  wire       [31:0]   io_apbSlave_1_logic_io_input_rsp_payload_fragment_data;
  wire       [2:0]    io_apbSlave_1_logic_io_input_rsp_payload_fragment_context;
  wire       [11:0]   io_apbSlave_1_logic_io_output_PADDR;
  wire       [0:0]    io_apbSlave_1_logic_io_output_PSEL;
  wire                io_apbSlave_1_logic_io_output_PENABLE;
  wire                io_apbSlave_1_logic_io_output_PWRITE;
  wire       [31:0]   io_apbSlave_1_logic_io_output_PWDATA;
  wire                io_apbSlave_0_logic_io_input_cmd_ready;
  wire                io_apbSlave_0_logic_io_input_rsp_valid;
  wire                io_apbSlave_0_logic_io_input_rsp_payload_last;
  wire       [0:0]    io_apbSlave_0_logic_io_input_rsp_payload_fragment_opcode;
  wire       [31:0]   io_apbSlave_0_logic_io_input_rsp_payload_fragment_data;
  wire       [2:0]    io_apbSlave_0_logic_io_input_rsp_payload_fragment_context;
  wire       [15:0]   io_apbSlave_0_logic_io_output_PADDR;
  wire       [0:0]    io_apbSlave_0_logic_io_output_PSEL;
  wire                io_apbSlave_0_logic_io_output_PENABLE;
  wire                io_apbSlave_0_logic_io_output_PWRITE;
  wire       [31:0]   io_apbSlave_0_logic_io_output_PWDATA;
  wire                _zz_axiShared_b_ready;
  wire                _zz_axiShared_r_ready;
  wire                axi_aw_halfPipe_valid;
  wire                axi_aw_halfPipe_ready;
  wire       [23:0]   axi_aw_halfPipe_payload_addr;
  wire       [7:0]    axi_aw_halfPipe_payload_len;
  wire       [2:0]    axi_aw_halfPipe_payload_size;
  wire       [3:0]    axi_aw_halfPipe_payload_cache;
  wire       [2:0]    axi_aw_halfPipe_payload_prot;
  reg                 axi_aw_rValid;
  wire                axi_aw_halfPipe_fire;
  reg        [23:0]   axi_aw_rData_addr;
  reg        [7:0]    axi_aw_rData_len;
  reg        [2:0]    axi_aw_rData_size;
  reg        [3:0]    axi_aw_rData_cache;
  reg        [2:0]    axi_aw_rData_prot;
  wire                axi_w_halfPipe_valid;
  wire                axi_w_halfPipe_ready;
  wire       [31:0]   axi_w_halfPipe_payload_data;
  wire       [3:0]    axi_w_halfPipe_payload_strb;
  wire                axi_w_halfPipe_payload_last;
  reg                 axi_w_rValid;
  wire                axi_w_halfPipe_fire;
  reg        [31:0]   axi_w_rData_data;
  reg        [3:0]    axi_w_rData_strb;
  reg                 axi_w_rData_last;
  wire                _zz_axi_bvalid;
  reg                 _zz_axi_bvalid_1;
  reg        [1:0]    _zz_axi_bresp;
  wire                axi_ar_halfPipe_valid;
  wire                axi_ar_halfPipe_ready;
  wire       [23:0]   axi_ar_halfPipe_payload_addr;
  wire       [7:0]    axi_ar_halfPipe_payload_len;
  wire       [2:0]    axi_ar_halfPipe_payload_size;
  wire       [3:0]    axi_ar_halfPipe_payload_cache;
  wire       [2:0]    axi_ar_halfPipe_payload_prot;
  reg                 axi_ar_rValid;
  wire                axi_ar_halfPipe_fire;
  reg        [23:0]   axi_ar_rData_addr;
  reg        [7:0]    axi_ar_rData_len;
  reg        [2:0]    axi_ar_rData_size;
  reg        [3:0]    axi_ar_rData_cache;
  reg        [2:0]    axi_ar_rData_prot;
  wire                _zz_axi_rvalid;
  reg                 _zz_axi_rvalid_1;
  reg        [31:0]   _zz_axi_rdata;
  reg        [1:0]    _zz_axi_rresp;
  reg                 _zz_axi_rlast;
  wire                axiShared_arw_valid;
  wire                axiShared_arw_ready;
  wire       [23:0]   axiShared_arw_payload_addr;
  wire       [7:0]    axiShared_arw_payload_len;
  wire       [2:0]    axiShared_arw_payload_size;
  wire       [3:0]    axiShared_arw_payload_cache;
  wire       [2:0]    axiShared_arw_payload_prot;
  wire                axiShared_arw_payload_write;
  wire                axiShared_w_valid;
  wire                axiShared_w_ready;
  wire       [31:0]   axiShared_w_payload_data;
  wire       [3:0]    axiShared_w_payload_strb;
  wire                axiShared_w_payload_last;
  wire                axiShared_b_valid;
  wire                axiShared_b_ready;
  wire       [1:0]    axiShared_b_payload_resp;
  wire                axiShared_r_valid;
  wire                axiShared_r_ready;
  wire       [31:0]   axiShared_r_payload_data;
  wire       [1:0]    axiShared_r_payload_resp;
  wire                axiShared_r_payload_last;
  wire                bmbPeripheral_bmb_cmd_valid;
  wire                bmbPeripheral_bmb_cmd_ready;
  wire                bmbPeripheral_bmb_cmd_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbPeripheral_bmb_cmd_payload_fragment_address;
  wire       [1:0]    bmbPeripheral_bmb_cmd_payload_fragment_length;
  wire       [31:0]   bmbPeripheral_bmb_cmd_payload_fragment_data;
  wire       [3:0]    bmbPeripheral_bmb_cmd_payload_fragment_mask;
  wire       [2:0]    bmbPeripheral_bmb_cmd_payload_fragment_context;
  wire                bmbPeripheral_bmb_rsp_valid;
  wire                bmbPeripheral_bmb_rsp_ready;
  wire                bmbPeripheral_bmb_rsp_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_rsp_payload_fragment_opcode;
  wire       [31:0]   bmbPeripheral_bmb_rsp_payload_fragment_data;
  wire       [2:0]    bmbPeripheral_bmb_rsp_payload_fragment_context;
  wire                bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid;
  wire                bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  wire                bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
  wire       [1:0]    bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
  wire       [31:0]   bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
  wire       [3:0]    bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_mask;
  wire       [2:0]    bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
  wire                bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  wire                bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready;
  wire                bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  wire       [31:0]   bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  wire       [2:0]    bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
  wire       [0:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
  wire       [5:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
  wire       [1:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
  wire       [31:0]   system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
  wire       [2:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  wire       [0:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  wire       [31:0]   system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  wire       [2:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  wire                _zz_io_bus_rsp_ready;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_ready;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_last;
  wire       [0:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_opcode;
  wire       [5:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_address;
  wire       [1:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_length;
  wire       [31:0]   system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_data;
  wire       [2:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_context;
  reg                 system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid;
  wire                system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_fire;
  reg                 system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_last;
  reg        [0:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_opcode;
  reg        [5:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_address;
  reg        [1:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_length;
  reg        [31:0]   system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_data;
  reg        [2:0]    system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_context;
  wire                _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  reg                 _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid_1;
  reg                 _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  reg        [0:0]    _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  reg        [31:0]   _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  reg        [2:0]    _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
  wire       [0:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
  wire       [11:0]   system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
  wire       [1:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
  wire       [31:0]   system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
  wire       [2:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  wire       [0:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  wire       [31:0]   system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  wire       [2:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_ready;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_last;
  wire       [0:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_opcode;
  wire       [11:0]   system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_address;
  wire       [1:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_length;
  wire       [31:0]   system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_data;
  wire       [2:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_context;
  reg                 system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid;
  wire                system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_fire;
  reg                 system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_last;
  reg        [0:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_opcode;
  reg        [11:0]   system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_address;
  reg        [1:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_length;
  reg        [31:0]   system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_data;
  reg        [2:0]    system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_context;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
  wire       [0:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
  wire       [7:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
  wire       [1:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
  wire       [31:0]   system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
  wire       [2:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  wire       [0:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  wire       [31:0]   system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  wire       [2:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_ready;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_last;
  wire       [0:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_opcode;
  wire       [7:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_address;
  wire       [1:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_length;
  wire       [31:0]   system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_data;
  wire       [2:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_context;
  reg                 system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid;
  wire                system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_fire;
  reg                 system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_last;
  reg        [0:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_opcode;
  reg        [7:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_address;
  reg        [1:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_length;
  reg        [31:0]   system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_data;
  reg        [2:0]    system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_context;
  wire                io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid;
  wire                io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  wire                io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
  wire       [0:0]    io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
  wire       [11:0]   io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
  wire       [1:0]    io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
  wire       [31:0]   io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
  wire       [2:0]    io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
  wire                io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  wire                io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready;
  wire                io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  wire       [0:0]    io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  wire       [31:0]   io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  wire       [2:0]    io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  wire                io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid;
  wire                io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  wire                io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
  wire       [0:0]    io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
  wire       [15:0]   io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
  wire       [1:0]    io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
  wire       [31:0]   io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
  wire       [2:0]    io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
  wire                io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  wire                io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready;
  wire                io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  wire       [0:0]    io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  wire       [31:0]   io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  wire       [2:0]    io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  wire                bmbPeripheral_bmb_withoutMask_cmd_valid;
  wire                bmbPeripheral_bmb_withoutMask_cmd_ready;
  wire                bmbPeripheral_bmb_withoutMask_cmd_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode;
  wire       [23:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address;
  wire       [1:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context;
  wire                bmbPeripheral_bmb_withoutMask_rsp_valid;
  wire                bmbPeripheral_bmb_withoutMask_rsp_ready;
  wire                bmbPeripheral_bmb_withoutMask_rsp_payload_last;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context;
  wire                bmbPeripheral_bmb_withoutMask_cmd_valid_1;
  wire                bmbPeripheral_bmb_withoutMask_cmd_ready_1;
  wire                bmbPeripheral_bmb_withoutMask_cmd_payload_last_1;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_1;
  wire       [23:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_1;
  wire       [1:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_1;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_1;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_1;
  wire                bmbPeripheral_bmb_withoutMask_rsp_valid_1;
  wire                bmbPeripheral_bmb_withoutMask_rsp_ready_1;
  wire                bmbPeripheral_bmb_withoutMask_rsp_payload_last_1;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_1;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_1;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_1;
  wire                bmbPeripheral_bmb_withoutMask_cmd_valid_2;
  wire                bmbPeripheral_bmb_withoutMask_cmd_ready_2;
  wire                bmbPeripheral_bmb_withoutMask_cmd_payload_last_2;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_2;
  wire       [23:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_2;
  wire       [1:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_2;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_2;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_2;
  wire                bmbPeripheral_bmb_withoutMask_rsp_valid_2;
  wire                bmbPeripheral_bmb_withoutMask_rsp_ready_2;
  wire                bmbPeripheral_bmb_withoutMask_rsp_payload_last_2;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_2;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_2;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_2;
  wire                bmbPeripheral_bmb_withoutMask_cmd_valid_3;
  wire                bmbPeripheral_bmb_withoutMask_cmd_ready_3;
  wire                bmbPeripheral_bmb_withoutMask_cmd_payload_last_3;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_3;
  wire       [23:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_3;
  wire       [1:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_3;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_3;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_3;
  wire                bmbPeripheral_bmb_withoutMask_rsp_valid_3;
  wire                bmbPeripheral_bmb_withoutMask_rsp_ready_3;
  wire                bmbPeripheral_bmb_withoutMask_rsp_payload_last_3;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_3;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_3;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_3;
  wire                bmbPeripheral_bmb_withoutMask_cmd_valid_4;
  wire                bmbPeripheral_bmb_withoutMask_cmd_ready_4;
  wire                bmbPeripheral_bmb_withoutMask_cmd_payload_last_4;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_4;
  wire       [23:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_4;
  wire       [1:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_4;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_4;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_4;
  wire                bmbPeripheral_bmb_withoutMask_rsp_valid_4;
  wire                bmbPeripheral_bmb_withoutMask_rsp_ready_4;
  wire                bmbPeripheral_bmb_withoutMask_rsp_payload_last_4;
  wire       [0:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_4;
  wire       [31:0]   bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_4;
  wire       [2:0]    bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_4;

  Axi4PeripheralStreamArbiter streamArbiter (
    .io_inputs_0_valid         (axi_ar_halfPipe_valid                     ), //i
    .io_inputs_0_ready         (streamArbiter_io_inputs_0_ready           ), //o
    .io_inputs_0_payload_addr  (axi_ar_halfPipe_payload_addr[23:0]        ), //i
    .io_inputs_0_payload_len   (axi_ar_halfPipe_payload_len[7:0]          ), //i
    .io_inputs_0_payload_size  (axi_ar_halfPipe_payload_size[2:0]         ), //i
    .io_inputs_0_payload_cache (axi_ar_halfPipe_payload_cache[3:0]        ), //i
    .io_inputs_0_payload_prot  (axi_ar_halfPipe_payload_prot[2:0]         ), //i
    .io_inputs_1_valid         (axi_aw_halfPipe_valid                     ), //i
    .io_inputs_1_ready         (streamArbiter_io_inputs_1_ready           ), //o
    .io_inputs_1_payload_addr  (axi_aw_halfPipe_payload_addr[23:0]        ), //i
    .io_inputs_1_payload_len   (axi_aw_halfPipe_payload_len[7:0]          ), //i
    .io_inputs_1_payload_size  (axi_aw_halfPipe_payload_size[2:0]         ), //i
    .io_inputs_1_payload_cache (axi_aw_halfPipe_payload_cache[3:0]        ), //i
    .io_inputs_1_payload_prot  (axi_aw_halfPipe_payload_prot[2:0]         ), //i
    .io_output_valid           (streamArbiter_io_output_valid             ), //o
    .io_output_ready           (axiShared_arw_ready                       ), //i
    .io_output_payload_addr    (streamArbiter_io_output_payload_addr[23:0]), //o
    .io_output_payload_len     (streamArbiter_io_output_payload_len[7:0]  ), //o
    .io_output_payload_size    (streamArbiter_io_output_payload_size[2:0] ), //o
    .io_output_payload_cache   (streamArbiter_io_output_payload_cache[3:0]), //o
    .io_output_payload_prot    (streamArbiter_io_output_payload_prot[2:0] ), //o
    .io_chosen                 (streamArbiter_io_chosen                   ), //o
    .io_chosenOH               (streamArbiter_io_chosenOH[1:0]            ), //o
    .clk                       (clk                                       ), //i
    .reset                     (reset                                     )  //i
  );
  Axi4PeripheralAxi4SharedToBmb axiToBmb (
    .io_axi_arw_valid                    (axiShared_arw_valid                                       ), //i
    .io_axi_arw_ready                    (axiToBmb_io_axi_arw_ready                                 ), //o
    .io_axi_arw_payload_addr             (axiShared_arw_payload_addr[23:0]                          ), //i
    .io_axi_arw_payload_len              (axiShared_arw_payload_len[7:0]                            ), //i
    .io_axi_arw_payload_size             (axiShared_arw_payload_size[2:0]                           ), //i
    .io_axi_arw_payload_cache            (axiShared_arw_payload_cache[3:0]                          ), //i
    .io_axi_arw_payload_prot             (axiShared_arw_payload_prot[2:0]                           ), //i
    .io_axi_arw_payload_write            (axiShared_arw_payload_write                               ), //i
    .io_axi_w_valid                      (axiShared_w_valid                                         ), //i
    .io_axi_w_ready                      (axiToBmb_io_axi_w_ready                                   ), //o
    .io_axi_w_payload_data               (axiShared_w_payload_data[31:0]                            ), //i
    .io_axi_w_payload_strb               (axiShared_w_payload_strb[3:0]                             ), //i
    .io_axi_w_payload_last               (axiShared_w_payload_last                                  ), //i
    .io_axi_b_valid                      (axiToBmb_io_axi_b_valid                                   ), //o
    .io_axi_b_ready                      (axiShared_b_ready                                         ), //i
    .io_axi_b_payload_resp               (axiToBmb_io_axi_b_payload_resp[1:0]                       ), //o
    .io_axi_r_valid                      (axiToBmb_io_axi_r_valid                                   ), //o
    .io_axi_r_ready                      (axiShared_r_ready                                         ), //i
    .io_axi_r_payload_data               (axiToBmb_io_axi_r_payload_data[31:0]                      ), //o
    .io_axi_r_payload_resp               (axiToBmb_io_axi_r_payload_resp[1:0]                       ), //o
    .io_axi_r_payload_last               (axiToBmb_io_axi_r_payload_last                            ), //o
    .io_bmb_cmd_valid                    (axiToBmb_io_bmb_cmd_valid                                 ), //o
    .io_bmb_cmd_ready                    (bmbHandle_decoder_io_input_cmd_ready                      ), //i
    .io_bmb_cmd_payload_last             (axiToBmb_io_bmb_cmd_payload_last                          ), //o
    .io_bmb_cmd_payload_fragment_source  (axiToBmb_io_bmb_cmd_payload_fragment_source               ), //o
    .io_bmb_cmd_payload_fragment_opcode  (axiToBmb_io_bmb_cmd_payload_fragment_opcode               ), //o
    .io_bmb_cmd_payload_fragment_address (axiToBmb_io_bmb_cmd_payload_fragment_address[23:0]        ), //o
    .io_bmb_cmd_payload_fragment_length  (axiToBmb_io_bmb_cmd_payload_fragment_length[9:0]          ), //o
    .io_bmb_cmd_payload_fragment_data    (axiToBmb_io_bmb_cmd_payload_fragment_data[31:0]           ), //o
    .io_bmb_cmd_payload_fragment_mask    (axiToBmb_io_bmb_cmd_payload_fragment_mask[3:0]            ), //o
    .io_bmb_rsp_valid                    (bmbHandle_decoder_io_input_rsp_valid                      ), //i
    .io_bmb_rsp_ready                    (axiToBmb_io_bmb_rsp_ready                                 ), //o
    .io_bmb_rsp_payload_last             (bmbHandle_decoder_io_input_rsp_payload_last               ), //i
    .io_bmb_rsp_payload_fragment_source  (bmbHandle_decoder_io_input_rsp_payload_fragment_source    ), //i
    .io_bmb_rsp_payload_fragment_opcode  (bmbHandle_decoder_io_input_rsp_payload_fragment_opcode    ), //i
    .io_bmb_rsp_payload_fragment_data    (bmbHandle_decoder_io_input_rsp_payload_fragment_data[31:0])  //i
  );
  Axi4PeripheralBmbDecoder bmbHandle_decoder (
    .io_input_cmd_valid                        (axiToBmb_io_bmb_cmd_valid                                        ), //i
    .io_input_cmd_ready                        (bmbHandle_decoder_io_input_cmd_ready                             ), //o
    .io_input_cmd_payload_last                 (axiToBmb_io_bmb_cmd_payload_last                                 ), //i
    .io_input_cmd_payload_fragment_source      (axiToBmb_io_bmb_cmd_payload_fragment_source                      ), //i
    .io_input_cmd_payload_fragment_opcode      (axiToBmb_io_bmb_cmd_payload_fragment_opcode                      ), //i
    .io_input_cmd_payload_fragment_address     (axiToBmb_io_bmb_cmd_payload_fragment_address[23:0]               ), //i
    .io_input_cmd_payload_fragment_length      (axiToBmb_io_bmb_cmd_payload_fragment_length[9:0]                 ), //i
    .io_input_cmd_payload_fragment_data        (axiToBmb_io_bmb_cmd_payload_fragment_data[31:0]                  ), //i
    .io_input_cmd_payload_fragment_mask        (axiToBmb_io_bmb_cmd_payload_fragment_mask[3:0]                   ), //i
    .io_input_rsp_valid                        (bmbHandle_decoder_io_input_rsp_valid                             ), //o
    .io_input_rsp_ready                        (axiToBmb_io_bmb_rsp_ready                                        ), //i
    .io_input_rsp_payload_last                 (bmbHandle_decoder_io_input_rsp_payload_last                      ), //o
    .io_input_rsp_payload_fragment_source      (bmbHandle_decoder_io_input_rsp_payload_fragment_source           ), //o
    .io_input_rsp_payload_fragment_opcode      (bmbHandle_decoder_io_input_rsp_payload_fragment_opcode           ), //o
    .io_input_rsp_payload_fragment_data        (bmbHandle_decoder_io_input_rsp_payload_fragment_data[31:0]       ), //o
    .io_outputs_0_cmd_valid                    (bmbHandle_decoder_io_outputs_0_cmd_valid                         ), //o
    .io_outputs_0_cmd_ready                    (bmbHandle_unburstify_io_input_cmd_ready                          ), //i
    .io_outputs_0_cmd_payload_last             (bmbHandle_decoder_io_outputs_0_cmd_payload_last                  ), //o
    .io_outputs_0_cmd_payload_fragment_source  (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_source       ), //o
    .io_outputs_0_cmd_payload_fragment_opcode  (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_opcode       ), //o
    .io_outputs_0_cmd_payload_fragment_address (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_address[23:0]), //o
    .io_outputs_0_cmd_payload_fragment_length  (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_length[9:0]  ), //o
    .io_outputs_0_cmd_payload_fragment_data    (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_data[31:0]   ), //o
    .io_outputs_0_cmd_payload_fragment_mask    (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_mask[3:0]    ), //o
    .io_outputs_0_rsp_valid                    (bmbHandle_unburstify_io_input_rsp_valid                          ), //i
    .io_outputs_0_rsp_ready                    (bmbHandle_decoder_io_outputs_0_rsp_ready                         ), //o
    .io_outputs_0_rsp_payload_last             (bmbHandle_unburstify_io_input_rsp_payload_last                   ), //i
    .io_outputs_0_rsp_payload_fragment_source  (bmbHandle_unburstify_io_input_rsp_payload_fragment_source        ), //i
    .io_outputs_0_rsp_payload_fragment_opcode  (bmbHandle_unburstify_io_input_rsp_payload_fragment_opcode        ), //i
    .io_outputs_0_rsp_payload_fragment_data    (bmbHandle_unburstify_io_input_rsp_payload_fragment_data[31:0]    ), //i
    .clk                                       (clk                                                              ), //i
    .reset                                     (reset                                                            )  //i
  );
  Axi4PeripheralBmbUnburstify bmbHandle_unburstify (
    .io_input_cmd_valid                     (bmbHandle_decoder_io_outputs_0_cmd_valid                                                  ), //i
    .io_input_cmd_ready                     (bmbHandle_unburstify_io_input_cmd_ready                                                   ), //o
    .io_input_cmd_payload_last              (bmbHandle_decoder_io_outputs_0_cmd_payload_last                                           ), //i
    .io_input_cmd_payload_fragment_source   (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_source                                ), //i
    .io_input_cmd_payload_fragment_opcode   (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_opcode                                ), //i
    .io_input_cmd_payload_fragment_address  (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_address[23:0]                         ), //i
    .io_input_cmd_payload_fragment_length   (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_length[9:0]                           ), //i
    .io_input_cmd_payload_fragment_data     (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_data[31:0]                            ), //i
    .io_input_cmd_payload_fragment_mask     (bmbHandle_decoder_io_outputs_0_cmd_payload_fragment_mask[3:0]                             ), //i
    .io_input_rsp_valid                     (bmbHandle_unburstify_io_input_rsp_valid                                                   ), //o
    .io_input_rsp_ready                     (bmbHandle_decoder_io_outputs_0_rsp_ready                                                  ), //i
    .io_input_rsp_payload_last              (bmbHandle_unburstify_io_input_rsp_payload_last                                            ), //o
    .io_input_rsp_payload_fragment_source   (bmbHandle_unburstify_io_input_rsp_payload_fragment_source                                 ), //o
    .io_input_rsp_payload_fragment_opcode   (bmbHandle_unburstify_io_input_rsp_payload_fragment_opcode                                 ), //o
    .io_input_rsp_payload_fragment_data     (bmbHandle_unburstify_io_input_rsp_payload_fragment_data[31:0]                             ), //o
    .io_output_cmd_valid                    (bmbHandle_unburstify_io_output_cmd_valid                                                  ), //o
    .io_output_cmd_ready                    (bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready                        ), //i
    .io_output_cmd_payload_last             (bmbHandle_unburstify_io_output_cmd_payload_last                                           ), //o
    .io_output_cmd_payload_fragment_opcode  (bmbHandle_unburstify_io_output_cmd_payload_fragment_opcode                                ), //o
    .io_output_cmd_payload_fragment_address (bmbHandle_unburstify_io_output_cmd_payload_fragment_address[23:0]                         ), //o
    .io_output_cmd_payload_fragment_length  (bmbHandle_unburstify_io_output_cmd_payload_fragment_length[1:0]                           ), //o
    .io_output_cmd_payload_fragment_data    (bmbHandle_unburstify_io_output_cmd_payload_fragment_data[31:0]                            ), //o
    .io_output_cmd_payload_fragment_mask    (bmbHandle_unburstify_io_output_cmd_payload_fragment_mask[3:0]                             ), //o
    .io_output_cmd_payload_fragment_context (bmbHandle_unburstify_io_output_cmd_payload_fragment_context[2:0]                          ), //o
    .io_output_rsp_valid                    (bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid                        ), //i
    .io_output_rsp_ready                    (bmbHandle_unburstify_io_output_rsp_ready                                                  ), //o
    .io_output_rsp_payload_last             (bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last                 ), //i
    .io_output_rsp_payload_fragment_opcode  (bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode      ), //i
    .io_output_rsp_payload_fragment_data    (bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data[31:0]  ), //i
    .io_output_rsp_payload_fragment_context (bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context[2:0]), //i
    .clk                                    (clk                                                                                       ), //i
    .reset                                  (reset                                                                                     )  //i
  );
  Axi4PeripheralBmbDecoder_1 bmbPeripheral_bmb_decoder (
    .io_input_cmd_valid                        (bmbPeripheral_bmb_cmd_valid                                              ), //i
    .io_input_cmd_ready                        (bmbPeripheral_bmb_decoder_io_input_cmd_ready                             ), //o
    .io_input_cmd_payload_last                 (bmbPeripheral_bmb_cmd_payload_last                                       ), //i
    .io_input_cmd_payload_fragment_opcode      (bmbPeripheral_bmb_cmd_payload_fragment_opcode                            ), //i
    .io_input_cmd_payload_fragment_address     (bmbPeripheral_bmb_cmd_payload_fragment_address[23:0]                     ), //i
    .io_input_cmd_payload_fragment_length      (bmbPeripheral_bmb_cmd_payload_fragment_length[1:0]                       ), //i
    .io_input_cmd_payload_fragment_data        (bmbPeripheral_bmb_cmd_payload_fragment_data[31:0]                        ), //i
    .io_input_cmd_payload_fragment_mask        (bmbPeripheral_bmb_cmd_payload_fragment_mask[3:0]                         ), //i
    .io_input_cmd_payload_fragment_context     (bmbPeripheral_bmb_cmd_payload_fragment_context[2:0]                      ), //i
    .io_input_rsp_valid                        (bmbPeripheral_bmb_decoder_io_input_rsp_valid                             ), //o
    .io_input_rsp_ready                        (bmbPeripheral_bmb_rsp_ready                                              ), //i
    .io_input_rsp_payload_last                 (bmbPeripheral_bmb_decoder_io_input_rsp_payload_last                      ), //o
    .io_input_rsp_payload_fragment_opcode      (bmbPeripheral_bmb_decoder_io_input_rsp_payload_fragment_opcode           ), //o
    .io_input_rsp_payload_fragment_data        (bmbPeripheral_bmb_decoder_io_input_rsp_payload_fragment_data[31:0]       ), //o
    .io_input_rsp_payload_fragment_context     (bmbPeripheral_bmb_decoder_io_input_rsp_payload_fragment_context[2:0]     ), //o
    .io_outputs_0_cmd_valid                    (bmbPeripheral_bmb_decoder_io_outputs_0_cmd_valid                         ), //o
    .io_outputs_0_cmd_ready                    (bmbPeripheral_bmb_withoutMask_cmd_ready                                  ), //i
    .io_outputs_0_cmd_payload_last             (bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_last                  ), //o
    .io_outputs_0_cmd_payload_fragment_opcode  (bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_opcode       ), //o
    .io_outputs_0_cmd_payload_fragment_address (bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_address[23:0]), //o
    .io_outputs_0_cmd_payload_fragment_length  (bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_length[1:0]  ), //o
    .io_outputs_0_cmd_payload_fragment_data    (bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_data[31:0]   ), //o
    .io_outputs_0_cmd_payload_fragment_mask    (bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_mask[3:0]    ), //o
    .io_outputs_0_cmd_payload_fragment_context (bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_context[2:0] ), //o
    .io_outputs_0_rsp_valid                    (bmbPeripheral_bmb_withoutMask_rsp_valid                                  ), //i
    .io_outputs_0_rsp_ready                    (bmbPeripheral_bmb_decoder_io_outputs_0_rsp_ready                         ), //o
    .io_outputs_0_rsp_payload_last             (bmbPeripheral_bmb_withoutMask_rsp_payload_last                           ), //i
    .io_outputs_0_rsp_payload_fragment_opcode  (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode                ), //i
    .io_outputs_0_rsp_payload_fragment_data    (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data[31:0]            ), //i
    .io_outputs_0_rsp_payload_fragment_context (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context[2:0]          ), //i
    .io_outputs_1_cmd_valid                    (bmbPeripheral_bmb_decoder_io_outputs_1_cmd_valid                         ), //o
    .io_outputs_1_cmd_ready                    (bmbPeripheral_bmb_withoutMask_cmd_ready_1                                ), //i
    .io_outputs_1_cmd_payload_last             (bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_last                  ), //o
    .io_outputs_1_cmd_payload_fragment_opcode  (bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_opcode       ), //o
    .io_outputs_1_cmd_payload_fragment_address (bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_address[23:0]), //o
    .io_outputs_1_cmd_payload_fragment_length  (bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_length[1:0]  ), //o
    .io_outputs_1_cmd_payload_fragment_data    (bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_data[31:0]   ), //o
    .io_outputs_1_cmd_payload_fragment_mask    (bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_mask[3:0]    ), //o
    .io_outputs_1_cmd_payload_fragment_context (bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_context[2:0] ), //o
    .io_outputs_1_rsp_valid                    (bmbPeripheral_bmb_withoutMask_rsp_valid_1                                ), //i
    .io_outputs_1_rsp_ready                    (bmbPeripheral_bmb_decoder_io_outputs_1_rsp_ready                         ), //o
    .io_outputs_1_rsp_payload_last             (bmbPeripheral_bmb_withoutMask_rsp_payload_last_1                         ), //i
    .io_outputs_1_rsp_payload_fragment_opcode  (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_1              ), //i
    .io_outputs_1_rsp_payload_fragment_data    (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_1[31:0]          ), //i
    .io_outputs_1_rsp_payload_fragment_context (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_1[2:0]        ), //i
    .io_outputs_2_cmd_valid                    (bmbPeripheral_bmb_decoder_io_outputs_2_cmd_valid                         ), //o
    .io_outputs_2_cmd_ready                    (bmbPeripheral_bmb_withoutMask_cmd_ready_2                                ), //i
    .io_outputs_2_cmd_payload_last             (bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_last                  ), //o
    .io_outputs_2_cmd_payload_fragment_opcode  (bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_opcode       ), //o
    .io_outputs_2_cmd_payload_fragment_address (bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_address[23:0]), //o
    .io_outputs_2_cmd_payload_fragment_length  (bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_length[1:0]  ), //o
    .io_outputs_2_cmd_payload_fragment_data    (bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_data[31:0]   ), //o
    .io_outputs_2_cmd_payload_fragment_mask    (bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_mask[3:0]    ), //o
    .io_outputs_2_cmd_payload_fragment_context (bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_context[2:0] ), //o
    .io_outputs_2_rsp_valid                    (bmbPeripheral_bmb_withoutMask_rsp_valid_2                                ), //i
    .io_outputs_2_rsp_ready                    (bmbPeripheral_bmb_decoder_io_outputs_2_rsp_ready                         ), //o
    .io_outputs_2_rsp_payload_last             (bmbPeripheral_bmb_withoutMask_rsp_payload_last_2                         ), //i
    .io_outputs_2_rsp_payload_fragment_opcode  (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_2              ), //i
    .io_outputs_2_rsp_payload_fragment_data    (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_2[31:0]          ), //i
    .io_outputs_2_rsp_payload_fragment_context (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_2[2:0]        ), //i
    .io_outputs_3_cmd_valid                    (bmbPeripheral_bmb_decoder_io_outputs_3_cmd_valid                         ), //o
    .io_outputs_3_cmd_ready                    (bmbPeripheral_bmb_withoutMask_cmd_ready_3                                ), //i
    .io_outputs_3_cmd_payload_last             (bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_last                  ), //o
    .io_outputs_3_cmd_payload_fragment_opcode  (bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_opcode       ), //o
    .io_outputs_3_cmd_payload_fragment_address (bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_address[23:0]), //o
    .io_outputs_3_cmd_payload_fragment_length  (bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_length[1:0]  ), //o
    .io_outputs_3_cmd_payload_fragment_data    (bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_data[31:0]   ), //o
    .io_outputs_3_cmd_payload_fragment_mask    (bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_mask[3:0]    ), //o
    .io_outputs_3_cmd_payload_fragment_context (bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_context[2:0] ), //o
    .io_outputs_3_rsp_valid                    (bmbPeripheral_bmb_withoutMask_rsp_valid_3                                ), //i
    .io_outputs_3_rsp_ready                    (bmbPeripheral_bmb_decoder_io_outputs_3_rsp_ready                         ), //o
    .io_outputs_3_rsp_payload_last             (bmbPeripheral_bmb_withoutMask_rsp_payload_last_3                         ), //i
    .io_outputs_3_rsp_payload_fragment_opcode  (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_3              ), //i
    .io_outputs_3_rsp_payload_fragment_data    (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_3[31:0]          ), //i
    .io_outputs_3_rsp_payload_fragment_context (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_3[2:0]        ), //i
    .io_outputs_4_cmd_valid                    (bmbPeripheral_bmb_decoder_io_outputs_4_cmd_valid                         ), //o
    .io_outputs_4_cmd_ready                    (bmbPeripheral_bmb_withoutMask_cmd_ready_4                                ), //i
    .io_outputs_4_cmd_payload_last             (bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_last                  ), //o
    .io_outputs_4_cmd_payload_fragment_opcode  (bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_opcode       ), //o
    .io_outputs_4_cmd_payload_fragment_address (bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_address[23:0]), //o
    .io_outputs_4_cmd_payload_fragment_length  (bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_length[1:0]  ), //o
    .io_outputs_4_cmd_payload_fragment_data    (bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_data[31:0]   ), //o
    .io_outputs_4_cmd_payload_fragment_mask    (bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_mask[3:0]    ), //o
    .io_outputs_4_cmd_payload_fragment_context (bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_context[2:0] ), //o
    .io_outputs_4_rsp_valid                    (bmbPeripheral_bmb_withoutMask_rsp_valid_4                                ), //i
    .io_outputs_4_rsp_ready                    (bmbPeripheral_bmb_decoder_io_outputs_4_rsp_ready                         ), //o
    .io_outputs_4_rsp_payload_last             (bmbPeripheral_bmb_withoutMask_rsp_payload_last_4                         ), //i
    .io_outputs_4_rsp_payload_fragment_opcode  (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_4              ), //i
    .io_outputs_4_rsp_payload_fragment_data    (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_4[31:0]          ), //i
    .io_outputs_4_rsp_payload_fragment_context (bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_4[2:0]        ), //i
    .clk                                       (clk                                                                      ), //i
    .reset                                     (reset                                                                    )  //i
  );
  Axi4PeripheralBmbUartCtrl system_uart_0_io_logic (
    .io_bus_cmd_valid                    (system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid                        ), //i
    .io_bus_cmd_ready                    (system_uart_0_io_logic_io_bus_cmd_ready                                                                ), //o
    .io_bus_cmd_payload_last             (system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_last                 ), //i
    .io_bus_cmd_payload_fragment_opcode  (system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_opcode      ), //i
    .io_bus_cmd_payload_fragment_address (system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_address[5:0]), //i
    .io_bus_cmd_payload_fragment_length  (system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_length[1:0] ), //i
    .io_bus_cmd_payload_fragment_data    (system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_data[31:0]  ), //i
    .io_bus_cmd_payload_fragment_context (system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_context[2:0]), //i
    .io_bus_rsp_valid                    (system_uart_0_io_logic_io_bus_rsp_valid                                                                ), //o
    .io_bus_rsp_ready                    (_zz_io_bus_rsp_ready                                                                                   ), //i
    .io_bus_rsp_payload_last             (system_uart_0_io_logic_io_bus_rsp_payload_last                                                         ), //o
    .io_bus_rsp_payload_fragment_opcode  (system_uart_0_io_logic_io_bus_rsp_payload_fragment_opcode                                              ), //o
    .io_bus_rsp_payload_fragment_data    (system_uart_0_io_logic_io_bus_rsp_payload_fragment_data[31:0]                                          ), //o
    .io_bus_rsp_payload_fragment_context (system_uart_0_io_logic_io_bus_rsp_payload_fragment_context[2:0]                                        ), //o
    .io_uart_txd                         (system_uart_0_io_logic_io_uart_txd                                                                     ), //o
    .io_uart_rxd                         (system_uart_0_io_rxd                                                                                   ), //i
    .system_uart_0_io_interrupt_source   (system_uart_0_io_logic_system_uart_0_io_interrupt_source                                               ), //o
    .clk                                 (clk                                                                                                    ), //i
    .reset                               (reset                                                                                                  )  //i
  );
  Axi4PeripheralBmbSpiXdrMasterCtrl system_spi_0_io_logic (
    .io_ctrl_cmd_valid                    (system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid                         ), //i
    .io_ctrl_cmd_ready                    (system_spi_0_io_logic_io_ctrl_cmd_ready                                                                ), //o
    .io_ctrl_cmd_payload_last             (system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_last                  ), //i
    .io_ctrl_cmd_payload_fragment_opcode  (system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_opcode       ), //i
    .io_ctrl_cmd_payload_fragment_address (system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_address[11:0]), //i
    .io_ctrl_cmd_payload_fragment_length  (system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_length[1:0]  ), //i
    .io_ctrl_cmd_payload_fragment_data    (system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_data[31:0]   ), //i
    .io_ctrl_cmd_payload_fragment_context (system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_context[2:0] ), //i
    .io_ctrl_rsp_valid                    (system_spi_0_io_logic_io_ctrl_rsp_valid                                                                ), //o
    .io_ctrl_rsp_ready                    (system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready                                  ), //i
    .io_ctrl_rsp_payload_last             (system_spi_0_io_logic_io_ctrl_rsp_payload_last                                                         ), //o
    .io_ctrl_rsp_payload_fragment_opcode  (system_spi_0_io_logic_io_ctrl_rsp_payload_fragment_opcode                                              ), //o
    .io_ctrl_rsp_payload_fragment_data    (system_spi_0_io_logic_io_ctrl_rsp_payload_fragment_data[31:0]                                          ), //o
    .io_ctrl_rsp_payload_fragment_context (system_spi_0_io_logic_io_ctrl_rsp_payload_fragment_context[2:0]                                        ), //o
    .io_spi_sclk_write                    (system_spi_0_io_logic_io_spi_sclk_write                                                                ), //o
    .io_spi_data_0_writeEnable            (system_spi_0_io_logic_io_spi_data_0_writeEnable                                                        ), //o
    .io_spi_data_0_read                   (system_spi_0_io_data_0_read                                                                            ), //i
    .io_spi_data_0_write                  (system_spi_0_io_logic_io_spi_data_0_write                                                              ), //o
    .io_spi_data_1_writeEnable            (system_spi_0_io_logic_io_spi_data_1_writeEnable                                                        ), //o
    .io_spi_data_1_read                   (system_spi_0_io_data_1_read                                                                            ), //i
    .io_spi_data_1_write                  (system_spi_0_io_logic_io_spi_data_1_write                                                              ), //o
    .io_spi_data_2_writeEnable            (system_spi_0_io_logic_io_spi_data_2_writeEnable                                                        ), //o
    .io_spi_data_2_read                   (system_spi_0_io_data_2_read                                                                            ), //i
    .io_spi_data_2_write                  (system_spi_0_io_logic_io_spi_data_2_write                                                              ), //o
    .io_spi_data_3_writeEnable            (system_spi_0_io_logic_io_spi_data_3_writeEnable                                                        ), //o
    .io_spi_data_3_read                   (system_spi_0_io_data_3_read                                                                            ), //i
    .io_spi_data_3_write                  (system_spi_0_io_logic_io_spi_data_3_write                                                              ), //o
    .io_spi_ss                            (system_spi_0_io_logic_io_spi_ss[3:0]                                                                   ), //o
    .system_spi_0_io_interrupt_source     (system_spi_0_io_logic_system_spi_0_io_interrupt_source                                                 ), //o
    .clk                                  (clk                                                                                                    ), //i
    .reset                                (reset                                                                                                  )  //i
  );
  Axi4PeripheralBmbI2cCtrl system_i2c_0_io_logic (
    .io_ctrl_cmd_valid                    (system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid                        ), //i
    .io_ctrl_cmd_ready                    (system_i2c_0_io_logic_io_ctrl_cmd_ready                                                               ), //o
    .io_ctrl_cmd_payload_last             (system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_last                 ), //i
    .io_ctrl_cmd_payload_fragment_opcode  (system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_opcode      ), //i
    .io_ctrl_cmd_payload_fragment_address (system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_address[7:0]), //i
    .io_ctrl_cmd_payload_fragment_length  (system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_length[1:0] ), //i
    .io_ctrl_cmd_payload_fragment_data    (system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_data[31:0]  ), //i
    .io_ctrl_cmd_payload_fragment_context (system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_context[2:0]), //i
    .io_ctrl_rsp_valid                    (system_i2c_0_io_logic_io_ctrl_rsp_valid                                                               ), //o
    .io_ctrl_rsp_ready                    (system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready                                 ), //i
    .io_ctrl_rsp_payload_last             (system_i2c_0_io_logic_io_ctrl_rsp_payload_last                                                        ), //o
    .io_ctrl_rsp_payload_fragment_opcode  (system_i2c_0_io_logic_io_ctrl_rsp_payload_fragment_opcode                                             ), //o
    .io_ctrl_rsp_payload_fragment_data    (system_i2c_0_io_logic_io_ctrl_rsp_payload_fragment_data[31:0]                                         ), //o
    .io_ctrl_rsp_payload_fragment_context (system_i2c_0_io_logic_io_ctrl_rsp_payload_fragment_context[2:0]                                       ), //o
    .io_i2c_sda_write                     (system_i2c_0_io_logic_io_i2c_sda_write                                                                ), //o
    .io_i2c_sda_read                      (system_i2c_0_io_sda_read                                                                              ), //i
    .io_i2c_scl_write                     (system_i2c_0_io_logic_io_i2c_scl_write                                                                ), //o
    .io_i2c_scl_read                      (system_i2c_0_io_scl_read                                                                              ), //i
    .system_i2c_0_io_interrupt_source     (system_i2c_0_io_logic_system_i2c_0_io_interrupt_source                                                ), //o
    .clk                                  (clk                                                                                                   ), //i
    .reset                                (reset                                                                                                 )  //i
  );
  Axi4PeripheralBmbToApb3Bridge io_apbSlave_1_logic (
    .io_input_cmd_valid                    (io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid                         ), //i
    .io_input_cmd_ready                    (io_apbSlave_1_logic_io_input_cmd_ready                                                       ), //o
    .io_input_cmd_payload_last             (io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last                  ), //i
    .io_input_cmd_payload_fragment_opcode  (io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode       ), //i
    .io_input_cmd_payload_fragment_address (io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address[11:0]), //i
    .io_input_cmd_payload_fragment_length  (io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length[1:0]  ), //i
    .io_input_cmd_payload_fragment_data    (io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data[31:0]   ), //i
    .io_input_cmd_payload_fragment_context (io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context[2:0] ), //i
    .io_input_rsp_valid                    (io_apbSlave_1_logic_io_input_rsp_valid                                                       ), //o
    .io_input_rsp_ready                    (io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready                         ), //i
    .io_input_rsp_payload_last             (io_apbSlave_1_logic_io_input_rsp_payload_last                                                ), //o
    .io_input_rsp_payload_fragment_opcode  (io_apbSlave_1_logic_io_input_rsp_payload_fragment_opcode                                     ), //o
    .io_input_rsp_payload_fragment_data    (io_apbSlave_1_logic_io_input_rsp_payload_fragment_data[31:0]                                 ), //o
    .io_input_rsp_payload_fragment_context (io_apbSlave_1_logic_io_input_rsp_payload_fragment_context[2:0]                               ), //o
    .io_output_PADDR                       (io_apbSlave_1_logic_io_output_PADDR[11:0]                                                    ), //o
    .io_output_PSEL                        (io_apbSlave_1_logic_io_output_PSEL                                                           ), //o
    .io_output_PENABLE                     (io_apbSlave_1_logic_io_output_PENABLE                                                        ), //o
    .io_output_PREADY                      (io_apbSlave_1_PREADY                                                                         ), //i
    .io_output_PWRITE                      (io_apbSlave_1_logic_io_output_PWRITE                                                         ), //o
    .io_output_PWDATA                      (io_apbSlave_1_logic_io_output_PWDATA[31:0]                                                   ), //o
    .io_output_PRDATA                      (io_apbSlave_1_PRDATA[31:0]                                                                   ), //i
    .io_output_PSLVERROR                   (io_apbSlave_1_PSLVERROR                                                                      ), //i
    .clk                                   (clk                                                                                          ), //i
    .reset                                 (reset                                                                                        )  //i
  );
  Axi4PeripheralBmbToApb3Bridge_1 io_apbSlave_0_logic (
    .io_input_cmd_valid                    (io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid                         ), //i
    .io_input_cmd_ready                    (io_apbSlave_0_logic_io_input_cmd_ready                                                       ), //o
    .io_input_cmd_payload_last             (io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last                  ), //i
    .io_input_cmd_payload_fragment_opcode  (io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode       ), //i
    .io_input_cmd_payload_fragment_address (io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address[15:0]), //i
    .io_input_cmd_payload_fragment_length  (io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length[1:0]  ), //i
    .io_input_cmd_payload_fragment_data    (io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data[31:0]   ), //i
    .io_input_cmd_payload_fragment_context (io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context[2:0] ), //i
    .io_input_rsp_valid                    (io_apbSlave_0_logic_io_input_rsp_valid                                                       ), //o
    .io_input_rsp_ready                    (io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready                         ), //i
    .io_input_rsp_payload_last             (io_apbSlave_0_logic_io_input_rsp_payload_last                                                ), //o
    .io_input_rsp_payload_fragment_opcode  (io_apbSlave_0_logic_io_input_rsp_payload_fragment_opcode                                     ), //o
    .io_input_rsp_payload_fragment_data    (io_apbSlave_0_logic_io_input_rsp_payload_fragment_data[31:0]                                 ), //o
    .io_input_rsp_payload_fragment_context (io_apbSlave_0_logic_io_input_rsp_payload_fragment_context[2:0]                               ), //o
    .io_output_PADDR                       (io_apbSlave_0_logic_io_output_PADDR[15:0]                                                    ), //o
    .io_output_PSEL                        (io_apbSlave_0_logic_io_output_PSEL                                                           ), //o
    .io_output_PENABLE                     (io_apbSlave_0_logic_io_output_PENABLE                                                        ), //o
    .io_output_PREADY                      (io_apbSlave_0_PREADY                                                                         ), //i
    .io_output_PWRITE                      (io_apbSlave_0_logic_io_output_PWRITE                                                         ), //o
    .io_output_PWDATA                      (io_apbSlave_0_logic_io_output_PWDATA[31:0]                                                   ), //o
    .io_output_PRDATA                      (io_apbSlave_0_PRDATA[31:0]                                                                   ), //i
    .io_output_PSLVERROR                   (io_apbSlave_0_PSLVERROR                                                                      ), //i
    .clk                                   (clk                                                                                          ), //i
    .reset                                 (reset                                                                                        )  //i
  );
  assign axi_aw_halfPipe_fire = (axi_aw_halfPipe_valid && axi_aw_halfPipe_ready);
  assign axi_awready = (! axi_aw_rValid);
  assign axi_aw_halfPipe_valid = axi_aw_rValid;
  assign axi_aw_halfPipe_payload_addr = axi_aw_rData_addr;
  assign axi_aw_halfPipe_payload_len = axi_aw_rData_len;
  assign axi_aw_halfPipe_payload_size = axi_aw_rData_size;
  assign axi_aw_halfPipe_payload_cache = axi_aw_rData_cache;
  assign axi_aw_halfPipe_payload_prot = axi_aw_rData_prot;
  assign axi_aw_halfPipe_ready = streamArbiter_io_inputs_1_ready;
  assign axi_w_halfPipe_fire = (axi_w_halfPipe_valid && axi_w_halfPipe_ready);
  assign axi_wready = (! axi_w_rValid);
  assign axi_w_halfPipe_valid = axi_w_rValid;
  assign axi_w_halfPipe_payload_data = axi_w_rData_data;
  assign axi_w_halfPipe_payload_strb = axi_w_rData_strb;
  assign axi_w_halfPipe_payload_last = axi_w_rData_last;
  assign axi_w_halfPipe_ready = axiShared_w_ready;
  assign _zz_axiShared_b_ready = (! _zz_axi_bvalid_1);
  assign _zz_axi_bvalid = _zz_axi_bvalid_1;
  assign axi_bvalid = _zz_axi_bvalid;
  assign axi_bresp = _zz_axi_bresp;
  assign axi_ar_halfPipe_fire = (axi_ar_halfPipe_valid && axi_ar_halfPipe_ready);
  assign axi_arready = (! axi_ar_rValid);
  assign axi_ar_halfPipe_valid = axi_ar_rValid;
  assign axi_ar_halfPipe_payload_addr = axi_ar_rData_addr;
  assign axi_ar_halfPipe_payload_len = axi_ar_rData_len;
  assign axi_ar_halfPipe_payload_size = axi_ar_rData_size;
  assign axi_ar_halfPipe_payload_cache = axi_ar_rData_cache;
  assign axi_ar_halfPipe_payload_prot = axi_ar_rData_prot;
  assign axi_ar_halfPipe_ready = streamArbiter_io_inputs_0_ready;
  assign _zz_axiShared_r_ready = (! _zz_axi_rvalid_1);
  assign _zz_axi_rvalid = _zz_axi_rvalid_1;
  assign axi_rvalid = _zz_axi_rvalid;
  assign axi_rdata = _zz_axi_rdata;
  assign axi_rresp = _zz_axi_rresp;
  assign axi_rlast = _zz_axi_rlast;
  assign axiShared_arw_valid = streamArbiter_io_output_valid;
  assign axiShared_arw_payload_addr = streamArbiter_io_output_payload_addr;
  assign axiShared_arw_payload_len = streamArbiter_io_output_payload_len;
  assign axiShared_arw_payload_size = streamArbiter_io_output_payload_size;
  assign axiShared_arw_payload_cache = streamArbiter_io_output_payload_cache;
  assign axiShared_arw_payload_prot = streamArbiter_io_output_payload_prot;
  assign axiShared_arw_payload_write = streamArbiter_io_chosenOH[1];
  assign axiShared_w_valid = axi_w_halfPipe_valid;
  assign axiShared_w_payload_data = axi_w_halfPipe_payload_data;
  assign axiShared_w_payload_strb = axi_w_halfPipe_payload_strb;
  assign axiShared_w_payload_last = axi_w_halfPipe_payload_last;
  assign axiShared_b_ready = _zz_axiShared_b_ready;
  assign axiShared_r_ready = _zz_axiShared_r_ready;
  assign axiShared_arw_ready = axiToBmb_io_axi_arw_ready;
  assign axiShared_w_ready = axiToBmb_io_axi_w_ready;
  assign axiShared_b_valid = axiToBmb_io_axi_b_valid;
  assign axiShared_b_payload_resp = axiToBmb_io_axi_b_payload_resp;
  assign axiShared_r_valid = axiToBmb_io_axi_r_valid;
  assign axiShared_r_payload_data = axiToBmb_io_axi_r_payload_data;
  assign axiShared_r_payload_last = axiToBmb_io_axi_r_payload_last;
  assign axiShared_r_payload_resp = axiToBmb_io_axi_r_payload_resp;
  assign bmbPeripheral_bmb_cmd_valid = bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready = bmbPeripheral_bmb_cmd_ready;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid = bmbPeripheral_bmb_rsp_valid;
  assign bmbPeripheral_bmb_rsp_ready = bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready;
  assign bmbPeripheral_bmb_cmd_payload_last = bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last = bmbPeripheral_bmb_rsp_payload_last;
  assign bmbPeripheral_bmb_cmd_payload_fragment_opcode = bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
  assign bmbPeripheral_bmb_cmd_payload_fragment_address = bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
  assign bmbPeripheral_bmb_cmd_payload_fragment_length = bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
  assign bmbPeripheral_bmb_cmd_payload_fragment_data = bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
  assign bmbPeripheral_bmb_cmd_payload_fragment_mask = bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_mask;
  assign bmbPeripheral_bmb_cmd_payload_fragment_context = bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode = bmbPeripheral_bmb_rsp_payload_fragment_opcode;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data = bmbPeripheral_bmb_rsp_payload_fragment_data;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context = bmbPeripheral_bmb_rsp_payload_fragment_context;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid = bmbHandle_unburstify_io_output_cmd_valid;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready = bmbHandle_unburstify_io_output_rsp_ready;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last = bmbHandle_unburstify_io_output_cmd_payload_last;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode = bmbHandle_unburstify_io_output_cmd_payload_fragment_opcode;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address = bmbHandle_unburstify_io_output_cmd_payload_fragment_address;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length = bmbHandle_unburstify_io_output_cmd_payload_fragment_length;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data = bmbHandle_unburstify_io_output_cmd_payload_fragment_data;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_mask = bmbHandle_unburstify_io_output_cmd_payload_fragment_mask;
  assign bmbPeripheral_bmb_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context = bmbHandle_unburstify_io_output_cmd_payload_fragment_context;
  assign bmbPeripheral_bmb_cmd_ready = bmbPeripheral_bmb_decoder_io_input_cmd_ready;
  assign bmbPeripheral_bmb_rsp_valid = bmbPeripheral_bmb_decoder_io_input_rsp_valid;
  assign bmbPeripheral_bmb_rsp_payload_last = bmbPeripheral_bmb_decoder_io_input_rsp_payload_last;
  assign bmbPeripheral_bmb_rsp_payload_fragment_opcode = bmbPeripheral_bmb_decoder_io_input_rsp_payload_fragment_opcode;
  assign bmbPeripheral_bmb_rsp_payload_fragment_data = bmbPeripheral_bmb_decoder_io_input_rsp_payload_fragment_data;
  assign bmbPeripheral_bmb_rsp_payload_fragment_context = bmbPeripheral_bmb_decoder_io_input_rsp_payload_fragment_context;
  assign system_uart_0_io_txd = system_uart_0_io_logic_io_uart_txd;
  assign system_i2c_0_io_sda_write = system_i2c_0_io_logic_io_i2c_sda_write;
  assign system_i2c_0_io_scl_write = system_i2c_0_io_logic_io_i2c_scl_write;
  assign io_apbSlave_1_PADDR = io_apbSlave_1_logic_io_output_PADDR;
  assign io_apbSlave_1_PSEL = io_apbSlave_1_logic_io_output_PSEL;
  assign io_apbSlave_1_PENABLE = io_apbSlave_1_logic_io_output_PENABLE;
  assign io_apbSlave_1_PWRITE = io_apbSlave_1_logic_io_output_PWRITE;
  assign io_apbSlave_1_PWDATA = io_apbSlave_1_logic_io_output_PWDATA;
  assign io_apbSlave_0_PADDR = io_apbSlave_0_logic_io_output_PADDR;
  assign io_apbSlave_0_PSEL = io_apbSlave_0_logic_io_output_PSEL;
  assign io_apbSlave_0_PENABLE = io_apbSlave_0_logic_io_output_PENABLE;
  assign io_apbSlave_0_PWRITE = io_apbSlave_0_logic_io_output_PWRITE;
  assign io_apbSlave_0_PWDATA = io_apbSlave_0_logic_io_output_PWDATA;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_fire = (system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid && system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_ready);
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready = (! system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid);
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_last = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_last;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_opcode = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_opcode;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_address = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_address;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_length = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_length;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_data = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_data;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_context = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_context;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_ready = system_uart_0_io_logic_io_bus_cmd_ready;
  assign _zz_io_bus_rsp_ready = (! _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid_1);
  assign _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid = _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid_1;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid = _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last = _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode = _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data = _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context = _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  assign system_uart_0_io_interrupt = system_uart_0_io_logic_system_uart_0_io_interrupt_source;
  assign system_spi_0_io_interrupt = system_spi_0_io_logic_system_spi_0_io_interrupt_source;
  assign system_spi_0_io_sclk_write = system_spi_0_io_logic_io_spi_sclk_write;
  assign system_spi_0_io_data_0_writeEnable = system_spi_0_io_logic_io_spi_data_0_writeEnable;
  assign system_spi_0_io_data_0_write = system_spi_0_io_logic_io_spi_data_0_write;
  assign system_spi_0_io_data_1_writeEnable = system_spi_0_io_logic_io_spi_data_1_writeEnable;
  assign system_spi_0_io_data_1_write = system_spi_0_io_logic_io_spi_data_1_write;
  assign system_spi_0_io_data_2_writeEnable = system_spi_0_io_logic_io_spi_data_2_writeEnable;
  assign system_spi_0_io_data_2_write = system_spi_0_io_logic_io_spi_data_2_write;
  assign system_spi_0_io_data_3_writeEnable = system_spi_0_io_logic_io_spi_data_3_writeEnable;
  assign system_spi_0_io_data_3_write = system_spi_0_io_logic_io_spi_data_3_write;
  assign system_spi_0_io_ss = system_spi_0_io_logic_io_spi_ss;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_fire = (system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid && system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_ready);
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready = (! system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid);
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_last = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_last;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_opcode = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_opcode;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_address = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_address;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_length = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_length;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_data = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_data;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_context = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_context;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_ready = system_spi_0_io_logic_io_ctrl_cmd_ready;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid = system_spi_0_io_logic_io_ctrl_rsp_valid;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last = system_spi_0_io_logic_io_ctrl_rsp_payload_last;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode = system_spi_0_io_logic_io_ctrl_rsp_payload_fragment_opcode;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data = system_spi_0_io_logic_io_ctrl_rsp_payload_fragment_data;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context = system_spi_0_io_logic_io_ctrl_rsp_payload_fragment_context;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_fire = (system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid && system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_ready);
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready = (! system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid);
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_valid = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_last = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_last;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_opcode = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_opcode;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_address = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_address;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_length = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_length;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_data = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_data;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_payload_fragment_context = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_context;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_ready = system_i2c_0_io_logic_io_ctrl_cmd_ready;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid = system_i2c_0_io_logic_io_ctrl_rsp_valid;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last = system_i2c_0_io_logic_io_ctrl_rsp_payload_last;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode = system_i2c_0_io_logic_io_ctrl_rsp_payload_fragment_opcode;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data = system_i2c_0_io_logic_io_ctrl_rsp_payload_fragment_data;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context = system_i2c_0_io_logic_io_ctrl_rsp_payload_fragment_context;
  assign system_i2c_0_io_interrupt = system_i2c_0_io_logic_system_i2c_0_io_interrupt_source;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready = io_apbSlave_1_logic_io_input_cmd_ready;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid = io_apbSlave_1_logic_io_input_rsp_valid;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last = io_apbSlave_1_logic_io_input_rsp_payload_last;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode = io_apbSlave_1_logic_io_input_rsp_payload_fragment_opcode;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data = io_apbSlave_1_logic_io_input_rsp_payload_fragment_data;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context = io_apbSlave_1_logic_io_input_rsp_payload_fragment_context;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready = io_apbSlave_0_logic_io_input_cmd_ready;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid = io_apbSlave_0_logic_io_input_rsp_valid;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last = io_apbSlave_0_logic_io_input_rsp_payload_last;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode = io_apbSlave_0_logic_io_input_rsp_payload_fragment_opcode;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data = io_apbSlave_0_logic_io_input_rsp_payload_fragment_data;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context = io_apbSlave_0_logic_io_input_rsp_payload_fragment_context;
  assign bmbPeripheral_bmb_withoutMask_cmd_valid = bmbPeripheral_bmb_decoder_io_outputs_0_cmd_valid;
  assign bmbPeripheral_bmb_withoutMask_rsp_ready = bmbPeripheral_bmb_decoder_io_outputs_0_rsp_ready;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_last = bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_last;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode = bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address = bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_address;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length = bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_length;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data = bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context = bmbPeripheral_bmb_decoder_io_outputs_0_cmd_payload_fragment_context;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid = bmbPeripheral_bmb_withoutMask_cmd_valid;
  assign bmbPeripheral_bmb_withoutMask_cmd_ready = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  assign bmbPeripheral_bmb_withoutMask_rsp_valid = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready = bmbPeripheral_bmb_withoutMask_rsp_ready;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last = bmbPeripheral_bmb_withoutMask_cmd_payload_last;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_last = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address[5:0];
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data;
  assign system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context = system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  assign bmbPeripheral_bmb_withoutMask_cmd_valid_1 = bmbPeripheral_bmb_decoder_io_outputs_1_cmd_valid;
  assign bmbPeripheral_bmb_withoutMask_rsp_ready_1 = bmbPeripheral_bmb_decoder_io_outputs_1_rsp_ready;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_last_1 = bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_last;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_1 = bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_1 = bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_address;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_1 = bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_length;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_1 = bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_1 = bmbPeripheral_bmb_decoder_io_outputs_1_cmd_payload_fragment_context;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid = bmbPeripheral_bmb_withoutMask_cmd_valid_1;
  assign bmbPeripheral_bmb_withoutMask_cmd_ready_1 = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  assign bmbPeripheral_bmb_withoutMask_rsp_valid_1 = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready = bmbPeripheral_bmb_withoutMask_rsp_ready_1;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last = bmbPeripheral_bmb_withoutMask_cmd_payload_last_1;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_last_1 = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_1;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_1[11:0];
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_1;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_1;
  assign system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_1;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_1 = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_1 = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_1 = system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  assign bmbPeripheral_bmb_withoutMask_cmd_valid_2 = bmbPeripheral_bmb_decoder_io_outputs_2_cmd_valid;
  assign bmbPeripheral_bmb_withoutMask_rsp_ready_2 = bmbPeripheral_bmb_decoder_io_outputs_2_rsp_ready;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_last_2 = bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_last;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_2 = bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_2 = bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_address;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_2 = bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_length;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_2 = bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_2 = bmbPeripheral_bmb_decoder_io_outputs_2_cmd_payload_fragment_context;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid = bmbPeripheral_bmb_withoutMask_cmd_valid_2;
  assign bmbPeripheral_bmb_withoutMask_cmd_ready_2 = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  assign bmbPeripheral_bmb_withoutMask_rsp_valid_2 = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready = bmbPeripheral_bmb_withoutMask_rsp_ready_2;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last = bmbPeripheral_bmb_withoutMask_cmd_payload_last_2;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_last_2 = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_2;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_2[7:0];
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_2;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_2;
  assign system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_2;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_2 = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_2 = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_2 = system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  assign bmbPeripheral_bmb_withoutMask_cmd_valid_3 = bmbPeripheral_bmb_decoder_io_outputs_3_cmd_valid;
  assign bmbPeripheral_bmb_withoutMask_rsp_ready_3 = bmbPeripheral_bmb_decoder_io_outputs_3_rsp_ready;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_last_3 = bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_last;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_3 = bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_3 = bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_address;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_3 = bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_length;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_3 = bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_3 = bmbPeripheral_bmb_decoder_io_outputs_3_cmd_payload_fragment_context;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid = bmbPeripheral_bmb_withoutMask_cmd_valid_3;
  assign bmbPeripheral_bmb_withoutMask_cmd_ready_3 = io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  assign bmbPeripheral_bmb_withoutMask_rsp_valid_3 = io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready = bmbPeripheral_bmb_withoutMask_rsp_ready_3;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last = bmbPeripheral_bmb_withoutMask_cmd_payload_last_3;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_last_3 = io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_3;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_3[11:0];
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_3;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_3;
  assign io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_3;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_3 = io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_3 = io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_3 = io_apbSlave_1_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  assign bmbPeripheral_bmb_withoutMask_cmd_valid_4 = bmbPeripheral_bmb_decoder_io_outputs_4_cmd_valid;
  assign bmbPeripheral_bmb_withoutMask_rsp_ready_4 = bmbPeripheral_bmb_decoder_io_outputs_4_rsp_ready;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_last_4 = bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_last;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_4 = bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_4 = bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_address;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_4 = bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_length;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_4 = bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_4 = bmbPeripheral_bmb_decoder_io_outputs_4_cmd_payload_fragment_context;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid = bmbPeripheral_bmb_withoutMask_cmd_valid_4;
  assign bmbPeripheral_bmb_withoutMask_cmd_ready_4 = io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready;
  assign bmbPeripheral_bmb_withoutMask_rsp_valid_4 = io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready = bmbPeripheral_bmb_withoutMask_rsp_ready_4;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last = bmbPeripheral_bmb_withoutMask_cmd_payload_last_4;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_last_4 = io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_opcode_4;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_address_4[15:0];
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_length_4;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_data_4;
  assign io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context = bmbPeripheral_bmb_withoutMask_cmd_payload_fragment_context_4;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_opcode_4 = io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_data_4 = io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data;
  assign bmbPeripheral_bmb_withoutMask_rsp_payload_fragment_context_4 = io_apbSlave_0_input_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context;
  always @(posedge clk) begin
    if(reset) begin
      axi_aw_rValid <= 1'b0;
      axi_w_rValid <= 1'b0;
      _zz_axi_bvalid_1 <= 1'b0;
      axi_ar_rValid <= 1'b0;
      _zz_axi_rvalid_1 <= 1'b0;
      system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid <= 1'b0;
      _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid_1 <= 1'b0;
      system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid <= 1'b0;
      system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid <= 1'b0;
    end else begin
      if(axi_awvalid) begin
        axi_aw_rValid <= 1'b1;
      end
      if(axi_aw_halfPipe_fire) begin
        axi_aw_rValid <= 1'b0;
      end
      if(axi_wvalid) begin
        axi_w_rValid <= 1'b1;
      end
      if(axi_w_halfPipe_fire) begin
        axi_w_rValid <= 1'b0;
      end
      if(axiShared_b_valid) begin
        _zz_axi_bvalid_1 <= 1'b1;
      end
      if((_zz_axi_bvalid && axi_bready)) begin
        _zz_axi_bvalid_1 <= 1'b0;
      end
      if(axi_arvalid) begin
        axi_ar_rValid <= 1'b1;
      end
      if(axi_ar_halfPipe_fire) begin
        axi_ar_rValid <= 1'b0;
      end
      if(axiShared_r_valid) begin
        _zz_axi_rvalid_1 <= 1'b1;
      end
      if((_zz_axi_rvalid && axi_rready)) begin
        _zz_axi_rvalid_1 <= 1'b0;
      end
      if(system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid) begin
        system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid <= 1'b1;
      end
      if(system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_fire) begin
        system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid <= 1'b0;
      end
      if(system_uart_0_io_logic_io_bus_rsp_valid) begin
        _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid_1 <= 1'b1;
      end
      if((_zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid && system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_ready)) begin
        _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_valid_1 <= 1'b0;
      end
      if(system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid) begin
        system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid <= 1'b1;
      end
      if(system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_fire) begin
        system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid <= 1'b0;
      end
      if(system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_valid) begin
        system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid <= 1'b1;
      end
      if(system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_halfPipe_fire) begin
        system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rValid <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if(axi_awready) begin
      axi_aw_rData_addr <= axi_awaddr;
      axi_aw_rData_len <= axi_awlen;
      axi_aw_rData_size <= axi_awsize;
      axi_aw_rData_cache <= axi_awcache;
      axi_aw_rData_prot <= axi_awprot;
    end
    if(axi_wready) begin
      axi_w_rData_data <= axi_wdata;
      axi_w_rData_strb <= axi_wstrb;
      axi_w_rData_last <= axi_wlast;
    end
    if(_zz_axiShared_b_ready) begin
      _zz_axi_bresp <= axiShared_b_payload_resp;
    end
    if(axi_arready) begin
      axi_ar_rData_addr <= axi_araddr;
      axi_ar_rData_len <= axi_arlen;
      axi_ar_rData_size <= axi_arsize;
      axi_ar_rData_cache <= axi_arcache;
      axi_ar_rData_prot <= axi_arprot;
    end
    if(_zz_axiShared_r_ready) begin
      _zz_axi_rdata <= axiShared_r_payload_data;
      _zz_axi_rresp <= axiShared_r_payload_resp;
      _zz_axi_rlast <= axiShared_r_payload_last;
    end
    if(system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready) begin
      system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_last <= system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
      system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_opcode <= system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
      system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_address <= system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
      system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_length <= system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
      system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_data <= system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
      system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_context <= system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
    end
    if(_zz_io_bus_rsp_ready) begin
      _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_last <= system_uart_0_io_logic_io_bus_rsp_payload_last;
      _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_opcode <= system_uart_0_io_logic_io_bus_rsp_payload_fragment_opcode;
      _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_data <= system_uart_0_io_logic_io_bus_rsp_payload_fragment_data;
      _zz_system_uart_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_rsp_payload_fragment_context <= system_uart_0_io_logic_io_bus_rsp_payload_fragment_context;
    end
    if(system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready) begin
      system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_last <= system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
      system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_opcode <= system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
      system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_address <= system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
      system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_length <= system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
      system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_data <= system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
      system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_context <= system_spi_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
    end
    if(system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_ready) begin
      system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_last <= system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_last;
      system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_opcode <= system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_opcode;
      system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_address <= system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_address;
      system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_length <= system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_length;
      system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_data <= system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_data;
      system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_rData_fragment_context <= system_i2c_0_io_ctrl_slaveModel_arbiterGen_oneToOne_arbiter_cmd_payload_fragment_context;
    end
  end


endmodule

module Axi4PeripheralBmbToApb3Bridge_1 (
  input  wire          io_input_cmd_valid,
  output wire          io_input_cmd_ready,
  input  wire          io_input_cmd_payload_last,
  input  wire [0:0]    io_input_cmd_payload_fragment_opcode,
  input  wire [15:0]   io_input_cmd_payload_fragment_address,
  input  wire [1:0]    io_input_cmd_payload_fragment_length,
  input  wire [31:0]   io_input_cmd_payload_fragment_data,
  input  wire [2:0]    io_input_cmd_payload_fragment_context,
  output wire          io_input_rsp_valid,
  input  wire          io_input_rsp_ready,
  output wire          io_input_rsp_payload_last,
  output wire [0:0]    io_input_rsp_payload_fragment_opcode,
  output wire [31:0]   io_input_rsp_payload_fragment_data,
  output wire [2:0]    io_input_rsp_payload_fragment_context,
  output wire [15:0]   io_output_PADDR,
  output wire [0:0]    io_output_PSEL,
  output wire          io_output_PENABLE,
  input  wire          io_output_PREADY,
  output wire          io_output_PWRITE,
  output wire [31:0]   io_output_PWDATA,
  input  wire [31:0]   io_output_PRDATA,
  input  wire          io_output_PSLVERROR,
  input  wire          clk,
  input  wire          reset
);

  wire                bmbBuffer_cmd_valid;
  reg                 bmbBuffer_cmd_ready;
  wire                bmbBuffer_cmd_payload_last;
  wire       [0:0]    bmbBuffer_cmd_payload_fragment_opcode;
  wire       [15:0]   bmbBuffer_cmd_payload_fragment_address;
  wire       [1:0]    bmbBuffer_cmd_payload_fragment_length;
  wire       [31:0]   bmbBuffer_cmd_payload_fragment_data;
  wire       [2:0]    bmbBuffer_cmd_payload_fragment_context;
  reg                 bmbBuffer_rsp_valid;
  reg                 bmbBuffer_rsp_ready;
  wire                bmbBuffer_rsp_payload_last;
  reg        [0:0]    bmbBuffer_rsp_payload_fragment_opcode;
  wire       [31:0]   bmbBuffer_rsp_payload_fragment_data;
  wire       [2:0]    bmbBuffer_rsp_payload_fragment_context;
  wire                io_input_rsp_isStall;
  wire                _zz_io_input_cmd_ready;
  wire                bmbBuffer_rsp_m2sPipe_valid;
  wire                bmbBuffer_rsp_m2sPipe_ready;
  wire                bmbBuffer_rsp_m2sPipe_payload_last;
  wire       [0:0]    bmbBuffer_rsp_m2sPipe_payload_fragment_opcode;
  wire       [31:0]   bmbBuffer_rsp_m2sPipe_payload_fragment_data;
  wire       [2:0]    bmbBuffer_rsp_m2sPipe_payload_fragment_context;
  reg                 bmbBuffer_rsp_rValid;
  reg                 bmbBuffer_rsp_rData_last;
  reg        [0:0]    bmbBuffer_rsp_rData_fragment_opcode;
  reg        [31:0]   bmbBuffer_rsp_rData_fragment_data;
  reg        [2:0]    bmbBuffer_rsp_rData_fragment_context;
  wire                when_Stream_l375;
  reg                 state;
  wire                when_BmbToApb3Bridge_l46;

  assign io_input_rsp_isStall = (io_input_rsp_valid && (! io_input_rsp_ready));
  assign _zz_io_input_cmd_ready = (! io_input_rsp_isStall);
  assign io_input_cmd_ready = (bmbBuffer_cmd_ready && _zz_io_input_cmd_ready);
  assign bmbBuffer_cmd_valid = (io_input_cmd_valid && _zz_io_input_cmd_ready);
  assign bmbBuffer_cmd_payload_last = io_input_cmd_payload_last;
  assign bmbBuffer_cmd_payload_fragment_opcode = io_input_cmd_payload_fragment_opcode;
  assign bmbBuffer_cmd_payload_fragment_address = io_input_cmd_payload_fragment_address;
  assign bmbBuffer_cmd_payload_fragment_length = io_input_cmd_payload_fragment_length;
  assign bmbBuffer_cmd_payload_fragment_data = io_input_cmd_payload_fragment_data;
  assign bmbBuffer_cmd_payload_fragment_context = io_input_cmd_payload_fragment_context;
  always @(*) begin
    bmbBuffer_rsp_ready = bmbBuffer_rsp_m2sPipe_ready;
    if(when_Stream_l375) begin
      bmbBuffer_rsp_ready = 1'b1;
    end
  end

  assign when_Stream_l375 = (! bmbBuffer_rsp_m2sPipe_valid);
  assign bmbBuffer_rsp_m2sPipe_valid = bmbBuffer_rsp_rValid;
  assign bmbBuffer_rsp_m2sPipe_payload_last = bmbBuffer_rsp_rData_last;
  assign bmbBuffer_rsp_m2sPipe_payload_fragment_opcode = bmbBuffer_rsp_rData_fragment_opcode;
  assign bmbBuffer_rsp_m2sPipe_payload_fragment_data = bmbBuffer_rsp_rData_fragment_data;
  assign bmbBuffer_rsp_m2sPipe_payload_fragment_context = bmbBuffer_rsp_rData_fragment_context;
  assign io_input_rsp_valid = bmbBuffer_rsp_m2sPipe_valid;
  assign bmbBuffer_rsp_m2sPipe_ready = io_input_rsp_ready;
  assign io_input_rsp_payload_last = bmbBuffer_rsp_m2sPipe_payload_last;
  assign io_input_rsp_payload_fragment_opcode = bmbBuffer_rsp_m2sPipe_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_data = bmbBuffer_rsp_m2sPipe_payload_fragment_data;
  assign io_input_rsp_payload_fragment_context = bmbBuffer_rsp_m2sPipe_payload_fragment_context;
  always @(*) begin
    bmbBuffer_cmd_ready = 1'b0;
    if(!when_BmbToApb3Bridge_l46) begin
      if(io_output_PREADY) begin
        bmbBuffer_cmd_ready = 1'b1;
      end
    end
  end

  assign io_output_PSEL[0] = bmbBuffer_cmd_valid;
  assign io_output_PENABLE = state;
  assign io_output_PWRITE = (bmbBuffer_cmd_payload_fragment_opcode == 1'b1);
  assign io_output_PADDR = bmbBuffer_cmd_payload_fragment_address;
  assign io_output_PWDATA = bmbBuffer_cmd_payload_fragment_data;
  always @(*) begin
    bmbBuffer_rsp_valid = 1'b0;
    if(!when_BmbToApb3Bridge_l46) begin
      if(io_output_PREADY) begin
        bmbBuffer_rsp_valid = 1'b1;
      end
    end
  end

  assign bmbBuffer_rsp_payload_fragment_data = io_output_PRDATA;
  assign when_BmbToApb3Bridge_l46 = (! state);
  assign bmbBuffer_rsp_payload_fragment_context = io_input_cmd_payload_fragment_context;
  assign bmbBuffer_rsp_payload_last = 1'b1;
  always @(*) begin
    bmbBuffer_rsp_payload_fragment_opcode = 1'b0;
    if(io_output_PSLVERROR) begin
      bmbBuffer_rsp_payload_fragment_opcode = 1'b1;
    end
  end

  always @(posedge clk) begin
    if(reset) begin
      bmbBuffer_rsp_rValid <= 1'b0;
      state <= 1'b0;
    end else begin
      if(bmbBuffer_rsp_ready) begin
        bmbBuffer_rsp_rValid <= bmbBuffer_rsp_valid;
      end
      if(when_BmbToApb3Bridge_l46) begin
        state <= bmbBuffer_cmd_valid;
      end else begin
        if(io_output_PREADY) begin
          state <= 1'b0;
        end
      end
    end
  end

  always @(posedge clk) begin
    if(bmbBuffer_rsp_ready) begin
      bmbBuffer_rsp_rData_last <= bmbBuffer_rsp_payload_last;
      bmbBuffer_rsp_rData_fragment_opcode <= bmbBuffer_rsp_payload_fragment_opcode;
      bmbBuffer_rsp_rData_fragment_data <= bmbBuffer_rsp_payload_fragment_data;
      bmbBuffer_rsp_rData_fragment_context <= bmbBuffer_rsp_payload_fragment_context;
    end
  end


endmodule

module Axi4PeripheralBmbToApb3Bridge (
  input  wire          io_input_cmd_valid,
  output wire          io_input_cmd_ready,
  input  wire          io_input_cmd_payload_last,
  input  wire [0:0]    io_input_cmd_payload_fragment_opcode,
  input  wire [11:0]   io_input_cmd_payload_fragment_address,
  input  wire [1:0]    io_input_cmd_payload_fragment_length,
  input  wire [31:0]   io_input_cmd_payload_fragment_data,
  input  wire [2:0]    io_input_cmd_payload_fragment_context,
  output wire          io_input_rsp_valid,
  input  wire          io_input_rsp_ready,
  output wire          io_input_rsp_payload_last,
  output wire [0:0]    io_input_rsp_payload_fragment_opcode,
  output wire [31:0]   io_input_rsp_payload_fragment_data,
  output wire [2:0]    io_input_rsp_payload_fragment_context,
  output wire [11:0]   io_output_PADDR,
  output wire [0:0]    io_output_PSEL,
  output wire          io_output_PENABLE,
  input  wire          io_output_PREADY,
  output wire          io_output_PWRITE,
  output wire [31:0]   io_output_PWDATA,
  input  wire [31:0]   io_output_PRDATA,
  input  wire          io_output_PSLVERROR,
  input  wire          clk,
  input  wire          reset
);

  wire                bmbBuffer_cmd_valid;
  reg                 bmbBuffer_cmd_ready;
  wire                bmbBuffer_cmd_payload_last;
  wire       [0:0]    bmbBuffer_cmd_payload_fragment_opcode;
  wire       [11:0]   bmbBuffer_cmd_payload_fragment_address;
  wire       [1:0]    bmbBuffer_cmd_payload_fragment_length;
  wire       [31:0]   bmbBuffer_cmd_payload_fragment_data;
  wire       [2:0]    bmbBuffer_cmd_payload_fragment_context;
  reg                 bmbBuffer_rsp_valid;
  reg                 bmbBuffer_rsp_ready;
  wire                bmbBuffer_rsp_payload_last;
  reg        [0:0]    bmbBuffer_rsp_payload_fragment_opcode;
  wire       [31:0]   bmbBuffer_rsp_payload_fragment_data;
  wire       [2:0]    bmbBuffer_rsp_payload_fragment_context;
  wire                io_input_rsp_isStall;
  wire                _zz_io_input_cmd_ready;
  wire                bmbBuffer_rsp_m2sPipe_valid;
  wire                bmbBuffer_rsp_m2sPipe_ready;
  wire                bmbBuffer_rsp_m2sPipe_payload_last;
  wire       [0:0]    bmbBuffer_rsp_m2sPipe_payload_fragment_opcode;
  wire       [31:0]   bmbBuffer_rsp_m2sPipe_payload_fragment_data;
  wire       [2:0]    bmbBuffer_rsp_m2sPipe_payload_fragment_context;
  reg                 bmbBuffer_rsp_rValid;
  reg                 bmbBuffer_rsp_rData_last;
  reg        [0:0]    bmbBuffer_rsp_rData_fragment_opcode;
  reg        [31:0]   bmbBuffer_rsp_rData_fragment_data;
  reg        [2:0]    bmbBuffer_rsp_rData_fragment_context;
  wire                when_Stream_l375;
  reg                 state;
  wire                when_BmbToApb3Bridge_l46;

  assign io_input_rsp_isStall = (io_input_rsp_valid && (! io_input_rsp_ready));
  assign _zz_io_input_cmd_ready = (! io_input_rsp_isStall);
  assign io_input_cmd_ready = (bmbBuffer_cmd_ready && _zz_io_input_cmd_ready);
  assign bmbBuffer_cmd_valid = (io_input_cmd_valid && _zz_io_input_cmd_ready);
  assign bmbBuffer_cmd_payload_last = io_input_cmd_payload_last;
  assign bmbBuffer_cmd_payload_fragment_opcode = io_input_cmd_payload_fragment_opcode;
  assign bmbBuffer_cmd_payload_fragment_address = io_input_cmd_payload_fragment_address;
  assign bmbBuffer_cmd_payload_fragment_length = io_input_cmd_payload_fragment_length;
  assign bmbBuffer_cmd_payload_fragment_data = io_input_cmd_payload_fragment_data;
  assign bmbBuffer_cmd_payload_fragment_context = io_input_cmd_payload_fragment_context;
  always @(*) begin
    bmbBuffer_rsp_ready = bmbBuffer_rsp_m2sPipe_ready;
    if(when_Stream_l375) begin
      bmbBuffer_rsp_ready = 1'b1;
    end
  end

  assign when_Stream_l375 = (! bmbBuffer_rsp_m2sPipe_valid);
  assign bmbBuffer_rsp_m2sPipe_valid = bmbBuffer_rsp_rValid;
  assign bmbBuffer_rsp_m2sPipe_payload_last = bmbBuffer_rsp_rData_last;
  assign bmbBuffer_rsp_m2sPipe_payload_fragment_opcode = bmbBuffer_rsp_rData_fragment_opcode;
  assign bmbBuffer_rsp_m2sPipe_payload_fragment_data = bmbBuffer_rsp_rData_fragment_data;
  assign bmbBuffer_rsp_m2sPipe_payload_fragment_context = bmbBuffer_rsp_rData_fragment_context;
  assign io_input_rsp_valid = bmbBuffer_rsp_m2sPipe_valid;
  assign bmbBuffer_rsp_m2sPipe_ready = io_input_rsp_ready;
  assign io_input_rsp_payload_last = bmbBuffer_rsp_m2sPipe_payload_last;
  assign io_input_rsp_payload_fragment_opcode = bmbBuffer_rsp_m2sPipe_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_data = bmbBuffer_rsp_m2sPipe_payload_fragment_data;
  assign io_input_rsp_payload_fragment_context = bmbBuffer_rsp_m2sPipe_payload_fragment_context;
  always @(*) begin
    bmbBuffer_cmd_ready = 1'b0;
    if(!when_BmbToApb3Bridge_l46) begin
      if(io_output_PREADY) begin
        bmbBuffer_cmd_ready = 1'b1;
      end
    end
  end

  assign io_output_PSEL[0] = bmbBuffer_cmd_valid;
  assign io_output_PENABLE = state;
  assign io_output_PWRITE = (bmbBuffer_cmd_payload_fragment_opcode == 1'b1);
  assign io_output_PADDR = bmbBuffer_cmd_payload_fragment_address;
  assign io_output_PWDATA = bmbBuffer_cmd_payload_fragment_data;
  always @(*) begin
    bmbBuffer_rsp_valid = 1'b0;
    if(!when_BmbToApb3Bridge_l46) begin
      if(io_output_PREADY) begin
        bmbBuffer_rsp_valid = 1'b1;
      end
    end
  end

  assign bmbBuffer_rsp_payload_fragment_data = io_output_PRDATA;
  assign when_BmbToApb3Bridge_l46 = (! state);
  assign bmbBuffer_rsp_payload_fragment_context = io_input_cmd_payload_fragment_context;
  assign bmbBuffer_rsp_payload_last = 1'b1;
  always @(*) begin
    bmbBuffer_rsp_payload_fragment_opcode = 1'b0;
    if(io_output_PSLVERROR) begin
      bmbBuffer_rsp_payload_fragment_opcode = 1'b1;
    end
  end

  always @(posedge clk) begin
    if(reset) begin
      bmbBuffer_rsp_rValid <= 1'b0;
      state <= 1'b0;
    end else begin
      if(bmbBuffer_rsp_ready) begin
        bmbBuffer_rsp_rValid <= bmbBuffer_rsp_valid;
      end
      if(when_BmbToApb3Bridge_l46) begin
        state <= bmbBuffer_cmd_valid;
      end else begin
        if(io_output_PREADY) begin
          state <= 1'b0;
        end
      end
    end
  end

  always @(posedge clk) begin
    if(bmbBuffer_rsp_ready) begin
      bmbBuffer_rsp_rData_last <= bmbBuffer_rsp_payload_last;
      bmbBuffer_rsp_rData_fragment_opcode <= bmbBuffer_rsp_payload_fragment_opcode;
      bmbBuffer_rsp_rData_fragment_data <= bmbBuffer_rsp_payload_fragment_data;
      bmbBuffer_rsp_rData_fragment_context <= bmbBuffer_rsp_payload_fragment_context;
    end
  end


endmodule

module Axi4PeripheralBmbI2cCtrl (
  input  wire          io_ctrl_cmd_valid,
  output wire          io_ctrl_cmd_ready,
  input  wire          io_ctrl_cmd_payload_last,
  input  wire [0:0]    io_ctrl_cmd_payload_fragment_opcode,
  input  wire [7:0]    io_ctrl_cmd_payload_fragment_address,
  input  wire [1:0]    io_ctrl_cmd_payload_fragment_length,
  input  wire [31:0]   io_ctrl_cmd_payload_fragment_data,
  input  wire [2:0]    io_ctrl_cmd_payload_fragment_context,
  output wire          io_ctrl_rsp_valid,
  input  wire          io_ctrl_rsp_ready,
  output wire          io_ctrl_rsp_payload_last,
  output wire [0:0]    io_ctrl_rsp_payload_fragment_opcode,
  output wire [31:0]   io_ctrl_rsp_payload_fragment_data,
  output wire [2:0]    io_ctrl_rsp_payload_fragment_context,
  output wire          io_i2c_sda_write,
  input  wire          io_i2c_sda_read,
  output wire          io_i2c_scl_write,
  input  wire          io_i2c_scl_read,
  output wire          system_i2c_0_io_interrupt_source,
  input  wire          clk,
  input  wire          reset
);
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_BOOT = 4'd0;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE = 4'd1;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 = 4'd2;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 = 4'd3;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 = 4'd4;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW = 4'd5;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH = 4'd6;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART = 4'd7;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 = 4'd8;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 = 4'd9;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 = 4'd10;
  localparam Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF = 4'd11;
  localparam Axi4PeripheralI2cSlaveCmdMode_NONE = 3'd0;
  localparam Axi4PeripheralI2cSlaveCmdMode_START = 3'd1;
  localparam Axi4PeripheralI2cSlaveCmdMode_RESTART = 3'd2;
  localparam Axi4PeripheralI2cSlaveCmdMode_STOP = 3'd3;
  localparam Axi4PeripheralI2cSlaveCmdMode_DROP = 3'd4;
  localparam Axi4PeripheralI2cSlaveCmdMode_DRIVE = 3'd5;
  localparam Axi4PeripheralI2cSlaveCmdMode_READ = 3'd6;

  reg                 i2cCtrl_io_config_timeoutClear;
  reg                 i2cCtrl_io_bus_rsp_valid;
  reg                 i2cCtrl_io_bus_rsp_enable;
  reg                 i2cCtrl_io_bus_rsp_data;
  wire                i2cCtrl_io_i2c_scl_write;
  wire                i2cCtrl_io_i2c_sda_write;
  wire       [2:0]    i2cCtrl_io_bus_cmd_kind;
  wire                i2cCtrl_io_bus_cmd_data;
  wire                i2cCtrl_io_timeout;
  wire                i2cCtrl_io_internals_inFrame;
  wire                i2cCtrl_io_internals_sdaRead;
  wire                i2cCtrl_io_internals_sclRead;
  wire       [6:0]    _zz_bridge_addressFilter_hits_0;
  wire       [6:0]    _zz_bridge_addressFilter_hits_1;
  wire       [0:0]    _zz_bridge_masterLogic_start;
  wire       [0:0]    _zz_bridge_masterLogic_stop;
  wire       [0:0]    _zz_bridge_masterLogic_drop;
  wire       [0:0]    _zz_bridge_masterLogic_recover;
  wire       [11:0]   _zz_bridge_masterLogic_timer_value;
  wire       [0:0]    _zz_bridge_masterLogic_timer_value_1;
  wire       [0:0]    _zz_bridge_masterLogic_fsm_dropped_start;
  wire       [0:0]    _zz_bridge_masterLogic_fsm_dropped_stop;
  wire       [0:0]    _zz_bridge_masterLogic_fsm_dropped_recover;
  wire       [2:0]    _zz_io_bus_rsp_data;
  wire       [2:0]    _zz_bridge_rxData_value;
  wire       [0:0]    _zz_bridge_interruptCtrl_start_flag;
  wire       [0:0]    _zz_bridge_interruptCtrl_restart_flag;
  wire       [0:0]    _zz_bridge_interruptCtrl_end_flag;
  wire       [0:0]    _zz_bridge_interruptCtrl_drop_flag;
  wire       [0:0]    _zz_bridge_interruptCtrl_filterGen_flag;
  wire       [0:0]    _zz_bridge_interruptCtrl_clockGenExit_flag;
  wire       [0:0]    _zz_bridge_interruptCtrl_clockGenEnter_flag;
  wire                busCtrl_readErrorFlag;
  wire                busCtrl_writeErrorFlag;
  wire                busCtrl_readHaltTrigger;
  wire                busCtrl_writeHaltTrigger;
  wire                busCtrl_rsp_valid;
  wire                busCtrl_rsp_ready;
  wire                busCtrl_rsp_payload_last;
  reg        [0:0]    busCtrl_rsp_payload_fragment_opcode;
  reg        [31:0]   busCtrl_rsp_payload_fragment_data;
  wire       [2:0]    busCtrl_rsp_payload_fragment_context;
  wire                _zz_busCtrl_rsp_ready;
  reg                 _zz_busCtrl_rsp_ready_1;
  wire                _zz_io_ctrl_rsp_valid;
  reg                 _zz_io_ctrl_rsp_valid_1;
  reg                 _zz_io_ctrl_rsp_payload_last;
  reg        [0:0]    _zz_io_ctrl_rsp_payload_fragment_opcode;
  reg        [31:0]   _zz_io_ctrl_rsp_payload_fragment_data;
  reg        [2:0]    _zz_io_ctrl_rsp_payload_fragment_context;
  wire                when_Stream_l375;
  wire                busCtrl_askWrite;
  wire                busCtrl_askRead;
  wire                io_ctrl_cmd_fire;
  wire                busCtrl_doWrite;
  wire                busCtrl_doRead;
  wire                when_BmbSlaveFactory_l33;
  wire                when_BmbSlaveFactory_l35;
  wire                bridge_busCtrlWithOffset_readErrorFlag;
  wire                bridge_busCtrlWithOffset_writeErrorFlag;
  reg                 bridge_frameReset;
  reg                 bridge_i2cBuffer_sda_write;
  wire                bridge_i2cBuffer_sda_read;
  reg                 bridge_i2cBuffer_scl_write;
  wire                bridge_i2cBuffer_scl_read;
  reg                 bridge_rxData_event;
  reg                 bridge_rxData_listen;
  reg                 bridge_rxData_valid;
  reg        [7:0]    bridge_rxData_value;
  reg                 when_I2cCtrl_l224;
  reg                 bridge_rxAck_listen;
  reg                 bridge_rxAck_valid;
  reg                 bridge_rxAck_value;
  reg                 when_I2cCtrl_l237;
  reg                 bridge_txData_valid;
  reg                 bridge_txData_repeat;
  reg                 bridge_txData_enable;
  reg        [7:0]    bridge_txData_value;
  reg                 bridge_txData_forceDisable;
  reg                 bridge_txData_disableOnDataConflict;
  reg                 bridge_txAck_valid;
  reg                 bridge_txAck_repeat;
  reg                 bridge_txAck_enable;
  reg                 bridge_txAck_value;
  reg                 bridge_txAck_forceAck;
  reg                 bridge_txAck_disableOnDataConflict;
  reg                 bridge_addressFilter_addresses_0_enable;
  reg        [9:0]    bridge_addressFilter_addresses_0_value;
  reg                 bridge_addressFilter_addresses_0_is10Bit;
  reg                 bridge_addressFilter_addresses_1_enable;
  reg        [9:0]    bridge_addressFilter_addresses_1_value;
  reg                 bridge_addressFilter_addresses_1_is10Bit;
  reg        [1:0]    bridge_addressFilter_state;
  reg        [7:0]    bridge_addressFilter_byte0;
  reg        [7:0]    bridge_addressFilter_byte1;
  wire                bridge_addressFilter_byte0Is10Bit;
  wire                bridge_addressFilter_hits_0;
  wire                bridge_addressFilter_hits_1;
  wire                when_I2cCtrl_l306;
  wire                _zz_when_I2cCtrl_l310;
  reg                 _zz_when_I2cCtrl_l310_1;
  wire                when_I2cCtrl_l310;
  reg                 bridge_masterLogic_start;
  reg                 when_BusSlaveFactory_l377;
  wire                when_BusSlaveFactory_l379;
  reg                 bridge_masterLogic_stop;
  reg                 when_BusSlaveFactory_l377_1;
  wire                when_BusSlaveFactory_l379_1;
  reg                 bridge_masterLogic_drop;
  reg                 when_BusSlaveFactory_l377_2;
  wire                when_BusSlaveFactory_l379_2;
  reg                 bridge_masterLogic_recover;
  reg                 when_BusSlaveFactory_l377_3;
  wire                when_BusSlaveFactory_l379_3;
  reg        [11:0]   bridge_masterLogic_timer_value;
  reg        [11:0]   bridge_masterLogic_timer_tLow;
  reg        [11:0]   bridge_masterLogic_timer_tHigh;
  reg        [11:0]   bridge_masterLogic_timer_tBuf;
  wire                bridge_masterLogic_timer_done;
  wire                bridge_masterLogic_txReady;
  wire                bridge_masterLogic_fsm_wantExit;
  reg                 bridge_masterLogic_fsm_wantStart;
  wire                bridge_masterLogic_fsm_wantKill;
  reg                 bridge_masterLogic_fsm_dropped_start;
  reg                 bridge_masterLogic_fsm_dropped_stop;
  reg                 bridge_masterLogic_fsm_dropped_recover;
  reg                 bridge_masterLogic_fsm_dropped_trigger;
  reg                 bridge_masterLogic_fsm_inFrameLate;
  wire                when_I2cCtrl_l363;
  wire                when_I2cCtrl_l363_1;
  wire                bridge_masterLogic_fsm_outOfSync;
  wire                bridge_masterLogic_fsm_isBusy;
  reg                 when_BusSlaveFactory_l341;
  wire                when_BusSlaveFactory_l347;
  reg                 when_BusSlaveFactory_l341_1;
  wire                when_BusSlaveFactory_l347_1;
  reg                 when_BusSlaveFactory_l341_2;
  wire                when_BusSlaveFactory_l347_2;
  reg        [2:0]    bridge_dataCounter;
  reg                 bridge_inAckState;
  reg                 bridge_wasntAck;
  wire                when_I2cCtrl_l523;
  wire                when_I2cCtrl_l546;
  wire                when_I2cCtrl_l566;
  wire                when_I2cCtrl_l570;
  wire                when_I2cCtrl_l574;
  wire                when_I2cCtrl_l578;
  wire                when_I2cCtrl_l588;
  wire                when_I2cCtrl_l601;
  reg                 bridge_interruptCtrl_rxDataEnable;
  reg                 bridge_interruptCtrl_rxAckEnable;
  reg                 bridge_interruptCtrl_txDataEnable;
  reg                 bridge_interruptCtrl_txAckEnable;
  reg                 bridge_interruptCtrl_interrupt;
  wire                when_I2cCtrl_l634;
  reg                 bridge_interruptCtrl_start_enable;
  reg                 bridge_interruptCtrl_start_flag;
  wire                when_I2cCtrl_l634_1;
  reg                 when_BusSlaveFactory_l341_3;
  wire                when_BusSlaveFactory_l347_3;
  wire                when_I2cCtrl_l634_2;
  reg                 bridge_interruptCtrl_restart_enable;
  reg                 bridge_interruptCtrl_restart_flag;
  wire                when_I2cCtrl_l634_3;
  reg                 when_BusSlaveFactory_l341_4;
  wire                when_BusSlaveFactory_l347_4;
  wire                when_I2cCtrl_l634_4;
  reg                 bridge_interruptCtrl_end_enable;
  reg                 bridge_interruptCtrl_end_flag;
  wire                when_I2cCtrl_l634_5;
  reg                 when_BusSlaveFactory_l341_5;
  wire                when_BusSlaveFactory_l347_5;
  wire                when_I2cCtrl_l634_6;
  reg                 bridge_interruptCtrl_drop_enable;
  reg                 bridge_interruptCtrl_drop_flag;
  wire                when_I2cCtrl_l634_7;
  reg                 when_BusSlaveFactory_l341_6;
  wire                when_BusSlaveFactory_l347_6;
  wire                _zz_when_I2cCtrl_l634;
  reg                 _zz_when_I2cCtrl_l634_1;
  wire                when_I2cCtrl_l634_8;
  reg                 bridge_interruptCtrl_filterGen_enable;
  reg                 bridge_interruptCtrl_filterGen_flag;
  wire                when_I2cCtrl_l634_9;
  reg                 when_BusSlaveFactory_l341_7;
  wire                when_BusSlaveFactory_l347_7;
  reg                 bridge_masterLogic_fsm_isBusy_regNext;
  wire                when_I2cCtrl_l634_10;
  reg                 bridge_interruptCtrl_clockGenExit_enable;
  reg                 bridge_interruptCtrl_clockGenExit_flag;
  wire                when_I2cCtrl_l634_11;
  reg                 when_BusSlaveFactory_l341_8;
  wire                when_BusSlaveFactory_l347_8;
  reg                 bridge_masterLogic_fsm_isBusy_regNext_1;
  wire                when_I2cCtrl_l634_12;
  reg                 bridge_interruptCtrl_clockGenEnter_enable;
  reg                 bridge_interruptCtrl_clockGenEnter_flag;
  wire                when_I2cCtrl_l634_13;
  reg                 when_BusSlaveFactory_l341_9;
  wire                when_BusSlaveFactory_l347_9;
  reg        [9:0]    _zz_io_config_samplingClockDivider;
  reg        [19:0]   _zz_io_config_timeout;
  reg        [5:0]    _zz_io_config_tsuData;
  reg                 bridge_timeoutClear;
  wire                when_I2cCtrl_l659;
  reg        [3:0]    bridge_masterLogic_fsm_stateReg;
  reg        [3:0]    bridge_masterLogic_fsm_stateNext;
  reg                 i2cCtrl_io_internals_inFrame_regNext;
  wire                when_I2cCtrl_l367;
  wire                when_I2cCtrl_l369;
  wire                when_I2cCtrl_l380;
  wire                when_I2cCtrl_l392;
  wire                when_I2cCtrl_l418;
  wire                when_I2cCtrl_l422;
  wire                when_I2cCtrl_l442;
  wire                when_I2cCtrl_l450;
  wire                when_I2cCtrl_l474;
  wire                when_StateMachine_l253;
  wire                when_StateMachine_l253_1;
  wire                when_StateMachine_l253_2;
  wire                when_StateMachine_l253_3;
  wire                when_StateMachine_l253_4;
  wire                when_StateMachine_l253_5;
  wire                when_I2cCtrl_l350;
  reg                 bridge_slaveOverride_sda;
  reg                 bridge_slaveOverride_scl;
  wire                when_I2cCtrl_l673;
  wire                when_I2cCtrl_l674;
  reg                 bridge_i2cBuffer_scl_write_regNext;
  reg                 bridge_i2cBuffer_sda_write_regNext;
  `ifndef SYNTHESIS
  reg [55:0] bridge_masterLogic_fsm_stateReg_string;
  reg [55:0] bridge_masterLogic_fsm_stateNext_string;
  `endif


  assign _zz_bridge_addressFilter_hits_0 = (bridge_addressFilter_byte0 >>> 1'd1);
  assign _zz_bridge_addressFilter_hits_1 = (bridge_addressFilter_byte0 >>> 1'd1);
  assign _zz_bridge_masterLogic_start = 1'b1;
  assign _zz_bridge_masterLogic_stop = 1'b1;
  assign _zz_bridge_masterLogic_drop = 1'b1;
  assign _zz_bridge_masterLogic_recover = 1'b1;
  assign _zz_bridge_masterLogic_timer_value_1 = (! bridge_masterLogic_timer_done);
  assign _zz_bridge_masterLogic_timer_value = {11'd0, _zz_bridge_masterLogic_timer_value_1};
  assign _zz_bridge_masterLogic_fsm_dropped_start = 1'b0;
  assign _zz_bridge_masterLogic_fsm_dropped_stop = 1'b0;
  assign _zz_bridge_masterLogic_fsm_dropped_recover = 1'b0;
  assign _zz_io_bus_rsp_data = (3'b111 - bridge_dataCounter);
  assign _zz_bridge_rxData_value = (3'b111 - bridge_dataCounter);
  assign _zz_bridge_interruptCtrl_start_flag = 1'b0;
  assign _zz_bridge_interruptCtrl_restart_flag = 1'b0;
  assign _zz_bridge_interruptCtrl_end_flag = 1'b0;
  assign _zz_bridge_interruptCtrl_drop_flag = 1'b0;
  assign _zz_bridge_interruptCtrl_filterGen_flag = 1'b0;
  assign _zz_bridge_interruptCtrl_clockGenExit_flag = 1'b0;
  assign _zz_bridge_interruptCtrl_clockGenEnter_flag = 1'b0;
  Axi4PeripheralI2cSlave i2cCtrl (
    .io_i2c_sda_write               (i2cCtrl_io_i2c_sda_write               ), //o
    .io_i2c_sda_read                (bridge_i2cBuffer_sda_read              ), //i
    .io_i2c_scl_write               (i2cCtrl_io_i2c_scl_write               ), //o
    .io_i2c_scl_read                (bridge_i2cBuffer_scl_read              ), //i
    .io_config_samplingClockDivider (_zz_io_config_samplingClockDivider[9:0]), //i
    .io_config_timeout              (_zz_io_config_timeout[19:0]            ), //i
    .io_config_tsuData              (_zz_io_config_tsuData[5:0]             ), //i
    .io_config_timeoutClear         (i2cCtrl_io_config_timeoutClear         ), //i
    .io_bus_cmd_kind                (i2cCtrl_io_bus_cmd_kind[2:0]           ), //o
    .io_bus_cmd_data                (i2cCtrl_io_bus_cmd_data                ), //o
    .io_bus_rsp_valid               (i2cCtrl_io_bus_rsp_valid               ), //i
    .io_bus_rsp_enable              (i2cCtrl_io_bus_rsp_enable              ), //i
    .io_bus_rsp_data                (i2cCtrl_io_bus_rsp_data                ), //i
    .io_timeout                     (i2cCtrl_io_timeout                     ), //o
    .io_internals_inFrame           (i2cCtrl_io_internals_inFrame           ), //o
    .io_internals_sdaRead           (i2cCtrl_io_internals_sdaRead           ), //o
    .io_internals_sclRead           (i2cCtrl_io_internals_sclRead           ), //o
    .clk                            (clk                                    ), //i
    .reset                          (reset                                  )  //i
  );
  initial begin
  `ifndef SYNTHESIS
    _zz_io_config_timeout = {$urandom};
    _zz_io_config_tsuData = {$urandom};
  `endif
  end

  `ifndef SYNTHESIS
  always @(*) begin
    case(bridge_masterLogic_fsm_stateReg)
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_BOOT : bridge_masterLogic_fsm_stateReg_string = "BOOT   ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE : bridge_masterLogic_fsm_stateReg_string = "IDLE   ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 : bridge_masterLogic_fsm_stateReg_string = "START1 ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 : bridge_masterLogic_fsm_stateReg_string = "START2 ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 : bridge_masterLogic_fsm_stateReg_string = "START3 ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW : bridge_masterLogic_fsm_stateReg_string = "LOW    ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH : bridge_masterLogic_fsm_stateReg_string = "HIGH   ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART : bridge_masterLogic_fsm_stateReg_string = "RESTART";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 : bridge_masterLogic_fsm_stateReg_string = "STOP1  ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 : bridge_masterLogic_fsm_stateReg_string = "STOP2  ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 : bridge_masterLogic_fsm_stateReg_string = "STOP3  ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF : bridge_masterLogic_fsm_stateReg_string = "TBUF   ";
      default : bridge_masterLogic_fsm_stateReg_string = "???????";
    endcase
  end
  always @(*) begin
    case(bridge_masterLogic_fsm_stateNext)
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_BOOT : bridge_masterLogic_fsm_stateNext_string = "BOOT   ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE : bridge_masterLogic_fsm_stateNext_string = "IDLE   ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 : bridge_masterLogic_fsm_stateNext_string = "START1 ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 : bridge_masterLogic_fsm_stateNext_string = "START2 ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 : bridge_masterLogic_fsm_stateNext_string = "START3 ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW : bridge_masterLogic_fsm_stateNext_string = "LOW    ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH : bridge_masterLogic_fsm_stateNext_string = "HIGH   ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART : bridge_masterLogic_fsm_stateNext_string = "RESTART";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 : bridge_masterLogic_fsm_stateNext_string = "STOP1  ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 : bridge_masterLogic_fsm_stateNext_string = "STOP2  ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 : bridge_masterLogic_fsm_stateNext_string = "STOP3  ";
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF : bridge_masterLogic_fsm_stateNext_string = "TBUF   ";
      default : bridge_masterLogic_fsm_stateNext_string = "???????";
    endcase
  end
  `endif

  assign busCtrl_readErrorFlag = 1'b0;
  assign busCtrl_writeErrorFlag = 1'b0;
  assign busCtrl_readHaltTrigger = 1'b0;
  assign busCtrl_writeHaltTrigger = 1'b0;
  assign _zz_busCtrl_rsp_ready = (! (busCtrl_readHaltTrigger || busCtrl_writeHaltTrigger));
  assign busCtrl_rsp_ready = (_zz_busCtrl_rsp_ready_1 && _zz_busCtrl_rsp_ready);
  always @(*) begin
    _zz_busCtrl_rsp_ready_1 = io_ctrl_rsp_ready;
    if(when_Stream_l375) begin
      _zz_busCtrl_rsp_ready_1 = 1'b1;
    end
  end

  assign when_Stream_l375 = (! _zz_io_ctrl_rsp_valid);
  assign _zz_io_ctrl_rsp_valid = _zz_io_ctrl_rsp_valid_1;
  assign io_ctrl_rsp_valid = _zz_io_ctrl_rsp_valid;
  assign io_ctrl_rsp_payload_last = _zz_io_ctrl_rsp_payload_last;
  assign io_ctrl_rsp_payload_fragment_opcode = _zz_io_ctrl_rsp_payload_fragment_opcode;
  assign io_ctrl_rsp_payload_fragment_data = _zz_io_ctrl_rsp_payload_fragment_data;
  assign io_ctrl_rsp_payload_fragment_context = _zz_io_ctrl_rsp_payload_fragment_context;
  assign busCtrl_askWrite = (io_ctrl_cmd_valid && (io_ctrl_cmd_payload_fragment_opcode == 1'b1));
  assign busCtrl_askRead = (io_ctrl_cmd_valid && (io_ctrl_cmd_payload_fragment_opcode == 1'b0));
  assign io_ctrl_cmd_fire = (io_ctrl_cmd_valid && io_ctrl_cmd_ready);
  assign busCtrl_doWrite = (io_ctrl_cmd_fire && (io_ctrl_cmd_payload_fragment_opcode == 1'b1));
  assign busCtrl_doRead = (io_ctrl_cmd_fire && (io_ctrl_cmd_payload_fragment_opcode == 1'b0));
  assign busCtrl_rsp_valid = io_ctrl_cmd_valid;
  assign io_ctrl_cmd_ready = busCtrl_rsp_ready;
  assign busCtrl_rsp_payload_last = 1'b1;
  assign when_BmbSlaveFactory_l33 = (busCtrl_doWrite && busCtrl_writeErrorFlag);
  always @(*) begin
    if(when_BmbSlaveFactory_l33) begin
      busCtrl_rsp_payload_fragment_opcode = 1'b1;
    end else begin
      if(when_BmbSlaveFactory_l35) begin
        busCtrl_rsp_payload_fragment_opcode = 1'b1;
      end else begin
        busCtrl_rsp_payload_fragment_opcode = 1'b0;
      end
    end
  end

  assign when_BmbSlaveFactory_l35 = (busCtrl_doRead && busCtrl_readErrorFlag);
  always @(*) begin
    busCtrl_rsp_payload_fragment_data = 32'h0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h08 : begin
        busCtrl_rsp_payload_fragment_data[8 : 8] = bridge_rxData_valid;
        busCtrl_rsp_payload_fragment_data[7 : 0] = bridge_rxData_value;
      end
      8'h0c : begin
        busCtrl_rsp_payload_fragment_data[8 : 8] = bridge_rxAck_valid;
        busCtrl_rsp_payload_fragment_data[0 : 0] = bridge_rxAck_value;
      end
      8'h0 : begin
        busCtrl_rsp_payload_fragment_data[8 : 8] = bridge_txData_valid;
        busCtrl_rsp_payload_fragment_data[9 : 9] = bridge_txData_enable;
      end
      8'h04 : begin
        busCtrl_rsp_payload_fragment_data[8 : 8] = bridge_txAck_valid;
        busCtrl_rsp_payload_fragment_data[9 : 9] = bridge_txAck_enable;
      end
      8'h80 : begin
        busCtrl_rsp_payload_fragment_data[1 : 0] = {bridge_addressFilter_hits_1,bridge_addressFilter_hits_0};
      end
      8'h84 : begin
        busCtrl_rsp_payload_fragment_data[0 : 0] = bridge_addressFilter_byte0[0];
      end
      8'h40 : begin
        busCtrl_rsp_payload_fragment_data[4 : 4] = bridge_masterLogic_start;
        busCtrl_rsp_payload_fragment_data[5 : 5] = bridge_masterLogic_stop;
        busCtrl_rsp_payload_fragment_data[6 : 6] = bridge_masterLogic_drop;
        busCtrl_rsp_payload_fragment_data[7 : 7] = bridge_masterLogic_recover;
        busCtrl_rsp_payload_fragment_data[0 : 0] = bridge_masterLogic_fsm_isBusy;
        busCtrl_rsp_payload_fragment_data[9 : 9] = bridge_masterLogic_fsm_dropped_start;
        busCtrl_rsp_payload_fragment_data[10 : 10] = bridge_masterLogic_fsm_dropped_stop;
        busCtrl_rsp_payload_fragment_data[11 : 11] = bridge_masterLogic_fsm_dropped_recover;
      end
      8'h20 : begin
        busCtrl_rsp_payload_fragment_data[0 : 0] = bridge_interruptCtrl_rxDataEnable;
        busCtrl_rsp_payload_fragment_data[1 : 1] = bridge_interruptCtrl_rxAckEnable;
        busCtrl_rsp_payload_fragment_data[2 : 2] = bridge_interruptCtrl_txDataEnable;
        busCtrl_rsp_payload_fragment_data[3 : 3] = bridge_interruptCtrl_txAckEnable;
        busCtrl_rsp_payload_fragment_data[4 : 4] = bridge_interruptCtrl_start_enable;
        busCtrl_rsp_payload_fragment_data[5 : 5] = bridge_interruptCtrl_restart_enable;
        busCtrl_rsp_payload_fragment_data[6 : 6] = bridge_interruptCtrl_end_enable;
        busCtrl_rsp_payload_fragment_data[7 : 7] = bridge_interruptCtrl_drop_enable;
        busCtrl_rsp_payload_fragment_data[17 : 17] = bridge_interruptCtrl_filterGen_enable;
        busCtrl_rsp_payload_fragment_data[15 : 15] = bridge_interruptCtrl_clockGenExit_enable;
        busCtrl_rsp_payload_fragment_data[16 : 16] = bridge_interruptCtrl_clockGenEnter_enable;
      end
      8'h24 : begin
        busCtrl_rsp_payload_fragment_data[4 : 4] = bridge_interruptCtrl_start_flag;
        busCtrl_rsp_payload_fragment_data[5 : 5] = bridge_interruptCtrl_restart_flag;
        busCtrl_rsp_payload_fragment_data[6 : 6] = bridge_interruptCtrl_end_flag;
        busCtrl_rsp_payload_fragment_data[7 : 7] = bridge_interruptCtrl_drop_flag;
        busCtrl_rsp_payload_fragment_data[17 : 17] = bridge_interruptCtrl_filterGen_flag;
        busCtrl_rsp_payload_fragment_data[15 : 15] = bridge_interruptCtrl_clockGenExit_flag;
        busCtrl_rsp_payload_fragment_data[16 : 16] = bridge_interruptCtrl_clockGenEnter_flag;
      end
      8'h44 : begin
        busCtrl_rsp_payload_fragment_data[0 : 0] = i2cCtrl_io_internals_inFrame;
        busCtrl_rsp_payload_fragment_data[1 : 1] = i2cCtrl_io_internals_sdaRead;
        busCtrl_rsp_payload_fragment_data[2 : 2] = i2cCtrl_io_internals_sclRead;
      end
      8'h48 : begin
        busCtrl_rsp_payload_fragment_data[1 : 1] = bridge_slaveOverride_sda;
        busCtrl_rsp_payload_fragment_data[2 : 2] = bridge_slaveOverride_scl;
      end
      default : begin
      end
    endcase
  end

  assign busCtrl_rsp_payload_fragment_context = io_ctrl_cmd_payload_fragment_context;
  assign bridge_busCtrlWithOffset_readErrorFlag = 1'b0;
  assign bridge_busCtrlWithOffset_writeErrorFlag = 1'b0;
  always @(*) begin
    bridge_frameReset = 1'b0;
    case(i2cCtrl_io_bus_cmd_kind)
      Axi4PeripheralI2cSlaveCmdMode_START : begin
        bridge_frameReset = 1'b1;
      end
      Axi4PeripheralI2cSlaveCmdMode_RESTART : begin
        bridge_frameReset = 1'b1;
      end
      Axi4PeripheralI2cSlaveCmdMode_STOP : begin
        bridge_frameReset = 1'b1;
      end
      Axi4PeripheralI2cSlaveCmdMode_DROP : begin
        bridge_frameReset = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    bridge_i2cBuffer_sda_write = i2cCtrl_io_i2c_sda_write;
    case(bridge_masterLogic_fsm_stateReg)
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 : begin
        bridge_i2cBuffer_sda_write = 1'b0;
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 : begin
        bridge_i2cBuffer_sda_write = 1'b0;
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 : begin
        bridge_i2cBuffer_sda_write = 1'b0;
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 : begin
        bridge_i2cBuffer_sda_write = 1'b0;
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF : begin
      end
      default : begin
      end
    endcase
    if(when_I2cCtrl_l673) begin
      bridge_i2cBuffer_sda_write = 1'b0;
    end
  end

  always @(*) begin
    bridge_i2cBuffer_scl_write = i2cCtrl_io_i2c_scl_write;
    case(bridge_masterLogic_fsm_stateReg)
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 : begin
        bridge_i2cBuffer_scl_write = 1'b0;
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW : begin
        if(bridge_masterLogic_timer_done) begin
          if(when_I2cCtrl_l418) begin
            bridge_i2cBuffer_scl_write = 1'b0;
          end else begin
            if(when_I2cCtrl_l422) begin
              bridge_i2cBuffer_scl_write = 1'b0;
            end
          end
        end else begin
          bridge_i2cBuffer_scl_write = 1'b0;
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 : begin
        bridge_i2cBuffer_scl_write = 1'b0;
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF : begin
      end
      default : begin
      end
    endcase
    if(when_I2cCtrl_l674) begin
      bridge_i2cBuffer_scl_write = 1'b0;
    end
  end

  always @(*) begin
    when_I2cCtrl_l224 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h08 : begin
        if(busCtrl_doRead) begin
          when_I2cCtrl_l224 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    when_I2cCtrl_l237 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h0c : begin
        if(busCtrl_doRead) begin
          when_I2cCtrl_l237 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    bridge_txData_forceDisable = 1'b0;
    if(when_I2cCtrl_l601) begin
      bridge_txData_forceDisable = 1'b0;
    end
    case(bridge_masterLogic_fsm_stateReg)
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW : begin
        if(bridge_masterLogic_timer_done) begin
          if(when_I2cCtrl_l418) begin
            bridge_txData_forceDisable = 1'b1;
          end else begin
            if(when_I2cCtrl_l422) begin
              bridge_txData_forceDisable = 1'b1;
            end
          end
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF : begin
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    bridge_txAck_forceAck = 1'b0;
    if(when_I2cCtrl_l306) begin
      bridge_txAck_forceAck = 1'b1;
    end
  end

  assign bridge_addressFilter_byte0Is10Bit = (bridge_addressFilter_byte0[7 : 3] == 5'h1e);
  assign bridge_addressFilter_hits_0 = (bridge_addressFilter_addresses_0_enable && ((! bridge_addressFilter_addresses_0_is10Bit) ? ((_zz_bridge_addressFilter_hits_0 == bridge_addressFilter_addresses_0_value[6 : 0]) && (bridge_addressFilter_state != 2'b00)) : (({bridge_addressFilter_byte0[2 : 1],bridge_addressFilter_byte1} == bridge_addressFilter_addresses_0_value) && (bridge_addressFilter_state == 2'b10))));
  assign bridge_addressFilter_hits_1 = (bridge_addressFilter_addresses_1_enable && ((! bridge_addressFilter_addresses_1_is10Bit) ? ((_zz_bridge_addressFilter_hits_1 == bridge_addressFilter_addresses_1_value[6 : 0]) && (bridge_addressFilter_state != 2'b00)) : (({bridge_addressFilter_byte0[2 : 1],bridge_addressFilter_byte1} == bridge_addressFilter_addresses_1_value) && (bridge_addressFilter_state == 2'b10))));
  assign when_I2cCtrl_l306 = ((bridge_addressFilter_byte0Is10Bit && (bridge_addressFilter_state == 2'b01)) && (|{((bridge_addressFilter_addresses_1_enable && bridge_addressFilter_addresses_1_is10Bit) && (bridge_addressFilter_byte0[2 : 1] == bridge_addressFilter_addresses_1_value[9 : 8])),((bridge_addressFilter_addresses_0_enable && bridge_addressFilter_addresses_0_is10Bit) && (bridge_addressFilter_byte0[2 : 1] == bridge_addressFilter_addresses_0_value[9 : 8]))}));
  assign _zz_when_I2cCtrl_l310 = (|{bridge_addressFilter_hits_1,bridge_addressFilter_hits_0});
  assign when_I2cCtrl_l310 = (_zz_when_I2cCtrl_l310 && (! _zz_when_I2cCtrl_l310_1));
  always @(*) begin
    when_BusSlaveFactory_l377 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h40 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l377 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379 = io_ctrl_cmd_payload_fragment_data[4];
  always @(*) begin
    when_BusSlaveFactory_l377_1 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h40 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l377_1 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_1 = io_ctrl_cmd_payload_fragment_data[5];
  always @(*) begin
    when_BusSlaveFactory_l377_2 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h40 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l377_2 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_2 = io_ctrl_cmd_payload_fragment_data[6];
  always @(*) begin
    when_BusSlaveFactory_l377_3 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h40 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l377_3 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379_3 = io_ctrl_cmd_payload_fragment_data[7];
  assign bridge_masterLogic_timer_done = (bridge_masterLogic_timer_value == 12'h0);
  assign bridge_masterLogic_fsm_wantExit = 1'b0;
  always @(*) begin
    bridge_masterLogic_fsm_wantStart = 1'b0;
    case(bridge_masterLogic_fsm_stateReg)
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF : begin
      end
      default : begin
        bridge_masterLogic_fsm_wantStart = 1'b1;
      end
    endcase
  end

  assign bridge_masterLogic_fsm_wantKill = 1'b0;
  always @(*) begin
    bridge_masterLogic_fsm_dropped_trigger = 1'b0;
    if(when_I2cCtrl_l350) begin
      bridge_masterLogic_fsm_dropped_trigger = 1'b1;
    end
  end

  assign when_I2cCtrl_l363 = (! i2cCtrl_io_internals_sclRead);
  assign when_I2cCtrl_l363_1 = (! i2cCtrl_io_internals_inFrame);
  assign bridge_masterLogic_fsm_outOfSync = ((! i2cCtrl_io_internals_inFrame) && ((! i2cCtrl_io_internals_sdaRead) || (! i2cCtrl_io_internals_sclRead)));
  assign bridge_masterLogic_fsm_isBusy = ((! (bridge_masterLogic_fsm_stateReg == Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE)) && (! (bridge_masterLogic_fsm_stateReg == Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF)));
  always @(*) begin
    when_BusSlaveFactory_l341 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h40 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347 = io_ctrl_cmd_payload_fragment_data[9];
  always @(*) begin
    when_BusSlaveFactory_l341_1 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h40 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_1 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_1 = io_ctrl_cmd_payload_fragment_data[10];
  always @(*) begin
    when_BusSlaveFactory_l341_2 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h40 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_2 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_2 = io_ctrl_cmd_payload_fragment_data[11];
  assign bridge_masterLogic_txReady = (bridge_inAckState ? bridge_txAck_valid : bridge_txData_valid);
  assign when_I2cCtrl_l523 = (! bridge_inAckState);
  always @(*) begin
    if(when_I2cCtrl_l523) begin
      i2cCtrl_io_bus_rsp_valid = ((bridge_txData_valid && (! (bridge_rxData_valid && bridge_rxData_listen))) && (i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_DRIVE));
      if(bridge_txData_forceDisable) begin
        i2cCtrl_io_bus_rsp_valid = 1'b1;
      end
    end else begin
      i2cCtrl_io_bus_rsp_valid = ((bridge_txAck_valid && (! (bridge_rxAck_valid && bridge_rxAck_listen))) && (i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_DRIVE));
      if(bridge_txAck_forceAck) begin
        i2cCtrl_io_bus_rsp_valid = 1'b1;
      end
    end
    if(when_I2cCtrl_l546) begin
      i2cCtrl_io_bus_rsp_valid = (i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_DRIVE);
    end
  end

  always @(*) begin
    if(when_I2cCtrl_l523) begin
      i2cCtrl_io_bus_rsp_enable = bridge_txData_enable;
      if(bridge_txData_forceDisable) begin
        i2cCtrl_io_bus_rsp_enable = 1'b0;
      end
    end else begin
      i2cCtrl_io_bus_rsp_enable = bridge_txAck_enable;
      if(bridge_txAck_forceAck) begin
        i2cCtrl_io_bus_rsp_enable = 1'b1;
      end
    end
    if(when_I2cCtrl_l546) begin
      i2cCtrl_io_bus_rsp_enable = 1'b0;
    end
  end

  always @(*) begin
    if(when_I2cCtrl_l523) begin
      i2cCtrl_io_bus_rsp_data = bridge_txData_value[_zz_io_bus_rsp_data];
    end else begin
      i2cCtrl_io_bus_rsp_data = bridge_txAck_value;
      if(bridge_txAck_forceAck) begin
        i2cCtrl_io_bus_rsp_data = 1'b0;
      end
    end
  end

  assign when_I2cCtrl_l546 = (bridge_wasntAck && (! bridge_masterLogic_fsm_isBusy));
  assign when_I2cCtrl_l566 = (! bridge_inAckState);
  assign when_I2cCtrl_l570 = (i2cCtrl_io_bus_rsp_data != i2cCtrl_io_bus_cmd_data);
  assign when_I2cCtrl_l574 = (bridge_dataCounter == 3'b111);
  assign when_I2cCtrl_l578 = (bridge_txData_valid && (! bridge_txData_repeat));
  assign when_I2cCtrl_l588 = (bridge_txAck_valid && (! bridge_txAck_repeat));
  assign when_I2cCtrl_l601 = ((i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_STOP) || (i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_DROP));
  always @(*) begin
    bridge_interruptCtrl_interrupt = ((((bridge_interruptCtrl_rxDataEnable && bridge_rxData_valid) || (bridge_interruptCtrl_rxAckEnable && bridge_rxAck_valid)) || (bridge_interruptCtrl_txDataEnable && (! bridge_txData_valid))) || (bridge_interruptCtrl_txAckEnable && (! bridge_txAck_valid)));
    if(bridge_interruptCtrl_start_flag) begin
      bridge_interruptCtrl_interrupt = 1'b1;
    end
    if(bridge_interruptCtrl_restart_flag) begin
      bridge_interruptCtrl_interrupt = 1'b1;
    end
    if(bridge_interruptCtrl_end_flag) begin
      bridge_interruptCtrl_interrupt = 1'b1;
    end
    if(bridge_interruptCtrl_drop_flag) begin
      bridge_interruptCtrl_interrupt = 1'b1;
    end
    if(bridge_interruptCtrl_filterGen_flag) begin
      bridge_interruptCtrl_interrupt = 1'b1;
    end
    if(bridge_interruptCtrl_clockGenExit_flag) begin
      bridge_interruptCtrl_interrupt = 1'b1;
    end
    if(bridge_interruptCtrl_clockGenEnter_flag) begin
      bridge_interruptCtrl_interrupt = 1'b1;
    end
  end

  assign when_I2cCtrl_l634 = (i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_START);
  assign when_I2cCtrl_l634_1 = (! bridge_interruptCtrl_start_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_3 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h24 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_3 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_3 = io_ctrl_cmd_payload_fragment_data[4];
  assign when_I2cCtrl_l634_2 = (i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_RESTART);
  assign when_I2cCtrl_l634_3 = (! bridge_interruptCtrl_restart_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_4 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h24 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_4 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_4 = io_ctrl_cmd_payload_fragment_data[5];
  assign when_I2cCtrl_l634_4 = (i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_STOP);
  assign when_I2cCtrl_l634_5 = (! bridge_interruptCtrl_end_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_5 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h24 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_5 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_5 = io_ctrl_cmd_payload_fragment_data[6];
  assign when_I2cCtrl_l634_6 = ((i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_DROP) || bridge_masterLogic_fsm_dropped_trigger);
  assign when_I2cCtrl_l634_7 = (! bridge_interruptCtrl_drop_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_6 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h24 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_6 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_6 = io_ctrl_cmd_payload_fragment_data[7];
  assign _zz_when_I2cCtrl_l634 = (|{bridge_addressFilter_hits_1,bridge_addressFilter_hits_0});
  assign when_I2cCtrl_l634_8 = (_zz_when_I2cCtrl_l634 && (! _zz_when_I2cCtrl_l634_1));
  assign when_I2cCtrl_l634_9 = (! bridge_interruptCtrl_filterGen_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_7 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h24 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_7 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_7 = io_ctrl_cmd_payload_fragment_data[17];
  assign when_I2cCtrl_l634_10 = ((! bridge_masterLogic_fsm_isBusy) && bridge_masterLogic_fsm_isBusy_regNext);
  assign when_I2cCtrl_l634_11 = (! bridge_interruptCtrl_clockGenExit_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_8 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h24 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_8 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_8 = io_ctrl_cmd_payload_fragment_data[15];
  assign when_I2cCtrl_l634_12 = (bridge_masterLogic_fsm_isBusy && (! bridge_masterLogic_fsm_isBusy_regNext_1));
  assign when_I2cCtrl_l634_13 = (! bridge_interruptCtrl_clockGenEnter_enable);
  always @(*) begin
    when_BusSlaveFactory_l341_9 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      8'h24 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_9 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_9 = io_ctrl_cmd_payload_fragment_data[16];
  always @(*) begin
    i2cCtrl_io_config_timeoutClear = bridge_timeoutClear;
    if(when_I2cCtrl_l659) begin
      i2cCtrl_io_config_timeoutClear = 1'b1;
    end
  end

  assign when_I2cCtrl_l659 = ((! i2cCtrl_io_internals_inFrame) && (! bridge_masterLogic_fsm_isBusy));
  always @(*) begin
    bridge_masterLogic_fsm_stateNext = bridge_masterLogic_fsm_stateReg;
    case(bridge_masterLogic_fsm_stateReg)
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE : begin
        if(when_I2cCtrl_l367) begin
          bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF;
        end else begin
          if(when_I2cCtrl_l369) begin
            bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1;
          end else begin
            if(bridge_masterLogic_recover) begin
              bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW;
            end
          end
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 : begin
        if(when_I2cCtrl_l380) begin
          bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2;
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 : begin
        if(when_I2cCtrl_l392) begin
          bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3;
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 : begin
        if(bridge_masterLogic_timer_done) begin
          bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW;
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW : begin
        if(bridge_masterLogic_timer_done) begin
          if(when_I2cCtrl_l418) begin
            bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1;
          end else begin
            if(when_I2cCtrl_l422) begin
              bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART;
            end else begin
              if(i2cCtrl_io_internals_sclRead) begin
                bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH;
              end
            end
          end
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH : begin
        if(when_I2cCtrl_l442) begin
          bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW;
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART : begin
        if(!when_I2cCtrl_l450) begin
          if(bridge_masterLogic_timer_done) begin
            bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1;
          end
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 : begin
        if(bridge_masterLogic_timer_done) begin
          bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2;
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 : begin
        if(!when_I2cCtrl_l474) begin
          if(bridge_masterLogic_timer_done) begin
            bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3;
          end
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 : begin
        if(i2cCtrl_io_internals_sdaRead) begin
          bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF;
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF : begin
        if(bridge_masterLogic_timer_done) begin
          bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE;
        end
      end
      default : begin
      end
    endcase
    if(when_I2cCtrl_l350) begin
      bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF;
    end
    if(bridge_masterLogic_fsm_wantStart) begin
      bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE;
    end
    if(bridge_masterLogic_fsm_wantKill) begin
      bridge_masterLogic_fsm_stateNext = Axi4Peripheralbridge_masterLogic_fsm_enumDef_BOOT;
    end
  end

  assign when_I2cCtrl_l367 = ((! i2cCtrl_io_internals_inFrame) && i2cCtrl_io_internals_inFrame_regNext);
  assign when_I2cCtrl_l369 = (bridge_masterLogic_start && (! bridge_masterLogic_fsm_inFrameLate));
  assign when_I2cCtrl_l380 = (! bridge_masterLogic_fsm_outOfSync);
  assign when_I2cCtrl_l392 = (bridge_masterLogic_timer_done || (! i2cCtrl_io_internals_sclRead));
  assign when_I2cCtrl_l418 = ((bridge_masterLogic_stop && (! bridge_inAckState)) || (bridge_masterLogic_recover && i2cCtrl_io_internals_sdaRead));
  assign when_I2cCtrl_l422 = (bridge_masterLogic_start && (! bridge_inAckState));
  assign when_I2cCtrl_l442 = (bridge_masterLogic_timer_done || (! i2cCtrl_io_internals_sclRead));
  assign when_I2cCtrl_l450 = (! i2cCtrl_io_internals_sclRead);
  assign when_I2cCtrl_l474 = (! i2cCtrl_io_internals_sclRead);
  assign when_StateMachine_l253 = ((! (bridge_masterLogic_fsm_stateReg == Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2)) && (bridge_masterLogic_fsm_stateNext == Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2));
  assign when_StateMachine_l253_1 = ((! (bridge_masterLogic_fsm_stateReg == Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3)) && (bridge_masterLogic_fsm_stateNext == Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3));
  assign when_StateMachine_l253_2 = ((! (bridge_masterLogic_fsm_stateReg == Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW)) && (bridge_masterLogic_fsm_stateNext == Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW));
  assign when_StateMachine_l253_3 = ((! (bridge_masterLogic_fsm_stateReg == Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH)) && (bridge_masterLogic_fsm_stateNext == Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH));
  assign when_StateMachine_l253_4 = ((! (bridge_masterLogic_fsm_stateReg == Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1)) && (bridge_masterLogic_fsm_stateNext == Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1));
  assign when_StateMachine_l253_5 = ((! (bridge_masterLogic_fsm_stateReg == Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF)) && (bridge_masterLogic_fsm_stateNext == Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF));
  assign when_I2cCtrl_l350 = (bridge_masterLogic_drop || ((! (bridge_masterLogic_fsm_stateReg == Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE)) && ((i2cCtrl_io_bus_cmd_kind == Axi4PeripheralI2cSlaveCmdMode_DROP) || i2cCtrl_io_timeout)));
  assign when_I2cCtrl_l673 = (! bridge_slaveOverride_sda);
  assign when_I2cCtrl_l674 = (! bridge_slaveOverride_scl);
  assign io_i2c_scl_write = bridge_i2cBuffer_scl_write_regNext;
  assign io_i2c_sda_write = bridge_i2cBuffer_sda_write_regNext;
  assign bridge_i2cBuffer_scl_read = io_i2c_scl_read;
  assign bridge_i2cBuffer_sda_read = io_i2c_sda_read;
  assign system_i2c_0_io_interrupt_source = bridge_interruptCtrl_interrupt;
  always @(posedge clk) begin
    if(reset) begin
      _zz_io_ctrl_rsp_valid_1 <= 1'b0;
      bridge_rxData_event <= 1'b0;
      bridge_rxData_listen <= 1'b0;
      bridge_rxData_valid <= 1'b0;
      bridge_rxAck_listen <= 1'b0;
      bridge_rxAck_valid <= 1'b0;
      bridge_txData_valid <= 1'b1;
      bridge_txData_repeat <= 1'b1;
      bridge_txData_enable <= 1'b0;
      bridge_txAck_valid <= 1'b1;
      bridge_txAck_repeat <= 1'b1;
      bridge_txAck_enable <= 1'b0;
      bridge_addressFilter_addresses_0_enable <= 1'b0;
      bridge_addressFilter_addresses_1_enable <= 1'b0;
      bridge_addressFilter_state <= 2'b00;
      bridge_masterLogic_start <= 1'b0;
      bridge_masterLogic_stop <= 1'b0;
      bridge_masterLogic_drop <= 1'b0;
      bridge_masterLogic_recover <= 1'b0;
      bridge_masterLogic_fsm_dropped_start <= 1'b0;
      bridge_masterLogic_fsm_dropped_stop <= 1'b0;
      bridge_masterLogic_fsm_dropped_recover <= 1'b0;
      bridge_dataCounter <= 3'b000;
      bridge_inAckState <= 1'b0;
      bridge_wasntAck <= 1'b0;
      bridge_interruptCtrl_rxDataEnable <= 1'b0;
      bridge_interruptCtrl_rxAckEnable <= 1'b0;
      bridge_interruptCtrl_txDataEnable <= 1'b0;
      bridge_interruptCtrl_txAckEnable <= 1'b0;
      bridge_interruptCtrl_start_enable <= 1'b0;
      bridge_interruptCtrl_start_flag <= 1'b0;
      bridge_interruptCtrl_restart_enable <= 1'b0;
      bridge_interruptCtrl_restart_flag <= 1'b0;
      bridge_interruptCtrl_end_enable <= 1'b0;
      bridge_interruptCtrl_end_flag <= 1'b0;
      bridge_interruptCtrl_drop_enable <= 1'b0;
      bridge_interruptCtrl_drop_flag <= 1'b0;
      bridge_interruptCtrl_filterGen_enable <= 1'b0;
      bridge_interruptCtrl_filterGen_flag <= 1'b0;
      bridge_interruptCtrl_clockGenExit_enable <= 1'b0;
      bridge_interruptCtrl_clockGenExit_flag <= 1'b0;
      bridge_interruptCtrl_clockGenEnter_enable <= 1'b0;
      bridge_interruptCtrl_clockGenEnter_flag <= 1'b0;
      _zz_io_config_samplingClockDivider <= 10'h0;
      bridge_masterLogic_fsm_stateReg <= Axi4Peripheralbridge_masterLogic_fsm_enumDef_BOOT;
      bridge_slaveOverride_sda <= 1'b1;
      bridge_slaveOverride_scl <= 1'b1;
      bridge_i2cBuffer_scl_write_regNext <= 1'b1;
      bridge_i2cBuffer_sda_write_regNext <= 1'b1;
    end else begin
      if(_zz_busCtrl_rsp_ready_1) begin
        _zz_io_ctrl_rsp_valid_1 <= (busCtrl_rsp_valid && _zz_busCtrl_rsp_ready);
      end
      bridge_rxData_event <= 1'b0;
      if(when_I2cCtrl_l224) begin
        bridge_rxData_valid <= 1'b0;
      end
      if(when_I2cCtrl_l237) begin
        bridge_rxAck_valid <= 1'b0;
      end
      if(bridge_rxData_event) begin
        case(bridge_addressFilter_state)
          2'b00 : begin
            bridge_addressFilter_state <= 2'b01;
          end
          2'b01 : begin
            bridge_addressFilter_state <= 2'b10;
          end
          default : begin
          end
        endcase
      end
      if(bridge_frameReset) begin
        bridge_addressFilter_state <= 2'b00;
      end
      if(when_I2cCtrl_l310) begin
        bridge_txAck_valid <= 1'b0;
      end
      if(when_BusSlaveFactory_l377) begin
        if(when_BusSlaveFactory_l379) begin
          bridge_masterLogic_start <= _zz_bridge_masterLogic_start[0];
        end
      end
      if(when_BusSlaveFactory_l377_1) begin
        if(when_BusSlaveFactory_l379_1) begin
          bridge_masterLogic_stop <= _zz_bridge_masterLogic_stop[0];
        end
      end
      if(when_BusSlaveFactory_l377_2) begin
        if(when_BusSlaveFactory_l379_2) begin
          bridge_masterLogic_drop <= _zz_bridge_masterLogic_drop[0];
        end
      end
      if(when_BusSlaveFactory_l377_3) begin
        if(when_BusSlaveFactory_l379_3) begin
          bridge_masterLogic_recover <= _zz_bridge_masterLogic_recover[0];
        end
      end
      if(when_BusSlaveFactory_l341) begin
        if(when_BusSlaveFactory_l347) begin
          bridge_masterLogic_fsm_dropped_start <= _zz_bridge_masterLogic_fsm_dropped_start[0];
        end
      end
      if(when_BusSlaveFactory_l341_1) begin
        if(when_BusSlaveFactory_l347_1) begin
          bridge_masterLogic_fsm_dropped_stop <= _zz_bridge_masterLogic_fsm_dropped_stop[0];
        end
      end
      if(when_BusSlaveFactory_l341_2) begin
        if(when_BusSlaveFactory_l347_2) begin
          bridge_masterLogic_fsm_dropped_recover <= _zz_bridge_masterLogic_fsm_dropped_recover[0];
        end
      end
      case(i2cCtrl_io_bus_cmd_kind)
        Axi4PeripheralI2cSlaveCmdMode_READ : begin
          if(when_I2cCtrl_l566) begin
            bridge_dataCounter <= (bridge_dataCounter + 3'b001);
            if(when_I2cCtrl_l570) begin
              if(bridge_txData_disableOnDataConflict) begin
                bridge_txData_enable <= 1'b0;
              end
              if(bridge_txAck_disableOnDataConflict) begin
                bridge_txAck_enable <= 1'b0;
              end
            end
            if(when_I2cCtrl_l574) begin
              if(bridge_rxData_listen) begin
                bridge_rxData_valid <= 1'b1;
              end
              bridge_rxData_event <= 1'b1;
              bridge_inAckState <= 1'b1;
              if(when_I2cCtrl_l578) begin
                bridge_txData_valid <= 1'b0;
              end
            end
          end else begin
            if(bridge_rxAck_listen) begin
              bridge_rxAck_valid <= 1'b1;
            end
            bridge_inAckState <= 1'b0;
            bridge_wasntAck <= i2cCtrl_io_bus_cmd_data;
            if(when_I2cCtrl_l588) begin
              bridge_txAck_valid <= 1'b0;
            end
          end
        end
        default : begin
        end
      endcase
      if(bridge_frameReset) begin
        bridge_inAckState <= 1'b0;
        bridge_dataCounter <= 3'b000;
        bridge_wasntAck <= 1'b0;
      end
      if(when_I2cCtrl_l601) begin
        bridge_txData_valid <= 1'b1;
        bridge_txData_enable <= 1'b0;
        bridge_txData_repeat <= 1'b1;
        bridge_txAck_valid <= 1'b1;
        bridge_txAck_enable <= 1'b0;
        bridge_txAck_repeat <= 1'b1;
        bridge_rxData_listen <= 1'b0;
        bridge_rxAck_listen <= 1'b0;
      end
      if(when_I2cCtrl_l634) begin
        bridge_interruptCtrl_start_flag <= 1'b1;
      end
      if(when_I2cCtrl_l634_1) begin
        bridge_interruptCtrl_start_flag <= 1'b0;
      end
      if(when_BusSlaveFactory_l341_3) begin
        if(when_BusSlaveFactory_l347_3) begin
          bridge_interruptCtrl_start_flag <= _zz_bridge_interruptCtrl_start_flag[0];
        end
      end
      if(when_I2cCtrl_l634_2) begin
        bridge_interruptCtrl_restart_flag <= 1'b1;
      end
      if(when_I2cCtrl_l634_3) begin
        bridge_interruptCtrl_restart_flag <= 1'b0;
      end
      if(when_BusSlaveFactory_l341_4) begin
        if(when_BusSlaveFactory_l347_4) begin
          bridge_interruptCtrl_restart_flag <= _zz_bridge_interruptCtrl_restart_flag[0];
        end
      end
      if(when_I2cCtrl_l634_4) begin
        bridge_interruptCtrl_end_flag <= 1'b1;
      end
      if(when_I2cCtrl_l634_5) begin
        bridge_interruptCtrl_end_flag <= 1'b0;
      end
      if(when_BusSlaveFactory_l341_5) begin
        if(when_BusSlaveFactory_l347_5) begin
          bridge_interruptCtrl_end_flag <= _zz_bridge_interruptCtrl_end_flag[0];
        end
      end
      if(when_I2cCtrl_l634_6) begin
        bridge_interruptCtrl_drop_flag <= 1'b1;
      end
      if(when_I2cCtrl_l634_7) begin
        bridge_interruptCtrl_drop_flag <= 1'b0;
      end
      if(when_BusSlaveFactory_l341_6) begin
        if(when_BusSlaveFactory_l347_6) begin
          bridge_interruptCtrl_drop_flag <= _zz_bridge_interruptCtrl_drop_flag[0];
        end
      end
      if(when_I2cCtrl_l634_8) begin
        bridge_interruptCtrl_filterGen_flag <= 1'b1;
      end
      if(when_I2cCtrl_l634_9) begin
        bridge_interruptCtrl_filterGen_flag <= 1'b0;
      end
      if(when_BusSlaveFactory_l341_7) begin
        if(when_BusSlaveFactory_l347_7) begin
          bridge_interruptCtrl_filterGen_flag <= _zz_bridge_interruptCtrl_filterGen_flag[0];
        end
      end
      if(when_I2cCtrl_l634_10) begin
        bridge_interruptCtrl_clockGenExit_flag <= 1'b1;
      end
      if(when_I2cCtrl_l634_11) begin
        bridge_interruptCtrl_clockGenExit_flag <= 1'b0;
      end
      if(when_BusSlaveFactory_l341_8) begin
        if(when_BusSlaveFactory_l347_8) begin
          bridge_interruptCtrl_clockGenExit_flag <= _zz_bridge_interruptCtrl_clockGenExit_flag[0];
        end
      end
      if(when_I2cCtrl_l634_12) begin
        bridge_interruptCtrl_clockGenEnter_flag <= 1'b1;
      end
      if(when_I2cCtrl_l634_13) begin
        bridge_interruptCtrl_clockGenEnter_flag <= 1'b0;
      end
      if(when_BusSlaveFactory_l341_9) begin
        if(when_BusSlaveFactory_l347_9) begin
          bridge_interruptCtrl_clockGenEnter_flag <= _zz_bridge_interruptCtrl_clockGenEnter_flag[0];
        end
      end
      bridge_masterLogic_fsm_stateReg <= bridge_masterLogic_fsm_stateNext;
      case(bridge_masterLogic_fsm_stateReg)
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE : begin
          if(!when_I2cCtrl_l367) begin
            if(when_I2cCtrl_l369) begin
              bridge_txData_valid <= 1'b0;
            end
          end
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 : begin
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 : begin
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 : begin
          if(bridge_masterLogic_timer_done) begin
            bridge_masterLogic_start <= 1'b0;
          end
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW : begin
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH : begin
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART : begin
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 : begin
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 : begin
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 : begin
          if(i2cCtrl_io_internals_sdaRead) begin
            bridge_masterLogic_stop <= 1'b0;
            bridge_masterLogic_recover <= 1'b0;
          end
        end
        Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF : begin
        end
        default : begin
        end
      endcase
      if(when_I2cCtrl_l350) begin
        bridge_masterLogic_start <= 1'b0;
        bridge_masterLogic_stop <= 1'b0;
        bridge_masterLogic_drop <= 1'b0;
        bridge_masterLogic_recover <= 1'b0;
        if(bridge_masterLogic_start) begin
          bridge_masterLogic_fsm_dropped_start <= 1'b1;
        end
        if(bridge_masterLogic_stop) begin
          bridge_masterLogic_fsm_dropped_stop <= 1'b1;
        end
      end
      bridge_i2cBuffer_scl_write_regNext <= bridge_i2cBuffer_scl_write;
      bridge_i2cBuffer_sda_write_regNext <= bridge_i2cBuffer_sda_write;
      case(io_ctrl_cmd_payload_fragment_address)
        8'h08 : begin
          if(busCtrl_doWrite) begin
            bridge_rxData_listen <= io_ctrl_cmd_payload_fragment_data[9];
          end
        end
        8'h0c : begin
          if(busCtrl_doWrite) begin
            bridge_rxAck_listen <= io_ctrl_cmd_payload_fragment_data[9];
          end
        end
        8'h0 : begin
          if(busCtrl_doWrite) begin
            bridge_txData_repeat <= io_ctrl_cmd_payload_fragment_data[10];
            bridge_txData_valid <= io_ctrl_cmd_payload_fragment_data[8];
            bridge_txData_enable <= io_ctrl_cmd_payload_fragment_data[9];
          end
        end
        8'h04 : begin
          if(busCtrl_doWrite) begin
            bridge_txAck_repeat <= io_ctrl_cmd_payload_fragment_data[10];
            bridge_txAck_valid <= io_ctrl_cmd_payload_fragment_data[8];
            bridge_txAck_enable <= io_ctrl_cmd_payload_fragment_data[9];
          end
        end
        8'h88 : begin
          if(busCtrl_doWrite) begin
            bridge_addressFilter_addresses_0_enable <= io_ctrl_cmd_payload_fragment_data[15];
          end
        end
        8'h8c : begin
          if(busCtrl_doWrite) begin
            bridge_addressFilter_addresses_1_enable <= io_ctrl_cmd_payload_fragment_data[15];
          end
        end
        8'h20 : begin
          if(busCtrl_doWrite) begin
            bridge_interruptCtrl_rxDataEnable <= io_ctrl_cmd_payload_fragment_data[0];
            bridge_interruptCtrl_rxAckEnable <= io_ctrl_cmd_payload_fragment_data[1];
            bridge_interruptCtrl_txDataEnable <= io_ctrl_cmd_payload_fragment_data[2];
            bridge_interruptCtrl_txAckEnable <= io_ctrl_cmd_payload_fragment_data[3];
            bridge_interruptCtrl_start_enable <= io_ctrl_cmd_payload_fragment_data[4];
            bridge_interruptCtrl_restart_enable <= io_ctrl_cmd_payload_fragment_data[5];
            bridge_interruptCtrl_end_enable <= io_ctrl_cmd_payload_fragment_data[6];
            bridge_interruptCtrl_drop_enable <= io_ctrl_cmd_payload_fragment_data[7];
            bridge_interruptCtrl_filterGen_enable <= io_ctrl_cmd_payload_fragment_data[17];
            bridge_interruptCtrl_clockGenExit_enable <= io_ctrl_cmd_payload_fragment_data[15];
            bridge_interruptCtrl_clockGenEnter_enable <= io_ctrl_cmd_payload_fragment_data[16];
          end
        end
        8'h28 : begin
          if(busCtrl_doWrite) begin
            _zz_io_config_samplingClockDivider <= io_ctrl_cmd_payload_fragment_data[9 : 0];
          end
        end
        8'h48 : begin
          if(busCtrl_doWrite) begin
            bridge_slaveOverride_sda <= io_ctrl_cmd_payload_fragment_data[1];
            bridge_slaveOverride_scl <= io_ctrl_cmd_payload_fragment_data[2];
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if(_zz_busCtrl_rsp_ready_1) begin
      _zz_io_ctrl_rsp_payload_last <= busCtrl_rsp_payload_last;
      _zz_io_ctrl_rsp_payload_fragment_opcode <= busCtrl_rsp_payload_fragment_opcode;
      _zz_io_ctrl_rsp_payload_fragment_data <= busCtrl_rsp_payload_fragment_data;
      _zz_io_ctrl_rsp_payload_fragment_context <= busCtrl_rsp_payload_fragment_context;
    end
    if(bridge_rxData_event) begin
      case(bridge_addressFilter_state)
        2'b00 : begin
          bridge_addressFilter_byte0 <= bridge_rxData_value;
        end
        2'b01 : begin
          bridge_addressFilter_byte1 <= bridge_rxData_value;
        end
        default : begin
        end
      endcase
    end
    _zz_when_I2cCtrl_l310_1 <= _zz_when_I2cCtrl_l310;
    bridge_masterLogic_timer_value <= (bridge_masterLogic_timer_value - _zz_bridge_masterLogic_timer_value);
    if(when_I2cCtrl_l363) begin
      bridge_masterLogic_fsm_inFrameLate <= 1'b1;
    end
    if(when_I2cCtrl_l363_1) begin
      bridge_masterLogic_fsm_inFrameLate <= 1'b0;
    end
    case(i2cCtrl_io_bus_cmd_kind)
      Axi4PeripheralI2cSlaveCmdMode_READ : begin
        if(when_I2cCtrl_l566) begin
          bridge_rxData_value[_zz_bridge_rxData_value] <= i2cCtrl_io_bus_cmd_data;
        end else begin
          bridge_rxAck_value <= i2cCtrl_io_bus_cmd_data;
        end
      end
      default : begin
      end
    endcase
    if(when_I2cCtrl_l601) begin
      bridge_txData_disableOnDataConflict <= 1'b0;
      bridge_txAck_disableOnDataConflict <= 1'b0;
    end
    _zz_when_I2cCtrl_l634_1 <= _zz_when_I2cCtrl_l634;
    bridge_masterLogic_fsm_isBusy_regNext <= bridge_masterLogic_fsm_isBusy;
    bridge_masterLogic_fsm_isBusy_regNext_1 <= bridge_masterLogic_fsm_isBusy;
    bridge_timeoutClear <= 1'b0;
    case(bridge_masterLogic_fsm_stateReg)
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_IDLE : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START1 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START2 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_START3 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_LOW : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_HIGH : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_RESTART : begin
        if(when_I2cCtrl_l450) begin
          bridge_masterLogic_timer_value <= bridge_masterLogic_timer_tHigh;
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP1 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP2 : begin
        if(when_I2cCtrl_l474) begin
          bridge_masterLogic_timer_value <= bridge_masterLogic_timer_tHigh;
        end
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_STOP3 : begin
      end
      Axi4Peripheralbridge_masterLogic_fsm_enumDef_TBUF : begin
      end
      default : begin
      end
    endcase
    if(when_StateMachine_l253) begin
      bridge_masterLogic_timer_value <= bridge_masterLogic_timer_tHigh;
    end
    if(when_StateMachine_l253_1) begin
      bridge_masterLogic_timer_value <= bridge_masterLogic_timer_tLow;
    end
    if(when_StateMachine_l253_2) begin
      bridge_masterLogic_timer_value <= bridge_masterLogic_timer_tLow;
    end
    if(when_StateMachine_l253_3) begin
      bridge_masterLogic_timer_value <= bridge_masterLogic_timer_tHigh;
    end
    if(when_StateMachine_l253_4) begin
      bridge_masterLogic_timer_value <= bridge_masterLogic_timer_tHigh;
    end
    if(when_StateMachine_l253_5) begin
      bridge_masterLogic_timer_value <= bridge_masterLogic_timer_tBuf;
    end
    case(io_ctrl_cmd_payload_fragment_address)
      8'h0 : begin
        if(busCtrl_doWrite) begin
          bridge_txData_value <= io_ctrl_cmd_payload_fragment_data[7 : 0];
          bridge_txData_disableOnDataConflict <= io_ctrl_cmd_payload_fragment_data[11];
        end
      end
      8'h04 : begin
        if(busCtrl_doWrite) begin
          bridge_txAck_value <= io_ctrl_cmd_payload_fragment_data[0];
          bridge_txAck_disableOnDataConflict <= io_ctrl_cmd_payload_fragment_data[11];
        end
      end
      8'h88 : begin
        if(busCtrl_doWrite) begin
          bridge_addressFilter_addresses_0_value <= io_ctrl_cmd_payload_fragment_data[9 : 0];
          bridge_addressFilter_addresses_0_is10Bit <= io_ctrl_cmd_payload_fragment_data[14];
        end
      end
      8'h8c : begin
        if(busCtrl_doWrite) begin
          bridge_addressFilter_addresses_1_value <= io_ctrl_cmd_payload_fragment_data[9 : 0];
          bridge_addressFilter_addresses_1_is10Bit <= io_ctrl_cmd_payload_fragment_data[14];
        end
      end
      8'h50 : begin
        if(busCtrl_doWrite) begin
          bridge_masterLogic_timer_tLow <= io_ctrl_cmd_payload_fragment_data[11 : 0];
        end
      end
      8'h54 : begin
        if(busCtrl_doWrite) begin
          bridge_masterLogic_timer_tHigh <= io_ctrl_cmd_payload_fragment_data[11 : 0];
        end
      end
      8'h58 : begin
        if(busCtrl_doWrite) begin
          bridge_masterLogic_timer_tBuf <= io_ctrl_cmd_payload_fragment_data[11 : 0];
        end
      end
      8'h2c : begin
        if(busCtrl_doWrite) begin
          _zz_io_config_timeout <= io_ctrl_cmd_payload_fragment_data[19 : 0];
          bridge_timeoutClear <= 1'b1;
        end
      end
      8'h30 : begin
        if(busCtrl_doWrite) begin
          _zz_io_config_tsuData <= io_ctrl_cmd_payload_fragment_data[5 : 0];
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk) begin
    if(reset) begin
      i2cCtrl_io_internals_inFrame_regNext <= 1'b0;
    end else begin
      i2cCtrl_io_internals_inFrame_regNext <= i2cCtrl_io_internals_inFrame;
    end
  end


endmodule

module Axi4PeripheralBmbSpiXdrMasterCtrl (
  input  wire          io_ctrl_cmd_valid,
  output wire          io_ctrl_cmd_ready,
  input  wire          io_ctrl_cmd_payload_last,
  input  wire [0:0]    io_ctrl_cmd_payload_fragment_opcode,
  input  wire [11:0]   io_ctrl_cmd_payload_fragment_address,
  input  wire [1:0]    io_ctrl_cmd_payload_fragment_length,
  input  wire [31:0]   io_ctrl_cmd_payload_fragment_data,
  input  wire [2:0]    io_ctrl_cmd_payload_fragment_context,
  output wire          io_ctrl_rsp_valid,
  input  wire          io_ctrl_rsp_ready,
  output wire          io_ctrl_rsp_payload_last,
  output wire [0:0]    io_ctrl_rsp_payload_fragment_opcode,
  output wire [31:0]   io_ctrl_rsp_payload_fragment_data,
  output wire [2:0]    io_ctrl_rsp_payload_fragment_context,
  output wire [0:0]    io_spi_sclk_write,
  output wire          io_spi_data_0_writeEnable,
  input  wire [0:0]    io_spi_data_0_read,
  output wire [0:0]    io_spi_data_0_write,
  output wire          io_spi_data_1_writeEnable,
  input  wire [0:0]    io_spi_data_1_read,
  output wire [0:0]    io_spi_data_1_write,
  output wire          io_spi_data_2_writeEnable,
  input  wire [0:0]    io_spi_data_2_read,
  output wire [0:0]    io_spi_data_2_write,
  output wire          io_spi_data_3_writeEnable,
  input  wire [0:0]    io_spi_data_3_read,
  output wire [0:0]    io_spi_data_3_write,
  output wire [3:0]    io_spi_ss,
  output wire          system_spi_0_io_interrupt_source,
  input  wire          clk,
  input  wire          reset
);

  wire                ctrl_io_rsp_queueWithOccupancy_io_pop_ready;
  wire                ctrl_io_cmd_ready;
  wire                ctrl_io_rsp_valid;
  wire       [7:0]    ctrl_io_rsp_payload_data;
  wire       [0:0]    ctrl_io_spi_sclk_write;
  wire       [3:0]    ctrl_io_spi_ss;
  wire       [0:0]    ctrl_io_spi_data_0_write;
  wire                ctrl_io_spi_data_0_writeEnable;
  wire       [0:0]    ctrl_io_spi_data_1_write;
  wire                ctrl_io_spi_data_1_writeEnable;
  wire       [0:0]    ctrl_io_spi_data_2_write;
  wire                ctrl_io_spi_data_2_writeEnable;
  wire       [0:0]    ctrl_io_spi_data_3_write;
  wire                ctrl_io_spi_data_3_writeEnable;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_push_ready;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_valid;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_kind;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_read;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_write;
  wire       [7:0]    mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_data;
  wire       [8:0]    mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_occupancy;
  wire       [8:0]    mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_availability;
  wire                ctrl_io_rsp_queueWithOccupancy_io_push_ready;
  wire                ctrl_io_rsp_queueWithOccupancy_io_pop_valid;
  wire       [7:0]    ctrl_io_rsp_queueWithOccupancy_io_pop_payload_data;
  wire       [8:0]    ctrl_io_rsp_queueWithOccupancy_io_occupancy;
  wire       [8:0]    ctrl_io_rsp_queueWithOccupancy_io_availability;
  wire                factory_readErrorFlag;
  wire                factory_writeErrorFlag;
  wire                factory_readHaltTrigger;
  wire                factory_writeHaltTrigger;
  wire                factory_rsp_valid;
  wire                factory_rsp_ready;
  wire                factory_rsp_payload_last;
  reg        [0:0]    factory_rsp_payload_fragment_opcode;
  reg        [31:0]   factory_rsp_payload_fragment_data;
  wire       [2:0]    factory_rsp_payload_fragment_context;
  wire                _zz_factory_rsp_ready;
  reg                 _zz_factory_rsp_ready_1;
  wire                _zz_io_ctrl_rsp_valid;
  reg                 _zz_io_ctrl_rsp_valid_1;
  reg                 _zz_io_ctrl_rsp_payload_last;
  reg        [0:0]    _zz_io_ctrl_rsp_payload_fragment_opcode;
  reg        [31:0]   _zz_io_ctrl_rsp_payload_fragment_data;
  reg        [2:0]    _zz_io_ctrl_rsp_payload_fragment_context;
  wire                when_Stream_l375;
  wire                factory_askWrite;
  wire                factory_askRead;
  wire                io_ctrl_cmd_fire;
  wire                factory_doWrite;
  wire                factory_doRead;
  wire                when_BmbSlaveFactory_l33;
  wire                when_BmbSlaveFactory_l35;
  wire       [31:0]   mapping_cmdLogic_writeData;
  reg                 mapping_cmdLogic_doRegular;
  reg                 mapping_cmdLogic_doWriteLarge;
  reg                 mapping_cmdLogic_doReadWriteLarge;
  wire                mapping_cmdLogic_streamUnbuffered_valid;
  wire                mapping_cmdLogic_streamUnbuffered_ready;
  wire                mapping_cmdLogic_streamUnbuffered_payload_kind;
  wire                mapping_cmdLogic_streamUnbuffered_payload_read;
  wire                mapping_cmdLogic_streamUnbuffered_payload_write;
  wire       [7:0]    mapping_cmdLogic_streamUnbuffered_payload_data;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_valid;
  reg                 mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_ready;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_kind;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_read;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_write;
  wire       [7:0]    mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_data;
  reg                 mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN;
  reg                 mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_kind;
  reg                 mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_read;
  reg                 mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_write;
  reg        [7:0]    mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_data;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_valid;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_ready;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_kind;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_read;
  wire                mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_write;
  wire       [7:0]    mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_data;
  reg                 mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rValid;
  reg                 mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_kind;
  reg                 mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_read;
  reg                 mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_write;
  reg        [7:0]    mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_data;
  wire                when_Stream_l375_1;
  wire                ctrl_io_rsp_toStream_valid;
  wire                ctrl_io_rsp_toStream_ready;
  wire       [7:0]    ctrl_io_rsp_toStream_payload_data;
  reg                 _zz_io_pop_ready;
  reg                 _zz_io_pop_ready_1;
  reg                 mapping_interruptCtrl_cmdIntEnable;
  reg                 mapping_interruptCtrl_rspIntEnable;
  wire                mapping_interruptCtrl_cmdInt;
  wire                mapping_interruptCtrl_rspInt;
  wire                mapping_interruptCtrl_interrupt;
  reg                 _zz_io_config_kind_cpol;
  reg                 _zz_io_config_kind_cpha;
  reg        [1:0]    _zz_io_config_mod;
  reg        [11:0]   _zz_io_config_sclkToggle;
  reg        [11:0]   _zz_io_config_ss_setup;
  reg        [11:0]   _zz_io_config_ss_hold;
  reg        [11:0]   _zz_io_config_ss_disable;
  reg        [3:0]    _zz_io_config_ss_activeHigh;
  wire       [1:0]    _zz_io_config_kind_cpol_1;

  Axi4PeripheralTopLevel ctrl (
    .io_config_kind_cpol       (_zz_io_config_kind_cpol                                                                         ), //i
    .io_config_kind_cpha       (_zz_io_config_kind_cpha                                                                         ), //i
    .io_config_sclkToggle      (_zz_io_config_sclkToggle[11:0]                                                                  ), //i
    .io_config_mod             (_zz_io_config_mod[1:0]                                                                          ), //i
    .io_config_ss_activeHigh   (_zz_io_config_ss_activeHigh[3:0]                                                                ), //i
    .io_config_ss_setup        (_zz_io_config_ss_setup[11:0]                                                                    ), //i
    .io_config_ss_hold         (_zz_io_config_ss_hold[11:0]                                                                     ), //i
    .io_config_ss_disable      (_zz_io_config_ss_disable[11:0]                                                                  ), //i
    .io_cmd_valid              (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_valid            ), //i
    .io_cmd_ready              (ctrl_io_cmd_ready                                                                               ), //o
    .io_cmd_payload_kind       (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_kind     ), //i
    .io_cmd_payload_read       (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_read     ), //i
    .io_cmd_payload_write      (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_write    ), //i
    .io_cmd_payload_data       (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_data[7:0]), //i
    .io_rsp_valid              (ctrl_io_rsp_valid                                                                               ), //o
    .io_rsp_payload_data       (ctrl_io_rsp_payload_data[7:0]                                                                   ), //o
    .io_spi_sclk_write         (ctrl_io_spi_sclk_write                                                                          ), //o
    .io_spi_data_0_writeEnable (ctrl_io_spi_data_0_writeEnable                                                                  ), //o
    .io_spi_data_0_read        (io_spi_data_0_read                                                                              ), //i
    .io_spi_data_0_write       (ctrl_io_spi_data_0_write                                                                        ), //o
    .io_spi_data_1_writeEnable (ctrl_io_spi_data_1_writeEnable                                                                  ), //o
    .io_spi_data_1_read        (io_spi_data_1_read                                                                              ), //i
    .io_spi_data_1_write       (ctrl_io_spi_data_1_write                                                                        ), //o
    .io_spi_data_2_writeEnable (ctrl_io_spi_data_2_writeEnable                                                                  ), //o
    .io_spi_data_2_read        (io_spi_data_2_read                                                                              ), //i
    .io_spi_data_2_write       (ctrl_io_spi_data_2_write                                                                        ), //o
    .io_spi_data_3_writeEnable (ctrl_io_spi_data_3_writeEnable                                                                  ), //o
    .io_spi_data_3_read        (io_spi_data_3_read                                                                              ), //i
    .io_spi_data_3_write       (ctrl_io_spi_data_3_write                                                                        ), //o
    .io_spi_ss                 (ctrl_io_spi_ss[3:0]                                                                             ), //o
    .clk                       (clk                                                                                             ), //i
    .reset                     (reset                                                                                           )  //i
  );
  Axi4PeripheralStreamFifo_2 mapping_cmdLogic_streamUnbuffered_queueWithAvailability (
    .io_push_valid         (mapping_cmdLogic_streamUnbuffered_valid                                         ), //i
    .io_push_ready         (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_push_ready           ), //o
    .io_push_payload_kind  (mapping_cmdLogic_streamUnbuffered_payload_kind                                  ), //i
    .io_push_payload_read  (mapping_cmdLogic_streamUnbuffered_payload_read                                  ), //i
    .io_push_payload_write (mapping_cmdLogic_streamUnbuffered_payload_write                                 ), //i
    .io_push_payload_data  (mapping_cmdLogic_streamUnbuffered_payload_data[7:0]                             ), //i
    .io_pop_valid          (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_valid            ), //o
    .io_pop_ready          (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN          ), //i
    .io_pop_payload_kind   (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_kind     ), //o
    .io_pop_payload_read   (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_read     ), //o
    .io_pop_payload_write  (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_write    ), //o
    .io_pop_payload_data   (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_data[7:0]), //o
    .io_flush              (1'b0                                                                            ), //i
    .io_occupancy          (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_occupancy[8:0]       ), //o
    .io_availability       (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_availability[8:0]    ), //o
    .clk                   (clk                                                                             ), //i
    .reset                 (reset                                                                           )  //i
  );
  Axi4PeripheralStreamFifo_3 ctrl_io_rsp_queueWithOccupancy (
    .io_push_valid        (ctrl_io_rsp_toStream_valid                             ), //i
    .io_push_ready        (ctrl_io_rsp_queueWithOccupancy_io_push_ready           ), //o
    .io_push_payload_data (ctrl_io_rsp_toStream_payload_data[7:0]                 ), //i
    .io_pop_valid         (ctrl_io_rsp_queueWithOccupancy_io_pop_valid            ), //o
    .io_pop_ready         (ctrl_io_rsp_queueWithOccupancy_io_pop_ready            ), //i
    .io_pop_payload_data  (ctrl_io_rsp_queueWithOccupancy_io_pop_payload_data[7:0]), //o
    .io_flush             (1'b0                                                   ), //i
    .io_occupancy         (ctrl_io_rsp_queueWithOccupancy_io_occupancy[8:0]       ), //o
    .io_availability      (ctrl_io_rsp_queueWithOccupancy_io_availability[8:0]    ), //o
    .clk                  (clk                                                    ), //i
    .reset                (reset                                                  )  //i
  );
  assign factory_readErrorFlag = 1'b0;
  assign factory_writeErrorFlag = 1'b0;
  assign factory_readHaltTrigger = 1'b0;
  assign factory_writeHaltTrigger = 1'b0;
  assign _zz_factory_rsp_ready = (! (factory_readHaltTrigger || factory_writeHaltTrigger));
  assign factory_rsp_ready = (_zz_factory_rsp_ready_1 && _zz_factory_rsp_ready);
  always @(*) begin
    _zz_factory_rsp_ready_1 = io_ctrl_rsp_ready;
    if(when_Stream_l375) begin
      _zz_factory_rsp_ready_1 = 1'b1;
    end
  end

  assign when_Stream_l375 = (! _zz_io_ctrl_rsp_valid);
  assign _zz_io_ctrl_rsp_valid = _zz_io_ctrl_rsp_valid_1;
  assign io_ctrl_rsp_valid = _zz_io_ctrl_rsp_valid;
  assign io_ctrl_rsp_payload_last = _zz_io_ctrl_rsp_payload_last;
  assign io_ctrl_rsp_payload_fragment_opcode = _zz_io_ctrl_rsp_payload_fragment_opcode;
  assign io_ctrl_rsp_payload_fragment_data = _zz_io_ctrl_rsp_payload_fragment_data;
  assign io_ctrl_rsp_payload_fragment_context = _zz_io_ctrl_rsp_payload_fragment_context;
  assign factory_askWrite = (io_ctrl_cmd_valid && (io_ctrl_cmd_payload_fragment_opcode == 1'b1));
  assign factory_askRead = (io_ctrl_cmd_valid && (io_ctrl_cmd_payload_fragment_opcode == 1'b0));
  assign io_ctrl_cmd_fire = (io_ctrl_cmd_valid && io_ctrl_cmd_ready);
  assign factory_doWrite = (io_ctrl_cmd_fire && (io_ctrl_cmd_payload_fragment_opcode == 1'b1));
  assign factory_doRead = (io_ctrl_cmd_fire && (io_ctrl_cmd_payload_fragment_opcode == 1'b0));
  assign factory_rsp_valid = io_ctrl_cmd_valid;
  assign io_ctrl_cmd_ready = factory_rsp_ready;
  assign factory_rsp_payload_last = 1'b1;
  assign when_BmbSlaveFactory_l33 = (factory_doWrite && factory_writeErrorFlag);
  always @(*) begin
    if(when_BmbSlaveFactory_l33) begin
      factory_rsp_payload_fragment_opcode = 1'b1;
    end else begin
      if(when_BmbSlaveFactory_l35) begin
        factory_rsp_payload_fragment_opcode = 1'b1;
      end else begin
        factory_rsp_payload_fragment_opcode = 1'b0;
      end
    end
  end

  assign when_BmbSlaveFactory_l35 = (factory_doRead && factory_readErrorFlag);
  always @(*) begin
    factory_rsp_payload_fragment_data = 32'h0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h0 : begin
        factory_rsp_payload_fragment_data[31 : 31] = (! ctrl_io_rsp_queueWithOccupancy_io_pop_valid);
        factory_rsp_payload_fragment_data[7 : 0] = ctrl_io_rsp_queueWithOccupancy_io_pop_payload_data;
      end
      12'h004 : begin
        factory_rsp_payload_fragment_data[8 : 0] = mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_availability;
        factory_rsp_payload_fragment_data[24 : 16] = ctrl_io_rsp_queueWithOccupancy_io_occupancy;
      end
      12'h00c : begin
        factory_rsp_payload_fragment_data[16 : 16] = mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_valid;
        factory_rsp_payload_fragment_data[0 : 0] = mapping_interruptCtrl_cmdIntEnable;
        factory_rsp_payload_fragment_data[1 : 1] = mapping_interruptCtrl_rspIntEnable;
        factory_rsp_payload_fragment_data[8 : 8] = mapping_interruptCtrl_cmdInt;
        factory_rsp_payload_fragment_data[9 : 9] = mapping_interruptCtrl_rspInt;
      end
      12'h058 : begin
        factory_rsp_payload_fragment_data[7 : 0] = ctrl_io_rsp_queueWithOccupancy_io_pop_payload_data;
      end
      default : begin
      end
    endcase
  end

  assign factory_rsp_payload_fragment_context = io_ctrl_cmd_payload_fragment_context;
  always @(*) begin
    mapping_cmdLogic_doRegular = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h0 : begin
        if(factory_doWrite) begin
          mapping_cmdLogic_doRegular = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    mapping_cmdLogic_doWriteLarge = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h050 : begin
        if(factory_doWrite) begin
          mapping_cmdLogic_doWriteLarge = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    mapping_cmdLogic_doReadWriteLarge = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h054 : begin
        if(factory_doWrite) begin
          mapping_cmdLogic_doReadWriteLarge = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign mapping_cmdLogic_streamUnbuffered_valid = ((mapping_cmdLogic_doRegular || mapping_cmdLogic_doWriteLarge) || mapping_cmdLogic_doReadWriteLarge);
  assign mapping_cmdLogic_streamUnbuffered_payload_write = (((mapping_cmdLogic_doRegular && mapping_cmdLogic_writeData[8]) || mapping_cmdLogic_doWriteLarge) || mapping_cmdLogic_doReadWriteLarge);
  assign mapping_cmdLogic_streamUnbuffered_payload_read = ((mapping_cmdLogic_doRegular && mapping_cmdLogic_writeData[9]) || mapping_cmdLogic_doReadWriteLarge);
  assign mapping_cmdLogic_streamUnbuffered_payload_kind = (mapping_cmdLogic_doRegular && mapping_cmdLogic_writeData[11]);
  assign mapping_cmdLogic_streamUnbuffered_payload_data = mapping_cmdLogic_writeData[7:0];
  assign mapping_cmdLogic_streamUnbuffered_ready = mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_push_ready;
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_valid = (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_valid || (! mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN));
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_kind = (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN ? mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_kind : mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_kind);
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_read = (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN ? mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_read : mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_read);
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_write = (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN ? mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_write : mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_write);
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_data = (mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN ? mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_data : mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_data);
  always @(*) begin
    mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_ready = mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_ready;
    if(when_Stream_l375_1) begin
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_ready = 1'b1;
    end
  end

  assign when_Stream_l375_1 = (! mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_valid);
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_valid = mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rValid;
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_kind = mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_kind;
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_read = mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_read;
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_write = mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_write;
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_payload_data = mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_data;
  assign mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_m2sPipe_ready = ctrl_io_cmd_ready;
  assign ctrl_io_rsp_toStream_valid = ctrl_io_rsp_valid;
  assign ctrl_io_rsp_toStream_payload_data = ctrl_io_rsp_payload_data;
  assign ctrl_io_rsp_toStream_ready = ctrl_io_rsp_queueWithOccupancy_io_push_ready;
  always @(*) begin
    _zz_io_pop_ready = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h0 : begin
        if(factory_doRead) begin
          _zz_io_pop_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    _zz_io_pop_ready_1 = 1'b0;
    case(io_ctrl_cmd_payload_fragment_address)
      12'h058 : begin
        if(factory_doRead) begin
          _zz_io_pop_ready_1 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign ctrl_io_rsp_queueWithOccupancy_io_pop_ready = (_zz_io_pop_ready || _zz_io_pop_ready_1);
  assign mapping_interruptCtrl_cmdInt = (mapping_interruptCtrl_cmdIntEnable && (! mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_valid));
  assign mapping_interruptCtrl_rspInt = (mapping_interruptCtrl_rspIntEnable && ctrl_io_rsp_queueWithOccupancy_io_pop_valid);
  assign mapping_interruptCtrl_interrupt = (mapping_interruptCtrl_rspInt || mapping_interruptCtrl_cmdInt);
  assign io_spi_sclk_write = ctrl_io_spi_sclk_write;
  assign io_spi_data_0_writeEnable = ctrl_io_spi_data_0_writeEnable;
  assign io_spi_data_0_write = ctrl_io_spi_data_0_write;
  assign io_spi_data_1_writeEnable = ctrl_io_spi_data_1_writeEnable;
  assign io_spi_data_1_write = ctrl_io_spi_data_1_write;
  assign io_spi_data_2_writeEnable = ctrl_io_spi_data_2_writeEnable;
  assign io_spi_data_2_write = ctrl_io_spi_data_2_write;
  assign io_spi_data_3_writeEnable = ctrl_io_spi_data_3_writeEnable;
  assign io_spi_data_3_write = ctrl_io_spi_data_3_write;
  assign io_spi_ss = ctrl_io_spi_ss;
  assign system_spi_0_io_interrupt_source = mapping_interruptCtrl_interrupt;
  assign mapping_cmdLogic_writeData = io_ctrl_cmd_payload_fragment_data[31 : 0];
  assign _zz_io_config_kind_cpol_1 = io_ctrl_cmd_payload_fragment_data[1 : 0];
  always @(posedge clk) begin
    if(reset) begin
      _zz_io_ctrl_rsp_valid_1 <= 1'b0;
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN <= 1'b1;
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rValid <= 1'b0;
      mapping_interruptCtrl_cmdIntEnable <= 1'b0;
      mapping_interruptCtrl_rspIntEnable <= 1'b0;
      _zz_io_config_ss_activeHigh <= 4'b0000;
    end else begin
      if(_zz_factory_rsp_ready_1) begin
        _zz_io_ctrl_rsp_valid_1 <= (factory_rsp_valid && _zz_factory_rsp_ready);
      end
      if(mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_valid) begin
        mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN <= 1'b0;
      end
      if(mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_ready) begin
        mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN <= 1'b1;
      end
      if(mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_ready) begin
        mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rValid <= mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_valid;
      end
      case(io_ctrl_cmd_payload_fragment_address)
        12'h00c : begin
          if(factory_doWrite) begin
            mapping_interruptCtrl_cmdIntEnable <= io_ctrl_cmd_payload_fragment_data[0];
            mapping_interruptCtrl_rspIntEnable <= io_ctrl_cmd_payload_fragment_data[1];
          end
        end
        12'h030 : begin
          if(factory_doWrite) begin
            _zz_io_config_ss_activeHigh <= io_ctrl_cmd_payload_fragment_data[3 : 0];
          end
        end
        default : begin
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if(_zz_factory_rsp_ready_1) begin
      _zz_io_ctrl_rsp_payload_last <= factory_rsp_payload_last;
      _zz_io_ctrl_rsp_payload_fragment_opcode <= factory_rsp_payload_fragment_opcode;
      _zz_io_ctrl_rsp_payload_fragment_data <= factory_rsp_payload_fragment_data;
      _zz_io_ctrl_rsp_payload_fragment_context <= factory_rsp_payload_fragment_context;
    end
    if(mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rValidN) begin
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_kind <= mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_kind;
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_read <= mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_read;
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_write <= mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_write;
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_rData_data <= mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_payload_data;
    end
    if(mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_ready) begin
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_kind <= mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_kind;
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_read <= mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_read;
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_write <= mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_write;
      mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_rData_data <= mapping_cmdLogic_streamUnbuffered_queueWithAvailability_io_pop_s2mPipe_payload_data;
    end
    case(io_ctrl_cmd_payload_fragment_address)
      12'h008 : begin
        if(factory_doWrite) begin
          _zz_io_config_kind_cpol <= _zz_io_config_kind_cpol_1[0];
          _zz_io_config_kind_cpha <= _zz_io_config_kind_cpol_1[1];
          _zz_io_config_mod <= io_ctrl_cmd_payload_fragment_data[5 : 4];
        end
      end
      12'h020 : begin
        if(factory_doWrite) begin
          _zz_io_config_sclkToggle <= io_ctrl_cmd_payload_fragment_data[11 : 0];
        end
      end
      12'h024 : begin
        if(factory_doWrite) begin
          _zz_io_config_ss_setup <= io_ctrl_cmd_payload_fragment_data[11 : 0];
        end
      end
      12'h028 : begin
        if(factory_doWrite) begin
          _zz_io_config_ss_hold <= io_ctrl_cmd_payload_fragment_data[11 : 0];
        end
      end
      12'h02c : begin
        if(factory_doWrite) begin
          _zz_io_config_ss_disable <= io_ctrl_cmd_payload_fragment_data[11 : 0];
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module Axi4PeripheralBmbUartCtrl (
  input  wire          io_bus_cmd_valid,
  output wire          io_bus_cmd_ready,
  input  wire          io_bus_cmd_payload_last,
  input  wire [0:0]    io_bus_cmd_payload_fragment_opcode,
  input  wire [5:0]    io_bus_cmd_payload_fragment_address,
  input  wire [1:0]    io_bus_cmd_payload_fragment_length,
  input  wire [31:0]   io_bus_cmd_payload_fragment_data,
  input  wire [2:0]    io_bus_cmd_payload_fragment_context,
  output wire          io_bus_rsp_valid,
  input  wire          io_bus_rsp_ready,
  output wire          io_bus_rsp_payload_last,
  output wire [0:0]    io_bus_rsp_payload_fragment_opcode,
  output wire [31:0]   io_bus_rsp_payload_fragment_data,
  output wire [2:0]    io_bus_rsp_payload_fragment_context,
  output wire          io_uart_txd,
  input  wire          io_uart_rxd,
  output wire          system_uart_0_io_interrupt_source,
  input  wire          clk,
  input  wire          reset
);
  localparam Axi4PeripheralUartStopType_ONE = 1'd0;
  localparam Axi4PeripheralUartStopType_TWO = 1'd1;
  localparam Axi4PeripheralUartParityType_NONE = 2'd0;
  localparam Axi4PeripheralUartParityType_EVEN = 2'd1;
  localparam Axi4PeripheralUartParityType_ODD = 2'd2;

  reg                 uartCtrl_io_read_queueWithOccupancy_io_pop_ready;
  wire                uartCtrl_io_write_ready;
  wire                uartCtrl_io_read_valid;
  wire       [7:0]    uartCtrl_io_read_payload;
  wire                uartCtrl_io_uart_txd;
  wire                uartCtrl_io_readError;
  wire                uartCtrl_io_readBreak;
  wire                bridge_write_streamUnbuffered_queueWithOccupancy_io_push_ready;
  wire                bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid;
  wire       [7:0]    bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_payload;
  wire       [7:0]    bridge_write_streamUnbuffered_queueWithOccupancy_io_occupancy;
  wire       [7:0]    bridge_write_streamUnbuffered_queueWithOccupancy_io_availability;
  wire                uartCtrl_io_read_queueWithOccupancy_io_push_ready;
  wire                uartCtrl_io_read_queueWithOccupancy_io_pop_valid;
  wire       [7:0]    uartCtrl_io_read_queueWithOccupancy_io_pop_payload;
  wire       [7:0]    uartCtrl_io_read_queueWithOccupancy_io_occupancy;
  wire       [7:0]    uartCtrl_io_read_queueWithOccupancy_io_availability;
  wire       [0:0]    _zz_bridge_misc_readError;
  wire       [0:0]    _zz_bridge_misc_readOverflowError;
  wire       [0:0]    _zz_bridge_misc_breakDetected;
  wire       [0:0]    _zz_bridge_misc_doBreak;
  wire       [0:0]    _zz_bridge_misc_doBreak_1;
  wire       [7:0]    _zz_busCtrl_rsp_payload_fragment_data;
  wire                busCtrl_readErrorFlag;
  wire                busCtrl_writeErrorFlag;
  wire                busCtrl_readHaltTrigger;
  wire                busCtrl_writeHaltTrigger;
  wire                busCtrl_rsp_valid;
  wire                busCtrl_rsp_ready;
  wire                busCtrl_rsp_payload_last;
  reg        [0:0]    busCtrl_rsp_payload_fragment_opcode;
  reg        [31:0]   busCtrl_rsp_payload_fragment_data;
  wire       [2:0]    busCtrl_rsp_payload_fragment_context;
  wire                _zz_busCtrl_rsp_ready;
  reg                 _zz_busCtrl_rsp_ready_1;
  wire                _zz_io_bus_rsp_valid;
  reg                 _zz_io_bus_rsp_valid_1;
  reg                 _zz_io_bus_rsp_payload_last;
  reg        [0:0]    _zz_io_bus_rsp_payload_fragment_opcode;
  reg        [31:0]   _zz_io_bus_rsp_payload_fragment_data;
  reg        [2:0]    _zz_io_bus_rsp_payload_fragment_context;
  wire                when_Stream_l375;
  wire                busCtrl_askWrite;
  wire                busCtrl_askRead;
  wire                io_bus_cmd_fire;
  wire                busCtrl_doWrite;
  wire                busCtrl_doRead;
  wire                when_BmbSlaveFactory_l33;
  wire                when_BmbSlaveFactory_l35;
  wire                bridge_busCtrlWrapped_readErrorFlag;
  wire                bridge_busCtrlWrapped_writeErrorFlag;
  reg        [2:0]    bridge_uartConfigReg_frame_dataLength;
  reg        [0:0]    bridge_uartConfigReg_frame_stop;
  reg        [1:0]    bridge_uartConfigReg_frame_parity;
  reg        [19:0]   bridge_uartConfigReg_clockDivider;
  reg                 _zz_bridge_write_streamUnbuffered_valid;
  wire                bridge_write_streamUnbuffered_valid;
  wire                bridge_write_streamUnbuffered_ready;
  wire       [7:0]    bridge_write_streamUnbuffered_payload;
  reg                 bridge_read_streamBreaked_valid;
  reg                 bridge_read_streamBreaked_ready;
  wire       [7:0]    bridge_read_streamBreaked_payload;
  reg                 bridge_interruptCtrl_writeIntEnable;
  reg                 bridge_interruptCtrl_readIntEnable;
  wire                bridge_interruptCtrl_readInt;
  wire                bridge_interruptCtrl_writeInt;
  wire                bridge_interruptCtrl_interrupt;
  reg                 bridge_misc_readError;
  reg                 when_BusSlaveFactory_l341;
  wire                when_BusSlaveFactory_l347;
  reg                 bridge_misc_readOverflowError;
  reg                 when_BusSlaveFactory_l341_1;
  wire                when_BusSlaveFactory_l347_1;
  wire                uartCtrl_io_read_isStall;
  reg                 bridge_misc_breakDetected;
  reg                 uartCtrl_io_readBreak_regNext;
  wire                when_UartCtrl_l155;
  reg                 when_BusSlaveFactory_l341_2;
  wire                when_BusSlaveFactory_l347_2;
  reg                 bridge_misc_doBreak;
  reg                 when_BusSlaveFactory_l377;
  wire                when_BusSlaveFactory_l379;
  reg                 when_BusSlaveFactory_l341_3;
  wire                when_BusSlaveFactory_l347_3;
  wire       [1:0]    _zz_bridge_uartConfigReg_frame_parity;
  wire       [0:0]    _zz_bridge_uartConfigReg_frame_stop;
  wire                when_BmbSlaveFactory_l77;
  `ifndef SYNTHESIS
  reg [23:0] bridge_uartConfigReg_frame_stop_string;
  reg [31:0] bridge_uartConfigReg_frame_parity_string;
  reg [31:0] _zz_bridge_uartConfigReg_frame_parity_string;
  reg [23:0] _zz_bridge_uartConfigReg_frame_stop_string;
  `endif


  assign _zz_bridge_misc_readError = 1'b0;
  assign _zz_bridge_misc_readOverflowError = 1'b0;
  assign _zz_bridge_misc_breakDetected = 1'b0;
  assign _zz_bridge_misc_doBreak = 1'b1;
  assign _zz_bridge_misc_doBreak_1 = 1'b0;
  assign _zz_busCtrl_rsp_payload_fragment_data = (8'h80 - bridge_write_streamUnbuffered_queueWithOccupancy_io_occupancy);
  Axi4PeripheralUartCtrl uartCtrl (
    .io_config_frame_dataLength (bridge_uartConfigReg_frame_dataLength[2:0]                          ), //i
    .io_config_frame_stop       (bridge_uartConfigReg_frame_stop                                     ), //i
    .io_config_frame_parity     (bridge_uartConfigReg_frame_parity[1:0]                              ), //i
    .io_config_clockDivider     (bridge_uartConfigReg_clockDivider[19:0]                             ), //i
    .io_write_valid             (bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid       ), //i
    .io_write_ready             (uartCtrl_io_write_ready                                             ), //o
    .io_write_payload           (bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_payload[7:0]), //i
    .io_read_valid              (uartCtrl_io_read_valid                                              ), //o
    .io_read_ready              (uartCtrl_io_read_queueWithOccupancy_io_push_ready                   ), //i
    .io_read_payload            (uartCtrl_io_read_payload[7:0]                                       ), //o
    .io_uart_txd                (uartCtrl_io_uart_txd                                                ), //o
    .io_uart_rxd                (io_uart_rxd                                                         ), //i
    .io_readError               (uartCtrl_io_readError                                               ), //o
    .io_writeBreak              (bridge_misc_doBreak                                                 ), //i
    .io_readBreak               (uartCtrl_io_readBreak                                               ), //o
    .clk                        (clk                                                                 ), //i
    .reset                      (reset                                                               )  //i
  );
  Axi4PeripheralStreamFifo bridge_write_streamUnbuffered_queueWithOccupancy (
    .io_push_valid   (bridge_write_streamUnbuffered_valid                                  ), //i
    .io_push_ready   (bridge_write_streamUnbuffered_queueWithOccupancy_io_push_ready       ), //o
    .io_push_payload (bridge_write_streamUnbuffered_payload[7:0]                           ), //i
    .io_pop_valid    (bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid        ), //o
    .io_pop_ready    (uartCtrl_io_write_ready                                              ), //i
    .io_pop_payload  (bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_payload[7:0] ), //o
    .io_flush        (1'b0                                                                 ), //i
    .io_occupancy    (bridge_write_streamUnbuffered_queueWithOccupancy_io_occupancy[7:0]   ), //o
    .io_availability (bridge_write_streamUnbuffered_queueWithOccupancy_io_availability[7:0]), //o
    .clk             (clk                                                                  ), //i
    .reset           (reset                                                                )  //i
  );
  Axi4PeripheralStreamFifo uartCtrl_io_read_queueWithOccupancy (
    .io_push_valid   (uartCtrl_io_read_valid                                  ), //i
    .io_push_ready   (uartCtrl_io_read_queueWithOccupancy_io_push_ready       ), //o
    .io_push_payload (uartCtrl_io_read_payload[7:0]                           ), //i
    .io_pop_valid    (uartCtrl_io_read_queueWithOccupancy_io_pop_valid        ), //o
    .io_pop_ready    (uartCtrl_io_read_queueWithOccupancy_io_pop_ready        ), //i
    .io_pop_payload  (uartCtrl_io_read_queueWithOccupancy_io_pop_payload[7:0] ), //o
    .io_flush        (1'b0                                                    ), //i
    .io_occupancy    (uartCtrl_io_read_queueWithOccupancy_io_occupancy[7:0]   ), //o
    .io_availability (uartCtrl_io_read_queueWithOccupancy_io_availability[7:0]), //o
    .clk             (clk                                                     ), //i
    .reset           (reset                                                   )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(bridge_uartConfigReg_frame_stop)
      Axi4PeripheralUartStopType_ONE : bridge_uartConfigReg_frame_stop_string = "ONE";
      Axi4PeripheralUartStopType_TWO : bridge_uartConfigReg_frame_stop_string = "TWO";
      default : bridge_uartConfigReg_frame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(bridge_uartConfigReg_frame_parity)
      Axi4PeripheralUartParityType_NONE : bridge_uartConfigReg_frame_parity_string = "NONE";
      Axi4PeripheralUartParityType_EVEN : bridge_uartConfigReg_frame_parity_string = "EVEN";
      Axi4PeripheralUartParityType_ODD : bridge_uartConfigReg_frame_parity_string = "ODD ";
      default : bridge_uartConfigReg_frame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_bridge_uartConfigReg_frame_parity)
      Axi4PeripheralUartParityType_NONE : _zz_bridge_uartConfigReg_frame_parity_string = "NONE";
      Axi4PeripheralUartParityType_EVEN : _zz_bridge_uartConfigReg_frame_parity_string = "EVEN";
      Axi4PeripheralUartParityType_ODD : _zz_bridge_uartConfigReg_frame_parity_string = "ODD ";
      default : _zz_bridge_uartConfigReg_frame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(_zz_bridge_uartConfigReg_frame_stop)
      Axi4PeripheralUartStopType_ONE : _zz_bridge_uartConfigReg_frame_stop_string = "ONE";
      Axi4PeripheralUartStopType_TWO : _zz_bridge_uartConfigReg_frame_stop_string = "TWO";
      default : _zz_bridge_uartConfigReg_frame_stop_string = "???";
    endcase
  end
  `endif

  assign io_uart_txd = uartCtrl_io_uart_txd;
  assign busCtrl_readErrorFlag = 1'b0;
  assign busCtrl_writeErrorFlag = 1'b0;
  assign busCtrl_readHaltTrigger = 1'b0;
  assign busCtrl_writeHaltTrigger = 1'b0;
  assign _zz_busCtrl_rsp_ready = (! (busCtrl_readHaltTrigger || busCtrl_writeHaltTrigger));
  assign busCtrl_rsp_ready = (_zz_busCtrl_rsp_ready_1 && _zz_busCtrl_rsp_ready);
  always @(*) begin
    _zz_busCtrl_rsp_ready_1 = io_bus_rsp_ready;
    if(when_Stream_l375) begin
      _zz_busCtrl_rsp_ready_1 = 1'b1;
    end
  end

  assign when_Stream_l375 = (! _zz_io_bus_rsp_valid);
  assign _zz_io_bus_rsp_valid = _zz_io_bus_rsp_valid_1;
  assign io_bus_rsp_valid = _zz_io_bus_rsp_valid;
  assign io_bus_rsp_payload_last = _zz_io_bus_rsp_payload_last;
  assign io_bus_rsp_payload_fragment_opcode = _zz_io_bus_rsp_payload_fragment_opcode;
  assign io_bus_rsp_payload_fragment_data = _zz_io_bus_rsp_payload_fragment_data;
  assign io_bus_rsp_payload_fragment_context = _zz_io_bus_rsp_payload_fragment_context;
  assign busCtrl_askWrite = (io_bus_cmd_valid && (io_bus_cmd_payload_fragment_opcode == 1'b1));
  assign busCtrl_askRead = (io_bus_cmd_valid && (io_bus_cmd_payload_fragment_opcode == 1'b0));
  assign io_bus_cmd_fire = (io_bus_cmd_valid && io_bus_cmd_ready);
  assign busCtrl_doWrite = (io_bus_cmd_fire && (io_bus_cmd_payload_fragment_opcode == 1'b1));
  assign busCtrl_doRead = (io_bus_cmd_fire && (io_bus_cmd_payload_fragment_opcode == 1'b0));
  assign busCtrl_rsp_valid = io_bus_cmd_valid;
  assign io_bus_cmd_ready = busCtrl_rsp_ready;
  assign busCtrl_rsp_payload_last = 1'b1;
  assign when_BmbSlaveFactory_l33 = (busCtrl_doWrite && busCtrl_writeErrorFlag);
  always @(*) begin
    if(when_BmbSlaveFactory_l33) begin
      busCtrl_rsp_payload_fragment_opcode = 1'b1;
    end else begin
      if(when_BmbSlaveFactory_l35) begin
        busCtrl_rsp_payload_fragment_opcode = 1'b1;
      end else begin
        busCtrl_rsp_payload_fragment_opcode = 1'b0;
      end
    end
  end

  assign when_BmbSlaveFactory_l35 = (busCtrl_doRead && busCtrl_readErrorFlag);
  always @(*) begin
    busCtrl_rsp_payload_fragment_data = 32'h0;
    case(io_bus_cmd_payload_fragment_address)
      6'h0 : begin
        busCtrl_rsp_payload_fragment_data[16 : 16] = (bridge_read_streamBreaked_valid ^ 1'b0);
        busCtrl_rsp_payload_fragment_data[7 : 0] = bridge_read_streamBreaked_payload;
      end
      6'h04 : begin
        busCtrl_rsp_payload_fragment_data[23 : 16] = _zz_busCtrl_rsp_payload_fragment_data;
        busCtrl_rsp_payload_fragment_data[15 : 15] = bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid;
        busCtrl_rsp_payload_fragment_data[31 : 24] = uartCtrl_io_read_queueWithOccupancy_io_occupancy;
        busCtrl_rsp_payload_fragment_data[0 : 0] = bridge_interruptCtrl_writeIntEnable;
        busCtrl_rsp_payload_fragment_data[1 : 1] = bridge_interruptCtrl_readIntEnable;
        busCtrl_rsp_payload_fragment_data[8 : 8] = bridge_interruptCtrl_writeInt;
        busCtrl_rsp_payload_fragment_data[9 : 9] = bridge_interruptCtrl_readInt;
      end
      6'h10 : begin
        busCtrl_rsp_payload_fragment_data[0 : 0] = bridge_misc_readError;
        busCtrl_rsp_payload_fragment_data[1 : 1] = bridge_misc_readOverflowError;
        busCtrl_rsp_payload_fragment_data[8 : 8] = uartCtrl_io_readBreak;
        busCtrl_rsp_payload_fragment_data[9 : 9] = bridge_misc_breakDetected;
      end
      default : begin
      end
    endcase
  end

  assign busCtrl_rsp_payload_fragment_context = io_bus_cmd_payload_fragment_context;
  assign bridge_busCtrlWrapped_readErrorFlag = 1'b0;
  assign bridge_busCtrlWrapped_writeErrorFlag = 1'b0;
  always @(*) begin
    _zz_bridge_write_streamUnbuffered_valid = 1'b0;
    case(io_bus_cmd_payload_fragment_address)
      6'h0 : begin
        if(busCtrl_doWrite) begin
          _zz_bridge_write_streamUnbuffered_valid = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign bridge_write_streamUnbuffered_valid = _zz_bridge_write_streamUnbuffered_valid;
  assign bridge_write_streamUnbuffered_payload = io_bus_cmd_payload_fragment_data[7 : 0];
  assign bridge_write_streamUnbuffered_ready = bridge_write_streamUnbuffered_queueWithOccupancy_io_push_ready;
  always @(*) begin
    bridge_read_streamBreaked_valid = uartCtrl_io_read_queueWithOccupancy_io_pop_valid;
    if(uartCtrl_io_readBreak) begin
      bridge_read_streamBreaked_valid = 1'b0;
    end
  end

  always @(*) begin
    uartCtrl_io_read_queueWithOccupancy_io_pop_ready = bridge_read_streamBreaked_ready;
    if(uartCtrl_io_readBreak) begin
      uartCtrl_io_read_queueWithOccupancy_io_pop_ready = 1'b1;
    end
  end

  assign bridge_read_streamBreaked_payload = uartCtrl_io_read_queueWithOccupancy_io_pop_payload;
  always @(*) begin
    bridge_read_streamBreaked_ready = 1'b0;
    case(io_bus_cmd_payload_fragment_address)
      6'h0 : begin
        if(busCtrl_doRead) begin
          bridge_read_streamBreaked_ready = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign bridge_interruptCtrl_readInt = (bridge_interruptCtrl_readIntEnable && bridge_read_streamBreaked_valid);
  assign bridge_interruptCtrl_writeInt = (bridge_interruptCtrl_writeIntEnable && (! bridge_write_streamUnbuffered_queueWithOccupancy_io_pop_valid));
  assign bridge_interruptCtrl_interrupt = (bridge_interruptCtrl_readInt || bridge_interruptCtrl_writeInt);
  always @(*) begin
    when_BusSlaveFactory_l341 = 1'b0;
    case(io_bus_cmd_payload_fragment_address)
      6'h10 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347 = io_bus_cmd_payload_fragment_data[0];
  always @(*) begin
    when_BusSlaveFactory_l341_1 = 1'b0;
    case(io_bus_cmd_payload_fragment_address)
      6'h10 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_1 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_1 = io_bus_cmd_payload_fragment_data[1];
  assign uartCtrl_io_read_isStall = (uartCtrl_io_read_valid && (! uartCtrl_io_read_queueWithOccupancy_io_push_ready));
  assign when_UartCtrl_l155 = (uartCtrl_io_readBreak && (! uartCtrl_io_readBreak_regNext));
  always @(*) begin
    when_BusSlaveFactory_l341_2 = 1'b0;
    case(io_bus_cmd_payload_fragment_address)
      6'h10 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_2 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_2 = io_bus_cmd_payload_fragment_data[9];
  always @(*) begin
    when_BusSlaveFactory_l377 = 1'b0;
    case(io_bus_cmd_payload_fragment_address)
      6'h10 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l377 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l379 = io_bus_cmd_payload_fragment_data[10];
  always @(*) begin
    when_BusSlaveFactory_l341_3 = 1'b0;
    case(io_bus_cmd_payload_fragment_address)
      6'h10 : begin
        if(busCtrl_doWrite) begin
          when_BusSlaveFactory_l341_3 = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  assign when_BusSlaveFactory_l347_3 = io_bus_cmd_payload_fragment_data[11];
  assign system_uart_0_io_interrupt_source = bridge_interruptCtrl_interrupt;
  assign _zz_bridge_uartConfigReg_frame_parity = io_bus_cmd_payload_fragment_data[9 : 8];
  assign _zz_bridge_uartConfigReg_frame_stop = io_bus_cmd_payload_fragment_data[16 : 16];
  assign when_BmbSlaveFactory_l77 = ((io_bus_cmd_payload_fragment_address & (~ 6'h03)) == 6'h08);
  always @(posedge clk) begin
    if(reset) begin
      _zz_io_bus_rsp_valid_1 <= 1'b0;
      bridge_uartConfigReg_clockDivider <= 20'h0;
      bridge_uartConfigReg_clockDivider <= 20'h0009f;
      bridge_uartConfigReg_frame_dataLength <= 3'b111;
      bridge_uartConfigReg_frame_parity <= Axi4PeripheralUartParityType_NONE;
      bridge_uartConfigReg_frame_stop <= Axi4PeripheralUartStopType_ONE;
      bridge_interruptCtrl_writeIntEnable <= 1'b0;
      bridge_interruptCtrl_readIntEnable <= 1'b0;
      bridge_misc_readError <= 1'b0;
      bridge_misc_readOverflowError <= 1'b0;
      bridge_misc_breakDetected <= 1'b0;
      bridge_misc_doBreak <= 1'b0;
    end else begin
      if(_zz_busCtrl_rsp_ready_1) begin
        _zz_io_bus_rsp_valid_1 <= (busCtrl_rsp_valid && _zz_busCtrl_rsp_ready);
      end
      if(when_BusSlaveFactory_l341) begin
        if(when_BusSlaveFactory_l347) begin
          bridge_misc_readError <= _zz_bridge_misc_readError[0];
        end
      end
      if(uartCtrl_io_readError) begin
        bridge_misc_readError <= 1'b1;
      end
      if(when_BusSlaveFactory_l341_1) begin
        if(when_BusSlaveFactory_l347_1) begin
          bridge_misc_readOverflowError <= _zz_bridge_misc_readOverflowError[0];
        end
      end
      if(uartCtrl_io_read_isStall) begin
        bridge_misc_readOverflowError <= 1'b1;
      end
      if(when_UartCtrl_l155) begin
        bridge_misc_breakDetected <= 1'b1;
      end
      if(when_BusSlaveFactory_l341_2) begin
        if(when_BusSlaveFactory_l347_2) begin
          bridge_misc_breakDetected <= _zz_bridge_misc_breakDetected[0];
        end
      end
      if(when_BusSlaveFactory_l377) begin
        if(when_BusSlaveFactory_l379) begin
          bridge_misc_doBreak <= _zz_bridge_misc_doBreak[0];
        end
      end
      if(when_BusSlaveFactory_l341_3) begin
        if(when_BusSlaveFactory_l347_3) begin
          bridge_misc_doBreak <= _zz_bridge_misc_doBreak_1[0];
        end
      end
      case(io_bus_cmd_payload_fragment_address)
        6'h0c : begin
          if(busCtrl_doWrite) begin
            bridge_uartConfigReg_frame_dataLength <= io_bus_cmd_payload_fragment_data[2 : 0];
            bridge_uartConfigReg_frame_parity <= _zz_bridge_uartConfigReg_frame_parity;
            bridge_uartConfigReg_frame_stop <= _zz_bridge_uartConfigReg_frame_stop;
          end
        end
        6'h04 : begin
          if(busCtrl_doWrite) begin
            bridge_interruptCtrl_writeIntEnable <= io_bus_cmd_payload_fragment_data[0];
            bridge_interruptCtrl_readIntEnable <= io_bus_cmd_payload_fragment_data[1];
          end
        end
        default : begin
        end
      endcase
      if(when_BmbSlaveFactory_l77) begin
        if(busCtrl_doWrite) begin
          bridge_uartConfigReg_clockDivider[19 : 0] <= io_bus_cmd_payload_fragment_data[19 : 0];
        end
      end
    end
  end

  always @(posedge clk) begin
    if(_zz_busCtrl_rsp_ready_1) begin
      _zz_io_bus_rsp_payload_last <= busCtrl_rsp_payload_last;
      _zz_io_bus_rsp_payload_fragment_opcode <= busCtrl_rsp_payload_fragment_opcode;
      _zz_io_bus_rsp_payload_fragment_data <= busCtrl_rsp_payload_fragment_data;
      _zz_io_bus_rsp_payload_fragment_context <= busCtrl_rsp_payload_fragment_context;
    end
    uartCtrl_io_readBreak_regNext <= uartCtrl_io_readBreak;
  end


endmodule

module Axi4PeripheralBmbDecoder_1 (
  input  wire          io_input_cmd_valid,
  output wire          io_input_cmd_ready,
  input  wire          io_input_cmd_payload_last,
  input  wire [0:0]    io_input_cmd_payload_fragment_opcode,
  input  wire [23:0]   io_input_cmd_payload_fragment_address,
  input  wire [1:0]    io_input_cmd_payload_fragment_length,
  input  wire [31:0]   io_input_cmd_payload_fragment_data,
  input  wire [3:0]    io_input_cmd_payload_fragment_mask,
  input  wire [2:0]    io_input_cmd_payload_fragment_context,
  output reg           io_input_rsp_valid,
  input  wire          io_input_rsp_ready,
  output reg           io_input_rsp_payload_last,
  output reg  [0:0]    io_input_rsp_payload_fragment_opcode,
  output wire [31:0]   io_input_rsp_payload_fragment_data,
  output reg  [2:0]    io_input_rsp_payload_fragment_context,
  output reg           io_outputs_0_cmd_valid,
  input  wire          io_outputs_0_cmd_ready,
  output wire          io_outputs_0_cmd_payload_last,
  output wire [0:0]    io_outputs_0_cmd_payload_fragment_opcode,
  output wire [23:0]   io_outputs_0_cmd_payload_fragment_address,
  output wire [1:0]    io_outputs_0_cmd_payload_fragment_length,
  output wire [31:0]   io_outputs_0_cmd_payload_fragment_data,
  output wire [3:0]    io_outputs_0_cmd_payload_fragment_mask,
  output wire [2:0]    io_outputs_0_cmd_payload_fragment_context,
  input  wire          io_outputs_0_rsp_valid,
  output wire          io_outputs_0_rsp_ready,
  input  wire          io_outputs_0_rsp_payload_last,
  input  wire [0:0]    io_outputs_0_rsp_payload_fragment_opcode,
  input  wire [31:0]   io_outputs_0_rsp_payload_fragment_data,
  input  wire [2:0]    io_outputs_0_rsp_payload_fragment_context,
  output reg           io_outputs_1_cmd_valid,
  input  wire          io_outputs_1_cmd_ready,
  output wire          io_outputs_1_cmd_payload_last,
  output wire [0:0]    io_outputs_1_cmd_payload_fragment_opcode,
  output wire [23:0]   io_outputs_1_cmd_payload_fragment_address,
  output wire [1:0]    io_outputs_1_cmd_payload_fragment_length,
  output wire [31:0]   io_outputs_1_cmd_payload_fragment_data,
  output wire [3:0]    io_outputs_1_cmd_payload_fragment_mask,
  output wire [2:0]    io_outputs_1_cmd_payload_fragment_context,
  input  wire          io_outputs_1_rsp_valid,
  output wire          io_outputs_1_rsp_ready,
  input  wire          io_outputs_1_rsp_payload_last,
  input  wire [0:0]    io_outputs_1_rsp_payload_fragment_opcode,
  input  wire [31:0]   io_outputs_1_rsp_payload_fragment_data,
  input  wire [2:0]    io_outputs_1_rsp_payload_fragment_context,
  output reg           io_outputs_2_cmd_valid,
  input  wire          io_outputs_2_cmd_ready,
  output wire          io_outputs_2_cmd_payload_last,
  output wire [0:0]    io_outputs_2_cmd_payload_fragment_opcode,
  output wire [23:0]   io_outputs_2_cmd_payload_fragment_address,
  output wire [1:0]    io_outputs_2_cmd_payload_fragment_length,
  output wire [31:0]   io_outputs_2_cmd_payload_fragment_data,
  output wire [3:0]    io_outputs_2_cmd_payload_fragment_mask,
  output wire [2:0]    io_outputs_2_cmd_payload_fragment_context,
  input  wire          io_outputs_2_rsp_valid,
  output wire          io_outputs_2_rsp_ready,
  input  wire          io_outputs_2_rsp_payload_last,
  input  wire [0:0]    io_outputs_2_rsp_payload_fragment_opcode,
  input  wire [31:0]   io_outputs_2_rsp_payload_fragment_data,
  input  wire [2:0]    io_outputs_2_rsp_payload_fragment_context,
  output reg           io_outputs_3_cmd_valid,
  input  wire          io_outputs_3_cmd_ready,
  output wire          io_outputs_3_cmd_payload_last,
  output wire [0:0]    io_outputs_3_cmd_payload_fragment_opcode,
  output wire [23:0]   io_outputs_3_cmd_payload_fragment_address,
  output wire [1:0]    io_outputs_3_cmd_payload_fragment_length,
  output wire [31:0]   io_outputs_3_cmd_payload_fragment_data,
  output wire [3:0]    io_outputs_3_cmd_payload_fragment_mask,
  output wire [2:0]    io_outputs_3_cmd_payload_fragment_context,
  input  wire          io_outputs_3_rsp_valid,
  output wire          io_outputs_3_rsp_ready,
  input  wire          io_outputs_3_rsp_payload_last,
  input  wire [0:0]    io_outputs_3_rsp_payload_fragment_opcode,
  input  wire [31:0]   io_outputs_3_rsp_payload_fragment_data,
  input  wire [2:0]    io_outputs_3_rsp_payload_fragment_context,
  output reg           io_outputs_4_cmd_valid,
  input  wire          io_outputs_4_cmd_ready,
  output wire          io_outputs_4_cmd_payload_last,
  output wire [0:0]    io_outputs_4_cmd_payload_fragment_opcode,
  output wire [23:0]   io_outputs_4_cmd_payload_fragment_address,
  output wire [1:0]    io_outputs_4_cmd_payload_fragment_length,
  output wire [31:0]   io_outputs_4_cmd_payload_fragment_data,
  output wire [3:0]    io_outputs_4_cmd_payload_fragment_mask,
  output wire [2:0]    io_outputs_4_cmd_payload_fragment_context,
  input  wire          io_outputs_4_rsp_valid,
  output wire          io_outputs_4_rsp_ready,
  input  wire          io_outputs_4_rsp_payload_last,
  input  wire [0:0]    io_outputs_4_rsp_payload_fragment_opcode,
  input  wire [31:0]   io_outputs_4_rsp_payload_fragment_data,
  input  wire [2:0]    io_outputs_4_rsp_payload_fragment_context,
  input  wire          clk,
  input  wire          reset
);

  wire       [6:0]    _zz_logic_rspPendingCounter;
  wire       [6:0]    _zz_logic_rspPendingCounter_1;
  wire       [0:0]    _zz_logic_rspPendingCounter_2;
  wire       [6:0]    _zz_logic_rspPendingCounter_3;
  wire       [0:0]    _zz_logic_rspPendingCounter_4;
  reg                 _zz_io_input_rsp_payload_last_3;
  reg        [0:0]    _zz_io_input_rsp_payload_fragment_opcode;
  reg        [31:0]   _zz_io_input_rsp_payload_fragment_data;
  reg        [2:0]    _zz_io_input_rsp_payload_fragment_context;
  wire                logic_input_valid;
  reg                 logic_input_ready;
  wire                logic_input_payload_last;
  wire       [0:0]    logic_input_payload_fragment_opcode;
  wire       [23:0]   logic_input_payload_fragment_address;
  wire       [1:0]    logic_input_payload_fragment_length;
  wire       [31:0]   logic_input_payload_fragment_data;
  wire       [3:0]    logic_input_payload_fragment_mask;
  wire       [2:0]    logic_input_payload_fragment_context;
  wire                logic_hitsS0_0;
  wire                logic_hitsS0_1;
  wire                logic_hitsS0_2;
  wire                logic_hitsS0_3;
  wire                logic_hitsS0_4;
  wire                logic_noHitS0;
  wire                _zz_io_outputs_0_cmd_payload_last;
  wire                _zz_io_outputs_1_cmd_payload_last;
  wire                _zz_io_outputs_2_cmd_payload_last;
  wire                _zz_io_outputs_3_cmd_payload_last;
  wire                _zz_io_outputs_4_cmd_payload_last;
  reg        [6:0]    logic_rspPendingCounter;
  wire                logic_input_fire;
  wire                io_input_rsp_fire;
  wire                logic_cmdWait;
  wire                when_BmbDecoder_l56;
  reg                 logic_rspHits_0;
  reg                 logic_rspHits_1;
  reg                 logic_rspHits_2;
  reg                 logic_rspHits_3;
  reg                 logic_rspHits_4;
  wire                logic_rspPending;
  wire                logic_rspNoHitValid;
  reg                 logic_rspNoHit_doIt;
  wire                when_BmbDecoder_l60;
  wire                when_BmbDecoder_l60_1;
  reg                 logic_rspNoHit_singleBeatRsp;
  reg        [2:0]    logic_rspNoHit_context;
  wire                _zz_io_input_rsp_payload_last;
  wire                _zz_io_input_rsp_payload_last_1;
  wire       [2:0]    _zz_io_input_rsp_payload_last_2;

  assign _zz_logic_rspPendingCounter = (logic_rspPendingCounter + _zz_logic_rspPendingCounter_1);
  assign _zz_logic_rspPendingCounter_2 = (logic_input_fire && logic_input_payload_last);
  assign _zz_logic_rspPendingCounter_1 = {6'd0, _zz_logic_rspPendingCounter_2};
  assign _zz_logic_rspPendingCounter_4 = (io_input_rsp_fire && io_input_rsp_payload_last);
  assign _zz_logic_rspPendingCounter_3 = {6'd0, _zz_logic_rspPendingCounter_4};
  always @(*) begin
    case(_zz_io_input_rsp_payload_last_2)
      3'b000 : begin
        _zz_io_input_rsp_payload_last_3 = io_outputs_0_rsp_payload_last;
        _zz_io_input_rsp_payload_fragment_opcode = io_outputs_0_rsp_payload_fragment_opcode;
        _zz_io_input_rsp_payload_fragment_data = io_outputs_0_rsp_payload_fragment_data;
        _zz_io_input_rsp_payload_fragment_context = io_outputs_0_rsp_payload_fragment_context;
      end
      3'b001 : begin
        _zz_io_input_rsp_payload_last_3 = io_outputs_1_rsp_payload_last;
        _zz_io_input_rsp_payload_fragment_opcode = io_outputs_1_rsp_payload_fragment_opcode;
        _zz_io_input_rsp_payload_fragment_data = io_outputs_1_rsp_payload_fragment_data;
        _zz_io_input_rsp_payload_fragment_context = io_outputs_1_rsp_payload_fragment_context;
      end
      3'b010 : begin
        _zz_io_input_rsp_payload_last_3 = io_outputs_2_rsp_payload_last;
        _zz_io_input_rsp_payload_fragment_opcode = io_outputs_2_rsp_payload_fragment_opcode;
        _zz_io_input_rsp_payload_fragment_data = io_outputs_2_rsp_payload_fragment_data;
        _zz_io_input_rsp_payload_fragment_context = io_outputs_2_rsp_payload_fragment_context;
      end
      3'b011 : begin
        _zz_io_input_rsp_payload_last_3 = io_outputs_3_rsp_payload_last;
        _zz_io_input_rsp_payload_fragment_opcode = io_outputs_3_rsp_payload_fragment_opcode;
        _zz_io_input_rsp_payload_fragment_data = io_outputs_3_rsp_payload_fragment_data;
        _zz_io_input_rsp_payload_fragment_context = io_outputs_3_rsp_payload_fragment_context;
      end
      default : begin
        _zz_io_input_rsp_payload_last_3 = io_outputs_4_rsp_payload_last;
        _zz_io_input_rsp_payload_fragment_opcode = io_outputs_4_rsp_payload_fragment_opcode;
        _zz_io_input_rsp_payload_fragment_data = io_outputs_4_rsp_payload_fragment_data;
        _zz_io_input_rsp_payload_fragment_context = io_outputs_4_rsp_payload_fragment_context;
      end
    endcase
  end

  assign logic_input_valid = io_input_cmd_valid;
  assign io_input_cmd_ready = logic_input_ready;
  assign logic_input_payload_last = io_input_cmd_payload_last;
  assign logic_input_payload_fragment_opcode = io_input_cmd_payload_fragment_opcode;
  assign logic_input_payload_fragment_address = io_input_cmd_payload_fragment_address;
  assign logic_input_payload_fragment_length = io_input_cmd_payload_fragment_length;
  assign logic_input_payload_fragment_data = io_input_cmd_payload_fragment_data;
  assign logic_input_payload_fragment_mask = io_input_cmd_payload_fragment_mask;
  assign logic_input_payload_fragment_context = io_input_cmd_payload_fragment_context;
  assign logic_noHitS0 = (! (|{logic_hitsS0_4,{logic_hitsS0_3,{logic_hitsS0_2,{logic_hitsS0_1,logic_hitsS0_0}}}}));
  assign logic_hitsS0_0 = ((io_input_cmd_payload_fragment_address & (~ 24'h00003f)) == 24'h010000);
  always @(*) begin
    io_outputs_0_cmd_valid = (logic_input_valid && logic_hitsS0_0);
    if(logic_cmdWait) begin
      io_outputs_0_cmd_valid = 1'b0;
    end
  end

  assign _zz_io_outputs_0_cmd_payload_last = logic_input_payload_last;
  assign io_outputs_0_cmd_payload_last = _zz_io_outputs_0_cmd_payload_last;
  assign io_outputs_0_cmd_payload_fragment_opcode = logic_input_payload_fragment_opcode;
  assign io_outputs_0_cmd_payload_fragment_address = logic_input_payload_fragment_address;
  assign io_outputs_0_cmd_payload_fragment_length = logic_input_payload_fragment_length;
  assign io_outputs_0_cmd_payload_fragment_data = logic_input_payload_fragment_data;
  assign io_outputs_0_cmd_payload_fragment_mask = logic_input_payload_fragment_mask;
  assign io_outputs_0_cmd_payload_fragment_context = logic_input_payload_fragment_context;
  assign logic_hitsS0_1 = ((io_input_cmd_payload_fragment_address & (~ 24'h000fff)) == 24'h030000);
  always @(*) begin
    io_outputs_1_cmd_valid = (logic_input_valid && logic_hitsS0_1);
    if(logic_cmdWait) begin
      io_outputs_1_cmd_valid = 1'b0;
    end
  end

  assign _zz_io_outputs_1_cmd_payload_last = logic_input_payload_last;
  assign io_outputs_1_cmd_payload_last = _zz_io_outputs_1_cmd_payload_last;
  assign io_outputs_1_cmd_payload_fragment_opcode = logic_input_payload_fragment_opcode;
  assign io_outputs_1_cmd_payload_fragment_address = logic_input_payload_fragment_address;
  assign io_outputs_1_cmd_payload_fragment_length = logic_input_payload_fragment_length;
  assign io_outputs_1_cmd_payload_fragment_data = logic_input_payload_fragment_data;
  assign io_outputs_1_cmd_payload_fragment_mask = logic_input_payload_fragment_mask;
  assign io_outputs_1_cmd_payload_fragment_context = logic_input_payload_fragment_context;
  assign logic_hitsS0_2 = ((io_input_cmd_payload_fragment_address & (~ 24'h0000ff)) == 24'h020000);
  always @(*) begin
    io_outputs_2_cmd_valid = (logic_input_valid && logic_hitsS0_2);
    if(logic_cmdWait) begin
      io_outputs_2_cmd_valid = 1'b0;
    end
  end

  assign _zz_io_outputs_2_cmd_payload_last = logic_input_payload_last;
  assign io_outputs_2_cmd_payload_last = _zz_io_outputs_2_cmd_payload_last;
  assign io_outputs_2_cmd_payload_fragment_opcode = logic_input_payload_fragment_opcode;
  assign io_outputs_2_cmd_payload_fragment_address = logic_input_payload_fragment_address;
  assign io_outputs_2_cmd_payload_fragment_length = logic_input_payload_fragment_length;
  assign io_outputs_2_cmd_payload_fragment_data = logic_input_payload_fragment_data;
  assign io_outputs_2_cmd_payload_fragment_mask = logic_input_payload_fragment_mask;
  assign io_outputs_2_cmd_payload_fragment_context = logic_input_payload_fragment_context;
  assign logic_hitsS0_3 = ((io_input_cmd_payload_fragment_address & (~ 24'h000fff)) == 24'h200000);
  always @(*) begin
    io_outputs_3_cmd_valid = (logic_input_valid && logic_hitsS0_3);
    if(logic_cmdWait) begin
      io_outputs_3_cmd_valid = 1'b0;
    end
  end

  assign _zz_io_outputs_3_cmd_payload_last = logic_input_payload_last;
  assign io_outputs_3_cmd_payload_last = _zz_io_outputs_3_cmd_payload_last;
  assign io_outputs_3_cmd_payload_fragment_opcode = logic_input_payload_fragment_opcode;
  assign io_outputs_3_cmd_payload_fragment_address = logic_input_payload_fragment_address;
  assign io_outputs_3_cmd_payload_fragment_length = logic_input_payload_fragment_length;
  assign io_outputs_3_cmd_payload_fragment_data = logic_input_payload_fragment_data;
  assign io_outputs_3_cmd_payload_fragment_mask = logic_input_payload_fragment_mask;
  assign io_outputs_3_cmd_payload_fragment_context = logic_input_payload_fragment_context;
  assign logic_hitsS0_4 = ((io_input_cmd_payload_fragment_address & (~ 24'h00ffff)) == 24'h100000);
  always @(*) begin
    io_outputs_4_cmd_valid = (logic_input_valid && logic_hitsS0_4);
    if(logic_cmdWait) begin
      io_outputs_4_cmd_valid = 1'b0;
    end
  end

  assign _zz_io_outputs_4_cmd_payload_last = logic_input_payload_last;
  assign io_outputs_4_cmd_payload_last = _zz_io_outputs_4_cmd_payload_last;
  assign io_outputs_4_cmd_payload_fragment_opcode = logic_input_payload_fragment_opcode;
  assign io_outputs_4_cmd_payload_fragment_address = logic_input_payload_fragment_address;
  assign io_outputs_4_cmd_payload_fragment_length = logic_input_payload_fragment_length;
  assign io_outputs_4_cmd_payload_fragment_data = logic_input_payload_fragment_data;
  assign io_outputs_4_cmd_payload_fragment_mask = logic_input_payload_fragment_mask;
  assign io_outputs_4_cmd_payload_fragment_context = logic_input_payload_fragment_context;
  always @(*) begin
    logic_input_ready = ((|{(logic_hitsS0_4 && io_outputs_4_cmd_ready),{(logic_hitsS0_3 && io_outputs_3_cmd_ready),{(logic_hitsS0_2 && io_outputs_2_cmd_ready),{(logic_hitsS0_1 && io_outputs_1_cmd_ready),(logic_hitsS0_0 && io_outputs_0_cmd_ready)}}}}) || logic_noHitS0);
    if(logic_cmdWait) begin
      logic_input_ready = 1'b0;
    end
  end

  assign logic_input_fire = (logic_input_valid && logic_input_ready);
  assign io_input_rsp_fire = (io_input_rsp_valid && io_input_rsp_ready);
  assign when_BmbDecoder_l56 = (logic_input_valid && (! logic_cmdWait));
  assign logic_rspPending = (logic_rspPendingCounter != 7'h0);
  assign logic_rspNoHitValid = (! (|{logic_rspHits_4,{logic_rspHits_3,{logic_rspHits_2,{logic_rspHits_1,logic_rspHits_0}}}}));
  assign when_BmbDecoder_l60 = (io_input_rsp_fire && io_input_rsp_payload_last);
  assign when_BmbDecoder_l60_1 = ((logic_input_fire && logic_noHitS0) && logic_input_payload_last);
  always @(*) begin
    io_input_rsp_valid = ((|{io_outputs_4_rsp_valid,{io_outputs_3_rsp_valid,{io_outputs_2_rsp_valid,{io_outputs_1_rsp_valid,io_outputs_0_rsp_valid}}}}) || (logic_rspPending && logic_rspNoHitValid));
    if(logic_rspNoHit_doIt) begin
      io_input_rsp_valid = 1'b1;
    end
  end

  assign _zz_io_input_rsp_payload_last = (logic_rspHits_1 || logic_rspHits_3);
  assign _zz_io_input_rsp_payload_last_1 = (logic_rspHits_2 || logic_rspHits_3);
  assign _zz_io_input_rsp_payload_last_2 = {logic_rspHits_4,{_zz_io_input_rsp_payload_last_1,_zz_io_input_rsp_payload_last}};
  always @(*) begin
    io_input_rsp_payload_last = _zz_io_input_rsp_payload_last_3;
    if(logic_rspNoHit_doIt) begin
      io_input_rsp_payload_last = 1'b1;
    end
  end

  always @(*) begin
    io_input_rsp_payload_fragment_opcode = _zz_io_input_rsp_payload_fragment_opcode;
    if(logic_rspNoHit_doIt) begin
      io_input_rsp_payload_fragment_opcode = 1'b1;
    end
  end

  assign io_input_rsp_payload_fragment_data = _zz_io_input_rsp_payload_fragment_data;
  always @(*) begin
    io_input_rsp_payload_fragment_context = _zz_io_input_rsp_payload_fragment_context;
    if(logic_rspNoHit_doIt) begin
      io_input_rsp_payload_fragment_context = logic_rspNoHit_context;
    end
  end

  assign io_outputs_0_rsp_ready = io_input_rsp_ready;
  assign io_outputs_1_rsp_ready = io_input_rsp_ready;
  assign io_outputs_2_rsp_ready = io_input_rsp_ready;
  assign io_outputs_3_rsp_ready = io_input_rsp_ready;
  assign io_outputs_4_rsp_ready = io_input_rsp_ready;
  assign logic_cmdWait = ((logic_rspPending && ((((((logic_hitsS0_0 != logic_rspHits_0) || (logic_hitsS0_1 != logic_rspHits_1)) || (logic_hitsS0_2 != logic_rspHits_2)) || (logic_hitsS0_3 != logic_rspHits_3)) || (logic_hitsS0_4 != logic_rspHits_4)) || logic_rspNoHitValid)) || (logic_rspPendingCounter == 7'h40));
  always @(posedge clk) begin
    if(reset) begin
      logic_rspPendingCounter <= 7'h0;
      logic_rspNoHit_doIt <= 1'b0;
    end else begin
      logic_rspPendingCounter <= (_zz_logic_rspPendingCounter - _zz_logic_rspPendingCounter_3);
      if(when_BmbDecoder_l60) begin
        logic_rspNoHit_doIt <= 1'b0;
      end
      if(when_BmbDecoder_l60_1) begin
        logic_rspNoHit_doIt <= 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if(when_BmbDecoder_l56) begin
      logic_rspHits_0 <= logic_hitsS0_0;
      logic_rspHits_1 <= logic_hitsS0_1;
      logic_rspHits_2 <= logic_hitsS0_2;
      logic_rspHits_3 <= logic_hitsS0_3;
      logic_rspHits_4 <= logic_hitsS0_4;
    end
    if(logic_input_fire) begin
      logic_rspNoHit_singleBeatRsp <= (logic_input_payload_fragment_opcode == 1'b1);
    end
    if(logic_input_fire) begin
      logic_rspNoHit_context <= logic_input_payload_fragment_context;
    end
  end


endmodule

module Axi4PeripheralBmbUnburstify (
  input  wire          io_input_cmd_valid,
  output reg           io_input_cmd_ready,
  input  wire          io_input_cmd_payload_last,
  input  wire [0:0]    io_input_cmd_payload_fragment_source,
  input  wire [0:0]    io_input_cmd_payload_fragment_opcode,
  input  wire [23:0]   io_input_cmd_payload_fragment_address,
  input  wire [9:0]    io_input_cmd_payload_fragment_length,
  input  wire [31:0]   io_input_cmd_payload_fragment_data,
  input  wire [3:0]    io_input_cmd_payload_fragment_mask,
  output wire          io_input_rsp_valid,
  input  wire          io_input_rsp_ready,
  output wire          io_input_rsp_payload_last,
  output wire [0:0]    io_input_rsp_payload_fragment_source,
  output wire [0:0]    io_input_rsp_payload_fragment_opcode,
  output wire [31:0]   io_input_rsp_payload_fragment_data,
  output reg           io_output_cmd_valid,
  input  wire          io_output_cmd_ready,
  output wire          io_output_cmd_payload_last,
  output reg  [0:0]    io_output_cmd_payload_fragment_opcode,
  output reg  [23:0]   io_output_cmd_payload_fragment_address,
  output reg  [1:0]    io_output_cmd_payload_fragment_length,
  output wire [31:0]   io_output_cmd_payload_fragment_data,
  output wire [3:0]    io_output_cmd_payload_fragment_mask,
  output wire [2:0]    io_output_cmd_payload_fragment_context,
  input  wire          io_output_rsp_valid,
  output reg           io_output_rsp_ready,
  input  wire          io_output_rsp_payload_last,
  input  wire [0:0]    io_output_rsp_payload_fragment_opcode,
  input  wire [31:0]   io_output_rsp_payload_fragment_data,
  input  wire [2:0]    io_output_rsp_payload_fragment_context,
  input  wire          clk,
  input  wire          reset
);

  wire       [7:0]    _zz_buffer_last;
  wire       [0:0]    _zz_buffer_last_1;
  wire       [11:0]   _zz_buffer_addressIncr;
  wire                doResult;
  reg                 buffer_valid;
  reg        [0:0]    buffer_opcode;
  reg        [0:0]    buffer_source;
  reg        [23:0]   buffer_address;
  reg        [7:0]    buffer_beat;
  wire                buffer_last;
  wire       [23:0]   buffer_addressIncr;
  wire                buffer_isWrite;
  wire                io_output_cmd_fire;
  wire       [7:0]    cmdTransferBeatCount;
  wire                requireBuffer;
  reg                 cmdContext_drop;
  reg                 cmdContext_last;
  reg        [0:0]    cmdContext_source;
  wire                rspContext_drop;
  wire                rspContext_last;
  wire       [0:0]    rspContext_source;
  wire       [2:0]    _zz_rspContext_drop;
  wire                when_Stream_l445;
  reg                 io_output_rsp_thrown_valid;
  wire                io_output_rsp_thrown_ready;
  wire                io_output_rsp_thrown_payload_last;
  wire       [0:0]    io_output_rsp_thrown_payload_fragment_opcode;
  wire       [31:0]   io_output_rsp_thrown_payload_fragment_data;
  wire       [2:0]    io_output_rsp_thrown_payload_fragment_context;

  assign _zz_buffer_last_1 = 1'b1;
  assign _zz_buffer_last = {7'd0, _zz_buffer_last_1};
  assign _zz_buffer_addressIncr = (buffer_address[11 : 0] + 12'h004);
  assign buffer_last = (buffer_beat == _zz_buffer_last);
  assign buffer_addressIncr = {buffer_address[23 : 12],(_zz_buffer_addressIncr & (~ 12'h003))};
  assign buffer_isWrite = (buffer_opcode == 1'b1);
  assign io_output_cmd_fire = (io_output_cmd_valid && io_output_cmd_ready);
  assign cmdTransferBeatCount = io_input_cmd_payload_fragment_length[9 : 2];
  assign requireBuffer = (cmdTransferBeatCount != 8'h0);
  assign io_output_cmd_payload_fragment_data = io_input_cmd_payload_fragment_data;
  assign io_output_cmd_payload_fragment_mask = io_input_cmd_payload_fragment_mask;
  assign io_output_cmd_payload_last = 1'b1;
  assign io_output_cmd_payload_fragment_context = {cmdContext_source,{cmdContext_last,cmdContext_drop}};
  always @(*) begin
    if(buffer_valid) begin
      io_output_cmd_payload_fragment_address = buffer_addressIncr;
    end else begin
      io_output_cmd_payload_fragment_address = io_input_cmd_payload_fragment_address;
      if(requireBuffer) begin
        io_output_cmd_payload_fragment_address[1 : 0] = 2'b00;
      end
    end
  end

  always @(*) begin
    if(buffer_valid) begin
      io_output_cmd_payload_fragment_opcode = buffer_opcode;
    end else begin
      io_output_cmd_payload_fragment_opcode = io_input_cmd_payload_fragment_opcode;
    end
  end

  always @(*) begin
    if(buffer_valid) begin
      io_output_cmd_payload_fragment_length = 2'b11;
    end else begin
      if(requireBuffer) begin
        io_output_cmd_payload_fragment_length = 2'b11;
      end else begin
        io_output_cmd_payload_fragment_length = io_input_cmd_payload_fragment_length[1:0];
      end
    end
  end

  always @(*) begin
    if(buffer_valid) begin
      cmdContext_source = buffer_source;
    end else begin
      cmdContext_source = io_input_cmd_payload_fragment_source;
    end
  end

  always @(*) begin
    io_input_cmd_ready = 1'b0;
    if(buffer_valid) begin
      io_input_cmd_ready = (buffer_isWrite && io_output_cmd_ready);
    end else begin
      io_input_cmd_ready = io_output_cmd_ready;
    end
  end

  always @(*) begin
    if(buffer_valid) begin
      io_output_cmd_valid = (! (buffer_isWrite && (! io_input_cmd_valid)));
    end else begin
      io_output_cmd_valid = io_input_cmd_valid;
    end
  end

  always @(*) begin
    if(buffer_valid) begin
      cmdContext_last = buffer_last;
    end else begin
      cmdContext_last = (! requireBuffer);
    end
  end

  always @(*) begin
    if(buffer_valid) begin
      cmdContext_drop = buffer_isWrite;
    end else begin
      cmdContext_drop = (io_input_cmd_payload_fragment_opcode == 1'b1);
    end
  end

  assign _zz_rspContext_drop = io_output_rsp_payload_fragment_context;
  assign rspContext_drop = _zz_rspContext_drop[0];
  assign rspContext_last = _zz_rspContext_drop[1];
  assign rspContext_source = _zz_rspContext_drop[2 : 2];
  assign when_Stream_l445 = (! (rspContext_last || (! rspContext_drop)));
  always @(*) begin
    io_output_rsp_thrown_valid = io_output_rsp_valid;
    if(when_Stream_l445) begin
      io_output_rsp_thrown_valid = 1'b0;
    end
  end

  always @(*) begin
    io_output_rsp_ready = io_output_rsp_thrown_ready;
    if(when_Stream_l445) begin
      io_output_rsp_ready = 1'b1;
    end
  end

  assign io_output_rsp_thrown_payload_last = io_output_rsp_payload_last;
  assign io_output_rsp_thrown_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_output_rsp_thrown_payload_fragment_data = io_output_rsp_payload_fragment_data;
  assign io_output_rsp_thrown_payload_fragment_context = io_output_rsp_payload_fragment_context;
  assign io_input_rsp_valid = io_output_rsp_thrown_valid;
  assign io_output_rsp_thrown_ready = io_input_rsp_ready;
  assign io_input_rsp_payload_last = rspContext_last;
  assign io_input_rsp_payload_fragment_source = rspContext_source;
  assign io_input_rsp_payload_fragment_opcode = io_output_rsp_payload_fragment_opcode;
  assign io_input_rsp_payload_fragment_data = io_output_rsp_payload_fragment_data;
  always @(posedge clk) begin
    if(reset) begin
      buffer_valid <= 1'b0;
    end else begin
      if(io_output_cmd_fire) begin
        if(buffer_last) begin
          buffer_valid <= 1'b0;
        end
      end
      if(!buffer_valid) begin
        buffer_valid <= (requireBuffer && io_output_cmd_fire);
      end
    end
  end

  always @(posedge clk) begin
    if(io_output_cmd_fire) begin
      buffer_beat <= (buffer_beat - 8'h01);
      buffer_address[11 : 0] <= buffer_addressIncr[11 : 0];
    end
    if(!buffer_valid) begin
      buffer_opcode <= io_input_cmd_payload_fragment_opcode;
      buffer_source <= io_input_cmd_payload_fragment_source;
      buffer_address <= io_input_cmd_payload_fragment_address;
      buffer_beat <= cmdTransferBeatCount;
    end
  end


endmodule

module Axi4PeripheralBmbDecoder (
  input  wire          io_input_cmd_valid,
  output wire          io_input_cmd_ready,
  input  wire          io_input_cmd_payload_last,
  input  wire [0:0]    io_input_cmd_payload_fragment_source,
  input  wire [0:0]    io_input_cmd_payload_fragment_opcode,
  input  wire [23:0]   io_input_cmd_payload_fragment_address,
  input  wire [9:0]    io_input_cmd_payload_fragment_length,
  input  wire [31:0]   io_input_cmd_payload_fragment_data,
  input  wire [3:0]    io_input_cmd_payload_fragment_mask,
  output reg           io_input_rsp_valid,
  input  wire          io_input_rsp_ready,
  output reg           io_input_rsp_payload_last,
  output reg  [0:0]    io_input_rsp_payload_fragment_source,
  output reg  [0:0]    io_input_rsp_payload_fragment_opcode,
  output wire [31:0]   io_input_rsp_payload_fragment_data,
  output reg           io_outputs_0_cmd_valid,
  input  wire          io_outputs_0_cmd_ready,
  output wire          io_outputs_0_cmd_payload_last,
  output wire [0:0]    io_outputs_0_cmd_payload_fragment_source,
  output wire [0:0]    io_outputs_0_cmd_payload_fragment_opcode,
  output wire [23:0]   io_outputs_0_cmd_payload_fragment_address,
  output wire [9:0]    io_outputs_0_cmd_payload_fragment_length,
  output wire [31:0]   io_outputs_0_cmd_payload_fragment_data,
  output wire [3:0]    io_outputs_0_cmd_payload_fragment_mask,
  input  wire          io_outputs_0_rsp_valid,
  output wire          io_outputs_0_rsp_ready,
  input  wire          io_outputs_0_rsp_payload_last,
  input  wire [0:0]    io_outputs_0_rsp_payload_fragment_source,
  input  wire [0:0]    io_outputs_0_rsp_payload_fragment_opcode,
  input  wire [31:0]   io_outputs_0_rsp_payload_fragment_data,
  input  wire          clk,
  input  wire          reset
);

  wire       [6:0]    _zz_logic_rspPendingCounter;
  wire       [6:0]    _zz_logic_rspPendingCounter_1;
  wire       [0:0]    _zz_logic_rspPendingCounter_2;
  wire       [6:0]    _zz_logic_rspPendingCounter_3;
  wire       [0:0]    _zz_logic_rspPendingCounter_4;
  wire                logic_input_valid;
  reg                 logic_input_ready;
  wire                logic_input_payload_last;
  wire       [0:0]    logic_input_payload_fragment_source;
  wire       [0:0]    logic_input_payload_fragment_opcode;
  wire       [23:0]   logic_input_payload_fragment_address;
  wire       [9:0]    logic_input_payload_fragment_length;
  wire       [31:0]   logic_input_payload_fragment_data;
  wire       [3:0]    logic_input_payload_fragment_mask;
  wire                logic_hitsS0_0;
  wire                logic_noHitS0;
  wire                _zz_io_outputs_0_cmd_payload_last;
  reg        [6:0]    logic_rspPendingCounter;
  wire                logic_input_fire;
  wire                io_input_rsp_fire;
  wire                logic_cmdWait;
  wire                when_BmbDecoder_l56;
  reg                 logic_rspHits_0;
  wire                logic_rspPending;
  wire                logic_rspNoHitValid;
  reg                 logic_rspNoHit_doIt;
  wire                when_BmbDecoder_l60;
  wire                when_BmbDecoder_l60_1;
  reg                 logic_rspNoHit_singleBeatRsp;
  reg        [0:0]    logic_rspNoHit_source;
  reg        [7:0]    logic_rspNoHit_counter;
  wire                when_BmbDecoder_l81;

  assign _zz_logic_rspPendingCounter = (logic_rspPendingCounter + _zz_logic_rspPendingCounter_1);
  assign _zz_logic_rspPendingCounter_2 = (logic_input_fire && logic_input_payload_last);
  assign _zz_logic_rspPendingCounter_1 = {6'd0, _zz_logic_rspPendingCounter_2};
  assign _zz_logic_rspPendingCounter_4 = (io_input_rsp_fire && io_input_rsp_payload_last);
  assign _zz_logic_rspPendingCounter_3 = {6'd0, _zz_logic_rspPendingCounter_4};
  assign logic_input_valid = io_input_cmd_valid;
  assign io_input_cmd_ready = logic_input_ready;
  assign logic_input_payload_last = io_input_cmd_payload_last;
  assign logic_input_payload_fragment_source = io_input_cmd_payload_fragment_source;
  assign logic_input_payload_fragment_opcode = io_input_cmd_payload_fragment_opcode;
  assign logic_input_payload_fragment_address = io_input_cmd_payload_fragment_address;
  assign logic_input_payload_fragment_length = io_input_cmd_payload_fragment_length;
  assign logic_input_payload_fragment_data = io_input_cmd_payload_fragment_data;
  assign logic_input_payload_fragment_mask = io_input_cmd_payload_fragment_mask;
  assign logic_noHitS0 = (! (|logic_hitsS0_0));
  assign logic_hitsS0_0 = ((io_input_cmd_payload_fragment_address & (~ 24'hffffff)) == 24'h0);
  always @(*) begin
    io_outputs_0_cmd_valid = (logic_input_valid && logic_hitsS0_0);
    if(logic_cmdWait) begin
      io_outputs_0_cmd_valid = 1'b0;
    end
  end

  assign _zz_io_outputs_0_cmd_payload_last = logic_input_payload_last;
  assign io_outputs_0_cmd_payload_last = _zz_io_outputs_0_cmd_payload_last;
  assign io_outputs_0_cmd_payload_fragment_source = logic_input_payload_fragment_source;
  assign io_outputs_0_cmd_payload_fragment_opcode = logic_input_payload_fragment_opcode;
  assign io_outputs_0_cmd_payload_fragment_address = logic_input_payload_fragment_address;
  assign io_outputs_0_cmd_payload_fragment_length = logic_input_payload_fragment_length;
  assign io_outputs_0_cmd_payload_fragment_data = logic_input_payload_fragment_data;
  assign io_outputs_0_cmd_payload_fragment_mask = logic_input_payload_fragment_mask;
  always @(*) begin
    logic_input_ready = ((|(logic_hitsS0_0 && io_outputs_0_cmd_ready)) || logic_noHitS0);
    if(logic_cmdWait) begin
      logic_input_ready = 1'b0;
    end
  end

  assign logic_input_fire = (logic_input_valid && logic_input_ready);
  assign io_input_rsp_fire = (io_input_rsp_valid && io_input_rsp_ready);
  assign when_BmbDecoder_l56 = (logic_input_valid && (! logic_cmdWait));
  assign logic_rspPending = (logic_rspPendingCounter != 7'h0);
  assign logic_rspNoHitValid = (! (|logic_rspHits_0));
  assign when_BmbDecoder_l60 = (io_input_rsp_fire && io_input_rsp_payload_last);
  assign when_BmbDecoder_l60_1 = ((logic_input_fire && logic_noHitS0) && logic_input_payload_last);
  always @(*) begin
    io_input_rsp_valid = ((|io_outputs_0_rsp_valid) || (logic_rspPending && logic_rspNoHitValid));
    if(logic_rspNoHit_doIt) begin
      io_input_rsp_valid = 1'b1;
    end
  end

  always @(*) begin
    io_input_rsp_payload_last = io_outputs_0_rsp_payload_last;
    if(logic_rspNoHit_doIt) begin
      io_input_rsp_payload_last = 1'b0;
      if(when_BmbDecoder_l81) begin
        io_input_rsp_payload_last = 1'b1;
      end
      if(logic_rspNoHit_singleBeatRsp) begin
        io_input_rsp_payload_last = 1'b1;
      end
    end
  end

  always @(*) begin
    io_input_rsp_payload_fragment_source = io_outputs_0_rsp_payload_fragment_source;
    if(logic_rspNoHit_doIt) begin
      io_input_rsp_payload_fragment_source = logic_rspNoHit_source;
    end
  end

  always @(*) begin
    io_input_rsp_payload_fragment_opcode = io_outputs_0_rsp_payload_fragment_opcode;
    if(logic_rspNoHit_doIt) begin
      io_input_rsp_payload_fragment_opcode = 1'b1;
    end
  end

  assign io_input_rsp_payload_fragment_data = io_outputs_0_rsp_payload_fragment_data;
  assign when_BmbDecoder_l81 = (logic_rspNoHit_counter == 8'h0);
  assign io_outputs_0_rsp_ready = io_input_rsp_ready;
  assign logic_cmdWait = ((logic_rspPending && ((logic_hitsS0_0 != logic_rspHits_0) || logic_rspNoHitValid)) || (logic_rspPendingCounter == 7'h40));
  always @(posedge clk) begin
    if(reset) begin
      logic_rspPendingCounter <= 7'h0;
      logic_rspNoHit_doIt <= 1'b0;
    end else begin
      logic_rspPendingCounter <= (_zz_logic_rspPendingCounter - _zz_logic_rspPendingCounter_3);
      if(when_BmbDecoder_l60) begin
        logic_rspNoHit_doIt <= 1'b0;
      end
      if(when_BmbDecoder_l60_1) begin
        logic_rspNoHit_doIt <= 1'b1;
      end
    end
  end

  always @(posedge clk) begin
    if(when_BmbDecoder_l56) begin
      logic_rspHits_0 <= logic_hitsS0_0;
    end
    if(logic_input_fire) begin
      logic_rspNoHit_singleBeatRsp <= (logic_input_payload_fragment_opcode == 1'b1);
    end
    if(logic_input_fire) begin
      logic_rspNoHit_source <= logic_input_payload_fragment_source;
    end
    if(logic_input_fire) begin
      logic_rspNoHit_counter <= logic_input_payload_fragment_length[9 : 2];
    end
    if(logic_rspNoHit_doIt) begin
      if(io_input_rsp_fire) begin
        logic_rspNoHit_counter <= (logic_rspNoHit_counter - 8'h01);
      end
    end
  end


endmodule

module Axi4PeripheralAxi4SharedToBmb (
  input  wire          io_axi_arw_valid,
  output wire          io_axi_arw_ready,
  input  wire [23:0]   io_axi_arw_payload_addr,
  input  wire [7:0]    io_axi_arw_payload_len,
  input  wire [2:0]    io_axi_arw_payload_size,
  input  wire [3:0]    io_axi_arw_payload_cache,
  input  wire [2:0]    io_axi_arw_payload_prot,
  input  wire          io_axi_arw_payload_write,
  input  wire          io_axi_w_valid,
  output wire          io_axi_w_ready,
  input  wire [31:0]   io_axi_w_payload_data,
  input  wire [3:0]    io_axi_w_payload_strb,
  input  wire          io_axi_w_payload_last,
  output wire          io_axi_b_valid,
  input  wire          io_axi_b_ready,
  output reg  [1:0]    io_axi_b_payload_resp,
  output wire          io_axi_r_valid,
  input  wire          io_axi_r_ready,
  output wire [31:0]   io_axi_r_payload_data,
  output reg  [1:0]    io_axi_r_payload_resp,
  output wire          io_axi_r_payload_last,
  output wire          io_bmb_cmd_valid,
  input  wire          io_bmb_cmd_ready,
  output wire          io_bmb_cmd_payload_last,
  output wire [0:0]    io_bmb_cmd_payload_fragment_source,
  output wire [0:0]    io_bmb_cmd_payload_fragment_opcode,
  output wire [23:0]   io_bmb_cmd_payload_fragment_address,
  output wire [9:0]    io_bmb_cmd_payload_fragment_length,
  output wire [31:0]   io_bmb_cmd_payload_fragment_data,
  output wire [3:0]    io_bmb_cmd_payload_fragment_mask,
  input  wire          io_bmb_rsp_valid,
  output wire          io_bmb_rsp_ready,
  input  wire          io_bmb_rsp_payload_last,
  input  wire [0:0]    io_bmb_rsp_payload_fragment_source,
  input  wire [0:0]    io_bmb_rsp_payload_fragment_opcode,
  input  wire [31:0]   io_bmb_rsp_payload_fragment_data
);

  wire       [9:0]    _zz_io_bmb_cmd_payload_fragment_length;
  wire                hazard;
  wire                io_bmb_cmd_fire;
  wire                rspIsWrite;
  wire                when_Axi4SharedToBmb_l42;
  wire                when_Axi4SharedToBmb_l49;

  assign _zz_io_bmb_cmd_payload_fragment_length = ({2'd0,io_axi_arw_payload_len} <<< 2'd2);
  assign hazard = (io_axi_arw_payload_write && (! io_axi_w_valid));
  assign io_bmb_cmd_valid = (io_axi_arw_valid && (! hazard));
  assign io_bmb_cmd_payload_fragment_source = io_axi_arw_payload_write;
  assign io_bmb_cmd_payload_fragment_opcode = io_axi_arw_payload_write;
  assign io_bmb_cmd_payload_fragment_address = io_axi_arw_payload_addr;
  assign io_bmb_cmd_payload_fragment_length = (_zz_io_bmb_cmd_payload_fragment_length | 10'h003);
  assign io_bmb_cmd_payload_fragment_data = io_axi_w_payload_data;
  assign io_bmb_cmd_payload_fragment_mask = io_axi_w_payload_strb;
  assign io_bmb_cmd_payload_last = ((! io_axi_arw_payload_write) || io_axi_w_payload_last);
  assign io_bmb_cmd_fire = (io_bmb_cmd_valid && io_bmb_cmd_ready);
  assign io_axi_arw_ready = (io_bmb_cmd_fire && io_bmb_cmd_payload_last);
  assign io_axi_w_ready = (io_bmb_cmd_fire && (io_bmb_cmd_payload_fragment_opcode == 1'b1));
  assign rspIsWrite = io_bmb_rsp_payload_fragment_source[0];
  assign io_axi_b_valid = (io_bmb_rsp_valid && rspIsWrite);
  always @(*) begin
    io_axi_b_payload_resp = 2'b00;
    if(when_Axi4SharedToBmb_l42) begin
      io_axi_b_payload_resp = 2'b11;
    end
  end

  assign when_Axi4SharedToBmb_l42 = (io_bmb_rsp_payload_fragment_opcode == 1'b1);
  assign io_axi_r_valid = (io_bmb_rsp_valid && (! rspIsWrite));
  assign io_axi_r_payload_data = io_bmb_rsp_payload_fragment_data;
  assign io_axi_r_payload_last = io_bmb_rsp_payload_last;
  always @(*) begin
    io_axi_r_payload_resp = 2'b00;
    if(when_Axi4SharedToBmb_l49) begin
      io_axi_r_payload_resp = 2'b11;
    end
  end

  assign when_Axi4SharedToBmb_l49 = (io_bmb_rsp_payload_fragment_opcode == 1'b1);
  assign io_bmb_rsp_ready = (rspIsWrite ? io_axi_b_ready : io_axi_r_ready);

endmodule

module Axi4PeripheralStreamArbiter (
  input  wire          io_inputs_0_valid,
  output wire          io_inputs_0_ready,
  input  wire [23:0]   io_inputs_0_payload_addr,
  input  wire [7:0]    io_inputs_0_payload_len,
  input  wire [2:0]    io_inputs_0_payload_size,
  input  wire [3:0]    io_inputs_0_payload_cache,
  input  wire [2:0]    io_inputs_0_payload_prot,
  input  wire          io_inputs_1_valid,
  output wire          io_inputs_1_ready,
  input  wire [23:0]   io_inputs_1_payload_addr,
  input  wire [7:0]    io_inputs_1_payload_len,
  input  wire [2:0]    io_inputs_1_payload_size,
  input  wire [3:0]    io_inputs_1_payload_cache,
  input  wire [2:0]    io_inputs_1_payload_prot,
  output wire          io_output_valid,
  input  wire          io_output_ready,
  output wire [23:0]   io_output_payload_addr,
  output wire [7:0]    io_output_payload_len,
  output wire [2:0]    io_output_payload_size,
  output wire [3:0]    io_output_payload_cache,
  output wire [2:0]    io_output_payload_prot,
  output wire [0:0]    io_chosen,
  output wire [1:0]    io_chosenOH,
  input  wire          clk,
  input  wire          reset
);

  wire       [3:0]    _zz__zz_maskProposal_0_2;
  wire       [3:0]    _zz__zz_maskProposal_0_2_1;
  wire       [1:0]    _zz__zz_maskProposal_0_2_2;
  reg                 locked;
  wire                maskProposal_0;
  wire                maskProposal_1;
  reg                 maskLocked_0;
  reg                 maskLocked_1;
  wire                maskRouted_0;
  wire                maskRouted_1;
  wire       [1:0]    _zz_maskProposal_0;
  wire       [3:0]    _zz_maskProposal_0_1;
  wire       [3:0]    _zz_maskProposal_0_2;
  wire       [1:0]    _zz_maskProposal_0_3;
  wire                io_output_fire;
  wire                _zz_io_chosen;

  assign _zz__zz_maskProposal_0_2 = (_zz_maskProposal_0_1 - _zz__zz_maskProposal_0_2_1);
  assign _zz__zz_maskProposal_0_2_2 = {maskLocked_0,maskLocked_1};
  assign _zz__zz_maskProposal_0_2_1 = {2'd0, _zz__zz_maskProposal_0_2_2};
  assign maskRouted_0 = (locked ? maskLocked_0 : maskProposal_0);
  assign maskRouted_1 = (locked ? maskLocked_1 : maskProposal_1);
  assign _zz_maskProposal_0 = {io_inputs_1_valid,io_inputs_0_valid};
  assign _zz_maskProposal_0_1 = {_zz_maskProposal_0,_zz_maskProposal_0};
  assign _zz_maskProposal_0_2 = (_zz_maskProposal_0_1 & (~ _zz__zz_maskProposal_0_2));
  assign _zz_maskProposal_0_3 = (_zz_maskProposal_0_2[3 : 2] | _zz_maskProposal_0_2[1 : 0]);
  assign maskProposal_0 = _zz_maskProposal_0_3[0];
  assign maskProposal_1 = _zz_maskProposal_0_3[1];
  assign io_output_fire = (io_output_valid && io_output_ready);
  assign io_output_valid = ((io_inputs_0_valid && maskRouted_0) || (io_inputs_1_valid && maskRouted_1));
  assign io_output_payload_addr = (maskRouted_0 ? io_inputs_0_payload_addr : io_inputs_1_payload_addr);
  assign io_output_payload_len = (maskRouted_0 ? io_inputs_0_payload_len : io_inputs_1_payload_len);
  assign io_output_payload_size = (maskRouted_0 ? io_inputs_0_payload_size : io_inputs_1_payload_size);
  assign io_output_payload_cache = (maskRouted_0 ? io_inputs_0_payload_cache : io_inputs_1_payload_cache);
  assign io_output_payload_prot = (maskRouted_0 ? io_inputs_0_payload_prot : io_inputs_1_payload_prot);
  assign io_inputs_0_ready = (maskRouted_0 && io_output_ready);
  assign io_inputs_1_ready = (maskRouted_1 && io_output_ready);
  assign io_chosenOH = {maskRouted_1,maskRouted_0};
  assign _zz_io_chosen = io_chosenOH[1];
  assign io_chosen = _zz_io_chosen;
  always @(posedge clk) begin
    if(reset) begin
      locked <= 1'b0;
      maskLocked_0 <= 1'b0;
      maskLocked_1 <= 1'b1;
    end else begin
      if(io_output_valid) begin
        maskLocked_0 <= maskRouted_0;
        maskLocked_1 <= maskRouted_1;
      end
      if(io_output_valid) begin
        locked <= 1'b1;
      end
      if(io_output_fire) begin
        locked <= 1'b0;
      end
    end
  end


endmodule

module Axi4PeripheralI2cSlave (
  output wire          io_i2c_sda_write,
  input  wire          io_i2c_sda_read,
  output wire          io_i2c_scl_write,
  input  wire          io_i2c_scl_read,
  input  wire [9:0]    io_config_samplingClockDivider,
  input  wire [19:0]   io_config_timeout,
  input  wire [5:0]    io_config_tsuData,
  input  wire          io_config_timeoutClear,
  output reg  [2:0]    io_bus_cmd_kind,
  output wire          io_bus_cmd_data,
  input  wire          io_bus_rsp_valid,
  input  wire          io_bus_rsp_enable,
  input  wire          io_bus_rsp_data,
  output wire          io_timeout,
  output wire          io_internals_inFrame,
  output wire          io_internals_sdaRead,
  output wire          io_internals_sclRead,
  input  wire          clk,
  input  wire          reset
);
  localparam Axi4PeripheralI2cSlaveCmdMode_NONE = 3'd0;
  localparam Axi4PeripheralI2cSlaveCmdMode_START = 3'd1;
  localparam Axi4PeripheralI2cSlaveCmdMode_RESTART = 3'd2;
  localparam Axi4PeripheralI2cSlaveCmdMode_STOP = 3'd3;
  localparam Axi4PeripheralI2cSlaveCmdMode_DROP = 3'd4;
  localparam Axi4PeripheralI2cSlaveCmdMode_DRIVE = 3'd5;
  localparam Axi4PeripheralI2cSlaveCmdMode_READ = 3'd6;

  wire                io_i2c_scl_read_buffercc_io_dataOut;
  wire                io_i2c_sda_read_buffercc_io_dataOut;
  reg        [9:0]    filter_timer_counter;
  wire                filter_timer_tick;
  wire                filter_sampler_sclSync;
  wire                filter_sampler_sdaSync;
  wire                filter_sampler_sclSamples_0;
  wire                filter_sampler_sclSamples_1;
  wire                filter_sampler_sclSamples_2;
  wire                _zz_filter_sampler_sclSamples_0;
  reg                 _zz_filter_sampler_sclSamples_1;
  reg                 _zz_filter_sampler_sclSamples_2;
  wire                filter_sampler_sdaSamples_0;
  wire                filter_sampler_sdaSamples_1;
  wire                filter_sampler_sdaSamples_2;
  wire                _zz_filter_sampler_sdaSamples_0;
  reg                 _zz_filter_sampler_sdaSamples_1;
  reg                 _zz_filter_sampler_sdaSamples_2;
  reg                 filter_sda;
  reg                 filter_scl;
  wire                when_Misc_l82;
  wire                when_Misc_l85;
  wire                sclEdge_rise;
  wire                sclEdge_fall;
  wire                sclEdge_toggle;
  reg                 filter_scl_regNext;
  wire                sdaEdge_rise;
  wire                sdaEdge_fall;
  wire                sdaEdge_toggle;
  reg                 filter_sda_regNext;
  wire                detector_start;
  wire                detector_stop;
  reg        [5:0]    tsuData_counter;
  wire                tsuData_done;
  reg                 tsuData_reset;
  wire                when_I2CSlave_l191;
  reg                 ctrl_inFrame;
  reg                 ctrl_inFrameData;
  reg                 ctrl_sdaWrite;
  reg                 ctrl_sclWrite;
  wire                ctrl_rspBufferIn_valid;
  reg                 ctrl_rspBufferIn_ready;
  wire                ctrl_rspBufferIn_payload_enable;
  wire                ctrl_rspBufferIn_payload_data;
  wire                ctrl_rspBuffer_valid;
  reg                 ctrl_rspBuffer_ready;
  wire                ctrl_rspBuffer_payload_enable;
  wire                ctrl_rspBuffer_payload_data;
  reg                 ctrl_rspBufferIn_rValid;
  reg                 ctrl_rspBufferIn_rData_enable;
  reg                 ctrl_rspBufferIn_rData_data;
  wire                when_Stream_l375;
  wire                ctrl_rspAhead_valid;
  wire                ctrl_rspAhead_payload_enable;
  wire                ctrl_rspAhead_payload_data;
  wire                when_I2CSlave_l241;
  wire                when_I2CSlave_l245;
  wire                when_I2CSlave_l251;
  wire       [2:0]    _zz_io_bus_cmd_kind;
  reg                 timeout_enabled;
  reg        [19:0]   timeout_counter;
  wire                timeout_tick;
  wire                when_I2CSlave_l270;
  wire                when_I2CSlave_l276;
  wire       [2:0]    _zz_io_bus_cmd_kind_1;
  `ifndef SYNTHESIS
  reg [55:0] io_bus_cmd_kind_string;
  reg [55:0] _zz_io_bus_cmd_kind_string;
  reg [55:0] _zz_io_bus_cmd_kind_1_string;
  `endif


  (* keep_hierarchy = "TRUE" *) Axi4PeripheralBufferCC_1 io_i2c_scl_read_buffercc (
    .io_dataIn  (io_i2c_scl_read                    ), //i
    .io_dataOut (io_i2c_scl_read_buffercc_io_dataOut), //o
    .clk        (clk                                ), //i
    .reset      (reset                              )  //i
  );
  (* keep_hierarchy = "TRUE" *) Axi4PeripheralBufferCC_1 io_i2c_sda_read_buffercc (
    .io_dataIn  (io_i2c_sda_read                    ), //i
    .io_dataOut (io_i2c_sda_read_buffercc_io_dataOut), //o
    .clk        (clk                                ), //i
    .reset      (reset                              )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_bus_cmd_kind)
      Axi4PeripheralI2cSlaveCmdMode_NONE : io_bus_cmd_kind_string = "NONE   ";
      Axi4PeripheralI2cSlaveCmdMode_START : io_bus_cmd_kind_string = "START  ";
      Axi4PeripheralI2cSlaveCmdMode_RESTART : io_bus_cmd_kind_string = "RESTART";
      Axi4PeripheralI2cSlaveCmdMode_STOP : io_bus_cmd_kind_string = "STOP   ";
      Axi4PeripheralI2cSlaveCmdMode_DROP : io_bus_cmd_kind_string = "DROP   ";
      Axi4PeripheralI2cSlaveCmdMode_DRIVE : io_bus_cmd_kind_string = "DRIVE  ";
      Axi4PeripheralI2cSlaveCmdMode_READ : io_bus_cmd_kind_string = "READ   ";
      default : io_bus_cmd_kind_string = "???????";
    endcase
  end
  always @(*) begin
    case(_zz_io_bus_cmd_kind)
      Axi4PeripheralI2cSlaveCmdMode_NONE : _zz_io_bus_cmd_kind_string = "NONE   ";
      Axi4PeripheralI2cSlaveCmdMode_START : _zz_io_bus_cmd_kind_string = "START  ";
      Axi4PeripheralI2cSlaveCmdMode_RESTART : _zz_io_bus_cmd_kind_string = "RESTART";
      Axi4PeripheralI2cSlaveCmdMode_STOP : _zz_io_bus_cmd_kind_string = "STOP   ";
      Axi4PeripheralI2cSlaveCmdMode_DROP : _zz_io_bus_cmd_kind_string = "DROP   ";
      Axi4PeripheralI2cSlaveCmdMode_DRIVE : _zz_io_bus_cmd_kind_string = "DRIVE  ";
      Axi4PeripheralI2cSlaveCmdMode_READ : _zz_io_bus_cmd_kind_string = "READ   ";
      default : _zz_io_bus_cmd_kind_string = "???????";
    endcase
  end
  always @(*) begin
    case(_zz_io_bus_cmd_kind_1)
      Axi4PeripheralI2cSlaveCmdMode_NONE : _zz_io_bus_cmd_kind_1_string = "NONE   ";
      Axi4PeripheralI2cSlaveCmdMode_START : _zz_io_bus_cmd_kind_1_string = "START  ";
      Axi4PeripheralI2cSlaveCmdMode_RESTART : _zz_io_bus_cmd_kind_1_string = "RESTART";
      Axi4PeripheralI2cSlaveCmdMode_STOP : _zz_io_bus_cmd_kind_1_string = "STOP   ";
      Axi4PeripheralI2cSlaveCmdMode_DROP : _zz_io_bus_cmd_kind_1_string = "DROP   ";
      Axi4PeripheralI2cSlaveCmdMode_DRIVE : _zz_io_bus_cmd_kind_1_string = "DRIVE  ";
      Axi4PeripheralI2cSlaveCmdMode_READ : _zz_io_bus_cmd_kind_1_string = "READ   ";
      default : _zz_io_bus_cmd_kind_1_string = "???????";
    endcase
  end
  `endif

  assign filter_timer_tick = (filter_timer_counter == 10'h0);
  assign filter_sampler_sclSync = io_i2c_scl_read_buffercc_io_dataOut;
  assign filter_sampler_sdaSync = io_i2c_sda_read_buffercc_io_dataOut;
  assign _zz_filter_sampler_sclSamples_0 = filter_sampler_sclSync;
  assign filter_sampler_sclSamples_0 = _zz_filter_sampler_sclSamples_0;
  assign filter_sampler_sclSamples_1 = _zz_filter_sampler_sclSamples_1;
  assign filter_sampler_sclSamples_2 = _zz_filter_sampler_sclSamples_2;
  assign _zz_filter_sampler_sdaSamples_0 = filter_sampler_sdaSync;
  assign filter_sampler_sdaSamples_0 = _zz_filter_sampler_sdaSamples_0;
  assign filter_sampler_sdaSamples_1 = _zz_filter_sampler_sdaSamples_1;
  assign filter_sampler_sdaSamples_2 = _zz_filter_sampler_sdaSamples_2;
  assign when_Misc_l82 = (&{(filter_sampler_sdaSamples_2 != filter_sda),{(filter_sampler_sdaSamples_1 != filter_sda),(filter_sampler_sdaSamples_0 != filter_sda)}});
  assign when_Misc_l85 = (&{(filter_sampler_sclSamples_2 != filter_scl),{(filter_sampler_sclSamples_1 != filter_scl),(filter_sampler_sclSamples_0 != filter_scl)}});
  assign sclEdge_rise = ((! filter_scl_regNext) && filter_scl);
  assign sclEdge_fall = (filter_scl_regNext && (! filter_scl));
  assign sclEdge_toggle = (filter_scl_regNext != filter_scl);
  assign sdaEdge_rise = ((! filter_sda_regNext) && filter_sda);
  assign sdaEdge_fall = (filter_sda_regNext && (! filter_sda));
  assign sdaEdge_toggle = (filter_sda_regNext != filter_sda);
  assign detector_start = (filter_scl && sdaEdge_fall);
  assign detector_stop = (filter_scl && sdaEdge_rise);
  assign tsuData_done = (tsuData_counter == 6'h0);
  always @(*) begin
    tsuData_reset = 1'b0;
    if(ctrl_inFrameData) begin
      tsuData_reset = (! ctrl_rspAhead_valid);
    end
  end

  assign when_I2CSlave_l191 = (! tsuData_done);
  always @(*) begin
    ctrl_sdaWrite = 1'b1;
    if(ctrl_inFrameData) begin
      if(when_I2CSlave_l251) begin
        ctrl_sdaWrite = ctrl_rspAhead_payload_data;
      end
    end
  end

  always @(*) begin
    ctrl_sclWrite = 1'b1;
    if(ctrl_inFrameData) begin
      if(when_I2CSlave_l245) begin
        ctrl_sclWrite = 1'b0;
      end
    end
  end

  always @(*) begin
    ctrl_rspBufferIn_ready = ctrl_rspBuffer_ready;
    if(when_Stream_l375) begin
      ctrl_rspBufferIn_ready = 1'b1;
    end
  end

  assign when_Stream_l375 = (! ctrl_rspBuffer_valid);
  assign ctrl_rspBuffer_valid = ctrl_rspBufferIn_rValid;
  assign ctrl_rspBuffer_payload_enable = ctrl_rspBufferIn_rData_enable;
  assign ctrl_rspBuffer_payload_data = ctrl_rspBufferIn_rData_data;
  assign ctrl_rspAhead_valid = (ctrl_rspBuffer_valid ? ctrl_rspBuffer_valid : ctrl_rspBufferIn_valid);
  assign ctrl_rspAhead_payload_enable = (ctrl_rspBuffer_valid ? ctrl_rspBuffer_payload_enable : ctrl_rspBufferIn_payload_enable);
  assign ctrl_rspAhead_payload_data = (ctrl_rspBuffer_valid ? ctrl_rspBuffer_payload_data : ctrl_rspBufferIn_payload_data);
  assign ctrl_rspBufferIn_valid = io_bus_rsp_valid;
  assign ctrl_rspBufferIn_payload_enable = io_bus_rsp_enable;
  assign ctrl_rspBufferIn_payload_data = io_bus_rsp_data;
  always @(*) begin
    ctrl_rspBuffer_ready = 1'b0;
    if(ctrl_inFrame) begin
      if(sclEdge_fall) begin
        ctrl_rspBuffer_ready = 1'b1;
      end
    end
  end

  always @(*) begin
    io_bus_cmd_kind = Axi4PeripheralI2cSlaveCmdMode_NONE;
    if(ctrl_inFrame) begin
      if(sclEdge_rise) begin
        io_bus_cmd_kind = Axi4PeripheralI2cSlaveCmdMode_READ;
      end
    end
    if(ctrl_inFrameData) begin
      if(when_I2CSlave_l241) begin
        io_bus_cmd_kind = Axi4PeripheralI2cSlaveCmdMode_DRIVE;
      end
    end
    if(detector_start) begin
      io_bus_cmd_kind = _zz_io_bus_cmd_kind;
    end
    if(when_I2CSlave_l276) begin
      if(ctrl_inFrame) begin
        io_bus_cmd_kind = _zz_io_bus_cmd_kind_1;
      end
    end
  end

  assign io_bus_cmd_data = filter_sda;
  assign when_I2CSlave_l241 = ((! ctrl_rspBuffer_valid) || ctrl_rspBuffer_ready);
  assign when_I2CSlave_l245 = ((! ctrl_rspAhead_valid) || (ctrl_rspAhead_payload_enable && (! tsuData_done)));
  assign when_I2CSlave_l251 = (ctrl_rspAhead_valid && ctrl_rspAhead_payload_enable);
  assign _zz_io_bus_cmd_kind = (ctrl_inFrame ? Axi4PeripheralI2cSlaveCmdMode_RESTART : Axi4PeripheralI2cSlaveCmdMode_START);
  assign timeout_tick = (timeout_enabled && (timeout_counter == 20'h0));
  assign when_I2CSlave_l270 = (((timeout_tick || sclEdge_toggle) || (((! ctrl_inFrame) && filter_scl) && filter_sda)) || io_config_timeoutClear);
  assign io_timeout = timeout_tick;
  assign when_I2CSlave_l276 = (detector_stop || timeout_tick);
  assign _zz_io_bus_cmd_kind_1 = (timeout_tick ? Axi4PeripheralI2cSlaveCmdMode_DROP : Axi4PeripheralI2cSlaveCmdMode_STOP);
  assign io_internals_inFrame = ctrl_inFrame;
  assign io_internals_sdaRead = filter_sda;
  assign io_internals_sclRead = filter_scl;
  assign io_i2c_scl_write = ctrl_sclWrite;
  assign io_i2c_sda_write = ctrl_sdaWrite;
  always @(posedge clk) begin
    if(reset) begin
      filter_timer_counter <= 10'h0;
      _zz_filter_sampler_sclSamples_1 <= 1'b1;
      _zz_filter_sampler_sclSamples_2 <= 1'b1;
      _zz_filter_sampler_sdaSamples_1 <= 1'b1;
      _zz_filter_sampler_sdaSamples_2 <= 1'b1;
      filter_sda <= 1'b1;
      filter_scl <= 1'b1;
      filter_scl_regNext <= 1'b1;
      filter_sda_regNext <= 1'b1;
      tsuData_counter <= 6'h0;
      ctrl_inFrame <= 1'b0;
      ctrl_inFrameData <= 1'b0;
      ctrl_rspBufferIn_rValid <= 1'b0;
      timeout_counter <= 20'h0;
    end else begin
      filter_timer_counter <= (filter_timer_counter - 10'h001);
      if(filter_timer_tick) begin
        filter_timer_counter <= io_config_samplingClockDivider;
      end
      if(filter_timer_tick) begin
        _zz_filter_sampler_sclSamples_1 <= _zz_filter_sampler_sclSamples_0;
      end
      if(filter_timer_tick) begin
        _zz_filter_sampler_sclSamples_2 <= _zz_filter_sampler_sclSamples_1;
      end
      if(filter_timer_tick) begin
        _zz_filter_sampler_sdaSamples_1 <= _zz_filter_sampler_sdaSamples_0;
      end
      if(filter_timer_tick) begin
        _zz_filter_sampler_sdaSamples_2 <= _zz_filter_sampler_sdaSamples_1;
      end
      if(filter_timer_tick) begin
        if(when_Misc_l82) begin
          filter_sda <= filter_sampler_sdaSamples_2;
        end
        if(when_Misc_l85) begin
          filter_scl <= filter_sampler_sclSamples_2;
        end
      end
      filter_scl_regNext <= filter_scl;
      filter_sda_regNext <= filter_sda;
      if(when_I2CSlave_l191) begin
        tsuData_counter <= (tsuData_counter - 6'h01);
      end
      if(tsuData_reset) begin
        tsuData_counter <= io_config_tsuData;
      end
      if(ctrl_rspBufferIn_ready) begin
        ctrl_rspBufferIn_rValid <= ctrl_rspBufferIn_valid;
      end
      if(ctrl_inFrame) begin
        if(sclEdge_fall) begin
          ctrl_inFrameData <= 1'b1;
        end
      end
      if(detector_start) begin
        ctrl_inFrame <= 1'b1;
        ctrl_inFrameData <= 1'b0;
      end
      timeout_counter <= (timeout_counter - 20'h00001);
      if(when_I2CSlave_l270) begin
        timeout_counter <= io_config_timeout;
      end
      if(when_I2CSlave_l276) begin
        ctrl_inFrame <= 1'b0;
        ctrl_inFrameData <= 1'b0;
      end
    end
  end

  always @(posedge clk) begin
    if(ctrl_rspBufferIn_ready) begin
      ctrl_rspBufferIn_rData_enable <= ctrl_rspBufferIn_payload_enable;
      ctrl_rspBufferIn_rData_data <= ctrl_rspBufferIn_payload_data;
    end
    timeout_enabled <= (io_config_timeout != 20'h0);
  end


endmodule

module Axi4PeripheralStreamFifo_3 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [7:0]    io_push_payload_data,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [7:0]    io_pop_payload_data,
  input  wire          io_flush,
  output wire [8:0]    io_occupancy,
  output wire [8:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  reg        [7:0]    logic_ram_spinal_port1;
  reg                 _zz_1;
  wire                logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [8:0]    logic_ptr_push;
  reg        [8:0]    logic_ptr_pop;
  wire       [8:0]    logic_ptr_occupancy;
  wire       [8:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1248;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [7:0]    logic_push_onRam_write_payload_address;
  wire       [7:0]    logic_push_onRam_write_payload_data_data;
  wire                logic_pop_addressGen_valid;
  reg                 logic_pop_addressGen_ready;
  wire       [7:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_sync_readArbitation_valid;
  wire                logic_pop_sync_readArbitation_ready;
  wire       [7:0]    logic_pop_sync_readArbitation_payload;
  reg                 logic_pop_addressGen_rValid;
  reg        [7:0]    logic_pop_addressGen_rData;
  wire                when_Stream_l375;
  wire                logic_pop_sync_readPort_cmd_valid;
  wire       [7:0]    logic_pop_sync_readPort_cmd_payload;
  wire       [7:0]    logic_pop_sync_readPort_rsp_data;
  wire                logic_pop_sync_readArbitation_translated_valid;
  wire                logic_pop_sync_readArbitation_translated_ready;
  wire       [7:0]    logic_pop_sync_readArbitation_translated_payload_data;
  wire                logic_pop_sync_readArbitation_fire;
  reg        [8:0]    logic_pop_sync_popReg;
  reg [7:0] logic_ram [0:255];

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= logic_push_onRam_write_payload_data_data;
    end
  end

  always @(posedge clk) begin
    if(logic_pop_sync_readPort_cmd_valid) begin
      logic_ram_spinal_port1 <= logic_ram[logic_pop_sync_readPort_cmd_payload];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1248 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 9'h100) == 9'h0);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign logic_ptr_doPush = io_push_fire;
  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[7:0];
  assign logic_push_onRam_write_payload_data_data = io_push_payload_data;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[7:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  always @(*) begin
    logic_pop_addressGen_ready = logic_pop_sync_readArbitation_ready;
    if(when_Stream_l375) begin
      logic_pop_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l375 = (! logic_pop_sync_readArbitation_valid);
  assign logic_pop_sync_readArbitation_valid = logic_pop_addressGen_rValid;
  assign logic_pop_sync_readArbitation_payload = logic_pop_addressGen_rData;
  assign logic_pop_sync_readPort_rsp_data = logic_ram_spinal_port1[7 : 0];
  assign logic_pop_sync_readPort_cmd_valid = logic_pop_addressGen_fire;
  assign logic_pop_sync_readPort_cmd_payload = logic_pop_addressGen_payload;
  assign logic_pop_sync_readArbitation_translated_valid = logic_pop_sync_readArbitation_valid;
  assign logic_pop_sync_readArbitation_ready = logic_pop_sync_readArbitation_translated_ready;
  assign logic_pop_sync_readArbitation_translated_payload_data = logic_pop_sync_readPort_rsp_data;
  assign io_pop_valid = logic_pop_sync_readArbitation_translated_valid;
  assign logic_pop_sync_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload_data = logic_pop_sync_readArbitation_translated_payload_data;
  assign logic_pop_sync_readArbitation_fire = (logic_pop_sync_readArbitation_valid && logic_pop_sync_readArbitation_ready);
  assign logic_ptr_popOnIo = logic_pop_sync_popReg;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (9'h100 - logic_ptr_occupancy);
  always @(posedge clk) begin
    if(reset) begin
      logic_ptr_push <= 9'h0;
      logic_ptr_pop <= 9'h0;
      logic_ptr_wentUp <= 1'b0;
      logic_pop_addressGen_rValid <= 1'b0;
      logic_pop_sync_popReg <= 9'h0;
    end else begin
      if(when_Stream_l1248) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 9'h001);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 9'h001);
      end
      if(io_flush) begin
        logic_ptr_push <= 9'h0;
        logic_ptr_pop <= 9'h0;
      end
      if(logic_pop_addressGen_ready) begin
        logic_pop_addressGen_rValid <= logic_pop_addressGen_valid;
      end
      if(io_flush) begin
        logic_pop_addressGen_rValid <= 1'b0;
      end
      if(logic_pop_sync_readArbitation_fire) begin
        logic_pop_sync_popReg <= logic_ptr_pop;
      end
      if(io_flush) begin
        logic_pop_sync_popReg <= 9'h0;
      end
    end
  end

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule

module Axi4PeripheralStreamFifo_2 (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire          io_push_payload_kind,
  input  wire          io_push_payload_read,
  input  wire          io_push_payload_write,
  input  wire [7:0]    io_push_payload_data,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire          io_pop_payload_kind,
  output wire          io_pop_payload_read,
  output wire          io_pop_payload_write,
  output wire [7:0]    io_pop_payload_data,
  input  wire          io_flush,
  output wire [8:0]    io_occupancy,
  output wire [8:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  reg        [10:0]   logic_ram_spinal_port1;
  wire       [10:0]   _zz_logic_ram_port;
  reg                 _zz_1;
  wire                logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [8:0]    logic_ptr_push;
  reg        [8:0]    logic_ptr_pop;
  wire       [8:0]    logic_ptr_occupancy;
  wire       [8:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1248;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [7:0]    logic_push_onRam_write_payload_address;
  wire                logic_push_onRam_write_payload_data_kind;
  wire                logic_push_onRam_write_payload_data_read;
  wire                logic_push_onRam_write_payload_data_write;
  wire       [7:0]    logic_push_onRam_write_payload_data_data;
  wire                logic_pop_addressGen_valid;
  reg                 logic_pop_addressGen_ready;
  wire       [7:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_sync_readArbitation_valid;
  wire                logic_pop_sync_readArbitation_ready;
  wire       [7:0]    logic_pop_sync_readArbitation_payload;
  reg                 logic_pop_addressGen_rValid;
  reg        [7:0]    logic_pop_addressGen_rData;
  wire                when_Stream_l375;
  wire                logic_pop_sync_readPort_cmd_valid;
  wire       [7:0]    logic_pop_sync_readPort_cmd_payload;
  wire                logic_pop_sync_readPort_rsp_kind;
  wire                logic_pop_sync_readPort_rsp_read;
  wire                logic_pop_sync_readPort_rsp_write;
  wire       [7:0]    logic_pop_sync_readPort_rsp_data;
  wire       [10:0]   _zz_logic_pop_sync_readPort_rsp_kind;
  wire                logic_pop_sync_readArbitation_translated_valid;
  wire                logic_pop_sync_readArbitation_translated_ready;
  wire                logic_pop_sync_readArbitation_translated_payload_kind;
  wire                logic_pop_sync_readArbitation_translated_payload_read;
  wire                logic_pop_sync_readArbitation_translated_payload_write;
  wire       [7:0]    logic_pop_sync_readArbitation_translated_payload_data;
  wire                logic_pop_sync_readArbitation_fire;
  reg        [8:0]    logic_pop_sync_popReg;
  reg [10:0] logic_ram [0:255];

  assign _zz_logic_ram_port = {logic_push_onRam_write_payload_data_data,{logic_push_onRam_write_payload_data_write,{logic_push_onRam_write_payload_data_read,logic_push_onRam_write_payload_data_kind}}};
  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= _zz_logic_ram_port;
    end
  end

  always @(posedge clk) begin
    if(logic_pop_sync_readPort_cmd_valid) begin
      logic_ram_spinal_port1 <= logic_ram[logic_pop_sync_readPort_cmd_payload];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1248 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 9'h100) == 9'h0);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign logic_ptr_doPush = io_push_fire;
  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[7:0];
  assign logic_push_onRam_write_payload_data_kind = io_push_payload_kind;
  assign logic_push_onRam_write_payload_data_read = io_push_payload_read;
  assign logic_push_onRam_write_payload_data_write = io_push_payload_write;
  assign logic_push_onRam_write_payload_data_data = io_push_payload_data;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[7:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  always @(*) begin
    logic_pop_addressGen_ready = logic_pop_sync_readArbitation_ready;
    if(when_Stream_l375) begin
      logic_pop_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l375 = (! logic_pop_sync_readArbitation_valid);
  assign logic_pop_sync_readArbitation_valid = logic_pop_addressGen_rValid;
  assign logic_pop_sync_readArbitation_payload = logic_pop_addressGen_rData;
  assign _zz_logic_pop_sync_readPort_rsp_kind = logic_ram_spinal_port1;
  assign logic_pop_sync_readPort_rsp_kind = _zz_logic_pop_sync_readPort_rsp_kind[0];
  assign logic_pop_sync_readPort_rsp_read = _zz_logic_pop_sync_readPort_rsp_kind[1];
  assign logic_pop_sync_readPort_rsp_write = _zz_logic_pop_sync_readPort_rsp_kind[2];
  assign logic_pop_sync_readPort_rsp_data = _zz_logic_pop_sync_readPort_rsp_kind[10 : 3];
  assign logic_pop_sync_readPort_cmd_valid = logic_pop_addressGen_fire;
  assign logic_pop_sync_readPort_cmd_payload = logic_pop_addressGen_payload;
  assign logic_pop_sync_readArbitation_translated_valid = logic_pop_sync_readArbitation_valid;
  assign logic_pop_sync_readArbitation_ready = logic_pop_sync_readArbitation_translated_ready;
  assign logic_pop_sync_readArbitation_translated_payload_kind = logic_pop_sync_readPort_rsp_kind;
  assign logic_pop_sync_readArbitation_translated_payload_read = logic_pop_sync_readPort_rsp_read;
  assign logic_pop_sync_readArbitation_translated_payload_write = logic_pop_sync_readPort_rsp_write;
  assign logic_pop_sync_readArbitation_translated_payload_data = logic_pop_sync_readPort_rsp_data;
  assign io_pop_valid = logic_pop_sync_readArbitation_translated_valid;
  assign logic_pop_sync_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload_kind = logic_pop_sync_readArbitation_translated_payload_kind;
  assign io_pop_payload_read = logic_pop_sync_readArbitation_translated_payload_read;
  assign io_pop_payload_write = logic_pop_sync_readArbitation_translated_payload_write;
  assign io_pop_payload_data = logic_pop_sync_readArbitation_translated_payload_data;
  assign logic_pop_sync_readArbitation_fire = (logic_pop_sync_readArbitation_valid && logic_pop_sync_readArbitation_ready);
  assign logic_ptr_popOnIo = logic_pop_sync_popReg;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (9'h100 - logic_ptr_occupancy);
  always @(posedge clk) begin
    if(reset) begin
      logic_ptr_push <= 9'h0;
      logic_ptr_pop <= 9'h0;
      logic_ptr_wentUp <= 1'b0;
      logic_pop_addressGen_rValid <= 1'b0;
      logic_pop_sync_popReg <= 9'h0;
    end else begin
      if(when_Stream_l1248) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 9'h001);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 9'h001);
      end
      if(io_flush) begin
        logic_ptr_push <= 9'h0;
        logic_ptr_pop <= 9'h0;
      end
      if(logic_pop_addressGen_ready) begin
        logic_pop_addressGen_rValid <= logic_pop_addressGen_valid;
      end
      if(io_flush) begin
        logic_pop_addressGen_rValid <= 1'b0;
      end
      if(logic_pop_sync_readArbitation_fire) begin
        logic_pop_sync_popReg <= logic_ptr_pop;
      end
      if(io_flush) begin
        logic_pop_sync_popReg <= 9'h0;
      end
    end
  end

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule

module Axi4PeripheralTopLevel (
  input  wire          io_config_kind_cpol,
  input  wire          io_config_kind_cpha,
  input  wire [11:0]   io_config_sclkToggle,
  input  wire [1:0]    io_config_mod,
  input  wire [3:0]    io_config_ss_activeHigh,
  input  wire [11:0]   io_config_ss_setup,
  input  wire [11:0]   io_config_ss_hold,
  input  wire [11:0]   io_config_ss_disable,
  input  wire          io_cmd_valid,
  output reg           io_cmd_ready,
  input  wire          io_cmd_payload_kind,
  input  wire          io_cmd_payload_read,
  input  wire          io_cmd_payload_write,
  input  wire [7:0]    io_cmd_payload_data,
  output wire          io_rsp_valid,
  output wire [7:0]    io_rsp_payload_data,
  output wire [0:0]    io_spi_sclk_write,
  output reg           io_spi_data_0_writeEnable,
  input  wire [0:0]    io_spi_data_0_read,
  output reg  [0:0]    io_spi_data_0_write,
  output reg           io_spi_data_1_writeEnable,
  input  wire [0:0]    io_spi_data_1_read,
  output reg  [0:0]    io_spi_data_1_write,
  output reg           io_spi_data_2_writeEnable,
  input  wire [0:0]    io_spi_data_2_read,
  output reg  [0:0]    io_spi_data_2_write,
  output reg           io_spi_data_3_writeEnable,
  input  wire [0:0]    io_spi_data_3_read,
  output reg  [0:0]    io_spi_data_3_write,
  output wire [3:0]    io_spi_ss,
  input  wire          clk,
  input  wire          reset
);

  reg        [0:0]    _zz_outputPhy_dataWrite_3;
  wire       [2:0]    _zz_outputPhy_dataWrite_4;
  reg        [1:0]    _zz_outputPhy_dataWrite_5;
  wire       [1:0]    _zz_outputPhy_dataWrite_6;
  wire       [2:0]    _zz_outputPhy_dataWrite_7;
  reg        [3:0]    _zz_outputPhy_dataWrite_8;
  wire       [0:0]    _zz_outputPhy_dataWrite_9;
  wire       [2:0]    _zz_outputPhy_dataWrite_10;
  wire       [3:0]    _zz_inputPhy_dataRead;
  wire       [3:0]    _zz_inputPhy_dataRead_1;
  wire       [3:0]    _zz_inputPhy_dataRead_2;
  wire       [3:0]    _zz_inputPhy_dataRead_3;
  wire       [3:0]    _zz_inputPhy_dataRead_4;
  wire       [3:0]    _zz_inputPhy_dataRead_5;
  wire       [3:0]    _zz_inputPhy_dataRead_6;
  wire       [8:0]    _zz_inputPhy_bufferNext;
  wire       [10:0]   _zz_inputPhy_bufferNext_1;
  reg        [11:0]   timer_counter;
  reg                 timer_reset;
  wire                timer_ss_setupHit;
  wire                timer_ss_holdHit;
  wire                timer_ss_disableHit;
  wire                timer_sclkToggleHit;
  reg                 fsm_state;
  reg        [2:0]    fsm_counter;
  reg        [2:0]    _zz_fsm_counterPlus;
  wire       [2:0]    fsm_counterPlus;
  reg                 fsm_fastRate;
  reg                 fsm_isDdr;
  reg        [2:0]    fsm_counterMax;
  reg                 fsm_lateSampling;
  reg                 fsm_readFill;
  reg                 fsm_readDone;
  reg        [3:0]    fsm_ss;
  wire                when_SpiXdrMasterCtrl_l741;
  wire                when_SpiXdrMasterCtrl_l744;
  wire                when_SpiXdrMasterCtrl_l751;
  wire                when_SpiXdrMasterCtrl_l753;
  wire                when_SpiXdrMasterCtrl_l760;
  wire                when_SpiXdrMasterCtrl_l766;
  wire                when_SpiXdrMasterCtrl_l783;
  reg        [0:0]    outputPhy_sclkWrite;
  wire       [0:0]    _zz_io_spi_sclk_write;
  wire                when_SpiXdrMasterCtrl_l798;
  reg        [3:0]    outputPhy_dataWrite;
  reg        [2:0]    outputPhy_widthSel;
  reg        [2:0]    outputPhy_offset;
  wire       [7:0]    _zz_outputPhy_dataWrite;
  wire       [7:0]    _zz_outputPhy_dataWrite_1;
  wire       [7:0]    _zz_outputPhy_dataWrite_2;
  wire                when_SpiXdrMasterCtrl_l841;
  wire                when_SpiXdrMasterCtrl_l841_1;
  reg        [1:0]    io_config_mod_delay_1;
  reg        [1:0]    inputPhy_mod;
  reg                 fsm_readFill_delay_1;
  reg                 inputPhy_readFill;
  reg                 fsm_readDone_delay_1;
  reg                 inputPhy_readDone;
  reg        [6:0]    inputPhy_buffer;
  reg        [7:0]    inputPhy_bufferNext;
  reg        [2:0]    inputPhy_widthSel;
  wire       [3:0]    inputPhy_dataWrite;
  reg        [3:0]    inputPhy_dataRead;
  reg                 fsm_state_delay_1;
  reg                 fsm_state_delay_2;
  wire                when_SpiXdrMasterCtrl_l863;
  reg        [3:0]    inputPhy_dataReadBuffer;

  assign _zz_outputPhy_dataWrite_4 = (outputPhy_offset - fsm_counter);
  assign _zz_outputPhy_dataWrite_6 = (_zz_outputPhy_dataWrite_7 >>> 1'd1);
  assign _zz_outputPhy_dataWrite_7 = (outputPhy_offset - fsm_counter);
  assign _zz_outputPhy_dataWrite_9 = (_zz_outputPhy_dataWrite_10 >>> 2'd2);
  assign _zz_outputPhy_dataWrite_10 = (outputPhy_offset - fsm_counter);
  assign _zz_inputPhy_dataRead = {io_spi_data_3_read[0],{io_spi_data_2_read[0],{io_spi_data_1_read[0],io_spi_data_0_read[0]}}};
  assign _zz_inputPhy_dataRead_1 = {io_spi_data_3_read[0],{io_spi_data_2_read[0],{io_spi_data_1_read[0],io_spi_data_0_read[0]}}};
  assign _zz_inputPhy_dataRead_2 = {io_spi_data_3_read[0],{io_spi_data_2_read[0],{io_spi_data_1_read[0],io_spi_data_0_read[0]}}};
  assign _zz_inputPhy_dataRead_3 = {io_spi_data_3_read[0],{io_spi_data_2_read[0],{io_spi_data_1_read[0],io_spi_data_0_read[0]}}};
  assign _zz_inputPhy_dataRead_4 = {io_spi_data_3_read[0],{io_spi_data_2_read[0],{io_spi_data_1_read[0],io_spi_data_0_read[0]}}};
  assign _zz_inputPhy_dataRead_5 = {io_spi_data_3_read[0],{io_spi_data_2_read[0],{io_spi_data_1_read[0],io_spi_data_0_read[0]}}};
  assign _zz_inputPhy_dataRead_6 = {io_spi_data_3_read[0],{io_spi_data_2_read[0],{io_spi_data_1_read[0],io_spi_data_0_read[0]}}};
  assign _zz_inputPhy_bufferNext = {inputPhy_buffer,inputPhy_dataRead[1 : 0]};
  assign _zz_inputPhy_bufferNext_1 = {inputPhy_buffer,inputPhy_dataRead[3 : 0]};
  always @(*) begin
    case(_zz_outputPhy_dataWrite_4)
      3'b000 : _zz_outputPhy_dataWrite_3 = _zz_outputPhy_dataWrite[0 : 0];
      3'b001 : _zz_outputPhy_dataWrite_3 = _zz_outputPhy_dataWrite[1 : 1];
      3'b010 : _zz_outputPhy_dataWrite_3 = _zz_outputPhy_dataWrite[2 : 2];
      3'b011 : _zz_outputPhy_dataWrite_3 = _zz_outputPhy_dataWrite[3 : 3];
      3'b100 : _zz_outputPhy_dataWrite_3 = _zz_outputPhy_dataWrite[4 : 4];
      3'b101 : _zz_outputPhy_dataWrite_3 = _zz_outputPhy_dataWrite[5 : 5];
      3'b110 : _zz_outputPhy_dataWrite_3 = _zz_outputPhy_dataWrite[6 : 6];
      default : _zz_outputPhy_dataWrite_3 = _zz_outputPhy_dataWrite[7 : 7];
    endcase
  end

  always @(*) begin
    case(_zz_outputPhy_dataWrite_6)
      2'b00 : _zz_outputPhy_dataWrite_5 = _zz_outputPhy_dataWrite_1[1 : 0];
      2'b01 : _zz_outputPhy_dataWrite_5 = _zz_outputPhy_dataWrite_1[3 : 2];
      2'b10 : _zz_outputPhy_dataWrite_5 = _zz_outputPhy_dataWrite_1[5 : 4];
      default : _zz_outputPhy_dataWrite_5 = _zz_outputPhy_dataWrite_1[7 : 6];
    endcase
  end

  always @(*) begin
    case(_zz_outputPhy_dataWrite_9)
      1'b0 : _zz_outputPhy_dataWrite_8 = _zz_outputPhy_dataWrite_2[3 : 0];
      default : _zz_outputPhy_dataWrite_8 = _zz_outputPhy_dataWrite_2[7 : 4];
    endcase
  end

  always @(*) begin
    timer_reset = 1'b0;
    if(io_cmd_valid) begin
      if(when_SpiXdrMasterCtrl_l741) begin
        timer_reset = timer_sclkToggleHit;
      end else begin
        if(!when_SpiXdrMasterCtrl_l760) begin
          if(when_SpiXdrMasterCtrl_l766) begin
            if(timer_ss_holdHit) begin
              timer_reset = 1'b1;
            end
          end
        end
      end
    end
    if(when_SpiXdrMasterCtrl_l783) begin
      timer_reset = 1'b1;
    end
  end

  assign timer_ss_setupHit = (timer_counter == io_config_ss_setup);
  assign timer_ss_holdHit = (timer_counter == io_config_ss_hold);
  assign timer_ss_disableHit = (timer_counter == io_config_ss_disable);
  assign timer_sclkToggleHit = (timer_counter == io_config_sclkToggle);
  always @(*) begin
    _zz_fsm_counterPlus = 3'bxxx;
    case(io_config_mod)
      2'b00 : begin
        _zz_fsm_counterPlus = 3'b001;
      end
      2'b01 : begin
        _zz_fsm_counterPlus = 3'b010;
      end
      2'b10 : begin
        _zz_fsm_counterPlus = 3'b100;
      end
      default : begin
      end
    endcase
  end

  assign fsm_counterPlus = (fsm_counter + _zz_fsm_counterPlus);
  always @(*) begin
    fsm_fastRate = 1'bx;
    case(io_config_mod)
      2'b00 : begin
        fsm_fastRate = 1'b0;
      end
      2'b01 : begin
        fsm_fastRate = 1'b0;
      end
      2'b10 : begin
        fsm_fastRate = 1'b0;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    fsm_isDdr = 1'bx;
    case(io_config_mod)
      2'b00 : begin
        fsm_isDdr = 1'b0;
      end
      2'b01 : begin
        fsm_isDdr = 1'b0;
      end
      2'b10 : begin
        fsm_isDdr = 1'b0;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    fsm_counterMax = 3'bxxx;
    case(io_config_mod)
      2'b00 : begin
        fsm_counterMax = 3'b111;
      end
      2'b01 : begin
        fsm_counterMax = 3'b110;
      end
      2'b10 : begin
        fsm_counterMax = 3'b100;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    fsm_lateSampling = 1'bx;
    case(io_config_mod)
      2'b00 : begin
        fsm_lateSampling = 1'b1;
      end
      2'b01 : begin
        fsm_lateSampling = 1'b1;
      end
      2'b10 : begin
        fsm_lateSampling = 1'b1;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    fsm_readFill = 1'b0;
    if(io_cmd_valid) begin
      if(when_SpiXdrMasterCtrl_l741) begin
        if(when_SpiXdrMasterCtrl_l744) begin
          fsm_readFill = 1'b1;
        end
      end
    end
  end

  always @(*) begin
    fsm_readDone = 1'b0;
    if(io_cmd_valid) begin
      if(when_SpiXdrMasterCtrl_l741) begin
        if(when_SpiXdrMasterCtrl_l744) begin
          fsm_readDone = (io_cmd_payload_read && (fsm_counter == fsm_counterMax));
        end
      end
    end
  end

  assign io_spi_ss = (~ (fsm_ss ^ io_config_ss_activeHigh));
  always @(*) begin
    io_cmd_ready = 1'b0;
    if(io_cmd_valid) begin
      if(when_SpiXdrMasterCtrl_l741) begin
        if(when_SpiXdrMasterCtrl_l751) begin
          if(when_SpiXdrMasterCtrl_l753) begin
            io_cmd_ready = 1'b1;
          end
        end
      end else begin
        if(when_SpiXdrMasterCtrl_l760) begin
          if(timer_ss_setupHit) begin
            io_cmd_ready = 1'b1;
          end
        end else begin
          if(!when_SpiXdrMasterCtrl_l766) begin
            if(timer_ss_disableHit) begin
              io_cmd_ready = 1'b1;
            end
          end
        end
      end
    end
  end

  assign when_SpiXdrMasterCtrl_l741 = (! io_cmd_payload_kind);
  assign when_SpiXdrMasterCtrl_l744 = ((timer_sclkToggleHit && (((! fsm_state) ^ fsm_lateSampling) || fsm_isDdr)) || fsm_fastRate);
  assign when_SpiXdrMasterCtrl_l751 = ((timer_sclkToggleHit && (fsm_state || fsm_isDdr)) || fsm_fastRate);
  assign when_SpiXdrMasterCtrl_l753 = (fsm_counter == fsm_counterMax);
  assign when_SpiXdrMasterCtrl_l760 = io_cmd_payload_data[7];
  assign when_SpiXdrMasterCtrl_l766 = (! fsm_state);
  assign when_SpiXdrMasterCtrl_l783 = ((! io_cmd_valid) || io_cmd_ready);
  always @(*) begin
    outputPhy_sclkWrite = 1'b0;
    if(when_SpiXdrMasterCtrl_l798) begin
      case(io_config_mod)
        2'b00 : begin
          outputPhy_sclkWrite = ((fsm_state ^ io_config_kind_cpha) ? 1'b1 : 1'b0);
        end
        2'b01 : begin
          outputPhy_sclkWrite = ((fsm_state ^ io_config_kind_cpha) ? 1'b1 : 1'b0);
        end
        2'b10 : begin
          outputPhy_sclkWrite = ((fsm_state ^ io_config_kind_cpha) ? 1'b1 : 1'b0);
        end
        default : begin
        end
      endcase
    end
  end

  assign _zz_io_spi_sclk_write[0] = io_config_kind_cpol;
  assign io_spi_sclk_write = (outputPhy_sclkWrite ^ _zz_io_spi_sclk_write);
  assign when_SpiXdrMasterCtrl_l798 = (io_cmd_valid && (! io_cmd_payload_kind));
  always @(*) begin
    outputPhy_widthSel = 3'bxxx;
    case(io_config_mod)
      2'b00 : begin
        outputPhy_widthSel = 3'b000;
      end
      2'b01 : begin
        outputPhy_widthSel = 3'b001;
      end
      2'b10 : begin
        outputPhy_widthSel = 3'b010;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    outputPhy_offset = 3'bxxx;
    case(io_config_mod)
      2'b00 : begin
        outputPhy_offset = 3'b111;
      end
      2'b01 : begin
        outputPhy_offset = 3'b111;
      end
      2'b10 : begin
        outputPhy_offset = 3'b111;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    outputPhy_dataWrite = 4'bxxxx;
    case(outputPhy_widthSel)
      3'b000 : begin
        outputPhy_dataWrite[0 : 0] = _zz_outputPhy_dataWrite_3;
      end
      3'b001 : begin
        outputPhy_dataWrite[1 : 0] = _zz_outputPhy_dataWrite_5;
      end
      3'b010 : begin
        outputPhy_dataWrite[3 : 0] = _zz_outputPhy_dataWrite_8;
      end
      default : begin
      end
    endcase
  end

  assign _zz_outputPhy_dataWrite = io_cmd_payload_data;
  assign _zz_outputPhy_dataWrite_1 = io_cmd_payload_data;
  assign _zz_outputPhy_dataWrite_2 = io_cmd_payload_data;
  always @(*) begin
    io_spi_data_0_writeEnable = 1'b0;
    case(io_config_mod)
      2'b00 : begin
        io_spi_data_0_writeEnable = 1'b1;
      end
      2'b01 : begin
        if(when_SpiXdrMasterCtrl_l841) begin
          io_spi_data_0_writeEnable = 1'b1;
        end
      end
      2'b10 : begin
        if(when_SpiXdrMasterCtrl_l841_1) begin
          io_spi_data_0_writeEnable = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_spi_data_1_writeEnable = 1'b0;
    case(io_config_mod)
      2'b01 : begin
        if(when_SpiXdrMasterCtrl_l841) begin
          io_spi_data_1_writeEnable = 1'b1;
        end
      end
      2'b10 : begin
        if(when_SpiXdrMasterCtrl_l841_1) begin
          io_spi_data_1_writeEnable = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_spi_data_2_writeEnable = 1'b0;
    case(io_config_mod)
      2'b10 : begin
        if(when_SpiXdrMasterCtrl_l841_1) begin
          io_spi_data_2_writeEnable = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_spi_data_3_writeEnable = 1'b0;
    case(io_config_mod)
      2'b10 : begin
        if(when_SpiXdrMasterCtrl_l841_1) begin
          io_spi_data_3_writeEnable = 1'b1;
        end
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_spi_data_0_write = 1'bx;
    case(io_config_mod)
      2'b00 : begin
        io_spi_data_0_write[0] = (outputPhy_dataWrite[0] || (! (io_cmd_valid && io_cmd_payload_write)));
      end
      2'b01 : begin
        io_spi_data_0_write[0] = outputPhy_dataWrite[0];
      end
      2'b10 : begin
        io_spi_data_0_write[0] = outputPhy_dataWrite[0];
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_spi_data_1_write = 1'bx;
    case(io_config_mod)
      2'b01 : begin
        io_spi_data_1_write[0] = outputPhy_dataWrite[1];
      end
      2'b10 : begin
        io_spi_data_1_write[0] = outputPhy_dataWrite[1];
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_spi_data_2_write = 1'bx;
    case(io_config_mod)
      2'b10 : begin
        io_spi_data_2_write[0] = outputPhy_dataWrite[2];
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_spi_data_3_write = 1'bx;
    case(io_config_mod)
      2'b10 : begin
        io_spi_data_3_write[0] = outputPhy_dataWrite[3];
      end
      default : begin
      end
    endcase
  end

  assign when_SpiXdrMasterCtrl_l841 = (io_cmd_valid && io_cmd_payload_write);
  assign when_SpiXdrMasterCtrl_l841_1 = (io_cmd_valid && io_cmd_payload_write);
  always @(*) begin
    inputPhy_bufferNext = 8'bxxxxxxxx;
    case(inputPhy_widthSel)
      3'b000 : begin
        inputPhy_bufferNext = {inputPhy_buffer,inputPhy_dataRead[0 : 0]};
      end
      3'b001 : begin
        inputPhy_bufferNext = _zz_inputPhy_bufferNext[7:0];
      end
      3'b010 : begin
        inputPhy_bufferNext = _zz_inputPhy_bufferNext_1[7:0];
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    inputPhy_widthSel = 3'bxxx;
    case(inputPhy_mod)
      2'b00 : begin
        inputPhy_widthSel = 3'b000;
      end
      2'b01 : begin
        inputPhy_widthSel = 3'b001;
      end
      2'b10 : begin
        inputPhy_widthSel = 3'b010;
      end
      default : begin
      end
    endcase
  end

  assign when_SpiXdrMasterCtrl_l863 = (! fsm_state_delay_2);
  always @(*) begin
    inputPhy_dataRead = 4'bxxxx;
    case(inputPhy_mod)
      2'b00 : begin
        inputPhy_dataRead[0] = _zz_inputPhy_dataRead[1];
      end
      2'b01 : begin
        inputPhy_dataRead[0] = _zz_inputPhy_dataRead_1[0];
        inputPhy_dataRead[1] = _zz_inputPhy_dataRead_2[1];
      end
      2'b10 : begin
        inputPhy_dataRead[0] = _zz_inputPhy_dataRead_3[0];
        inputPhy_dataRead[1] = _zz_inputPhy_dataRead_4[1];
        inputPhy_dataRead[2] = _zz_inputPhy_dataRead_5[2];
        inputPhy_dataRead[3] = _zz_inputPhy_dataRead_6[3];
      end
      default : begin
      end
    endcase
  end

  assign io_rsp_valid = inputPhy_readDone;
  assign io_rsp_payload_data = inputPhy_bufferNext;
  always @(posedge clk) begin
    timer_counter <= (timer_counter + 12'h001);
    if(timer_reset) begin
      timer_counter <= 12'h0;
    end
    io_config_mod_delay_1 <= io_config_mod;
    inputPhy_mod <= io_config_mod_delay_1;
    fsm_state_delay_1 <= fsm_state;
    fsm_state_delay_2 <= fsm_state_delay_1;
    if(when_SpiXdrMasterCtrl_l863) begin
      inputPhy_dataReadBuffer <= {io_spi_data_3_read[0],{io_spi_data_2_read[0],{io_spi_data_1_read[0],io_spi_data_0_read[0]}}};
    end
    case(inputPhy_widthSel)
      3'b000 : begin
        if(inputPhy_readFill) begin
          inputPhy_buffer <= inputPhy_bufferNext[6:0];
        end
      end
      3'b001 : begin
        if(inputPhy_readFill) begin
          inputPhy_buffer <= inputPhy_bufferNext[6:0];
        end
      end
      3'b010 : begin
        if(inputPhy_readFill) begin
          inputPhy_buffer <= inputPhy_bufferNext[6:0];
        end
      end
      default : begin
      end
    endcase
  end

  always @(posedge clk) begin
    if(reset) begin
      fsm_state <= 1'b0;
      fsm_counter <= 3'b000;
      fsm_ss <= 4'b0000;
      fsm_readFill_delay_1 <= 1'b0;
      inputPhy_readFill <= 1'b0;
      fsm_readDone_delay_1 <= 1'b0;
      inputPhy_readDone <= 1'b0;
    end else begin
      if(io_cmd_valid) begin
        if(when_SpiXdrMasterCtrl_l741) begin
          if(timer_sclkToggleHit) begin
            fsm_state <= (! fsm_state);
          end
          if(when_SpiXdrMasterCtrl_l751) begin
            fsm_counter <= fsm_counterPlus;
            if(when_SpiXdrMasterCtrl_l753) begin
              fsm_state <= 1'b0;
            end
          end
        end else begin
          if(when_SpiXdrMasterCtrl_l760) begin
            fsm_ss[io_cmd_payload_data[1 : 0]] <= 1'b1;
          end else begin
            if(when_SpiXdrMasterCtrl_l766) begin
              if(timer_ss_holdHit) begin
                fsm_state <= 1'b1;
              end
            end else begin
              fsm_ss[io_cmd_payload_data[1 : 0]] <= 1'b0;
            end
          end
        end
      end
      if(when_SpiXdrMasterCtrl_l783) begin
        fsm_state <= 1'b0;
        fsm_counter <= 3'b000;
      end
      fsm_readFill_delay_1 <= fsm_readFill;
      inputPhy_readFill <= fsm_readFill_delay_1;
      fsm_readDone_delay_1 <= fsm_readDone;
      inputPhy_readDone <= fsm_readDone_delay_1;
    end
  end


endmodule

//Axi4PeripheralStreamFifo_1 replaced by Axi4PeripheralStreamFifo

module Axi4PeripheralStreamFifo (
  input  wire          io_push_valid,
  output wire          io_push_ready,
  input  wire [7:0]    io_push_payload,
  output wire          io_pop_valid,
  input  wire          io_pop_ready,
  output wire [7:0]    io_pop_payload,
  input  wire          io_flush,
  output wire [7:0]    io_occupancy,
  output wire [7:0]    io_availability,
  input  wire          clk,
  input  wire          reset
);

  reg        [7:0]    logic_ram_spinal_port1;
  reg                 _zz_1;
  wire                logic_ptr_doPush;
  wire                logic_ptr_doPop;
  wire                logic_ptr_full;
  wire                logic_ptr_empty;
  reg        [7:0]    logic_ptr_push;
  reg        [7:0]    logic_ptr_pop;
  wire       [7:0]    logic_ptr_occupancy;
  wire       [7:0]    logic_ptr_popOnIo;
  wire                when_Stream_l1248;
  reg                 logic_ptr_wentUp;
  wire                io_push_fire;
  wire                logic_push_onRam_write_valid;
  wire       [6:0]    logic_push_onRam_write_payload_address;
  wire       [7:0]    logic_push_onRam_write_payload_data;
  wire                logic_pop_addressGen_valid;
  reg                 logic_pop_addressGen_ready;
  wire       [6:0]    logic_pop_addressGen_payload;
  wire                logic_pop_addressGen_fire;
  wire                logic_pop_sync_readArbitation_valid;
  wire                logic_pop_sync_readArbitation_ready;
  wire       [6:0]    logic_pop_sync_readArbitation_payload;
  reg                 logic_pop_addressGen_rValid;
  reg        [6:0]    logic_pop_addressGen_rData;
  wire                when_Stream_l375;
  wire                logic_pop_sync_readPort_cmd_valid;
  wire       [6:0]    logic_pop_sync_readPort_cmd_payload;
  wire       [7:0]    logic_pop_sync_readPort_rsp;
  wire                logic_pop_sync_readArbitation_translated_valid;
  wire                logic_pop_sync_readArbitation_translated_ready;
  wire       [7:0]    logic_pop_sync_readArbitation_translated_payload;
  wire                logic_pop_sync_readArbitation_fire;
  reg        [7:0]    logic_pop_sync_popReg;
  reg [7:0] logic_ram [0:127];

  always @(posedge clk) begin
    if(_zz_1) begin
      logic_ram[logic_push_onRam_write_payload_address] <= logic_push_onRam_write_payload_data;
    end
  end

  always @(posedge clk) begin
    if(logic_pop_sync_readPort_cmd_valid) begin
      logic_ram_spinal_port1 <= logic_ram[logic_pop_sync_readPort_cmd_payload];
    end
  end

  always @(*) begin
    _zz_1 = 1'b0;
    if(logic_push_onRam_write_valid) begin
      _zz_1 = 1'b1;
    end
  end

  assign when_Stream_l1248 = (logic_ptr_doPush != logic_ptr_doPop);
  assign logic_ptr_full = (((logic_ptr_push ^ logic_ptr_popOnIo) ^ 8'h80) == 8'h0);
  assign logic_ptr_empty = (logic_ptr_push == logic_ptr_pop);
  assign logic_ptr_occupancy = (logic_ptr_push - logic_ptr_popOnIo);
  assign io_push_ready = (! logic_ptr_full);
  assign io_push_fire = (io_push_valid && io_push_ready);
  assign logic_ptr_doPush = io_push_fire;
  assign logic_push_onRam_write_valid = io_push_fire;
  assign logic_push_onRam_write_payload_address = logic_ptr_push[6:0];
  assign logic_push_onRam_write_payload_data = io_push_payload;
  assign logic_pop_addressGen_valid = (! logic_ptr_empty);
  assign logic_pop_addressGen_payload = logic_ptr_pop[6:0];
  assign logic_pop_addressGen_fire = (logic_pop_addressGen_valid && logic_pop_addressGen_ready);
  assign logic_ptr_doPop = logic_pop_addressGen_fire;
  always @(*) begin
    logic_pop_addressGen_ready = logic_pop_sync_readArbitation_ready;
    if(when_Stream_l375) begin
      logic_pop_addressGen_ready = 1'b1;
    end
  end

  assign when_Stream_l375 = (! logic_pop_sync_readArbitation_valid);
  assign logic_pop_sync_readArbitation_valid = logic_pop_addressGen_rValid;
  assign logic_pop_sync_readArbitation_payload = logic_pop_addressGen_rData;
  assign logic_pop_sync_readPort_rsp = logic_ram_spinal_port1;
  assign logic_pop_sync_readPort_cmd_valid = logic_pop_addressGen_fire;
  assign logic_pop_sync_readPort_cmd_payload = logic_pop_addressGen_payload;
  assign logic_pop_sync_readArbitation_translated_valid = logic_pop_sync_readArbitation_valid;
  assign logic_pop_sync_readArbitation_ready = logic_pop_sync_readArbitation_translated_ready;
  assign logic_pop_sync_readArbitation_translated_payload = logic_pop_sync_readPort_rsp;
  assign io_pop_valid = logic_pop_sync_readArbitation_translated_valid;
  assign logic_pop_sync_readArbitation_translated_ready = io_pop_ready;
  assign io_pop_payload = logic_pop_sync_readArbitation_translated_payload;
  assign logic_pop_sync_readArbitation_fire = (logic_pop_sync_readArbitation_valid && logic_pop_sync_readArbitation_ready);
  assign logic_ptr_popOnIo = logic_pop_sync_popReg;
  assign io_occupancy = logic_ptr_occupancy;
  assign io_availability = (8'h80 - logic_ptr_occupancy);
  always @(posedge clk) begin
    if(reset) begin
      logic_ptr_push <= 8'h0;
      logic_ptr_pop <= 8'h0;
      logic_ptr_wentUp <= 1'b0;
      logic_pop_addressGen_rValid <= 1'b0;
      logic_pop_sync_popReg <= 8'h0;
    end else begin
      if(when_Stream_l1248) begin
        logic_ptr_wentUp <= logic_ptr_doPush;
      end
      if(io_flush) begin
        logic_ptr_wentUp <= 1'b0;
      end
      if(logic_ptr_doPush) begin
        logic_ptr_push <= (logic_ptr_push + 8'h01);
      end
      if(logic_ptr_doPop) begin
        logic_ptr_pop <= (logic_ptr_pop + 8'h01);
      end
      if(io_flush) begin
        logic_ptr_push <= 8'h0;
        logic_ptr_pop <= 8'h0;
      end
      if(logic_pop_addressGen_ready) begin
        logic_pop_addressGen_rValid <= logic_pop_addressGen_valid;
      end
      if(io_flush) begin
        logic_pop_addressGen_rValid <= 1'b0;
      end
      if(logic_pop_sync_readArbitation_fire) begin
        logic_pop_sync_popReg <= logic_ptr_pop;
      end
      if(io_flush) begin
        logic_pop_sync_popReg <= 8'h0;
      end
    end
  end

  always @(posedge clk) begin
    if(logic_pop_addressGen_ready) begin
      logic_pop_addressGen_rData <= logic_pop_addressGen_payload;
    end
  end


endmodule

module Axi4PeripheralUartCtrl (
  input  wire [2:0]    io_config_frame_dataLength,
  input  wire [0:0]    io_config_frame_stop,
  input  wire [1:0]    io_config_frame_parity,
  input  wire [19:0]   io_config_clockDivider,
  input  wire          io_write_valid,
  output reg           io_write_ready,
  input  wire [7:0]    io_write_payload,
  output wire          io_read_valid,
  input  wire          io_read_ready,
  output wire [7:0]    io_read_payload,
  output wire          io_uart_txd,
  input  wire          io_uart_rxd,
  output wire          io_readError,
  input  wire          io_writeBreak,
  output wire          io_readBreak,
  input  wire          clk,
  input  wire          reset
);
  localparam Axi4PeripheralUartStopType_ONE = 1'd0;
  localparam Axi4PeripheralUartStopType_TWO = 1'd1;
  localparam Axi4PeripheralUartParityType_NONE = 2'd0;
  localparam Axi4PeripheralUartParityType_EVEN = 2'd1;
  localparam Axi4PeripheralUartParityType_ODD = 2'd2;

  wire                tx_io_write_ready;
  wire                tx_io_txd;
  wire                rx_io_read_valid;
  wire       [7:0]    rx_io_read_payload;
  wire                rx_io_rts;
  wire                rx_io_error;
  wire                rx_io_break;
  reg        [19:0]   clockDivider_counter;
  wire                clockDivider_tick;
  reg                 clockDivider_tickReg;
  reg                 io_write_thrown_valid;
  wire                io_write_thrown_ready;
  wire       [7:0]    io_write_thrown_payload;
  `ifndef SYNTHESIS
  reg [23:0] io_config_frame_stop_string;
  reg [31:0] io_config_frame_parity_string;
  `endif


  Axi4PeripheralUartCtrlTx tx (
    .io_configFrame_dataLength (io_config_frame_dataLength[2:0]), //i
    .io_configFrame_stop       (io_config_frame_stop           ), //i
    .io_configFrame_parity     (io_config_frame_parity[1:0]    ), //i
    .io_samplingTick           (clockDivider_tickReg           ), //i
    .io_write_valid            (io_write_thrown_valid          ), //i
    .io_write_ready            (tx_io_write_ready              ), //o
    .io_write_payload          (io_write_thrown_payload[7:0]   ), //i
    .io_cts                    (1'b0                           ), //i
    .io_txd                    (tx_io_txd                      ), //o
    .io_break                  (io_writeBreak                  ), //i
    .clk                       (clk                            ), //i
    .reset                     (reset                          )  //i
  );
  Axi4PeripheralUartCtrlRx rx (
    .io_configFrame_dataLength (io_config_frame_dataLength[2:0]), //i
    .io_configFrame_stop       (io_config_frame_stop           ), //i
    .io_configFrame_parity     (io_config_frame_parity[1:0]    ), //i
    .io_samplingTick           (clockDivider_tickReg           ), //i
    .io_read_valid             (rx_io_read_valid               ), //o
    .io_read_ready             (io_read_ready                  ), //i
    .io_read_payload           (rx_io_read_payload[7:0]        ), //o
    .io_rxd                    (io_uart_rxd                    ), //i
    .io_rts                    (rx_io_rts                      ), //o
    .io_error                  (rx_io_error                    ), //o
    .io_break                  (rx_io_break                    ), //o
    .clk                       (clk                            ), //i
    .reset                     (reset                          )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_config_frame_stop)
      Axi4PeripheralUartStopType_ONE : io_config_frame_stop_string = "ONE";
      Axi4PeripheralUartStopType_TWO : io_config_frame_stop_string = "TWO";
      default : io_config_frame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_config_frame_parity)
      Axi4PeripheralUartParityType_NONE : io_config_frame_parity_string = "NONE";
      Axi4PeripheralUartParityType_EVEN : io_config_frame_parity_string = "EVEN";
      Axi4PeripheralUartParityType_ODD : io_config_frame_parity_string = "ODD ";
      default : io_config_frame_parity_string = "????";
    endcase
  end
  `endif

  assign clockDivider_tick = (clockDivider_counter == 20'h0);
  always @(*) begin
    io_write_thrown_valid = io_write_valid;
    if(rx_io_break) begin
      io_write_thrown_valid = 1'b0;
    end
  end

  always @(*) begin
    io_write_ready = io_write_thrown_ready;
    if(rx_io_break) begin
      io_write_ready = 1'b1;
    end
  end

  assign io_write_thrown_payload = io_write_payload;
  assign io_write_thrown_ready = tx_io_write_ready;
  assign io_read_valid = rx_io_read_valid;
  assign io_read_payload = rx_io_read_payload;
  assign io_uart_txd = tx_io_txd;
  assign io_readError = rx_io_error;
  assign io_readBreak = rx_io_break;
  always @(posedge clk) begin
    if(reset) begin
      clockDivider_counter <= 20'h0;
      clockDivider_tickReg <= 1'b0;
    end else begin
      clockDivider_tickReg <= clockDivider_tick;
      clockDivider_counter <= (clockDivider_counter - 20'h00001);
      if(clockDivider_tick) begin
        clockDivider_counter <= io_config_clockDivider;
      end
    end
  end


endmodule

//Axi4PeripheralBufferCC_2 replaced by Axi4PeripheralBufferCC_1

module Axi4PeripheralBufferCC_1 (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk) begin
    if(reset) begin
      buffers_0 <= 1'b1;
      buffers_1 <= 1'b1;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule

module Axi4PeripheralUartCtrlRx (
  input  wire [2:0]    io_configFrame_dataLength,
  input  wire [0:0]    io_configFrame_stop,
  input  wire [1:0]    io_configFrame_parity,
  input  wire          io_samplingTick,
  output wire          io_read_valid,
  input  wire          io_read_ready,
  output wire [7:0]    io_read_payload,
  input  wire          io_rxd,
  output wire          io_rts,
  output reg           io_error,
  output wire          io_break,
  input  wire          clk,
  input  wire          reset
);
  localparam Axi4PeripheralUartStopType_ONE = 1'd0;
  localparam Axi4PeripheralUartStopType_TWO = 1'd1;
  localparam Axi4PeripheralUartParityType_NONE = 2'd0;
  localparam Axi4PeripheralUartParityType_EVEN = 2'd1;
  localparam Axi4PeripheralUartParityType_ODD = 2'd2;
  localparam Axi4PeripheralUartCtrlRxState_IDLE = 3'd0;
  localparam Axi4PeripheralUartCtrlRxState_START = 3'd1;
  localparam Axi4PeripheralUartCtrlRxState_DATA = 3'd2;
  localparam Axi4PeripheralUartCtrlRxState_PARITY = 3'd3;
  localparam Axi4PeripheralUartCtrlRxState_STOP = 3'd4;

  wire                io_rxd_buffercc_io_dataOut;
  wire                _zz_sampler_value;
  wire                _zz_sampler_value_1;
  wire                _zz_sampler_value_2;
  wire                _zz_sampler_value_3;
  wire                _zz_sampler_value_4;
  wire                _zz_sampler_value_5;
  wire                _zz_sampler_value_6;
  wire       [2:0]    _zz_when_UartCtrlRx_l139;
  wire       [0:0]    _zz_when_UartCtrlRx_l139_1;
  reg                 _zz_io_rts;
  wire                sampler_synchroniser;
  wire                sampler_samples_0;
  reg                 sampler_samples_1;
  reg                 sampler_samples_2;
  reg                 sampler_samples_3;
  reg                 sampler_samples_4;
  reg                 sampler_value;
  reg                 sampler_tick;
  reg        [2:0]    bitTimer_counter;
  reg                 bitTimer_tick;
  wire                when_UartCtrlRx_l43;
  reg        [2:0]    bitCounter_value;
  reg        [6:0]    break_counter;
  wire                break_valid;
  wire                when_UartCtrlRx_l69;
  reg        [2:0]    stateMachine_state;
  reg                 stateMachine_parity;
  reg        [7:0]    stateMachine_shifter;
  reg                 stateMachine_validReg;
  wire                when_UartCtrlRx_l93;
  wire                when_UartCtrlRx_l103;
  wire                when_UartCtrlRx_l111;
  wire                when_UartCtrlRx_l113;
  wire                when_UartCtrlRx_l125;
  wire                when_UartCtrlRx_l136;
  wire                when_UartCtrlRx_l139;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  `endif


  assign _zz_when_UartCtrlRx_l139_1 = ((io_configFrame_stop == Axi4PeripheralUartStopType_ONE) ? 1'b0 : 1'b1);
  assign _zz_when_UartCtrlRx_l139 = {2'd0, _zz_when_UartCtrlRx_l139_1};
  assign _zz_sampler_value = ((((1'b0 || ((_zz_sampler_value_1 && sampler_samples_1) && sampler_samples_2)) || (((_zz_sampler_value_2 && sampler_samples_0) && sampler_samples_1) && sampler_samples_3)) || (((1'b1 && sampler_samples_0) && sampler_samples_2) && sampler_samples_3)) || (((1'b1 && sampler_samples_1) && sampler_samples_2) && sampler_samples_3));
  assign _zz_sampler_value_3 = (((1'b1 && sampler_samples_0) && sampler_samples_1) && sampler_samples_4);
  assign _zz_sampler_value_4 = ((1'b1 && sampler_samples_0) && sampler_samples_2);
  assign _zz_sampler_value_5 = (1'b1 && sampler_samples_1);
  assign _zz_sampler_value_6 = 1'b1;
  assign _zz_sampler_value_1 = (1'b1 && sampler_samples_0);
  assign _zz_sampler_value_2 = 1'b1;
  (* keep_hierarchy = "TRUE" *) Axi4PeripheralBufferCC io_rxd_buffercc (
    .io_dataIn  (io_rxd                    ), //i
    .io_dataOut (io_rxd_buffercc_io_dataOut), //o
    .clk        (clk                       ), //i
    .reset      (reset                     )  //i
  );
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      Axi4PeripheralUartStopType_ONE : io_configFrame_stop_string = "ONE";
      Axi4PeripheralUartStopType_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      Axi4PeripheralUartParityType_NONE : io_configFrame_parity_string = "NONE";
      Axi4PeripheralUartParityType_EVEN : io_configFrame_parity_string = "EVEN";
      Axi4PeripheralUartParityType_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      Axi4PeripheralUartCtrlRxState_IDLE : stateMachine_state_string = "IDLE  ";
      Axi4PeripheralUartCtrlRxState_START : stateMachine_state_string = "START ";
      Axi4PeripheralUartCtrlRxState_DATA : stateMachine_state_string = "DATA  ";
      Axi4PeripheralUartCtrlRxState_PARITY : stateMachine_state_string = "PARITY";
      Axi4PeripheralUartCtrlRxState_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    io_error = 1'b0;
    case(stateMachine_state)
      Axi4PeripheralUartCtrlRxState_IDLE : begin
      end
      Axi4PeripheralUartCtrlRxState_START : begin
      end
      Axi4PeripheralUartCtrlRxState_DATA : begin
      end
      Axi4PeripheralUartCtrlRxState_PARITY : begin
        if(bitTimer_tick) begin
          if(!when_UartCtrlRx_l125) begin
            io_error = 1'b1;
          end
        end
      end
      default : begin
        if(bitTimer_tick) begin
          if(when_UartCtrlRx_l136) begin
            io_error = 1'b1;
          end
        end
      end
    endcase
  end

  assign io_rts = _zz_io_rts;
  assign sampler_synchroniser = io_rxd_buffercc_io_dataOut;
  assign sampler_samples_0 = sampler_synchroniser;
  always @(*) begin
    bitTimer_tick = 1'b0;
    if(sampler_tick) begin
      if(when_UartCtrlRx_l43) begin
        bitTimer_tick = 1'b1;
      end
    end
  end

  assign when_UartCtrlRx_l43 = (bitTimer_counter == 3'b000);
  assign break_valid = (break_counter == 7'h68);
  assign when_UartCtrlRx_l69 = (io_samplingTick && (! break_valid));
  assign io_break = break_valid;
  assign io_read_valid = stateMachine_validReg;
  assign when_UartCtrlRx_l93 = ((sampler_tick && (! sampler_value)) && (! break_valid));
  assign when_UartCtrlRx_l103 = (sampler_value == 1'b1);
  assign when_UartCtrlRx_l111 = (bitCounter_value == io_configFrame_dataLength);
  assign when_UartCtrlRx_l113 = (io_configFrame_parity == Axi4PeripheralUartParityType_NONE);
  assign when_UartCtrlRx_l125 = (stateMachine_parity == sampler_value);
  assign when_UartCtrlRx_l136 = (! sampler_value);
  assign when_UartCtrlRx_l139 = (bitCounter_value == _zz_when_UartCtrlRx_l139);
  assign io_read_payload = stateMachine_shifter;
  always @(posedge clk) begin
    if(reset) begin
      _zz_io_rts <= 1'b0;
      sampler_samples_1 <= 1'b1;
      sampler_samples_2 <= 1'b1;
      sampler_samples_3 <= 1'b1;
      sampler_samples_4 <= 1'b1;
      sampler_value <= 1'b1;
      sampler_tick <= 1'b0;
      break_counter <= 7'h0;
      stateMachine_state <= Axi4PeripheralUartCtrlRxState_IDLE;
      stateMachine_validReg <= 1'b0;
    end else begin
      _zz_io_rts <= (! io_read_ready);
      if(io_samplingTick) begin
        sampler_samples_1 <= sampler_samples_0;
      end
      if(io_samplingTick) begin
        sampler_samples_2 <= sampler_samples_1;
      end
      if(io_samplingTick) begin
        sampler_samples_3 <= sampler_samples_2;
      end
      if(io_samplingTick) begin
        sampler_samples_4 <= sampler_samples_3;
      end
      sampler_value <= ((((((_zz_sampler_value || _zz_sampler_value_3) || (_zz_sampler_value_4 && sampler_samples_4)) || ((_zz_sampler_value_5 && sampler_samples_2) && sampler_samples_4)) || (((_zz_sampler_value_6 && sampler_samples_0) && sampler_samples_3) && sampler_samples_4)) || (((1'b1 && sampler_samples_1) && sampler_samples_3) && sampler_samples_4)) || (((1'b1 && sampler_samples_2) && sampler_samples_3) && sampler_samples_4));
      sampler_tick <= io_samplingTick;
      if(sampler_value) begin
        break_counter <= 7'h0;
      end else begin
        if(when_UartCtrlRx_l69) begin
          break_counter <= (break_counter + 7'h01);
        end
      end
      stateMachine_validReg <= 1'b0;
      case(stateMachine_state)
        Axi4PeripheralUartCtrlRxState_IDLE : begin
          if(when_UartCtrlRx_l93) begin
            stateMachine_state <= Axi4PeripheralUartCtrlRxState_START;
          end
        end
        Axi4PeripheralUartCtrlRxState_START : begin
          if(bitTimer_tick) begin
            stateMachine_state <= Axi4PeripheralUartCtrlRxState_DATA;
            if(when_UartCtrlRx_l103) begin
              stateMachine_state <= Axi4PeripheralUartCtrlRxState_IDLE;
            end
          end
        end
        Axi4PeripheralUartCtrlRxState_DATA : begin
          if(bitTimer_tick) begin
            if(when_UartCtrlRx_l111) begin
              if(when_UartCtrlRx_l113) begin
                stateMachine_state <= Axi4PeripheralUartCtrlRxState_STOP;
                stateMachine_validReg <= 1'b1;
              end else begin
                stateMachine_state <= Axi4PeripheralUartCtrlRxState_PARITY;
              end
            end
          end
        end
        Axi4PeripheralUartCtrlRxState_PARITY : begin
          if(bitTimer_tick) begin
            if(when_UartCtrlRx_l125) begin
              stateMachine_state <= Axi4PeripheralUartCtrlRxState_STOP;
              stateMachine_validReg <= 1'b1;
            end else begin
              stateMachine_state <= Axi4PeripheralUartCtrlRxState_IDLE;
            end
          end
        end
        default : begin
          if(bitTimer_tick) begin
            if(when_UartCtrlRx_l136) begin
              stateMachine_state <= Axi4PeripheralUartCtrlRxState_IDLE;
            end else begin
              if(when_UartCtrlRx_l139) begin
                stateMachine_state <= Axi4PeripheralUartCtrlRxState_IDLE;
              end
            end
          end
        end
      endcase
    end
  end

  always @(posedge clk) begin
    if(sampler_tick) begin
      bitTimer_counter <= (bitTimer_counter - 3'b001);
    end
    if(bitTimer_tick) begin
      bitCounter_value <= (bitCounter_value + 3'b001);
    end
    if(bitTimer_tick) begin
      stateMachine_parity <= (stateMachine_parity ^ sampler_value);
    end
    case(stateMachine_state)
      Axi4PeripheralUartCtrlRxState_IDLE : begin
        if(when_UartCtrlRx_l93) begin
          bitTimer_counter <= 3'b010;
        end
      end
      Axi4PeripheralUartCtrlRxState_START : begin
        if(bitTimer_tick) begin
          bitCounter_value <= 3'b000;
          stateMachine_parity <= (io_configFrame_parity == Axi4PeripheralUartParityType_ODD);
        end
      end
      Axi4PeripheralUartCtrlRxState_DATA : begin
        if(bitTimer_tick) begin
          stateMachine_shifter[bitCounter_value] <= sampler_value;
          if(when_UartCtrlRx_l111) begin
            bitCounter_value <= 3'b000;
          end
        end
      end
      Axi4PeripheralUartCtrlRxState_PARITY : begin
        if(bitTimer_tick) begin
          bitCounter_value <= 3'b000;
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module Axi4PeripheralUartCtrlTx (
  input  wire [2:0]    io_configFrame_dataLength,
  input  wire [0:0]    io_configFrame_stop,
  input  wire [1:0]    io_configFrame_parity,
  input  wire          io_samplingTick,
  input  wire          io_write_valid,
  output reg           io_write_ready,
  input  wire [7:0]    io_write_payload,
  input  wire          io_cts,
  output wire          io_txd,
  input  wire          io_break,
  input  wire          clk,
  input  wire          reset
);
  localparam Axi4PeripheralUartStopType_ONE = 1'd0;
  localparam Axi4PeripheralUartStopType_TWO = 1'd1;
  localparam Axi4PeripheralUartParityType_NONE = 2'd0;
  localparam Axi4PeripheralUartParityType_EVEN = 2'd1;
  localparam Axi4PeripheralUartParityType_ODD = 2'd2;
  localparam Axi4PeripheralUartCtrlTxState_IDLE = 3'd0;
  localparam Axi4PeripheralUartCtrlTxState_START = 3'd1;
  localparam Axi4PeripheralUartCtrlTxState_DATA = 3'd2;
  localparam Axi4PeripheralUartCtrlTxState_PARITY = 3'd3;
  localparam Axi4PeripheralUartCtrlTxState_STOP = 3'd4;

  wire       [2:0]    _zz_clockDivider_counter_valueNext;
  wire       [0:0]    _zz_clockDivider_counter_valueNext_1;
  wire       [2:0]    _zz_when_UartCtrlTx_l93;
  wire       [0:0]    _zz_when_UartCtrlTx_l93_1;
  reg                 clockDivider_counter_willIncrement;
  wire                clockDivider_counter_willClear;
  reg        [2:0]    clockDivider_counter_valueNext;
  reg        [2:0]    clockDivider_counter_value;
  wire                clockDivider_counter_willOverflowIfInc;
  wire                clockDivider_counter_willOverflow;
  reg        [2:0]    tickCounter_value;
  reg        [2:0]    stateMachine_state;
  reg                 stateMachine_parity;
  reg                 stateMachine_txd;
  wire                when_UartCtrlTx_l58;
  wire                when_UartCtrlTx_l73;
  wire                when_UartCtrlTx_l76;
  wire                when_UartCtrlTx_l93;
  wire       [2:0]    _zz_stateMachine_state;
  reg                 _zz_io_txd;
  `ifndef SYNTHESIS
  reg [23:0] io_configFrame_stop_string;
  reg [31:0] io_configFrame_parity_string;
  reg [47:0] stateMachine_state_string;
  reg [47:0] _zz_stateMachine_state_string;
  `endif


  assign _zz_clockDivider_counter_valueNext_1 = clockDivider_counter_willIncrement;
  assign _zz_clockDivider_counter_valueNext = {2'd0, _zz_clockDivider_counter_valueNext_1};
  assign _zz_when_UartCtrlTx_l93_1 = ((io_configFrame_stop == Axi4PeripheralUartStopType_ONE) ? 1'b0 : 1'b1);
  assign _zz_when_UartCtrlTx_l93 = {2'd0, _zz_when_UartCtrlTx_l93_1};
  `ifndef SYNTHESIS
  always @(*) begin
    case(io_configFrame_stop)
      Axi4PeripheralUartStopType_ONE : io_configFrame_stop_string = "ONE";
      Axi4PeripheralUartStopType_TWO : io_configFrame_stop_string = "TWO";
      default : io_configFrame_stop_string = "???";
    endcase
  end
  always @(*) begin
    case(io_configFrame_parity)
      Axi4PeripheralUartParityType_NONE : io_configFrame_parity_string = "NONE";
      Axi4PeripheralUartParityType_EVEN : io_configFrame_parity_string = "EVEN";
      Axi4PeripheralUartParityType_ODD : io_configFrame_parity_string = "ODD ";
      default : io_configFrame_parity_string = "????";
    endcase
  end
  always @(*) begin
    case(stateMachine_state)
      Axi4PeripheralUartCtrlTxState_IDLE : stateMachine_state_string = "IDLE  ";
      Axi4PeripheralUartCtrlTxState_START : stateMachine_state_string = "START ";
      Axi4PeripheralUartCtrlTxState_DATA : stateMachine_state_string = "DATA  ";
      Axi4PeripheralUartCtrlTxState_PARITY : stateMachine_state_string = "PARITY";
      Axi4PeripheralUartCtrlTxState_STOP : stateMachine_state_string = "STOP  ";
      default : stateMachine_state_string = "??????";
    endcase
  end
  always @(*) begin
    case(_zz_stateMachine_state)
      Axi4PeripheralUartCtrlTxState_IDLE : _zz_stateMachine_state_string = "IDLE  ";
      Axi4PeripheralUartCtrlTxState_START : _zz_stateMachine_state_string = "START ";
      Axi4PeripheralUartCtrlTxState_DATA : _zz_stateMachine_state_string = "DATA  ";
      Axi4PeripheralUartCtrlTxState_PARITY : _zz_stateMachine_state_string = "PARITY";
      Axi4PeripheralUartCtrlTxState_STOP : _zz_stateMachine_state_string = "STOP  ";
      default : _zz_stateMachine_state_string = "??????";
    endcase
  end
  `endif

  always @(*) begin
    clockDivider_counter_willIncrement = 1'b0;
    if(io_samplingTick) begin
      clockDivider_counter_willIncrement = 1'b1;
    end
  end

  assign clockDivider_counter_willClear = 1'b0;
  assign clockDivider_counter_willOverflowIfInc = (clockDivider_counter_value == 3'b111);
  assign clockDivider_counter_willOverflow = (clockDivider_counter_willOverflowIfInc && clockDivider_counter_willIncrement);
  always @(*) begin
    clockDivider_counter_valueNext = (clockDivider_counter_value + _zz_clockDivider_counter_valueNext);
    if(clockDivider_counter_willClear) begin
      clockDivider_counter_valueNext = 3'b000;
    end
  end

  always @(*) begin
    stateMachine_txd = 1'b1;
    case(stateMachine_state)
      Axi4PeripheralUartCtrlTxState_IDLE : begin
      end
      Axi4PeripheralUartCtrlTxState_START : begin
        stateMachine_txd = 1'b0;
      end
      Axi4PeripheralUartCtrlTxState_DATA : begin
        stateMachine_txd = io_write_payload[tickCounter_value];
      end
      Axi4PeripheralUartCtrlTxState_PARITY : begin
        stateMachine_txd = stateMachine_parity;
      end
      default : begin
      end
    endcase
  end

  always @(*) begin
    io_write_ready = io_break;
    case(stateMachine_state)
      Axi4PeripheralUartCtrlTxState_IDLE : begin
      end
      Axi4PeripheralUartCtrlTxState_START : begin
      end
      Axi4PeripheralUartCtrlTxState_DATA : begin
        if(clockDivider_counter_willOverflow) begin
          if(when_UartCtrlTx_l73) begin
            io_write_ready = 1'b1;
          end
        end
      end
      Axi4PeripheralUartCtrlTxState_PARITY : begin
      end
      default : begin
      end
    endcase
  end

  assign when_UartCtrlTx_l58 = ((io_write_valid && (! io_cts)) && clockDivider_counter_willOverflow);
  assign when_UartCtrlTx_l73 = (tickCounter_value == io_configFrame_dataLength);
  assign when_UartCtrlTx_l76 = (io_configFrame_parity == Axi4PeripheralUartParityType_NONE);
  assign when_UartCtrlTx_l93 = (tickCounter_value == _zz_when_UartCtrlTx_l93);
  assign _zz_stateMachine_state = (io_write_valid ? Axi4PeripheralUartCtrlTxState_START : Axi4PeripheralUartCtrlTxState_IDLE);
  assign io_txd = _zz_io_txd;
  always @(posedge clk) begin
    if(reset) begin
      clockDivider_counter_value <= 3'b000;
      stateMachine_state <= Axi4PeripheralUartCtrlTxState_IDLE;
      _zz_io_txd <= 1'b1;
    end else begin
      clockDivider_counter_value <= clockDivider_counter_valueNext;
      case(stateMachine_state)
        Axi4PeripheralUartCtrlTxState_IDLE : begin
          if(when_UartCtrlTx_l58) begin
            stateMachine_state <= Axi4PeripheralUartCtrlTxState_START;
          end
        end
        Axi4PeripheralUartCtrlTxState_START : begin
          if(clockDivider_counter_willOverflow) begin
            stateMachine_state <= Axi4PeripheralUartCtrlTxState_DATA;
          end
        end
        Axi4PeripheralUartCtrlTxState_DATA : begin
          if(clockDivider_counter_willOverflow) begin
            if(when_UartCtrlTx_l73) begin
              if(when_UartCtrlTx_l76) begin
                stateMachine_state <= Axi4PeripheralUartCtrlTxState_STOP;
              end else begin
                stateMachine_state <= Axi4PeripheralUartCtrlTxState_PARITY;
              end
            end
          end
        end
        Axi4PeripheralUartCtrlTxState_PARITY : begin
          if(clockDivider_counter_willOverflow) begin
            stateMachine_state <= Axi4PeripheralUartCtrlTxState_STOP;
          end
        end
        default : begin
          if(clockDivider_counter_willOverflow) begin
            if(when_UartCtrlTx_l93) begin
              stateMachine_state <= _zz_stateMachine_state;
            end
          end
        end
      endcase
      _zz_io_txd <= (stateMachine_txd && (! io_break));
    end
  end

  always @(posedge clk) begin
    if(clockDivider_counter_willOverflow) begin
      tickCounter_value <= (tickCounter_value + 3'b001);
    end
    if(clockDivider_counter_willOverflow) begin
      stateMachine_parity <= (stateMachine_parity ^ stateMachine_txd);
    end
    case(stateMachine_state)
      Axi4PeripheralUartCtrlTxState_IDLE : begin
      end
      Axi4PeripheralUartCtrlTxState_START : begin
        if(clockDivider_counter_willOverflow) begin
          stateMachine_parity <= (io_configFrame_parity == Axi4PeripheralUartParityType_ODD);
          tickCounter_value <= 3'b000;
        end
      end
      Axi4PeripheralUartCtrlTxState_DATA : begin
        if(clockDivider_counter_willOverflow) begin
          if(when_UartCtrlTx_l73) begin
            tickCounter_value <= 3'b000;
          end
        end
      end
      Axi4PeripheralUartCtrlTxState_PARITY : begin
        if(clockDivider_counter_willOverflow) begin
          tickCounter_value <= 3'b000;
        end
      end
      default : begin
      end
    endcase
  end


endmodule

module Axi4PeripheralBufferCC (
  input  wire          io_dataIn,
  output wire          io_dataOut,
  input  wire          clk,
  input  wire          reset
);

  (* async_reg = "true" *) reg                 buffers_0;
  (* async_reg = "true" *) reg                 buffers_1;

  assign io_dataOut = buffers_1;
  always @(posedge clk) begin
    if(reset) begin
      buffers_0 <= 1'b0;
      buffers_1 <= 1'b0;
    end else begin
      buffers_0 <= io_dataIn;
      buffers_1 <= buffers_0;
    end
  end


endmodule
