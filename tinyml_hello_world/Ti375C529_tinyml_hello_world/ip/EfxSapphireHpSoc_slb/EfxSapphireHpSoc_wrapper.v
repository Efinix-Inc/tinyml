module EfxSapphireHpSoc_wrapper (
input		cpu1_customInstruction_cmd_valid,
output		cpu1_customInstruction_cmd_ready,
input [9:0] cpu1_customInstruction_function_id,
input [31:0] cpu1_customInstruction_inputs_0,
input [31:0] cpu1_customInstruction_inputs_1,
output		cpu1_customInstruction_rsp_valid,
input		cpu1_customInstruction_rsp_ready,
output [31:0] cpu1_customInstruction_outputs_0,
output		io_ddrMasters_0_aw_valid,
input		io_ddrMasters_0_aw_ready,
output [31:0] io_ddrMasters_0_aw_payload_addr,
output [3:0] io_ddrMasters_0_aw_payload_id,
output [3:0] io_ddrMasters_0_aw_payload_region,
output [7:0] io_ddrMasters_0_aw_payload_len,
output [2:0] io_ddrMasters_0_aw_payload_size,
output [1:0] io_ddrMasters_0_aw_payload_burst,
output		io_ddrMasters_0_aw_payload_lock,
output [3:0] io_ddrMasters_0_aw_payload_cache,
output [3:0] io_ddrMasters_0_aw_payload_qos,
output [2:0] io_ddrMasters_0_aw_payload_prot,
output		io_ddrMasters_0_aw_payload_allStrb,
output		io_ddrMasters_0_w_valid,
input		io_ddrMasters_0_w_ready,
output [127:0] io_ddrMasters_0_w_payload_data,
output [15:0] io_ddrMasters_0_w_payload_strb,
output		io_ddrMasters_0_w_payload_last,
input		io_ddrMasters_0_b_valid,
output		io_ddrMasters_0_b_ready,
input [3:0] io_ddrMasters_0_b_payload_id,
input [1:0] io_ddrMasters_0_b_payload_resp,
output		io_ddrMasters_0_ar_valid,
input		io_ddrMasters_0_ar_ready,
output [31:0] io_ddrMasters_0_ar_payload_addr,
output [3:0] io_ddrMasters_0_ar_payload_id,
output [3:0] io_ddrMasters_0_ar_payload_region,
output [7:0] io_ddrMasters_0_ar_payload_len,
output [2:0] io_ddrMasters_0_ar_payload_size,
output [1:0] io_ddrMasters_0_ar_payload_burst,
output		io_ddrMasters_0_ar_payload_lock,
output [3:0] io_ddrMasters_0_ar_payload_cache,
output [3:0] io_ddrMasters_0_ar_payload_qos,
output [2:0] io_ddrMasters_0_ar_payload_prot,
input		io_ddrMasters_0_r_valid,
output		io_ddrMasters_0_r_ready,
input [127:0] io_ddrMasters_0_r_payload_data,
input [3:0] io_ddrMasters_0_r_payload_id,
input [1:0] io_ddrMasters_0_r_payload_resp,
input		io_ddrMasters_0_r_payload_last,
input		io_ddrMasters_0_clk,
input		io_ddrMasters_0_reset,
input		io_cfuClk,
input		io_cfuReset,
input		cpu2_customInstruction_cmd_valid,
output		cpu2_customInstruction_cmd_ready,
input [9:0] cpu2_customInstruction_function_id,
input [31:0] cpu2_customInstruction_inputs_0,
input [31:0] cpu2_customInstruction_inputs_1,
output		cpu2_customInstruction_rsp_valid,
input		cpu2_customInstruction_rsp_ready,
output [31:0] cpu2_customInstruction_outputs_0,
output		system_i2c_0_io_sda_writeEnable,
output		system_i2c_0_io_sda_write,
input		system_i2c_0_io_sda_read,
output		system_i2c_0_io_scl_writeEnable,
output		system_i2c_0_io_scl_write,
input		system_i2c_0_io_scl_read,
output		userInterruptB,
output		userInterruptA,
output		system_uart_0_io_txd,
input		system_uart_0_io_rxd,
output		jtagCtrl_tdi,
input		jtagCtrl_tdo,
output		jtagCtrl_enable,
output		jtagCtrl_capture,
output		jtagCtrl_shift,
output		jtagCtrl_update,
output		jtagCtrl_reset,
input		ut_jtagCtrl_tdi,
output		ut_jtagCtrl_tdo,
input		ut_jtagCtrl_enable,
input		ut_jtagCtrl_capture,
input		ut_jtagCtrl_shift,
input		ut_jtagCtrl_update,
input		ut_jtagCtrl_reset,
output		system_spi_0_io_sclk_write,
output		system_spi_0_io_data_0_writeEnable,
input		system_spi_0_io_data_0_read,
output		system_spi_0_io_data_0_write,
output		system_spi_0_io_data_1_writeEnable,
input		system_spi_0_io_data_1_read,
output		system_spi_0_io_data_1_write,
output		system_spi_0_io_data_2_writeEnable,
input		system_spi_0_io_data_2_read,
output		system_spi_0_io_data_2_write,
output		system_spi_0_io_data_3_writeEnable,
input		system_spi_0_io_data_3_read,
output		system_spi_0_io_data_3_write,
output [3:0] system_spi_0_io_ss,
output		userInterruptC,
input		cpu0_customInstruction_cmd_valid,
output		cpu0_customInstruction_cmd_ready,
input [9:0] cpu0_customInstruction_function_id,
input [31:0] cpu0_customInstruction_inputs_0,
input [31:0] cpu0_customInstruction_inputs_1,
output		cpu0_customInstruction_rsp_valid,
input		cpu0_customInstruction_rsp_ready,
output [31:0] cpu0_customInstruction_outputs_0,
output		userInterruptF,
output		userInterruptH,
input		cpu3_customInstruction_cmd_valid,
output		cpu3_customInstruction_cmd_ready,
input [9:0] cpu3_customInstruction_function_id,
input [31:0] cpu3_customInstruction_inputs_0,
input [31:0] cpu3_customInstruction_inputs_1,
output		cpu3_customInstruction_rsp_valid,
input		cpu3_customInstruction_rsp_ready,
output [31:0] cpu3_customInstruction_outputs_0,
output		userInterruptD,
output		userInterruptG,
output		userInterruptE,
input [31:0]  axiA_awaddr,
input [7:0]	  axiA_awlen,
input [2:0]	  axiA_awsize,
input [1:0]	  axiA_awburst,
input		  axiA_awlock,
input [3:0]	  axiA_awcache,
input [2:0]	  axiA_awprot,
input [3:0]	  axiA_awqos,
input [3:0]	  axiA_awregion,
input		  axiA_awvalid,
output		  axiA_awready,
input [31:0]  axiA_wdata,
input [3:0]   axiA_wstrb,
input		  axiA_wvalid,
input		  axiA_wlast,
output		  axiA_wready,
output [1:0]  axiA_bresp,
output		  axiA_bvalid,
input		  axiA_bready,
input [31:0]  axiA_araddr,
input [7:0]	  axiA_arlen,
input [2:0]	  axiA_arsize,
input [1:0]	  axiA_arburst,
input		  axiA_arlock,
input [3:0]	  axiA_arcache,
input [2:0]	  axiA_arprot,
input [3:0]	  axiA_arqos,
input [3:0]	  axiA_arregion,
input		  axiA_arvalid,
output		  axiA_arready,
output [31:0] axiA_rdata,
output [1:0]  axiA_rresp,
output		  axiA_rlast,
output		  axiA_rvalid,
input		  axiA_rready,
output        axiAInterrupt,
input         cfg_done,
output        cfg_start,
output        cfg_sel,
output        cfg_reset,
input		  io_peripheralClk,
input         io_peripheralReset,
output        io_asyncReset,
input         io_gpio_sw_n, 
input         pll_peripheral_locked,
input         pll_system_locked
);

