/*******************************************************************************
 * @file  i2c0_app.c
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

/*==================================================================================
 * @brief : This file contains example application for I2C EEPROM
 * @section Description :
 * In this example I2C will be configured in master mode. The SCL and SDA lines of
 * master controller are connected to EEPROM's SCL and SDA pins. EEPROM(AT2408C)
 * is slave device. From master the slave address is sent after START on bus and
 * waits till it gets the ACK respose from the slave. Thereafter write data to
 * EEPROM memory is based on its page write sequence to the required offset locations.
 ===================================================================================*/

/**
 * Include files
 **/
#include "i2c0_app.h"

/* Private typedef -----------------------------------------------------------*/

/* Private macro -------------------------------------------------------------*/

/* Private define ------------------------------------------------------------*/
#ifndef EEPROM_I2C_PORT
#define EEPROM_I2C_PORT 0 /* I2C Port number                    */
#endif

#define SIZE_BUFFERS    16
#define EEPROM_I2C_ADDR 0x50 /* 24LC128 EEPROM I2C address         */

#define EEPROM_MAX_ADDR  16384 /* Max memory locations available     */
#define EEPROM_MAX_WRITE 16    /* Max bytes to write in one step     */

#define A_WR                0 /* Master will write to the I2C       */
#define A_RD                1 /* Master will read from the I2C      */
#define OFFSET_ADDR         0x0
#define TX_LEN              16
#define RX_LEN              16
#define SYSTIC_TIMER_CONFIG 1000

/* General return codes */
#define ARM_DRIVER_OK                0  ///< Operation succeeded
#define ARM_DRIVER_ERROR             -1 ///< Unspecified error
#define ARM_DRIVER_ERROR_BUSY        -2 ///< Driver is busy
#define ARM_DRIVER_ERROR_TIMEOUT     -3 ///< Timeout occurred
#define ARM_DRIVER_ERROR_UNSUPPORTED -4 ///< Operation not supported
#define ARM_DRIVER_ERROR_PARAMETER   -5 ///< Parameter error
#define ARM_DRIVER_ERROR_SPECIFIC    -6 ///< Start of driver specific errors

/* Private variables ---------------------------------------------------------*/
static uint16_t DeviceAddr;
static uint8_t wr_buf[EEPROM_MAX_WRITE + 2];
uint8_t rd_buf[SIZE_BUFFERS];
static uint8_t buf[SIZE_BUFFERS];

extern ARM_DRIVER_I2C Driver_I2C0;
static ARM_DRIVER_I2C *I2Cdrv = &Driver_I2C0;
extern ARM_DRIVER_I2C Driver_I2C0;

#ifdef RSI_WITH_OS

#include "rsi_os.h"
extern rsi_semaphore_handle_t i2c_thread_sem, publish_msg_sem;
#endif

ARM_DRIVER_I2C *drv_info;

volatile uint32_t tx_done = 0, rx_done = 0, xfer_done = 0, stop_det = 0;
uint32_t cnt_num = 0, I2C0_TRANSFER = 1;
I2C_RESOURCES i2c;
ARM_I2C_CAPABILITIES drv_capabilities;

/* Private function prototypes -----------------------------------------------*/
void ErrorHandler(void);
void WriteDataGenerate(void);
int32_t EEPROM_WriteBuf(uint8_t sub_addr, const uint8_t *buf, uint32_t len);
int32_t EEPROM_ReadBuf(uint8_t addr, uint8_t *buf, uint32_t len);
int32_t EEPROM_Initialize(void);
uint32_t EEPROM_GetSize(void);
void setup_i2c(void);
void read_capabilities(void);
void ARM_I2C_SignalEvent(uint32_t event);

uint8_t Data_buff[SIZE_BUFFERS] = "AWS_LED_Toggle";

/* Private functions ---------------------------------------------------------*/
void ErrorHandler(void)
{
  while (1)
    ;
}

/**
 * @brief  Fills transmit buffer data
 * @return none
 */
void WriteDataGenerate(void)
{
  uint32_t loop;

  /* Put some data in the source buffer for */
  for (loop = 0; loop < SIZE_BUFFERS; loop++) {
    buf[loop]    = (loop + 0x1);
    rd_buf[loop] = 0;
  }
}

/**
 * @brief  Writes data to EEPROM slave
 * @param[in]  sub_addr EEPROM offset to write
 * @param[in]  buf  write data buffer
 * @param[in]  len  number bytes to write
 * @return write success or fail status
 */
int32_t EEPROM_WriteBuf(uint8_t sub_addr, const uint8_t *buf, uint32_t len)
{
  uint32_t start;
  wr_buf[0] = sub_addr;
  wr_buf[1] = sub_addr;

  memcpy((void *)&wr_buf[2], &Data_buff[0], SIZE_BUFFERS);

  I2Cdrv->MasterTransmit(DeviceAddr, wr_buf, EEPROM_MAX_WRITE + 2, false);

  start = rsi_hal_gettickcount();

  while ((I2Cdrv->GetStatus().busy)) {
    if (!(rsi_hal_gettickcount() - start < 100))
      return ARM_DRIVER_ERROR_TIMEOUT;
  }

  cnt_num = I2Cdrv->GetDataCount();
  if (cnt_num != (EEPROM_MAX_WRITE + 2)) {
    return -1;
    /* Acknowledge polling */
  } else {
    tx_done = 1;
  }
  return 0;
}

/**
 * @brief  Reads data from EEPROM slave
 * @param[in]  addr EEPROM offset to read
 * @param[in]  buf  Read data buffer
 * @param[in]  len  number bytes to read
 * @return Read success or fail status
 */
