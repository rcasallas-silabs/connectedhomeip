/*******************************************************************************
* @file  rsi_wake_on_wireless.c
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
 * Wake On Wireless test application demonstrates the� connected sleep power save
 * functionality of Silabs device having TCP server socket in open state.
 * M4 will be in retention mode sleep and wakes up whenever there is a packet from
 * NWP (Wireless Processor).
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

//! OS include file to refer OS specific functionality
#include "rsi_os.h"

//! Hardware and powersave related include files
#include "rsi_board.h"
#include "rsi_chip.h"
#include "rsi_ps_ram_func.h"
#include "rsi_wisemcu_hardware_setup.h"
#include "rsi_m4.h"
#include "rsi_driver.h"
#include "rsi_utils.h"

//! Access point SSID to connect
#define SSID "OSD_AP"

#define SCAN_CHANNEL 0

//! Security type
#define SECURITY_TYPE RSI_OPEN

//! Password
#define PSK ""

//! DHCP mode 1- Enable 0- Disable
#define DHCP_MODE 1

//! If DHCP mode is disabled given IP statically
#if !(DHCP_MODE)

//! IP address of the module
//! E.g: 0x650AA8C0 == 192.168.10.101
#define DEVICE_IP 0x650AA8C0

//! IP address of Gateway
//! E.g: 0x010AA8C0 == 192.168.10.1
#define GATEWAY 0x010AA8C0

//! IP address of netmask
//! E.g: 0x00FFFFFF == 255.255.255.0
#define NETMASK 0x00FFFFFF

#endif

//! Server IP address. Should be in reverse long format
//! E.g: 0x640AA8C0 == 192.168.10.100
#define SERVER_IP_ADDRESS 0x640AA8C0

//! Server port number
#define SERVER_PORT 5001

//! Device port number
#define DEVICE_PORT 5001

//! Power Save Profile Mode
#define PSP_TYPE RSI_MAX_PSP

//! Runs scheduler for some delay and do not send any command
#define RSI_DELAY 6000000

//! Memory length for driver
#define GLOBAL_BUFF_LEN 15000

//! Wlan task priority
#define RSI_WLAN_TASK_PRIORITY 1

//! Wireless driver task priority
#define RSI_DRIVER_TASK_PRIORITY 2

//! Wlan task stack size
#define RSI_WLAN_TASK_STACK_SIZE 500

//! Wireless driver task stack size
#define RSI_DRIVER_TASK_STACK_SIZE 500

//! Memory to initialize driver
uint8_t global_buf[GLOBAL_BUFF_LEN];

#ifdef COMMON_FLASH_EN
#define IVT_OFFSET_ADDR 0x8212000 /*<!Application IVT location VTOR offset>        */
#else
#define IVT_OFFSET_ADDR 0x8012000 /*<!Application IVT location VTOR offset>        */
#endif
#define WKP_RAM_USAGE_LOCATION 0x24061000 /*<!Bootloader RAM usage location upon wake up  */

#define WIRELESS_WAKEUP_IRQHandler NPSS_TO_MCU_WIRELESS_INTR_IRQn

void M4_sleep_wakeup()
{
  LOG_PRINT("\r\n Set Wakeup Source\r\n");
  /* Configure Wakeup-Source */
  RSI_PS_SetWkpSources(WIRELESS_BASED_WAKEUP);

  /* Enable NVIC */
  NVIC_EnableIRQ(WIRELESS_WAKEUP_IRQHandler);

#ifndef FLASH_BASED_EXECUTION_ENABLE
  /* LDOSOC Default Mode needs to be disabled */
  RSI_PS_LdoSocDefaultModeDisable();

  /* bypass_ldorf_ctrl needs to be enabled */
  RSI_PS_BypassLdoRfEnable();

  /* Disable FlashLDO */
  RSI_PS_FlashLdoDisable();

  /* Configure RAM Usage and Retention Size */
  LOG_PRINT("\r\n Retain required RAM size\r\n");
  RSI_WISEMCU_ConfigRamRetention(WISEMCU_128KB_RAM_IN_USE, WISEMCU_RETAIN_DEFAULT_RAM_DURING_SLEEP);

  /* Trigger M4 Sleep */
  LOG_PRINT("\r\n Trigger M4 to Sleep\r\n");
  RSI_WISEMCU_TriggerSleep(SLEEP_WITH_RETENTION,
                           DISABLE_LF_MODE,
                           0,
                           (uint32_t)RSI_PS_RestoreCpuContext,
                           0,
                           RSI_WAKEUP_WITH_RETENTION_WO_ULPSS_RAM);
#else
  /* Configure RAM Usage and Retention Size */
  LOG_PRINT("\r\n Retain required RAM size\r\n");
  RSI_WISEMCU_ConfigRamRetention(WISEMCU_192KB_RAM_IN_USE, WISEMCU_RETAIN_DEFAULT_RAM_DURING_SLEEP);

  /* Trigger M4 Sleep*/
  LOG_PRINT("\r\n Trigger M4 to Sleep\r\n");
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
}

