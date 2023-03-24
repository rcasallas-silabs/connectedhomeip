/*******************************************************************************
 * @file  pwm_app.c
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

/**
 * Include files
 **/

#include "pwm_app.h"

#ifdef RSI_WITH_OS
#include "rsi_os.h"
extern rsi_semaphore_handle_t pwm_thread_sem;
#endif
/* Private typedef -----------------------------------------------------------*/

/* Private macro -------------------------------------------------------------*/
#define MCPWM_RATE 10000
#define TICKS      1000 /* 1 ms Tick rate */
/* Private define ------------------------------------------------------------*/
#define MCPWM_IRQHandler IRQ048_Handler

/* Private variables ---------------------------------------------------------*/

/* Private  function prototypes -----------------------------------------------*/

/* Private functions ---------------------------------------------------------*/

/**
 * @brief	 Pin muxing for PWM_1L and PWM_2L output pins 
 * @return Nothing
 */
void RSI_MCPWM_PinMux()
{
  /* PWM_1L output pin mux */
  if (RTE_PWM_1L_PIN > 63) {
    RSI_EGPIO_UlpPadReceiverEnable((uint8_t)(RTE_PWM_1L_PIN - 64));
    RSI_EGPIO_SetPinMux(EGPIO1, 0, (uint8_t)(RTE_PWM_1L_PIN - 64), 6);
  } else {
    RSI_EGPIO_PadReceiverEnable(RTE_PWM_1L_PIN);
  }
  RSI_EGPIO_PadSelectionEnable(RTE_PWM_1L_PAD);
  RSI_EGPIO_SetPinMux(EGPIO, 0, RTE_PWM_1L_PIN, RTE_PWM_1L_MUX);

  /* PWM_1H output pin mux */
  if (RTE_PWM_1H_PIN > 63) {
    RSI_EGPIO_UlpPadReceiverEnable((uint8_t)(RTE_PWM_1H_PIN - 64));
    RSI_EGPIO_SetPinMux(EGPIO1, 0, (uint8_t)(RTE_PWM_1H_PIN - 64), 6);
  } else {
    RSI_EGPIO_PadReceiverEnable(RTE_PWM_1H_PIN);
  }
  RSI_EGPIO_PadSelectionEnable(RTE_PWM_1H_PAD);
  RSI_EGPIO_SetPinMux(EGPIO, 0, RTE_PWM_1H_PIN, RTE_PWM_1H_MUX);

  /* PWM_2L output pin mux */
  if (RTE_PWM_2L_PIN > 63) {
    RSI_EGPIO_UlpPadReceiverEnable((uint8_t)(RTE_PWM_2L_PIN - 64));
    RSI_EGPIO_SetPinMux(EGPIO1, 0, (uint8_t)(RTE_PWM_2L_PIN - 64), 6);
  } else {
    RSI_EGPIO_PadReceiverEnable(RTE_PWM_2L_PIN);
  }
  RSI_EGPIO_PadSelectionEnable(RTE_PWM_2L_PAD);
  RSI_EGPIO_SetPinMux(EGPIO, 0, RTE_PWM_2L_PIN, RTE_PWM_2L_MUX);

  /* PWM_2H output pin mux */
  if (RTE_PWM_2H_PIN > 63) {
    RSI_EGPIO_UlpPadReceiverEnable((uint8_t)(RTE_PWM_2H_PIN - 64));
    RSI_EGPIO_SetPinMux(EGPIO1, 0, (uint8_t)(RTE_PWM_2H_PIN - 64), 6);
  } else {
    RSI_EGPIO_PadReceiverEnable(RTE_PWM_2H_PIN);
  }
  RSI_EGPIO_PadSelectionEnable(RTE_PWM_2H_PAD);
  RSI_EGPIO_SetPinMux(EGPIO, 0, RTE_PWM_2H_PIN, RTE_PWM_2H_MUX);
}

/**
 * @brief	 PWM Channel time period config 
 * @param  freq  PWM clock frequency
 * @return none
 */
void MCPWM_SetChannelPeriod(uint32_t freq)
{
  uint32_t rate = 0;

  rate = SystemCoreClock / freq;

  /* Set time period */
  RSI_MCPWM_SetTimePeriod(MCPWM, PWM_CHNL_0, rate, COUNTER_INIT_VAL);
  RSI_MCPWM_SetTimePeriod(MCPWM, PWM_CHNL_1, rate, COUNTER_INIT_VAL);
}

