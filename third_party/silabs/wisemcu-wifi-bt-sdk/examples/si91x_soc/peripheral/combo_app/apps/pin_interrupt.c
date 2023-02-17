/*******************************************************************************
 * @file pin_interrupt.c
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

/*==================================================================================
 * @brief : This file contains example application for M4 Pin Interrupt
 * @section Description :
 * This example configures a pin to contribute for pin interrupt. It uses the pin
 * for interrupt generation with level low event enable, for level low event on
 * input pin generates pin interrupt.
 ===================================================================================*/

/**
 * Include files
 **/

#include "pin_interrupt.h"
#include "app_config.h"
#ifdef RSI_WITH_OS
#include "rsi_os.h"
#endif
/* Private typedef ------------------------------------------------------------------------------------------------*/

/* Private define -------------------------------------------------------------------------------------------------*/

/* Private macro --------------------------------------------------------------------------------------------------*/
#define PININT0_NVIC_NAME     EGPIO_PIN_0_IRQn
#define PININT0_IRQ_HANDLER   IRQ052_Handler   /* GPIO interrupt IRQ function name            */
#define PIN_INT0              0                /* Pin  interrupt number(0 to 7)               */
#define M4_GPIO_PORT          0                /* GPIO port number                            */
#define M4_GPIO_PIN0          11                /* GPIO pin number                             */
#define PIN0_PAD              6                /* GPIO pin number                             */

/* Private variables ----------------------------------------------------------------------------------------------*/
extern volatile uint32_t peripheral;

/* Private function prototypes ------------------------------------------------------------------------------------*/

/* Private functions ----------------------------------------------------------------------------------------------*/

/**
 * @brief	Interrupt handler
 * @return	Nothing
 */

void PININT0_IRQ_HANDLER(void)
{
  uint32_t gintStatus;

  /*get interrupt status*/
  gintStatus = RSI_EGPIO_GetIntStat(EGPIO, PIN_INT0);

  if ((gintStatus & EGPIO_PIN_INT_CLR_RISING) || (gintStatus & EGPIO_PIN_INT_CLR_FALLING)) {
      /*clear interrupt*/
      RSI_EGPIO_IntClr(EGPIO, PIN_INT0, INTERRUPT_STATUS_CLR);
  } else {
      RSI_EGPIO_IntMask(EGPIO, PIN_INT0);
  }
  #ifndef RSI_WITH_OS
  peripheral = PIN_INTERRUPT;
  #endif
  return;
}

int Pin_Int0(void)
{
  /* At this stage the microcontroller clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_rs9116.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * system_rs9116.c file
   */
  /*Enable clock for EGPIO module*/
  RSI_CLK_PeripheralClkEnable(M4CLK, EGPIO_CLK, ENABLE_STATIC_CLK);

  if (M4_GPIO_PIN0 > 24 && M4_GPIO_PIN0 < 31)
    {
      RSI_EGPIO_HostPadsGpioModeEnable(M4_GPIO_PIN0);
    }
  else
    {
      /*PAD selection*/
      RSI_EGPIO_PadSelectionEnable(PIN0_PAD);
    }

  /*REN enable */
  RSI_EGPIO_PadReceiverEnable(M4_GPIO_PIN0);

  /*Configure default GPIO mode(0) */
  RSI_EGPIO_SetPinMux(EGPIO, M4_GPIO_PORT, M4_GPIO_PIN0, EGPIO_PIN_MUX_MODE0);

  /*Selects the pin interrupt for the GPIO*/
  RSI_EGPIO_PinIntSel(EGPIO, PIN_INT0, M4_GPIO_PORT, M4_GPIO_PIN0);

  /*Configures the edge /level interrupt*/
  RSI_EGPIO_SetIntRiseEdgeEnable(EGPIO, PIN_INT0);

  /*Unmask the  interrupt*/
  RSI_EGPIO_IntUnMask(EGPIO, PIN_INT0);

  /*NVIC enable */
  NVIC_EnableIRQ(PININT0_NVIC_NAME);

  NVIC_SetPriority(PININT0_NVIC_NAME, 7);

  return RSI_OK;
}
