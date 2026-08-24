# STM8 Firmware Makefile

MCU      = stm8s003f3
TARGET   = main

CC       = sdcc
CFLAGS   = -mstm8 --std-c99

SRC      = src/main.c

all: $(TARGET).ihx

$(TARGET).ihx: $(SRC)
	$(CC) $(CFLAGS) $(SRC) -o $(TARGET).ihx

flash: $(TARGET).ihx
	stm8flash -c stlinkv2 -p $(MCU) -w $(TARGET).ihx

clean:
	rm -f *.ihx *.lk *.lst *.map *.rel *.rst *.sym

.PHONY: all flash clean