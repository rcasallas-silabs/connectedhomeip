/*******************************************************************************
 * @file  timer_intr_app.c
 * @brief
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inc. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inc. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/
/***************************************************************************/

/**
 * Include files
 **/

#include "timer_intr_app.h"
#include "app_config.h"
#ifdef RSI_WITH_OS
#include "rsi_os.h"
#include <FreeRTOS.h>
#include "task.h"
extern rsi_semaphore_handle_t  i2c_thread_sem;
#endif
/* Private typedef -----------------------------------------------------------*/

/* Private macro -------------------------------------------------------------*/
#define TIMER0_IRQHandler IRQ002_Handler

/* Private variables ---------------------------------------------------------*/
extern volatile uint32_t peripheral;

/* Private function prototypes -----------------------------------------------*/
error_t Timer0Config(void);

/* Private functions ---------------------------------------------------------*/

/**
 * @brief  TIMER0 Interrupt Handler
 * @param  None
 * @return None
 */


void TIMER0_IRQHandler()
{
  /* Clears interrupt */
  RSI_TIMERS_InterruptClear(TIMERS, TIMER_0);
#ifdef RSI_WITH_OS
  //rsi_semaphore_post_from_isr(&i2c_thread_sem);
#else
  peripheral = I2C;
#endif 
}

/**
 * @brief  TIMER0 Configurations
 * @param  None
 * @return None
 */
error_t Timer0Config(void)
{
  error_t status = RSI_OK;

  /* Sets periodic mode */
  status = RSI_TIMERS_SetTimerMode(TIMERS, PERIODIC_TIMER, TIMER_0);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Set Timer Mode as Periodic Timer, Error Code : %d\r\n", status);
      return status;
  }

  /* Sets timer in 1 Micro second mode */
  status = RSI_TIMERS_SetTimerType(TIMERS, MICRO_SEC_MODE, TIMER_0);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Set Timer Type as MicroSec Timer, Error Code : %d\r\n", status);
      return status;
  }

  /* 1 Micro second timer configuration */
  status = RSI_TIMERS_MicroSecTimerConfig(TIMERS, TIMER_0, 32, 0, MICRO_SEC_MODE);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Configure Parameters for MicroSec Timer, Error Code : %d\r\n", status);
      return status;
  }

  status = RSI_TIMERS_SetMatch(TIMERS, TIMER_0, 1000000);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Set Match Value in Sec For Timer0 Interrupt, Error Code : %d\r\n", status);
      return status;
  }

  /* Enables timer interrupt */
  status = RSI_TIMERS_InterruptEnable(TIMERS, TIMER_0);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Enabled Timer0 Interrupt, Error Code : %d\r\n", status);
      return status;
  }
  return RSI_OK;
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int Timer_Intr_App()
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_rs1xxxx.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * startup_rs1xxxx.c file
   */
  error_t status = RSI_OK;

  /* Timer clock config */
  status = RSI_ULPSS_TimerClkConfig(ULPCLK, ENABLE_STATIC_CLK, 0, ULP_TIMER_32MHZ_RC_CLK, 0);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Set 32Mhz RC Clock to Timer Peripheral, Error Code : %d\r\n", status);
      return status;
  }

  /* Timer 0 Configuration */
  status = Timer0Config();
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Configured All Parameter to Timer0, Error Code : %d\r\n", status);
      return status;
  }

  /* Interrupt map to ARM */
  NVIC_EnableIRQ(TIMER0_IRQn);
  NVIC_SetPriority(TIMER0_IRQn, 7);

  /* Timers start */
  status = RSI_TIMERS_TimerStart(TIMERS, TIMER_0);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Start Timer0, Error Code : %d\r\n", status);
      return status;
  }
}
