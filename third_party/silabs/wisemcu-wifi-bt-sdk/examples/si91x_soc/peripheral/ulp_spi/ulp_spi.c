/*******************************************************************************
 * @file  ULP_SPI.c
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

#define RESERVED_IRQ_COUNT   16
#define EXT_IRQ_COUNT        98
#define VECTOR_TABLE_ENTRIES (RESERVED_IRQ_COUNT + EXT_IRQ_COUNT)
uint32_t ramVector[VECTOR_TABLE_ENTRIES] __attribute__((aligned(256)));

#define ULP_BANK_OFFSET   0x800
#define TX_BUF_MEMORY_LOC (ULP_SRAM_START_ADDR + (1 * ULP_BANK_OFFSET))
#define RX_BUF_MEMORY_LOC (ULP_SRAM_START_ADDR + (2 * ULP_BANK_OFFSET))

#define BUFFER_SIZE             96       // Number of data to be sent through SPI
#define SPI_BAUD                10000000 // speed at which data transmitted through SPI
#define SPI_BIT_WIDTH           8        // SPI bit width can be 16/8 for 16/8 bit data transfer
#define INTF_PLL_CLK            180000000
#define INTF_PLL_REF_CLK        40000000
#define SOC_PLL_CLK             20000000
#define SOC_PLL_REF_CLK         40000000
#define INTF_PLL_500_CTRL_VALUE 0xD900
#define SOC_PLL_MM_COUNT_LIMIT  0xA4

void hardware_setup(void);

uint8_t testdata_out[BUFFER_SIZE];
uint8_t testdata_in[BUFFER_SIZE];

volatile uint8_t spi_done = 0;

extern ARM_DRIVER_SPI Driver_SSI_ULP_MASTER;
extern int32_t status = 0;

/*==============================================*/
/**
 * @fn       void mySPI_callback(uint32_t event)
 * @brief	 SPI callback handler
 * @param[in]event SPI transmit and receive events
 * @return   None
 */
void mySPI_callback(uint32_t event)
{
  switch (event) {
    case ARM_SPI_EVENT_TRANSFER_COMPLETE:
      spi_done = 1;
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
  volatile uint16_t i            = 0;
  volatile uint16_t transfer_len = 0;
  ARM_DRIVER_SPI *SPIdrv         = &Driver_SSI_ULP_MASTER;

  //copying the vector table from flash to ram
  memcpy(ramVector, (uint32_t *)SCB->VTOR, sizeof(uint32_t) * VECTOR_TABLE_ENTRIES);

  //assing the ram vector adress to VTOR register
  SCB->VTOR = (uint32_t)ramVector;

  //Configures the system default clock and power configurations
  SystemCoreClockUpdate();

  //Switching MCU from PS4 to PS2 state
  hardware_setup();

  // Initialized board UART
  DEBUGINIT();

  // Filled data into input buffer
  for (i = 0; i < BUFFER_SIZE; i++) {
    testdata_out[i] = i + 1;
  }
  //copying the data into ulp_memory location
  memcpy((uint8_t *)TX_BUF_MEMORY_LOC, testdata_out, BUFFER_SIZE);

  // UNInitialize the SPI driver
  status = SPIdrv->Uninitialize();
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n SPI UNInitialization Failed, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n SPI UNInitialization Success\r\n");
  }

  // Initialize the SPI driver
  status = SPIdrv->Initialize(mySPI_callback);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n SPI Initialization Failed, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n SPI Initialization Success\r\n");
  }

  // Power up the SPI peripheral
  status = SPIdrv->PowerControl(ARM_POWER_FULL);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Set Power to SPI, Error Code : %d\r\n", status);
    return status;
  } else {
    // DEBUGOUT("\r\n Configured Power to SPI \r\n");
  }

  // Configure the SPI to Master, 16-bit mode @10000 kBits/sec
  status = SPIdrv->Control(
    ARM_SPI_MODE_MASTER | ARM_SPI_CPOL1_CPHA1 | ARM_SPI_SS_MASTER_HW_OUTPUT | ARM_SPI_DATA_BITS(SPI_BIT_WIDTH),
    SPI_BAUD);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Set Configuration Parameters to SPI, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Set Configuration Parameters to SPI\r\n");
  }

  if (SPI_BIT_WIDTH == 16)
    transfer_len = (sizeof(testdata_in) / sizeof(uint16_t));
  else
    transfer_len = sizeof(testdata_in);

  // SS line = ACTIVE = LOW
  status = SPIdrv->Control(ARM_SPI_CONTROL_SS, ARM_SPI_SS_ACTIVE);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Active Slave Select Line for SPI Transfer, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Activated Slave Select Line for SPI Transfer\r\n");
  }

  // Trigger the SPI data transfer
  status = SPIdrv->Transfer((uint8_t *)TX_BUF_MEMORY_LOC, (uint8_t *)RX_BUF_MEMORY_LOC, transfer_len);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n SPI Transfer Failed, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n SPI Transfer Start \r\n");
  }

  // Waits until spi_done=0
  while (!spi_done)
    ;
  spi_done = 0;

  DEBUGOUT("\r\n SPI Transfer Completed\r\n");

  memcpy(testdata_in, (uint8_t *)RX_BUF_MEMORY_LOC, BUFFER_SIZE);

  // SS line = ACTIVE = LOW
  status = SPIdrv->Control(ARM_SPI_CONTROL_SS, ARM_SPI_SS_INACTIVE);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Inactive Slave Select Line After SPI Transfer, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Inactivated Slave Select Line After SPI Transfer\r\n");
  }

  for (i = 0; i < BUFFER_SIZE; i++) {
    if (testdata_out[i] == testdata_in[i]) {
      continue;
    } else {
      break;
    }
  }

  if (i == BUFFER_SIZE) {
    DEBUGOUT("\r\n Test Case Pass \r\n");
  } else {
    DEBUGOUT("\r\n Data Comparison Fail \r\n");
    DEBUGOUT("\r\n Test Case Fail \r\n");
  }

  while (1)
    ;
}
