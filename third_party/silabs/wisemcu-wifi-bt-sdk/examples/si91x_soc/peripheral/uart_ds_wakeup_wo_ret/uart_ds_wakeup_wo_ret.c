/*******************************************************************************
* @file  uart_ds_wakeup_wo_ret.c
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
/*================================================================================
 * @brief : This file contains example application for power save.
 * @section Description :
 * Without retention deepsleep test application demonstrates the disconnected sleep
 * power save functionality of Silabs device.M4 & NWP both are Without ram retain
 * so after sleep wakeup M4 should start starting of application and has to load
 * firmware for NWP ,these steps should happen repeatedly after sleep wakeup states.
	=================================================================================*/

/**
 * Include files
 * */

#include "rsi_data_types.h"

//! COMMON include file to refer wlan APIs
#include "rsi_common_apis.h"

//! WLAN include file to refer wlan APIs
#include "rsi_wlan_apis.h"
#include "rsi_wlan_non_rom.h"

//! socket include file to refer socket APIs
#include "rsi_socket.h"

//! Error include files
#include "rsi_error.h"

//! Hardware and powersave related include files
#include "rsi_board.h"
#include "rsi_chip.h"
#include "rsi_ps_ram_func.h"
#include "rsi_wisemcu_hardware_setup.h"
#include "rsi_m4.h"
#include "rsi_common.h"
#include "rsi_ds_timer.h"

//! Access point SSID to connect
#define SSID "SILABS_AP"

#define SCAN_CHANNEL 0

//! Power Save Profile Mode
#define PSP_TYPE RSI_MAX_PSP

//! Runs scheduler for some delay and do not send any command
#define RSI_DELAY 6000000

//! Memory length for driver
#define GLOBAL_BUFF_LEN 15000

//! Memory to initialize driver
uint8_t global_buf[GLOBAL_BUFF_LEN];

#ifdef SEC_BASED_WKP
void RSI_RTC_Sec_based_wkp_init(void);
/* RTC defines */
#define NVIC_RTC MCU_CAL_RTC_IRQn /*<! RTC NVIC enable   */
#endif

#ifdef UULP_GPIO_BASED_WKP
/*Configure the UULP GPIO 2 as wakeup source */
void RSI_Wakeupsw_config(void);
#endif

#ifdef DS_BASED_WKP
void RSI_DS_Timer_Init(void);
/* DS Timer defines*/
#define DS_IRQ            IRQ027_Handler     /*<! DS IRQ Handler */
#define NVIC_DS_TIMER     NPSS_MCU_INTR_IRQn /*<! DS Timer NVIC enable   */
#define DS_TIMER_DURATION 20000000
#endif

#ifdef ALARM_CONFIG
void InitM4AlarmConfig(void);
void RSI_Set_Alarm_Intr_Time(uint16_t interval);
static RTC_TIME_CONFIG_T rtcConfig, readTime, alarmConfig, readAlarmConfig, rtc_get_Time;
#define RTC_ALARM_IRQHandler IRQ028_Handler
#define NVIC_RTC_ALARM       MCU_CAL_ALARM_IRQn
#define RC_TRIGGER_TIME      3
#define RO_TRIGGER_TIME      0

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
#endif

#ifdef COMMON_FLASH_EN
#define IVT_OFFSET_ADDR 0x8212000 /*<!Application IVT location VTOR offset>        */
#else
#define IVT_OFFSET_ADDR 0x8012000 /*<!Application IVT location VTOR offset>        */
#endif
#define WKP_STACK_USAGE_LOCATION   0x1b000 /*<!Bootloader stack usage location upon wake up> */
#define WKP_CB_ADDRESS             0x1e000 /*<!Bootloader Control block usage loacation upon wake up>*/
#define WIRELESS_WAKEUP_IRQHandler NPSS_TO_MCU_WIRELESS_INTR_IRQn

int uart_app(void);
void M4_sleep_wakeup()
{
  //! Trigger M4 sleep
  RSI_WISEMCU_TriggerSleep(SLEEP_WITHOUT_RETENTION,
                           DISABLE_LF_MODE,
                           WKP_STACK_USAGE_LOCATION,
                           WKP_CB_ADDRESS,
                           IVT_OFFSET_ADDR,
                           RSI_WAKEUP_WO_RETENTION_WO_ULPSS_RAM);
}

