# STM32F407 FreeRTOS Sensor Monitor - Renode Simulation

Bare-metal FreeRTOS firmware for STM32F407 (Cortex-M4), fully simulated in
Renode with no physical hardware required.

## What this demonstrates

- FreeRTOS multitasking: 4 tasks (sensor sampling, UART transmit, heartbeat,
  watchdog monitor) with mutex and queue based synchronization
- Bare-metal peripheral drivers written directly against register maps
  (UART, ADC, GPIO, RCC) without HAL dependency
- Deterministic timing via vTaskDelayUntil for periodic sensor sampling
- Fault handling hooks (stack overflow, malloc failure)
- Automated Renode robot-framework test that boots the firmware and verifies
  UART output
- Clean separation of drivers, tasks, and application layer for portability
  to other STM32 parts

## Project layout

```
stm32-renode-showcase/
  src/            application and driver source files
  inc/            headers and FreeRTOS configuration
  scripts/        linker script and dependency setup
  renode/         platform description, resc launch script, robot test
  build/          build output (created by make)
  docs/           architecture notes
```

## Build (Linux / macOS / WSL)

```
./scripts/setup_dependencies.sh
make
```

Requires arm-none-eabi-gcc toolchain. Dependency script pulls FreeRTOS-Kernel
and CMSIS headers.

## Build (Windows PowerShell)

```powershell
.\scripts\setup_dependencies.ps1
.\scripts\build.ps1
```

Requires arm-none-eabi-gcc on PATH (install via `winget install Arm.GnuArmEmbeddedToolchain`)
and git. No `make` dependency needed.

## Run in Renode

```
make sim
```

On Windows:

```powershell
renode renode\stm32f407.resc
```

Opens a UART terminal window showing live sensor readings such as:

```
ADC:2048 TEMP:25.03
```

## Automated test

```
make test
```

On Windows:

```powershell
renode-test renode\test_firmware.robot
```

Runs the robot-framework test in `renode/test_firmware.robot`, which boots
the firmware in a headless Renode instance and asserts that sensor data
appears on the UART within the timeout window.

## Notes

This is a portfolio/demo project intended to show firmware architecture and
Renode-based CI-friendly testing. The ADC channel reads a placeholder
temperature-sensor style channel; swap `ADC_ReadChannel` calls and the
platform repl peripheral addresses for your target hardware and sensor.
