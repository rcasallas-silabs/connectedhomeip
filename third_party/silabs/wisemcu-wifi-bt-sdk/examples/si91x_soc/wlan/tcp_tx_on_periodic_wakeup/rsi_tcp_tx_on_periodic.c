/*******************************************************************************
* @file  rsi_tcp_tx_on_periodic.c
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
 * TCP Tx on periodic wakeup test application demonstrates power consumption of
 * Silabs device in connected sleep mode having TCP server socket in open state.
 * M4 wakes up with alarm configured time and sends packet to NWP, NWP wakes up with
 * packet f	rom M4 then process packet after that both will go to sleep.�
	=================================================================================*/

/**
 * Include files
 * */
#include "rsi_driver.h"

//! Hardware and powersave related include files
#include "rsi_board.h"
#include "rsi_chip.h"
#include "rsi_ps_ram_func.h"
#include "rsi_wisemcu_hardware_setup.h"
#include "rsi_m4.h"

//! Access point SSID to connect
#define SSID "SILABS_AP"

#define SCAN_CHANNEL 0

//! Security type
#define SECURITY_TYPE RSI_WPA2

//! Password
#define PSK ""

//! DHCP mode 1- Enable 0- Disable
#define DHCP_MODE 1

//! If DHCP mode is disabled given IP statically
#if !(DHCP_MODE)
//! IP address of the module
//! E.g: 0x650AA8C0 == 192.168.10.101
#define DEVICE_IP "192.168.10.101"

//! IP address of Gateway
//! E.g: 0x010AA8C0 == 192.168.10.1
#define GATEWAY "192.168.10.1"

//! IP address of netmask
//! E.g: 0x00FFFFFF == 255.255.255.0
#define NETMASK "255.255.255.0"

#endif
//! Server IP address. Should be in reverse long format
//! E.g: 0x640AA8C0 == 192.168.10.100
//! E.g: 0x640AA8C0 == 192.168.0.63
#define SERVER_IP_ADDRESS "192.168.10.100"

//! Server port number
#define SERVER_PORT 5001

//! Device port number
#define DEVICE_PORT 5001

//! Power Save Profile Mode
#define PSP_TYPE RSI_MAX_PSP

//! Number of packet to send or receive
#define NUMBER_OF_PACKETS 45964 // 64MB

//! Memory length for driver
#define GLOBAL_BUFF_LEN 15000

//! Memory to initialize driver
uint8_t global_buf[GLOBAL_BUFF_LEN];

#define BUF_SIZE 1460
uint8_t send_buf[BUF_SIZE] = { 0xFF };

#ifdef ALARM_CONFIG
void InitM4AlarmConfig(void);
void RSI_Set_Alarm_Intr_Time(uint16_t interval);
static RTC_TIME_CONFIG_T rtcConfig, readTime, alarmConfig, readAlarmConfig, rtc_get_Time;

#define RTC_ALARM_IRQHandler IRQ028_Handler
#define NVIC_RTC_ALARM       MCU_CAL_ALARM_IRQn
#define RC_TRIGGER_TIME      5
#define RO_TRIGGER_TIME      0

#define ALARM_PERIODIC_TIME       300 /*<! periodic alarm configuration in SEC */
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
#define WKP_RAM_USAGE_LOCATION     0x24061000 /*<!Bootloader RAM usage location upon wake up  */
#define WIRELESS_WAKEUP_IRQHandler NPSS_TO_MCU_WIRELESS_INTR_IRQn

extern uint64_t ip_to_reverse_hex(char *ip);

/**
 * @fn           void InitM4AlarmConfig(void)
 * @brief        This function is to  Trigger m4 sleep  . 
 *
 */
