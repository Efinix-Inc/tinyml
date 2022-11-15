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
#include "bsp.h"
#include "riscv.h"
#include "clint.h"
#include "plic.h"

void init();
void main();
void trap();
void crash();
void trap_entry();
void userInterrupt();

void main() {
	init();
	bsp_print("user interrupt(s) demo, waiting for user interrupt...");
	while(1); //Idle
}

void init(){
	plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0);
#ifdef SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT, 2);
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT, 3);
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT, 1);
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT, 1);
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT, 1);
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_F_INTERRUPT
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_F_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_F_INTERRUPT, 1);
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_G_INTERRUPT
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_G_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_G_INTERRUPT, 1);
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_H_INTERRUPT
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_H_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_H_INTERRUPT, 1);
#endif
	csr_write(mtvec, trap_entry);
    csr_set(mie, MIE_MEIE);
	csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

void trap(){
	int32_t mcause = csr_read(mcause);
	int32_t interrupt = mcause < 0;    
	int32_t cause     = mcause & 0xF;
	if(interrupt){
		switch(cause){
		case CAUSE_MACHINE_EXTERNAL: userInterrupt(); break;
		default: crash(); break;
		}
	} else {
		crash();
	}
}

void userInterrupt(){
	uint32_t claim;
	//While there is pending interrupts
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
		switch(claim){
#ifdef SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT
		case SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT:
			bsp_print("Entered User Interrupt 0 Routine");
			break;
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT
		case SYSTEM_PLIC_USER_INTERRUPT_B_INTERRUPT:
			bsp_print("Entered User Interrupt 1 Routine");
			break;
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT
		case SYSTEM_PLIC_USER_INTERRUPT_C_INTERRUPT:
			bsp_print("Entered User Interrupt 2 Routine");
			break;
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT
		case SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT:
			bsp_print("Entered User Interrupt 3 Routine");
			break;
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT
		case SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT:
			bsp_print("Entered User Interrupt 4 Routine");
			break;
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_F_INTERRUPT
		case SYSTEM_PLIC_USER_INTERRUPT_F_INTERRUPT:
			bsp_print("Entered User Interrupt 5 Routine");
			break;
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_G_INTERRUPT
		case SYSTEM_PLIC_USER_INTERRUPT_G_INTERRUPT:
			bsp_print("Entered User Interrupt 6 Routine");
			break;
#endif
#ifdef SYSTEM_PLIC_USER_INTERRUPT_H_INTERRUPT
		case SYSTEM_PLIC_USER_INTERRUPT_H_INTERRUPT:
			bsp_print("Entered User Interrupt 7 Routine");
			break;
#endif
			default: crash(); break;
		}
		plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
	}
}

void crash(){
	bsp_print("\n*** CRASH ***\n");
	while(1);
}

