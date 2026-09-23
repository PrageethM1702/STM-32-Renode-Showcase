#ifndef LED_DRIVER_H
#define LED_DRIVER_H

typedef enum
{
    LED_HEARTBEAT,
    LED_ERROR
} LedId_t;

void LED_Init(void);
void LED_Toggle(LedId_t led);

#endif
