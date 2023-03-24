/*******************************************************************************
 * @file  ulp_timer.c
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
/*************************************************************************
 *
 */

/*==================================================================================
 * @brief : This file contains example application for Timer LED
 * @section Description :
 * This example shows how to use timer to blink LED at 1sec periodic rate.
 * The timers is configured to generate interrupts upon expiration when the LED
 * is toggled.
 * The first timer is Timer 0, set to expire at 1-second (1Hz) intervals.
 ===================================================================================*/

/**
 * Include files
 **/

#include "rsi_chip.h"
#include "rsi_board.h"

/* Private typedef -----------------------------------------------------------*/
#define RESERVED_IRQ_COUNT   16
#define EXT_IRQ_COUNT        98
#define VECTOR_TABLE_ENTRIES (RESERVED_IRQ_COUNT + EXT_IRQ_COUNT)
uint32_t ramVector[VECTOR_TABLE_ENTRIES] __attribute__((aligned(256)));
/* Private macro -------------------------------------------------------------*/
#define TIMER0_IRQHandler IRQ002_Handler
#define TIMER_MATCH_VALUE 500000
#define GPIO_TOGGLE       1
/* Private define ------------------------------------------------------------*/

/* Private variables ---------------------------------------------------------*/

/* Private function prototypes -----------------------------------------------*/
error_t Timer0Config(void);
void RSI_Board_Init(void);
void RSI_Board_LED_Set(int x, int y);
void hardware_setup(void);
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
#if GPIO_TOGGLE
  //Set pin 0 in GPIO mode
  RSI_EGPIO_SetPinMux(EGPIO1, 0, 5, EGPIO_PIN_MUX_MODE0);
  //Set output direction
  RSI_EGPIO_SetDir(EGPIO1, 0, 5, EGPIO_CONFIG_DIR_OUTPUT);

  RSI_EGPIO_SetPin(EGPIO1, 0, 5, 1);
  RSI_EGPIO_SetPin(EGPIO1, 0, 5, 0);
#endif

  DEBUGOUT("\r\nToggle the ULP_GPIO\r\n");
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
  } else {
    DEBUGOUT("\r\nSet Timer Mode as Periodic Timer\r\n");
  }

  /* Sets timer in 1 Micro second mode */
  status = RSI_TIMERS_SetTimerType(TIMERS, MICRO_SEC_MODE, TIMER_0);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Set Timer Type as MicroSec Timer, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet Timer Type as MicroSec Timer\r\n");
  }

  /* 1 Micro second timer configuration */
  status = RSI_TIMERS_MicroSecTimerConfig(TIMERS, TIMER_0, 32, 0, MICRO_SEC_MODE);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Configure Parameters for MicroSec Timer, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nConfigured Parameters for MicroSec Timer\r\n");
  }

  status = RSI_TIMERS_SetMatch(TIMERS, TIMER_0, TIMER_MATCH_VALUE);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Set Match Value in Sec For Timer0 Interrupt, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet Match Value in Sec For Timer0 Interrupt\r\n");
  }

  /* Enables timer interrupt */
  status = RSI_TIMERS_InterruptEnable(TIMERS, TIMER_0);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Enabled Timer0 Interrupt, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nEnabled Timer0 Interrupt\r\n");
  }
  return RSI_OK;
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int main()
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
	 * this is done through SystemInit() function which is called from startup
	 * file (startup_rs1xxxx.s) before to branch to application main.
	 * To reconfigure the default setting of SystemInit() function, refer to
	 * startup_rs1xxxx.c file
	 */
  error_t status = RSI_OK;
  /*Configures the system default clock and power configurations*/
  SystemCoreClockUpdate();

  //copying the vector table from flash to ram
  memcpy(ramVector, (uint32_t *)SCB->VTOR, sizeof(uint32_t) * VECTOR_TABLE_ENTRIES);

  //assing the ram vector adress to VTOR register
  SCB->VTOR = (uint32_t)ramVector;

  //Switching MCU from PS4 to PS2 state
  hardware_setup();

  /* Configured TRI_LED and Board UART */
  RSI_Board_Init();

  /* Timer clock config */
  status = RSI_ULPSS_TimerClkConfig(ULPCLK, ENABLE_STATIC_CLK, 0, ULP_TIMER_32MHZ_RC_CLK, 0);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Set 32Mhz RC Clock to Timer Peripheral, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet 32Mhz RC Clock to Timer Peripheral\r\n");
  }

  /* Timer 0 Configuration */
  status = Timer0Config();
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Configured All Parameter to Timer0, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nConfigured All Parameter to Timer0\r\n");
  }

  /* Interrupt map to ARM */
  NVIC_EnableIRQ(TIMER0_IRQn);

  /* Timers start */
  status = RSI_TIMERS_TimerStart(TIMERS, TIMER_0);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Start Timer0, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nStart Timer0\r\n");
  }

  /* Code never reaches here. Only used to satisfy standard main() */
  while (1)
    ;
}
