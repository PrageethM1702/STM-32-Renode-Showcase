#!/bin/bash
set -e

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THIRD_PARTY="$ROOT_DIR/third_party"

mkdir -p "$THIRD_PARTY"

if [ ! -d "$THIRD_PARTY/FreeRTOS" ]; then
    git clone --depth 1 https://github.com/FreeRTOS/FreeRTOS-Kernel.git "$THIRD_PARTY/FreeRTOS"
fi

if [ ! -d "$THIRD_PARTY/CMSIS" ]; then
    git clone --depth 1 https://github.com/STMicroelectronics/cmsis_device_f4.git "$THIRD_PARTY/CMSIS_F4"
    git clone --depth 1 https://github.com/ARM-software/CMSIS_5.git "$THIRD_PARTY/CMSIS_5"
    mkdir -p "$THIRD_PARTY/CMSIS/Include"
    mkdir -p "$THIRD_PARTY/CMSIS/Device/ST/STM32F4xx/Include"
    cp -r "$THIRD_PARTY/CMSIS_5/CMSIS/Core/Include/." "$THIRD_PARTY/CMSIS/Include/"
    cp -r "$THIRD_PARTY/CMSIS_F4/Include/." "$THIRD_PARTY/CMSIS/Device/ST/STM32F4xx/Include/"
fi

echo "Dependencies ready in $THIRD_PARTY"
