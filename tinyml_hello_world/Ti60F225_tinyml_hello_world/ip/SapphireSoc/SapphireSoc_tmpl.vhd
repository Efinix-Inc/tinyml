////////////////////////////////////////////////////////////////////////////////
// Copyright (C) 2013-2022 Efinix Inc. All rights reserved.              
//
// This   document  contains  proprietary information  which   is        
// protected by  copyright. All rights  are reserved.  This notice       
// refers to original work by Efinix, Inc. which may be derivitive       
// of other work distributed under license of the authors.  In the       
// case of derivative work, nothing in this notice overrides the         
// original author's license agreement.  Where applicable, the           
// original license agreement is included in it's original               
// unmodified form immediately below this header.                        
//                                                                       
// WARRANTY DISCLAIMER.                                                  
//     THE  DESIGN, CODE, OR INFORMATION ARE PROVIDED “AS IS” AND        
//     EFINIX MAKES NO WARRANTIES, EXPRESS OR IMPLIED WITH               
//     RESPECT THERETO, AND EXPRESSLY DISCLAIMS ANY IMPLIED WARRANTIES,  
//     INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF          
//     MERCHANTABILITY, NON-INFRINGEMENT AND FITNESS FOR A PARTICULAR    
//     PURPOSE.  SOME STATES DO NOT ALLOW EXCLUSIONS OF AN IMPLIED       
//     WARRANTY, SO THIS DISCLAIMER MAY NOT APPLY TO LICENSEE.           
//                                                                       
// LIMITATION OF LIABILITY.                                              
//     NOTWITHSTANDING ANYTHING TO THE CONTRARY, EXCEPT FOR BODILY       
//     INJURY, EFINIX SHALL NOT BE LIABLE WITH RESPECT TO ANY SUBJECT    
//     MATTER OF THIS AGREEMENT UNDER TORT, CONTRACT, STRICT LIABILITY   
//     OR ANY OTHER LEGAL OR EQUITABLE THEORY (I) FOR ANY INDIRECT,      
//     SPECIAL, INCIDENTAL, EXEMPLARY OR CONSEQUENTIAL DAMAGES OF ANY    
//     CHARACTER INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF      
//     GOODWILL, DATA OR PROFIT, WORK STOPPAGE, OR COMPUTER FAILURE OR   
//     MALFUNCTION, OR IN ANY EVENT (II) FOR ANY AMOUNT IN EXCESS, IN    
//     THE AGGREGATE, OF THE FEE PAID BY LICENSEE TO EFINIX HEREUNDER    
//     (OR, IF THE FEE HAS BEEN WAIVED, $100), EVEN IF EFINIX SHALL HAVE 
//     BEEN INFORMED OF THE POSSIBILITY OF SUCH DAMAGES.  SOME STATES DO 
//     NOT ALLOW THE EXCLUSION OR LIMITATION OF INCIDENTAL OR            
//     CONSEQUENTIAL DAMAGES, SO THIS LIMITATION AND EXCLUSION MAY NOT   
//     APPLY TO LICENSEE.                                                
//
////////////////////////////////////////////////////////////////////////////////
------------- Begin Cut here for COMPONENT Declaration ------
COMPONENT SapphireSoc is
PORT (
io_systemClk : in std_logic;
io_peripheralClk : in std_logic;
io_peripheralReset : out std_logic;
io_ddrA_w_payload_strb : out std_logic_vector(15 downto 0);
io_ddrA_w_payload_data : out std_logic_vector(127 downto 0);
axiA_awready : in std_logic;
axiA_awlen : out std_logic_vector(7 downto 0);
axiA_awsize : out std_logic_vector(2 downto 0);
axiA_arburst : out std_logic_vector(1 downto 0);
axiA_awlock : out std_logic;
axiA_arcache : out std_logic_vector(3 downto 0);
axiA_awqos : out std_logic_vector(3 downto 0);
axiA_awprot : out std_logic_vector(2 downto 0);
axiA_arsize : out std_logic_vector(2 downto 0);
axiA_arregion : out std_logic_vector(3 downto 0);
axiA_arready : in std_logic;
axiA_arqos : out std_logic_vector(3 downto 0);
axiA_arprot : out std_logic_vector(2 downto 0);
axiA_arlock : out std_logic;
axiA_arlen : out std_logic_vector(7 downto 0);
axiA_arid : out std_logic_vector(7 downto 0);
axiA_awcache : out std_logic_vector(3 downto 0);
axiA_awburst : out std_logic_vector(1 downto 0);
axiA_awaddr : out std_logic_vector(31 downto 0);
axiAInterrupt : in std_logic;
axiA_rlast : in std_logic;
jtagCtrl_enable : in std_logic;
jtagCtrl_tdi : in std_logic;
jtagCtrl_capture : in std_logic;
jtagCtrl_shift : in std_logic;
jtagCtrl_update : in std_logic;
jtagCtrl_reset : in std_logic;
jtagCtrl_tdo : out std_logic;
jtagCtrl_tck : in std_logic;
axiA_araddr : out std_logic_vector(31 downto 0);
axiA_wvalid : out std_logic;
axiA_wready : in std_logic;
axiA_wdata : out std_logic_vector(31 downto 0);
axiA_wstrb : out std_logic_vector(3 downto 0);
axiA_wlast : out std_logic;
axiA_bvalid : in std_logic;
axiA_bready : out std_logic;
axiA_bid : in std_logic_vector(7 downto 0);
axiA_bresp : in std_logic_vector(1 downto 0);
axiA_rvalid : in std_logic;
axiA_rready : out std_logic;
axiA_rdata : in std_logic_vector(31 downto 0);
axiA_rid : in std_logic_vector(7 downto 0);
axiA_rresp : in std_logic_vector(1 downto 0);
axiA_arvalid : out std_logic;
axiA_awid : out std_logic_vector(7 downto 0);
axiA_awregion : out std_logic_vector(3 downto 0);
axiA_awvalid : out std_logic;
io_ddrA_w_payload_id : out std_logic_vector(7 downto 0);
io_ddrA_r_payload_last : in std_logic;
io_ddrA_r_payload_resp : in std_logic_vector(1 downto 0);
io_ddrA_r_payload_id : in std_logic_vector(7 downto 0);
io_ddrA_r_payload_data : in std_logic_vector(127 downto 0);
io_ddrA_r_ready : out std_logic;
io_ddrA_r_valid : in std_logic;
io_ddrA_b_payload_resp : in std_logic_vector(1 downto 0);
io_ddrA_b_payload_id : in std_logic_vector(7 downto 0);
io_ddrA_b_ready : out std_logic;
io_ddrA_b_valid : in std_logic;
io_ddrA_w_payload_last : out std_logic;
io_ddrA_w_ready : in std_logic;
io_ddrA_w_valid : out std_logic;
io_ddrA_arw_payload_write : out std_logic;
io_ddrA_arw_payload_prot : out std_logic_vector(2 downto 0);
io_ddrA_arw_payload_qos : out std_logic_vector(3 downto 0);
io_ddrA_arw_payload_cache : out std_logic_vector(3 downto 0);
io_ddrA_arw_payload_lock : out std_logic;
io_ddrA_arw_payload_burst : out std_logic_vector(1 downto 0);
io_ddrA_arw_payload_size : out std_logic_vector(2 downto 0);
io_ddrA_arw_payload_len : out std_logic_vector(7 downto 0);
io_ddrA_arw_payload_region : out std_logic_vector(3 downto 0);
io_ddrA_arw_payload_id : out std_logic_vector(7 downto 0);
io_ddrA_arw_payload_addr : out std_logic_vector(31 downto 0);
io_ddrA_arw_ready : in std_logic;
io_ddrA_arw_valid : out std_logic;
system_spi_0_io_data_0_read : in std_logic;
system_spi_0_io_data_0_write : out std_logic;
system_spi_0_io_data_0_writeEnable : out std_logic;
system_spi_0_io_data_1_read : in std_logic;
system_spi_0_io_data_1_write : out std_logic;
system_spi_0_io_data_1_writeEnable : out std_logic;
system_spi_0_io_data_2_read : in std_logic;
system_spi_0_io_data_2_write : out std_logic;
system_spi_0_io_data_2_writeEnable : out std_logic;
system_spi_0_io_data_3_read : in std_logic;
system_spi_0_io_data_3_write : out std_logic;
system_spi_0_io_data_3_writeEnable : out std_logic;
system_spi_0_io_sclk_write : out std_logic;
system_spi_0_io_ss : out std_logic_vector(0 to 0);
userInterruptB : in std_logic;
userInterruptA : in std_logic;
io_apbSlave_1_PADDR : out std_logic_vector(15 downto 0);
io_apbSlave_1_PENABLE : out std_logic;
io_apbSlave_1_PRDATA : in std_logic_vector(31 downto 0);
io_apbSlave_1_PREADY : in std_logic;
io_apbSlave_1_PSEL : out std_logic;
io_apbSlave_1_PSLVERROR : in std_logic;
io_apbSlave_1_PWDATA : out std_logic_vector(31 downto 0);
io_apbSlave_1_PWRITE : out std_logic;
io_apbSlave_0_PADDR : out std_logic_vector(15 downto 0);
io_apbSlave_0_PENABLE : out std_logic;
io_apbSlave_0_PRDATA : in std_logic_vector(31 downto 0);
io_apbSlave_0_PREADY : in std_logic;
io_apbSlave_0_PSEL : out std_logic;
io_apbSlave_0_PSLVERROR : in std_logic;
io_apbSlave_0_PWDATA : out std_logic_vector(31 downto 0);
io_apbSlave_0_PWRITE : out std_logic;
io_asyncReset : in std_logic;
io_memoryClk : in std_logic;
io_systemReset : out std_logic;
system_uart_0_io_txd : out std_logic;
io_memoryReset : out std_logic;
system_uart_0_io_rxd : in std_logic;
system_i2c_0_io_scl_read : in std_logic;
system_i2c_0_io_scl_write : out std_logic;
system_i2c_0_io_sda_read : in std_logic;
system_i2c_0_io_sda_write : out std_logic;
cpu0_customInstruction_cmd_valid : out std_logic;
cpu0_customInstruction_cmd_ready : in std_logic;
cpu0_customInstruction_function_id : out std_logic_vector(9 downto 0);
cpu0_customInstruction_inputs_0 : out std_logic_vector(31 downto 0);
cpu0_customInstruction_inputs_1 : out std_logic_vector(31 downto 0);
cpu0_customInstruction_rsp_valid : in std_logic;
cpu0_customInstruction_rsp_ready : out std_logic;
cpu0_customInstruction_outputs_0 : in std_logic_vector(31 downto 0));
END COMPONENT;
---------------------- End COMPONENT Declaration ------------

