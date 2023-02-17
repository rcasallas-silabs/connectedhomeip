/*******************************************************************************
 * @file  ulp_udma.c
 * @brief
 *******************************************************************************
 * # License
 * <b>Copyright 2022 Silicon Laboratories Inc. www.silabs.com</b>
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

/**=============================================================================
 * @brief : This file contains example application for UDMA Memory to Memory Data
 * Transfer
 * @section Description :
 * This example shows how to setup and use the UDMA controller for a limited
 * software triggered memory to memory transfer.
 * Because of the limited burst transfer size of the DMA (1024 transfers max) and
 * limited burst size.
   ===========================================================================**/

// Include Files

#include "UDMA.h"
#include "rsi_board.h"
#include "rsi_rom_udma_wrapper.h"

#define SIZE_BUFFERS (1024)
#define DMA_DESC_LEN (1024)
#define CHNL         1

#define RESERVED_IRQ_COUNT    16
#define EXT_IRQ_COUNT         98
#define VECTOR_TABLE_ENTRIES (RESERVED_IRQ_COUNT + EXT_IRQ_COUNT)
uint32_t ramVector[VECTOR_TABLE_ENTRIES] __attribute__ ((aligned(256)));

// DMA descriptors must be aligned to 16 bytes 
#if defined(__CC_ARM)
extern RSI_UDMA_DESC_T UDMA0_Table[CONTROL_STRUCT0];
extern RSI_UDMA_DESC_T UDMA1_Table[CONTROL_STRUCT1];
#endif // defined (__CC_ARM) 

#if defined(__GNUC__)
extern RSI_UDMA_DESC_T __attribute__((section(".udma_addr0"))) UDMA0_Table[CONTROL_STRUCT0];
extern RSI_UDMA_DESC_T __attribute__((section(".udma_addr1"))) UDMA1_Table[CONTROL_STRUCT1];
#endif // defined (__GNUC__) 

extern UDMA_Channel_Info udma1_chnl_info[32];

// UDMA0 Resources 
//extern UDMA_RESOURCES UDMA0_Resources;

// UDMA1 Resources 
extern UDMA_RESOURCES UDMA1_Resources;

extern RSI_UDMA_HANDLE_T udmaHandle1;

uint32_t src1[SIZE_BUFFERS];
uint32_t dst1[SIZE_BUFFERS];
extern uint32_t dma_rom_buff1[30]; //we can keep wrapeers
void hardware_setup(void);

volatile uint32_t done, ret;

/*==============================================*/
/**
 * @fn         void udmaTransferComplete(uint32_t event, uint8_t ch)
 * @brief      UDMA  controller transfer descriptor chain complete callback
 * @param[in]  event - dma transfer events
 * @param[in]  ch    - dma channel number
 * @return     None
 */
void udmaTransferComplete(uint32_t event, uint8_t ch)
{
  if (event == UDMA_EVENT_XFER_DONE) {
    if (ch == CHNL) {
      done = 1;
    }
  }
}

/*==============================================*/
/**
 * @fn         int main()
 * @brief      Main Application Function
 * @return     None
 */
int main()
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_rs1xxxx.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * startup_rs1xxxx.c file
   */
  int loop       = 0;
  int32_t status = RSI_OK;

  RSI_UDMA_CHA_CONFIG_DATA_T control;
  RSI_UDMA_CHA_CFG_T config;

//copying the vector table from flash to ram
  memcpy(ramVector, (uint32_t*)SCB->VTOR, sizeof(uint32_t) * VECTOR_TABLE_ENTRIES);

//assing the ram vector adress to VTOR register 
  SCB->VTOR = (uint32_t)ramVector;

  // Configures the system default clock and power configurations
  SystemCoreClockUpdate();
  
  //Switching MCU from PS4 to PS2 state
  hardware_setup();

  // Initialize UART for debug prints 
  DEBUGINIT();

  memset(&control, 0, sizeof(RSI_UDMA_CHA_CONFIG_DATA_T));
  memset(&config, 0, sizeof(RSI_UDMA_CHA_CFG_T));

  config.altStruct       = 0;
  config.burstReq        = 1;
  config.channelPrioHigh = 0;
  config.dmaCh           = CHNL;
  config.periAck         = 0;
  config.periphReq       = 0;
  config.reqMask         = 0;

  control.transferType       = UDMA_MODE_BASIC;
  control.nextBurst          = 0;
  control.totalNumOfDMATrans = (DMA_DESC_LEN - 1);
  control.rPower             = ARBSIZE_1024;
  control.srcProtCtrl        = 0x000;
  control.dstProtCtrl        = 0x000;
  control.srcSize            = SRC_SIZE_32;
  control.srcInc             = SRC_INC_32;
  control.dstSize            = DST_SIZE_32;
  control.dstInc             = DST_INC_32;

  // Filled data in source buffer 
  for (loop = 0; loop < SIZE_BUFFERS; loop++) {
    src1[loop] = loop + 1;
    dst1[loop] = 0;
  }
  // Prints on hyper-terminal  
  DEBUGOUT("UDMA Memory to Memory data transfer example\r\n");

  // Initialize dma 
  udmaHandle1 = UDMAx_Initialize(&UDMA1_Resources, UDMA1_Table, udmaHandle1, dma_rom_buff1);
  if (udmaHandle1 == NULL) {
    DEBUGOUT("\r\nFailed to Initialize UDMA\r\n");
    return -1;
  } else {
    DEBUGOUT("\r\nUDMA Initialization Success\r\n");
  }

  // Configure dma channel 
  status = UDMAx_ChannelConfigure(&UDMA1_Resources,
                                  CHNL,
                                  (uint32_t)src1,
                                  (uint32_t)dst1,
                                  SIZE_BUFFERS,
                                  control,
                                  &config,
                                  udmaTransferComplete,
                                  udma1_chnl_info,
                                  udmaHandle1);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to configure parameters to UDMA channel,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nConfigured parameters to UDMA channel\r\n");
  }

  // Enable dma channel 
  status = UDMAx_ChannelEnable(CHNL, &UDMA1_Resources, udmaHandle1);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to enable UDMA channel,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nEnabled UDMA channel\r\n");
  }

  // Enable dma controller 
  status = UDMAx_DMAEnable(&UDMA1_Resources, udmaHandle1);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to enable UDMA,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nEnabled UDMA\r\n");
  }

  status = RSI_UDMA_ChannelSoftwareTrigger(udmaHandle1, CHNL);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to enable software trigger to UDMA channel,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nEnabled software trigger to UDMA channel\r\n");
  }

  // Wait till dma done 
  while (!done);

  // Compare data buffers 
  for (ret = 0; ret < SIZE_BUFFERS; ret++) {
    if (dst1[ret] == src1[ret]) {
      continue;
    } else {
      break;
    }
  }

  if (ret == SIZE_BUFFERS) {
    // Prints on hyper-terminal  
    DEBUGOUT("\r\nTest case pass\r\n");
  } else {
    // Prints on hyper-terminal  
    DEBUGOUT("\r\nData comparison fail\r\n");
    DEBUGOUT("\r\nTest case fail\r\n");
  }

  // Uninitialize dma 
  UDMAx_Uninitialize(&UDMA1_Resources);

  while (1)
    ;
}

