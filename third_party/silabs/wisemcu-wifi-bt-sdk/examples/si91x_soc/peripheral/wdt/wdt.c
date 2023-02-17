/*******************************************************************************
* @file  rsi_wdt_example.c
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

/*================================================================================
 * @brief : This file contains example application for Watchdog Timer(WDT)
 * @section Description :
 * This Application  demonstrates the WDT warning trigger interrupt handler.
 * The watchdog generates a warning WWDT interrupt and then restarts the WWDT on
 * the warning. After 10 warning interrupts the re-start request is stopped to
 * generates a watchdog reset.
 =================================================================================*/

/**
 * Include files
 **/

#include "rsi_chip.h"
#include "rsi_board.h"

/* Private typedef ------------------------------------------------------------------------------------------------------------*/

/* Private define -------------------------------------------------------------------------------------------------------------*/
#define WDT_IRQHandler IRQ020_Handler            /*!<WDT IRQ Handler                                                */
#define NVIC_WDT       NPSS_TO_MCU_WDT_INTR_IRQn /*!<WDT NVIC IRQ Number                                            */

/* Private macro --------------------------------------------------------------------------------------------------------------*/
#define WDT_SYSTEM_RESET_TIMER \
  18 /*!<Watch dog SOC reset delay timer programming values. Counter is decremented
                                         with respect to clock tick of FSM clock. Total duration = 2^WDT_SYSTEM_RESET_TIMER
                                         FSM clocks (32Khz clock)*/
#define WDT_INTERRUPT_TIMER \
  16 /*!<watchdog window timer Total duration = 2^WDT_INTERRUPT_TIMER FSM clocks(32Khz clocks) */
#define WDT_RESET_GENERATION_CNT \
  10 /*!<Selects after how many interrupts watch dog RE-START should not provide               */
/* Private variables --------------- ----------------------------=-------------------------------------------------------------*/
static volatile uint8_t wdtIntrCnt = 0;
/* Private function prototypes ------------------------------------------------------------------------------------------------*/

/* Private functions ----------------------------------------------------------------------------------------------------------*/

/**
 * @brief  WDT interrupt handler
 * @param  None
 * @return None
 */
void WDT_IRQHandler(void)
{
  /*Clear interrupt */
  RSI_WWDT_IntrClear();
  wdtIntrCnt++;
  /*Do not re-start the WDT after 10 periodic interrupts to generate the RESET from WDT*/
  if (wdtIntrCnt < WDT_RESET_GENERATION_CNT) {
#ifdef CHIP_9118
    /*Restart the WDT */
    RSI_WWDT_ReStart(WDT);
#endif
#ifdef CHIP_9117
    /*Restart the WDT */
    RSI_WWDT_ReStart(MCU_WDT);
#endif
  }
#ifdef DEBUG_UART
  /*  Prints on hyper-terminal  */
  DEBUGOUT("WDT handler %d\r\n", wdtIntrCnt);
#endif
  /*Toggle LED0*/
  RSI_Board_LED_Toggle(0);
  return;
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int main(void)
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
	 * this is done through SystemInit() function which is called from startup
	 * file (startup_rs9116.s) before to branch to application main.
	 * To reconfigure the default setting of SystemInit() function, refer to
	 * system_rs9116.c file
	 */

  /*Configures the system default clock and power configurations*/
  SystemCoreClockUpdate();
  RSI_Board_Init();

  RSI_Board_LED_Set(1, 1);
  RSI_Board_LED_Set(2, 1);
#ifdef DEBUG_UART
  /*Enable Debug UART*/
  DEBUGINIT();
#endif

#ifdef DEBUG_UART
  DEBUGOUT("Main..!\r\n");
#endif

  /*Check the system RESET status*/
  if (RSI_PS_GetComnIntrSts() & WATCH_DOG_WINDOW_RESET_INTERRUPT) {
#ifdef DEBUG_UART
    DEBUGOUT("WDT RESET occurred..\r\n");
#endif
  } else {
#ifdef DEBUG_UART
    DEBUGOUT("Power on RESET occurred..\r\n");
#endif
  }
  /*FSM clock enable for WDT to be functional*/
  /*Enable clock sources */
  RSI_IPMU_ClockMuxSel(1);
  RSI_PS_FsmLfClkSel(KHZ_RO_CLK_SEL);
  RSI_PS_FsmHfClkSel(FSM_32MHZ_RC);
  /*Un mask WDT interrupt */
  RSI_WWDT_IntrUnMask();
  /* Time Period Programming */
  RSI_TIMEPERIOD_TimerClkSel(TIME_PERIOD, 0x003E7FFF);

#ifdef CHIP_9118
  /*configure the WDT reset and interrupt counters */
  RSI_WWDT_ConfigIntrTimer(WDT, WDT_INTERRUPT_TIMER);
  /*Configure the WDT reset value*/
  RSI_WWDT_ConfigSysRstTimer(WDT, WDT_SYSTEM_RESET_TIMER);
#endif
#ifdef CHIP_9117
  /*configure the WDT reset and interrupt counters */
  RSI_WWDT_ConfigIntrTimer(MCU_WDT, WDT_INTERRUPT_TIMER);
  /*Configure the WDT reset value*/
  RSI_WWDT_ConfigSysRstTimer(MCU_WDT, WDT_SYSTEM_RESET_TIMER);
#endif

  /*NVIC interrupt enables*/
  NVIC_EnableIRQ(NVIC_WDT);

#ifdef CHIP_9118
  /*Start WDT */
  RSI_WWDT_Start(WDT);
#endif
#ifdef CHIP_9117
  /*Start WDT */
  RSI_WWDT_Start(MCU_WDT);
#endif

  /*Wait for interrupt*/
  while (1) {
    __ASM("WFI");
  }
}
