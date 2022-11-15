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
#include "plic.h"

#ifdef SYSTEM_AXI_A_BMB

    #define AXI SYSTEM_AXI_A_BMB
    #define AXI_SIZE 2048

#endif

void main();
void error_state();
void intr_init();
void trap();
void crash();
void trap_entry();
void axiInterrupt();

void error_state() {
	bsp_print("Failed!");
	while (1) {}
}

void crash(){
	bsp_print("\n*** CRASH ***\n");
	while(1);
}

void intr_init(){
	//configure PLIC
    //cpu 0 accept all interrupts with priority above 0
	plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 
	//enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt
#ifdef SYSTEM_AXI_A_BMB

	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_AXI_A_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_AXI_A_INTERRUPT, 1);

#endif	
	//enable interrupts
    //Set the machine trap vector (../common/trap.S)
	csr_write(mtvec, trap_entry); 
    //Enable external interrupts
	csr_set(mie, MIE_MEIE); 
	csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

void trap(){
	int32_t mcause    = csr_read(mcause);
    //Interrupt if true, exception if false
	int32_t interrupt = mcause < 0;    
	int32_t cause     = mcause & 0xF;
	if(interrupt){
		switch(cause){
		case CAUSE_MACHINE_EXTERNAL: axiInterrupt(); break;
		default: crash(); break;
		}
	} else {
		crash();
	}
}

void axiInterrupt(){

	uint32_t claim;
	//While there is pending interrupts
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
		switch(claim){
#ifdef SYSTEM_AXI_A_BMB

		case SYSTEM_PLIC_SYSTEM_AXI_A_INTERRUPT:
            bsp_print("Entered AXI Interrupt Routine, Passed!"); 
			break;

#endif
		default: crash(); break;
		}
        //unmask the claimed interrupt
		plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
	}
}


void main() {
    u32 data;
	bsp_init();

#ifdef SYSTEM_AXI_A_BMB

    bsp_print("axi4 slave demo !");

    for (int i=0; i < AXI_SIZE ; i = i + 4 ){
        write_u32(i, AXI + i);
    }

    for (int i=0; i < AXI_SIZE ; i = i + 4 ){
        data = read_u32(AXI + i);
        if(i != data){
            bsp_print("Failed at address 0x");
            bsp_printHex(i);
            bsp_print(" with value 0x");
            bsp_printHex(data);
            error_state();
        }
    }
    bsp_print("Passed!");
    bsp_print("axi4 slave interrupt demo !");
    intr_init();
    // Set 0xABCD to trigger AXI interrupt pin '1'
	write_u32(0xABCD, SYSTEM_AXI_A_BMB);	
    // write 0x0000 to clear AXI interrupt pin to '0'
	write_u32(0x0000, SYSTEM_AXI_A_BMB);	

#else

    bsp_print("axi4 slave is disabled, please enable it to run this app.");

#endif

}

