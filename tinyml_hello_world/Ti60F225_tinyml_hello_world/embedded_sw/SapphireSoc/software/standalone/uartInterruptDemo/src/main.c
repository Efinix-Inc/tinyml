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
#include "plic.h"
#include "clint.h"
#include "bsp.h"
#include "riscv.h"

void init();
void main();
void trap();
void crash();
void trap_entry();
void UartInterrupt();

#define UART_A_SAMPLE_PER_BAUD 8
#define CORE_HZ BSP_CLINT_HZ

void init(){
    //UART init
    Uart_Config uartA;
    uartA.dataLength = BITS_8; 
    uartA.parity = NONE;
    uartA.stop = ONE;
    uartA.clockDivider = CORE_HZ/(115200*UART_A_SAMPLE_PER_BAUD)-1;
    uart_applyConfig(BSP_UART_TERMINAL, &uartA);

	// TX FIFO empty interrupt enable
	//uart_TX_emptyInterruptEna(BSP_UART_TERMINAL,1);	
	
	// RX FIFO not empty interrupt enable
    uart_RX_NotemptyInterruptEna(BSP_UART_TERMINAL,1);	

	//configure PLIC
    //cpu 0 accept all interrupts with priority above 0
	plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 

	//enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt
	plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);
	plic_set_priority(BSP_PLIC, SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT, 1);

	//enable interrupts
	csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
	csr_set(mie, MIE_MEIE); //Enable external interrupts
	csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
}

//Called by trap_entry on both exceptions and interrupts events
void trap(){
	int32_t mcause = csr_read(mcause);
    //Interrupt if set, exception if cleared
	int32_t interrupt = mcause < 0;    
	int32_t cause     = mcause & 0xF;

	if(interrupt){
		switch(cause){
		case CAUSE_MACHINE_EXTERNAL: UartInterrupt(); break;
		default: crash(); break;
		}
	} else {
		crash();
	}
}

void UartInterrupt_Sub()
{
	if (uart_status_read(BSP_UART_TERMINAL) & 0x00000100){
        
        bsp_print("\nuart 0 tx fifo empty interrupt routine");
        // TX FIFO empty interrupt Disable
		uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) & 0xFFFFFFFE);	
        // TX FIFO empty interrupt enable
		uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) | 0x01); 
	}
	else if (uart_status_read(BSP_UART_TERMINAL) & 0x00000200){

        bsp_print("\nuart 0 rx fifo not empty interrupt routine");
        // RX FIFO not empty interrupt Disable
		uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) & 0xFFFFFFFD); 			
        //Dummy Read Clear FIFO
		uart_write(BSP_UART_TERMINAL, uart_read(BSP_UART_TERMINAL));	
        // RX FIFO not empty interrupt enable
		uart_status_write(BSP_UART_TERMINAL,uart_status_read(BSP_UART_TERMINAL) | 0x02); 					
	}
}

void UartInterrupt()
{

    uint32_t claim;
	//While there is pending interrupts
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
		switch(claim){
		case SYSTEM_PLIC_SYSTEM_UART_0_IO_INTERRUPT: UartInterrupt_Sub(); break;
		default: crash(); break;
		}
        //unmask the claimed interrupt
		plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
	}
}

void crash(){
	bsp_print("\n*** CRASH ***\n");
	while(1);
}

void main() {
	init();

    bsp_print("uart 0 interrupt demo !");
    bsp_print("start typing on terminal to interrupt uart...");
	while(1){
        while(uart_readOccupancy(BSP_UART_TERMINAL)){
        	uart_write(BSP_UART_TERMINAL, uart_read(BSP_UART_TERMINAL));
		}
	}
}


