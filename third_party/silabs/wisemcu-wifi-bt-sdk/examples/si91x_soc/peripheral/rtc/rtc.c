/*******************************************************************************
* @file  rsi_rtc_example.c
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
 * @brief : This file contains example application for Real Time Clock (RTC)
 * @section Description :
 * This example demonstrates how to configure the Real Time Clock (RTC) in MCU chip.
 * It explains the periodic alarm configuration for every 5 sec with alarm ISR.
 * RTC milli seconds and seconds interrupts are also enabled in this example.
 ===================================================================================*/

/**
 * Include files
 **/

#include "rsi_chip.h"
#include "rsi_board.h"

/* Private typedef -----------------------------------------------------------*/

/* Private define ------------------------------------------------------------*/
#define NPSS_ALARM_IRQHandler IRQ028_Handler     /*<! Alarm IRQ Handler     */
#define NPSS_RTC_IRQ_Handler  IRQ029_Handler     /*<! RTC IRQ Handler       */
#define NVIC_RTC_ALARM        MCU_CAL_ALARM_IRQn /*<! RTC NVIC enable  */
#define NVIC_RTC              MCU_CAL_RTC_IRQn   /*<! RTC GPIO NVIC enable  */

/* Private macro -------------------------------------------------------------*/
#define ALARM_PERIODIC_TIME       5 /*<! periodic alarm configuration in SEC */
#define NO_OF_HOURS_IN_A_DAY      24
#define NO_OF_MINUTES_IN_AN_HOUR  60
#define NO_OF_SECONDS_IN_A_MINUTE 60
#define NO_OF_MONTHS_IN_A_YEAR    12
#define BASE_YEAR                 2000
#define NO_OF_DAYS_IN_A_MONTH_1   28
#define NO_OF_DAYS_IN_A_MONTH_2   29
#define NO_OF_DAYS_IN_A_MONTH_3   30
#define NO_OF_DAYS_IN_A_MONTH_4   31

#define ENABLE_RC_CLOCK   1         //By using macro enable the Rc_Clock
#define ENABLE_RO_CLOCK   0         //By using macro enable the Ro_Clock
#define ALARM_INTR        1         //By using macro enable the ALARM_INTR
#define MILLI_SEC_INTR    0         //By using macro enable the MILLI_SEC_INTR
#define SEC_INTR          0         //By using macro enable the SEC_INTR
#define GPIO_TOGGLE       1         //By using macro enable the GPIO_TOGGLE


/* Private variables ---------------------------------------------------------*/
/*<!RTC configuration structures     */

/* Private function prototypes -----------------------------------------------*/

/* Private functions ---------------------------------------------------------*/

/**
 * @brief  This is  Sec and msec IRQ handler of RTC
 * @param  None
 * @return None
 */
void NPSS_RTC_IRQ_Handler(void)
{
  volatile uint32_t statusRead = 0;

  statusRead = RSI_RTC_GetIntrStatus();

  #if GPIO_TOGGLE
   
   RSI_EGPIO_SetPinMux(EGPIO1, 0, 5, EGPIO_PIN_MUX_MODE0);     //Set pin 0 in GPIO mode
   
   RSI_EGPIO_SetDir(EGPIO1, 0, 5, EGPIO_CONFIG_DIR_OUTPUT);    //Set output direction

   RSI_EGPIO_SetPin(EGPIO1, 0, 5, 1);

   RSI_EGPIO_SetPin(EGPIO1, 0, 5, 0);
  #endif

  /*Clear the milli seconds interrupt */
  if (statusRead & NPSS_TO_MCU_MSEC_INTR) {
    RSI_RTC_IntrClear(NPSS_TO_MCU_MSEC_INTR);
  }

  if (statusRead & NPSS_TO_MCU_SEC_INTR) {
    RSI_RTC_IntrClear(NPSS_TO_MCU_SEC_INTR);
  }
  return;
}

/**
 * @brief  This is Alarm IRQ Handler
 * @param  None
 * @return None
 */
