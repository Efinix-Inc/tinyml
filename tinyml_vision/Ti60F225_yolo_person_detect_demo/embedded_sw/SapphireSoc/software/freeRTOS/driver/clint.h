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

#define CLINT_IPI_ADDR      0x0000
#define CLINT_CMP_ADDR      0x4000
#define CLINT_TIME_ADDR     0xBFF8

    readReg_u32 (clint_getTimeLow , CLINT_TIME_ADDR)
    readReg_u32 (clint_getTimeHigh, CLINT_TIME_ADDR+4)
    
    static void clint_setCmp(u32 p, u64 cmp, u32 hart_id) {
        p += CLINT_CMP_ADDR + hart_id*8;
        write_u32(0xFFFFFFFF, p + 4);
        write_u32(cmp, p + 0);
        write_u32(cmp >> 32, p + 4);
    }
    
    static u64 clint_getTime(u32 p){
        u32 lo, hi;
    
        /* Likewise, must guard against rollover when reading */
        do {
            hi = clint_getTimeHigh(p);
            lo = clint_getTimeLow(p);
        } while (clint_getTimeHigh(p) != hi);
    
        return (((u64)hi) << 32) | lo;
    }
    
    static void clint_uDelay(u32 usec, u32 hz, u32 reg){
        u32 mTimePerUsec = hz/1000000;
        u32 limit = clint_getTimeLow(reg) + usec*mTimePerUsec;
        while((int32_t)(limit-(clint_getTimeLow(reg))) >= 0);
    }