void HardFault_Handler()
{
  while (1) {
    DEBUGOUT("HardFault_Handler\n");
  }
}

int32_t rsi_powersave_profile_app()
{

  int32_t status = RSI_SUCCESS;
#if ((defined ALARM_CONFIG) || (defined DS_BASED_WKP) || (defined UULP_GPIO_BASED_WKP) || (defined SEC_BASED_WKP))
  uint8_t xtal_enable;
#endif

  /* MCU Hardware Configuration for Low-Power Applications */
  RSI_WISEMCU_HardwareSetup();

  //! WC initialization
  status = rsi_wireless_init(0, 0);
  if (status != RSI_SUCCESS) {
    DEBUGOUT("\r\nWireless Initialization Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nWireless Initialization Success\r\n");
  }

#if ((defined ALARM_CONFIG) || (defined DS_BASED_WKP) || (defined UULP_GPIO_BASED_WKP) || (defined SEC_BASED_WKP))
  //! First byte of input_data reserved/used for enable(1) or Disable(0) for the sub_cmd. Remaining bype would be used for input data .
  xtal_enable = 1;
  status      = rsi_cmd_m4_ta_secure_handshake(RSI_ENABLE_XTAL, 1, &xtal_enable, 0, NULL);
  if (status != RSI_SUCCESS) {
    return status;
  }
#endif
  //! Scan for Access Point
  status = rsi_wlan_scan((int8_t *)SSID, (uint8_t)SCAN_CHANNEL, NULL, 0);
  if (status != RSI_SUCCESS) {
    DEBUGOUT("\r\nWLAN AP Scan Failed, Error Code : 0x%X\r\n", status);
  }

  else {
    DEBUGOUT("\r\nWLAN AP Scan Success\r\n");
  }
  //! Apply power save profile with deep sleep
  DEBUGOUT("\r\n Start Powersave Command\r\n");
  status = rsi_wlan_power_save_profile(RSI_SLEEP_MODE_10, PSP_TYPE);
  if (status != RSI_SUCCESS) {
    DEBUGOUT("\r\n Powersave Command Failed ,Error code :0x%x \r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Powersave Command Success\r\n");
  }
  rsi_delay_ms(2000);
#ifdef SEC_BASED_WKP
  RSI_RTC_Sec_based_wkp_init();
  /* Time Period Programming */
  RSI_TIMEPERIOD_TimerClkSel(TIME_PERIOD, 0x003E7FFF);
#endif

#ifdef ALARM_CONFIG
  InitM4AlarmConfig();
  RSI_Set_Alarm_Intr_Time(ALARM_PERIODIC_TIME);
#endif
#ifdef DS_BASED_WKP
  //TODO :Need to add DS_BASED_WKP macro in rsi_wisemcu_hardware_setup.c to donot powerdown deepsleep and
  // time period domain in hardware setup
  RSI_DS_Timer_Init();
  /* Time Period Programming */
  RSI_TIMEPERIOD_TimerClkSel(TIME_PERIOD, 0x003E7FFF);
#endif

#ifdef UULP_GPIO_BASED_WKP
  /*Configure the UULP GPIO 2 as wakeup source */
  RSI_Wakeupsw_config();
#endif //end of UULP_GPIO_BASED_WKP

  //! Keep M4 in to sleep here
  DEBUGOUT("\r\n Keep M4 in Sleep\r\n");
  M4_sleep_wakeup();
  return status;
}

void app_task()
{
  ////////////////////////
  //! Application code ///
  ////////////////////////
  return;
}

