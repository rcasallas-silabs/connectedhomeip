/*******************************************************************************
 * @file  rsi_m4_powersave_app.c
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

#ifdef RSI_M4_INTERFACE
/**
 * Include files
 **/
#include "rsi_chip.h"
#include "rsi_wisemcu_hardware_setup.h"
#include "rsi_m4.h"
#include "rsi_board.h"
#include "rsi_app_config.h"

/* Private typedef -----------------------------------------------------------*/
rsi_semaphore_handle_t m4_powersave_sem;
extern rsi_semaphore_handle_t rsi_shadow_sem;
extern rsi_wlan_app_context_t rsi_wlan_app_context;
/* Private variables ---------------------------------------------------------*/
static RTC_TIME_CONFIG_T rtcConfig, alarmConfig, rtc_get_Time;
volatile uint32_t msp_value, psp_value, control_reg_val, pendsv_pri, systic_pri;

/* Private functions ---------------------------------------------------------*/
/**
 * @fn           void RSI_Save_Context(void)
 * @brief        This function is to save Stack pointer value and Control registers.
 *
 */
void RSI_Save_Context(void)
{
  msp_value       = __get_MSP();
  psp_value       = __get_PSP();
  control_reg_val = __get_CONTROL();
}
/**
 * @fn           void RSI_Restore_Context(void)
 * @brief        This function is to Restore Stack pointer value and Control registers.
 *
 */
STATIC INLINE void RSI_Restore_Context(void)
{
  __set_CONTROL(control_reg_val);
  __set_PSP(psp_value);
  __set_MSP(msp_value);
  /* Make PendSV and SysTick the lowest priority interrupts. */
  portNVIC_SHPR3_REG |= portNVIC_PENDSV_PRI;
  portNVIC_SHPR3_REG |= portNVIC_SYSTICK_PRI;
}

void m4_powersave_app(void)
{
  /* Configure the Alarm time*/
  InitM4AlarmConfig();
#ifdef RSI_WITH_OS
  rsi_semaphore_create(&m4_powersave_sem, 0);
  while (1) {
    rsi_semaphore_wait(&m4_powersave_sem, 0);
#endif
    /* Update the alarm time intervel, when to get next interrupt  */
    RSI_Set_Alarm_Intr_Time(ALARM_PERIODIC_TIME);
#ifdef RSI_WITH_OS
    /* Save Stack pointer value and Control registers */
    RSI_Save_Context();
#endif
    /* Configure RAM Usage and Retention Size */
    RSI_WISEMCU_ConfigRamRetention(WISEMCU_192KB_RAM_IN_USE, WISEMCU_RETAIN_DEFAULT_RAM_DURING_SLEEP);

    DEBUGOUT("\r\n M4 Sleep \r\n");
    /* Trigger M4 Sleep*/
    RSI_WISEMCU_TriggerSleep(SLEEP_WITH_RETENTION,
                             DISABLE_LF_MODE,
                             WKP_RAM_USAGE_LOCATION,
                             (uint32_t)RSI_PS_RestoreCpuContext,
                             IVT_OFFSET_ADDR,
                             RSI_WAKEUP_FROM_FLASH_MODE);
#ifdef RSI_WITH_OS
    /* Restore Stack pointer value and Control registers */
    RSI_Restore_Context();
    /* Enable M4_TA interrupt */
    rsi_m4_ta_interrupt_init();
    /*  Setup the systick timer */
    rsi_setup_timer_os_interrupt();
#endif
    /*Start of M4 init after wake up  */
#ifdef DEBUG_UART
    fpuInit();
    /*Initialize UART after wake up*/
    DEBUGINIT();
#endif
    DEBUGOUT("\r\n M4 Wake up\r\n");
    /*Resume wlan app state */
    rsi_wlan_app_context.state = RSI_WLAN_SHADOW_YIELD_STATE;
#ifdef RSI_WITH_OS
    rsi_semaphore_post(&rsi_shadow_sem);
  }
#endif
}

/**
 * @fn           void RSI_Set_Alarm_Time(uint16_t interval)
 * @brief        This function will update the alarm time ,when to get next alarm interrupt .
 * @param[in]    interval  : Alarm timer interrupt time
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
  /*Get the interrupt status */
  statusRead = RSI_RTC_GetIntrStatus();

  if (statusRead & NPSS_TO_MCU_ALARM_INTR) {
    /* TRIGGER SLEEP STATE */
    /*Clear wake up interrupt */
    RSI_RTC_IntrClear(RTC_ALARM_INTR);
  }
  return;
}

void IRQ026_Handler()
{
  volatile uint32_t wakeUpSrc = 0;

  /*Get the wake up source */
  wakeUpSrc = RSI_PS_GetWkpUpStatus();

  /*Clear interrupt */
  RSI_PS_ClrWkpUpStatus(NPSS_TO_MCU_WIRELESS_INTR);

  return;
}
#endif
