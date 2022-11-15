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
COMPONENT dma is
PORT (
clk : in std_logic;
ctrl_reset : in std_logic;
reset : in std_logic;
ctrl_clk : in std_logic;
ctrl_PADDR : in std_logic_vector(13 downto 0);
ctrl_PREADY : out std_logic;
ctrl_PENABLE : in std_logic;
ctrl_PSEL : in std_logic;
ctrl_PWRITE : in std_logic;
ctrl_PWDATA : in std_logic_vector(31 downto 0);
ctrl_PRDATA : out std_logic_vector(31 downto 0);
ctrl_PSLVERROR : out std_logic;
ctrl_interrupts : out std_logic_vector(3 downto 0);
read_arvalid : out std_logic;
read_araddr : out std_logic_vector(31 downto 0);
read_arready : in std_logic;
read_arregion : out std_logic_vector(3 downto 0);
read_arlen : out std_logic_vector(7 downto 0);
read_arsize : out std_logic_vector(2 downto 0);
read_arburst : out std_logic_vector(1 downto 0);
read_arlock : out std_logic;
read_arcache : out std_logic_vector(3 downto 0);
read_arqos : out std_logic_vector(3 downto 0);
read_arprot : out std_logic_vector(2 downto 0);
read_rready : out std_logic;
read_rvalid : in std_logic;
read_rdata : in std_logic_vector(127 downto 0);
read_rlast : in std_logic;
write_awvalid : out std_logic;
write_awready : in std_logic;
write_awaddr : out std_logic_vector(31 downto 0);
write_awregion : out std_logic_vector(3 downto 0);
write_awlen : out std_logic_vector(7 downto 0);
write_awsize : out std_logic_vector(2 downto 0);
write_awburst : out std_logic_vector(1 downto 0);
write_awlock : out std_logic;
write_awcache : out std_logic_vector(3 downto 0);
write_awqos : out std_logic_vector(3 downto 0);
write_awprot : out std_logic_vector(2 downto 0);
write_wvalid : out std_logic;
write_wready : in std_logic;
write_wdata : out std_logic_vector(127 downto 0);
write_wstrb : out std_logic_vector(15 downto 0);
write_wlast : out std_logic;
write_bvalid : in std_logic;
write_bready : out std_logic;
write_bresp : in std_logic_vector(1 downto 0);
dat3_o_tvalid : out std_logic;
dat3_o_tready : in std_logic;
dat3_o_tdata : out std_logic_vector(31 downto 0);
dat3_o_tkeep : out std_logic_vector(3 downto 0);
dat3_o_tdest : out std_logic_vector(3 downto 0);
dat3_o_tlast : out std_logic;
dat1_o_tvalid : out std_logic;
dat1_o_tready : in std_logic;
dat1_o_tdata : out std_logic_vector(63 downto 0);
dat1_o_tkeep : out std_logic_vector(7 downto 0);
dat1_o_tdest : out std_logic_vector(3 downto 0);
dat1_o_tlast : out std_logic;
dat3_o_clk : in std_logic;
dat3_o_reset : in std_logic;
dat2_i_clk : in std_logic;
dat2_i_reset : in std_logic;
dat1_o_clk : in std_logic;
dat1_o_reset : in std_logic;
dat0_i_clk : in std_logic;
dat0_i_reset : in std_logic_vector(0 to 0);
dat2_i_tvalid : in std_logic;
dat2_i_tready : out std_logic;
dat2_i_tdata : in std_logic_vector(31 downto 0);
dat2_i_tkeep : in std_logic_vector(3 downto 0);
dat2_i_tdest : in std_logic_vector(3 downto 0);
dat2_i_tlast : in std_logic;
dat0_i_tvalid : in std_logic;
dat0_i_tready : out std_logic;
dat0_i_tdata : in std_logic_vector(63 downto 0);
dat0_i_tkeep : in std_logic_vector(7 downto 0);
dat0_i_tdest : in std_logic_vector(3 downto 0);
dat0_i_tlast : in std_logic;
read_rresp : in std_logic_vector(1 downto 0));
END COMPONENT;
---------------------- End COMPONENT Declaration ------------