wire [15:0] io_apbSlave_0_PADDR;
wire		io_apbSlave_0_PSEL;
wire		io_apbSlave_0_PENABLE;
wire		io_apbSlave_0_PREADY;
wire		io_apbSlave_0_PWRITE;
wire [31:0] io_apbSlave_0_PWDATA;
wire [31:0] io_apbSlave_0_PRDATA;
wire		io_apbSlave_0_PSLVERROR;
wire [11:0] io_apbSlave_1_PADDR;
wire		io_apbSlave_1_PSEL;
wire		io_apbSlave_1_PENABLE;
wire		io_apbSlave_1_PREADY;
wire		io_apbSlave_1_PWRITE;
wire [31:0] io_apbSlave_1_PWDATA;
wire [31:0] io_apbSlave_1_PRDATA;
wire		io_apbSlave_1_PSLVERROR;


assign userInterruptD = 1'b0;	//USER TO MODIFY
assign userInterruptE = 1'b0;	//USER TO MODIFY
assign userInterruptF = 1'b0;	//USER TO MODIFY
assign userInterruptG = 1'b0;	//USER TO MODIFY
assign userInterruptH = 1'b0;	//USER TO MODIFY

/**/
/*	INFO: USER TO MODIFY CODES BELOW						*/
/*	INFO: REFER EXAMPLE DESIGN FOR IMPLEMENTATION DETAILS	*/
/**/
assign io_ddrMasters_0_aw_payload_addr = 32'd0;
assign io_ddrMasters_0_aw_payload_id = 4'd0;
assign io_ddrMasters_0_aw_payload_region = 4'd0;
assign io_ddrMasters_0_aw_payload_len = 8'd0;
assign io_ddrMasters_0_aw_payload_size = 3'd0;
assign io_ddrMasters_0_aw_payload_burst = 2'd0;
assign io_ddrMasters_0_aw_payload_lock = 1'b0;
assign io_ddrMasters_0_aw_payload_cache = 4'd0;
assign io_ddrMasters_0_aw_payload_qos = 4'd0;
assign io_ddrMasters_0_aw_payload_prot = 3'd0;
assign io_ddrMasters_0_aw_payload_allStrb = 1'b0;
assign io_ddrMasters_0_w_valid = 1'b0;
//io_ddrMasters_0_w_ready
assign io_ddrMasters_0_w_payload_data = 128'd0;
assign io_ddrMasters_0_w_payload_strb = 16'd0;
assign io_ddrMasters_0_w_payload_last = 1'b0;
//io_ddrMasters_0_b_valid
assign io_ddrMasters_0_b_ready = 1'b1;
//io_ddrMasters_0_b_payload_id
//io_ddrMasters_0_b_payload_resp
assign io_ddrMasters_0_ar_valid = 1'b0;
//io_ddrMasters_0_ar_ready
assign io_ddrMasters_0_ar_payload_addr = 32'd0;
assign io_ddrMasters_0_ar_payload_id = 4'd0;
assign io_ddrMasters_0_ar_payload_region = 4'd0;
assign io_ddrMasters_0_ar_payload_len = 8'd0;
assign io_ddrMasters_0_ar_payload_size = 3'd0;
assign io_ddrMasters_0_ar_payload_burst = 2'd0;
assign io_ddrMasters_0_ar_payload_lock = 1'b0;
assign io_ddrMasters_0_ar_payload_cache = 4'd0;
assign io_ddrMasters_0_ar_payload_qos = 4'd0;
assign io_ddrMasters_0_ar_payload_pro = 3'd0;
//io_ddrMasters_0_r_valid
assign io_ddrMasters_0_r_ready = 1'b1;
//io_ddrMasters_0_r_payload_data
//io_ddrMasters_0_r_payload_id
//io_ddrMasters_0_r_payload_resp
//io_ddrMasters_0_r_payload_last