void NPSS_ALARM_IRQHandler(void)
{
  volatile uint32_t statusRead = 0;
  static RTC_TIME_CONFIG_T alarmConfig, readTime;
  /*Get the interrupt status */
  statusRead = RSI_RTC_GetIntrStatus();
  if (statusRead & NPSS_TO_MCU_ALARM_INTR) {
    RSI_RTC_GetDateTime(RTC, &alarmConfig);
    /*Clear wake up interrupt */
    RSI_RTC_IntrClear(RTC_ALARM_INTR);

    /*Update seconds for next boundary alarm */
    alarmConfig.Second += (ALARM_PERIODIC_TIME % 60);
    if (alarmConfig.Second >= (NO_OF_SECONDS_IN_A_MINUTE)) {
      alarmConfig.Second -= NO_OF_SECONDS_IN_A_MINUTE;
      alarmConfig.Minute += 1;
    }
    /*Update minutes for next boundary alarm */
    alarmConfig.Minute += ((ALARM_PERIODIC_TIME / 60) % 60);
    if (alarmConfig.Minute >= (NO_OF_MINUTES_IN_AN_HOUR)) {
      alarmConfig.Minute -= NO_OF_MINUTES_IN_AN_HOUR;
      alarmConfig.Hour += 1;
    }
    /*Update date for next boundary alarm */
    alarmConfig.Hour += (ALARM_PERIODIC_TIME / 3600) % 24;
    if (alarmConfig.Hour >= (NO_OF_HOURS_IN_A_DAY)) {
      alarmConfig.Hour -= NO_OF_HOURS_IN_A_DAY;
      alarmConfig.Day += 1;
    }

    if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_1) {
      if (alarmConfig.Month == Febuary) {
        if (alarmConfig.Year % 4) {
          alarmConfig.Day = 1;
          alarmConfig.Month += 1;
        } else if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_2) {
          alarmConfig.Day = 1;
          alarmConfig.Month += 1;
        }
      }
      if (alarmConfig.Month <= July) {
        if (alarmConfig.Month % 2) {
          if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_3) {
            alarmConfig.Day = 1;
            alarmConfig.Month += 1;
          }
        } else if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_4) {
          alarmConfig.Day = 1;
          alarmConfig.Month += 1;
        }

      } else if (alarmConfig.Month % 2 == 0) {
        if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_4) {
          alarmConfig.Day = 1;
          alarmConfig.Month += 1;
        }
      } else if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_3) {
        alarmConfig.Day = 1;
        alarmConfig.Month += 1;
      }
    }
    if (alarmConfig.Month > (NO_OF_MONTHS_IN_A_YEAR)) {
      alarmConfig.Month = January;
      alarmConfig.Year += 1;
    }

    /*Reconfigure the Alarm for next alarm boundary*/
    RSI_RTC_SetAlarmDateTime(RTC, &alarmConfig);
  }
  RSI_RTC_GetDateTime(RTC, &readTime);
#ifdef DEBUG_UART
  DEBUGOUT("\n***RTC time****\n");
  DEBUGOUT("TIME: %d:%d:%d:%d\n", readTime.Hour, readTime.Minute, readTime.Second, readTime.MilliSeconds);
  DEBUGOUT("DATE: %d/%d/%d\n\n", readTime.Day, readTime.Month, (readTime.Year + 2000));
  RSI_RTC_GetAlarmDateTime(RTC, &readTime);
  DEBUGOUT("***Next alarmtime****\n");
  DEBUGOUT("ALARMTIME: %d:%d:%d:%d\n", readTime.Hour, readTime.Minute, readTime.Second, readTime.MilliSeconds);
  DEBUGOUT("ALARMDATE: %d/%d/%d\n\n", readTime.Day, readTime.Month, (readTime.Year + 2000));
