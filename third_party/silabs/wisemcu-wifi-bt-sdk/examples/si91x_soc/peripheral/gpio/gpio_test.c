/*******************************************************************************
 * @file  gpio_test.c
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

#define M4_GPIO_PIN
//#define ULP_GPIO_PIN
//#define UULP_GPIO_PIN

#define PORT 0      // Port selection
#define PIN  6      // Pin number to connect

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

  // Configures the system default clock and power configurations 
  SystemCoreClockUpdate();

  // Initialize UART for debug prints  
  DEBUGINIT();

#ifdef M4_GPIO_PIN
  DEBUGOUT("\r\n M4_GPIO_PIN test starts \r\n");
  if (PIN > 24 && PIN < 31) {
    RSI_EGPIO_HostPadsGpioModeEnable(PIN);
  }
	// Enable pad selection for gpio pins
  // PadSelection-9 related GPIOS are preconfigured for Other Functions 
	for (pad_sel = 1; pad_sel < 34; pad_sel++) {
	      if(pad_sel!=9){
	          RSI_EGPIO_PadSelectionEnable(pad_sel);
	        }
  }
  // Set pin 0 in GPIO mode  
  RSI_EGPIO_SetPinMux(EGPIO, PORT, PIN, EGPIO_PIN_MUX_MODE0);

  // Set output direction  
  RSI_EGPIO_SetDir(EGPIO, PORT, PIN, EGPIO_CONFIG_DIR_OUTPUT);

  while (forever) {
    // Toggle gpio in loop 
    RSI_EGPIO_SetPin(EGPIO, PORT, PIN, 0);
    RSI_EGPIO_SetPin(EGPIO, PORT, PIN, 1);
  }
#endif

#ifdef ULP_GPIO_PIN
  DEBUGOUT("\r\n ULP_GPIO_PIN test starts \r\n");
  // Set pin 0 in GPIO mode  
  RSI_EGPIO_SetPinMux(EGPIO1, PORT, PIN, EGPIO_PIN_MUX_MODE0);
  // Set output direction  
  RSI_EGPIO_SetDir(EGPIO1, PORT, PIN, EGPIO_CONFIG_DIR_OUTPUT);
  while (1) {
    // Toggle gpio in loop 
    RSI_EGPIO_SetPin(EGPIO1, PORT, PIN, 1);
    RSI_EGPIO_SetPin(EGPIO1, PORT, PIN, 0);
  }
#endif

#ifdef UULP_GPIO_PIN
  DEBUGOUT("\r\n UULP_GPIO_PIN test starts \r\n");
  // NPSS GPIO  
  RSI_NPSSGPIO_InputBufferEn(PIN, 1U);

  RSI_NPSSGPIO_SetPinMux(PIN, 0);

  RSI_NPSSGPIO_SetDir(PIN, NPSS_GPIO_DIR_OUTPUT);

  while (1) {
    // Toggle gpio in loop 
    RSI_NPSSGPIO_SetPin(PIN, 0U);
    RSI_NPSSGPIO_SetPin(PIN, 1U);
  }
#endif

  //Statement will never reach here , just to satisfy the standard main 
  return 0;
}