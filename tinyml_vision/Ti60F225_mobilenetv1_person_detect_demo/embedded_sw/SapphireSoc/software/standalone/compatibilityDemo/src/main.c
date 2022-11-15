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
//
//  Insert "compatibility.h" to have backward compatible with 
//  sapphireSoC v1.1 application
//
////////////////////////////////////////////////////////////////////////////////
#include <stdint.h>
#include "bsp.h"
#include "compatibility.h"
#include "riscv.h"
#include "gpio.h"
#include "plic.h"

#define PLIC_GPIO_A_0 SYSTEM_PLIC_SYSTEM_GPIO_0_IO_INTERRUPTS_0
#define GPIO_A SYSTEM_GPIO_A_APB

void init();
void main();
void trap();
void crash();
void trap_entry();
void timerInterrupt();
void externalInterrupt();
void initTimer();
void scheduleTimer();

#ifdef SIM
    //Faster timer tick in simulation to avoid having to wait too long
    #define TIMER_TICK_DELAY (BSP_MACHINE_TIMER_HZ/200) 
#else
    #define TIMER_TICK_DELAY (BSP_MACHINE_TIMER_HZ)
#endif

void main() {
    init();
    bsp_putString("Hello world\n\r");
    while(1); //Idle
}


void init(){
    //configure PLIC
    //cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 

#ifdef SYSTEM_GPIO_0_IO_APB
    //enable GPIO_A pin 0 rising edge interrupt
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, PLIC_GPIO_A_0, 1);
    plic_set_priority(BSP_PLIC, PLIC_GPIO_A_0, 1);
    //Enable pin 1 rising edge interrupts
    gpio_setInterruptRiseEnable(GPIO_A, 1); 
#endif
    //configure timer
    initTimer();

    //enable interrupts
    //Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry); 
    //Enable machine timer and external interrupts
    csr_set(mie, MIE_MTIE | MIE_MEIE); 
    csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

//Store the next interrupt time
uint64_t timerCmp; 

void initTimer(){
    timerCmp = machineTimer_getTime(BSP_MACHINE_TIMER);
    scheduleTimer();
}

//Make the timer tick in 1 second. (if SPINAL_SIM=yes, then much faster for simulations reasons)
void scheduleTimer(){
    timerCmp += TIMER_TICK_DELAY;
    machineTimer_setCmp(BSP_MACHINE_TIMER, timerCmp);
}

//Called by trap_entry on both exceptions and interrupts events
void trap(){
    int32_t mcause = csr_read(mcause);
    //Interrupt if true, exception if false
    int32_t interrupt = mcause < 0;    
    int32_t cause     = mcause & 0xF;
    if(interrupt){
        switch(cause){
        case CAUSE_MACHINE_TIMER: timerInterrupt(); break;
#ifdef SYSTEM_GPIO_0_IO_APB
        case CAUSE_MACHINE_EXTERNAL: externalInterrupt(); break;
#endif
        default: crash(); break;
        }
    } else {
        crash();
    }
}

void timerInterrupt(){
    static uint32_t counter = 0;
    scheduleTimer();
    bsp_putString("BSP_MACHINE_TIMER ");
    bsp_putChar('0' + counter);
    bsp_putChar('\n');
    bsp_putChar('\r');
    if(++counter == 10) counter = 0;
}

#ifdef SYSTEM_GPIO_0_IO_APB
void externalInterrupt(){
    uint32_t claim;
    //While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
        case PLIC_GPIO_A_0: bsp_putString("PLIC_GPIO_A_0\n\r"); break;
        default: crash(); break;
        }
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
    }
}
#endif

//Used on unexpected trap/interrupt codes
void crash(){
    bsp_putString("\n*** CRASH ***\n");
    while(1);
}
