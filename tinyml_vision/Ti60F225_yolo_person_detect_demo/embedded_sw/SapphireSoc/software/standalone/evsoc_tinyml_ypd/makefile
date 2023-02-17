PROJ_NAME=evsoc_tinyml_ypd
STANDALONE = ..

SRCS = $(wildcard src/*.c) \
       $(wildcard src/*.cc) \
       $(wildcard src/*.cpp) \
       $(wildcard src/*.S) \
       $(wildcard src/model/*.cc) \
       $(wildcard src/platform/*/*.cc) \
       $(wildcard src/platform/*/*.c) \
       $(wildcard src/platform/*/*/*.cc) \
       $(wildcard src/platform/*/*/*.c) \
       $(wildcard src/tests/*.c) \
       $(wildcard src/tests/*.cc) \
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

CFLAGS += -DOPTIMIZE_X -funroll-loops -mdiv -I. -Isrc -Isrc/platform -Isrc/platform/interrupt  -Isrc/platform/vision -Isrc/platform/misc -Isrc/platform/tinyml \
		-Isrc/tensorflow/third_party/flatbuffers/include \
		-Isrc/tensorflow/third_party/gemmlowp \
		-Isrc/tensorflow/third_party/ruy \
		-ffunction-sections \
		-fdata-sections \
		-fno-common \
		-fomit-frame-pointer \
		-ffreestanding \
		-Wsign-compare\
		-Wdouble-promotion\
		-Wshadow\
		-Wmissing-field-initializers\
		-Wunused-function\
		-Wswitch\
		-Wvla\
	    -DTF_LITE_STATIC_MEMORY\
		-DTF_LITE_USE_GLOBAL_CMATH_FUNCTIONS\
		-DTF_LITE_USE_GLOBAL_MIN\
		-DTF_LITE_USE_GLOBAL_MAX \
		-DTF_LITE_DISABLE_X86_NEON\
		-g \
		-O3 \
		-fno-builtin
		 
CXXFLAGS +=-DOPTIMIZE_X -funroll-loops -mdiv -I. -Isrc -Isrc/platform -Isrc/platform/interrupt  -Isrc/platform/vision -Isrc/platform/misc -Isrc/platform/tinyml \
		-Isrc/tensorflow/third_party/flatbuffers/include \
		-Isrc/tensorflow/third_party/gemmlowp \
		-Isrc/tensorflow/third_party/ruy \
		-ffunction-sections \
		-fdata-sections \
		-fno-common \
		-fomit-frame-pointer \
		-ffreestanding \
		-Wsign-compare\
		-Wdouble-promotion\
		-Wshadow\
		-Wmissing-field-initializers\
		-Wunused-function\
		-Wswitch\
		-Wvla\
	    	-DTF_LITE_STATIC_MEMORY \
	    	-DTF_LITE_STATIC_MEMORY \
		-DTF_LITE_USE_GLOBAL_CMATH_FUNCTIONS \
		-DTF_LITE_USE_GLOBAL_MIN \
		-DTF_LITE_USE_GLOBAL_MAX  \
		-DTF_LITE_DISABLE_X86_NEON \
		-g \
		-O3 \
		-fno-builtin \
		-std=c++11 \
		-fstrict-aliasing \
		-fno-rtti \
		-fno-exceptions \
		-fno-threadsafe-statics\
		-fmessage-length=0 
				 
include ${STANDALONE}/common/bsp.mk
include ${STANDALONE}/common/tinyml_riscv64-unknown-elf.mk
include ${STANDALONE}/common/tinyml_standalone.mk

LIBS+=${STANDALONE}/common/tinyml_lib.a
