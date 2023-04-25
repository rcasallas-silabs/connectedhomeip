/*******************************************************************************
* @file  rsi_wwdt.h
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
#ifndef __RSI_WDT_H__
#define __RSI_WDT_H__

#ifdef __cplusplus
extern "C" {
#endif
#include "rsi_ccp_common.h"
#include "base_types.h"

/**
 * @fn        	void RSI_WWDT_ConfigIntrTimer(MCU_WDT_Type *pstcWDT , uint16_t u16IntrTimerVal)
 * @brief     	This API is used to configure the interrupt timer of the watch dog timer
 * @param[in]  	  pstcWDT 	 			 : pointer to the WDT register instance
 * @param[in]  	  u16IntrTimerVal  : interrupt timer value
 * @return			None
 */
STATIC INLINE void RSI_WWDT_ConfigIntrTimer(MCU_WDT_Type *pstcWDT, uint16_t u16IntrTimerVal)
{
  pstcWDT->MCU_WWD_INTERRUPT_TIMER_b.WWD_INTERRUPT_TIMER = u16IntrTimerVal;
}

/**
 * @fn					void RSI_WWDT_ConfigSysRstTimer(MCU_WDT_Type *pstcWDT , uint16_t u16SysRstVal)	
 * @brief   	 	This API is used to configure the system reset timer of the watch dog timer
 * @param[in]	  pstcWDT 			  : pointer to the WDT register instance
 * @param[in] 	  u16SysRstVal 		: reset value
 * @return			NONE
 */
STATIC INLINE void RSI_WWDT_ConfigSysRstTimer(MCU_WDT_Type *pstcWDT, uint16_t u16SysRstVal)
{
  pstcWDT->MCU_WWD_SYSTEM_RESET_TIMER_b.WWD_SYSTEM_RESET_TIMER = u16SysRstVal;
}

/**
 * @fn			 		void RSI_WWDT_Disable(MCU_WDT_Type *pstcWDT)
 * @brief   	 	This API is used to Disable the Watch dog timer
 * @param[in] 	 	pstcWDT  	:pointer to the WDT register instance
 * @return		 	None
 */
STATIC INLINE void RSI_WWDT_Disable(MCU_WDT_Type *pstcWDT)
{
  /*0xF0 to Disable the watch dog */
  pstcWDT->MCU_WWD_MODE_AND_RSTART_b.WWD_MODE_EN_STATUS = 0xF0;
}

/**
 * @fn		 			 void RSI_WWDT_ReStart(MCU_WDT_Type *pstcWDT)
 * @brief   		 This API is used to restart the Watch dog timer
 * @param[in]		 pstcWDT  :pointer to the WDT register instance
 * @return 			 None
 */
STATIC INLINE void RSI_WWDT_ReStart(MCU_WDT_Type *pstcWDT)
{
  pstcWDT->MCU_WWD_MODE_AND_RSTART_b.WWD_MODE_RSTART = 1U;
}

/**
 * @fn					 void RSI_WWDT_IntrUnMask(void)
 * @brief   		 This API is used to unmask the Watch dog timer
 * @return		   None
 */
STATIC INLINE void RSI_WWDT_IntrUnMask(void)
{
  NPSS_INTR_MASK_CLR_REG = NPSS_TO_MCU_WDT_INTR;
}

/**
 * @fn					 void RSI_WWDT_IntrMask(void)
 * @brief   		 This API is used to mask the Watch dog timer
 * @return		   None
 */
STATIC INLINE void RSI_WWDT_IntrMask(void)
{
  NPSS_INTR_MASK_SET_REG = NPSS_TO_MCU_WDT_INTR;
}

// Function prototypes
void RSI_WWDT_IntrClear(void);

uint8_t RSI_WWDT_GetIntrStatus(void);

void RSI_WWDT_DeInit(MCU_WDT_Type *pstcWDT);

void RSI_WWDT_Start(MCU_WDT_Type *pstcWDT);

void RSI_WWDT_Init(MCU_WDT_Type *pstcWDT);

#ifdef __cplusplus
}
#endif

/*End of file not truncated*/
#endif /*__RSI_WDT_H__*/
