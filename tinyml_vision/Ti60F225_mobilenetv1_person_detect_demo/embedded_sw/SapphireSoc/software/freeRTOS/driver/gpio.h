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
#pragma once

#include "type.h"
#include "io.h"

#define GPIO_INPUT                  0x00
#define GPIO_OUTPUT                 0x04
#define GPIO_OUTPUT_ENABLE          0x08
#define GPIO_INTERRUPT_RISE_ENABLE  0x20
#define GPIO_INTERRUPT_FALL_ENABLE  0x24
#define GPIO_INTERRUPT_HIGH_ENABLE  0x28
#define GPIO_INTERRUPT_LOW_ENABLE   0x2c


    readReg_u32 (gpio_getInput               , GPIO_INPUT)
    readReg_u32 (gpio_getOutput              , GPIO_OUTPUT)
    writeReg_u32(gpio_setOutput              , GPIO_OUTPUT)
    readReg_u32 (gpio_getOutputEnable        , GPIO_OUTPUT_ENABLE)
    writeReg_u32(gpio_setOutputEnable        , GPIO_OUTPUT_ENABLE)
    
    writeReg_u32(gpio_setInterruptRiseEnable , GPIO_INTERRUPT_RISE_ENABLE)
    writeReg_u32(gpio_setInterruptFallEnable , GPIO_INTERRUPT_FALL_ENABLE)
    writeReg_u32(gpio_setInterruptHighEnable , GPIO_INTERRUPT_HIGH_ENABLE)
    writeReg_u32(gpio_setInterruptLowEnable  , GPIO_INTERRUPT_LOW_ENABLE)