/**/
/*	INFO: USER TO MODIFY CODES BELOW						*/
/*	INFO: REFER EXAMPLE DESIGN FOR IMPLEMENTATION DETAILS	*/
/**/
assign cpu1_customInstruction_cmd_ready = 1'b1;
assign cpu1_customInstruction_rsp_valid = 1'b0;
assign cpu1_customInstruction_outputs_0 = 32'd0;
//io_cfuClk
//io_cfyReset
//cpu1_customInstruction_rsp_ready
//cpu1_customInstruction_cmd_valid
//cpu1_customInstruction_function_id
//cpu1_customInstruction_inputs_0
//cpu1_customInstruction_inputs_1

/**/
/*	INFO: USER TO MODIFY CODES BELOW						*/
/*	INFO: REFER EXAMPLE DESIGN FOR IMPLEMENTATION DETAILS	*/
/**/
assign io_apbSlave_0_PREADY = 1'b1;
assign io_apbSlave_0_PRDATA = 32'd0;
//io_apbSlave_0_PADDR;
//io_apbSlave_0_PSEL;
//io_apbSlave_0_PENABLE;
//io_apbSlave_0_PWRITE;
//io_apbSlave_0_PWDATA;
//io_apbSlave_0_PSLVERROR;
/**/
/*	INFO: USER TO MODIFY CODES BELOW						*/
/*	INFO: REFER EXAMPLE DESIGN FOR IMPLEMENTATION DETAILS	*/
/**/
assign cpu0_customInstruction_cmd_ready = 1'b1;
assign cpu0_customInstruction_rsp_valid = 1'b0;
assign cpu0_customInstruction_outputs_0 = 32'd0;
//io_cfuClk
//io_cfyReset
//cpu0_customInstruction_rsp_ready
//cpu0_customInstruction_cmd_valid
//cpu0_customInstruction_function_id
//cpu0_customInstruction_inputs_0
//cpu0_customInstruction_inputs_1

