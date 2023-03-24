/*******************************************************************************
* @file  rsi_tx_on_button_wakeup.c
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
 * packet f rom M4 then process packet after that both will go to sleep.�
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
#define SERVER_PORT 5004

//! Device port number
#define DEVICE_PORT 5004

//! Power Save Profile Mode
#define PSP_TYPE RSI_MAX_PSP

//! Number of packet to send or receive
#define NUMBER_OF_PACKETS 1 //45964 // 64MB

//! Memory length for driver
#define GLOBAL_BUFF_LEN 15000

//! Memory to initialize driver
uint8_t global_buf[GLOBAL_BUFF_LEN];

#define BUF_SIZE 1460
uint8_t send_buf[BUF_SIZE] = { 0xFF };

#ifdef COMMON_FLASH_EN
#define IVT_OFFSET_ADDR 0x8212000 /*<!Application IVT location VTOR offset>        */
#else
#define IVT_OFFSET_ADDR 0x8012000 /*<!Application IVT location VTOR offset>        */
#endif
#define WKP_RAM_USAGE_LOCATION     0x24061000 /*<!Bootloader RAM usage location upon wake up  */
#define WIRELESS_WAKEUP_IRQHandler NPSS_TO_MCU_WIRELESS_INTR_IRQn

uint32_t send_data_count;
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
  rsi_delay_ms(1000);
#ifdef DEBUG_UART
  fpuInit();
  DEBUGINIT();
#endif
}

int32_t rsi_powersave_profile_app()
{
  int32_t client_socket;
  struct rsi_sockaddr_in server_addr, client_addr;
  volatile int32_t status        = RSI_SUCCESS;
  volatile uint32_t packet_count = 0;
  uint8_t xtal_enable            = 0;
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
  client_socket = rsi_socket(AF_INET, SOCK_DGRAM, 0);
  if (client_socket < 0) {
    LOG_PRINT("\r\nSocket Create Failed, Error Code : 0x%X\r\n", status);
    status = rsi_wlan_get_status();
    return status;
  } else {
    LOG_PRINT("\r\nSocket Create Success\r\n");
  }
  //! Set server structure
  memset(&server_addr, 0, sizeof(server_addr));

  //! Set family type
  server_addr.sin_family = AF_INET;

  //! Set server port number, using htons function to use proper byte order
  server_addr.sin_port = htons(SERVER_PORT);
  //! Set IP address to localhost
  server_addr.sin_addr.s_addr = ip_to_reverse_hex((char *)SERVER_IP_ADDRESS);
  //! Filter Broad cast enable
  status = rsi_wlan_filter_broadcast(3000, 1, 1);
  if (status != RSI_SUCCESS) {
    status = rsi_wlan_get_status();
    rsi_shutdown(client_socket, 0);
    return status;
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
#ifdef UULP_GPIO_BASED_WAKEUP
  RSI_Button_wakeup_config();
#endif
  while (1) {
    LOG_PRINT("\r\nSending Data To UDP Server socket\r\n");
    //! Send data on socket
    status = rsi_sendto(client_socket,
                        (int8_t *)send_buf,
                        BUF_SIZE,
                        0,
                        (struct rsi_sockaddr *)&server_addr,
                        sizeof(server_addr));
    if (status < 0) {
      status = rsi_wlan_get_status();
      rsi_shutdown(client_socket, 0);
      return status;
    }
    LOG_PRINT("\r\nSending Data To UDP Server Socket Is Success\r\n");
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
  LOG_PRINT("\r\nCCP-Powersave UDP_Tx_On_Button_Wakeup Application Demo\r\n");
  status = rsi_powersave_profile_app();

  return status;
}

#ifdef UULP_GPIO_BASED_WAKEUP
/* GPIO INTR IRQ handler */
void IRQ021_Handler(void)
{
  /* clear NPSS GPIO interrupt*/
  RSI_NPSSGPIO_ClrIntr(NPSS_GPIO_2_INTR);
}

void RSI_Button_wakeup_config(void)
{
  /*GPIO based wake up */
  /*Configure the UULP GPIO2 mode to wake up  */
  RSI_NPSSGPIO_SetPinMux(NPSS_GPIO_2, NPSSGPIO_PIN_MUX_MODE2);

  /*Configure the UULP GPIO2 direction to input */
  RSI_NPSSGPIO_SetDir(NPSS_GPIO_2, NPSS_GPIO_DIR_INPUT);

  /*Configure the UULP GPIO2 interrupt polarity */
  RSI_NPSSGPIO_SetPolarity(NPSS_GPIO_2, NPSS_GPIO_INTR_LOW);

  /*Enable the REN*/
  RSI_NPSSGPIO_InputBufferEn(NPSS_GPIO_2, 1);

  /*Set the GPIO to wake from deep sleep */
  RSI_NPSSGPIO_SetWkpGpio(NPSS_GPIO_2_INTR);

  /* un mask the UULP GPIO interrupt*/
  RSI_NPSSGPIO_IntrUnMask(NPSS_GPIO_2_INTR);

  /*Select wake up sources */
  RSI_PS_SetWkpSources(GPIO_BASED_WAKEUP);

  /*Enable the UULP GPIO interrupt slot*/
  NVIC_EnableIRQ(NPSS_TO_MCU_GPIO_INTR_IRQn);
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
