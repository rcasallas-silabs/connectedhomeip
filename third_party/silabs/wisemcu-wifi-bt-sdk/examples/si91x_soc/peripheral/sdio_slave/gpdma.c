/*******************************************************************************
 * @file  gpdma.c
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
/** @file gpdma.c
 * 
 *  @brief This file contains function definitions of transfer and receive
 *         SDIO slave data using GPDMA. 
 *
 */

#include "gpdma.h"

/* Private macro -------------------------------------------------------------*/
#define GPDMA_IRQHandler  IRQ031_Handler
#define GPDMA_LASTCHANNEL 8
#define NUMGPDMADESC      10
#define TRANSFER_SIZE     256

/* SDIO Write FIFO Data Register */
#define RX_SOURCE_ADDR 0x20200080

/* SDIO Read FIFO Data Register */
#define TX_SOURCE_ADDR 0x20200040

/* Private define ------------------------------------------------------------*/
#define M4_HOST_INTR_STATUS_REG (*(volatile uint32_t *)(M4_MISC_CONFIG_BASE + 0x04))

#define SDIO_REG_CMD                (*(volatile uint16_t *)(SDIO_BASE + 0x18))
#define SDIO_BLK_CNT                (*(volatile uint16_t *)(SDIO_BASE + 0x14))
#define SDIO_REG_RX_NUM_CHUNKS_ADDR (*(volatile uint32_t *)(SDIO_BASE + 0x242))

/* DMA descriptors must be aligned to 16 bytes */
#if defined(__CC_ARM)
/* Keil alignment to 1024 bytes */
__align(1024) RSI_GPDMA_DESC_T GPDMADesc[NUMGPDMADESC];
#endif /* defined (__CC_ARM) */

/* IAR support */
#if defined(__ICCARM__)
#pragma data_alignment = 1024
static RSI_GPDMA_DESC_T GPDMADesc[NUMGPDMADESC];
#endif /* defined (__ICCARM__) */

#if defined(__GNUC__)
RSI_GPDMA_DESC_T GPDMADesc[NUMGPDMADESC];
#endif /* defined (__GNUC__) */

/* Private variables ---------------------------------------------------------*/
static uint32_t memBuff[30];
uint32_t ret             = 0;
volatile uint8_t dmaDone = 0;
uint32_t memSize = 0, *devMem = NULL;
RSI_GPDMA_HANDLE_T GPDMAHandle;

/* Private function prototypes -----------------------------------------------*/

/* Private functions ---------------------------------------------------------*/
/**
 * @fn     void GPDMA_IRQHandler(void)
 * @brief  GPDMA Interrupt Handler
 * @param  None
 * @return None
 */
void GPDMA_IRQHandler(void)
{
  dmaDone = 1;
  RSI_GPDMA_InterruptHandler(GPDMAHandle);
}

/**
 * @fn          void GPDMATransferComplete(RSI_GPDMA_HANDLE_T GPDMAHandle, RSI_GPDMA_DESC_T *pTranDesc)
 * @brief       GPDMA controller transfer descriptor chain complete callback
 * @param[in]   GPDMAHandle : structure variable to driver context handle
 * @param[in]   pTranDesc   : Pointer to transfer descriptor
 * @return      None
 */
void GPDMATransferComplete(RSI_GPDMA_HANDLE_T GPDMAHandle, RSI_GPDMA_DESC_T *pTranDesc)
{
}

/**
 * @fn          void GPDMATransferDescComplete(RSI_GPDMA_HANDLE_T GPDMAHandle, RSI_GPDMA_DESC_T *pTranDesc)
 * @brief       GPDMA controller transfer descriptor complete callback
 * @param[in]   GPDMAHandle: structure variable to driver context handle
 * @param[in]   pTranDesc  : Pointer to transfer descriptor
 * @return      None
 */
void GPDMATransferDescComplete(RSI_GPDMA_HANDLE_T GPDMAHandle, RSI_GPDMA_DESC_T *pTranDesc)
{
}

