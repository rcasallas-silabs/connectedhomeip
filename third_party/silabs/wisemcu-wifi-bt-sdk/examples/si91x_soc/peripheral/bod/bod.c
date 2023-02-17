/*******************************************************************************
* @file  rsi_bod_example.c
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

/**
 * Include files
 * */

#include "rsi_chip.h"
#include "rsi_board.h"
#include "rsi_bod.h"
#include "rsi_chip.h"
#include "rsi_board.h"
#include "rsi_ps_ram_func.h"
#include "rsi_ds_timer.h"

/* Private typedef -----------------------------------------------------------*/

/* Private define ------------------------------------------------------------*/

/* Private macro -------------------------------------------------------------*/
/* Uncommenent one of the below to select the mode */
/* Note:one of that should be in commnet  */
#define AUTOMATIC
//#define MANUAL
/* Mode selection */
#define PMU_GOOD_TIME                 31 /*Duration in us*/
#define XTAL_GOOD_TIME                31 /*Duration in us*/
#define MANUAL_MODE                   0
#define AUTOMATIC_MODE                1
#define ENABLE                        1
#define DISABLE                       0
#define BOD_THRESHOLD                 3.35 /* Min is 1.8v Max is 3.5v*/
#define SLOT_VALUE                    2
#define NVIC_BOD                      NPSS_TO_MCU_BOD_INTR_IRQn
#define NVIC_BUTTON                   NPSS_TO_MCU_BUTTON_INTR_IRQn
#define NPSS_TO_MCU_BUTTON_IRQHandler IRQ024_Handler
#define NPSS_TO_MCU_BOD_IRQHandler    IRQ023_Handler

/* Private variables ---------------------------------------------------------*/
volatile float vbatt_status = 0;
/* Private function prototypes -----------------------------------------------*/

/* Private functions ---------------------------------------------------------*/
/**
 * @brief	  Handle interrupt from BOD
 * @return	Nothing
 */
void NPSS_TO_MCU_BOD_IRQHandler(void)
{
  DEBUGOUT("Vbatt status is less than the threshold voltage i.e %dV \n", (int)RSI_BOD_SoftTriggerGetBatteryStatus());
/* Clears the BOD interrupt */
  RSI_BOD_IntrClr();
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int main(void)
{
  volatile static uint32_t t_value = 0, button_number = 0;
  /*Configures the system default clock and power configurations*/
  SystemCoreClockUpdate();
#ifdef DEBUG_UART
  /*Init debug UART*/
  DEBUGINIT();
#endif
#ifdef AUTOMATIC
  /*BOD enable and set the threshold value */
  DEBUGOUT("\r\n Set BOD Threshold Value \r\n");
  RSI_BOD_Enable(ENABLE, BOD_THRESHOLD);

  /* set the slot value */
  DEBUGOUT("\r\n Set Slot Value \r\n");
  RSI_BOD_ConfigSlotValue(SLOT_VALUE);

  /*set the BOD to automatic  mode*/
  DEBUGOUT("\r\n Set BOD Mode \r\n");
  RSI_BOD_SetMode(AUTOMATIC_MODE);

  /*enable bod interrupt */
  RSI_BOD_IntrEnable(ENABLE);

  RSI_BOD_BodTestSel(1, 3);
  /*Gets the threshold value */

  /* BOD NVIC enable  */
  NVIC_EnableIRQ(NVIC_BOD);

  t_value = RSI_BOD_GetThreshold();
  DEBUGOUT("\r\n Calibrated Threshold Value is %X\r\n", t_value);
#endif

#ifdef MANUAL
  RSI_BOD_BodTestSel(1, 3);
  /*BOD enable and set the threshold value */
  DEBUGOUT("\r\n Set BOD Threshold Value \r\n");
  RSI_BOD_Enable(ENABLE, BOD_THRESHOLD);

  /*set the BOD to automatic  mode*/
  DEBUGOUT("\r\n Set BOD Mode \r\n");

  RSI_BOD_SetMode(MANUAL_MODE);

  /*enable bod interrupt */
  RSI_BOD_IntrEnable(ENABLE);
  /* BOD NVIC enable  */
  NVIC_EnableIRQ(NVIC_BOD);

#endif

  while (1) {

    __WFI();
  }
}
