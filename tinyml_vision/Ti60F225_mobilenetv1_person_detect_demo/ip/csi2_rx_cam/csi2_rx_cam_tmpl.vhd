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
COMPONENT csi2_rx_cam is
PORT (
reset_n : in std_logic;
clk : in std_logic;
reset_byte_HS_n : in std_logic;
clk_byte_HS : in std_logic;
reset_pixel_n : in std_logic;
clk_pixel : in std_logic;
Rx_LP_CLK_P : in std_logic;
Rx_LP_CLK_N : in std_logic;
Rx_HS_enable_C : out std_logic;
LVDS_termen_C : out std_logic;
Rx_LP_D_P : in std_logic_vector(1 downto 0);
Rx_LP_D_N : in std_logic_vector(1 downto 0);
Rx_HS_D_0 : in std_logic_vector(7 downto 0);
Rx_HS_D_1 : in std_logic_vector(7 downto 0);
Rx_HS_D_2 : in std_logic_vector(7 downto 0);
Rx_HS_D_3 : in std_logic_vector(7 downto 0);
Rx_HS_D_4 : in std_logic_vector(7 downto 0);
Rx_HS_D_5 : in std_logic_vector(7 downto 0);
Rx_HS_D_6 : in std_logic_vector(7 downto 0);
Rx_HS_D_7 : in std_logic_vector(7 downto 0);
Rx_HS_enable_D : out std_logic_vector(1 downto 0);
LVDS_termen_D : out std_logic_vector(1 downto 0);
fifo_rd_enable : out std_logic_vector(1 downto 0);
fifo_rd_empty : in std_logic_vector(1 downto 0);
DLY_enable_D : out std_logic_vector(1 downto 0);
DLY_inc_D : out std_logic_vector(1 downto 0);
u_dly_enable_D : in std_logic_vector(1 downto 0);
vsync_vc1 : out std_logic;
vsync_vc15 : out std_logic;
vsync_vc12 : out std_logic;
vsync_vc9 : out std_logic;
vsync_vc7 : out std_logic;
vsync_vc14 : out std_logic;
vsync_vc13 : out std_logic;
vsync_vc11 : out std_logic;
vsync_vc10 : out std_logic;
vsync_vc8 : out std_logic;
vsync_vc6 : out std_logic;
vsync_vc4 : out std_logic;
vsync_vc0 : out std_logic;
vsync_vc5 : out std_logic;
irq : out std_logic;
pixel_data_valid : out std_logic;
pixel_data : out std_logic_vector(63 downto 0);
pixel_per_clk : out std_logic_vector(3 downto 0);
datatype : out std_logic_vector(5 downto 0);
shortpkt_data_field : out std_logic_vector(15 downto 0);
word_count : out std_logic_vector(15 downto 0);
vcx : out std_logic_vector(1 downto 0);
vc : out std_logic_vector(1 downto 0);
hsync_vc3 : out std_logic;
hsync_vc2 : out std_logic;
hsync_vc8 : out std_logic;
hsync_vc12 : out std_logic;
hsync_vc7 : out std_logic;
hsync_vc10 : out std_logic;
hsync_vc1 : out std_logic;
hsync_vc0 : out std_logic;
hsync_vc13 : out std_logic;
hsync_vc4 : out std_logic;
hsync_vc11 : out std_logic;
hsync_vc6 : out std_logic;
hsync_vc9 : out std_logic;
hsync_vc15 : out std_logic;
hsync_vc14 : out std_logic;
hsync_vc5 : out std_logic;
axi_rready : in std_logic;
axi_rvalid : out std_logic;
axi_rdata : out std_logic_vector(31 downto 0);
axi_arready : out std_logic;
axi_arvalid : in std_logic;
axi_araddr : in std_logic_vector(5 downto 0);
axi_bready : in std_logic;
axi_bvalid : out std_logic;
axi_wready : out std_logic;
axi_wvalid : in std_logic;
axi_wdata : in std_logic_vector(31 downto 0);
vsync_vc3 : out std_logic;
vsync_vc2 : out std_logic;
axi_awready : out std_logic;
u_dly_inc_D : in std_logic_vector(1 downto 0);
axi_clk : in std_logic;
axi_reset_n : in std_logic;
axi_awaddr : in std_logic_vector(5 downto 0);
axi_awvalid : in std_logic);
END COMPONENT;
---------------------- End COMPONENT Declaration ------------

