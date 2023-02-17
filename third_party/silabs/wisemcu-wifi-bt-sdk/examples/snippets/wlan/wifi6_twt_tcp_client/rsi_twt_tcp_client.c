/*******************************************************************************
* @file  rsi_twt_tcp_client.c
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
#include "rsi_driver.h"
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

#ifdef RSI_M4_INTERFACE
#include "rsi_wisemcu_hardware_setup.h"
#endif

//! Access point SSID to connect
#define SSID "SILABS_AP"

//!Scan Channel number , 0 - to scan all channels
#define CHANNEL_NO 0

//! Security type
#define SECURITY_TYPE RSI_WPA2

//! Password
#define PSK "12345678"

//! DHCP mode 1- Enable 0- Disable
#define DHCP_MODE 0

//! If DHCP mode is disabled given IP statically
#if !(DHCP_MODE)

//! IP address of the module
//! E.g: 0x650AA8C0 == 192.168.10.101
#define DEVICE_IP "192.168.10.101" //0x6500A8C0

//! IP address of Gateway
//! E.g: 0x010AA8C0 == 192.168.10.1
#define GATEWAY "192.168.10.1" //0x010AA8C0

//! IP address of netmask
//! E.g: 0x00FFFFFF == 255.255.255.0
#define NETMASK "255.255.255.0" //0x00FFFFFF

#endif

//! Device port number
#define DEVICE_PORT 5001

//! Server port number
#define SERVER_PORT 5001

//! Server IP address. Should be in reverse long format
//! E.g: 0x640AA8C0 == 192.168.10.100
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

//! Wlan task priority
#define RSI_WLAN_TASK_PRIORITY 1

//! Wireless driver task priority
#define RSI_DRIVER_TASK_PRIORITY 2

//! Wlan task stack size
#define RSI_WLAN_TASK_STACK_SIZE 500

//! Wireless driver task stack size
#define RSI_DRIVER_TASK_STACK_SIZE 500

#if ENABLE_POWER_SAVE
//! Power Save Profile mode
#define PSP_MODE RSI_SLEEP_MODE_2

//! Power Save Profile type
#define PSP_TYPE RSI_MAX_PSP

//! TCP TX
#define SEND_TCP_DATA 0

int32_t rsi_wlan_power_save_profile(uint8_t psp_mode, uint8_t psp_type);
#endif
//! Memory to initialize driver
uint8_t global_buf[GLOBAL_BUFF_LEN];

uint64_t ip_to_reverse_hex(char *ip);
//twt session status
uint32_t twt_session_active = 0;
//twt async response handler
void twt_response_handler(uint16_t status, uint8_t *buffer, const uint32_t length);

#ifdef RSI_M4_INTERFACE
void M4_sleep_wakeup(void);
#endif
#ifdef RSI_M4_INTERFACE
#ifdef COMMON_FLASH_EN
#define IVT_OFFSET_ADDR 0x8212000 /*<!Application IVT location VTOR offset>        */
#else
#define IVT_OFFSET_ADDR 0x8012000 /*<!Application IVT location VTOR offset>        */
#endif
#define WKP_RAM_USAGE_LOCATION     0x24061000 /*<!Bootloader RAM usage location upon wake up  */
#define WIRELESS_WAKEUP_IRQHandler NPSS_TO_MCU_WIRELESS_INTR_IRQn
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

#ifdef RSI_M4_INTERFACE

void M4_sleep_wakeup()
{
#ifndef FLASH_BASED_EXECUTION_ENABLE

  /* LDOSOC Default Mode needs to be disabled */
  RSI_PS_LdoSocDefaultModeDisable();

  /* bypass_ldorf_ctrl needs to be enabled */
  RSI_PS_BypassLdoRfEnable();

  RSI_PS_FlashLdoDisable();

  /* Configure RAM Usage and Retention Size */
  RSI_WISEMCU_ConfigRamRetention(WISEMCU_48KB_RAM_IN_USE, WISEMCU_RETAIN_DEFAULT_RAM_DURING_SLEEP);

  /* Trigger M4 Sleep */
  RSI_WISEMCU_TriggerSleep(SLEEP_WITH_RETENTION,
                           DISABLE_LF_MODE,
                           0,
                           (uint32_t)RSI_PS_RestoreCpuContext,
                           0,
                           RSI_WAKEUP_WITH_RETENTION_WO_ULPSS_RAM);

#else
  /* Trigger M4 Sleep*/
  RSI_WISEMCU_TriggerSleep(SLEEP_WITH_RETENTION,
                           DISABLE_LF_MODE,
                           WKP_RAM_USAGE_LOCATION,
                           (uint32_t)RSI_PS_RestoreCpuContext,
                           IVT_OFFSET_ADDR,
                           RSI_WAKEUP_FROM_FLASH_MODE);
#endif
}
#endif

