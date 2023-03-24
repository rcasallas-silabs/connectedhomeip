/*******************************************************************************
 * @file  rsi_app_config.h
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

#ifndef RSI_APP_CONFIG_H_
#define RSI_APP_CONFIG_H_

/* Private macro -------------------------------------------------------------*/
#define ALARM_PERIODIC_TIME 5    /*<! periodic alarm configuration in SEC */
#define RSI_APP_BUF_SIZE    1600 /*Application BUFF Size*/

/*Update time configurations for next boundary alarm*/
#define RC_TRIGGER_TIME           5
#define RO_TRIGGER_TIME           0
#define NO_OF_HOURS_IN_A_DAY      24
#define NO_OF_MINUTES_IN_AN_HOUR  60
#define NO_OF_SECONDS_IN_A_MINUTE 60
#define NO_OF_MONTHS_IN_A_YEAR    12
#define BASE_YEAR                 2000
#define NO_OF_DAYS_IN_A_MONTH_1   28
#define NO_OF_DAYS_IN_A_MONTH_2   29
#define NO_OF_DAYS_IN_A_MONTH_3   30
#define NO_OF_DAYS_IN_A_MONTH_4   31

#ifdef COMMON_FLASH_EN
#define IVT_OFFSET_ADDR 0x8212000 /*<!Application IVT location VTOR offset>        */
#else
#define IVT_OFFSET_ADDR 0x8012000 /*<!Application IVT location VTOR offset>        */
#endif
#define WKP_RAM_USAGE_LOCATION 0x24061000 /*<!Bootloader RAM usage location upon wake up  */
/* Constants required to manipulate the NVIC. */
#define portNVIC_SHPR3_REG   (*((volatile uint32_t *)0xe000ed20))
#define portNVIC_PENDSV_PRI  (((uint32_t)(0x3f << 4)) << 16UL)
#define portNVIC_SYSTICK_PRI (((uint32_t)(0x3f << 4)) << 24UL)

/* Private define ------------------------------------------------------------*/
#define RTC_ALARM_IRQHandler       IRQ028_Handler
#define NVIC_RTC_ALARM             MCU_CAL_ALARM_IRQn
#define WIRELESS_WAKEUP_IRQHandler NPSS_TO_MCU_WIRELESS_INTR_IRQn
/* Private  function prototypes -----------------------------------------------*/
void InitM4AlarmConfig(void);
void RSI_Set_Alarm_Intr_Time(uint16_t interval);
void m4_powersave_app(void);

// Enumeration for states in application
typedef enum rsi_wlan_app_state_e {
  RSI_WLAN_INITIAL_STATE                   = 0,
  RSI_WLAN_SCAN_STATE                      = 1,
  RSI_WLAN_UNCONNECTED_STATE               = 2,
  RSI_WLAN_CONNECTED_STATE                 = 3,
  RSI_WLAN_IPCONFIG_DONE_STATE             = 4,
  RSI_WLAN_SHADOW_INIT_STATE               = 5,
  RSI_WLAN_SHADOW_CONNECT_STATE            = 6,
  RSI_WLAN_SHADOW_AUTO_RECONNECT_SET_STATE = 7,
  RSI_WLAN_SHADOW_REGISTER_DELTA           = 8,
  RSI_WLAN_SHADOW_YIELD_STATE              = 9,
  RSI_WLAN_SHADOW_IDLE_STATE               = 10,
  RSI_SLEEP_STATE                          = 11
} rsi_wlan_app_state_t;

// WLAN application context
typedef struct rsi_wlan_app_context_s {

  // WLAN application state
  rsi_wlan_app_state_t state;

  // Length of buffer to copy
  uint32_t length;

  // application buffer
  uint8_t buffer[RSI_APP_BUF_SIZE];

  // Used to check application buffer availability
  uint8_t buf_in_use;

  // Application events bit map
  uint32_t event_map;

} rsi_wlan_app_context_t;

#endif /* RSI_APP_CONFIG_H_ */
