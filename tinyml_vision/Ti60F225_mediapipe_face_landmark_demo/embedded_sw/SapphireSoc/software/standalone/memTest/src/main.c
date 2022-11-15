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
#include "io.h"

//memory start address
#define mem ((volatile uint32_t*)0x00010000) 
#define MAX_WORDS (4 * 1024 * 1024)

void main() {

    bsp_print("memory test !");
    for(int i=0;i<MAX_WORDS;i++) mem[i] = i;

    for(int i=0;i<MAX_WORDS;i++) {
        if (mem[i] != i) {
        bsp_print("Failed at address 0x");
        bsp_printHex(i);
        bsp_print("with value 0x");
        bsp_printHex(mem[i]);
        while(1){
            }
        }
    }
    bsp_print("Passed");
    while(1){}
}

