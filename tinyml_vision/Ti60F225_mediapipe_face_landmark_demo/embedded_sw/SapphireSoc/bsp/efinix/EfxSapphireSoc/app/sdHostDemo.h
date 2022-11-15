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
#include <stdlib.h>
#include <string.h>
#include "soc.h"

/************************** Hardware Header File ***************************/
#define APB_0	                IO_APB_SLAVE_0_INPUT
#define APB_1	                IO_APB_SLAVE_1_INPUT
#define DDR_SADDR               0x01300000
#define DDR_EADDR               0xf7ffffff
#define PROBE_ADDR              IO_APB_SLAVE_0_INPUT

/************************** Main Header File ***************************/
#define DEBUG_PRINTF_EN         0

/************************** SDHC Header File ***************************/
#define MAX_CLK_FREQ            50000//KHz
#define SD_CLK_FREQ             MAX_CLK_FREQ
#define SDHC_ADDR               0x100
#define BLOCK_SIZE              0x200
#define MAX_BLK_BUF             0x100
#define DATA_WIDTH              0x2 //0x0 : 1-bit mode; 
                                    //0x2 : 4-bit mode;

/************************** INTC Header File *****************************/
#define INT_ENABLE                0xffffffcf
#define INT_COMMAND_COMPLETE      0x1
#define INT_TRANSFER_COMPLETE     0x2
#define INT_BLOCK_GAP_EVENT       0x4
#define INT_BUFFER_WRITE_READY    0x10
#define INT_BUFFER_READ_READY     0x20
#define INT_CARD_INSERTION        0x40
#define INT_CARD_REMOVAL          0x80
#define INT_COMMAND_TIMEOUT_ERROR 0x10000
#define INT_COMMAND_CRC_ERROR     0x20000
#define INT_COMMAND_END_BIT_ERROR 0x40000
#define INT_COMMAND_INDEX_ERROR   0x80000
#define INT_DATA_CRC_ERROR        0x200000