int32_t rsi_tcp_client()
{
  int32_t client_socket;
  struct rsi_sockaddr_in server_addr, client_addr;
  int32_t status       = RSI_SUCCESS;
  int32_t packet_count = 0;
  twt_user_params_t twt_req;
  uint8_t ip_buff[20];
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
  //! Silabs module intialisation
  status = rsi_device_init(LOAD_NWP_FW);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nDevice Initialization Failed, Error Code : 0x%X\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nDevice Initialization Success\r\n");
  }
#endif
#ifdef RSI_M4_INTERFACE
  /* MCU Hardware Configuration for Low-Power Applications */
  RSI_WISEMCU_HardwareSetup();
#endif
  //! WC initialization
  status = rsi_wireless_init(0, 0);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nWireless Initialization Failed, Error Code : 0x%lX\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nWireless Initialization Success\r\n");
  }
  //! Send feature frame
  status = rsi_send_feature_frame();
  if (status != RSI_SUCCESS) {
    return status;
  }
  //!TWT callback register
  rsi_wlan_register_callbacks(RSI_WLAN_TWT_RESPONSE_CB, twt_response_handler);
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
  status = rsi_config_ipaddress(RSI_IP_VERSION_4, dhcp_mode, 0, 0, 0, ip_buff, sizeof(ip_buff), 0);
#else
  status            = rsi_config_ipaddress(RSI_IP_VERSION_4,
                                RSI_STATIC,
                                (uint8_t *)&ip_addr,
                                (uint8_t *)&network_mask,
                                (uint8_t *)&gateway,
                                ip_buff,
                                sizeof(ip_buff),
                                0);
#endif
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nIP Config Failed, Error Code : 0x%lX\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nIP Config Success\r\n");
    LOG_PRINT("RSI_STA IP ADDR: %d.%d.%d.%d \r\n", ip_buff[6], ip_buff[7], ip_buff[8], ip_buff[9]);
  }

  //! Create socket
  client_socket = rsi_socket(AF_INET, SOCK_STREAM, 0);
  if (client_socket < 0) {
    status = rsi_wlan_get_status();
    LOG_PRINT("\r\nSocket Create Failed, Error Code : 0x%lX\r\n", status);
    return status;
  } else {
    LOG_PRINT("\r\nSocket Create Success\r\n");
  }

  //! Memset client structrue
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
  LOG_PRINT("\r\nSocket Connecting\r\n");
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

  if (TWT_SUPPORT == 1) {
    twt_req.wake_duration           = 0x60;
    twt_req.wake_duration_unit      = 0; // wake duration unit 0 - 256 uSec; 1 - 1024 uSec
    twt_req.wake_duration_tol       = 0x60;
    twt_req.wake_int_exp            = 13;
    twt_req.wake_int_exp_tol        = 13;
    twt_req.wake_int_mantissa       = 0x1D4C;
    twt_req.wake_int_mantissa_tol   = 0x1D4C;
    twt_req.implicit_twt            = 1;
    twt_req.un_announced_twt        = 1;
    twt_req.triggered_twt           = 0;
    twt_req.twt_channel             = 0; // twt_channel must be zero
    twt_req.twt_protection          = 0; // twt_protection must be zero
    twt_req.restrict_tx_outside_tsp = 1;
    twt_req.twt_retry_limit         = 6;
    twt_req.twt_retry_interval      = 10;
    twt_req.req_type                = 1; // 0 - Request TWT; 1 - Suggest TWT; 2 - Demand TWT
    status                          = rsi_wlan_twt_config(1, 1, &twt_req);
    if (status != RSI_SUCCESS) {
      LOG_PRINT("\r\n twt config command failed Error Code : 0x%lX\r\n", status);
      return status;
    }
  }
  rsi_delay_ms(100);

  //! Enable Broadcast data filter
  status = rsi_wlan_filter_broadcast(5000, 1, 1);
  if (status != RSI_SUCCESS) {
    LOG_PRINT("\r\nBroadcast Data Filtering Failed with Error Code : 0x%lX\r\n", status);
    return status;
  }

#if ENABLE_POWER_SAVE
  //! Apply power save profile
  status = rsi_wlan_power_save_profile(PSP_MODE, PSP_TYPE);
  if (status != RSI_SUCCESS) {
    return status;
  }
