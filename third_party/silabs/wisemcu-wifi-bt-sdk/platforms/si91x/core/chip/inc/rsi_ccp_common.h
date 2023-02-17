/*******************************************************************************
* @file  rsi_cpp_common.h
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
#include "rsi_ccp_user_config.h"
#ifdef CHIP_9117
#include "RS1xxxx_9117.h"
#include "RTE_Device_9117.h"
#else
#include "RS1xxxx.h"
#include "RTE_Device.h"
#endif
