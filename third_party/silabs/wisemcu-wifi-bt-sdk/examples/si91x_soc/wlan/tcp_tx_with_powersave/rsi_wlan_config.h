/*******************************************************************************
* @file  rsi_wlan_config.h
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
 * @file         rsi_config.h
 * @version      0.1
 * @date         15 Aug 2015
 *
 *
 *
 *  @brief : This file contains user configurable details to configure the device  
 *
 *  @section Description  This file contains user configurable details to configure the device 
 *
 *
 */
#ifndef RSI_CONFIG_H
#define RSI_CONFIG_H

#include "rsi_wlan_defines.h"

//! Enable feature
#define RSI_ENABLE 1
//! Disable feature
#define RSI_DISABLE 0

//! To enable concurrent mode
#define CONCURRENT_MODE RSI_DISABLE

//! opermode command paramaters
/*=======================================================================*/
//! To set wlan feature select bit map
#define RSI_FEATURE_BIT_MAP (FEAT_SECURITY_OPEN | FEAT_AGGREGATION)

//! TCP IP BYPASS feature check
#define RSI_TCP_IP_BYPASS (RSI_DISABLE)

//! TCP/IP feature select bitmap for selecting TCP/IP features
#define RSI_TCP_IP_FEATURE_BIT_MAP (TCP_IP_FEAT_DHCPV4_CLIENT | TCP_IP_FEAT_EXTENSION_VALID)

//! TCP/IP feature select bitmap for selecting TCP/IP features
#define RSI_EXT_TCPIP_FEATURE_BITMAP (EXT_TCP_IP_WAIT_FOR_SOCKET_CLOSE)

//! To set custom feature select bit map
#define RSI_CUSTOM_FEATURE_BIT_MAP (FEAT_CUSTOM_FEAT_EXTENTION_VALID | CUSTOM_FEAT_SOC_CLK_CONFIG_160MHZ)

//! To set Extended custom feature select bit map
#define RSI_EXT_CUSTOM_FEATURE_BIT_MAP (EXT_FEAT_256K_MODE)
/*=======================================================================*/

//! Feature frame parameters
/*=======================================================================*/
#define PLL_MODE      0
#define RF_TYPE       1  //! 0 - External RF 1- Internal RF
#define WIRELESS_MODE 12 //! HP mode - 0 ;LP mode - 12
#define ENABLE_PPP    0
#define AFE_TYPE      1
#define FEATURE_ENABLES \
  (RSI_FEAT_FRAME_PREAMBLE_DUTY_CYCLE | RSI_FEAT_FRAME_LP_CHAIN | RSI_FEAT_FRAME_IN_PACKET_DUTY_CYCLE)
/*=======================================================================*/

//! Band command paramters
/*=======================================================================*/

//! RSI_BAND_2P4GHZ(2.4GHz) or RSI_BAND_5GHZ(5GHz) or RSI_DUAL_BAND
#define RSI_BAND RSI_BAND_2P4GHZ //RSI_BAND_2P4GHZ

/*=======================================================================*/

#define RSI_HAND_SHAKE_TYPE M4_BASED

#define BUFFER_FULL_HANDLING 0

/*=======================================================================*/
#include "rsi_wlan_common_config.h"

#endif