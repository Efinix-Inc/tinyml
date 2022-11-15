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
#include <stdio.h>
#include "bsp.h"
#include "spi.h"
#include "spiDemo.h"

//userBinary location
#define StartAddress 0x380000	

void init(){
    //SPI init
    Spi_Config spiA;
    spiA.cpol = 1;
    spiA.cpha = 1;
    //Assume full duplex (standard SPI)
    spiA.mode = 0; 
    spiA.clkDivider = 10;
    spiA.ssSetup = 5;
    spiA.ssHold = 5;
    spiA.ssDisable = 5;
    spi_applyConfig(SPI, &spiA);
}

void WaitBusy(void)
{
	u8 out;
	u16 timeout=0;

	while(1)
	{
		bsp_uDelay(1*1000);
		spi_select(SPI, 0);
        //Write Enable
		spi_write(SPI, 0x05);	
		out = spi_read(SPI);
		spi_diselect(SPI, 0);
		if((out & 0x01) ==0x00)
			return;
		timeout++;
        //sector erase max=400ms
		if(timeout >=400)		
		{
			bsp_print("Time out");
			return;
		}
	}
}

void WriteEnableLatch(void)
{
	spi_select(SPI, 0);
    //Write Enable latch
	spi_write(SPI, 0x06);	
	spi_diselect(SPI, 0);
}

void GlobalLock(void)
{
	WriteEnableLatch();
	spi_select(SPI, 0);
    //Global lock
	spi_write(SPI, 0x7E);	
	spi_diselect(SPI, 0);
}

void GlobalUnlock(void)
{
	WriteEnableLatch();
	spi_select(SPI, 0);
    //Global unlock
	spi_write(SPI, 0x98);	
	spi_diselect(SPI, 0);
}

void SectorErase(u32 Addr)
{
	WriteEnableLatch();
	spi_select(SPI, 0);		
    //Erase Sector
	spi_write(SPI, 0x20);
	spi_write(SPI, (Addr>>16)&0xFF);
	spi_write(SPI, (Addr>>8)&0xFF);
	spi_write(SPI, Addr&0xFF);
	spi_diselect(SPI, 0);
	WaitBusy();
}

void main() {
    init();
    int i,len;
    u8 out;
    //page write
    len =256;	
    bsp_print("spi 0 flash write start !");
    GlobalUnlock();
	SectorErase(StartAddress);
	WriteEnableLatch();
    spi_select(SPI, 0);
	spi_write(SPI, 0x02);
	spi_write(SPI, (StartAddress>>16)&0xFF);
	spi_write(SPI, (StartAddress>>8)&0xFF);
	spi_write(SPI, StartAddress&0xFF);
    //Write sequential number for testing
    for(i=0;i<len;i++)			
    {
    	spi_write(SPI, i&0xFF);
    	bsp_print("WR Addr ");
		bsp_printHex(StartAddress+i);
		bsp_print(" : =");
		bsp_printHex(i&0xFF);
    }
    spi_diselect(SPI, 0);
    //wait for page progarm done
    WaitBusy();	
    GlobalLock();
    bsp_print("spi 0 flash write end !");
    while(1){}
}
