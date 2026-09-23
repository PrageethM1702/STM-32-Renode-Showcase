*** Settings ***
Suite Setup                  Setup
Suite Teardown                Teardown
Test Setup                   Reset Emulation
Test Teardown                 Test Teardown
Resource                      ${RENODEKEYWORDS}

*** Variables ***
${UART}                       sysbus.usart2

*** Test Cases ***
Should Boot And Print Sensor Data
    Execute Command            mach create "stm32f407-test"
    Execute Command            machine LoadPlatformDescription @renode/stm32f407.repl
    Execute Command            sysbus LoadELF @build/firmware.elf
    Create Terminal Tester      ${UART}

    Start Emulation

    Wait For Line On Uart       ADC:
