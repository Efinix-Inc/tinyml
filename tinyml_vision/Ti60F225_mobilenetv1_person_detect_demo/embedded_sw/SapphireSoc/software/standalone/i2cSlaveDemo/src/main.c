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
#include "i2c.h"
#include "i2cDemo.h" 

unsigned char addr0=0x00;
unsigned char data0[128];
unsigned char data1[128];

#ifdef SYSTEM_I2C_0_IO_CTRL

void main();
void init();
void trap();
void crash();
void trap_entry();
void externalInterrupt();
void externalInterrupt_i2c();

//I2C interrupt state
enum {
    IDLE,
	Write_Addr_0,
    Read_DATA_0, 
    Read_DATA_1, 
    Write_DATA_0, 
    Write_DATA_1 
} state = IDLE;

void init(){
    //I2C init
    I2c_Config i2c;
    i2c.samplingClockDivider = 3;	    //Number of cycle - 1 between each SDA/SCL sample
    i2c.timeout = I2C_CTRL_HZ/1000;     //1 ms
    i2c.tsuDat  = I2C_CTRL_HZ/2000000;  //500 ns 
    i2c.tLow  = I2C_CTRL_HZ/200000;	    //100khz	
    i2c.tHigh = I2C_CTRL_HZ/200000;	    //100khz	
    i2c.tBuf  = I2C_CTRL_HZ/200000;	    
    i2c_applyConfig(I2C_CTRL, &i2c);
    //0x30 => Address byte = 0x60 | 0x61
    i2c_setFilterConfig(I2C_CTRL, 0, 0x30 | I2C_FILTER_7_BITS | I2C_FILTER_ENABLE); 
    i2c_enableInterrupt(I2C_CTRL, I2C_INTERRUPT_FILTER | I2C_INTERRUPT_DROP);

    //configure PLIC
    plic_set_threshold(BSP_PLIC, BSP_PLIC_CPU_0, 0); 

    //enable PLIC I2C interrupts
    plic_set_enable(BSP_PLIC, BSP_PLIC_CPU_0, I2C_CTRL_PLIC_INTERRUPT, 1);
    plic_set_priority(BSP_PLIC, I2C_CTRL_PLIC_INTERRUPT, 1);

    //configure RISC-V interrupt CSR
    //Set the machine trap vector (trap.S)
    csr_write(mtvec, trap_entry); 
    //Enable machine external interrupts
    csr_write(mie, MIE_MEIE); 
    //Enable interrupts
    csr_write(mstatus, MSTATUS_MPP | MSTATUS_MIE); 

}

void assert(int cond){
    if(!cond) {
        bsp_print("Assert failure");
        while(1);
    }
}

//Called by trap_entry on both exceptions and interrupts events
void trap(){
    int32_t mcause = csr_read(mcause);
    int32_t interrupt = mcause < 0;    
    int32_t cause     = mcause & 0xF;

    if(interrupt){
        switch(cause){
        case CAUSE_MACHINE_EXTERNAL: externalInterrupt(); break;
        default: crash(); break;
        }
    }
    else
    {
      crash();
    }
}

void externalInterrupt(){
    uint32_t claim;
    //While there is pending interrupts
    while(claim = plic_claim(BSP_PLIC, BSP_PLIC_CPU_0)){
        switch(claim){
        case I2C_CTRL_PLIC_INTERRUPT: externalInterrupt_i2c(); break;
        default:crash(); break;
        }
        //unmask the claimed interrupt
        plic_release(BSP_PLIC, BSP_PLIC_CPU_0, claim); 
    }
}

void crash(){
    bsp_print("\n*** CRASH ***\n");
    while(1);
}

