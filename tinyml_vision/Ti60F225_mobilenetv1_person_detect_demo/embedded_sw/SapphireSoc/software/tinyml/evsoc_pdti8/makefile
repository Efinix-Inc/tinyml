PROJ_NAME=evsoc_pdti8
STANDALONE = ../../standalone
COMMON = ..

SRCS = $(wildcard *.c) \
       $(wildcard *.cc) \
       $(wildcard *.cpp) \
       $(wildcard *.S) \
       $(wildcard model/*.cc) \
       $(wildcard platform/*/*.cc) \
       $(wildcard platform/*/*.c) \
       $(wildcard platform/*/*/*.cc) \
       $(wildcard platform/*/*/*.c) \
       $(wildcard tests/*.c) \
       $(wildcard tests/*.cc) \
       $(wildcard tensorflow/lite/*.c) \
       $(wildcard tensorflow/lite/c/*.c) \
       $(wildcard tensorflow/lite/core/api/*.cc) \
       $(wildcard tensorflow/lite/kernels/*.cc ) \
       $(wildcard tensorflow/lite/kernels/internal/*.cc) \
       $(wildcard tensorflow/lite/kernels/internal/optimized/*.cc) \
       $(wildcard tensorflow/lite/kernels/internal/reference/*.cc) \
       $(wildcard tensorflow/lite/kernels/internal/reference/integer_ops/*.cc) \
       $(wildcard tensorflow/lite/micro/*.cc) \
       $(wildcard tensorflow/lite/micro/kernels/*.cc) \
       $(wildcard tensorflow/lite/micro/memory_planner/*.cc) \
       $(wildcard tensorflow/lite/schema/*.cc) \
       ${STANDALONE}/common/start.S  \
       ${STANDALONE}/common/trap.S

CFLAGS += -DOPTIMIZE_X -funroll-loops -mdiv -I.  -Iplatform -Iplatform/interrupt  -Iplatform/vision -Iplatform/misc -Iplatform/tinyml \
		-Itensorflow/third_party/flatbuffers/include \
		-Itensorflow/third_party/gemmlowp \
		-Itensorflow/third_party/ruy \
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
		 
CXXFLAGS +=-DOPTIMIZE_X -funroll-loops -mdiv -I. -Iplatform -Iplatform/interrupt  -Iplatform/vision -Iplatform/misc -Iplatform/tinyml \
		-Itensorflow/third_party/flatbuffers/include \
		-Itensorflow/third_party/gemmlowp \
		-Itensorflow/third_party/ruy \
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
				 
include ${COMMON}/common/bsp.mk
include ${COMMON}/common/riscv64-unknown-elf.mk
include ${COMMON}/common/standalone.mk

LIBS+=platform/tinyml/ops/lib.a

