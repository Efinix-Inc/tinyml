#include "soc.h"
#include "type.h"
#include "riscv.h"
#include "start.h"
#include "smpDemo.h"
#include "bsp.h"
#include "print.h"

#define SMP_INUSE (HART_COUNT > 1)

//Encryption count for single core processing
#define ENCRYPT_COUNT 4
//Stack space used by smpInit.S to provide stack to secondary harts
u8 hartStack[STACK_PER_HART*HART_COUNT] __attribute__((aligned(16)));

//Used as a syncronization barrier between all threads
volatile u32 hartCounter = 0;
//Flag used by hart 0 to notify the other harts that the "value" variable is loaded
volatile u32 h0_ready = 0;
volatile u32 h1_ready = 0;
volatile u32 h2_ready = 0;
volatile u32 h3_ready = 0;
u32 input1;
u32 input2;
u32 h0_r1,h0_r2;
u32 h1_r1,h1_r2;
u32 h2_r1,h2_r2;
u32 h3_r1,h3_r2;

uint64_t timerCmp0, timerCmp1;

void printPTime(uint64_t ts1, uint64_t ts2, char *s) {
    uint64_t rts;
    rts=ts2-ts1;
    uart_writeStr(BSP_UART_TERMINAL, s);
    print_dec(rts);
    uart_writeStr(BSP_UART_TERMINAL, "\n\n\r");

}

void tiny_algo_encrypter (uint32_t v0, uint32_t v1, uint32_t k[], uint32_t *rv0, uint32_t *rv1) {
    uint32_t sum=0, i;

    uint32_t delta=0x9e3779b9;

    for (i=0; i < 1024; i++) {
        sum += delta;
        v0 += ((v1<<4) + k[0]) ^ (v1 + sum) ^ ((v1>>5) + k[1]);
        v1 += ((v0<<4) + k[2]) ^ (v0 + sum) ^ ((v0>>5) + k[3]);

    }
    *rv0=v0;
    *rv1=v1;
}

#if (SMP_INUSE == 1)

extern void smpInit();
void mainSmp();

__inline__ s32 atomicAdd(s32 *a, u32 increment) {
    s32 old;
    __asm__ volatile(
          "amoadd.w %[old], %[increment], (%[atomic])"
        : [old] "=r"(old)
        : [increment] "r"(increment), [atomic] "r"(a)
        : "memory"
    );
    return old;
}

void mainSmp(){
    u32 hartId = csr_read(mhartid);
    atomicAdd((s32*)&hartCounter, 1);

    while(hartCounter != HART_COUNT);
    //Hart 0 will provide a value to the other harts, other harts wait on it by pulling the "ready" variable
    if(hartId == 0){
        bsp_print("synced!");
        timerCmp0 = clint_getTime(BSP_CLINT);
        input1 = 0xdeadbeaf;
        input2 = 0x42395820;
        asm("fence w,w");
        h0_ready = 1;

        u32 key_h0[4]={0x227C81AA, 0x7AE71DA8, 0x4ACF7AD5, 0x67E57113};
        tiny_algo_encrypter(input1, input2, key_h0, &h0_r1, &h0_r2);

#if (HART_COUNT == 4)
        while(!h1_ready && !h2_ready && !h3_ready);
        asm("fence r,r");
    	timerCmp1 = clint_getTime(BSP_CLINT);
    	printPTime(timerCmp0,timerCmp1,"processing clock cycles:");
        bsp_putString("hart 0 encrypted output A:");bsp_printHex(h0_r1);
        bsp_putString("hart 0 encrypted output B:");bsp_printHex(h0_r2);
        bsp_putString("hart 1 encrypted output A:");bsp_printHex(h1_r1);
        bsp_putString("hart 1 encrypted output B:");bsp_printHex(h1_r2);
        bsp_putString("hart 2 encrypted output A:");bsp_printHex(h2_r1);
        bsp_putString("hart 2 encrypted output B:");bsp_printHex(h2_r2);
        bsp_putString("hart 3 encrypted output A:");bsp_printHex(h3_r1);
        bsp_putString("hart 3 encrypted output B:");bsp_printHex(h3_r2);
#elif (HART_COUNT == 3)
        while(!h1_ready && !h2_ready);
        asm("fence r,r");
    	timerCmp1 = clint_getTime(BSP_CLINT);
    	printPTime(timerCmp0,timerCmp1,"processing clock cycles:");
        bsp_putString("hart 0 encrypted output A:");bsp_printHex(h0_r1);
        bsp_putString("hart 0 encrypted output B:");bsp_printHex(h0_r2);
        bsp_putString("hart 1 encrypted output A:");bsp_printHex(h1_r1);
        bsp_putString("hart 1 encrypted output B:");bsp_printHex(h1_r2);
        bsp_putString("hart 2 encrypted output A:");bsp_printHex(h2_r1);
        bsp_putString("hart 2 encrypted output B:");bsp_printHex(h2_r2);
#else
        while(!h1_ready);
        asm("fence r,r");
    	timerCmp1 = clint_getTime(BSP_CLINT);
    	printPTime(timerCmp0,timerCmp1,"processing clock cycles:");
        bsp_putString("hart 0 encrypted output A:");bsp_printHex(h0_r1);
        bsp_putString("hart 0 encrypted output B:");bsp_printHex(h0_r2);
        bsp_putString("hart 1 encrypted output A:");bsp_printHex(h1_r1);
        bsp_putString("hart 1 encrypted output B:");bsp_printHex(h1_r2);
#endif

    }
    else if(hartId == 1){
    	while(!h0_ready);
    	asm("fence r,r");
    	u32 inp1_h1 = (volatile u32)input1;
    	u32 inp2_h1 = (volatile u32)input2;
    	u32 key_h1[4]={0x248a0135, 0x529C7762, 0x5688593F, 0xF9A7B565};
    	tiny_algo_encrypter(inp1_h1, inp2_h1, key_h1, &h1_r1, &h1_r2);
        asm("fence w,w");
    	h1_ready = 1;
    }
    else if(hartId == 2){
    	while(!h0_ready);
    	asm("fence r,r");
    	u32 inp1_h2 = (volatile u32)input1;
    	u32 inp2_h2 = (volatile u32)input2;
        u32 key_h2[4]={0x3AAE508A, 0xC58CCC20, 0x8CA79D11, 0x038C6414};
        tiny_algo_encrypter(inp1_h2, inp2_h2, key_h2, &h2_r1, &h2_r2);
        asm("fence w,w");
    	h2_ready = 1;
    }
    else if(hartId == 3){
    	while(!h0_ready);
    	asm("fence r,r");
    	u32 inp1_h3 = (volatile u32)input1;
    	u32 inp2_h3 = (volatile u32)input2;
        u32 key_h3[4]={0x248a0135, 0x5BB6136C, 0xC7E9CA03, 0xE4407CF3};
        tiny_algo_encrypter(inp1_h3, inp2_h3, key_h3, &h3_r1, &h3_r2);
        asm("fence w,w");
    	h3_ready = 1;
    }
}

