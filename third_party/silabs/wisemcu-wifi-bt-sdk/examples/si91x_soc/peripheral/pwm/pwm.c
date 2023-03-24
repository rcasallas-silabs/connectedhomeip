/*******************************************************************************
 * @file  pwm.c
 * @brief
 *******************************************************************************
 * # License
 * <b>Copyright 2022 Silicon Laboratories Inc. www.silabs.com</b>
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
/**============================================================================
 * @brief : This file contains example application for MCPWM LED
 * @section Description :
 * This example uses the MCPWM driver to create 2 independent PWMs (running at the
 * same frequency). Square wave will be generated on channel 0 output PWM_1L and
 * channel 1 output PWM_2L with the duty cycle varying from 0% to 100% in steps of
 * 0.5% every 20 Milliseconds and goes down to 0% in the same step.
 =============================================================================**/

// Include Flies

#include "rsi_chip.h"
#include "rsi_board.h"
#include "RTE_Device.h"

#define MCPWM_RATE       10000
#define TICKS            1000 // 1 ms Tick rate
#define MCPWM_IRQHandler IRQ048_Handler

void SysTick_Handler(void)
{
}

/*==============================================*/
/**
 * @fn       void RSI_MCPWM_PinMux()
 * @brief	 Pin muxing for PWM_1L and PWM_2L output pins
 * @return   None
 */
void RSI_MCPWM_PinMux()
{
  // PWM_1L output pin mux
  if (RTE_PWM_1L_PIN > 63) {
    RSI_EGPIO_UlpPadReceiverEnable((uint8_t)(RTE_PWM_1L_PIN - 64));
    RSI_EGPIO_SetPinMux(EGPIO1, 0, (uint8_t)(RTE_PWM_1L_PIN - 64), 6);
  } else {
    RSI_EGPIO_PadReceiverEnable(RTE_PWM_1L_PIN);
  }
  RSI_EGPIO_PadSelectionEnable(RTE_PWM_1L_PAD);
  RSI_EGPIO_SetPinMux(EGPIO, 0, RTE_PWM_1L_PIN, RTE_PWM_1L_MUX);

  // PWM_2L output pin mux
  if (RTE_PWM_2L_PIN > 63) {
    RSI_EGPIO_UlpPadReceiverEnable((uint8_t)(RTE_PWM_2L_PIN - 64));
    RSI_EGPIO_SetPinMux(EGPIO1, 0, (uint8_t)(RTE_PWM_2L_PIN - 64), 6);
  } else {
    RSI_EGPIO_PadReceiverEnable(RTE_PWM_2L_PIN);
  }
  RSI_EGPIO_PadSelectionEnable(RTE_PWM_2L_PAD);
  RSI_EGPIO_SetPinMux(EGPIO, 0, RTE_PWM_2L_PIN, RTE_PWM_2L_MUX);
}

/*==============================================*/
/**
 * @fn           void MCPWM_SetChannelPeriod(uint32_t freq)
 * @brief	     PWM Channel time period config
 * @param[in]    freq  PWM clock frequency
 * @return       none
 */
void MCPWM_SetChannelPeriod(uint32_t freq)
{
  uint32_t rate = 0;

  rate = SystemCoreClock / freq;

  // Set time period
  RSI_MCPWM_SetTimePeriod(MCPWM, PWM_CHNL_0, rate, COUNTER_INIT_VAL);
  RSI_MCPWM_SetTimePeriod(MCPWM, PWM_CHNL_1, rate, COUNTER_INIT_VAL);
}

/*==============================================*/
/**
 * @fn           uint32_t MCPWM_PercentageToTicks(uint8_t percent, uint8_t chnl_num)
 * @brief	     Converts duty cycle percentage to system ticks
 * @param[in]    percent  Duty cycle in percentage
 * @param[in]    chnl_num PWM channel number (0...3)
 * @return       Returns number of ticks
 */
uint32_t MCPWM_PercentageToTicks(uint8_t percent, uint8_t chnl_num)
{
  uint16_t time_period = 0;
  uint32_t ticks       = 0;

  // Get time period
  RSI_MCPWM_GetTimePeriod(MCPWM, chnl_num, &time_period);
  ticks = (time_period * percent) / 100;
  return ticks;
}

/*==============================================*/
/**
 * @fn         int main(void)
 * @brief      Main Application Function
 * @return     None
 */
