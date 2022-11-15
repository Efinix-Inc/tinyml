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

csi2_rx_cam u_csi2_rx_cam(
.reset_n ( reset_n ),
.clk ( clk ),
.reset_byte_HS_n ( reset_byte_HS_n ),
.clk_byte_HS ( clk_byte_HS ),
.reset_pixel_n ( reset_pixel_n ),
.clk_pixel ( clk_pixel ),
.Rx_LP_CLK_P ( Rx_LP_CLK_P ),
.Rx_LP_CLK_N ( Rx_LP_CLK_N ),
.Rx_HS_enable_C ( Rx_HS_enable_C ),
.LVDS_termen_C ( LVDS_termen_C ),
.Rx_LP_D_P ( Rx_LP_D_P ),
.Rx_LP_D_N ( Rx_LP_D_N ),
.Rx_HS_D_0 ( Rx_HS_D_0 ),
.Rx_HS_D_1 ( Rx_HS_D_1 ),
.Rx_HS_D_2 ( Rx_HS_D_2 ),
.Rx_HS_D_3 ( Rx_HS_D_3 ),
.Rx_HS_D_4 ( Rx_HS_D_4 ),
.Rx_HS_D_5 ( Rx_HS_D_5 ),
.Rx_HS_D_6 ( Rx_HS_D_6 ),
.Rx_HS_D_7 ( Rx_HS_D_7 ),
.Rx_HS_enable_D ( Rx_HS_enable_D ),
.LVDS_termen_D ( LVDS_termen_D ),
.fifo_rd_enable ( fifo_rd_enable ),
.fifo_rd_empty ( fifo_rd_empty ),
.DLY_enable_D ( DLY_enable_D ),
.DLY_inc_D ( DLY_inc_D ),
.u_dly_enable_D ( u_dly_enable_D ),
.vsync_vc1 ( vsync_vc1 ),
.vsync_vc15 ( vsync_vc15 ),
.vsync_vc12 ( vsync_vc12 ),
.vsync_vc9 ( vsync_vc9 ),
.vsync_vc7 ( vsync_vc7 ),
.vsync_vc14 ( vsync_vc14 ),
.vsync_vc13 ( vsync_vc13 ),
.vsync_vc11 ( vsync_vc11 ),
.vsync_vc10 ( vsync_vc10 ),
.vsync_vc8 ( vsync_vc8 ),
.vsync_vc6 ( vsync_vc6 ),
.vsync_vc4 ( vsync_vc4 ),
.vsync_vc0 ( vsync_vc0 ),
.vsync_vc5 ( vsync_vc5 ),
.irq ( irq ),
.pixel_data_valid ( pixel_data_valid ),
.pixel_data ( pixel_data ),
.pixel_per_clk ( pixel_per_clk ),
.datatype ( datatype ),
.shortpkt_data_field ( shortpkt_data_field ),
.word_count ( word_count ),
.vcx ( vcx ),
.vc ( vc ),
.hsync_vc3 ( hsync_vc3 ),
.hsync_vc2 ( hsync_vc2 ),
.hsync_vc8 ( hsync_vc8 ),
.hsync_vc12 ( hsync_vc12 ),
.hsync_vc7 ( hsync_vc7 ),
.hsync_vc10 ( hsync_vc10 ),
.hsync_vc1 ( hsync_vc1 ),
.hsync_vc0 ( hsync_vc0 ),
.hsync_vc13 ( hsync_vc13 ),
.hsync_vc4 ( hsync_vc4 ),
.hsync_vc11 ( hsync_vc11 ),
.hsync_vc6 ( hsync_vc6 ),
.hsync_vc9 ( hsync_vc9 ),
.hsync_vc15 ( hsync_vc15 ),
.hsync_vc14 ( hsync_vc14 ),
.hsync_vc5 ( hsync_vc5 ),
.axi_rready ( axi_rready ),
.axi_rvalid ( axi_rvalid ),
.axi_rdata ( axi_rdata ),
.axi_arready ( axi_arready ),
.axi_arvalid ( axi_arvalid ),
.axi_araddr ( axi_araddr ),
.axi_bready ( axi_bready ),
.axi_bvalid ( axi_bvalid ),
.axi_wready ( axi_wready ),
.axi_wvalid ( axi_wvalid ),
.axi_wdata ( axi_wdata ),
.vsync_vc3 ( vsync_vc3 ),
.vsync_vc2 ( vsync_vc2 ),
.axi_awready ( axi_awready ),
.u_dly_inc_D ( u_dly_inc_D ),
.axi_clk ( axi_clk ),
.axi_reset_n ( axi_reset_n ),
.axi_awaddr ( axi_awaddr ),
.axi_awvalid ( axi_awvalid )
);