void main() {
    bsp_putString("smpDemo with multiple cpu processing\n\r");
    smp_unlock(smpInit);
    mainSmp();
}
#else
void main() {
	bsp_putString("\nsmpDemo with single cpu processing\n\r");

	u32 key_h0[4]={0x227C81AA, 0x7AE71DA8, 0x4ACF7AD5, 0x67E57113};
	u32 key_h1[4]={0x248a0135, 0x529C7762, 0x5688593F, 0xF9A7B565};
	u32 key_h2[4]={0x3AAE508A, 0xC58CCC20, 0x8CA79D11, 0x038C6414};
	u32 key_h3[4]={0x248a0135, 0x5BB6136C, 0xC7E9CA03, 0xE4407CF3};

    timerCmp0 = clint_getTime(BSP_CLINT);

    input1 = 0xdeadbeaf;
    input2 = 0x42395820;
#if (ENCRYPT_COUNT == 4)
    tiny_algo_encrypter(input1, input2, key_h0, &h0_r1, &h0_r2);
    tiny_algo_encrypter(input1, input2, key_h1, &h1_r1, &h1_r2);
    tiny_algo_encrypter(input1, input2, key_h2, &h2_r1, &h2_r2);
    tiny_algo_encrypter(input1, input2, key_h3, &h3_r1, &h3_r2);
    timerCmp1 = clint_getTime(BSP_CLINT);
	printPTime(timerCmp0, timerCmp1,"processing clock cycles:");
    bsp_putString("1st encrypted output A:");bsp_printHex(h0_r1);
    bsp_putString("1st encrypted output B:");bsp_printHex(h0_r2);
    bsp_putString("2nd encrypted output A:");bsp_printHex(h1_r1);
    bsp_putString("2nd encrypted output B:");bsp_printHex(h1_r2);
    bsp_putString("3rd encrypted output A:");bsp_printHex(h2_r1);
    bsp_putString("3rd encrypted output B:");bsp_printHex(h2_r2);
    bsp_putString("4th encrypted output A:");bsp_printHex(h3_r1);
    bsp_putString("4th encrypted output B:");bsp_printHex(h3_r2);
#elif (ENCRYPT_COUNT == 3)
    tiny_algo_encrypter(input1, input2, key_h0, &h0_r1, &h0_r2);
    tiny_algo_encrypter(input1, input2, key_h1, &h1_r1, &h1_r2);
    tiny_algo_encrypter(input1, input2, key_h2, &h2_r1, &h2_r2);
    timerCmp1 = clint_getTime(BSP_CLINT);
	printPTime(timerCmp0, timerCmp1,"processing clock cycles:");
    bsp_putString("1st encrypted output A:");bsp_printHex(h0_r1);
    bsp_putString("1st encrypted output B:");bsp_printHex(h0_r2);
    bsp_putString("2nd encrypted output A:");bsp_printHex(h1_r1);
    bsp_putString("2nd encrypted output B:");bsp_printHex(h1_r2);
    bsp_putString("3rd encrypted output A:");bsp_printHex(h2_r1);
    bsp_putString("3rd encrypted output B:");bsp_printHex(h2_r2);
#elif (ENCRYPT_COUNT == 2)
    tiny_algo_encrypter(input1, input2, key_h0, &h0_r1, &h0_r2);
    tiny_algo_encrypter(input1, input2, key_h1, &h1_r1, &h1_r2);
    timerCmp1 = clint_getTime(BSP_CLINT);
	printPTime(timerCmp0, timerCmp1,"processing clock cycles:");
    bsp_putString("1st encrypted output A:");bsp_printHex(h0_r1);
    bsp_putString("1st encrypted output B:");bsp_printHex(h0_r2);
    bsp_putString("2nd encrypted output A:");bsp_printHex(h1_r1);
    bsp_putString("2nd encrypted output B:");bsp_printHex(h1_r2);
#else
    tiny_algo_encrypter(input1, input2, key_h0, &h0_r1, &h0_r2);
    timerCmp1 = clint_getTime(BSP_CLINT);
	printPTime(timerCmp0, timerCmp1,"processing clock cycles:");
    bsp_putString("1st encrypted output A:");bsp_printHex(h0_r1);
    bsp_putString("1st encrypted output B:");bsp_printHex(h0_r2);
#endif
}
#endif