/**
 * @fn          void GPDMATransferError(RSI_GPDMA_HANDLE_T GPDMAHandle, RSI_GPDMA_DESC_T *pTranDesc)
 * @brief       GPDMA controller transfer descriptor error callback
 * @param[in]   GPDMAHandle : structure variable to driver context handle
 * @param[in]   pTranDesc   : Pointer to transfer descriptor
 * @return      None
 */
void GPDMATransferError(RSI_GPDMA_HANDLE_T GPDMAHandle, RSI_GPDMA_DESC_T *pTranDesc)
{
}

/**
 * @fn          void GPDMATransferDescFetchComplete(RSI_GPDMA_HANDLE_T GPDMAHandle, RSI_GPDMA_DESC_T *pTranDesc)
 * @brief       DMA controller transfer descriptor error callback
 * @param[in]   GPDMAHandle: structure variable to driver context handle
 * @param[in]   pTranDesc  : Pointer to transfer descriptor
 * @return      None
 */
void GPDMATransferDescFetchComplete(RSI_GPDMA_HANDLE_T GPDMAHandle, RSI_GPDMA_DESC_T *pTranDesc)
{
}

/**
 * @fn          void Fill_RxDescriptors(uint8_t *data_buf)
 * @brief       Filled RX GPDMA descriptor
 * @param[in]   data_buf : Pointer to RX buffer 
 * @return      None
 */
void Fill_RxDescriptors(uint8_t *data_buf)
{
  uint32_t j;
  RSI_GPDMA_DESC_T *pPrevDesc;
  uint32_t no_of_desc = 0;
  RSI_GPDMA_DESC_T XferCfg;

  no_of_desc = SDIO_BLK_CNT;

  pPrevDesc = NULL;
  for (j = 0; j < no_of_desc; j++) {
    /* Channel Control Config */
    XferCfg.chnlCtrlConfig.transSize        = TRANSFER_SIZE;
    XferCfg.chnlCtrlConfig.transType        = PERIPHERAL_MEMORY;
    XferCfg.chnlCtrlConfig.dmaFlwCtrl       = DMA_FLW_CTRL;
    XferCfg.chnlCtrlConfig.mastrIfFetchSel  = MASTER0_FETCH_IFSEL;
    XferCfg.chnlCtrlConfig.mastrIfSendSel   = MASTER0_SEND_IFSEL;
    XferCfg.chnlCtrlConfig.destDataWidth    = DST_8_DATA_WIDTH;
    XferCfg.chnlCtrlConfig.srcDataWidth     = SRC_32_DATA_WIDTH;
    XferCfg.chnlCtrlConfig.srcAlign         = 0;
    XferCfg.chnlCtrlConfig.linkListOn       = 1;
    XferCfg.chnlCtrlConfig.linkListMstrSel  = LINK_MASTER_0_FTCH;
    XferCfg.chnlCtrlConfig.srcAddContiguous = 0;
    XferCfg.chnlCtrlConfig.dstAddContiguous = 0;
    XferCfg.chnlCtrlConfig.retryOnErr       = 0;
    XferCfg.chnlCtrlConfig.linkInterrupt    = 0;
    XferCfg.chnlCtrlConfig.srcFifoMode      = 1;
    XferCfg.chnlCtrlConfig.dstFifoMode      = 0;

    /* Misc Channel Config */
    XferCfg.miscChnlCtrlConfig.ahbBurstSize  = AHBBURST_SIZE_4;
    XferCfg.miscChnlCtrlConfig.destDataBurst = DST_BURST_SIZE_4;
    XferCfg.miscChnlCtrlConfig.srcDataBurst  = SRC_BURST_SIZE_4;
    XferCfg.miscChnlCtrlConfig.destChannelId = 0;
    XferCfg.miscChnlCtrlConfig.srcChannelId  = 30;
    XferCfg.miscChnlCtrlConfig.dmaProt       = 0;
    XferCfg.miscChnlCtrlConfig.memoryFillEn  = 0;
    XferCfg.miscChnlCtrlConfig.memoryOneFill = 0;

    XferCfg.dest = (data_buf + (j * TRANSFER_SIZE));
    XferCfg.src  = (uint32_t *)(RX_SOURCE_ADDR);
    if (RSI_GPDMA_BuildDescriptors(GPDMAHandle, &XferCfg, &GPDMADesc[j], pPrevDesc) != RSI_OK) {
    }
    pPrevDesc = &GPDMADesc[j];
  }
}

