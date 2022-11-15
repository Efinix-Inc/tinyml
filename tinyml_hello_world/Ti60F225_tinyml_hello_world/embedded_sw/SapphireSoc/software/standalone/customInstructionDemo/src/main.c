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
#include <stdint.h>
#include <stdlib.h>
#include "bsp.h"
#include "riscv.h"
#include "soc.h"
#include "print.h"

#define tea_l(rs1, rs2) opcode_R(CUSTOM0, 0x00, 0x00, rs1, rs2)
#define tea_u(rs1, rs2) opcode_R(CUSTOM0, 0x01, 0x00, rs1, rs2)

void soft_tea (uint32_t v0, uint32_t v1, uint32_t *rv0, uint32_t *rv1) {
    uint32_t sum=0, i;

    uint32_t delta=0x9e3779b9;

    uint32_t k0=0x01234567,
    		 k1=0x89abcdef,
			 k2=0x13579248,
			 k3=0x248a0135;

    for (i=0; i < 1024; i++) {
        sum += delta;
        v0 += ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        v1 += ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);

    }
    *rv0=v0;
    *rv1=v1;
}

void error_state() {
    bsp_print("Failed!");
    while (1) {}
}


void printPTime(uint64_t ts1, uint64_t ts2, char *s) {
    uint64_t rts;
    rts=ts2-ts1;
    uart_writeStr(BSP_UART_TERMINAL, s);
    print_dec(rts);
    uart_writeStr(BSP_UART_TERMINAL, "\n\n\r");

}

void main() {
	uint32_t num1, num2;
	uint64_t timerCmp0, timerCmp1;
	uint32_t result_ci0,result_ci1,result_s0,result_s1;

	num1=0x84425820;
	num2=0xdeadbe11;

	bsp_init();
#if (SYSTEM_CORES_0_CFU == 1)
	bsp_print("custom instruction demo !");
	timerCmp0 = clint_getTime(BSP_CLINT);
	result_ci0=tea_l(num1,num2);
	result_ci1=tea_u(0x0, 0x0);
	timerCmp1 = clint_getTime(BSP_CLINT);
	printPTime(timerCmp0,timerCmp1,"custom instruction processing clock cycles:");

	timerCmp0 = clint_getTime(BSP_CLINT);
	soft_tea(num1, num2, &result_s0, &result_s1);
	timerCmp1 = clint_getTime(BSP_CLINT);
	printPTime(timerCmp0,timerCmp1,"software processing clock cycles:");

    if(result_ci0 != result_s0 || result_ci1 != result_s1) {
        error_state();
    } else {
        bsp_print("Passed!"); 
    }
#else
        bsp_print("Custom instruction plugin is disabled, please enable it to run this app");
#endif 

}
