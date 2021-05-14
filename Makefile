# Stlink komutu 
# eger terminalden direkt calistirilamiyorsa st-flash oncesine st-flash scriptinin bulundugu adresi ekleyin
STLINK=st-flash

# Source dosyalari
SRCS=main.c system_stm32f4xx.c

# Kutuphanelerin source dosyalari kodunuzda kullandiginiz farkli kutuphaneler varsa ekleyiniz
SRCS += stm32f4xx_rcc.c
SRCS += stm32f4xx_gpio.c

# Proje adi
PROJ_NAME=test

# STM32F4 firmware paketinin cikardigimiz adres
STM_COMMON=/home/ajanx/EmbeddedSTM32/STM32F4-Discovery_FW_V1.1.0/

# Derleyici komutu
# Eger derleyiciyi terminalden direkt calistirilamiyorsa arm-none-eabi-gcc oncesine derleyicinin scriptlerinin oldugu adresi yaziniz ornegin CC=/usr/local/derleyici/scripts/arm-none-eabi-gcc
# OBJCOPY icin de ayni sey gecerlidir
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

# Derleyicinin parametreleri
CFLAGS  = -g -Og -O2 -Wall -Tstm32_flash.ld
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -I.

# STM kutuphaneleri .h
CFLAGS += -I$(STM_COMMON)/Libraries/CMSIS/Include
CFLAGS += -I$(STM_COMMON)/Libraries/CMSIS/ST/STM32F4xx/Include
CFLAGS += -I$(STM_COMMON)/Libraries/STM32F4xx_StdPeriph_Driver/inc
CFLAGS += -I$(STM_COMMON)/Utilities/STM32F4-Discovery

# Startup dosyasi
SRCS += $(STM_COMMON)/Libraries/CMSIS/ST/STM32F4xx/Source/Templates/TrueSTUDIO/startup_stm32f4xx.s
OBJS = $(SRCS:.c=.o)

vpath %.c $(STM_COMMON)/Libraries/STM32F4xx_StdPeriph_Driver/src \

.PHONY: proj

all: cpy proj
# Gereken dosyalari ana dosyadan proje dosyasina kopyala
cpy:
	yes | cp -rf $(STM_COMMON)stm32f4xx_conf.h $(STM_COMMON)stm32_flash.ld $(STM_COMMON)system_stm32f4xx.c ./

proj: $(PROJ_NAME).elf

# Belirlenen parametrelere gore derle
$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

# Proje dosyalarini temizle
clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin system_stm32f4xx.c stm32_flash.ld stm32f4xx_conf.h

# STM32F4e aktar
burn: proj
	$(STLINK) write $(PROJ_NAME).bin 0x8000000