void main_loop(void)
{
  while (1) {
    //! Application task
    app_task();

    //! event loop
    rsi_wireless_driver_task();
  }
}
int main()
{
  int32_t status;
  /* Clear M4_Wake_Up_TA bit */

  P2P_STATUS_REG &= ~(BIT(0));

#ifndef GPIO_TOGGLE
  //Set pin 0 in GPIO mode
  RSI_EGPIO_SetPinMux(EGPIO1, 0, 5, EGPIO_PIN_MUX_MODE0);
  //Set output direction
  RSI_EGPIO_SetDir(EGPIO1, 0, 5, EGPIO_CONFIG_DIR_OUTPUT);

  RSI_EGPIO_SetPin(EGPIO1, 0, 5, 1);
  RSI_EGPIO_SetPin(EGPIO1, 0, 5, 0);
#endif
  //! Driver initialization
  status = rsi_driver_init(global_buf, GLOBAL_BUFF_LEN);
  if ((status < 0) || (status > GLOBAL_BUFF_LEN)) {
    return status;
  }
  //! Silabs module intialisation
  status = rsi_device_init(LOAD_NWP_FW);
  if (status != RSI_SUCCESS) {
    DEBUGOUT("\r\nDevice Initialization Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nDevice Initialization Success\r\n");
  }
  //! Call Uart application
  status = uart_app();

  DEBUGOUT("\r\nCCP-Power-save Deep_Sleep_Without_Retention Application Demo\r\n");
  //! CallPower save application
  status = rsi_powersave_profile_app();

  //! Application main loop
  main_loop();
  return status;
}

#ifdef SEC_BASED_WKP
/*Configure the RTC */
void RSI_RTC_Sec_based_wkp_init(void)
{
  /*Init the rtc block */
  RSI_RTC_Init(RTC);
  /*Start RTC */
  RSI_RTC_Start(RTC);
  /*Enables RTC NVIC */
  NVIC_EnableIRQ(NVIC_RTC);
  /* Select rtc sec as a wake up sources  */
  RSI_PS_SetWkpSources(SEC_BASED_WAKEUP);
  RSI_RTC_IntrUnMask(RTC_SEC_INTR);
}

/*Msec and Sec IRQ handler */
void IRQ029_Handler()
{
  /*Clears the wakeup status */
  RSI_RTC_IntrClear(RTC_SEC_INTR);
}
#endif

#ifdef DS_BASED_WKP
/* DST IRQ handler */
void DS_IRQ()
{
  /*Deep sleep timer interrupt */
  RSI_PS_ClrWkpUpStatus(NPSS_TO_MCU_DST_INTR);
}
void RSI_DS_Timer_Init(void)
{
  /*Deep sleep duration count us*/
  RSI_DST_DurationSet(DS_TIMER_DURATION);
  RSI_DST_IntrUnMask();
  /*Set wake source as the Alarm interrupt from NPSS */
  RSI_PS_SetWkpSources(DST_BASED_WAKEUP);
  NVIC_EnableIRQ(NVIC_DS_TIMER);
}
#endif
#ifdef UULP_GPIO_BASED_WKP

/* GPIO based wake up IRQ */
void IRQ021_Handler(void)
{
  /* clear NPSS GPIO interrupt*/
  RSI_NPSSGPIO_ClrIntr(NPSS_GPIO_2_INTR);
}

/*Configure the UULP GPIO 2 as wakeup source */
void RSI_Wakeupsw_config(void)
{

  /*Configure the NPSS GPIO mode to wake up  */
  RSI_NPSSGPIO_SetPinMux(NPSS_GPIO_2, NPSSGPIO_PIN_MUX_MODE2);

  /*Configure the NPSS GPIO direction to input */
  RSI_NPSSGPIO_SetDir(NPSS_GPIO_2, NPSS_GPIO_DIR_INPUT);

  /*Configure the NPSS GPIO interrupt polarity */
  RSI_NPSSGPIO_SetPolarity(NPSS_GPIO_2, NPSS_GPIO_INTR_LOW);

  /*Enable the REN*/
  RSI_NPSSGPIO_InputBufferEn(NPSS_GPIO_2, 1);

  /* Set the GPIO to wake from deep sleep */
  RSI_NPSSGPIO_SetWkpGpio(NPSS_GPIO_2_INTR);

  /* Un mask the NPSS GPIO interrupt*/
  RSI_NPSSGPIO_IntrUnMask(NPSS_GPIO_2_INTR);

  /*Select wake up sources */
  RSI_PS_SetWkpSources(GPIO_BASED_WAKEUP);

  /*Enable the NPSS GPIO interrupt slot*/
  NVIC_EnableIRQ(NPSS_TO_MCU_GPIO_INTR_IRQn);
}

