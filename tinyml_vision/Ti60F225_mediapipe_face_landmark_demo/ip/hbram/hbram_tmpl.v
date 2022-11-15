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

hbram u_hbram(
.io_arw_ready ( io_arw_ready ),
.io_arw_valid ( io_arw_valid ),
.io_axi_clk ( io_axi_clk ),
.ram_clk_cal ( ram_clk_cal ),
.ram_clk ( ram_clk ),
.rst ( rst ),
.io_arw_payload_addr ( io_arw_payload_addr ),
.io_arw_payload_id ( io_arw_payload_id ),
.io_arw_payload_len ( io_arw_payload_len ),
.io_arw_payload_size ( io_arw_payload_size ),
.io_arw_payload_burst ( io_arw_payload_burst ),
.io_arw_payload_lock ( io_arw_payload_lock ),
.io_arw_payload_write ( io_arw_payload_write ),
.io_w_payload_id ( io_w_payload_id ),
.io_w_ready ( io_w_ready ),
.io_w_valid ( io_w_valid ),
.io_w_payload_data ( io_w_payload_data ),
.io_w_payload_strb ( io_w_payload_strb ),
.io_b_valid ( io_b_valid ),
.io_w_payload_last ( io_w_payload_last ),
.io_b_payload_id ( io_b_payload_id ),
.io_b_ready ( io_b_ready ),
.io_r_valid ( io_r_valid ),
.io_r_payload_data ( io_r_payload_data ),
.io_r_ready ( io_r_ready ),
.io_r_payload_id ( io_r_payload_id ),
.hbc_cal_debug_info ( hbc_cal_debug_info ),
.hbc_cal_pass ( hbc_cal_pass ),
.hbc_dq_OE ( hbc_dq_OE ),
.hbc_dq_IN_LO ( hbc_dq_IN_LO ),
.hbc_dq_IN_HI ( hbc_dq_IN_HI ),
.hbc_dq_OUT_LO ( hbc_dq_OUT_LO ),
.hbc_dq_OUT_HI ( hbc_dq_OUT_HI ),
.hbc_rwds_OE ( hbc_rwds_OE ),
.hbc_rwds_IN_LO ( hbc_rwds_IN_LO ),
.hbc_rwds_IN_HI ( hbc_rwds_IN_HI ),
.hbc_rwds_OUT_LO ( hbc_rwds_OUT_LO ),
.hbc_rwds_OUT_HI ( hbc_rwds_OUT_HI ),
.hbc_ck_n_LO ( hbc_ck_n_LO ),
.hbc_ck_n_HI ( hbc_ck_n_HI ),
.hbc_ck_p_LO ( hbc_ck_p_LO ),
.hbc_ck_p_HI ( hbc_ck_p_HI ),
.hbc_cs_n ( hbc_cs_n ),
.hbc_rst_n ( hbc_rst_n ),
.hbc_cal_SHIFT_SEL ( hbc_cal_SHIFT_SEL ),
.hbc_cal_SHIFT ( hbc_cal_SHIFT ),
.hbc_cal_SHIFT_ENA ( hbc_cal_SHIFT_ENA ),
.io_r_payload_last ( io_r_payload_last ),
.dyn_pll_phase_sel ( dyn_pll_phase_sel ),
.dyn_pll_phase_en ( dyn_pll_phase_en ),
.io_r_payload_resp ( io_r_payload_resp )
);
