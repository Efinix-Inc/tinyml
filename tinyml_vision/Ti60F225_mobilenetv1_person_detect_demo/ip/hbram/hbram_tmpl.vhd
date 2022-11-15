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
COMPONENT hbram is
PORT (
io_arw_ready : out std_logic;
io_arw_valid : in std_logic;
io_axi_clk : in std_logic;
ram_clk_cal : in std_logic;
ram_clk : in std_logic;
rst : in std_logic;
io_arw_payload_addr : in std_logic_vector(31 downto 0);
io_arw_payload_id : in std_logic_vector(7 downto 0);
io_arw_payload_len : in std_logic_vector(7 downto 0);
io_arw_payload_size : in std_logic_vector(2 downto 0);
io_arw_payload_burst : in std_logic_vector(1 downto 0);
io_arw_payload_lock : in std_logic_vector(1 downto 0);
io_arw_payload_write : in std_logic;
io_w_payload_id : in std_logic_vector(7 downto 0);
io_w_ready : out std_logic;
io_w_valid : in std_logic;
io_w_payload_data : in std_logic_vector(127 downto 0);
io_w_payload_strb : in std_logic_vector(15 downto 0);
io_b_valid : out std_logic;
io_w_payload_last : in std_logic;
io_b_payload_id : out std_logic_vector(7 downto 0);
io_b_ready : in std_logic;
io_r_valid : out std_logic;
io_r_payload_data : out std_logic_vector(127 downto 0);
io_r_ready : in std_logic;
io_r_payload_id : out std_logic_vector(7 downto 0);
hbc_cal_debug_info : out std_logic_vector(15 downto 0);
hbc_cal_pass : out std_logic;
hbc_dq_OE : out std_logic_vector(15 downto 0);
hbc_dq_IN_LO : in std_logic_vector(15 downto 0);
hbc_dq_IN_HI : in std_logic_vector(15 downto 0);
hbc_dq_OUT_LO : out std_logic_vector(15 downto 0);
hbc_dq_OUT_HI : out std_logic_vector(15 downto 0);
hbc_rwds_OE : out std_logic_vector(1 downto 0);
hbc_rwds_IN_LO : in std_logic_vector(1 downto 0);
hbc_rwds_IN_HI : in std_logic_vector(1 downto 0);
hbc_rwds_OUT_LO : out std_logic_vector(1 downto 0);
hbc_rwds_OUT_HI : out std_logic_vector(1 downto 0);
hbc_ck_n_LO : out std_logic;
hbc_ck_n_HI : out std_logic;
hbc_ck_p_LO : out std_logic;
hbc_ck_p_HI : out std_logic;
hbc_cs_n : out std_logic;
hbc_rst_n : out std_logic;
hbc_cal_SHIFT_SEL : out std_logic_vector(4 downto 0);
hbc_cal_SHIFT : out std_logic_vector(2 downto 0);
hbc_cal_SHIFT_ENA : out std_logic;
io_r_payload_last : out std_logic;
dyn_pll_phase_sel : in std_logic_vector(2 downto 0);
dyn_pll_phase_en : in std_logic;
io_r_payload_resp : out std_logic_vector(1 downto 0));
END COMPONENT;
---------------------- End COMPONENT Declaration ------------

------------- Begin Cut here for INSTANTIATION Template -----
u_hbram : hbram
PORT MAP (
io_arw_ready => io_arw_ready,
io_arw_valid => io_arw_valid,
io_axi_clk => io_axi_clk,
ram_clk_cal => ram_clk_cal,
ram_clk => ram_clk,
rst => rst,
io_arw_payload_addr => io_arw_payload_addr,
io_arw_payload_id => io_arw_payload_id,
io_arw_payload_len => io_arw_payload_len,
io_arw_payload_size => io_arw_payload_size,
io_arw_payload_burst => io_arw_payload_burst,
io_arw_payload_lock => io_arw_payload_lock,
io_arw_payload_write => io_arw_payload_write,
io_w_payload_id => io_w_payload_id,
io_w_ready => io_w_ready,
io_w_valid => io_w_valid,
io_w_payload_data => io_w_payload_data,
io_w_payload_strb => io_w_payload_strb,
io_b_valid => io_b_valid,
io_w_payload_last => io_w_payload_last,
io_b_payload_id => io_b_payload_id,
io_b_ready => io_b_ready,
io_r_valid => io_r_valid,
io_r_payload_data => io_r_payload_data,
io_r_ready => io_r_ready,
io_r_payload_id => io_r_payload_id,
hbc_cal_debug_info => hbc_cal_debug_info,
hbc_cal_pass => hbc_cal_pass,
hbc_dq_OE => hbc_dq_OE,
hbc_dq_IN_LO => hbc_dq_IN_LO,
hbc_dq_IN_HI => hbc_dq_IN_HI,
hbc_dq_OUT_LO => hbc_dq_OUT_LO,
hbc_dq_OUT_HI => hbc_dq_OUT_HI,
hbc_rwds_OE => hbc_rwds_OE,
hbc_rwds_IN_LO => hbc_rwds_IN_LO,
hbc_rwds_IN_HI => hbc_rwds_IN_HI,
hbc_rwds_OUT_LO => hbc_rwds_OUT_LO,
hbc_rwds_OUT_HI => hbc_rwds_OUT_HI,
hbc_ck_n_LO => hbc_ck_n_LO,
hbc_ck_n_HI => hbc_ck_n_HI,
hbc_ck_p_LO => hbc_ck_p_LO,
hbc_ck_p_HI => hbc_ck_p_HI,
hbc_cs_n => hbc_cs_n,
hbc_rst_n => hbc_rst_n,
hbc_cal_SHIFT_SEL => hbc_cal_SHIFT_SEL,
hbc_cal_SHIFT => hbc_cal_SHIFT,
hbc_cal_SHIFT_ENA => hbc_cal_SHIFT_ENA,
io_r_payload_last => io_r_payload_last,
dyn_pll_phase_sel => dyn_pll_phase_sel,
dyn_pll_phase_en => dyn_pll_phase_en,
io_r_payload_resp => io_r_payload_resp);
------------------------ End INSTANTIATION Template ---------
