/*******************************************************************************
 * @file  i2s_master.c
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
/**============================================================================
 * @brief : This file contains example application for I2S Master
 * @section Description :
 * In this example I2S will be configured in master mode. The TX pin is connected
 * to RX pin i.e loopback. Master transmits data on TX pin using DMA and receives
 * same data on RX pin using DMA. The data received should match with the
 * transmitted data.
 =============================================================================**/

// Include Flies

#include "rsi_chip.h"
#include "SAI.h"
#include "rsi_board.h"

#define BUFFER_SIZE 1024

#define SOC_PLL_REF_FREQUENCY 40000000 // PLL input REFERENCE clock 40MHZ

#define DATA_RESOLUTION   16      // This macro is used for Data Resolution(Frame length)
#define DATA_SIZE         32      // This macro is used for Data length(Bits)
#define SAMPLING_RATE     8000    // This macro is used for Sampling frequency(KHz)

//Note: Change this macro to required PLL frequency in hertz
#define PS4_SOC_FREQ 180000000 // PLL out clock 180MHz            

uint16_t tx_buf[BUFFER_SIZE];
uint16_t rx_buf[BUFFER_SIZE];
uint32_t tx_cnt           = 0;
uint32_t rx_cnt           = 0;
volatile uint32_t tx_done = 0, rx_done = 0;

// SAI Driver 
extern ARM_DRIVER_SAI Driver_SAI0;
static ARM_DRIVER_SAI *SAIdrv = &Driver_SAI0;
void ARM_SAI_SignalEvent(uint32_t event);
ARM_DRIVER_SAI *drv_info;
ARM_SAI_CAPABILITIES drv_capabilities;

void ARM_SAI_SignalEvent(uint32_t event);
void setup_sai(void);
void read_capabilities(void);
void BufferInit(uint16_t seed);

/*==============================================*/
/**
 * @fn        void ARM_SAI_SignalEvent(uint32_t event)
 * @brief	  SAI event handler
 * @param[in] event SAI transmit and receive events
 * @return	  none
 */
void ARM_SAI_SignalEvent(uint32_t event)
{
  if (event & ARM_SAI_EVENT_SEND_COMPLETE) {
    tx_done = 1;
  }
  if (event & ARM_SAI_EVENT_RECEIVE_COMPLETE) {
    rx_done = 1;
  }
  if (event & ARM_SAI_EVENT_TX_UNDERFLOW) {
  }
  if (event & ARM_SAI_EVENT_RX_OVERFLOW) {
  }
  if (event & ARM_SAI_EVENT_FRAME_ERROR) {
  }
}

/*==============================================*/
/**
 * @fn       void setup_sai(void)
 * @brief	 SAI driver version check
 * @return	 none
 */
void setup_sai(void)
{
  ARM_DRIVER_VERSION version;

  drv_info = &Driver_SAI0;
  version  = drv_info->GetVersion();
  if (version.api < 0x10A) {
    // error handling
    return;
  }
}

/*==============================================*/
/**
 * @fn         void read_capabilities(void)
 * @brief	   Capabilities of SAI driver
 * @param[in]  void 
 * @return     none
 */
void read_capabilities(void)
{
  drv_info         = &Driver_SAI0;
  drv_capabilities = drv_info->GetCapabilities();
  // interrogate capabilities
}

/*==============================================*/
/**
 * @fn        void BufferInit(uint16_t seed)
 * @brief	  Fills transmit buffer data
 * @param[in] seed  Inital value of a transmit buffer
 * @return    none
 */
void BufferInit(uint16_t seed)
{
  uint32_t loop;

  for (loop = 0; loop < BUFFER_SIZE; loop++) {
    // Clear RX buffers, so we know something was received 
    rx_buf[loop] = 0;

    // Seed data for master transmit buffers 
    tx_buf[loop] = seed;

    seed++;
  }
  return;
}

/*==============================================*/
/**
 * @fn         int main()
 * @brief      Main Application Function
 * @param[in]  None
 * @return     None
 */
