#ifndef UART_DRIVER_H
#define UART_DRIVER_H

#include <stdint.h>
#include "stm32f4xx.h"

void UART_Init(USART_TypeDef *instance, uint32_t baudRate);
void UART_Transmit(USART_TypeDef *instance, const uint8_t *data, uint16_t length);
uint8_t UART_ReceiveByte(USART_TypeDef *instance, uint8_t *byteOut, uint32_t timeoutTicks);

#endif