void M4_sleep_wakeup()
{
  /* Configure Wakeup-Source */
  RSI_PS_SetWkpSources(WIRELESS_BASED_WAKEUP);

  /* Enable NVIC */
  NVIC_EnableIRQ(WIRELESS_WAKEUP_IRQHandler);

#ifdef ALARM_CONFIG
  RSI_RTC_GetDateTime(RTC, &readTime);
  LOG_PRINT("\r\nRTC time before M4  sleep\r\n");
  LOG_PRINT("\r\nTIME: %d:%d:%d:%d\r\n", readTime.Hour, readTime.Minute, readTime.Second, readTime.MilliSeconds);
  LOG_PRINT("\r\nDATE: %d/%d/%d\r\n", readTime.Day, readTime.Month, (readTime.Year + BASE_YEAR));
#endif
#ifndef FLASH_BASED_EXECUTION_ENABLE

  /* LDOSOC Default Mode needs to be disabled */
  RSI_PS_LdoSocDefaultModeDisable();

  /* bypass_ldorf_ctrl needs to be enabled */
  RSI_PS_BypassLdoRfEnable();

  /* Disable FlashLDO */
  RSI_PS_FlashLdoDisable();

  /* Configure RAM Usage and Retention Size */
  RSI_WISEMCU_ConfigRamRetention(WISEMCU_128KB_RAM_IN_USE, WISEMCU_RETAIN_DEFAULT_RAM_DURING_SLEEP);

  /* Trigger M4 Sleep */
  RSI_WISEMCU_TriggerSleep(SLEEP_WITH_RETENTION,
                           DISABLE_LF_MODE,
                           0,
                           (uint32_t)RSI_PS_RestoreCpuContext,
                           0,
                           RSI_WAKEUP_WITH_RETENTION_WO_ULPSS_RAM);

#else
  /* Configure RAM Usage and Retention Size */
  RSI_WISEMCU_ConfigRamRetention(WISEMCU_128KB_RAM_IN_USE, WISEMCU_RETAIN_DEFAULT_RAM_DURING_SLEEP);

  /* Trigger M4 Sleep */
  RSI_WISEMCU_TriggerSleep(SLEEP_WITH_RETENTION,
                           DISABLE_LF_MODE,
                           WKP_RAM_USAGE_LOCATION,
                           (uint32_t)RSI_PS_RestoreCpuContext,
                           IVT_OFFSET_ADDR,
                           RSI_WAKEUP_FROM_FLASH_MODE);

#endif
#ifdef DEBUG_UART
  fpuInit();
  DEBUGINIT();
#endif
#ifdef ALARM_CONFIG
  RSI_RTC_GetDateTime(RTC, &readTime);
  LOG_PRINT("\r\nRTC time after M4  wakeup\r\n");
  LOG_PRINT("\r\nTIME: %d:%d:%d:%d\r\n", readTime.Hour, readTime.Minute, readTime.Second, readTime.MilliSeconds);
  LOG_PRINT("\r\nDATE: %d/%d/%d\r\n", readTime.Day, readTime.Month, (readTime.Year + BASE_YEAR));
#endif
}

int32_t rsi_powersave_profile_app()
{
  int32_t client_socket;
  struct rsi_sockaddr_in server_addr, client_addr;
  volatile int32_t status        = RSI_SUCCESS;
  volatile uint32_t packet_count = 0;
#ifdef ALARM_CONFIG
  uint8_t xtal_enable = 0;
#endif
#if !(DHCP_MODE)
  uint32_t ip_addr      = ip_to_reverse_hex((char *)DEVICE_IP);
  uint32_t network_mask = ip_to_reverse_hex((char *)NETMASK);
  uint32_t gateway      = ip_to_reverse_hex((char *)GATEWAY);
#endif

  uint8_t ip_rsp[18] = { 0 };
  /* MCU Hardware Configuration for Low-Power Applications */
  RSI_WISEMCU_HardwareSetup();

  //! WC initialization
  status = rsi_wireless_init(0, 0);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nWireless Initialization Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nWireless Initialization Success\r\n");
  }
#ifdef ALARM_CONFIG
  //! First byte of input_data reserved/used for enable(1) or Disable(0) for the sub_cmd. Remaining bype would be used for input data .
  xtal_enable = 1;
  status      = rsi_cmd_m4_ta_secure_handshake(RSI_ENABLE_XTAL, 1, &xtal_enable, 0, NULL);
  if (status != RSI_SUCCESS) {
    return status;
  }
#endif
  //! Send feature frame
  status = rsi_send_feature_frame();
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nSend Feature Frame Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nSend Feature Frame Success\r\n");
  }

  //! Scan for the Access Point
  do {
    status = rsi_wlan_scan((int8_t *)SSID, (uint8_t)SCAN_CHANNEL, NULL, 0);
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\nWLAN AP Scan Failed, Error Code : 0x%X\r\n", status);
    } else {
      LOG_PRINT("\r\nWLAN AP Scan Success\r\n");
    }
  } while (status != 0);

  //! Connect to an Acces point
  status = rsi_wlan_connect((int8_t *)SSID, SECURITY_TYPE, PSK);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nWLAN AP Connect Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nWLAN AP Connect Success\r\n");
  }
  //! Configure IP
#if DHCP_MODE
  status = rsi_config_ipaddress(RSI_IP_VERSION_4, RSI_DHCP, 0, 0, 0, ip_rsp, sizeof(ip_rsp), 0);
#else
  status = rsi_config_ipaddress(RSI_IP_VERSION_4,
                                RSI_STATIC,
                                (uint8_t *)&ip_addr,
                                (uint8_t *)&network_mask,
                                (uint8_t *)&gateway,
                                NULL,
                                0,
                                0);
#endif
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nIP Config Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nIP Config Success\r\n");
#if DHCP_MODE
    LOG_PRINT("\r\nIP address: %d.%d.%d.%d \r\n", ip_rsp[6], ip_rsp[7], ip_rsp[8], ip_rsp[9]);
