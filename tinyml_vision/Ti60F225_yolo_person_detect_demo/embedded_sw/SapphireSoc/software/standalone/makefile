SUBDIRS := 	apb3Demo \
            axi4Demo \
            bootloader \
            coreTimerInterruptDemo \
            dhrystone \
            coremark \
            gpioDemo \
            i2cDemo \
            i2cSlaveDemo \
            memTest \
            spiDemo \
            spiReadFlashDemo \
            spiWriteFlashDemo \
            uartEchoDemo \
            uartInterruptDemo \
            userInterruptDemo \
            userTimerDemo \
            nestedInterruptDemo \
            fpuDemo \
            compatibilityDemo

all:
	for dir in $(SUBDIRS); do \
		(cd $$dir; ${MAKE} all); \
	done

clean:
	for dir in $(SUBDIRS); do \
		(cd $$dir; ${MAKE} clean); \
	done

.PHONY: all $(SUBDIRS)