------------- Begin Cut here for INSTANTIATION Template -----
u_csi2_rx_cam : csi2_rx_cam
PORT MAP (
reset_n => reset_n,
clk => clk,
reset_byte_HS_n => reset_byte_HS_n,
clk_byte_HS => clk_byte_HS,
reset_pixel_n => reset_pixel_n,
clk_pixel => clk_pixel,
Rx_LP_CLK_P => Rx_LP_CLK_P,
Rx_LP_CLK_N => Rx_LP_CLK_N,
Rx_HS_enable_C => Rx_HS_enable_C,
LVDS_termen_C => LVDS_termen_C,
Rx_LP_D_P => Rx_LP_D_P,
Rx_LP_D_N => Rx_LP_D_N,
Rx_HS_D_0 => Rx_HS_D_0,
Rx_HS_D_1 => Rx_HS_D_1,
Rx_HS_D_2 => Rx_HS_D_2,
Rx_HS_D_3 => Rx_HS_D_3,
Rx_HS_D_4 => Rx_HS_D_4,
Rx_HS_D_5 => Rx_HS_D_5,
Rx_HS_D_6 => Rx_HS_D_6,
Rx_HS_D_7 => Rx_HS_D_7,
Rx_HS_enable_D => Rx_HS_enable_D,
LVDS_termen_D => LVDS_termen_D,
fifo_rd_enable => fifo_rd_enable,
fifo_rd_empty => fifo_rd_empty,
DLY_enable_D => DLY_enable_D,
DLY_inc_D => DLY_inc_D,
u_dly_enable_D => u_dly_enable_D,
vsync_vc1 => vsync_vc1,
vsync_vc15 => vsync_vc15,
vsync_vc12 => vsync_vc12,
vsync_vc9 => vsync_vc9,
vsync_vc7 => vsync_vc7,
vsync_vc14 => vsync_vc14,
vsync_vc13 => vsync_vc13,
vsync_vc11 => vsync_vc11,
vsync_vc10 => vsync_vc10,
vsync_vc8 => vsync_vc8,
vsync_vc6 => vsync_vc6,
vsync_vc4 => vsync_vc4,
vsync_vc0 => vsync_vc0,
vsync_vc5 => vsync_vc5,
irq => irq,
pixel_data_valid => pixel_data_valid,
pixel_data => pixel_data,
pixel_per_clk => pixel_per_clk,
datatype => datatype,
shortpkt_data_field => shortpkt_data_field,
word_count => word_count,
vcx => vcx,
vc => vc,
hsync_vc3 => hsync_vc3,
hsync_vc2 => hsync_vc2,
hsync_vc8 => hsync_vc8,
hsync_vc12 => hsync_vc12,
hsync_vc7 => hsync_vc7,
hsync_vc10 => hsync_vc10,
hsync_vc1 => hsync_vc1,
hsync_vc0 => hsync_vc0,
hsync_vc13 => hsync_vc13,
hsync_vc4 => hsync_vc4,
hsync_vc11 => hsync_vc11,
hsync_vc6 => hsync_vc6,
hsync_vc9 => hsync_vc9,
hsync_vc15 => hsync_vc15,
hsync_vc14 => hsync_vc14,
hsync_vc5 => hsync_vc5,
axi_rready => axi_rready,
axi_rvalid => axi_rvalid,
axi_rdata => axi_rdata,
axi_arready => axi_arready,
axi_arvalid => axi_arvalid,
axi_araddr => axi_araddr,
axi_bready => axi_bready,
axi_bvalid => axi_bvalid,
axi_wready => axi_wready,
axi_wvalid => axi_wvalid,
axi_wdata => axi_wdata,
vsync_vc3 => vsync_vc3,
vsync_vc2 => vsync_vc2,
axi_awready => axi_awready,
u_dly_inc_D => u_dly_inc_D,
axi_clk => axi_clk,
axi_reset_n => axi_reset_n,
axi_awaddr => axi_awaddr,
axi_awvalid => axi_awvalid);
------------------------ End INSTANTIATION Template ---------
