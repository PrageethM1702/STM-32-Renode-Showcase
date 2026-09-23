#include "uart_driver.h"
#include "stm32f4xx.h"

void UART_Init(USART_TypeDef *instance, uint32_t baudRate)
{
    RCC->APB1ENR |= RCC_APB1ENR_USART2EN;
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIOAEN;

    GPIOA->MODER &= ~(GPIO_MODER_MODER2_Msk | GPIO_MODER_MODER3_Msk);
    GPIOA->MODER |= (2U << GPIO_MODER_MODER2_Pos) | (2U << GPIO_MODER_MODER3_Pos);
    GPIOA->AFR[0] |= (7U << (4 * 2)) | (7U << (4 * 3));

    uint32_t apb1Clock = 16000000U;
    uint32_t usartDiv = (apb1Clock + (baudRate / 2U)) / baudRate;
    instance->BRR = usartDiv;

    instance->CR1 = USART_CR1_TE | USART_CR1_RE | USART_CR1_UE;
}

void UART_Transmit(USART_TypeDef *instance, const uint8_t *data, uint16_t length)
{
    for (uint16_t i = 0; i < length; i++)
    {
        while (!(instance->SR & USART_SR_TXE))
        {
        }
        instance->DR = data[i];
    }

    while (!(instance->SR & USART_SR_TC))
    {
    }
}

uint8_t UART_ReceiveByte(USART_TypeDef *instance, uint8_t *byteOut, uint32_t timeoutTicks)
{
    uint32_t elapsed = 0;

    while (!(instance->SR & USART_SR_RXNE))
    {
        if (++elapsed >= timeoutTicks)
        {
            return 0;
        }
    }

    *byteOut = (uint8_t)instance->DR;
    return 1;
}
