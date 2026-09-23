#include "led_driver.h"
#include "stm32f4xx.h"

#define LED_HEARTBEAT_PIN 12
#define LED_ERROR_PIN 13

void LED_Init(void)
{
    RCC->AHB1ENR |= RCC_AHB1ENR_GPIODEN;

    GPIOD->MODER &= ~(GPIO_MODER_MODER12_Msk | GPIO_MODER_MODER13_Msk);
    GPIOD->MODER |= (1U << GPIO_MODER_MODER12_Pos) | (1U << GPIO_MODER_MODER13_Pos);
}

void LED_Toggle(LedId_t led)
{
    uint32_t pin = (led == LED_HEARTBEAT) ? LED_HEARTBEAT_PIN : LED_ERROR_PIN;
    GPIOD->ODR ^= (1U << pin);
}
