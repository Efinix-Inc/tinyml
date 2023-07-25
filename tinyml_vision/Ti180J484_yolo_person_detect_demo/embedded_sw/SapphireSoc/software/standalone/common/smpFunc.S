// This assembly is used to compile the internal bootloader for multicore
.global   smp_unlock
.type    smp_unlock,%function
smp_unlock:
	sw a0, smp_lottery_target, a1
	fence w, w
	li a0, 1
	sw a0, smp_lottery_lock, a1
   ret

.global smp_tyranny
.global smp_slave

smp_tyranny:
  csrr a0, mhartid
  beqz a0, init

smp_slave:
	lw a0, smp_lottery_lock
	beqz a0, smp_slave

	fence r, r
	//li a1, -1
	//amoadd.w x0, a1,(a0)

	.word(0x100F) //i$ flush
	lw a5, smp_lottery_target
	li a0, 0
	li a1, 0
	li a2, 0
	jr a5

.global smp_lottery_target
.global smp_lottery_lock

.bss
.align 2
  smp_lottery_target: .word 0
  smp_lottery_lock:   .word 0
