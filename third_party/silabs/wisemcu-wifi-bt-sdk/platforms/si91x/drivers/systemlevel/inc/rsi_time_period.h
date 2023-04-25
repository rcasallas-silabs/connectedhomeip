/*******************************************************************************
* @file  rsi_time_period.h
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
 * Includes
 */

#ifndef __RSI_TIME_PERIOD_H__
#define __RSI_TIME_PERIOD_H__
#include "rsi_ccp_common.h"

#ifdef __cplusplus
extern "C" {
#endif

error_t RSI_TIMEPERIOD_TimerClkSel(TIME_PERIOD_Type *pstcTimePeriod, uint32_t u32TimePeriod);

#ifdef __cplusplus
}
#endif

/*End of file not truncated*/
#endif /*__RSI_TIME_PERIOD_H__*/
