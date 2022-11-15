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
#pragma once

#include "bsp.h"
#include "tseDemo.h"

/************************** Function File ***************************/
static void MacTxEn(u32 tx_en)
{
	u32 Value;
	//Set Mac TxEn
	Value = read_u32(TSEMAC_CSR+0x008) & TX_ENA_MASK;
	Value |= (tx_en&0x1)<<0;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
		bsp_print("Info : Set Mac TxEn.");
	}
}

/************************** Function File ***************************/
static void MacRxEn(u32 rx_en)
{
	u32 Value;
	//Set Mac RxEn
	Value = read_u32(TSEMAC_CSR+0x008) & RX_ENA_MASK;
	Value |= (rx_en&0x1)<<1;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
		bsp_print("Info : Set Mac RxEn.");
	}
}

/************************** Function File ***************************/
static void MacSpeedSet(u32 speed)
{
	u32 Value;
	//Set Mac Speed
	Value = read_u32(TSEMAC_CSR+0x008) & ETH_SPEED_MASK;
	Value |= (speed&0x7)<<16;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac Speed.");
	}
}

/************************** Function File ***************************/
static void MacLoopbackSet(u32 loopback_en)
{
	u32 Value;
	//Set Mac Loopback
	Value = read_u32(TSEMAC_CSR+0x008) & LOOP_ENA_MASK;
	Value |= (loopback_en&0x1)<<15;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac Loopback.");
	}
}

/************************** Function File ***************************/
static void MacIpgSet(u32 ipg)
{
	//Set Mac IPG
	write_u32(ipg&0x3f, (TSEMAC_CSR+0x5C));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac IPG.");
	}
}

/************************** Function File ***************************/
static void MacAddrSet(u32 dst_addr_ins, u32 src_addr_ins)
{
	u32 Value;
	//dst mac addr set
    //mac_reg mac_addr[47:32]
	write_u32(DST_MAC_H, (TSEMAC_CSR+0x188));
    //mac_reg mac_addr[31:0]
	write_u32(DST_MAC_L, (TSEMAC_CSR+0x184));
	//dst mac addr ins set
    //mac_reg tx_dst_addr_ins
	write_u32(dst_addr_ins, (TSEMAC_CSR+0x180));
	//src mac addr set
    //mac_addr[47:32]
	write_u32(SRC_MAC_H, (TSEMAC_CSR+0x010));
    //mac_addr[31:0]
	write_u32(SRC_MAC_L, (TSEMAC_CSR+0x00c));
	//src mac addr ins set
	Value = read_u32(TSEMAC_CSR+0x008) & TX_ADDR_INS_MASK;
	Value |= (src_addr_ins&0x1)<<9;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
	    bsp_print("Info : Set Mac Address.");
	}
}

/********************************* Function **********************************/
static void Pause_XOn()
{
	u32 Value;
	//Set xon_gen 1
	Value = read_u32(TSEMAC_CSR+0x008) & XON_GEN_MASK;
	Value |= 0x1<<2;
	write_u32(Value, (TSEMAC_CSR+0x008));
	//Set xon_gen 0
	Value &= XON_GEN_MASK;
	Value |= 0x0<<2;
	write_u32(Value, (TSEMAC_CSR+0x008));
}

/************************** Function File ***************************/
static void MacCntClean()
{
	u32 Value;
	//Set cnt_reset 1
	Value = read_u32(TSEMAC_CSR+0x008) & CNT_RST_MASK;
	Value |= 0x80000000;
	write_u32(Value, (TSEMAC_CSR+0x008));
	bsp_uDelay(1);
	//Set cnt_reset 0
	Value &= CNT_RST_MASK;
	Value |= 0x0;
	write_u32(Value, (TSEMAC_CSR+0x008));
	if(PRINTF_EN == 1) {
		bsp_print("Info : Mac Reset Statistics Counters.");
	}
}

/************************** Function File ***************************/
static void CntMonitor()
{
	bsp_print("--------------------");
	bsp_printReg("aFramesTransmittedOK :"       , read_u32(TSEMAC_CSR+0x68));
	bsp_printReg("aFramesReceivedOK :"          , read_u32(TSEMAC_CSR+0x6c));
	bsp_printReg("ifInErrors :"                 , read_u32(TSEMAC_CSR+0x88));
	bsp_printReg("ifOutErrors :"                , read_u32(TSEMAC_CSR+0x8c));
	bsp_printReg("etherStatsPkts :"             , read_u32(TSEMAC_CSR+0xb4));
	bsp_printReg("etherStatsUndersizePkts :"    , read_u32(TSEMAC_CSR+0xb8));
	bsp_printReg("etherStatsOversizePkts :"     , read_u32(TSEMAC_CSR+0xbc));
	bsp_printReg("aRxFilterFramesErrors :"      , read_u32(TSEMAC_CSR+0x9c));
	bsp_printReg("aFrameCheckSequenceErrors :"  , read_u32(TSEMAC_CSR+0x70));
	bsp_printReg("aTxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x80));
	bsp_printReg("aRxPAUSEMACCtrlFrames :"      , read_u32(TSEMAC_CSR+0x84));
	bsp_print("--------------------");
}

/************************** Function File ***************************/
static void MacNormalInit(u32 speed)
{
	MacSpeedSet(speed);
	MacIpgSet(0x0C);
}