void data_recv(uint32_t sock_no, uint8_t *buffer, uint32_t length)
{
  int i;

  LOG_PRINT("\r\n RX Packet Received\r\n ");
  LOG_PRINT("\r\n RX: LEN %d\r\n ", length);
  LOG_PRINT("\r\n Data:\r\n ");

  for (i = 0; i < length; i++) {
    LOG_PRINT("%c", buffer[i]);
  }
}
void HardFault_Handler()
{
  while (1) {
    LOG_PRINT("\r\nHardFault_Handler\r\n");
  }
}

int32_t rsi_powersave_profile_app()
{
  struct rsi_sockaddr_in server_addr;
  struct rsi_sockaddr_in client_addr;
  int32_t status = RSI_SUCCESS;
  int32_t addr_size;
  uint8_t xtal_enable = 0;
#if !(DHCP_MODE)
  uint32_t ip_addr      = DEVICE_IP;
  uint32_t network_mask = NETMASK;
  uint32_t gateway      = GATEWAY;
#else
  uint8_t dhcp_mode = (RSI_DHCP | RSI_DHCP_UNICAST_OFFER);
#endif
  int32_t server_socket, new_socket;
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
  //! First byte of input_data reserved/used for enable(1) or Disable(0) for the sub_cmd. Remaining bype would be used for input data .
  xtal_enable = 1;
  status      = rsi_cmd_m4_ta_secure_handshake(RSI_ENABLE_XTAL, 1, &xtal_enable, 0, NULL);
  if (status != RSI_SUCCESS) {
    return status;
  }
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
  status = rsi_config_ipaddress(RSI_IP_VERSION_4, dhcp_mode, 0, 0, 0, ip_rsp, 18, 0);
#else
  status            = rsi_config_ipaddress(RSI_IP_VERSION_4,
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
    LOG_PRINT("\r\nSILABS_STA IP ADDR: %d.%d.%d.%d \r\n", ip_rsp[6], ip_rsp[7], ip_rsp[8], ip_rsp[9]);
  }

  //! Create socket
  server_socket = rsi_socket_async(AF_INET, SOCK_STREAM, 0, data_recv);
  if (server_socket < 0) {
    status = rsi_wlan_get_status();
    LOG_PRINT("\r\nSocket Create Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nSocket Create Success\r\n");
  }

  //! Set server structure
  memset(&server_addr, 0, sizeof(server_addr));

  //! Set family type
  server_addr.sin_family = AF_INET;

  //! Set local port number
  server_addr.sin_port = htons(DEVICE_PORT);

  //! Bind socket
  status = rsi_bind(server_socket, (struct rsi_sockaddr *)&server_addr, sizeof(server_addr));
  if (status != RSI_SUCCESS) {
    status = rsi_wlan_get_status();
    rsi_shutdown(server_socket, 0);
    LOG_PRINT("\r\nBind Failed, Error code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nBind Success\r\n");
  }

  //! Socket listen
  status = rsi_listen(server_socket, 1);
  if (status != RSI_SUCCESS) {
    status = rsi_wlan_get_status();
    rsi_shutdown(server_socket, 0);
    LOG_PRINT("\r\nListen Failed, Error code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nListen Success\r\n");
  }

  addr_size = sizeof(server_socket);

  //! Socket accept
  new_socket = rsi_accept(server_socket, (struct rsi_sockaddr *)&client_addr, &addr_size);
  if (new_socket < 0) {
    status = rsi_wlan_get_status();
    rsi_shutdown(server_socket, 0);
    LOG_PRINT("\r\nSocket Accept Failed, Error code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nSocket Accept Success\r\n");
  }
  LOG_PRINT("\r\n Start Powersave Command\r\n");
  //! Apply power save profile with deep sleep
  status = rsi_wlan_power_save_profile(RSI_SLEEP_MODE_2, PSP_TYPE);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\n Powersave Command Failed ,Error code :0x%x \r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\n Powersave Command Success\r\n");
  }

  //! Keep M4 sleep Here,Wake On wirless Here
  LOG_PRINT("\r\n Keep M4 in Sleep\r\n");
  M4_sleep_wakeup();
  //! Wakeup
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
      LOG_PRINT("\n main loop sleep \n");
      M4_sleep_wakeup();
    }
  }
}
int main()
{
  int32_t status, cntr;

#ifdef RSI_WITH_OS

  rsi_task_handle_t wlan_task_handle = NULL;

  rsi_task_handle_t driver_task_handle = NULL;
#endif

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

#ifdef RSI_WITH_OS
  //! OS case
  //! Task created for WLAN task
  rsi_task_create(rsi_powersave_profile_app,
                  "wlan_task",
                  RSI_WLAN_TASK_STACK_SIZE,
                  NULL,
                  RSI_WLAN_TASK_PRIORITY,
                  &wlan_task_handle);

  //! Task created for Driver task
  rsi_task_create(rsi_wireless_driver_task,
                  "driver_task",
                  RSI_DRIVER_TASK_STACK_SIZE,
                  NULL,
                  RSI_DRIVER_TASK_PRIORITY,
                  &driver_task_handle);

  //! OS TAsk Start the scheduler
  rsi_start_os_scheduler();
#else
  //! NON - OS case
  //! CallPower save application
  LOG_PRINT("\r\nCCP Powersave Wake_On_Wireless Application Demo\r\n");
  status = rsi_powersave_profile_app();

  //! Application main loop
  main_loop();
#endif
  return status;
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
