PROJ_NAME=imgc
STANDALONE = ../../standalone
COMMON = ..

SRCS = $(wildcard src/*.c) \
       $(wildcard src/*.cc) \
       $(wildcard src/*.cpp) \
       $(wildcard src/*.S) \
       $(wildcard src/model/*.cc) \
       $(wildcard src/tensorflow/lite/*.c) \
       $(wildcard src/tensorflow/lite/c/*.c) \
       $(wildcard src/tensorflow/lite/core/api/*.cc) \
       $(wildcard src/tensorflow/lite/kernels/*.cc ) \
       $(wildcard src/tensorflow/lite/kernels/internal/*.cc) \
       $(wildcard src/tensorflow/lite/kernels/internal/optimized/*.cc) \
       $(wildcard src/tensorflow/lite/kernels/internal/reference/*.cc) \
       $(wildcard src/tensorflow/lite/kernels/internal/reference/integer_ops/*.cc) \
       $(wildcard src/tensorflow/lite/micro/*.cc) \
       $(wildcard src/tensorflow/lite/micro/kernels/*.cc) \
       $(wildcard src/tensorflow/lite/micro/memory_planner/*.cc) \
       $(wildcard src/tensorflow/lite/schema/*.cc) \
       ${STANDALONE}/common/start.S  \
       ${STANDALONE}/common/trap.S

CFLAGS += -DOPTIMIZE_X -funroll-loops -mdiv -Isrc  -Isrc \
		 -Isrc/third_party/flatbuffers/include \
		 -Isrc/third_party/gemmlowp \
		 -Isrc/third_party/ruy
CXXFLAGS +=-DOPTIMIZE_X -funroll-loops -mdiv  -Isrc \
	 -Isrc/third_party/flatbuffers/include \
	 -Isrc/third_party/gemmlowp \
	 -Isrc/third_party/ruy
MAKEFLAGS := --jobs=10
include ${COMMON}/common/bsp.mk
include ${COMMON}/common/riscv64-unknown-elf.mk
include ${COMMON}/common/standalone.mk
LIBS += src/model/lib.a