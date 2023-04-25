/*******************************************************************************
* @file  gpdma.h
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
/** @file gpdma.h
 * 
 * 	@brief This file contains functions prototype of transfer or receive
 *         SDIO slave data using GPDMA. 
 *
 */

#include "rsi_chip.h"

void GPDMA_TX_Trigger(uint8_t num_of_blocks, uint8_t *data_buf);
void GPDMA_RX_Trigger(uint8_t *data_buf);

////////////////////////////////////////////////////////////////
#define TA_MISC_CONFIG_BASE 0x41050000
#define M4_MISC_CONFIG_BASE 0x46008000

#define SDIO_BASE 0x20200000

#define M4_HOST_INTR_MASK_REG (*(volatile uint32_t *)(M4_MISC_CONFIG_BASE + 0x00))

#define M4_HOST_INTR_CLEAR (*(volatile uint32_t *)(M4_MISC_CONFIG_BASE + 0x08))

#define RX_NUM_CHUNKS (*(volatile uint32_t *)(SDIO_BASE + 0x242))

#define SDIO_FN1_INT_ENABLE (*(volatile uint32_t *)(SDIO_BASE + 0x04))

#define SDIO_FN1_INT_CLEAR (*(volatile uint32_t *)(SDIO_BASE + 0x00))

#define SDIO_RFIFO_DATA_REGISTER (*(volatile uint32_t *)(SDIO_BASE + 0x40))

#define SDIO_FN1_INT_UNMASK_REG (*(volatile uint32_t *)(SDIO_BASE + 0x0C))
#define SDIO_FN1_INT_MASK_REG   (*(volatile uint32_t *)(SDIO_BASE + 0x08))

#define MISC_CFG_HOST_CTRL (*(volatile uint32_t *)(M4_MISC_CONFIG_BASE + 0x0C))
#define SDIO_READ          (*(volatile uint32_t *)(SDIO_BASE + 0x00))

#define SDIO_REG_INT_MSK  *(volatile uint16_t *)((SDIO_BASE + 0x08))
#define SDIO_REG_INT_STAT *(volatile uint16_t *)((SDIO_BASE + 0x00))

#define INT_STAT_TX_TMOUT  BIT(15)
#define INT_STAT_ABRT_SPI  BIT(14)
#define INT_STAT_ABRT_SDIO BIT(6)
#define INT_STAT_CRC_SDIO  BIT(11)
#define INT_STAT_CMD53_RD  BIT(1)
#define INT_STAT_CMD53_WR  BIT(0)
#define INT_STAT_WR_RD_REQ BIT(8)
#define INT_EN_CMD53_WR    BIT(0)
#define INT_STAT_CMD53_WR  BIT(0)
////////////////////////////////////////////////////////////////
