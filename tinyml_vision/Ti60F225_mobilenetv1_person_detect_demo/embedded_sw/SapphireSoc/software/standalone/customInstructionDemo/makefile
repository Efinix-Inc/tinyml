PROJ_NAME=customInstructionDemo
STANDALONE = ..

DEBUG?=yes
DEBUG_OG?=yes

SRCS = 	$(wildcard src/*.c) \
		$(wildcard src/*.cpp) \
		$(wildcard src/*.S) \
		${STANDALONE}/common/start.S


include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/riscv64-unknown-elf.mk
include ${STANDALONE}/common/standalone.mk