/**
 * @brief	 Converts duty cycle percentage to system ticks
 * @param  percent  Duty cycle in percentage
 * @param  chnl_num PWM channel number (0...3)
 * @return Returns number of ticks
 */
uint32_t MCPWM_PercentageToTicks(uint8_t percent, uint8_t chnl_num)
{
  uint16_t time_period = 0;
  uint32_t ticks       = 0;

  /* Get time period */
  RSI_MCPWM_GetTimePeriod(MCPWM, chnl_num, &time_period);
  ticks = (time_period * percent) / 100;
  return ticks;
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int PWM_Init(void)
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_RS1xxxx.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * system_RS1xxxx.c file
   */
  error_t status = RSI_OK;
  int loop       = 1;
  uint32_t delay = 0;
  int pwm_out_0, pwm_out_1, duty_p = 0, incr = 1, Led = 0;
  uint16_t time_period = 0;
  uint32_t ticks       = 0;

  /* Sets pin mux */
  RSI_MCPWM_PinMux();

  /* MCPWM clock enable */
  status = RSI_CLK_PeripheralClkEnable(M4CLK, PWM_CLK, ENABLE_STATIC_CLK);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to enable PWM  clock , Error Code : %d\r\n", status);
    return status;
  }
  /* select number of base timers as four base timers for four channels MCPWM*/
  RSI_MCPWM_BaseTimerSelect(MCPWM, ONE_TIMER_FOR_EACH_CHNL);

  /* Set output polarity for MCPWM */
  RSI_MCPWM_SetOutputPolarity(MCPWM, 1, 1);

  /* Set PWM output mode */
  status =
    RSI_MCPWM_SetBaseTimerMode(MCPWM, TMR_FREE_RUN_MODE, PWM_CHNL_0); //set the mode of base timer for required channel
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to set the free running mode of base timer for  channel zero , Error Code : %d\r\n", status);
    return status;
  }

  status = RSI_MCPWM_SetBaseTimerMode(MCPWM, TMR_FREE_RUN_MODE, PWM_CHNL_1);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to set the free running mode of base timer for  channel one , Error Code : %d\r\n", status);
    return status;
  }

  /* configure PWM Channel time period  */
  MCPWM_SetChannelPeriod(MCPWM_RATE);
}
int PWM_App()
{
  error_t status = RSI_OK;
  int loop       = 1;
  uint32_t delay = 0;
  int pwm_out_0, pwm_out_1, duty_p = 0, incr = 1, Led = 0;
  uint16_t time_period = 0;
  uint32_t ticks       = 0;

  /* Get time period for required channel. */
  status = RSI_MCPWM_GetTimePeriod(MCPWM, PWM_CHNL_1, &time_period);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to get Time period  for  channel one , Error Code : %d\r\n", status);
    return status;
  }
  ticks = time_period / 2;

  /* Set Duty cycle value for channel 0 and channel 1*/
  status = RSI_MCPWM_SetDutyCycle(MCPWM, ticks, PWM_CHNL_0); /* LED */
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to set duty cycle  for channel zero , Error Code : %d\r\n", status);
    return status;
  }
  status = RSI_MCPWM_SetDutyCycle(MCPWM, ticks, PWM_CHNL_1); /* OUT */
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to set duty cycle  for channel one , Error Code : %d\r\n", status);
    return status;
  }
#ifdef RSI_WITH_OS
  while (1) {
    rsi_semaphore_wait(&pwm_thread_sem, 0);
#endif
    /* Start PWM */
    status = RSI_MCPWM_Start(MCPWM, PWM_CHNL_0); //start the MCPWM operation for required channel
    if (status != RSI_OK) {
      DEBUGOUT("\r\n Failed to start the MCPWM operation  for channel zero , Error Code : %d\r\n", status);
      return status;
    }

    status = RSI_MCPWM_Start(MCPWM, PWM_CHNL_1);
    if (status != RSI_OK) {
      DEBUGOUT("\r\n Failed to start the MCPWM operation  for channel one , Error Code : %d\r\n", status);
      return status;
    }
    DEBUGOUT("\n PWM Start\n");

#ifdef RSI_WITH_OS
  }
#endif
}
