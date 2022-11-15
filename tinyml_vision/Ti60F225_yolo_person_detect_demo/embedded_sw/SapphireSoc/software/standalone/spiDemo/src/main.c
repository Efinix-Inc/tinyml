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

void init(){
    //SPI init
    Spi_Config spiA;
    spiA.cpol = 1;
    spiA.cpha = 1;
    spiA.mode = 0; //Assume full duplex (standard SPI)
    spiA.clkDivider = 10;
    spiA.ssSetup = 5;
    spiA.ssHold = 5;
    spiA.ssDisable = 5;
    spi_applyConfig(SPI, &spiA);
}

void main() {
    init();

    bsp_print("spi 0 demo !");
    spi_select(SPI, 0);
    spi_write(SPI, 0xAB);
    spi_write(SPI, 0x00);
    spi_write(SPI, 0x00);
    spi_write(SPI, 0x00);
    uint8_t id = spi_read(SPI);
    spi_diselect(SPI, 0);
    bsp_print("Device ID : ");
    bsp_printHexByte(id);

    while(1){
        uint8_t data[3];
        spi_select(SPI, 0);
        spi_write(SPI, 0x9F);
        data[0] = spi_read(SPI);
        data[1] = spi_read(SPI);
        data[2] = spi_read(SPI);
        spi_diselect(SPI, 0);
        bsp_print("CMD 0x9F : ");
        bsp_printHexByte(data[0]);
        bsp_printHexByte(data[1]);
        bsp_printHexByte(data[2]);
    }
}

