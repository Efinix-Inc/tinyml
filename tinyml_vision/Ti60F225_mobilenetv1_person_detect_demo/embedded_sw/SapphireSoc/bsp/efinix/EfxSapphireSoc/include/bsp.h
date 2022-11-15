#pragma once

//#include <stdarg.h>
//#include <stdint.h>
#include "soc.h"
#include "uart.h"
#include "clint.h"
#include "io.h"
#include "type.h"

#define BSP_PLIC SYSTEM_PLIC_CTRL
#define BSP_PLIC_CPU_0 SYSTEM_PLIC_SYSTEM_CORES_0_EXTERNAL_INTERRUPT
#define BSP_CLINT SYSTEM_CLINT_CTRL
#define BSP_CLINT_HZ SYSTEM_CLINT_HZ
#define BSP_UART_TERMINAL SYSTEM_UART_0_IO_CTRL

//backward compability 
#define BSP_MACHINE_TIMER SYSTEM_CLINT_CTRL
#define BSP_MACHINE_TIMER_HZ SYSTEM_CLINT_HZ 
#define machineTimer_setCmp(p, cmp) clint_setCmp(p, cmp, 0);
#define machineTimer_getTime(p) clint_getTime(p);
#define machineTimer_uDelay(usec, hz, reg) clint_uDelay(usec, hz, reg);

#define bsp_init() {}
#define bsp_putChar(c) uart_write(BSP_UART_TERMINAL, c);
#define bsp_uDelay(usec) clint_uDelay(usec, SYSTEM_CLINT_HZ, SYSTEM_CLINT_CTRL);
#define bsp_putString(s) uart_writeStr(BSP_UART_TERMINAL, s);

// Freertos specifics
#define configMTIME_BASE_ADDRESS        (BSP_CLINT + 0xBFF8)
#define configMTIMECMP_BASE_ADDRESS     (BSP_CLINT + 0x4000)
#define configCPU_CLOCK_HZ              ( ( uint32_t ) ( BSP_CLINT_HZ ) )
#define BSP_LED_GPIO                    SYSTEM_GPIO_0_IO_CTRL
#define BSP_LED_MASK                    0xf

    static void bsp_printHex(uint32_t val)
    {
        uint32_t digits;
        digits =8;

        for (int i = (4*digits)-4; i >= 0; i -= 4) {
            uart_write(BSP_UART_TERMINAL, "0123456789ABCDEF"[(val >> i) % 16]);
        }
        uart_write(BSP_UART_TERMINAL, '\n');
        uart_write(BSP_UART_TERMINAL, '\r');
    }
    
    static void bsp_print(uint8_t * data) {
        uart_writeStr(BSP_UART_TERMINAL, (const char*)data);
        uart_write(BSP_UART_TERMINAL, '\n');
        uart_write(BSP_UART_TERMINAL, '\r');
    }

    static void bsp_printHexDigit(uint8_t digit){
        uart_write(BSP_UART_TERMINAL, digit < 10 ? '0' + digit : 'A' + digit - 10);
    }

    static void bsp_printHexByte(uint8_t byte){
        bsp_printHexDigit(byte >> 4);
        bsp_printHexDigit(byte & 0x0F);
    }

    static void bsp_printReg(char* s, u32 data)
    {
        bsp_putString(s);
        bsp_printHex(data);
    }

