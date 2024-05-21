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

RAM_LENGTH = 16384K
STACK_SIZE = 2048K

default_ld:
ifeq ($(OS),Windows_NT)
	@powershell -Command "(Get-Content -Path '$(BSP_PATH)\linker\default.ld' -Raw) -replace 'LENGTH = .*', 'LENGTH = $(RAM_LENGTH)' -replace '__stack_size : .*', '__stack_size : $(STACK_SIZE);' | Set-Content -Path '$(BSP_PATH)\linker\default.ld.tmp';; Move-Item -Path '$(BSP_PATH)\linker\default.ld.tmp' -Destination '$(BSP_PATH)\linker\default.ld' -Force"

else
	@sed -e 's/LENGTH = .*/LENGTH = $(RAM_LENGTH)/g' -e 's/__stack_size : .*/__stack_size : $(STACK_SIZE);/g' $(BSP_PATH)/linker/default.ld > $(BSP_PATH)/linker/default.ld.tmp
	@mv $(BSP_PATH)/linker/default.ld.tmp $(BSP_PATH)/linker/default.ld
	@chmod 755 $(BSP_PATH)/linker/default.ld
endif

all: $(TARGET) $(OBJS) default_ld
	@echo LD $(PROJ_NAME).elf
	@$(RISCV_CXX) $(OBJS) -o $(OBJDIR)/$(PROJ_NAME).elf $(LDFLAGS) $(LIBS)
	@$(RISCV_OBJCOPY) -O ihex $(OBJDIR)/$(PROJ_NAME).elf  $(OBJDIR)/$(PROJ_NAME).hex
	@$(RISCV_OBJCOPY) -O binary $(OBJDIR)/$(PROJ_NAME).elf  $(OBJDIR)/$(PROJ_NAME).bin
	@$(RISCV_OBJCOPY) -O verilog $(OBJDIR)/$(PROJ_NAME).elf  $(OBJDIR)/$(PROJ_NAME).v
	@$(RISCV_OBJDUMP) -S -d $(OBJDIR)/$(PROJ_NAME).elf > $(OBJDIR)/$(PROJ_NAME).asm
	
clean:
	@rm -rf $(OBJDIR) $(dir $(OBJS)) || true
