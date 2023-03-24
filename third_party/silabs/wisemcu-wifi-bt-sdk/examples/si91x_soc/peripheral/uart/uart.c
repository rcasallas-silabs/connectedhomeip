/*******************************************************************************
 * @file  uart.c
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
 * @brief : This file contains example application for UART Data Transfer
 * @section Description :
 * This example shows how to use the UART loopback mode, sending and receiving data
 * in loopback mode.
=============================================================================**/

// Include Flies

#include "USART.h"
#include "rsi_board.h"

#define BUFFER_SIZE 1024

#define BAUD_VALUE 115200

extern ARM_DRIVER_USART Driver_USART0;

static ARM_DRIVER_USART *USARTdrv = &Driver_USART0;

ARM_USART_CAPABILITIES drv_capabilities;

ARM_USART_STATUS status;

uint8_t tx_buffer[BUFFER_SIZE];
uint8_t rx_buffer[BUFFER_SIZE];
volatile uint32_t read_tx_cnt = 0;
volatile uint32_t read_rx_cnt = 0;
volatile uint32_t match = 0, unmatch = 0;

void ARM_USART_SignalEvent(uint32_t event);

// read capabilities

/*==============================================*/
/**
 * @fn          void Read_Capabilities(void)
 * @brief       read capabilities
 * @param[in]   void
 * @return      None
 */
void Read_Capabilities(void)
{
  drv_capabilities = USARTdrv->GetCapabilities();
}

/*==============================================*/
/**
 * @fn          void ARM_USART_SignalEvent(uint32_t event)
 * @brief       event callback handler
 * @param[in]   event -transfer events based on the switch case
 * @return      None
 */
void ARM_USART_SignalEvent(uint32_t event)
{
  switch (event) {
    case ARM_USART_EVENT_SEND_COMPLETE:
      read_tx_cnt = USARTdrv->GetTxCount();
      break;
    case ARM_USART_EVENT_RECEIVE_COMPLETE:
      read_rx_cnt = USARTdrv->GetRxCount();
      break;
    case ARM_USART_EVENT_TRANSFER_COMPLETE:
      break;
    case ARM_USART_EVENT_TX_COMPLETE:
      break;
    case ARM_USART_EVENT_TX_UNDERFLOW:
      break;
    case ARM_USART_EVENT_RX_OVERFLOW:
      break;
    case ARM_USART_EVENT_RX_TIMEOUT:
      break;
    case ARM_USART_EVENT_RX_BREAK:
      break;
    case ARM_USART_EVENT_RX_FRAMING_ERROR:
      break;
    case ARM_USART_EVENT_RX_PARITY_ERROR:
      break;
    case ARM_USART_EVENT_CTS:
      break;
    case ARM_USART_EVENT_DSR:
      break;
    case ARM_USART_EVENT_DCD:
      break;
    case ARM_USART_EVENT_RI:
      break;
  }
}

/*==============================================*/
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
  int forever             = 1;
  volatile uint32_t i     = 0;
  volatile int32_t status = 0;
  // Configures the system default clock and power configurations
  SystemCoreClockUpdate();

  // Fill some data into input buffer
  for (i = 0; i < BUFFER_SIZE; i++) {
    tx_buffer[i] = i + 1;
  }
  // Read capabilities of UART
  Read_Capabilities();

  // Initialize UART(Enable Clock)
  status = USARTdrv->Initialize(ARM_USART_SignalEvent);

  // Initialized board UART
  DEBUGINIT();

  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n UART Initialization Failed, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n UART Initialization Success\r\n");
  }

  // Power up the UART peripheral
  status = USARTdrv->PowerControl(ARM_POWER_FULL);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Set Power to UART, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Configured Power to UART \r\n");
  }
  // Enable Receiver and Transmitter lines
  status = USARTdrv->Control(ARM_USART_CONTROL_TX, 1);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Set  Transmitter lines to UART, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Set  Transmitter lines to UART is sucess \r\n");
  }

  status = USARTdrv->Control(ARM_USART_CONTROL_RX, 1);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Set  Receiver lines to UART, Error Code : %d \r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Set  Receiver lines to UART\r\n");
  }

  // Configure the UART to 9600 Bits/sec
  status = USARTdrv->Control(ARM_USART_MODE_ASYNCHRONOUS | ARM_USART_DATA_BITS_8 | ARM_USART_PARITY_NONE
                               | ARM_USART_STOP_BITS_1 | ARM_USART_FLOW_CONTROL_NONE,
                             BAUD_VALUE);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to set  UART control Configuration , Error Code : %d \r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Successfully Configured UART control  \r\n");
  }

  // Receives data
  status = USARTdrv->Receive(rx_buffer, sizeof(rx_buffer));
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to Receive data , Error Code : %d \r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n Receives data success  \r\n");
  }

  // sends data
  status = USARTdrv->Send(tx_buffer, sizeof(tx_buffer));

  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\n Failed to send data , Error Code : %d \r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\n data send success  \r\n");
  }

  // wait for the receive complete event
  while (read_rx_cnt == 0)
    ;

  DEBUGOUT("\r\n  receive complete event  is done  \r\n");

  // compare both send receive data
  for (i = 0; i < BUFFER_SIZE; i++) {
    if (tx_buffer[i] == rx_buffer[i]) {
      match++;
    } else {
      unmatch++;
    }
  }
  if (match == BUFFER_SIZE) {
    DEBUGOUT("\r\n Data Comparision Success \r\n ");
    DEBUGOUT("\r\n Test Case Pass \r\n ");
  } else {
    DEBUGOUT("\r\n Data Comparision Fail \r\n ");
    DEBUGOUT("\r\n Test Case Fail \r\n ");
  }

  while (forever) {
  }
  // Statement will never reach here , just to satisfy the standard main
  return 0;
}