#endif // DEBUG_UART
  return;
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int main(void)
{
  static RTC_TIME_CONFIG_T rtcConfig, alarmConfig, rtc_get_Time;
  /*Configures the system default clock and power configurations*/
  SystemCoreClockUpdate();

  #if ENABLE_RO_CLOCK
    RSI_PS_FsmLfClkSel(KHZ_RO_CLK_SEL);
  #endif

  #if ENABLE_RC_CLOCK
    RSI_PS_FsmLfClkSel(KHZ_RC_CLK_SEL);
  #endif

#ifdef DEBUG_UART
  /*Init debug UART*/
  DEBUGINIT();
#endif
  /*Init RTC*/
  RSI_RTC_Init(RTC);

  /*RTC configuration with some default time */
  rtcConfig.DayOfWeek    = Saturday;
  rtcConfig.Month        = March;
  rtcConfig.Day          = 19;
  rtcConfig.Century      = 0;
  rtcConfig.Year         = 19;
  rtcConfig.Hour         = 23;
  rtcConfig.Minute       = 59;
  rtcConfig.Second       = 50;
  rtcConfig.MilliSeconds = 0;
  /*start RTC */
  RSI_RTC_Start(RTC);
  /*Set the RTC configuration*/
  RSI_RTC_SetDateTime(RTC, &rtcConfig);
  RSI_RTC_GetDateTime(RTC, &rtc_get_Time);
  /*RTC alarm configuration */
  alarmConfig.DayOfWeek    = rtc_get_Time.DayOfWeek;
  alarmConfig.Month        = rtc_get_Time.Month;
  alarmConfig.Century      = rtc_get_Time.Century;
  alarmConfig.MilliSeconds = rtc_get_Time.MilliSeconds;
  alarmConfig.Day          = rtc_get_Time.Day;
  alarmConfig.Year         = rtc_get_Time.Year;
  alarmConfig.Minute       = rtc_get_Time.Minute;
  alarmConfig.Hour         = rtc_get_Time.Hour;
  /*Update seconds for next boundary alarm */
  alarmConfig.Second = rtcConfig.Second + (ALARM_PERIODIC_TIME % 60);
  if (alarmConfig.Second >= (NO_OF_SECONDS_IN_A_MINUTE)) {
    alarmConfig.Second -= NO_OF_SECONDS_IN_A_MINUTE;
    alarmConfig.Minute += 1;
  }
  /*Update minutes for next boundary alarm */
  alarmConfig.Minute = alarmConfig.Minute + ((ALARM_PERIODIC_TIME / 60) % 60);
  if (alarmConfig.Minute >= (NO_OF_MINUTES_IN_AN_HOUR)) {
    alarmConfig.Minute -= NO_OF_MINUTES_IN_AN_HOUR;
    alarmConfig.Hour += 1;
  }
  /*Update date for next boundary alarm */
  alarmConfig.Hour = alarmConfig.Hour + (ALARM_PERIODIC_TIME / 3600) % 24;
  if (alarmConfig.Hour >= (NO_OF_HOURS_IN_A_DAY)) {
    alarmConfig.Hour -= NO_OF_HOURS_IN_A_DAY;
    alarmConfig.Day += 1;
  }
  if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_1) {
    if (alarmConfig.Month == Febuary) {
      if (alarmConfig.Year % 4) {
        alarmConfig.Day = 1;
        alarmConfig.Month += 1;
      } else if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_2) {
        alarmConfig.Day = 1;
        alarmConfig.Month += 1;
      }
    }
    if (alarmConfig.Month <= July) {
      if (alarmConfig.Month % 2 == 0) {
        if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_3) {
          alarmConfig.Day = 1;
          alarmConfig.Month += 1;
        }
      } else if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_4) {
        alarmConfig.Day = 1;
        alarmConfig.Month += 1;
      }

    } else if (alarmConfig.Month % 2 == 0) {
      if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_4) {
        alarmConfig.Day = 1;
        alarmConfig.Month += 1;
      }
    } else if (alarmConfig.Day > NO_OF_DAYS_IN_A_MONTH_3) {
      alarmConfig.Day = 1;
      alarmConfig.Month += 1;
    }
  }
  if (alarmConfig.Month > (NO_OF_MONTHS_IN_A_YEAR)) {
    alarmConfig.Month = January;
    alarmConfig.Year += 1;
  }

  /*Set Alarm configuration */
  RSI_RTC_SetAlarmDateTime(RTC, &alarmConfig);
  /*Enable Alarm feature*/
  RSI_RTC_AlamEnable(RTC, ENABLE);

  #if ALARM_INTR
  /*Enable RTC ALARM interrupt*/
    RSI_RTC_IntrUnMask(RTC_ALARM_INTR);
  #endif

  #if SEC_INTR
  /*Enable RTC seconds interrupts\*/
    RSI_RTC_IntrUnMask(RTC_SEC_INTR);
  #endif

  #if MILLI_SEC_INTR
  /*Enable RTC Milli-seconds interrupt\*/
    RSI_RTC_IntrUnMask(RTC_MSEC_INTR);
  #endif

  /*Initilization RTC CALIBRATION*/
  RSI_RTC_CalibInitilization();
  /* To calibrate rc and ro */
  RSI_RTC_ROCLK_Calib(TIME_PERIOD, 1, 1, 3, 1, 1, 0);
  /*Start RTC */
  RSI_RTC_Start(RTC);
  /*Enable NVIC for RTC */
  NVIC_EnableIRQ(NVIC_RTC_ALARM);
  /*Enable NVIC for Sec and milli second interrupts */
  NVIC_EnableIRQ(NVIC_RTC);

  while (1) {
    /*Wait for interrupt */
    __WFI();
  }
  /*Code will never reach here,Just to satisfy the standard main*/
}
