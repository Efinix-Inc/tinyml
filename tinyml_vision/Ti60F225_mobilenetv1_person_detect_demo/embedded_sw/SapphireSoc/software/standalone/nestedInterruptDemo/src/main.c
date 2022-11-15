///////////////////////////////////////////////////////////////////////////////////
//  MIT License
//  
//  Copyright (c) 2022 SaxonSoc contributors
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
///////////////////////////////////////////////////////////////////////////////////
#include <stdint.h>
#include "bsp.h"
#include "prescaler.h"
#include "timer.h"
#include "nestedInterruptDemo.h"
#include "riscv.h"
#include "plic.h"


#if defined(SYSTEM_USER_TIMER_0_CTRL) && defined(SYSTEM_USER_TIMER_1_CTRL)

    #define TIMER_CONFIG_WITH_PRESCALER     0x2
    #define TIMER_CONFIG_WITHOUT_PRESCALER  0x1
    #define TIMER_CONFIG_SELF_RESTART       0x10000

    #define TIMER_0_PRESCALER_CTRL          (TIMER_CTRL_0 + 0x00)
    #define TIMER_0_CTRL                    (TIMER_CTRL_0 + 0x40)

    #define TIMER_1_PRESCALER_CTRL          (TIMER_CTRL_1 + 0x00)
    #define TIMER_1_CTRL                    (TIMER_CTRL_1 + 0x40)


#ifdef SIM
    //Faster timer tick in simulation to avoid having to wait too long
    #define TIMER_TICK_DELAY (BSP_CLINT_HZ/200) 
#else
    #define TIMER_TICK_DELAY (BSP_CLINT_HZ)
#endif


void init();
void main();
void trap();
void crash();
void trap_entry();
void timerInterrupt();
void externalInterrupt();
void initTimer();


void init(){
    //configure timer
    initTimer();

    //configure PLIC
    //cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 

    //enable Timer 0 interrupts
    //priority 2 win against priority 1
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_TIMER_INTERRUPTS_0, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_TIMER_INTERRUPTS_0, 2);  
    //enable Timer 1 interrupts
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_TIMER_INTERRUPTS_1, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_TIMER_INTERRUPTS_1, 1);
    //enable interrupts
    //Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry); 
    //Enable external interrupts only
    csr_set(mie, MIE_MEIE); 
    csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

uint64_t timerCmp; //Store the next interrupt time


void initTimer(){
    //Divide clock rate by 99+1
    prescaler_setValue(TIMER_0_PRESCALER_CTRL, 99); 
    
    // Will tick each (999+1)*(99+1) cycles (as it use the prescaler)
    timer_setConfig(TIMER_0_CTRL, TIMER_CONFIG_WITH_PRESCALER | TIMER_CONFIG_SELF_RESTART);
    timer_setLimit(TIMER_0_CTRL, 999); 
    // Will tick each (999+1)*(249+1) cycles (as it use the prescaler)
    prescaler_setValue(TIMER_1_PRESCALER_CTRL, 249); 
    timer_setConfig(TIMER_1_CTRL, TIMER_CONFIG_WITH_PRESCALER);
    timer_setLimit(TIMER_1_CTRL, 999); 
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

    // Save the Machine Exception Programme Counter to be able to restore it in case a higher priority interrupt happen
    u32 epc = csr_read(mepc);                                     
    // Save it to restore it later
    u32 threshold = plic_get_threshold(BSP_PLIC, BSP_PLIC_CPU_0); 

    //While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        // Identify which priority level the current claimed interrupt is
        u32 priority = plic_get_priority(BSP_PLIC, claim);            
        // Enable only the interrupts which higher priority than the currently claimed one.
        plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, priority);       
        // enable machine external interrupts
        csr_set(mstatus, MSTATUS_MIE);                                
        switch(claim){
        case SYSTEM_PLIC_TIMER_INTERRUPTS_0: {
            bsp_putString("T0S-HP\n\r");
            bsp_putString("T0E-HP\n\r");
        }  break;
        case SYSTEM_PLIC_TIMER_INTERRUPTS_1: {
            bsp_putString("T1S\n");
            //User delay
            for(int i = 0;i < 50000;i++) asm("nop"); 
            bsp_putString("T1E\n\r");
            //That timer wasn't configured with self restart, require to do it manually.
            timer_clearValue(TIMER_1_CTRL); 
        } break;
        default: crash(); break;
        }
        // disable machine external interrupts
        csr_clear(mstatus, MSTATUS_MIE);                              
        // Restore the original threshold level
        plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, threshold); 
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
    }
    //Restore the mepc, in case it was overwritten by a nested interrupt
    csr_write(mepc, epc); 
}

//Used on unexpected trap/interrupt codes
void crash(){
    bsp_print("\n*** CRASH ***\n");
    while(1);
}

void main() {
    bsp_init();
    init();
    bsp_print("nested interrupt demo !");
    while(1); 
}
#else
void trap(){
}

void main() {
    bsp_init();
    bsp_print("This demo requires user timer 0 and user timer 1, please enable them to run this app");
}
#endif