//I2C_CTRL handler to manage slave frames
void externalInterrupt_i2c(){
    //Frame drop detected
    if(gpio_getInterruptFlag(I2C_CTRL) & I2C_INTERRUPT_DROP){ 
        state = IDLE;
        i2c_disableInterrupt(I2C_CTRL, I2C_INTERRUPT_CLOCK_GEN_BUSY | I2C_INTERRUPT_TX_ACK | I2C_INTERRUPT_TX_DATA);
        return;
    }

    switch(state){
    case IDLE:
        //I2C filter 0 hit => frame for us
        if(gpio_getFilteringHit(I2C_CTRL) == 1){ 
            //read (0x61)
            if(gpio_getFilteringStatus(I2C_CTRL) == 1){ 
                i2c_txAck(I2C_CTRL);
                // Send First Read Value to Master
                i2c_txByte(I2C_CTRL, data0[addr0]);	
                //Interrupt when the tx data buffer is empty again
                i2c_enableInterrupt(I2C_CTRL, I2C_INTERRUPT_TX_DATA); 
                state = Read_DATA_0;
            } else {
                i2c_txAck(I2C_CTRL);
                i2c_txByte(I2C_CTRL, 0xFF);
                //Interrupt when the tx data buffer is empty again
                i2c_enableInterrupt(I2C_CTRL, I2C_INTERRUPT_TX_DATA); 
                state = Write_Addr_0;
            }
            i2c_clearInterruptFlag(I2C_CTRL, I2C_INTERRUPT_FILTER);
        }
        else
        {
        	crash();
        }

        break;
    //Write frame to us
    case Write_Addr_0:
		i2c_txAck(I2C_CTRL);
		i2c_txByte(I2C_CTRL, 0xFF);
        //Get First Value from Master
		addr0 = i2c_rxData(I2C_CTRL);

        //Write Addr Only(Read Case)
		if(addr0 & 0x80)		
		{
			i2c_disableInterrupt(I2C_CTRL, I2C_INTERRUPT_TX_DATA);
			state = IDLE;
		}
        //Write Continues
		else					
		{
			state = Write_DATA_0;
		}

		addr0&=0x7F;
		break;
    case Write_DATA_0:
        i2c_txAck(I2C_CTRL);
        i2c_txByte(I2C_CTRL, 0xFF);
        //Get First Value from Master
        data0[addr0] = i2c_rxData(I2C_CTRL);
        state = Write_DATA_1;
        break;
    case Write_DATA_1:
        //End of the frame, do not interfere with it anymore
        i2c_txNackRepeat(I2C_CTRL);
        i2c_txByteRepeat(I2C_CTRL, 0xFF);
        //Get Second Value from Master
        data1[addr0] = i2c_rxData(I2C_CTRL);	
        i2c_disableInterrupt(I2C_CTRL, I2C_INTERRUPT_TX_DATA);
        state = IDLE;
        break;
    //Read frame to us
    case Read_DATA_0:
        i2c_txNack(I2C_CTRL);
        // Send Secnond Read Value to Master
        i2c_txByte(I2C_CTRL, data1[addr0]);
        // Expected value
        assert(i2c_rxAck(I2C_CTRL)); 
        state = Read_DATA_1;
        break;
    case Read_DATA_1:
        //End of the frame, do not interfere with it anymore
        i2c_txNackRepeat(I2C_CTRL);
        i2c_txByteRepeat(I2C_CTRL, 0xFF);
        i2c_disableInterrupt(I2C_CTRL, I2C_INTERRUPT_TX_DATA);
        state = IDLE;
        break;
    }

    i2c_enableInterrupt(I2C_CTRL, I2C_INTERRUPT_CLOCK_GEN_BUSY);
}

void main() {
	int n;
    bsp_init();
    for(n=0;n<128;n++)
    {
    	data0[n]=0;
    	data1[n]=0;
    }

    init();
    bsp_print("i2c 0 slave demo !");
    i2c_enableInterrupt(I2C_CTRL, I2C_INTERRUPT_CLOCK_GEN_BUSY);
    i2c_masterDrop(I2C_CTRL);
    bsp_print("i2c 0 init done");
}
#else
void main() {
	int n;
    bsp_init();
    bsp_print("i2c 0 is disabled, please enable it to run this app");
}
#endif
