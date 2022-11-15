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
#include "clint.h"
#include "riscv.h"
#include "gpio.h"
#include "plic.h"

#ifdef SIM
    //Faster timer tick in simulation to avoid having to wait too long
    #define TIMER_TICK_DELAY (SYSTEM_CLINT_HZ/200) 
#else
    #define TIMER_TICK_DELAY (SYSTEM_CLINT_HZ)
#endif

void init();
void main();
void trap();
void crash();
void trap_entry();
void timerInterrupt();
void initTimer();
void scheduleTimer();

//Store the next interrupt time
uint64_t timerCmp; 

void main() {
    init();
    bsp_print("core timer interrupt demo !");
    while(1); //Idle
}

void init(){
    //configure PLIC
    //cpu 0 accept all interrupts with priority above 0
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 
    //configure timer
    initTimer();
    //enable interrupts
    //Set the machine trap vector (../common/trap.S)
    csr_write(mtvec, trap_entry); 
    //Enable machine timer interrupts
    csr_set(mie, MIE_MTIE); 
    csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

void initTimer(){
    timerCmp = clint_getTime(BSP_CLINT);
    scheduleTimer();
}

//Make the timer tick in 1 second. (if yes, then much faster for simulations reasons)
void scheduleTimer(){
    timerCmp += TIMER_TICK_DELAY;
    clint_setCmp(BSP_CLINT, timerCmp, 0);
}

//Called by trap_entry on both exceptions and interrupts events
void trap(){
    int32_t mcause = csr_read(mcause);
    int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
    int32_t cause     = mcause & 0xF;
    if(interrupt){
        switch(cause){
        case CAUSE_MACHINE_TIMER: timerInterrupt(); break;
        default: crash(); break;
        }
    } else {
        crash();
    }
}

void timerInterrupt(){
    static uint32_t counter = 0;
    scheduleTimer();
    bsp_putString("core timer interrupt ");
    bsp_putChar('0' + counter);
    bsp_putChar('\n');
    bsp_putChar('\r');
    if(++counter == 10) counter = 0;
}

//Used on unexpected trap/interrupt codes
void crash(){
    bsp_putString("\n*** CRASH ***\n");
    while(1);
}