#endif
#ifdef ALARM_CONFIG

/**
 * @fn           void RSI_Set_Alarm_Time(uint16_t interval)
 * @brief        This function will update the alarm time ,when to get next alarm interrupt . 
 * @param[in]    interval  : Alarm  timer interrupt time
 * @param[out]   None
 *
 */
void RSI_Set_Alarm_Intr_Time(uint16_t interval)
{
  /* Get the RTC time,which is used to update alarm time as per RTC time  */
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
  alarmConfig.Second       = rtc_get_Time.Second;
  /*Update seconds for next boundary alarm */
  alarmConfig.Second = alarmConfig.Second + (interval % 60);
  if (alarmConfig.Second >= (NO_OF_SECONDS_IN_A_MINUTE)) {
    alarmConfig.Second -= NO_OF_SECONDS_IN_A_MINUTE;
    alarmConfig.Minute += 1;
  }
  /*Update minutes for next boundary alarm */
  alarmConfig.Minute = alarmConfig.Minute + ((interval / 60) % 60);
  if (alarmConfig.Minute >= (NO_OF_MINUTES_IN_AN_HOUR)) {
    alarmConfig.Minute -= NO_OF_MINUTES_IN_AN_HOUR;
    alarmConfig.Hour += 1;
  }
  /*Update hour for next boundary alarm */
  alarmConfig.Hour = alarmConfig.Hour + (interval / 3600) % 24;
  if (alarmConfig.Hour >= (NO_OF_HOURS_IN_A_DAY)) {
    alarmConfig.Hour -= NO_OF_HOURS_IN_A_DAY;
    alarmConfig.Day += 1;
  }
  /*Update month for next boundary alarm */
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
  /*Update year  for next boundary alarm */
  if (alarmConfig.Month > (NO_OF_MONTHS_IN_A_YEAR)) {
    alarmConfig.Month = 1;
    alarmConfig.Year += 1;
  }

  /*Set Alarm configuration */
  RSI_RTC_SetAlarmDateTime(RTC, &alarmConfig);
}
/**
 * @fn           void InitM4AlarmConfig(void)
 * @brief        This function is to initialize Alarm block . 
 *
 */
void InitM4AlarmConfig(void)
{
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
  /*Set the RTC configuration*/
  RSI_RTC_SetDateTime(RTC, &rtcConfig);
  /*Enable Alarm feature*/
  RSI_RTC_AlamEnable(RTC, ENABLE);
  /*Enable RTC ALARM interrupts*/
  RSI_RTC_IntrUnMask(RTC_ALARM_INTR);
  /*Initialization of RTC CALIBRATION*/
  RSI_RTC_CalibInitilization();
  /*To calibrate rc and ro */
  RSI_RTC_ROCLK_Calib(TIME_PERIOD, ENABLE, ENABLE, RC_TRIGGER_TIME, ENABLE, ENABLE, RO_TRIGGER_TIME);
  /*Set Alarm as a  wake up source to wake up from deep sleep */
  RSI_PS_SetWkpSources(ALARM_BASED_WAKEUP);
  /*Enable the RTC alarm interrupts */
  RSI_RTC_IntrUnMask(RTC_ALARM_INTR);

  /*Enable NVIC for RTC */
  NVIC_EnableIRQ(NVIC_RTC_ALARM);
}

/*RTC Alarm interrupt*/
void RTC_ALARM_IRQHandler(void)
{
  volatile uint32_t statusRead = 0;
  static RTC_TIME_CONFIG_T alarmConfig, readTime;
  /*Get the interrupt status */
  statusRead = RSI_RTC_GetIntrStatus();
  if (statusRead & NPSS_TO_MCU_ALARM_INTR) {
    /*Clear wake up interrupt */
    RSI_RTC_IntrClear(RTC_ALARM_INTR);
  }
  return;
}
#endif
