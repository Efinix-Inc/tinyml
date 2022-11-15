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
static void Phy_Wr(u32 RegAddr, u32 Data)
{
    write_u32(((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f), (TSEMAC_CSR+0x108));
    write_u32(Data, (TSEMAC_CSR+0x10c));
    write_u32(0x2, (TSEMAC_CSR+0x104));
    if(PRINTF_EN == 1) {
        bsp_printReg("Wr Phy Addr : ", RegAddr);
        bsp_printReg("Wr Phy Data : ", Data);
    }
}

static u32 Phy_Rd(u32 RegAddr)
{
    u32 Value;
    write_u32(((PHY_ADDR&0x1f)<<8)|(RegAddr&0x1f), (TSEMAC_CSR+0x108));
    write_u32(0x1, (TSEMAC_CSR+0x104));
    bsp_uDelay(1000);
    Value = read_u32(TSEMAC_CSR+0x110);
    if(PRINTF_EN == 1) {
        bsp_printReg("Rd Phy Addr : ", RegAddr);
        bsp_printReg("Return Value : ", Value);
    }
    return Value;
}

/************************** Function File ***************************/
static void PhyDlySetRXTX(int RX_delay, int TX_delay)
{
    u32 Value;
    bsp_print("Start Info : Set Phy Delay.");
    Phy_Wr(0x1F,0x0168);
    Phy_Wr(0x1E,0x8040);
    Phy_Wr(0x1E,0x401E);
    Value = Phy_Rd(0x1F) & 0xFFFF;

    Value &= 0xFF00;
    RX_delay &= 0xF;
    TX_delay &= 0xF;
    bsp_printReg("Setup New Value = ", RX_delay);

    Value = ((Value) | (RX_delay<<4) | (TX_delay));
    Phy_Wr(0x1F,Value);
    Phy_Wr(0x1E,0x801E);
    Phy_Wr(0x1E,0x401E);
    Value = Phy_Rd(0x1F) & 0xFFFF;
    bsp_printReg("Read New Value = ", Value);
}

/************************** Function File ***************************/
static u32 PhyNormalInit()
{
	PhyDlySetRXTX(15, 8);

	u32 Value;
	if(PRINTF_EN == 1) {
		bsp_print("Wait Ethernet Link up...");
	}
    // to read Basic control
	Phy_Rd(0x0); 
    // to read phy ID
	Phy_Rd(0x2); 
    // to read phy ID
	Phy_Rd(0x3); 

	//Unlock Extended registers
	Phy_Wr(0x1f, 0x0168);
	Phy_Wr(0x1e, 0x8040);

	while(1) {
		Value = Phy_Rd(0x11);
        //Link up and DUPLEX mode
		if((Value&0x2400) == 0x2400) {
			if((Value&0xc000) == 0x8000) {          //1000Mbps
				if(PRINTF_EN == 1) {
					bsp_print("Info : Phy Link up on 1000Mbps.");
				}
				return 0x4;
			} else if((Value&0xc000) == 0x4000) {   //100Mbps
				if(PRINTF_EN == 1) {
					bsp_print("Info : Phy Link up on 100Mbps.");
				}
				return 0x2;
			} else if((Value&0xc000) == 0x0) {      //10Mbps
				if(PRINTF_EN == 1) {
					bsp_print("Info : Phy Link up on 10Mbps.");
				}
				return 0x1;
			}
		}
		bsp_uDelay(100000);
	}
}

/************************** Function File ***************************/
static void PhyLoopInit(u32 speed)
{
	PhyDlySetRXTX(8, 1);
	u32 Value;
	if(speed == 0x4) {
		Phy_Wr(0x0, 0x4140);
		if(PRINTF_EN == 1) {
			bsp_print("Info : Set Phy 1000Mbps Loopback Mode.");
		}
	} else if(speed == 0x2) {
		Phy_Wr(0x0, 0x6100);
		if(PRINTF_EN == 1) {
			bsp_print("Info : Set Phy 100Mbps Loopback Mode.");
		}
	} else if(speed == 0x1) {
		Phy_Wr(0x0, 0x4100);
		if(PRINTF_EN == 1) {
			bsp_print("Info : Set Phy 10Mbps Loopback Mode.");
		}
	}
}