#endif
  }

  //! Create socket
  client_socket = rsi_socket(AF_INET, SOCK_STREAM, 0);
  if (client_socket < 0) {
    status = rsi_wlan_get_status();
    return status;
  } else {
    LOG_PRINT("\r\nSocket Create Success\r\n");
  }
  //! Memset client structure
  memset(&client_addr, 0, sizeof(client_addr));

  //! Set family type
  client_addr.sin_family = AF_INET;

  //! Set local port number
  client_addr.sin_port = htons(DEVICE_PORT);

  //! Bind socket
  status = rsi_bind(client_socket, (struct rsi_sockaddr *)&client_addr, sizeof(client_addr));
  if (status != RSI_SUCCESS) {
    status = rsi_wlan_get_status();
    rsi_shutdown(client_socket, 0);
    LOG_PRINT("\r\nSocket Create Success\r\n");
    return status;
  } else {
    LOG_PRINT("\r\nBind Success\r\n");
  }
  //! Set server structure
  memset(&server_addr, 0, sizeof(server_addr));

  //! Set server address family
  server_addr.sin_family = AF_INET;

  //! Set server port number, using htons function to use proper byte order
  server_addr.sin_port = htons(SERVER_PORT);

  //! Set IP address to localhost
  server_addr.sin_addr.s_addr = ip_to_reverse_hex((char *)SERVER_IP_ADDRESS);

  //! Connect to server socket
  status = rsi_connect(client_socket, (struct rsi_sockaddr *)&server_addr, sizeof(server_addr));
  if (status != RSI_SUCCESS) {
    status = rsi_wlan_get_status();
    rsi_shutdown(client_socket, 0);
    LOG_PRINT("\r\n Failed to Connect  server socket \t error 0x%x \r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\n Connection to Server Socket is Success \r\n");
  }

  //! Filter Broad cast enable
  status = rsi_wlan_filter_broadcast(3000, 1, 1);
  if (status != RSI_SUCCESS) {
    status = rsi_wlan_get_status();
    rsi_shutdown(client_socket, 0);
    return status;
  }

#ifdef ALARM_CONFIG
  InitM4AlarmConfig();
#endif

  while (1) {
    LOG_PRINT("\r\n Start Powersave Command\r\n");
    status = rsi_wlan_power_save_profile(0, 0);
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\n Powersave Command Failed ,Error code :0x%x \r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\n Powersave Command Success\r\n");
    }

    LOG_PRINT("\r\n Start sending data on TCP socket\r\n");
    while (packet_count < NUMBER_OF_PACKETS) {
      //! Send data on socket
      status = rsi_send(client_socket, (const int8_t *)send_buf, sizeof(send_buf), 0);
      if (status < 0) {
        status = rsi_wlan_get_status();
        rsi_shutdown(client_socket, 0);
        LOG_PRINT("\n Sending Data on Socket is Failed,Error code : 0x%x \r\n", status);
        return status;
      }

      packet_count++;
    }
    //! Apply power save profile with connected standby
    LOG_PRINT("\r\n Start Powersave Command\r\n");
    status = rsi_wlan_power_save_profile(RSI_SLEEP_MODE_2, PSP_TYPE);
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\n Powersave Command Failed ,Error code :0x%x \r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\n Powersave Command Success\r\n");
    }
    if (packet_count == NUMBER_OF_PACKETS) {
      LOG_PRINT("\r\n Sending Data on Socket is Completed \r\n");
      packet_count = 0;
      rsi_delay_ms(1000);
    }
#ifdef ALARM_CONFIG
    RSI_Set_Alarm_Intr_Time(ALARM_PERIODIC_TIME);
#endif

    LOG_PRINT("\r\n Keep M4 in Sleep\r\n");
    M4_sleep_wakeup();
  }
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
    if (!(P2P_STATUS_REG & TA_wakeup_M4)) {
      M4_sleep_wakeup();
    }
  }
}

int main()
{
  int32_t status;

  //! Driver initialization
  status = rsi_driver_init(global_buf, GLOBAL_BUFF_LEN);
  if ((status < 0) || (status > GLOBAL_BUFF_LEN)) {
    return status;
  }

  //! Silabs module intialisation
  status = rsi_device_init(LOAD_NWP_FW);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nDevice Initialization Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nDevice Initialization Success\r\n");
  }

  //! CallPower save application
  LOG_PRINT("\r\nCCP-Powersave TCP_TX_On_Periodic_Wakeup Application Demo\r\n");
  status = rsi_powersave_profile_app();

  return status;
}

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
void IRQ026_Handler()
{
  volatile uint32_t wakeUpSrc = 0;

  /*Get the wake up source */
  wakeUpSrc = RSI_PS_GetWkpUpStatus();
  /*Clear interrupt */
  RSI_PS_ClrWkpUpStatus(NPSS_TO_MCU_WIRELESS_INTR);

  return;
}