------------- Begin Cut here for INSTANTIATION Template -----
u_SapphireSoc : SapphireSoc
PORT MAP (
io_systemClk => io_systemClk,
io_peripheralClk => io_peripheralClk,
io_peripheralReset => io_peripheralReset,
io_ddrA_w_payload_strb => io_ddrA_w_payload_strb,
io_ddrA_w_payload_data => io_ddrA_w_payload_data,
axiA_awready => axiA_awready,
axiA_awlen => axiA_awlen,
axiA_awsize => axiA_awsize,
axiA_arburst => axiA_arburst,
axiA_awlock => axiA_awlock,
axiA_arcache => axiA_arcache,
axiA_awqos => axiA_awqos,
axiA_awprot => axiA_awprot,
axiA_arsize => axiA_arsize,
axiA_arregion => axiA_arregion,
axiA_arready => axiA_arready,
axiA_arqos => axiA_arqos,
axiA_arprot => axiA_arprot,
axiA_arlock => axiA_arlock,
axiA_arlen => axiA_arlen,
axiA_arid => axiA_arid,
axiA_awcache => axiA_awcache,
axiA_awburst => axiA_awburst,
axiA_awaddr => axiA_awaddr,
axiAInterrupt => axiAInterrupt,
axiA_rlast => axiA_rlast,
jtagCtrl_enable => jtagCtrl_enable,
jtagCtrl_tdi => jtagCtrl_tdi,
jtagCtrl_capture => jtagCtrl_capture,
jtagCtrl_shift => jtagCtrl_shift,
jtagCtrl_update => jtagCtrl_update,
jtagCtrl_reset => jtagCtrl_reset,
jtagCtrl_tdo => jtagCtrl_tdo,
jtagCtrl_tck => jtagCtrl_tck,
axiA_araddr => axiA_araddr,
axiA_wvalid => axiA_wvalid,
axiA_wready => axiA_wready,
axiA_wdata => axiA_wdata,
axiA_wstrb => axiA_wstrb,
axiA_wlast => axiA_wlast,
axiA_bvalid => axiA_bvalid,
axiA_bready => axiA_bready,
axiA_bid => axiA_bid,
axiA_bresp => axiA_bresp,
axiA_rvalid => axiA_rvalid,
axiA_rready => axiA_rready,
axiA_rdata => axiA_rdata,
axiA_rid => axiA_rid,
axiA_rresp => axiA_rresp,
axiA_arvalid => axiA_arvalid,
axiA_awid => axiA_awid,
axiA_awregion => axiA_awregion,
axiA_awvalid => axiA_awvalid,
io_ddrA_w_payload_id => io_ddrA_w_payload_id,
io_ddrA_r_payload_last => io_ddrA_r_payload_last,
io_ddrA_r_payload_resp => io_ddrA_r_payload_resp,
io_ddrA_r_payload_id => io_ddrA_r_payload_id,
io_ddrA_r_payload_data => io_ddrA_r_payload_data,
io_ddrA_r_ready => io_ddrA_r_ready,
io_ddrA_r_valid => io_ddrA_r_valid,
io_ddrA_b_payload_resp => io_ddrA_b_payload_resp,
io_ddrA_b_payload_id => io_ddrA_b_payload_id,
io_ddrA_b_ready => io_ddrA_b_ready,
io_ddrA_b_valid => io_ddrA_b_valid,
io_ddrA_w_payload_last => io_ddrA_w_payload_last,
io_ddrA_w_ready => io_ddrA_w_ready,
io_ddrA_w_valid => io_ddrA_w_valid,
io_ddrA_arw_payload_write => io_ddrA_arw_payload_write,
io_ddrA_arw_payload_prot => io_ddrA_arw_payload_prot,
io_ddrA_arw_payload_qos => io_ddrA_arw_payload_qos,
io_ddrA_arw_payload_cache => io_ddrA_arw_payload_cache,
io_ddrA_arw_payload_lock => io_ddrA_arw_payload_lock,
io_ddrA_arw_payload_burst => io_ddrA_arw_payload_burst,
io_ddrA_arw_payload_size => io_ddrA_arw_payload_size,
io_ddrA_arw_payload_len => io_ddrA_arw_payload_len,
io_ddrA_arw_payload_region => io_ddrA_arw_payload_region,
io_ddrA_arw_payload_id => io_ddrA_arw_payload_id,
io_ddrA_arw_payload_addr => io_ddrA_arw_payload_addr,
io_ddrA_arw_ready => io_ddrA_arw_ready,
io_ddrA_arw_valid => io_ddrA_arw_valid,
system_spi_0_io_data_0_read => system_spi_0_io_data_0_read,
system_spi_0_io_data_0_write => system_spi_0_io_data_0_write,
system_spi_0_io_data_0_writeEnable => system_spi_0_io_data_0_writeEnable,
system_spi_0_io_data_1_read => system_spi_0_io_data_1_read,
system_spi_0_io_data_1_write => system_spi_0_io_data_1_write,
system_spi_0_io_data_1_writeEnable => system_spi_0_io_data_1_writeEnable,
system_spi_0_io_data_2_read => system_spi_0_io_data_2_read,
system_spi_0_io_data_2_write => system_spi_0_io_data_2_write,
system_spi_0_io_data_2_writeEnable => system_spi_0_io_data_2_writeEnable,
system_spi_0_io_data_3_read => system_spi_0_io_data_3_read,
system_spi_0_io_data_3_write => system_spi_0_io_data_3_write,
system_spi_0_io_data_3_writeEnable => system_spi_0_io_data_3_writeEnable,
system_spi_0_io_sclk_write => system_spi_0_io_sclk_write,
system_spi_0_io_ss => system_spi_0_io_ss,
userInterruptB => userInterruptB,
userInterruptA => userInterruptA,
io_apbSlave_1_PADDR => io_apbSlave_1_PADDR,
io_apbSlave_1_PENABLE => io_apbSlave_1_PENABLE,
io_apbSlave_1_PRDATA => io_apbSlave_1_PRDATA,
io_apbSlave_1_PREADY => io_apbSlave_1_PREADY,
io_apbSlave_1_PSEL => io_apbSlave_1_PSEL,
io_apbSlave_1_PSLVERROR => io_apbSlave_1_PSLVERROR,
io_apbSlave_1_PWDATA => io_apbSlave_1_PWDATA,
io_apbSlave_1_PWRITE => io_apbSlave_1_PWRITE,
io_apbSlave_0_PADDR => io_apbSlave_0_PADDR,
io_apbSlave_0_PENABLE => io_apbSlave_0_PENABLE,
io_apbSlave_0_PRDATA => io_apbSlave_0_PRDATA,
io_apbSlave_0_PREADY => io_apbSlave_0_PREADY,
io_apbSlave_0_PSEL => io_apbSlave_0_PSEL,
io_apbSlave_0_PSLVERROR => io_apbSlave_0_PSLVERROR,
io_apbSlave_0_PWDATA => io_apbSlave_0_PWDATA,
io_apbSlave_0_PWRITE => io_apbSlave_0_PWRITE,
io_asyncReset => io_asyncReset,
io_memoryClk => io_memoryClk,
io_systemReset => io_systemReset,
system_uart_0_io_txd => system_uart_0_io_txd,
io_memoryReset => io_memoryReset,
system_uart_0_io_rxd => system_uart_0_io_rxd,
system_i2c_0_io_scl_read => system_i2c_0_io_scl_read,
system_i2c_0_io_scl_write => system_i2c_0_io_scl_write,
system_i2c_0_io_sda_read => system_i2c_0_io_sda_read,
system_i2c_0_io_sda_write => system_i2c_0_io_sda_write,
cpu0_customInstruction_cmd_valid => cpu0_customInstruction_cmd_valid,
cpu0_customInstruction_cmd_ready => cpu0_customInstruction_cmd_ready,
cpu0_customInstruction_function_id => cpu0_customInstruction_function_id,
cpu0_customInstruction_inputs_0 => cpu0_customInstruction_inputs_0,
cpu0_customInstruction_inputs_1 => cpu0_customInstruction_inputs_1,
cpu0_customInstruction_rsp_valid => cpu0_customInstruction_rsp_valid,
cpu0_customInstruction_rsp_ready => cpu0_customInstruction_rsp_ready,
cpu0_customInstruction_outputs_0 => cpu0_customInstruction_outputs_0);
------------------------ End INSTANTIATION Template ---------
