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
//
//  This demo use the I2C peripheral to communicate with a MCP4725 (DAC)
//  It assume it is the single master on the bus, and send frame in a blocking manner.
//
///////////////////////////////////////////////////////////////////////////////////
#include <stdint.h>

#include "bsp.h"
#include "i2c.h"
#include "i2cDemo.h" 

uint32_t phase = 0;

#ifdef SYSTEM_I2C_0_IO_CTRL

void init(){
    //I2C init
    I2c_Config i2c;
    i2c.samplingClockDivider = 3;
    i2c.timeout = I2C_CTRL_HZ/1000;     //1 ms;
    i2c.tsuDat  = I2C_CTRL_HZ/2000000;  //500 ns
    i2c.tLow  = I2C_CTRL_HZ/800000;     //1.25 us
    i2c.tHigh = I2C_CTRL_HZ/800000;     //1.25 us
    i2c.tBuf  = I2C_CTRL_HZ/400000;     //2.5 us
    i2c_applyConfig(I2C_CTRL, &i2c);
}

void main() {
    bsp_init();
    init();
    bsp_print("i2c 0 demo !");
    while(1){
        uint32_t ready;
        uint32_t dacValue = 0;

        //Read the status of the DAC
        i2c_masterStartBlocking(I2C_CTRL);
        i2c_txByte(I2C_CTRL, 0xC1); i2c_txNackBlocking(I2C_CTRL);
        i2c_txByte(I2C_CTRL, 0xFF); i2c_txAckBlocking(I2C_CTRL);
        ready = (i2c_rxData(I2C_CTRL) & 0x80) != 0;
        i2c_txByte(I2C_CTRL, 0xFF); i2c_txAckBlocking(I2C_CTRL);
        dacValue |= i2c_rxData(I2C_CTRL) << 4;
        i2c_txByte(I2C_CTRL, 0xFF); i2c_txNackBlocking(I2C_CTRL);
        dacValue |= i2c_rxData(I2C_CTRL) >> 4;
        i2c_masterStopBlocking(I2C_CTRL);

        //If not busy, write a new DAC value
        if(ready){
            dacValue += 1;
            dacValue &= 0xFFF;
            i2c_masterStartBlocking(I2C_CTRL);
            i2c_txByte(I2C_CTRL, 0xC0); i2c_txNackBlocking(I2C_CTRL);
            i2c_txByte(I2C_CTRL, 0x00 | ((dacValue >> 8) & 0x0F)); i2c_txNackBlocking(I2C_CTRL);
            i2c_txByte(I2C_CTRL, 0x00 | ((dacValue >> 0) & 0xFF)); i2c_txNackBlocking(I2C_CTRL);
            i2c_masterStopBlocking(I2C_CTRL);
            for(uint32_t i = 0;i < 1000;i++)  asm("nop");
        }
    }
}
#else
void main() {
    bsp_init();
    bsp_print("i2c 0 is disabled, please enable it to run this app");
}
#endif





