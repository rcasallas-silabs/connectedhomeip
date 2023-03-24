/*******************************************************************************
* @file  push_button_app.c
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

/* Includes -------------------------------------------------------------------------------------------------------*/
#include "push_button_app.h"
#include "app_config.h"

#ifdef RSI_WITH_OS
#include "rsi_os.h"
#include <FreeRTOS.h>
#include "task.h"
extern rsi_semaphore_handle_t pwm_thread_sem;
#endif

/* Private typedef ------------------------------------------------------------------------------------------------*/

/* Private define -------------------------------------------------------------------------------------------------*/
//#define LEVEL_HIGH //Enable the define for level high interrrupt detection
#define LEVEL_LOW //Enable the define for level low interrrupt detection
//#define FALL_EDGE //Enable the define for fall edge  interrrupt detection
//#define RISE_EDGE //Enable the define for rise edge interrrupt detection
/* Private macro --------------------------------------------------------------------------------------------------*/
#define NPSS_GPIO_IRQHandler IRQ021_Handler
#define NPSS_GPIO_NVIC       NPSS_TO_MCU_GPIO_INTR_IRQn

/* Private variables ----------------------------------------------------------------------------------------------*/

/* Private function prototypes ------------------------------------------------------------------------------------*/

/* Private functions ----------------------------------------------------------------------------------------------*/
extern volatile uint32_t peripheral;
/**
 * @brief	Interrupt handler
 * @return	Nothing
 */

void NPSS_GPIO_IRQHandler(void)
{
  volatile uint32_t intrStatus = 0;

  intrStatus = RSI_NPSSGPIO_GetIntrStatus();

  if (intrStatus & NPSS_GPIO_2_INTR) {
    RSI_NPSSGPIO_ClrIntr(NPSS_GPIO_2_INTR);
  }
#ifdef RSI_WITH_OS
  rsi_semaphore_post_from_isr(&pwm_thread_sem);
#else
  peripheral = PWM;
#endif
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int Push_Button_Intr(void)
{
  /* At this stage the microcontroller clock setting is already configured,
	 * this is done through SystemInit() function which is called from startup
	 * file (startup_rs9116.s) before to branch to application main.
	 * To reconfigure the default setting of SystemInit() function, refer to
	 * system_rs9116.c file
	 */
  /* Enable NPSS GPIO input buffer */
  RSI_NPSSGPIO_InputBufferEn(NPSS_GPIO_2, 1);

  /* Set the NPSS GPIO pin MUX */
  RSI_NPSSGPIO_SetPinMux(NPSS_GPIO_2, 2);

  /* Set the direction of the NPSS GPIO */
  RSI_NPSSGPIO_SetDir(NPSS_GPIO_2, NPSS_GPIO_DIR_INPUT);

#ifdef LEVEL_HIGH
  /* Enables level 1 interrupt detection for UULP_VBAT_GPIO_0 */
  RSI_NPSSGPIO_SetIntLevelHighEnable(NPSS_GPIO_2_INTR);
#endif
#ifdef RISE_EDGE
  /* Enables rise edge interrupt detection for UULP_VBAT_GPIO_0 */
  RSI_NPSSGPIO_SetIntRiseEdgeEnable(NPSS_GPIO_2_INTR);
#endif
#ifdef FALL_EDGE
  /* Enables fall edge interrupt detection for UULP_VBAT_GPIO_0 */
  RSI_NPSSGPIO_SetIntFallEdgeEnable(NPSS_GPIO_2_INTR);
#endif
#ifdef LEVEL_LOW
  /* Enables level 0 interrupt detection for UULP_VBAT_GPIO_0 */
  RSI_NPSSGPIO_SetIntLevelLowEnable(NPSS_GPIO_2_INTR);
#endif
  /* un mask the NPSS GPIO interrupt */
  RSI_NPSSGPIO_IntrUnMask(NPSS_GPIO_2_INTR);

  /*  NVIC Enable */
  NVIC_EnableIRQ(NPSS_TO_MCU_GPIO_INTR_IRQn);

  NVIC_SetPriority(NPSS_TO_MCU_GPIO_INTR_IRQn, 7);

  return 0;
}
