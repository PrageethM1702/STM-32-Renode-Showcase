#ifndef SENSOR_TASK_H
#define SENSOR_TASK_H

#include <stdint.h>

#define SENSOR_QUEUE_LEN 8

typedef struct
{
    uint16_t rawAdc;
    int16_t temperatureC;
    uint8_t temperatureFrac;
} SensorSample_t;

void vSensorTask(void *pvParameters);

#endif