/**
 * @fn          void Fill_TxDescriptors(uint8_t *data_buff, uint8_t num_of_blocks)
 * @brief       Filled TX GPDMA descriptor
 * @param[in]   data_buf      : Pointer to TX buffer 
 * @param[in]   num_of_blocks : Numbers of block transmit. 
 * @return      None
 */
void Fill_TxDescriptors(uint8_t *data_buff, uint8_t num_of_blocks)
{
  uint32_t j;
  RSI_GPDMA_DESC_T *pPrevDesc;
  uint32_t no_of_desc = 0;
  RSI_GPDMA_DESC_T XferCfg;

  no_of_desc = num_of_blocks;

  pPrevDesc = NULL;
  for (j = 0; j < no_of_desc; j++) {
    /* Channel Control Config */
    XferCfg.chnlCtrlConfig.transSize        = TRANSFER_SIZE;
    XferCfg.chnlCtrlConfig.transType        = MEMORY_PERIPHERAL;
    XferCfg.chnlCtrlConfig.dmaFlwCtrl       = DMA_FLW_CTRL;
    XferCfg.chnlCtrlConfig.mastrIfFetchSel  = MASTER0_FETCH_IFSEL;
    XferCfg.chnlCtrlConfig.mastrIfSendSel   = MASTER0_SEND_IFSEL;
    XferCfg.chnlCtrlConfig.destDataWidth    = DST_32_DATA_WIDTH;
    XferCfg.chnlCtrlConfig.srcDataWidth     = SRC_8_DATA_WIDTH;
    XferCfg.chnlCtrlConfig.srcAlign         = 0;
    XferCfg.chnlCtrlConfig.linkListOn       = 1;
    XferCfg.chnlCtrlConfig.linkListMstrSel  = LINK_MASTER_0_FTCH;
    XferCfg.chnlCtrlConfig.srcAddContiguous = 0;
    XferCfg.chnlCtrlConfig.dstAddContiguous = 0;
    XferCfg.chnlCtrlConfig.retryOnErr       = 0;
    XferCfg.chnlCtrlConfig.linkInterrupt    = 1;
    XferCfg.chnlCtrlConfig.srcFifoMode      = 0;
    XferCfg.chnlCtrlConfig.dstFifoMode      = 1;

    /* Misc Channel Config */
    XferCfg.miscChnlCtrlConfig.ahbBurstSize  = AHBBURST_SIZE_8;
    XferCfg.miscChnlCtrlConfig.destDataBurst = DST_BURST_SIZE_8;
    XferCfg.miscChnlCtrlConfig.srcDataBurst  = SRC_BURST_SIZE_8;
    XferCfg.miscChnlCtrlConfig.destChannelId = 31;
    XferCfg.miscChnlCtrlConfig.srcChannelId  = 0;
    XferCfg.miscChnlCtrlConfig.dmaProt       = 0;
    XferCfg.miscChnlCtrlConfig.memoryFillEn  = 0;
    XferCfg.miscChnlCtrlConfig.memoryOneFill = 0;

    XferCfg.dest = (uint32_t *)(TX_SOURCE_ADDR);
    XferCfg.src  = (data_buff + (j * TRANSFER_SIZE));

    if (RSI_GPDMA_BuildDescriptors(GPDMAHandle, &XferCfg, &GPDMADesc[j], pPrevDesc) != RSI_OK) {
    }
    pPrevDesc = &GPDMADesc[j];
  }
}

/**
 * @fn          void Setup_RX_ChannelDesc(uint8_t *data_buf)
 * @brief       Setup GPDMA RX channel descriptor 
 * @param[in]   data_buf : Pointer to RX buffer 
 * @return      None
 */