------------- Begin Cut here for INSTANTIATION Template -----
u_dma : dma
PORT MAP (
clk => clk,
ctrl_reset => ctrl_reset,
reset => reset,
ctrl_clk => ctrl_clk,
ctrl_PADDR => ctrl_PADDR,
ctrl_PREADY => ctrl_PREADY,
ctrl_PENABLE => ctrl_PENABLE,
ctrl_PSEL => ctrl_PSEL,
ctrl_PWRITE => ctrl_PWRITE,
ctrl_PWDATA => ctrl_PWDATA,
ctrl_PRDATA => ctrl_PRDATA,
ctrl_PSLVERROR => ctrl_PSLVERROR,
ctrl_interrupts => ctrl_interrupts,
read_arvalid => read_arvalid,
read_araddr => read_araddr,
read_arready => read_arready,
read_arregion => read_arregion,
read_arlen => read_arlen,
read_arsize => read_arsize,
read_arburst => read_arburst,
read_arlock => read_arlock,
read_arcache => read_arcache,
read_arqos => read_arqos,
read_arprot => read_arprot,
read_rready => read_rready,
read_rvalid => read_rvalid,
read_rdata => read_rdata,
read_rlast => read_rlast,
write_awvalid => write_awvalid,
write_awready => write_awready,
write_awaddr => write_awaddr,
write_awregion => write_awregion,
write_awlen => write_awlen,
write_awsize => write_awsize,
write_awburst => write_awburst,
write_awlock => write_awlock,
write_awcache => write_awcache,
write_awqos => write_awqos,
write_awprot => write_awprot,
write_wvalid => write_wvalid,
write_wready => write_wready,
write_wdata => write_wdata,
write_wstrb => write_wstrb,
write_wlast => write_wlast,
write_bvalid => write_bvalid,
write_bready => write_bready,
write_bresp => write_bresp,
dat3_o_tvalid => dat3_o_tvalid,
dat3_o_tready => dat3_o_tready,
dat3_o_tdata => dat3_o_tdata,
dat3_o_tkeep => dat3_o_tkeep,
dat3_o_tdest => dat3_o_tdest,
dat3_o_tlast => dat3_o_tlast,
dat1_o_tvalid => dat1_o_tvalid,
dat1_o_tready => dat1_o_tready,
dat1_o_tdata => dat1_o_tdata,
dat1_o_tkeep => dat1_o_tkeep,
dat1_o_tdest => dat1_o_tdest,
dat1_o_tlast => dat1_o_tlast,
dat3_o_clk => dat3_o_clk,
dat3_o_reset => dat3_o_reset,
dat2_i_clk => dat2_i_clk,
dat2_i_reset => dat2_i_reset,
dat1_o_clk => dat1_o_clk,
dat1_o_reset => dat1_o_reset,
dat0_i_clk => dat0_i_clk,
dat0_i_reset => dat0_i_reset,
dat2_i_tvalid => dat2_i_tvalid,
dat2_i_tready => dat2_i_tready,
dat2_i_tdata => dat2_i_tdata,
dat2_i_tkeep => dat2_i_tkeep,
dat2_i_tdest => dat2_i_tdest,
dat2_i_tlast => dat2_i_tlast,
dat0_i_tvalid => dat0_i_tvalid,
dat0_i_tready => dat0_i_tready,
dat0_i_tdata => dat0_i_tdata,
dat0_i_tkeep => dat0_i_tkeep,
dat0_i_tdest => dat0_i_tdest,
dat0_i_tlast => dat0_i_tlast,
read_rresp => read_rresp);
------------------------ End INSTANTIATION Template ---------
