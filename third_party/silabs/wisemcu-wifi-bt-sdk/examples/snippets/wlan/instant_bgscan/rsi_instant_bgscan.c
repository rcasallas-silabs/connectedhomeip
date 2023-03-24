/*******************************************************************************
* @file  rsi_instant_bgscan.c
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

/**
 * Include files
 * */

//! include file to refer data types
#include "rsi_data_types.h"

//! COMMON include file to refer wlan APIs
#include "rsi_common_apis.h"

//! WLAN include file to refer wlan APIs
#include "rsi_wlan_apis.h"
#include "rsi_wlan_non_rom.h"

//! socket include file to refer socket APIs
#include "rsi_socket.h"

#include "rsi_bootup_config.h"
//! Error include files
#include "rsi_error.h"

//! OS include file to refer OS specific functionality
#include "rsi_os.h"
#ifdef RSI_M4_INTERFACE
#include "rsi_board.h"
#endif
#include "rsi_wlan_config.h"
#include <string.h>
#include "rsi_utils.h"
//! Access point SSID to connect
#define SSID "SILABS_AP"

//!Scan Channel number , 0 - to scan all channels
#define CHANNEL_NO 0

//! Security type
#define SECURITY_TYPE RSI_WPA2

//! Password
#define PSK "12345678"

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

//! Memory length for driver
#define GLOBAL_BUFF_LEN 15000

#define APP_BUFF_LEN 500
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

uint8_t bgscan_results[APP_BUFF_LEN];

//RSI_STA IP ADDR
uint8_t ip_buff[20];
uint8_t scan_ix;
rsi_rsp_scan_t *bgscan_results2;

extern uint64_t ip_to_reverse_hex(char *ip);
int32_t rsi_instant_bgscan()
{
  int32_t status = RSI_SUCCESS;
#if !(DHCP_MODE)
  uint32_t ip_addr      = ip_to_reverse_hex((char *)DEVICE_IP);
  uint32_t network_mask = ip_to_reverse_hex((char *)NETMASK);
  uint32_t gateway      = ip_to_reverse_hex((char *)GATEWAY);
#else
  uint8_t dhcp_mode = (RSI_DHCP | RSI_DHCP_UNICAST_OFFER);
#endif

#ifdef RSI_WITH_OS
  //! Silabs module intialisation
  status = rsi_device_init(LOAD_NWP_FW);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nDevice Initialization Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nDevice Initialization Success\r\n");
  }
#endif
  //! WC initialization
  status = rsi_wireless_init(0, 0);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nWireless Initialization Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nWireless Initialization Success\r\n");
  }

#ifdef RSI_WITH_OS
  while (1) {
#endif
    //! Scan for Access points
    status = rsi_wlan_scan((int8_t *)SSID, (uint8_t)CHANNEL_NO, NULL, 0);
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\nWLAN Scan Failed, Error Code : 0x%X\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nWLAN Scan Success\r\n");
    }

    //! Connect to an Access point
    status = rsi_wlan_connect((int8_t *)SSID, SECURITY_TYPE, PSK);
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\nWLAN Connect Failed, Error Code : 0x%X\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nWLAN Connect Success\r\n");
    }

    //! Configure IP
#if DHCP_MODE
    status = rsi_config_ipaddress(RSI_IP_VERSION_4, dhcp_mode, 0, 0, 0, ip_buff, sizeof(ip_buff), 0);
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
      LOG_PRINT("\r\nIP Config Success\r\n");
    }
#if DHCP_MODE
    LOG_PRINT("RSI_STA IP ADDR: %d.%d.%d.%d \r\n", ip_buff[6], ip_buff[7], ip_buff[8], ip_buff[9]);
#endif

    status = rsi_wlan_bgscan_profile(RSI_INSTANT_BGSCAN, (rsi_rsp_scan_t *)bgscan_results, APP_BUFF_LEN);
    if (status != RSI_SUCCESS) {
      return status;
    }
    LOG_PRINT("\r\nrsi_wlan_bgscan_profile Success\r\n");
    bgscan_results2 = bgscan_results;
    LOG_PRINT("\r\nTotal AP %d\r\n", bgscan_results2->scan_count[0]);
    for (scan_ix = 0; scan_ix < bgscan_results2->scan_count[0]; scan_ix++) {
      LOG_PRINT("Security mode- %d, ", bgscan_results2->scan_info[scan_ix].security_mode);
      LOG_PRINT("SSID %s\r\n", bgscan_results2->scan_info[scan_ix].ssid);
    }

#ifndef RSI_WITH_OS
    rsi_wireless_driver_task();
#endif
#ifdef RSI_WITH_OS
    rsi_task_suspend(NULL);
  }
#else
  return 0;
#endif
}

void main_loop(void)
{
  while (1) {
    ////////////////////////
    //! Application code ///
    ////////////////////////

    //! event loop
    rsi_wireless_driver_task();
  }
}

int main()
{
  int32_t status;
#ifdef RSI_WITH_OS

  rsi_task_handle_t wlan_task_handle = NULL;

  rsi_task_handle_t driver_task_handle = NULL;
#endif

  //! Driver initialization
  status = rsi_driver_init(global_buf, GLOBAL_BUFF_LEN);
  if ((status < 0) || (status > GLOBAL_BUFF_LEN)) {
    return status;
  }

#ifndef RSI_WITH_OS
  //! Silabs module intialisation
  status = rsi_device_init(LOAD_NWP_FW);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nDevice Initialisation Failed, Error Code : 0x%X\r\n", status);
    return status;
  }
  LOG_PRINT("\r\nDevice Initialisation Success\r\n");
#endif

#ifdef RSI_WITH_OS
  //! OS case
  //! Task created for WLAN task
  rsi_task_create((rsi_task_function_t)rsi_instant_bgscan,
                  (uint8_t *)"wlan_task",
                  RSI_WLAN_TASK_STACK_SIZE,
                  NULL,
                  RSI_WLAN_TASK_PRIORITY,
                  &wlan_task_handle);

  //! Task created for Driver task
  rsi_task_create((rsi_task_function_t)rsi_wireless_driver_task,
                  (uint8_t *)"driver_task",
                  RSI_DRIVER_TASK_STACK_SIZE,
                  NULL,
                  RSI_DRIVER_TASK_PRIORITY,
                  &driver_task_handle);

  //! OS TAsk Start the scheduler
  rsi_start_os_scheduler();

#else
  //! NON - OS case
  //! Call instant bg scan application
  status = rsi_instant_bgscan();

  //! Application main loop
  main_loop();
#endif
  return status;
}
