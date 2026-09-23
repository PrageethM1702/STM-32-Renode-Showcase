#include <stdio.h>
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "semphr.h"
#include "stm32f4xx.h"
#include "uart_driver.h"
#include "adc_driver.h"
#include "led_driver.h"
#include "sensor_task.h"
#include "system_clock.h"

static QueueHandle_t sensorDataQueue;
static SemaphoreHandle_t uartMutex;

void vUartTxTask(void *pvParameters)
{
    SensorSample_t sample;

    for (;;)
    {
        if (xQueueReceive(sensorDataQueue, &sample, portMAX_DELAY) == pdPASS)
        {
            char buffer[64];
            int len = snprintf(buffer, sizeof(buffer),
                                "ADC:%u TEMP:%d.%02u\r\n",
                                sample.rawAdc,
                                sample.temperatureC,
                                sample.temperatureFrac);

            if (xSemaphoreTake(uartMutex, pdMS_TO_TICKS(100)) == pdTRUE)
            {
                UART_Transmit(USART2, (uint8_t *)buffer, len);
                xSemaphoreGive(uartMutex);
            }
        }
    }
}

void vHeartbeatTask(void *pvParameters)
{
    for (;;)
    {
        LED_Toggle(LED_HEARTBEAT);
        vTaskDelay(pdMS_TO_TICKS(500));
    }
}

void vWatchdogMonitorTask(void *pvParameters)
{
    TickType_t lastWake = xTaskGetTickCount();

    for (;;)
    {
        vTaskDelayUntil(&lastWake, pdMS_TO_TICKS(1000));

        if (uxQueueMessagesWaiting(sensorDataQueue) >= (SENSOR_QUEUE_LEN - 1))
        {
            LED_Toggle(LED_ERROR);
        }
    }
}

int main(void)
{
    SystemClock_Config();
    UART_Init(USART2, 115200);
    ADC_Init();
    LED_Init();

    sensorDataQueue = xQueueCreate(SENSOR_QUEUE_LEN, sizeof(SensorSample_t));
    uartMutex = xSemaphoreCreateMutex();

    if (sensorDataQueue == NULL || uartMutex == NULL)
    {
        for (;;)
        {
            LED_Toggle(LED_ERROR);
        }
    }

    xTaskCreate(vSensorTask, "Sensor", 256, (void *)&sensorDataQueue, 2, NULL);
    xTaskCreate(vUartTxTask, "UartTx", 256, NULL, 2, NULL);
    xTaskCreate(vHeartbeatTask, "Heartbeat", 128, NULL, 1, NULL);
    xTaskCreate(vWatchdogMonitorTask, "WdgMonitor", 128, NULL, 3, NULL);

    vTaskStartScheduler();

    for (;;)
    {
    }
}

void vApplicationStackOverflowHook(TaskHandle_t xTask, char *pcTaskName)
{
    (void)xTask;
    (void)pcTaskName;
    taskDISABLE_INTERRUPTS();
    for (;;)
    {
    }
}

void vApplicationMallocFailedHook(void)
{
    taskDISABLE_INTERRUPTS();
    for (;;)
    {
    }
}