.syntax unified
.cpu cortex-m4
.thumb

.global Reset_Handler
.global g_pfnVectors

.word _estack

.section .isr_vector,"a",%progbits
g_pfnVectors:
    .word _estack
    .word Reset_Handler
    .word NMI_Handler
    .word HardFault_Handler
    .word MemManage_Handler
    .word BusFault_Handler
    .word UsageFault_Handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word vPortSVCHandler
    .word DebugMon_Handler
    .word 0
    .word xPortPendSVHandler
    .word xPortSysTickHandler

    .word Default_Handler /* IRQ0  WWDG */
    .word Default_Handler /* IRQ1  PVD */
    .word Default_Handler /* IRQ2  TAMP_STAMP */
    .word Default_Handler /* IRQ3  RTC_WKUP */
    .word Default_Handler /* IRQ4  FLASH */
    .word Default_Handler /* IRQ5  RCC */
    .word Default_Handler /* IRQ6  EXTI0 */
    .word Default_Handler /* IRQ7  EXTI1 */
    .word Default_Handler /* IRQ8  EXTI2 */
    .word Default_Handler /* IRQ9  EXTI3 */
    .word Default_Handler /* IRQ10 EXTI4 */
    .word Default_Handler /* IRQ11 DMA1_Stream0 */
    .word Default_Handler /* IRQ12 DMA1_Stream1 */
    .word Default_Handler /* IRQ13 DMA1_Stream2 */
    .word Default_Handler /* IRQ14 DMA1_Stream3 */
    .word Default_Handler /* IRQ15 DMA1_Stream4 */
    .word Default_Handler /* IRQ16 DMA1_Stream5 */
    .word Default_Handler /* IRQ17 DMA1_Stream6 */
    .word Default_Handler /* IRQ18 ADC */
    .word Default_Handler /* IRQ19 CAN1_TX */
    .word Default_Handler /* IRQ20 CAN1_RX0 */
    .word Default_Handler /* IRQ21 CAN1_RX1 */
    .word Default_Handler /* IRQ22 CAN1_SCE */
    .word Default_Handler /* IRQ23 EXTI9_5 */
    .word Default_Handler /* IRQ24 TIM1_BRK_TIM9 */
    .word Default_Handler /* IRQ25 TIM1_UP_TIM10 */
    .word Default_Handler /* IRQ26 TIM1_TRG_COM_TIM11 */
    .word Default_Handler /* IRQ27 TIM1_CC */
    .word Default_Handler /* IRQ28 TIM2 */
    .word Default_Handler /* IRQ29 TIM3 */
    .word Default_Handler /* IRQ30 TIM4 */
    .word Default_Handler /* IRQ31 I2C1_EV */
    .word Default_Handler /* IRQ32 I2C1_ER */
    .word Default_Handler /* IRQ33 I2C2_EV */
    .word Default_Handler /* IRQ34 I2C2_ER */
    .word Default_Handler /* IRQ35 SPI1 */
    .word Default_Handler /* IRQ36 SPI2 */
    .word Default_Handler /* IRQ37 USART1 */
    .word USART2_Handler  /* IRQ38 USART2 */

.section .text.Reset_Handler
.weak Reset_Handler
.type Reset_Handler, %function
Reset_Handler:
    ldr r0, =_estack
    mov sp, r0

    ldr r0, =_sdata
    ldr r1, =_edata
    ldr r2, =_sidata
    movs r3, #0
CopyLoop:
    cmp r0, r1
    beq CopyDone
    ldr r4, [r2, r3]
    str r4, [r0, r3]
    adds r3, r3, #4
    b CopyLoop
CopyDone:

    ldr r0, =_sbss
    ldr r1, =_ebss
    movs r2, #0
ZeroLoop:
    cmp r0, r1
    beq ZeroDone
    str r2, [r0]
    adds r0, r0, #4
    b ZeroLoop
ZeroDone:

    bl SystemInit
    bl main
    b .

.section .text.Default_Handler,"ax",%progbits
Default_Handler:
    b .

.macro def_irq_handler handler_name
    .weak \handler_name
    .set \handler_name, Default_Handler
.endm

def_irq_handler NMI_Handler
def_irq_handler HardFault_Handler
def_irq_handler MemManage_Handler
def_irq_handler BusFault_Handler
def_irq_handler UsageFault_Handler
def_irq_handler DebugMon_Handler
def_irq_handler USART2_Handler