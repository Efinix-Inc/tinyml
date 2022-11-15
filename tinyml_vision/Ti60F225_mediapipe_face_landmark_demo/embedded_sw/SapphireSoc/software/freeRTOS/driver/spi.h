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

#define SPI_DATA        0x00
#define SPI_BUFFER      0x04
#define SPI_CONFIG      0x08
#define SPI_INTERRUPT   0x0C
#define SPI_CLK_DIVIDER 0x20
#define SPI_SS_SETUP    0x24
#define SPI_SS_HOLD     0x28
#define SPI_SS_DISABLE  0x2C
#define SPI_CMD_WRITE   (1 << 8)
#define SPI_CMD_READ    (1 << 9)
#define SPI_CMD_SS      (1 << 11)
#define SPI_RSP_VALID   (1 << 31)
#define SPI_STATUS_CMD_INT_ENABLE = (1 << 0)
#define SPI_STATUS_RSP_INT_ENABLE = (1 << 1)
#define SPI_STATUS_CMD_INT_FLAG = (1 << 8)
#define SPI_STATUS_RSP_INT_FLAG = (1 << 9)
#define SPI_MODE_CPOL   (1 << 0)
#define SPI_MODE_CPHA   (1 << 1)


    typedef struct {
        u32 cpol;
        u32 cpha;
        u32 mode;
        u32 clkDivider;
        u32 ssSetup;
        u32 ssHold;
        u32 ssDisable;
    } Spi_Config;
    
    static u32 spi_cmdAvailability(u32 reg){
        return read_u32(reg + SPI_BUFFER) & 0xFFFF;
    }
    static u32 spi_rspOccupancy(u32 reg){
        return read_u32(reg + SPI_BUFFER) >> 16;
    }
    
    static void spi_write(u32 reg, u8 data){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(data | SPI_CMD_WRITE, reg + SPI_DATA);
    }
    
    static u8 spi_read(u32 reg){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(SPI_CMD_READ, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
        return read_u32(reg + SPI_DATA);
    }
    
    static u8 spi_writeRead(u32 reg, u8 data){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(data | SPI_CMD_READ | SPI_CMD_WRITE, reg + SPI_DATA);
        while(spi_rspOccupancy(reg) == 0);
        return read_u32(reg + SPI_DATA);
    }
    
    static void spi_select(u32 reg, u32 slaveId){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(slaveId | 0x80 | SPI_CMD_SS, reg + SPI_DATA);
    }
    
    static void spi_diselect(u32 reg, u32 slaveId){
        while(spi_cmdAvailability(reg) == 0);
        write_u32(slaveId | 0x00 | SPI_CMD_SS, reg + SPI_DATA);
    }
    
    static void spi_applyConfig(u32 reg, Spi_Config *config){
        write_u32((config->cpol << 0) | (config->cpha << 1) | (config->mode << 4), reg + SPI_CONFIG);
        write_u32(config->clkDivider, reg + SPI_CLK_DIVIDER);
        write_u32(config->ssSetup, reg + SPI_SS_SETUP);
        write_u32(config->ssHold, reg + SPI_SS_HOLD);
        write_u32(config->ssDisable, reg + SPI_SS_DISABLE);
    }

