#include "sensor_task.h"
#include "adc_driver.h"
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

static int16_t ConvertRawToTemperature(uint16_t rawAdc, uint8_t *fracOut)
{
    const uint32_t vRefMilliVolts = 3300;
    const uint32_t adcMaxValue = 4095;
    uint32_t milliVolts = (rawAdc * vRefMilliVolts) / adcMaxValue;
    int32_t tempTenths = ((int32_t)milliVolts - 500) * 10;

    *fracOut = (uint8_t)(tempTenths % 10 < 0 ? -(tempTenths % 10) : tempTenths % 10);
    return (int16_t)(tempTenths / 10);
}

void vSensorTask(void *pvParameters)
{
    QueueHandle_t queue = *(QueueHandle_t *)pvParameters;
    SensorSample_t sample;

    for (;;)
    {
        sample.rawAdc = ADC_ReadChannel(ADC_CHANNEL_TEMP);
        sample.temperatureC = ConvertRawToTemperature(sample.rawAdc, &sample.temperatureFrac);

        if (xQueueSend(queue, &sample, pdMS_TO_TICKS(50)) != pdPASS)
        {
            /* queue full, sample dropped intentionally to avoid blocking */
        }

        vTaskDelay(pdMS_TO_TICKS(200));
    }
}