#endif
#if SEND_TCP_DATA
  while (packet_count < NUMBER_OF_PACKETS) {
    //! Send data on socket
    status = rsi_send(client_socket, (int8_t *)"Hello from TCP client!!!", (sizeof("Hello from TCP client!!!") - 1), 0);
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
  }
#endif
#ifdef RSI_M4_INTERFACE
  //! Keep M4 in sleep
  M4_sleep_wakeup();
#endif
#ifdef RSI_WITH_OS
  while (1)
    ;
#endif
  return 0;
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
  int32_t status = RSI_SUCCESS;
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
void twt_response_handler(uint16_t status, uint8_t *buffer, const uint32_t length)
{
  rsi_twt_rsp_t *rsp = (rsi_twt_rsp_t *)buffer;
  if (length > sizeof(rsi_twt_rsp_t)) {
    LOG_PRINT("\n length = 0x%X \t struct sz = 0x%X", length, sizeof(rsi_twt_rsp_t));
    LOG_PRINT("\n size of response structure doesn't match");
    return;
  }
  switch (status) {
    case TWT_SESSION_SUCC:
      LOG_PRINT("\r\n TWT Setup success");
      twt_session_active = 1;
      break;
    case TWT_UNSOL_SESSION_SUCC:
      LOG_PRINT("\r\n Unsolicited TWT Setup success");
      twt_session_active = 1;
      break;
    case TWT_SETUP_AP_REJECTED:
      LOG_PRINT("\r\nTWT Setup Failed. TWT Setup rejected by AP");
      break;
    case TWT_SETUP_RSP_OUTOF_TOL:
      LOG_PRINT("\r\nTWT Setup Failed. TWT response out of tolerence limits");
      break;
    case TWT_SETUP_RSP_NOT_MATCHED:
      LOG_PRINT("\r\n TWT Setup Failed. TWT Response not matched with the request parameters");
      break;
    case TWT_SETUP_UNSUPPORTED_RSP:
      LOG_PRINT("\r\n TWT Setup Failed. TWT Response Unsupported");
      break;
    case TWT_SETUP_FAIL_MAX_RETRIES_REACHED:
      LOG_PRINT("\r\n TWT Setup Failed. Max retries reached");
      break;
    case TWT_INACTIVE_DUETO_ROAMING:
      LOG_PRINT("\r\n TWT session inactive due to roaming");
      twt_session_active = 0;
      break;

    case TWT_INACTIVE_DUETO_DISCONNECT:
      LOG_PRINT("\r\n TWT session inactive due to wlan disconnection");
      twt_session_active = 0;
      break;

    case TWT_TEARDOWN_SUCC:
      LOG_PRINT("\r\n TWT session teardown success");
      twt_session_active = 0;
      break;

    case TWT_AP_TEARDOWN_SUCC:
      LOG_PRINT("\r\n TWT session teardown from AP");
      twt_session_active = 0;
      break;
    case TWT_INACTIVE_NO_AP_SUPPORT:
      LOG_PRINT("\r\nConnected AP Does not support TWT");
      twt_session_active = 0;
      break;
    default:
      LOG_PRINT("\r\n Unsupported TWT status : 0x%X", status);
      break;
  }
  if (status < 11) {
    LOG_PRINT("\r\n wake duration : 0x%lX", rsp->wake_duration);
    LOG_PRINT("\r\n wake_duration_unit: 0x%lX", rsp->wake_duration_unit);
    LOG_PRINT("\r\n wake_int_exp : 0x%lX", rsp->wake_int_exp);
    LOG_PRINT("\r\n negotiation_type : 0x%lX", rsp->negotiation_type);
    LOG_PRINT("\r\n wake_int_mantissa : 0x%lX", rsp->wake_int_mantissa);
    LOG_PRINT("\r\n implicit_twt : 0x%lX", rsp->implicit_twt);
    LOG_PRINT("\r\n un_announced_twt : 0x%lX", rsp->un_announced_twt);
    LOG_PRINT("\r\n triggered_twt : 0x%lX", rsp->triggered_twt);
    LOG_PRINT("\r\n twt_channel : 0x%lX", rsp->twt_channel);
    LOG_PRINT("\r\n twt_protection : 0x%lX", rsp->twt_protection);
    LOG_PRINT("\r\n twt_flow_id : 0x%lX\r\n", rsp->twt_flow_id);
  } else if (status < 13) {
    LOG_PRINT("\r\n twt_flow_id : 0x%lX\r\n", rsp->twt_flow_id);
    LOG_PRINT("\r\n negotiation_type : 0x%lX", rsp->negotiation_type);
  }
}
