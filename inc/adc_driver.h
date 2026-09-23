#ifndef ADC_DRIVER_H
#define ADC_DRIVER_H

#include <stdint.h>

#define ADC_CHANNEL_TEMP 8

void ADC_Init(void);
uint16_t ADC_ReadChannel(uint8_t channel);

#endif
