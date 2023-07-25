#ifndef PRINT_H
#define PRINT_H

#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <string.h>
#include "bsp.h"

#if __cplusplus
extern "C" {
#endif
void print_dec(uint32_t val);
void print_float(double val);
void print_hex(u32 val, u32 digits);
void print_hex_digit(u8 digit);
void print_hex_byte(u8 byte);
void print_hex_64(uint64_t val, uint32_t digits);

#if __cplusplus
}
#endif

#endif
