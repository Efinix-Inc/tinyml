OBJDIR ?= build

LDFLAGS += -lc

SPINAL_SIM ?= no
ifeq ($(SPINAL_SIM),yes)
    PROJ_NAME := $(PROJ_NAME)_spinal_sim
    CFLAGS += -DSPINAL_SIM
endif

HEADERS += -I${STANDALONE}/include -I${STANDALONE}/driver 
CFLAGS += ${CFLAGS_ARGS}
CFLAGS += ${HEADERS}

LDFLAGS += -L${STANDALONE}/common
LDFLAGS += -specs=nosys.specs -lgcc -nostartfiles -ffreestanding -Wl,-Bstatic,-T,$(LDSCRIPT),-Map,$(OBJDIR)/$(PROJ_NAME).map,--print-memory-usage
DOT:= .
COLON:=:

RISCV_CXX := riscv-none-embed-g++
CXXFLAGS += $(CFLAGS) ${HEADERS}

TARGET := $(OBJDIR)/out
$(TARGET)/%.o: %.c
	@echo CC $<
	$(RISCV_CC) -c $(CFLAGS) -o $@ $<
$(TARGET)/%.o: %.cpp
	@echo CXX $<
	@$(RISCV_CXX) -c $(CXXFLAGS) -o $@ $<
$(TARGET)/%.o: %.cc
	@echo CXX $<
	$(RISCV_CXX) -c $(CXXFLAGS) -o $@ $<	
$(TARGET)/%.o: %.S
	@echo AS $<
	@$(RISCV_CC) -c $(CFLAGS) -o $@ $<
$(TARGET)/%.o: %.s
	@echo AS $<
	@$(RISCV_CC) -c $(CFLAGS) -o $@ $<                

%.hex: %.elf
	@$(RISCV_OBJCOPY) -O ihex $^ $@

%.bin: %.elf
	@$(RISCV_OBJCOPY) -O binary $^ $@

%.v: %.elf
	@$(RISCV_OBJCOPY) -O verilog $^ $@

%.asm: %.elf
	@$(RISCV_OBJDUMP) -S -d $^ > $@

OBJS = $(patsubst %,$(TARGET)/%,$(addsuffix .o, $(basename $(SRCS))))

$(TARGET):
	@mkdir -p $(dir $(OBJS))

all: $(TARGET) $(OBJS)
	@echo LD $(PROJ_NAME).elf
	@$(RISCV_CXX) $(OBJS) -o $(OBJDIR)/$(PROJ_NAME).elf $(LDFLAGS) $(LIBS)
	@$(RISCV_OBJCOPY) -O ihex $(OBJDIR)/$(PROJ_NAME).elf  $(OBJDIR)/$(PROJ_NAME).hex
	@$(RISCV_OBJCOPY) -O binary $(OBJDIR)/$(PROJ_NAME).elf  $(OBJDIR)/$(PROJ_NAME).bin
	@$(RISCV_OBJCOPY) -O verilog $(OBJDIR)/$(PROJ_NAME).elf  $(OBJDIR)/$(PROJ_NAME).v
	@$(RISCV_OBJDUMP) -S -d $(OBJDIR)/$(PROJ_NAME).elf > $(OBJDIR)/$(PROJ_NAME).asm
	
clean:
	@rm -rf $(OBJDIR) $(dir $(OBJS)) || true
