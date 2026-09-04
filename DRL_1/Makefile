# STM8 Firmware Makefile

MCU      = stm8s003f3
TARGET   = main

CC       = sdcc
CFLAGS   = -mstm8 --std-c99

SRC      = src/main.c

all: $(TARGET).ihx

$(TARGET).ihx: $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET).ihx
	packihx $(TARGET).ihx > $(TARGET).hex

flash: $(TARGET).ihx
	stm8flash -c stlinkv2 -p $(MCU) -w $(TARGET).hex

clean:
	rm -f *.ihx *.lk *.lst *.map *.rel *.rst *.sym *.hex

.PHONY: all flash clean