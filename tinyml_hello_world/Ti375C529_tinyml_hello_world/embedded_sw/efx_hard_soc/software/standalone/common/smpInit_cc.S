#include "userDef.h"

.global smpInit
.type smpInit, %function
.extern mainSmp  // Declare mainSmp as an external function
smpInit:
    //Initialise the stack of the given hart
    la sp, hartStack
    csrr a0, mhartid
    li a1, STACK_PER_HART
    addi a0, a0, 1
    mul a0, a0, a1
    add sp, sp, a0
    call mainSmp

smpDone:
    j smpDone





