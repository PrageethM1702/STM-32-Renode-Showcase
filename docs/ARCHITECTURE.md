# Architecture

## Task layout

| Task           | Priority | Period            | Purpose                              |
|----------------|----------|--------------------|----------------------------------------|
| vSensorTask    | 2        | 200 ms             | Reads ADC channel, pushes to queue     |
| vUartTxTask    | 2        | event driven        | Blocks on queue, formats and transmits |
| vHeartbeatTask | 1        | 500 ms             | Toggles heartbeat LED                  |
| vWatchdogMonitorTask | 3  | 1000 ms            | Detects queue backpressure, flags LED  |

## Synchronization

- `sensorDataQueue`: bounded queue (depth 8) decoupling sampling rate from
  transmit rate. Sender uses a short timeout and drops samples on overflow
  rather than blocking the sensor task indefinitely.
- `uartMutex`: guards UART peripheral access. Only one task currently writes
  to UART, but the mutex is in place so a future debug/log task can share the
  same port safely.

## Failure handling

- Stack overflow and malloc failure hooks halt the system with interrupts
  disabled rather than continuing in an undefined state.
- Watchdog monitor task treats a near-full sensor queue as a symptom of the
  UART task stalling and raises a visual (LED) fault indicator.

## Porting notes

- Peripheral base addresses and clock enables are STM32F407 specific,
  isolated in the driver `.c` files under `src/`.
- FreeRTOSConfig.h assumes a 16 MHz clock (matches Renode's default HSE
  model for this platform); adjust `configCPU_CLOCK_HZ` if raising the clock
  via PLL on real hardware.