int main()
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

  // Configures the system default clock and power configurations
  SystemCoreClockUpdate();

  // Initialize UART for debug prints
  DEBUGINIT();

  // Sets pin mux
  RSI_MCPWM_PinMux();
  // MCPWM clock enable
  status = RSI_CLK_PeripheralClkEnable(M4CLK, PWM_CLK, ENABLE_STATIC_CLK);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to enable PWM  clock , Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n PWM  clock is enabled \r\n");
  }
  // select number of base timers as four base timers for four channels MCPWM
  RSI_MCPWM_BaseTimerSelect(MCPWM, ONE_TIMER_FOR_EACH_CHNL);

  // Set output polarity for MCPWM
  RSI_MCPWM_SetOutputPolarity(MCPWM, 1, 1);

  // Set PWM output mode
  status =
    RSI_MCPWM_SetBaseTimerMode(MCPWM, TMR_FREE_RUN_MODE, PWM_CHNL_0); //set the mode of base timer for required channel
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to set the free running mode of base timer for  channel zero , Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Success to set PWM output mode  success \r\n");
  }

  status = RSI_MCPWM_SetBaseTimerMode(MCPWM, TMR_FREE_RUN_MODE, PWM_CHNL_1);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to set the free running mode of base timer for  channel one , Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Success to set PWM output mode for channel one \r\n");
  }

  // configure PWM Channel time period
  MCPWM_SetChannelPeriod(MCPWM_RATE);

  // Get time period for required channel.
  status = RSI_MCPWM_GetTimePeriod(MCPWM, PWM_CHNL_1, &time_period);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to get Time period  for  channel one , Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Success to get Time period  for channel one \r\n");
  }
  ticks = time_period / 2;

  // Set Duty cycle value for channel 0 and channel 1
  status = RSI_MCPWM_SetDutyCycle(MCPWM, 0, PWM_CHNL_0); // LED
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to set duty cycle  for channel zero , Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Success to set duty cycle for channel zero \r\n");
  }
  status = RSI_MCPWM_SetDutyCycle(MCPWM, ticks, PWM_CHNL_1); /* OUT */
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to set duty cycle  for channel one , Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Success to set duty cycle for channel one \r\n");
  }
  // Start PWM
  status = RSI_MCPWM_Start(MCPWM, PWM_CHNL_0); //start the MCPWM operation for required channel
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to start the MCPWM operation  for channel zero , Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Success to start the MCPWM operation for channel zero \r\n");
  }

  status = RSI_MCPWM_Start(MCPWM, PWM_CHNL_1);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to start the MCPWM operation  for channel one , Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Success to start the MCPWM operation for channel one \r\n");
  }

  // Enable SysTick Timer
  SysTick_Config(SystemCoreClock / TICKS);
  while (loop) {
    delay++;
    if (delay >= 20) {
      duty_p = duty_p + incr;
      if (duty_p < 0) {
        duty_p = 0;
        incr   = 1;
      }
      if (duty_p > 100) {
        duty_p = 100;
        incr   = -1;
        Led    = 1 - Led;
      }
      if (Led) {
        pwm_out_0 = duty_p;
        pwm_out_1 = 100;
      } else {
        pwm_out_0 = 100;
        pwm_out_1 = duty_p;
      }

      if (pwm_out_0 == 100) {
        // Enable the output override operation of MCPWM
        RSI_MCPWM_OutputOverrideEnable(MCPWM, PWM_OUTPUT_L0);

        // Set override value for the required output of MCPWM.
        RSI_MCPWM_OverrideValueSet(MCPWM, PWM_OUTPUT_L0, 1);
      } else {
        // Disable the output override operation of MCPWM
        RSI_MCPWM_OutputOverrideDisable(MCPWM, PWM_OUTPUT_L0);
        // Set duty cycle
        RSI_MCPWM_SetDutyCycle(MCPWM, MCPWM_PercentageToTicks(pwm_out_0, PWM_CHNL_0), PWM_CHNL_0); /* LED */
      }

      if (pwm_out_1 == 100) {
        // Enable the output override operation of MCPWM
        RSI_MCPWM_OutputOverrideEnable(MCPWM, PWM_OUTPUT_L1);

        // Set override value for the required output of MCPWM.
        RSI_MCPWM_OverrideValueSet(MCPWM, PWM_OUTPUT_L1, 1);
      } else {
        // Disable the output override operation of MCPWM
        RSI_MCPWM_OutputOverrideDisable(MCPWM, PWM_OUTPUT_L1);
        // Set duty cycle
        RSI_MCPWM_SetDutyCycle(MCPWM, MCPWM_PercentageToTicks(pwm_out_1, PWM_CHNL_1), PWM_CHNL_1); /* LED */
      }
      delay = 0;
    }
    __WFI();
  }
}
