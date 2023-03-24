/*******************************************************************************
 * @file  ulp_gpio.c
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
 * @brief : This file contains example application for GPIO Test
 * @section Description :
 * This application demonstrates toggling of GPIO pin in a loop
 ============================================================================**/

// Include Files

#include "rsi_chip.h"
#include "rsi_board.h"

#define RESERVED_IRQ_COUNT   16
#define EXT_IRQ_COUNT        98
#define VECTOR_TABLE_ENTRIES (RESERVED_IRQ_COUNT + EXT_IRQ_COUNT)
uint32_t ramVector[VECTOR_TABLE_ENTRIES] __attribute__((aligned(256)));

void hardware_setup(void);
#define ULP_GPIO_PIN

#define PORT 0 //port selection
#define PIN  6 //gpio_pin selection

/*==============================================*/
/**
 * @fn     int main(void)
 * @brief  Main Application Function
 * @return None
 */
int main(void)
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_RS1xxxx.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * system_RS1xxxx.c file
   */
  int forever = 1, analog_pin = 0, pad_sel;

  //copying the vector table from flash to ram
  memcpy(ramVector, (uint32_t *)SCB->VTOR, sizeof(uint32_t) * VECTOR_TABLE_ENTRIES);

  //assing the ram vector adress to VTOR register
  SCB->VTOR = (uint32_t)ramVector;

  // Configures the system default clock and power configurations
  SystemCoreClockUpdate();

  /* Switching MCU from PS4 to PS2 state */
  hardware_setup();

#ifdef ULP_GPIO_PIN
  // Set pin in GPIO mode
  RSI_EGPIO_SetPinMux(EGPIO1, PORT, PIN, EGPIO_PIN_MUX_MODE0);
  // Set output direction
  RSI_EGPIO_SetDir(EGPIO1, PORT, PIN, EGPIO_CONFIG_DIR_OUTPUT);

  // Toggle gpio pin from High to Low
  RSI_EGPIO_SetPin(EGPIO1, PORT, PIN, 1);
  RSI_EGPIO_SetPin(EGPIO1, PORT, PIN, 0);

#endif
  //Statement will never reach here , just to satisfy the standard main
  return 0;
}
