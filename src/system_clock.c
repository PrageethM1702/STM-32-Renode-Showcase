#include "system_clock.h"
#include "stm32f4xx.h"

void SystemInit(void)
{
    SCB->CPACR |= ((3UL << 20) | (3UL << 22));
    SCB->VTOR = 0x08000000;
}

void SystemClock_Config(void)
{
    RCC->CR |= RCC_CR_HSEON;
    while (!(RCC->CR & RCC_CR_HSERDY))
    {
    }

    RCC->CFGR |= RCC_CFGR_SW_HSE;
    while ((RCC->CFGR & RCC_CFGR_SWS) != RCC_CFGR_SWS_HSE)
    {
    }
}