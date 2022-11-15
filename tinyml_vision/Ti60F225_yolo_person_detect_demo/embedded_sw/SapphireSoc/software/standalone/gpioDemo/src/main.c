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
#include "gpio.h"
#include "clint.h"
#include "plic.h"

#ifdef SIM
    #define LOOP_UDELAY 100
#else
    #define LOOP_UDELAY 100000
#endif

#ifdef SYSTEM_GPIO_0_IO_CTRL
    
    #define GPIO0       SYSTEM_GPIO_0_IO_CTRL

void init();
void main();
void trap();
void crash();
void trap_entry();
void externalInterrupt();

void init(){
    //configure PLIC
    //cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_GPIO_0_IO_INTERRUPTS_0, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_GPIO_0_IO_INTERRUPTS_0, 1);
    //Enable rising edge interrupts
    gpio_setInterruptRiseEnable(GPIO0, 1); 
    //enable interrupts
    //Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry); 
    //Enable external interrupts
    csr_set(mie, MIE_MEIE); 
    csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

//Called by trap_entry on both exceptions and interrupts events
void trap(){
    int32_t mcause = csr_read(mcause);
    int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
    int32_t cause     = mcause & 0xF;
    if(interrupt){
        switch(cause){
        case CAUSE_MACHINE_EXTERNAL: externalInterrupt(); break;
        default: crash(); break;
        }
    } else {
        crash();
    }
}

void externalInterrupt(){
    uint32_t claim;
    //While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
        case SYSTEM_PLIC_SYSTEM_GPIO_0_IO_INTERRUPTS_0: bsp_print("gpio 0 interrupt routine"); break;
        default: crash(); break;
        }
        //unmask the claimed interrupt
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
    }
}

//Used on unexpected trap/interrupt codes
void crash(){
    bsp_print("\n*** CRASH ***\n");
    while(1);
}

void main() {
    bsp_init();
    bsp_print("gpio 0 demo !");
    bsp_print("onboard LEDs blinking");
    //configure 4 bits gpio 0
    gpio_setOutputEnable(GPIO0, 0xe);
    gpio_setOutput(GPIO0, 0x0);
    for (int i=0; i<50; i=i+1) {
        gpio_setOutput(GPIO0, gpio_getOutput(GPIO0) ^ 0xe);
        bsp_uDelay(LOOP_UDELAY);
    }   
    bsp_print("gpio 0 interrupt demo !");
    bsp_print("Ti60 press and release onboard button sw6");
    bsp_print("T120 press and release onboard button sw7");
    init();
    while(1); 
}
#else
void main() {
    bsp_init();
    bsp_print("gpio 0 is disabled, please enable it to run this app.\n\r");
}
#endif

