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

#define TIMER_CONFIG    0x00
#define TIMER_LIMIT     0x04
#define TIMER_VALUE     0x08


    readReg_u32 (timer_getConfig       , TIMER_CONFIG)
    writeReg_u32(timer_setConfig       , TIMER_CONFIG)
    
    readReg_u32 (timer_getLimit        , TIMER_LIMIT)
    writeReg_u32(timer_setLimit        , TIMER_LIMIT)
    
    readReg_u32 (timer_getValue        , TIMER_VALUE)
    
    void timer_clearValue(u32 reg){
        write_u32(0, reg + TIMER_VALUE);
    }
