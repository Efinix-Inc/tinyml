#include "../../platform/interrupt/intc.h"

#include <stdint.h>
#include "riscv.h"
#include "plic.h"
#include "bsp.h"
#include "platform/tinyml/ops/ops_api.h"

/********************************* Variable Instantiation ********************/

//For DMA interrupt
uint8_t cam_s2mm_active=0;
uint8_t display_mm2s_active=0;

#define DMASG_BASE            IO_APB_SLAVE_0_INPUT
#define PLIC_DMASG_CHANNEL    SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT



void trap_entry();
void trigger_next_display_dma();
void trigger_next_cam_dma();



#include <stdint.h>
#include "riscv.h"
#include "plic.h"
#include "bsp.h"
#include "platform/tinyml/ops/ops_api.h"

#include "../../platform/interrupt/intc.h"
/********************************* Variable Instantiation ********************/


/********************************* Function **********************************/
//Used on unexpected trap/interrupt codes

void crash0(){
	uart_writeStr(BSP_UART_TERMINAL, "\n*** CPU0 CRASH ***\n");
	while(1);
}
void crash1(){
	uart_writeStr(BSP_UART_TERMINAL, "\n*** CPU1 CRASH ***\n");
	while(1);
}void crash2(){
	uart_writeStr(BSP_UART_TERMINAL, "\n*** CPU2 CRASH ***\n");
	while(1);
}void crash3(){
	uart_writeStr(BSP_UART_TERMINAL, "\n*** CPU3 CRASH ***\n");
	while(1);
}


void userInterrupt0(){
	uint32_t claim;
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
		switch(claim){
	   case SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT: //DMA channels share single interrupt
		  if(cam_s2mm_active && !(dmasg_busy(DMASG_BASE, DMASG_CAM_S2MM_CHANNEL))) {
			 trigger_next_cam_dma();
		  }
		  if(display_mm2s_active && !(dmasg_busy(DMASG_BASE, DMASG_DISPLAY_MM2S_CHANNEL))){
			 trigger_next_box_dma();
			 trigger_next_display_dma();
		  }
		  break;
		case BSP_INIT_CHANNEL_0:
			ops_drv_intr();
			break;

		default: crash0(); break;}
	plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
	}

}

void userInterrupt1(){
	uint32_t claim;
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_1)){
		switch(claim){
		case BSP_INIT_CHANNEL_1:
			ops_drv_intr();
			break;

		default: crash1(); break;}
	plic_release(BSP_PLIC, BSP_PLIC_CPU_1, claim); //unmask the claimed interrupt
	}

}
void userInterrupt2(){
	uint32_t claim;
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_2)){
		switch(claim){
		case BSP_INIT_CHANNEL_2:
			ops_drv_intr();
			break;

		default: crash2(); break;}
	plic_release(BSP_PLIC, BSP_PLIC_CPU_2, claim); //unmask the claimed interrupt
	}

}

void userInterrupt3(){
	uint32_t claim;
	while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_3)){
		switch(claim){
		case BSP_INIT_CHANNEL_3:
			ops_drv_intr();
			break;

		default: crash3(); break;}
	plic_release(BSP_PLIC, BSP_PLIC_CPU_3, claim); //unmask the claimed interrupt
	}

}





//Called by trap_entry on both exceptions and interrupts events
void trap(){
	u32 hartId = csr_read(mhartid);
	if(hartId == 0){
		int32_t mcause = csr_read(mcause);
		int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
		int32_t cause     = mcause & 0xF;
		if(interrupt){
			switch(cause){
			case CAUSE_MACHINE_EXTERNAL: userInterrupt0(); break;
			default: crash0(); break;
			}
		} else {
			crash0();
		}
	}
	else if(hartId == 1){
		int32_t mcause = csr_read(mcause);
		int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
		int32_t cause     = mcause & 0xF;
		if(interrupt){
			switch(cause){
			case CAUSE_MACHINE_EXTERNAL: userInterrupt1(); break;
			default: crash1(); break;
			}
		} else {
			crash1();
		}
	}
	else if(hartId == 2){
		int32_t mcause = csr_read(mcause);
		int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
		int32_t cause     = mcause & 0xF;
		if(interrupt){
			switch(cause){
			case CAUSE_MACHINE_EXTERNAL: userInterrupt2(); break;
			default: crash2(); break;
			}
		} else {
			crash2();
		}
	}
	else if(hartId == 3){
		int32_t mcause = csr_read(mcause);
		int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
		int32_t cause     = mcause & 0xF;
		if(interrupt){
			switch(cause){
			case CAUSE_MACHINE_EXTERNAL: userInterrupt3(); break;
			default: crash3(); break;
			}
		} else {
			crash3();
		}
	}


}

void  IntcInitialize(uint32_t core, uint32_t channel)
{
	//configure PLIC
	plic_set_threshold(BSP_PLIC, core, 0); //cpu 0 accept all interrupts with priority above 0

	//enable SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT rising edge interrupt
	plic_set_enable(BSP_PLIC, core, channel, 1);
	plic_set_priority(BSP_PLIC, channel, 1);

	//enable riscV interrupts
	csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
//	csr_set(mie, MIE_MTIE | MIE_MEIE); //Enable machine timer and external interrupts
	csr_set(mie, MIE_MEIE); //Enable machine timer and external interrupts
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
}

void dma_init()
{
   plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); //cpu 0 accept all interrupts with priority above 0

   //enable PLIC DMASG channel 0 interrupt listening (But for the demo, we enable the DMASG internal interrupts later)
   plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT, 1);
   plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT, 1);
   
    //enable riscV interrupts
    csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
//  csr_set(mie, MIE_MTIE | MIE_MEIE); //Enable machine timer and external interrupts
    csr_set(mie, MIE_MEIE); //Enable machine timer and external interrupts
    csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);

}

