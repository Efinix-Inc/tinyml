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


/********************************* Function **********************************/
//Used on unexpected trap/interrupt codes


void crash(){
	uart_writeStr(BSP_UART_TERMINAL, "\n*** CRASH ***\n");
	while(1);
}


void userInterrupt(){
    uint32_t claim;
    //While there is pending interrupts
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
       case SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT:ops_drv_intr(); break;
       default: crash(); break;
       }
       plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); //unmask the claimed interrupt
    }
}


//Called by trap_entry on both exceptions and interrupts events
void trap(){
	int32_t mcause = csr_read(mcause);
	int32_t interrupt = mcause < 0;    //Interrupt if true, exception if false
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

// void IntcInitialize()
void dma_init()
{
   plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); //cpu 0 accept all interrupts with priority above 0
   
   //enable PLIC DMASG channel 0 interrupt listening (But for the demo, we enable the DMASG internal interrupts later)
   plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT, 1);
   plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_E_INTERRUPT, 1);
   
    //enable SYSTEM_PLIC_USER_INTERRUPT_A_INTERRUPT rising edge interrupt
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT, 1);
    plic_set_priority(BSP_PLIC, SYSTEM_PLIC_USER_INTERRUPT_D_INTERRUPT, 1);
   
    //enable riscV interrupts
    csr_write(mtvec, trap_entry); //Set the machine trap vector (../common/trap.S)
//  csr_set(mie, MIE_MTIE | MIE_MEIE); //Enable machine timer and external interrupts
    csr_set(mie, MIE_MEIE); //Enable machine timer and external interrupts
	// csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE);
	csr_write(mstatus, csr_read(mstatus) | MSTATUS_MPP | MSTATUS_MIE);
}
