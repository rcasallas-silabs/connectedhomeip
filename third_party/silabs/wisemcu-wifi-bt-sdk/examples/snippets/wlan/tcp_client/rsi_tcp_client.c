/*******************************************************************************
* @file  rsi_tcp_client.c
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
 * @brief : This file contains example application for TCP Client
 * @section Description :
 * The TCP client application demonstrates how to open and use a standard TCP
 * client socket and send data to TCP server socket.
 =================================================================================*/

/**
 * Include files
 * */

//! include file to refer data types
#include "rsi_data_types.h"

//! COMMON include file to refer WLAN APIs
#include "rsi_common_apis.h"

//! WLAN include file to refer WLAN APIs
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

// WLAN include file for configuration
#include "rsi_wlan_config.h"

#include <string.h>
#include "rsi_utils.h"

#ifdef FW_LOGGING_ENABLE
//! Firmware logging includes
#include "sl_fw_logging.h"
#endif

//! Access point SSID to connect
#define SSID "SILABS_AP"

//!Scan Channel number , 0 - to scan all channels
#define CHANNEL_NO 0

//! Security type
#define SECURITY_TYPE RSI_OPEN

//! Password
#define PSK NULL

//! DHCP mode 1- Enable 0- Disable
#define DHCP_MODE 1

//!TCP Max retries
#define RSI_MAX_TCP_RETRIES 10

//! If DHCP mode is disabled given IP statically
#if !(DHCP_MODE)

//! IP address of the module
#define DEVICE_IP "192.168.10.101"

//! IP address of Gateway
#define GATEWAY "192.168.10.1"

//! IP address of netmask
#define NETMASK "255.255.255.0"

#endif

//! Device port number
#define DEVICE_PORT 5001

//! Server port number
#define SERVER_PORT 5001

//! Server IP address. Should be in reverse long format
#define SERVER_IP_ADDRESS "192.168.10.100"

//! Number of packet to send or receive
#define NUMBER_OF_PACKETS 1000

#ifdef FW_LOGGING_ENABLE
//! Memory length of driver updated for firmware logging
#define GLOBAL_BUFF_LEN (15000 + (FW_LOG_QUEUE_SIZE * MAX_FW_LOG_MSG_LEN))
#else
//! Memory length for driver
#define GLOBAL_BUFF_LEN 15000
#endif

//! WLAN task priority
#define RSI_WLAN_TASK_PRIORITY 1

//! Wireless driver task priority
#define RSI_DRIVER_TASK_PRIORITY 2

//! WLAN task stack size
#define RSI_WLAN_TASK_STACK_SIZE 500

//! Wireless driver task stack size
#define RSI_DRIVER_TASK_STACK_SIZE 500

//! Memory to initialize driver
uint8_t global_buf[GLOBAL_BUFF_LEN];

#if ENABLE_NOVUS_TEST
//! Power Save Profile mode
#define PSP_MODE RSI_SLEEP_MODE_2

//! Power Save Profile type
#define PSP_TYPE RSI_MAX_PSP

//! Packet send interval in ms
#define PKT_SEND_INTERVAL 55000

int32_t rsi_wlan_power_save_profile(uint8_t psp_mode, uint8_t psp_type);
#endif

#ifdef FW_LOGGING_ENABLE
/*=======================================================================*/
//!    Firmware logging configurations
/*=======================================================================*/
//! Firmware logging task defines
#define RSI_FW_TASK_STACK_SIZE (512 * 2)
#define RSI_FW_TASK_PRIORITY   1
//! Firmware logging variables
extern rsi_semaphore_handle_t fw_log_app_sem;
rsi_task_handle_t fw_log_task_handle = NULL;
//! Firmware logging prototypes
void sl_fw_log_callback(uint8_t *log_message, uint16_t log_message_length);
void sl_fw_log_task(void);
#endif

extern uint64_t ip_to_reverse_hex(char *ip);

int32_t rsi_tcp_client()
{
  int32_t client_socket;
  struct rsi_sockaddr_in server_addr, client_addr;
  int32_t status        = RSI_SUCCESS;
  int32_t packet_count  = 0;
  uint8_t max_tcp_retry = RSI_MAX_TCP_RETRIES;
#if !(DHCP_MODE)
  uint32_t ip_addr      = ip_to_reverse_hex(DEVICE_IP);
  uint32_t network_mask = ip_to_reverse_hex(NETMASK);
  uint32_t gateway      = ip_to_reverse_hex(GATEWAY);
#else
  uint8_t dhcp_mode = (RSI_DHCP | RSI_DHCP_UNICAST_OFFER);
#endif

#ifdef FW_LOGGING_ENABLE
  //Fw log component level
  sl_fw_log_level_t fw_component_log_level;
#endif

#ifdef RSI_WITH_OS
  //! Silabs module initialization
  status = rsi_device_init(LOAD_NWP_FW);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nDevice Initialization Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nDevice Initialization Success\r\n");
  }
#endif

  //! Wireless initialization
  status = rsi_wireless_init(0, 0);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nWireless Initialization Failed, Error Code : 0x%lX\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nWireless Initialization Success\r\n");
  }

