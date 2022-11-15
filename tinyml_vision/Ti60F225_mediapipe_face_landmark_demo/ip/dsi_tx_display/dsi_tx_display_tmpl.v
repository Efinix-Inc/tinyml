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

dsi_tx_display u_dsi_tx_display(
.reset_n ( reset_n ),
.clk ( clk ),
.reset_byte_HS_n ( reset_byte_HS_n ),
.clk_byte_HS ( clk_byte_HS ),
.reset_pixel_n ( reset_pixel_n ),
.clk_pixel ( clk_pixel ),
.irq ( irq ),
.pixel_data_valid ( pixel_data_valid ),
.haddr ( haddr ),
.hsync ( hsync ),
.vsync ( vsync ),
.pixel_data ( pixel_data ),
.datatype ( datatype ),
.vc ( vc ),
.TurnRequest_dbg ( TurnRequest_dbg ),
.TurnRequest_done ( TurnRequest_done ),
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
.Tx_LP_CLK_P ( Tx_LP_CLK_P ),
.Tx_LP_CLK_P_OE ( Tx_LP_CLK_P_OE ),
.Tx_LP_CLK_N ( Tx_LP_CLK_N ),
.Tx_LP_CLK_N_OE ( Tx_LP_CLK_N_OE ),
.Tx_HS_enable_C ( Tx_HS_enable_C ),
.Tx_LP_D_P ( Tx_LP_D_P ),
.Tx_HS_C ( Tx_HS_C ),
.Tx_LP_D_P_OE ( Tx_LP_D_P_OE ),
.Tx_LP_D_N ( Tx_LP_D_N ),
.Tx_LP_D_N_OE ( Tx_LP_D_N_OE ),
.Tx_HS_D_0 ( Tx_HS_D_0 ),
.Tx_HS_D_1 ( Tx_HS_D_1 ),
.Tx_HS_D_2 ( Tx_HS_D_2 ),
.Tx_HS_D_3 ( Tx_HS_D_3 ),
.Tx_HS_enable_D ( Tx_HS_enable_D ),
.Rx_LP_D_P ( Rx_LP_D_P ),
.Rx_LP_D_N ( Rx_LP_D_N ),
.axi_awready ( axi_awready ),
.axi_clk ( axi_clk ),
.axi_reset_n ( axi_reset_n ),
.axi_awaddr ( axi_awaddr ),
.axi_awvalid ( axi_awvalid )
);
