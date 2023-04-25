/*******************************************************************************
 * @file  sdio_slave.c
 * @brief
 *******************************************************************************
 * # License
 * <b>Copyright 2023 Silicon Laboratories Inc. www.silabs.com</b>
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
/**===========================================================================
 * @brief : This file contains application code for SDIO transfer in slave mode
 * @section Description :
 * This example demonstrates data transfer through SDIO. The device acts as a
 * slave which interfaces with an external master.
============================================================================**/

//  ! INCLUDES

#include "UDMA.h"
#include "clock_update.h"
#include "gpdma.h"
#include "rsi_board.h"

/* Private macro -------------------------------------------------------------*/

/* Mode of Transmission */
#define TX_PATH 2 /* Transmit data to the master  */
#define RX_PATH 1 /* Receive data from the master */

/* Modify this macro to change mode of transmission for sdio slave */
#define TRANSMISSION_TYPE RX_PATH /* Default is receive mode, i.e., RX_PATH */

#define TRANSFER_LEN  256
#define NO_OF_BLOCKS  4
#define TX_BLOCK_SIZE (TRANSFER_LEN * NO_OF_BLOCKS) /* Transfer size is 256B*4 = 1KB */
#define RX_BLOCK_SIZE (TRANSFER_LEN * NO_OF_BLOCKS) /* Transfer size is 256B*4 = 1KB */

/* Global memory  ------------------------------------------------------------*/
#define SW_CORE_CLK         1
#define SDIO_MODE_SELECT    0x0705
#define MASK_HOST_INTERRUPT 0xF0

#if SW_CORE_CLK
#define ICACHE2_ADDR_TRANSLATE_1_REG  *(volatile uint32_t *)(0x20280000 + 0x24)
#define MISC_CFG_SRAM_REDUNDANCY_CTRL *(volatile uint32_t *)(0x46008000 + 0x18)
#define MISC_CONFIG_MISC_CTRL1        *(volatile uint32_t *)(0x46008000 + 0x44)
#define MISC_QUASI_SYNC_MODE          *(volatile uint32_t *)(0x46008000 + 0x84)

#define SOC_PLL_REF_FREQUENCY 40000000  /*<! PLL input REFERENCE clock 40MHZ */
#define PS4_SOC_FREQ          150000000 /*<! PLL out clock 150MHz            */

void switch_m4_frequency(void);
#endif // SW_CORE_CLK

/* Private variables ---------------------------------------------------------*/
uint8_t tx_buffer[TX_BLOCK_SIZE];
uint8_t rx_buffer[RX_BLOCK_SIZE];
volatile uint8_t flag = 0;
extern volatile uint8_t dmaDone;

/**
 * @brief  HIF1 IRQ handler.
 * @param  None
 * @retval None
 */
void HIF1_IRQHandler(void)
{
  flag = 1;
  /*Mask Interrupt*/
  SDIO_REG_INT_MSK  = INT_EN_CMD53_WR;
  SDIO_REG_INT_STAT = INT_STAT_CMD53_WR;
}

#if SW_CORE_CLK
/**
 * @brief  This API used to configure the M4 core clock
 * @param  None
 * @retval None
 */
void switch_m4_frequency(void)
{
  /*Switch M4 SOC clock to Reference clock*/
  /*Default keep M4 in reference clock*/
  RSI_CLK_M4SocClkConfig(M4CLK, M4_ULPREFCLK, 0);

  /*Configure the PLL frequency*/
  RSI_CLK_SetSocPllFreq(M4CLK, PS4_SOC_FREQ, SOC_PLL_REF_FREQUENCY);

  /*Switch M4 clock to PLL clock for speed operations*/
  RSI_CLK_M4SocClkConfig(M4CLK, M4_SOCPLLCLK, 0);
}
#endif // SW_CORE_CLK

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int main()
{
  /* At this stage the micro-controller clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_rs1xxxx.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * startup_rs1xxxx.c file
   */
  uint32_t i        = 0;
  uint32_t tt_start = 0, tt_end = 0;
  uint32_t packet_count = 0;
  uint32_t packet_size  = 0;
  uint32_t throughput   = 0;

  SystemCoreClockUpdate();

  /* Switch M4 core clock to 180Mhz */
#if SW_CORE_CLK
  switch_m4_frequency();
#endif

  SysTick_Config(SystemCoreClock / 1000);

  /* SDIO Connected to Tass */
  (*(volatile uint32_t *)(NWPAON_MEM_HOST_ACCESS_CTRL_CLEAR)) = (0x1 << 5);

  /* Host selects in SDIO mode */
  MISC_CFG_HOST_CTRL |= SDIO_MODE_SELECT;

  for (i = 0; i < 10; i++)
    ;

  /* Interrupt enable command53 wr */
  SDIO_FN1_INT_ENABLE = BIT(0);

  /* Interrupt enable command53 wr */
  SDIO_FN1_INT_UNMASK_REG = BIT(0);

  /*Enable NVIC*/
  NVIC_EnableIRQ(HIF0_IRQn);

  /* Mask the host interrupts.*/
  M4_HOST_INTR_MASK_REG = MASK_HOST_INTERRUPT;

  /* Initialized board UART */
  DEBUGINIT();
  DEBUGOUT("\r\nSDIO slave application started\r\n");

#if (TRANSMISSION_TYPE == TX_PATH)

  packet_size = TX_BLOCK_SIZE;
  /* Filled data in tx buffer */
  for (i = 0; i < TX_BLOCK_SIZE; i++) {
    tx_buffer[i] = (i / 256) + 1;
  }

  while (1) {
    tt_start = GetTickCount();

    /*Trigger TX dma*/
    GPDMA_TX_Trigger(NO_OF_BLOCKS, tx_buffer);

    /*Wait for dma done*/
    while (dmaDone == 0)
      ;
    dmaDone = 0;

    packet_count++;
    if ((GetTickCount() - tt_start) >= 10000) {
      tt_end = GetTickCount();

      DEBUGOUT("\r\nPackets sent: %d\r\n", packet_count);
      DEBUGOUT("Total bits sent:%d \r\n", (packet_count * packet_size * 8));
      DEBUGOUT("Time diff :%d ms \r\n", (tt_end - tt_start));

      throughput = (packet_count * packet_size * 8) / ((tt_end - tt_start) / 1000);
      DEBUGOUT("Throughput for slave->master= %d bps \r\n", throughput);

      packet_count = 0;
    }
  }
#elif (TRANSMISSION_TYPE == RX_PATH)

  packet_size = RX_BLOCK_SIZE;
  tt_start    = GetTickCount();

  while (1) {
    while (flag == 0)
      ;
    flag = 0;

    /*Trigger RX dma*/
    GPDMA_RX_Trigger(rx_buffer);
    packet_count++;

    /*Wait for dma done*/
    while (dmaDone == 0)
      ;
    dmaDone = 0;

    if ((GetTickCount() - tt_start) >= 10000) {

      tt_end = GetTickCount();

      DEBUGOUT("\r\nPackets received: %d\r\n", packet_count);
      DEBUGOUT("Total bits received: %d \r\n", (packet_count * packet_size * 8));
      DEBUGOUT("Time diff: %d ms\r\n", (tt_end - tt_start));

      throughput = (packet_count * packet_size * 8) / ((tt_end - tt_start) / 1000);
      DEBUGOUT("Throughput master->slave = %d bps \r\n", throughput);

      packet_count = 0;
      tt_start     = GetTickCount();
    }

    /* Interuupt enable command53 wr */
    SDIO_FN1_INT_UNMASK_REG = BIT(0);
  }
#endif
}
