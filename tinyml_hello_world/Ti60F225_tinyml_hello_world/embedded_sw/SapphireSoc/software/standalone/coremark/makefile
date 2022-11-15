PROJ_NAME=coremark
STANDALONE = ..
DEBUG=no
BENCH=yes
CFLAGS += -DITERATIONS=2000

SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp) \
		$(wildcard src/*.S) \
		${STANDALONE}/common/start.S 


include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk
