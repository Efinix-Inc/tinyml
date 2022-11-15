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
#include "soc.h"


    static inline u32 read_u32(u32 address){
        return *((volatile u32*) address);
    }
    
    static inline void write_u32(u32 data, u32 address){
        *((volatile u32*) address) = data;
    }
    
    static inline u16 read_u16(u32 address){
        return *((volatile u16*) address);
    }
    
    static inline void write_u16(u16 data, u32 address){
        *((volatile u16*) address) = data;
    }
    
    static inline u8 read_u8(u32 address){
        return *((volatile u8*) address);
    }
    
    static inline void write_u8(u8 data, u32 address){
        *((volatile u8*) address) = data;
    }
    
    static inline void write_u32_ad(u32 address, u32 data){
        *((volatile u32*) address) = data;
    }
    
    #define writeReg_u32(name, offset) \
    static inline void name(u32 reg, u32 value){ \
        write_u32(value, reg + offset); \
    } \
    
    #define readReg_u32(name, offset) \
    static inline u32 name(u32 reg){ \
        return read_u32(reg + offset); \
    } \