#ifdef FW_LOGGING_ENABLE
  //! Set log levels for firmware components
  sl_set_fw_component_log_levels(&fw_component_log_level);

  //! Configure firmware logging
  status = sl_fw_log_configure(FW_LOG_ENABLE,
                               FW_TSF_GRANULARITY_US,
                               &fw_component_log_level,
                               FW_LOG_BUFFER_SIZE,
                               sl_fw_log_callback);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\n Firmware Logging Init Failed\r\n");
  }

#ifdef RSI_WITH_OS
  //! Create firmware logging semaphore
  rsi_semaphore_create(&fw_log_app_sem, 0);

  //! Create firmware logging task
  rsi_task_create((rsi_task_function_t)sl_fw_log_task,
                  (uint8_t *)"fw_log_task",
                  RSI_FW_TASK_STACK_SIZE,
                  NULL,
                  RSI_FW_TASK_PRIORITY,
                  &fw_log_task_handle);
#endif
#endif

#ifdef RSI_WITH_OS
  while (1) {
#endif
    //! Scan for Access points
    status = rsi_wlan_scan((int8_t *)SSID, (uint8_t)CHANNEL_NO, NULL, 0);
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\nWLAN AP Scan Failed, Error Code : 0x%lX\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nWLAN AP Scan Success\r\n");
    }

    //! Connect to an Access point
    status = rsi_wlan_connect((int8_t *)SSID, SECURITY_TYPE, PSK);
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\nWLAN AP Connect Failed, Error Code : 0x%lX\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nWLAN AP Connect Success\r\n");
    }

    //! Configure IP
#if DHCP_MODE
    status = rsi_config_ipaddress(RSI_IP_VERSION_4, dhcp_mode, 0, 0, 0, NULL, 0, 0);
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
      LOG_PRINT("\r\nIP Config Failed, Error Code : 0x%lX\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nIP Config Success\r\n");
    }

#if ENABLE_NOVUS_TEST
    //! Apply power save profile
    status = rsi_wlan_power_save_profile(PSP_MODE, PSP_TYPE);
    if (status != RSI_SUCCESS) {
      return status;
    }
    LOG_PRINT("\r\nENABLE_POWER_SAVE Success\r\n");
#endif

    //! Create socket
    client_socket = rsi_socket(AF_INET, SOCK_STREAM, 0);
    if (client_socket < 0) {
      status = rsi_wlan_get_status();
      LOG_PRINT("\r\nSocket Create Failed, Error Code : 0x%lX\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nSocket Create Success\r\n");
    }

    //! To provide the TCP max retry count
    status = rsi_setsockopt(client_socket, SOL_SOCKET, SO_MAXRETRY, &max_tcp_retry, sizeof(max_tcp_retry));
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\nSet Socket Options Failed, Error Code : 0x%lX\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nSet Socket Options Success\r\n");
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
      LOG_PRINT("\r\nBind Failed, Error code : 0x%lX\r\n", status);
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
    server_addr.sin_addr.s_addr = ip_to_reverse_hex(SERVER_IP_ADDRESS);

    //! Connect to server socket
    status = rsi_connect(client_socket, (struct rsi_sockaddr *)&server_addr, sizeof(server_addr));
    if (status != RSI_SUCCESS) {
      status = rsi_wlan_get_status();
      rsi_shutdown(client_socket, 0);
      LOG_PRINT("\r\nConnect to Server Socket Failed, Error Code : 0x%lX\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nConnect to Server Socket Success\r\n");
    }

    LOG_PRINT("\r\nTCP TX start\r\n");

    while (packet_count < NUMBER_OF_PACKETS) {
      //! Send data on socket
      status =
        rsi_send(client_socket, (int8_t *)"Hello from TCP client!!!", (sizeof("Hello from TCP client!!!") - 1), 0);
      if (status < 0) {
        status = rsi_wlan_get_status();
        rsi_shutdown(client_socket, 0);
        LOG_PRINT("\r\nFailed to Send data to TCP Server, Error Code : 0x%lX\r\n", status);
        return status;
      }

#ifndef RSI_WITH_OS
      rsi_wireless_driver_task();
#endif

      packet_count++;

#if ENABLE_NOVUS_TEST
      LOG_PRINT("\r\n PKT sent\r\n");
      rsi_delay_ms(PKT_SEND_INTERVAL);
#endif
    }

    LOG_PRINT("\r\nTCP TX complete\r\n");

    //! closing socket after completing data transfer
    status = rsi_shutdown(client_socket, 0);
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\nSocket Close Failed, Error Code : 0x%lX\r\n", status);
    } else {
      LOG_PRINT("\r\nSocket Close Success\r\n");
    }

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
  //! Silabs module initialization
  status = rsi_device_init(LOAD_NWP_FW);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nDevice Initialization Failed, Error Code : 0x%lX\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nDevice Initialization Success\r\n");
  }
#endif

#ifdef RSI_WITH_OS
  //! OS case
  //! Task created for WLAN task
  rsi_task_create((rsi_task_function_t)rsi_tcp_client,
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
  //! Call TCP client application
  status = rsi_tcp_client();

  //! Application main loop
  main_loop();
#endif
  return status;
}