/**/
/*	INFO: USER TO MODIFY CODES BELOW						*/
/*	INFO: REFER EXAMPLE DESIGN FOR IMPLEMENTATION DETAILS	*/
/**/
assign io_apbSlave_1_PREADY = 1'b1;
assign io_apbSlave_1_PRDATA = 32'd0;
//io_apbSlave_1_PADDR;
//io_apbSlave_1_PSEL;
//io_apbSlave_1_PENABLE;
//io_apbSlave_1_PWRITE;
//io_apbSlave_1_PWDATA;
//io_apbSlave_1_PSLVERROR;
/**/
/*	INFO: USER TO MODIFY CODES BELOW						*/
/*	INFO: REFER EXAMPLE DESIGN FOR IMPLEMENTATION DETAILS	*/
/**/
assign cpu2_customInstruction_cmd_ready = 1'b1;
assign cpu2_customInstruction_rsp_valid = 1'b0;
assign cpu2_customInstruction_outputs_0 = 32'd0;
//io_cfuClk
//io_cfyReset
//cpu2_customInstruction_rsp_ready
//cpu2_customInstruction_cmd_valid
//cpu2_customInstruction_function_id
//cpu2_customInstruction_inputs_0
//cpu2_customInstruction_inputs_1

/**/
/*	INFO: USER TO MODIFY CODES BELOW						*/
/*	INFO: REFER EXAMPLE DESIGN FOR IMPLEMENTATION DETAILS	*/
/**/
assign cpu3_customInstruction_cmd_ready = 1'b1;
assign cpu3_customInstruction_rsp_valid = 1'b0;
assign cpu3_customInstruction_outputs_0 = 32'd0;
//io_cfuClk
//io_cfyReset
//cpu3_customInstruction_rsp_ready
//cpu3_customInstruction_cmd_valid
//cpu3_customInstruction_function_id
//cpu3_customInstruction_inputs_0
//cpu3_customInstruction_inputs_1



//axi4 bridge to various I/O
EfxSapphireHpSoc_slb u_top_peripherals(
.system_uart_0_io_txd(system_uart_0_io_txd),
.system_uart_0_io_rxd(system_uart_0_io_rxd),
.io_apbSlave_0_PADDR(io_apbSlave_0_PADDR),
.io_apbSlave_0_PSEL(io_apbSlave_0_PSEL),
.io_apbSlave_0_PENABLE(io_apbSlave_0_PENABLE),
.io_apbSlave_0_PREADY(io_apbSlave_0_PREADY),
.io_apbSlave_0_PWRITE(io_apbSlave_0_PWRITE),
.io_apbSlave_0_PWDATA(io_apbSlave_0_PWDATA),
.io_apbSlave_0_PRDATA(io_apbSlave_0_PRDATA),
.io_apbSlave_0_PSLVERROR(io_apbSlave_0_PSLVERROR),
.userInterruptB(userInterruptB),
.io_apbSlave_1_PADDR(io_apbSlave_1_PADDR),
.io_apbSlave_1_PSEL(io_apbSlave_1_PSEL),
.io_apbSlave_1_PENABLE(io_apbSlave_1_PENABLE),
.io_apbSlave_1_PREADY(io_apbSlave_1_PREADY),
.io_apbSlave_1_PWRITE(io_apbSlave_1_PWRITE),
.io_apbSlave_1_PWDATA(io_apbSlave_1_PWDATA),
.io_apbSlave_1_PRDATA(io_apbSlave_1_PRDATA),
.io_apbSlave_1_PSLVERROR(io_apbSlave_1_PSLVERROR),
.userInterruptA(userInterruptA),
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
.userInterruptC(userInterruptC),
.system_i2c_0_io_sda_writeEnable(system_i2c_0_io_sda_writeEnable),
.system_i2c_0_io_sda_write(system_i2c_0_io_sda_write),
.system_i2c_0_io_sda_read(system_i2c_0_io_sda_read),
.system_i2c_0_io_scl_writeEnable(system_i2c_0_io_scl_writeEnable),
.system_i2c_0_io_scl_write(system_i2c_0_io_scl_write),
.system_i2c_0_io_scl_read(system_i2c_0_io_scl_read),
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
