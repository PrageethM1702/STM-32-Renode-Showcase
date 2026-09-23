#include "adc_driver.h"
#include "stm32f4xx.h"

void ADC_Init(void)
{
    RCC->APB2ENR |= RCC_APB2ENR_ADC1EN;

    ADC1->CR2 &= ~ADC_CR2_CONT;
    ADC1->CR1 &= ~ADC_CR1_RES;
    ADC1->SQR3 = 0;
    ADC1->CR2 |= ADC_CR2_ADON;
}

uint16_t ADC_ReadChannel(uint8_t channel)
{
    ADC1->SQR3 = channel & 0x1F;
    ADC1->CR2 |= ADC_CR2_SWSTART;

    while (!(ADC1->SR & ADC_SR_EOC))
    {
    }

    return (uint16_t)(ADC1->DR & 0x0FFF);
}