int32_t EEPROM_ReadBuf(uint8_t addr, uint8_t *buf, uint32_t len)
{
  uint8_t a[2];

  a[0] = (uint8_t)(addr & 0xFF);
  a[1] = (uint8_t)(addr & 0xFF);

  I2Cdrv->MasterTransmit(DeviceAddr, a, 2, false);
  while (I2Cdrv->GetStatus().busy)
    ;

  I2Cdrv->MasterReceive(DeviceAddr, rd_buf, len, false);
  while (I2Cdrv->GetStatus().busy)
    ;

  cnt_num = I2Cdrv->GetDataCount();

  if (cnt_num != (len)) {
    return -1;
    /* Acknowledge polling */
  } else {
    rx_done = 1;
  }
  return 0;
}

/**
 * @brief      Reads data from EEPROM slave
 * @param[in]  Initializes I2C interface 
 * @return     Return zero on successful I2C interdace configuration.
 */
int32_t EEPROM_Initialize(void)
{
  int32_t status = ARM_DRIVER_OK;

  status = I2Cdrv->Initialize(ARM_I2C_SignalEvent);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nI2C Initialization Failed, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nI2C Initialization Success\r\n");
  }

  status = I2Cdrv->PowerControl(ARM_POWER_FULL);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Set Power to I2C, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nConfigured Power to I2C\r\n");
  }

  status = I2Cdrv->Control(ARM_I2C_BUS_SPEED, ARM_I2C_BUS_SPEED_FAST);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Set Configuration Parameters to I2C, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet Configuration Parameters to I2C\r\n");
  }
  DeviceAddr = EEPROM_I2C_ADDR;
  return 0;
}

/**
 * @brief  Gets EEPROM Max size
 * @return EEPROM size
 */
uint32_t EEPROM_GetSize(void)
{
  return EEPROM_MAX_ADDR;
}

/**
 * @brief  I2C driver version check
 * @return  none
 */
void setup_i2c(void)
{
  ARM_DRIVER_VERSION version;

  drv_info = &Driver_I2C0;
  version  = drv_info->GetVersion();
  if (version.api < 0x10A) {
    // error handling
    ErrorHandler();
    return;
  }
}

/**
 * @brief  Capabilities of I2C driver
 * @param  none   
 * @return none
 */
void read_capabilities(void)
{
  // interrogate capabilities
  drv_info         = &Driver_I2C0;
  drv_capabilities = drv_info->GetCapabilities();
}

/**
 * @brief  I2C event handler
 * @param  event I2C transmit and receive events
 * @return none
 */
void ARM_I2C_SignalEvent(uint32_t event)
{
  switch (event) {
    case ARM_I2C_EVENT_TRANSFER_DONE:
      break;
    case ARM_I2C_EVENT_TRANSFER_INCOMPLETE:
      break;
    case ARM_I2C_EVENT_SLAVE_TRANSMIT:
      break;
    case ARM_I2C_EVENT_SLAVE_RECEIVE:
      break;
    case ARM_I2C_EVENT_ADDRESS_NACK:
      break;
    case ARM_I2C_EVENT_GENERAL_CALL:
      break;
    case ARM_I2C_EVENT_ARBITRATION_LOST:
      break;
    case ARM_I2C_EVENT_BUS_ERROR:
      break;
    case ARM_I2C_EVENT_BUS_CLEAR:
      break;
  }
  return;
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int I2C0_Init(void)
{
  int32_t status = ARM_DRIVER_OK;

  /* Enable SysTick Timer */
  SysTick_Config(SystemCoreClock / SYSTIC_TIMER_CONFIG);

  /* check's I2C driver version */
  setup_i2c();

  /* Fills transmit buffer with data*/
  WriteDataGenerate();

  /*Read capabilities of I2C driver*/
  read_capabilities();

  /* Initialized I2C interface  */
  status = EEPROM_Initialize();
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Configure I2C Interface, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nConfigured I2C Interface\r\n");
  }

  /* Gets EEPROM Max size */
  EEPROM_GetSize();
}

int I2c0_Transfer(void)
{
  uint32_t forever = 1, comp = 0;
  int32_t status = ARM_DRIVER_OK;
  /* Writes data to EEPROM slave */
  status = EEPROM_WriteBuf(OFFSET_ADDR, buf, TX_LEN);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Write Data into EEPROM(I2C0 Slave), Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nWrite Data into EEPROM(I2C0 Slave)\r\n");
  }

  //5ms delay after stop to start
  rsi_delay_ms(5);

  /* Reads data from EEPROM slave */
  status = EEPROM_ReadBuf(OFFSET_ADDR, rd_buf, RX_LEN);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Read Data From EEPROM(I2C0 Slave), Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nStart Reading Data From EEPROM(I2C0 Slave)\r\n");
  }

  /*waits until rx_done=0  */
  while (!rx_done)
    ;
  rx_done = 0;

  DEBUGOUT("\r\nCompleted Reading Data From EEPROM\r\n");

  for (comp = 0; comp < sizeof(rd_buf); comp++) {
    if (Data_buff[comp] == rd_buf[comp]) {
      continue;
    } else {
      break;
    }
  }

  if (comp == sizeof(rd_buf)) {
    DEBUGOUT("\r\nI2C0 Data Comparison Success\r\n");
    I2C0_TRANSFER = 0;
#ifdef RSI_WITH_OS
    rsi_semaphore_post(&publish_msg_sem);
#endif
  } else {
    DEBUGOUT("\r\nI2C0 Data Comparison Fail\r\n");
  }
}