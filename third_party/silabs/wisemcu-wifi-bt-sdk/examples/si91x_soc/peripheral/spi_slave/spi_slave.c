/*******************************************************************************
 * @file  spi_slave.c
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
/**===========================================================================
 * @brief : This file contains example application for CMSIS SPI Data Transfer
 * @section Description :
 * This example demonstrates data transfer through SPI. Master transmits data on
 * MOSI pin and receives the same data on MISO pin. Data received should match with
 * the transmitted data.
============================================================================**/

// Include Flies

#include "SPI.h"
#include "rsi_ccp_common.h"
#include "rsi_board.h"
#include "rsi_rom_clks.h"

#define BUFFER_SIZE             1024     // Number of data to be sent through SPI
#define SPI_BAUD                10000000 // speed at which data transmitted through SPI; Max is 40000000
#define SPI_BIT_WIDTH           8        // SPI bit width can be 16/8 for 16/8 bit data transfer
#define INTF_PLL_CLK            180000000
#define INTF_PLL_REF_CLK        40000000
#define SOC_PLL_CLK             20000000
#define SOC_PLL_REF_CLK         40000000
#define INTF_PLL_500_CTRL_VALUE 0xD900
#define SOC_PLL_MM_COUNT_LIMIT  0xA4

uint8_t testdata_out[BUFFER_SIZE];
uint8_t testdata_in[BUFFER_SIZE];

/* Private variable */
volatile uint8_t spi_slave_tx_done = 0;

/* SPI Driver */
extern ARM_DRIVER_SPI Driver_SSI_SLAVE;
extern int32_t status = 0;

/*==============================================*/
/**
 * @fn       void mySPI_callback(uint32_t event)
 * @brief	 SPI callback handler
 * @param[in]event SPI transmit and receive events
 * @return   None
 */
void mySPI_callback_slave(uint32_t event)
{
  switch (event) {
    case ARM_SPI_EVENT_TRANSFER_COMPLETE:
      spi_slave_tx_done = 1;
      break;
    case ARM_SPI_EVENT_DATA_LOST:
      /*  Occurs in slave mode when data is requested/sent by master
            but send/receive/transfer operation has not been started
            and indicates that data is lost. Occurs also in master mode
            when driver cannot transfer data fast enough. */
      DEBUGOUT("\r\n ARM_SPI_EVENT_DATA_LOST \r\n");
      break;
    case ARM_SPI_EVENT_MODE_FAULT:
      /*  Occurs in master mode when Slave Select is deactivated and
            indicates Master Mode Fault. */
      DEBUGOUT("\r\n ARM_SPI_EVENT_MODE_FAULT \r\n");
      break;
  }
}

/**
 * @fn         int main(void)
 * @brief      Main Application Function
 * @return     None
 */
int main(void)
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_RS1xxxx.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * system_RS1xxxx.c file
   */
  volatile uint16_t i = 0;
  //volatile int32_t status = 0;
  ARM_DRIVER_SPI *SPIdrv_slave = &Driver_SSI_SLAVE;

  //Configures the system default clock and power configurations
  SystemCoreClockUpdate();

  // Initialized board UART
  DEBUGINIT();

  // Filled data into input buffer
  for (i = 0; i < BUFFER_SIZE; i++) {
    testdata_out[i] = i + 1;
  }

  // program intf pll to 180Mhz
  SPI_MEM_MAP_PLL(INTF_PLL_500_CTRL_REG9) = INTF_PLL_500_CTRL_VALUE;
  status                                  = RSI_CLK_SetIntfPllFreq(M4CLK, INTF_PLL_CLK, INTF_PLL_REF_CLK);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to Configure Interface PLL Clock, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Configured Interface PLL Clock to 180Mhz\r\n");
  }

  // Configure m4 soc to 180Mhz
  status = RSI_CLK_M4SocClkConfig(M4CLK, M4_INTFPLLCLK, 0);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to Set M4 Clock as Interface PLL clock,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Set M4 Clock as Interface PLL clock\r\n");
  }

  // Configure socpll to 20Mhz
  RSI_CLK_SocPllLockConfig(1, 1, SOC_PLL_MM_COUNT_LIMIT);
  status = RSI_CLK_SetSocPllFreq(M4CLK, SOC_PLL_CLK, SOC_PLL_REF_CLK);
  if (status != RSI_OK) {
    DEBUGOUT("\r\n Failed to Configure SOC PLL Clock to 20Mhz,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Configured SOC PLL Clock to 20Mhz\r\n");
  }
  status = ROMAPI_M4SS_CLK_API->clk_qspi_clk_config(M4CLK, QSPI_INTFPLLCLK, 0, 0, 0);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Set QSPI Clock as SOC PLL clock,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet QSPI Clock as SOC PLL clock\r\n");
  }
  // Initialize the SPI driver
  status = SPIdrv_slave->Initialize(mySPI_callback_slave);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n SPI Initialization Failed, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n SPI Initialization Success\r\n");
  }

  // Power up the SPI peripheral
  status = SPIdrv_slave->PowerControl(ARM_POWER_FULL);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Set Power to SPI, Error Code : %d\r\n", status);
    return status;
  } else {
    // DEBUGOUT("\r\n Configured Power to SPI \r\n");
  }

  // Configure the SPI to Master, 16-bit mode @10000 kBits/sec
  status = SPIdrv_slave->Control(
    ARM_SPI_MODE_SLAVE | ARM_SPI_CPOL1_CPHA1 | ARM_SPI_SS_SLAVE_HW | ARM_SPI_DATA_BITS(SPI_BIT_WIDTH),
    SPI_BAUD);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Set Configuration Parameters to SPI, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Set Configuration Parameters to SPI\r\n");
  }

  // Trigger the SPI data transfer
  status = SPIdrv_slave->Transfer(testdata_out, testdata_in, sizeof(testdata_out));
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n SPI Receive Failed, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n SPI Receive Start \r\n");
  }

  /* Waits until spi_slave_tx_done=0 */
  while (!spi_slave_tx_done)
    ;
  spi_slave_tx_done = 0;
  DEBUGOUT("\r\n SPI Transfer Completed\r\n");

  for (i = 0; i < BUFFER_SIZE; i++) {
    if (testdata_out[i] == testdata_in[i]) {
      continue;
    } else {
      break;
    }
  }

  if (i == BUFFER_SIZE) {
    DEBUGOUT("\r\n Data Comparison Success \r\n");
    DEBUGOUT("\r\n Test Case Pass \r\n");
  } else {
    DEBUGOUT("\r\n Data Comparison Fail \r\n");
    DEBUGOUT("\r\n Test Case Fail \r\n");
  }

  while (1)
    ;
}
