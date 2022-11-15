/*
 * FreeRTOS Kernel V10.2.1
 * Copyright (C) 2019 Amazon.com, Inc. or its affiliates.  All Rights Reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to
 * use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 * IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * http://www.FreeRTOS.org
 * http://aws.amazon.com/freertos
 *
 * 1 tab == 4 spaces!
 */

/* FreeRTOS kernel includes. */
#include <FreeRTOS.h>
#include <task.h>
#include <semphr.h>

#include "bsp.h"
#include "riscv.h"
#include "hal.h"
#include "gpio.h"

SemaphoreHandle_t xBinarySemaphore;

void vApplicationMallocFailedHook( void );
void vApplicationIdleHook( void );
void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName );
void vApplicationTickHook( void );

/* Prepare hardware to run the demo. */
static void prvSetupHardware( void );

/* Tasks to demo semaphore */
static void UartTask1 ( void *pvParameters );
static void UartTask2 ( void *pvParameters );

/* Send a message to the UART initialised in prvSetupHardware. */
void vSendString( const char * const pcString );

/*-----------------------------------------------------------*/
int main( void )
{
    prvSetupHardware();
    xBinarySemaphore = xSemaphoreCreateBinary();
    xTaskCreate(UartTask1, "UART1", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
    xTaskCreate(UartTask2, "UART2", configMINIMAL_STACK_SIZE, NULL, 1, NULL);
    xSemaphoreGive(xBinarySemaphore);
    
    vTaskStartScheduler();

    for( ;; );
}
/*-----------------------------------------------------------*/
static void prvSetupHardware( void )
{
    extern void freertos_risc_v_trap_handler();
    csr_write(mtvec, freertos_risc_v_trap_handler);

    vSendString( "Hello world, this is FreeRTOS\n" );
}

/*-----------------------------------------------------------*/
static void UartTask1(void *pvParameters)
{
    /*Uncomment semaphore functions below to check on output
     without interfere from sempahore*/
    while(1)
    {
        xSemaphoreTake(xBinarySemaphore,portMAX_DELAY);
        vSendString( "Inside uart task 1 loop\n\r");
        xSemaphoreGive(xBinarySemaphore);
        vTaskDelay(1);
    }
}

/*-----------------------------------------------------------*/
static void UartTask2(void *pvParameters)
{
    /*Uncomment semaphore functions below to check on output
     without interfere from sempahore*/
    while(1)
    {
        xSemaphoreTake(xBinarySemaphore,portMAX_DELAY);
        vSendString( "Inside uart task 2 loop\n\r");
        xSemaphoreGive(xBinarySemaphore);
        vTaskDelay(1);
    }
}

/*-----------------------------------------------------------*/
void vSendString( const char * const pcString )
{
    bsp_putString(pcString);
}

/*-----------------------------------------------------------*/

void vApplicationMallocFailedHook( void )
{
    /* vApplicationMallocFailedHook() will only be called if
    configUSE_MALLOC_FAILED_HOOK is set to 1 in FreeRTOSConfig.h.  It is a hook
    function that will get called if a call to pvPortMalloc() fails.
    pvPortMalloc() is called internally by the kernel whenever a task, queue,
    timer or semaphore is created.  It is also called by various parts of the
    demo application.  If heap_1.c or heap_2.c are used, then the size of the
    heap available to pvPortMalloc() is defined by configTOTAL_HEAP_SIZE in
    FreeRTOSConfig.h, and the xPortGetFreeHeapSize() API function can be used
    to query the size of free heap space that remains (although it does not
    provide information on how the remaining heap might be fragmented). */
    taskDISABLE_INTERRUPTS();
    __asm volatile( "ebreak" );
    for( ;; );
}
/*-----------------------------------------------------------*/

void vApplicationIdleHook( void )
{
    /* vApplicationIdleHook() will only be called if configUSE_IDLE_HOOK is set
    to 1 in FreeRTOSConfig.h.  It will be called on each iteration of the idle
    task.  It is essential that code added to this hook function never attempts
    to block in any way (for example, call xQueueReceive() with a block time
    specified, or call vTaskDelay()).  If the application makes use of the
    vTaskDelete() API function (as this demo application does) then it is also
    important that vApplicationIdleHook() is permitted to return to its calling
    function, because it is the responsibility of the idle task to clean up
    memory allocated by the kernel to any task that has since been deleted. */
}
/*-----------------------------------------------------------*/

void vApplicationStackOverflowHook( TaskHandle_t pxTask, char *pcTaskName )
{
    ( void ) pcTaskName;
    ( void ) pxTask;

    /* Run time stack overflow checking is performed if
    configCHECK_FOR_STACK_OVERFLOW is defined to 1 or 2.  This hook
    function is called if a stack overflow is detected. */
    taskDISABLE_INTERRUPTS();
    __asm volatile( "ebreak" );
    for( ;; );
}

/*-----------------------------------------------------------*/

void vApplicationTickHook( void )
{
    extern void vFullDemoTickHook( void );
}