int main()
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
	 * this is done through SystemInit() function which is called from startup
	 * file (startup_RS1xxxx.s) before to branch to application main.
	 * To reconfigure the default setting of SystemInit() function, refer to
	 * system_RS1xxxx.c file
	 */
  volatile uint32_t status;
  volatile uint32_t ret = 0;

  //Configures the system default clock and power configurations
  SystemCoreClockUpdate();

  // Initialized board UART 
  DEBUGINIT();

  // Fills the transmit buffer with data 
  BufferInit(1);

  // checks the SAI driver version  
  setup_sai();

  // Read capabilities of SAI driver
  read_capabilities();

  // Switch M4 SOC clock to Reference clock
  // Default keep M4 in reference clock
  status = RSI_CLK_M4SocClkConfig(M4CLK, M4_ULPREFCLK, 0);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Set M4 Clock as ULP Reference Clock,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet M4 Clock as ULP Reference Clock\r\n");
  }

  // Configure the PLL frequency
  status = RSI_CLK_SetSocPllFreq(M4CLK, PS4_SOC_FREQ, SOC_PLL_REF_FREQUENCY);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to configure SOC PLL Clock to 180Mhz,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nConfigured SOC PLL Clock to 180Mhz\r\n");
  }

  // Switch M4 clock to PLL clock for speed operations 
  status = RSI_CLK_M4SocClkConfig(M4CLK, M4_SOCPLLCLK, 0);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Set M4 Clock as SOC PLL clock,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet M4 Clock as SOC PLL clock\r\n");
  }

  status = ROMAPI_M4SS_CLK_API->clk_qspi_clk_config(M4CLK, QSPI_SOCPLLCLK, 0, 0, 0);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Set QSPI Clock as SOC PLL clock,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet QSPI Clock as SOC PLL clock\r\n");
  }

  // Initializes SAI interface 
  status = SAIdrv->Initialize(ARM_SAI_SignalEvent);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nSAI Initialization Failed, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSAI Initialization Success\r\n");
  }

  // Control the power modes of the SAI interface. 
  status = SAIdrv->PowerControl(ARM_POWER_FULL);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Set Power to SAI, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nConfigured Power to SAI\r\n");
  }

  // configure Transmitter to Asynchronous Master: I2S Protocol, 16-bit data, 8kHz Audio frequency 
  status = SAIdrv->Control(
    ARM_SAI_CONFIGURE_TX | ARM_SAI_MODE_MASTER | ARM_SAI_ASYNCHRONOUS | ARM_SAI_PROTOCOL_I2S | ARM_SAI_DATA_SIZE(DATA_SIZE),
    DATA_RESOLUTION,SAMPLING_RATE);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Set Configuration Parameters to SAI TX, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet Configuration Parameters to SAI TX\r\n");
  }

  // configure Receiver to Asynchronous Master: I2S Protocol, 16-bit data, 8kHz Audio frequency 
  status = SAIdrv->Control(
    ARM_SAI_CONFIGURE_RX | ARM_SAI_MODE_MASTER | ARM_SAI_ASYNCHRONOUS | ARM_SAI_PROTOCOL_I2S | ARM_SAI_DATA_SIZE(DATA_SIZE),
    DATA_RESOLUTION,SAMPLING_RATE);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Set Configuration Parameters to SAI RX, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet Configuration Parameters to SAI RX\r\n");
  }

  // enable Transmitter 
  status = SAIdrv->Control(ARM_SAI_CONTROL_TX, 1, 0);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Set Configuration Parameters to SAI, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet Configuration Parameters to SAI\r\n");
  }

  // enable Receiver 
  status = SAIdrv->Control(ARM_SAI_CONTROL_RX, 1, 0);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Set Configuration Parameters to SAI, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet Configuration Parameters to SAI\r\n");
  }

  // Start receiving data from SAI receiver 
  status = SAIdrv->Receive(rx_buf, BUFFER_SIZE);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Receiving data from SAI Slave, Error Code : %d\r\n", status);
    return status;
  }

  //  Sends data to the SAI transmitter. 
  status = SAIdrv->Send(tx_buf, BUFFER_SIZE);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Send Data to SAI Slave, Error Code : %d\r\n", status);
    return status;
  }

  // wait until tx_done=0  
  while (!tx_done)
    ;

  // Get transmitted data count. 
  tx_cnt = SAIdrv->GetTxCount();
  if (tx_cnt != (BUFFER_SIZE)) {
    while (1)
      ;
  }

  DEBUGOUT("\r\nCompleted Sending Data to SAI Slave\r\n");

  // wait until rx_done=0  
  while (!rx_done)
    ;
  // Get received data count. 
  rx_cnt = SAIdrv->GetRxCount();
  if (rx_cnt != (BUFFER_SIZE)) {
    while (1)
      ;
  }

  DEBUGOUT("\r\nCompleted Receiving Data from SAI Slave\r\n");

  for (ret = 0; ret < BUFFER_SIZE; ret++) {
    if (tx_buf[ret] == rx_buf[ret]) {
      continue;
    } else {
      break;
    }
  }
  if (ret == BUFFER_SIZE) {
    DEBUGOUT("\r\nData Comparison Success\r\n");
    DEBUGOUT("\r\nTest Case Pass\r\n");
  } else {
    DEBUGOUT("\r\nData Comparison Fail\r\n ");
    DEBUGOUT("\r\nTest Case Fail\r\n");
  }

  while (1)
    ;
}