void Setup_RX_ChannelDesc(uint8_t *data_buf)
{
  RSI_GPDMA_CHA_CFG_T chaCfg;

  chaCfg.channelPrio       = 0;
  chaCfg.descFetchDoneIntr = 0;
  chaCfg.hrespErr          = 1;
  chaCfg.gpdmacErr         = 1;
  chaCfg.xferDoneIntr      = 1;
  chaCfg.dmaCh             = 1;

  /* Setup channel 0 for trigger operation and M2M transfer */
  if (RSI_GPDMA_SetupChannel(GPDMAHandle, (RSI_GPDMA_CHA_CFG_T *)&chaCfg) != RSI_OK) {
    //DEBUGOUT("Error setting up channel\r\n");
  }
  Fill_RxDescriptors(data_buf);

  RSI_GPDMA_SetupChannelTransfer(GPDMAHandle, GPDMA_CHNL1, GPDMADesc);
}

/**
 * @fn          void Setup_TX_ChannelDesc(uint8_t *data_buf, uint8_t num_of_blocks)
 * @brief       Setup GPDMA TX channel descriptor 
 * @param[in]   data_buf      : Pointer to TX buffer 
 * @param[in]   num_of_blocks : Numbers of block transmit. 
 * @return      None
 */
void Setup_TX_ChannelDesc(uint8_t *data_buf, uint8_t num_of_blocks)
{
  RSI_GPDMA_CHA_CFG_T chaCfg;

  chaCfg.channelPrio       = 0;
  chaCfg.descFetchDoneIntr = 0;
  chaCfg.hrespErr          = 1;
  chaCfg.gpdmacErr         = 1;
  chaCfg.xferDoneIntr      = 1;
  chaCfg.dmaCh             = 1;

  /* Setup channel 0 for trigger operation and M2M transfer */
  if (RSI_GPDMA_SetupChannel(GPDMAHandle, (RSI_GPDMA_CHA_CFG_T *)&chaCfg) != RSI_OK) {
    //DEBUGOUT("Error setting up channel\r\n");
  }

  Fill_TxDescriptors(data_buf, num_of_blocks);

  RSI_GPDMA_SetupChannelTransfer(GPDMAHandle, 1, GPDMADesc);
}

/**
 * @fn          void GPDMA_TX_Trigger(uint8_t num_of_blocks, uint8_t *data_buf)
 * @brief       Trigger GPDMA TX channel 
 * @param[in]   data_buf      : Pointer to TX buffer 
 * @param[in]   num_of_blocks : Numbers of block transmit. 
 * @return      None
 */
void GPDMA_TX_Trigger(uint8_t num_of_blocks, uint8_t *data_buf)
{
  RSI_GPDMA_INIT_T GPDMAInit;
  volatile bool done;
  /*Configures the system default clock and power configurations*/

  dmaDone = false;

  /* Initialize UART for debug prints*/
  /* clear stack structures before use */
  memset(&GPDMAInit, 0, sizeof(RSI_GPDMA_INIT_T));

  /* Get needed size for driver context memory */
  memSize = RSI_GPDMA_GetMemSize();
  if (memSize > sizeof(memBuff)) {
    /*  Prints on hyper-terminal  */
    //DEBUGOUT("Can't allocate memory for driver context\r\n");
  }
  devMem = memBuff; /* Or just use malloc(memSize) */

  /* Initialize driver */
  GPDMAInit.pUserData = (void *)&done;
  GPDMAInit.baseC     = (uint32_t)GPDMA_C;
  GPDMAInit.baseG     = (uint32_t)GPDMA_G;
  GPDMAInit.sramBase  = (uint32_t)&GPDMADesc;

  /* Initialize driver context parameters*/
  GPDMAHandle = RSI_GPDMA_Init(devMem, &GPDMAInit);
  if (GPDMAHandle == NULL) {
    /*  Prints on hyper-terminal  */
    //DEBUGOUT("Error initializing GPDMA\r\n");
  }
  /* GPDMA clock enable */
  RSI_CLK_PeripheralClkEnable(M4CLK, RPDMA_CLK, ENABLE_STATIC_CLK);

  /* Enable the interrupt for the DMA controller */
  NVIC_EnableIRQ(GPDMA_IRQn);

  /* Register error, descriptor completion, and descriptor chain completion callbacks for channel 0 */
  RSI_GPDMA_RegisterCallback(GPDMAHandle, RSI_GPDMA_XFERCOMPLETE_CB, (void *)GPDMATransferComplete);
  RSI_GPDMA_RegisterCallback(GPDMAHandle, RSI_GPDMA_XFERDESCFETCHCOMPLETE_CB, (void *)GPDMATransferDescFetchComplete);
  RSI_GPDMA_RegisterCallback(GPDMAHandle, RSI_GPDMA_XFERHRESPERROR_CB, (void *)GPDMATransferError);
  RSI_GPDMA_RegisterCallback(GPDMAHandle, RSI_GPDMA_XFERGPDMACERROR_CB, (void *)GPDMATransferError);

  Setup_TX_ChannelDesc(data_buf, num_of_blocks);

  RX_NUM_CHUNKS = num_of_blocks; // to program no of blocks

  M4_HOST_INTR_STATUS_REG = BIT(3); // to raise interrupt to host

  /* Trigger channel */
  RSI_GPDMA_DMAChannelTrigger(GPDMAHandle, 1);
}

