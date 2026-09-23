TARGET = firmware
BUILD_DIR = build

TOOLCHAIN = arm-none-eabi-
CC = $(TOOLCHAIN)gcc
OBJCOPY = $(TOOLCHAIN)objcopy
SIZE = $(TOOLCHAIN)size

FREERTOS_DIR = third_party/FreeRTOS
CMSIS_DIR = third_party/CMSIS

SRCS = \
    src/main.c \
    src/sensor_task.c \
    src/uart_driver.c \
    src/adc_driver.c \
    src/led_driver.c \
    src/system_clock.c \
    src/syscalls.c \
    src/startup_stm32f407.s \
    $(FREERTOS_DIR)/tasks.c \
    $(FREERTOS_DIR)/queue.c \
    $(FREERTOS_DIR)/list.c \
    $(FREERTOS_DIR)/timers.c \
    $(FREERTOS_DIR)/portable/GCC/ARM_CM4F/port.c \
    $(FREERTOS_DIR)/portable/MemMang/heap_4.c

INCLUDES = \
    -Iinc \
    -I$(FREERTOS_DIR)/include \
    -I$(FREERTOS_DIR)/portable/GCC/ARM_CM4F \
    -I$(CMSIS_DIR)/Include \
    -I$(CMSIS_DIR)/Device/ST/STM32F4xx/Include

CFLAGS = -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard \
          -DSTM32F407xx -O2 -g -Wall -Wextra -ffunction-sections -fdata-sections \
          $(INCLUDES)

LDFLAGS = -mcpu=cortex-m4 -mthumb -mfpu=fpv4-sp-d16 -mfloat-abi=hard \
           -Tscripts/stm32f407.ld -Wl,--gc-sections -nostartfiles -specs=nano.specs

OBJS = $(patsubst %,$(BUILD_DIR)/%.o,$(SRCS))

all: $(BUILD_DIR)/$(TARGET).elf

$(BUILD_DIR)/$(TARGET).elf: $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@
	$(SIZE) $@

$(BUILD_DIR)/%.c.o: %.c
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD_DIR)/%.s.o: %.s
	@mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR)

sim: all
	renode renode/stm32f407.resc

test: all
	renode-test renode/test_firmware.robot

.PHONY: all clean sim test