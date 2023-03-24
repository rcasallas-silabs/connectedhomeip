/*******************************************************************************
* @file  rsi_udp_client.c
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
 * @brief : This file contains example application for UDP Client
 * @section Description :
 * The UDP client application demonstrates how to open and use a standard UDP
 * client socket and sends data to UDP server socket.
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

#include "rsi_wlan_config.h"

#include <string.h>
#include "rsi_utils.h"
#include <string.h>

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

//! If DHCP mode is disabled give IP statically
#if !(DHCP_MODE)

//! IP address of the module
#define DEVICE_IP "192.168.10.101"

//! IP address of Gateway
#define GATEWAY "192.168.10.1"

//! IP address of netmask
#define NETMASK "255.255.255.0"

#endif

//! Server port number
#define SERVER_PORT 5001

//! Server IP address. Should be in reverse long format
//! E.g: 0x640AA8C0 == 192.168.10.100
#define SERVER_IP_ADDRESS "192.168.10.100"

//! Number of packet to send or receive
#define NUMBER_OF_PACKETS 10000

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

extern uint64_t ip_to_reverse_hex(char *ip);

int32_t rsi_udp_client()
{
  int32_t client_socket;
  struct rsi_sockaddr_in server_addr;
  int32_t status       = RSI_SUCCESS;
  int32_t packet_count = 0;

#if !(DHCP_MODE)
  uint32_t ip_addr      = ip_to_reverse_hex(DEVICE_IP);
  uint32_t network_mask = ip_to_reverse_hex(NETMASK);
  uint32_t gateway      = ip_to_reverse_hex(GATEWAY);
#else
  uint8_t dhcp_mode = (RSI_DHCP | RSI_DHCP_UNICAST_OFFER);

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
#endif

  //! Wireless initialization
  status = rsi_wireless_init(0, 0);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nWireless Initialization Failed, Error Code : 0x%lX\r\n", status);
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
      LOG_PRINT("\r\nIP Config Failed, Error Code : 0x%lX\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nIP Config Success\r\n");
    }

    //! Create socket
    client_socket = rsi_socket(AF_INET, SOCK_DGRAM, 0);
    if (client_socket < 0) {
      status = rsi_wlan_get_status();
      LOG_PRINT("\r\nSocket Create Failed, Error Code : 0x%lX\r\n", status);
      return status;
    } else {
      LOG_PRINT("\r\nSocket Create Success\r\n");
    }

    //! Set server structure
    memset(&server_addr, 0, sizeof(server_addr));

    //! Set server address family
    server_addr.sin_family = AF_INET;

    //! Set server port number, using htons function to use proper byte order
    server_addr.sin_port = htons(SERVER_PORT);

    //! Set IP address to localhost
    server_addr.sin_addr.s_addr = ip_to_reverse_hex(SERVER_IP_ADDRESS);

    LOG_PRINT("\r\nUDP TX start\r\n");

    while (packet_count < NUMBER_OF_PACKETS) {
      //! Send data on socket
      status = rsi_sendto(client_socket,
                          (int8_t *)"Hello from UDP client!!!",
                          (sizeof("Hello from UDP client!!!") - 1),
                          0,
                          (struct rsi_sockaddr *)&server_addr,
                          sizeof(server_addr));
      if (status < 0) {
        status = rsi_wlan_get_status();
        rsi_shutdown(client_socket, 0);
        LOG_PRINT("\r\nFailed to send data to UDP Server, Error Code : 0x%lX\r\n", status);
        return status;
      }
#ifndef RSI_WITH_OS
      rsi_wireless_driver_task();
#endif
      //! Increase packet count
      packet_count++;
    }

    LOG_PRINT("\r\nUDP TX complete\r\n");

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
  //!  Silabs module initialization
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
  rsi_task_create((rsi_task_function_t)rsi_udp_client,
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
  //! Call UDP client application
  status = rsi_udp_client();

  //! Application main loop
  main_loop();
#endif
  return status;
}
