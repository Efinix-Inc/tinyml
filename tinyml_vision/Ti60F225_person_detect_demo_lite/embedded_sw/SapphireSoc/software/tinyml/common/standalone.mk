OBJDIR ?= build

LDFLAGS += -lc

SPINAL_SIM ?= no
ifeq ($(SPINAL_SIM),yes)
    PROJ_NAME := $(PROJ_NAME)_spinal_sim
    CFLAGS += -DSPINAL_SIM
endif
CFLAGS += ${CFLAGS_ARGS}
CFLAGS += -I${STANDALONE}/include
CFLAGS += -I${STANDALONE}/driver
CFLAGS += -I${STANDALONE}/${PROJ_NAME}/src
CFLAGS += -I${STANDALONE}/${PROJ_NAME}/src/third_party/gemmlowp
CFLAGS += -I${STANDALONE}/${PROJ_NAME}/src/third_party/flatbuffers
CFLAGS += -I${STANDALONE}/${PROJ_NAME}/src/third_party/flatbuffers/include
CFLAGS += -I${STANDALONE}/${PROJ_NAME}/src/third_party/ruy
LDFLAGS += -L${STANDALONE}/common
LDFLAGS += -lgcc -nostartfiles -ffreestanding -Wl,-Bstatic,-T,$(LDSCRIPT),-Map,$(OBJDIR)/$(PROJ_NAME).map,--print-memory-usage --specs=nosys.specs

# Added by WL for tflite
SHARED_FLAGS += \
	-I$(SRC_DIR) \
	-I$(SRC_DIR)/third_party/gemmlowp \
	-I$(SRC_DIR)/third_party/flatbuffers/include \
	-I$(SRC_DIR)/third_party/ruy \
	-I$(SRC_DIR)/third_party/kissfft \
	-I$(SOC_SOFTWARE_DIR)/include \
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

CXXFLAGS   += \
	$(SHARED_FLAGS) \
	-std=c++11 \
	-fstrict-aliasing \
	-fno-rtti \
	-fno-exceptions \
	-fno-threadsafe-statics\
	-fmessage-length=0 \
	-Wall \
	-Wextra \
	-Wstrict-aliasing \
	-Wno-unused-parameter

LDFLAGS     += \
	$(CXXFLAGS) \
	# -L$(LD_DIR) \
	# -L$(GEN_LD_DIR) \
	# -L$(SOC_SOFTWARE_DIR)/libbase -lbase-nofloat \
	# -L$(SOC_SOFTWARE_DIR)/libcompiler_rt -lcompiler_rt \
	-lm \
	#-nostartfiles \
	#-Wl,--gc-sections \
	-Wl,--fatal-warnings \
	-Wl,--no-warn-mismatch \
	#-Wl,--script=$(LDSCRIPT) \
	-Wl,--build-id=none
 
DOT:= .
COLON:=:

OBJS := $(SRCS)
OBJS := $(realpath $(OBJS))
OBJS := $(subst $(COLON),,$(OBJS))
OBJS := $(OBJS:.c=.o)
OBJS := $(OBJS:.cpp=.o)
OBJS := $(OBJS:.cc=.o)
OBJS := $(OBJS:.S=.o)
OBJS := $(OBJS:.s=.o)
OBJS := $(addprefix $(OBJDIR)/,$(OBJS))


all: $(OBJDIR)/$(PROJ_NAME).elf $(OBJDIR)/$(PROJ_NAME).hex $(OBJDIR)/$(PROJ_NAME).asm $(OBJDIR)/$(PROJ_NAME).bin

$(OBJDIR)/%.elf: $(OBJS) | $(OBJDIR)
	@echo "LD $(PROJ_NAME)"
	@$(RISCV_CXX) $(CXXFLAGS) $(CFLAGS) -o $@ $^ $(LDFLAGS) $(LIBS) 

%.hex: %.elf
	@$(RISCV_OBJCOPY) -O ihex $^ $@

%.bin: %.elf
	@$(RISCV_OBJCOPY) -O binary $^ $@

%.v: %.elf
	@$(RISCV_OBJCOPY) -O verilog $^ $@

%.asm: %.elf
	@$(RISCV_OBJDUMP) -S -d $^ > $@

define LIST_RULE
$(1)
	@mkdir -p $(dir $(word 1, $(subst $(COLON), ,$(1))))
	@echo "CC $(word 2,$(subst $(COLON), ,$(1)))"
	@$(RISCV_CXX) -c $(CXXFLAGS) $(CFLAGS)  $(INC) -o $(subst $(COLON), ,$(1))
endef

CAT:= $(addsuffix  $(COLON), $(OBJS))
CAT:= $(join  $(CAT), $(SRCS))
$(foreach i,$(CAT),$(eval $(call LIST_RULE,$(i))))

$(OBJDIR):
	@mkdir -p $@

clean:
	@rm -rf $(OBJDIR)

.SECONDARY: $(OBJS)