/**
 * @fn          void GPDMA_RX_Trigger(uint8_t *data_buf)
 * @brief       Trigger GPDMA RX channel 
 * @param[in]   data_buf      : Pointer to TX buffer 
 * @param[in]   num_of_blocks : Numbers of block transmit. 
 * @return      None
 */
void GPDMA_RX_Trigger(uint8_t *data_buf)
{
  uint32_t memSize, *devMem;
  RSI_GPDMA_INIT_T GPDMAInit;
  volatile bool done;
  /*Configures the system default clock and power configurations*/

  dmaDone = false;

  /* Initialize UART for debug prints*/
  /* clear stack structures before use */
  memset(&GPDMAInit, 0, sizeof(RSI_GPDMA_INIT_T));

  /* Get needed size for driver context memory */
  memSize = RSI_GPDMA_GetMemSize();
  if (memSize > sizeof(memBuff)) {
    /*  Prints on hyper-terminal  */
    //DEBUGOUT("Can't allocate memory for driver context\r\n");
  }
  devMem = memBuff; /* Or just use malloc(memSize) */

  /* Initialize driver */
  GPDMAInit.pUserData = (void *)&done;
  GPDMAInit.baseC     = (uint32_t)GPDMA_C;
  GPDMAInit.baseG     = (uint32_t)GPDMA_G;
  GPDMAInit.sramBase  = (uint32_t)&GPDMADesc;

  /* Initialize driver context parameters*/
  GPDMAHandle = RSI_GPDMA_Init(devMem, &GPDMAInit);
  if (GPDMAHandle == NULL) {
    /*  Prints on hyper-terminal  */
    //DEBUGOUT("Error initializing GPDMA\r\n");
  }
  /* GPDMA clock enable */
  RSI_CLK_PeripheralClkEnable(M4CLK, RPDMA_CLK, ENABLE_STATIC_CLK);

  /* Enable the interrupt for the DMA controller */
  NVIC_EnableIRQ(GPDMA_IRQn);

  /* Register error, descriptor completion, and descriptor chain completion callbacks for channel 0 */
  RSI_GPDMA_RegisterCallback(GPDMAHandle, RSI_GPDMA_XFERCOMPLETE_CB, (void *)GPDMATransferComplete);
  RSI_GPDMA_RegisterCallback(GPDMAHandle, RSI_GPDMA_XFERDESCFETCHCOMPLETE_CB, (void *)GPDMATransferDescFetchComplete);
  RSI_GPDMA_RegisterCallback(GPDMAHandle, RSI_GPDMA_XFERHRESPERROR_CB, (void *)GPDMATransferError);
  RSI_GPDMA_RegisterCallback(GPDMAHandle, RSI_GPDMA_XFERGPDMACERROR_CB, (void *)GPDMATransferError);

  /* Setup descriptor */
  Setup_RX_ChannelDesc(data_buf);

  /* Trigger channel */
  RSI_GPDMA_DMAChannelTrigger(GPDMAHandle, GPDMA_CHNL1);
}