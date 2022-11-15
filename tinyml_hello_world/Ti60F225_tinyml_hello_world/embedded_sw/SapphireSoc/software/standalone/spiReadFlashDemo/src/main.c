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
#include "spi.h"
#include "spiDemo.h"

//User Binary Location
#define StartAddress 	0x380000	
//Read size
#define ReadSize	    124*1024	

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

void main() {
    init();
    int i,len;
    len = ReadSize;

    bsp_print("spi 0 flash read start !");

    for(i=StartAddress;i<StartAddress+len;i++)
    {
		spi_select(SPI, 0);
		spi_write(SPI, 0x03);
		spi_write(SPI, (i>>16)&0xFF);
		spi_write(SPI, (i>>8)&0xFF);
		spi_write(SPI, i&0xFF);
		uint8_t out = spi_read(SPI);
		spi_diselect(SPI, 0);
		bsp_print("Addr");
		bsp_printHex(i);
		bsp_print(" : =");
		bsp_printHex(out);
    }
    bsp_print("spi 0 flash read end !");
    while(1){}
}
