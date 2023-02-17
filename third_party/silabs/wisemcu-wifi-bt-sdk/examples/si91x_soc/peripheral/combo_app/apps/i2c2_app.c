/*******************************************************************************
 * @file  i2c2_app.c
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


#include "i2c2_app.h"

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

/* Private variables ---------------------------------------------------------*/
static uint16_t DeviceAddr2;
static uint8_t wr_buf2[EEPROM_MAX_WRITE + 2];
static uint8_t rd_buf2[SIZE_BUFFERS];
static uint8_t buf2[SIZE_BUFFERS];

extern ARM_DRIVER_I2C Driver_I2C2;
static ARM_DRIVER_I2C *I2Cdrv = &Driver_I2C2;
extern ARM_DRIVER_I2C Driver_I2C2;


ARM_DRIVER_I2C *drv_info2;

volatile uint32_t tx_done2 = 0, rx_done2 = 0, xfer_done2 = 0, stop_det2 = 0;
uint32_t cnt_num2 = 0, I2C2_TRANSFER = 1;
I2C_RESOURCES i2c2;
ARM_I2C_CAPABILITIES drv_capabilities2;

/* Private function prototypes -----------------------------------------------*/
void ErrorHandler2(void);
void WriteDataGenerate2(void);
int32_t EEPROM_WriteBuf2(uint8_t sub_addr, const uint8_t *buf, uint32_t len);
int32_t EEPROM_ReadBuf2(uint16_t addr, uint8_t *buf, uint32_t len);
int32_t EEPROM_Initialize2(void);
uint32_t EEPROM_GetSize2(void);
void setup_i2c2(void);
void read_capabilities2(void);
void ARM_I2C_SignalEvent2(uint32_t event);

/* Private functions ---------------------------------------------------------*/

void ErrorHandler2(void)
{
  while (1)
    ;
}

/**
 * @brief	 Fills transmit buffer data
 * @return none
 */
void WriteDataGenerate2(void)
{
  uint32_t loop;

  /* Put some data in the source buffer for */
  for (loop = 0; loop < SIZE_BUFFERS; loop++) {
    buf2[loop]    = (loop + 0x1);
    rd_buf2[loop] = 0;
  }
}

/**
 * @brief	 Writes data to EEPROM slave
 * @param[in]  sub_addr EEPROM offset to write
 * @param[in]  buf  write data buffer
 * @param[in]  len  number bytes to write
 * @return write success or fail status
 */
int32_t EEPROM_WriteBuf2(uint8_t sub_addr, const uint8_t *buf, uint32_t len)
{
  uint32_t start;
  wr_buf2[0] = sub_addr;

  memcpy((void *)&wr_buf2[1], &buf[0], 16);

  I2Cdrv->MasterTransmit(DeviceAddr2, wr_buf2, len + 1, false);

  start = rsi_hal_gettickcount();

  while ((I2Cdrv->GetStatus().busy))
     {
       if(!(rsi_hal_gettickcount() - start < 100))
           return ARM_DRIVER_ERROR_TIMEOUT;
     }
  cnt_num2 = I2Cdrv->GetDataCount();
  if (cnt_num2 != (len + 1)) {
    return -1;
    /* Acknowledge polling */
  } else {
    tx_done2 = 1;
  }
  return 0;
}

/**
 * @brief	 Reads data from EEPROM slave
 * @param[in]  addr EEPROM offset to read
 * @param[in]  buf  Read data buffer
 * @param[in]  len  number bytes to read
 * @return Read success or fail status
 */
int32_t EEPROM_ReadBuf2(uint16_t addr, uint8_t *buf, uint32_t len)
{
  uint8_t a[2];

  a[0] = (uint8_t)(addr & 0xFF);

  I2Cdrv->MasterTransmit(DeviceAddr2, a, 1, false);
  while (I2Cdrv->GetStatus().busy)
    ;

  I2Cdrv->MasterReceive(DeviceAddr2, rd_buf2, len, false);
  while (I2Cdrv->GetStatus().busy)
    ;

  cnt_num2 = I2Cdrv->GetDataCount();

  if (cnt_num2 != (len)) {
    return -1;
    /* Acknowledge polling */
  } else {
    rx_done2 = 1;
  }
  return 0;
}

/**
 * @brief	     Reads data from EEPROM slave
 * @param[in]  Initializes I2C interface 
 * @return     Return zero on successful I2C interdace configuration.
 */
int32_t EEPROM_Initialize2(void)
{
  int32_t status = ARM_DRIVER_OK;

  status = I2Cdrv->Initialize(ARM_I2C_SignalEvent2);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nI2C Initialization Failed, Error Code : %d\r\n", status);
    return status;
  }

  status = I2Cdrv->PowerControl(ARM_POWER_FULL);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Set Power to I2C, Error Code : %d\r\n", status);
    return status;
  }

  status = I2Cdrv->Control(ARM_I2C_BUS_SPEED, ARM_I2C_BUS_SPEED_STANDARD);
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Set Configuration Parameters to I2C, Error Code : %d\r\n", status);
    return status;
  }
  DeviceAddr2 = EEPROM_I2C_ADDR;
  return 0;
}

/**
 * @brief	 Gets EEPROM Max size 
 * @return EEPROM size
 */
uint32_t EEPROM_GetSize2(void)
{
  return EEPROM_MAX_ADDR;
}

/**
 * @brief	 I2C driver version check
 * @return	none
 */
void setup_i2c2(void)
{
  ARM_DRIVER_VERSION version;

  drv_info2 = &Driver_I2C2;
  version  = drv_info2->GetVersion();
  if (version.api < 0x10A) {
    // error handling
    ErrorHandler2();
    return;
  }
}

/**
 * @brief	 Capabilities of I2C driver
 * @param  none   
 * @return none
 */
void read_capabilities2(void)
{
  // interrogate capabilities
  drv_info2         = &Driver_I2C2;
  drv_capabilities2 = drv_info2->GetCapabilities();
}

/**
 * @brief	 I2C event handler
 * @param  event I2C transmit and receive events
 * @return none
 */
void ARM_I2C_SignalEvent2(uint32_t event)
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

int I2C2_Init(void)
{ 

  int32_t status = ARM_DRIVER_OK;

  /* Enable SysTick Timer */
  SysTick_Config(SystemCoreClock / SYSTIC_TIMER_CONFIG);

  /* check's I2C driver version */
  setup_i2c2();

  /* Fills transmit buffer with data*/
  WriteDataGenerate2();

  /*Read capabilities of I2C driver*/
  read_capabilities2();

  /* Initialized I2C interface  */
  status = EEPROM_Initialize2();
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Configure I2C Interface, Error Code : %d\r\n", status);
    return status;
  }

  /* Gets EEPROM Max size */
  EEPROM_GetSize2();
}
/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int I2c2_Transfer(void)
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
	 * this is done through SystemInit() function which is called from startup
	 * file (startup_RS1xxxx.s) before to branch to application main.
	 * To reconfigure the default setting of SystemInit() function, refer to
	 * startup_RS1xxxx.c file
	 */
 	uint32_t forever = 1, comp = 0;
  int32_t status = ARM_DRIVER_OK;

    /* Writes data to EEPROM slave */
    status = EEPROM_WriteBuf2(OFFSET_ADDR, buf2, TX_LEN);
    if (status != ARM_DRIVER_OK) {
     DEBUGOUT("\r\nFailed to Write Data into EEPROM(I2C2 Slave), Error Code : %d\r\n", status);
      return status;
    } else {
        DEBUGOUT("\r\nWrite Data into EEPROM(I2C2 Slave)\r\n");
      }

    //5ms delay after stop to start
    rsi_delay_ms(5);

    /* Reads data from EEPROM slave */
    status = EEPROM_ReadBuf2(OFFSET_ADDR, rd_buf2, RX_LEN);
    if (status != ARM_DRIVER_OK) {
      DEBUGOUT("\r\nFailed to Read Data From EEPROM(I2C2 Slave), Error Code : %d\r\n", status);
      return status;
    } else {
        DEBUGOUT("\r\nStart Reading Data From EEPROM(I2C2 Slave)\r\n");
      }

    /*waits until rx_done=0  */
    while (!rx_done2)
      ;
    rx_done2 = 0;
    DEBUGOUT("\r\nCompleted Reading Data From EEPROM\r\n");
    for (comp = 0; comp < sizeof(rd_buf2); comp++) {
      if (buf2[comp] == rd_buf2[comp]) {
        continue;
      } else {
        break;
      }
    }

    if (comp == sizeof(rd_buf2)) {
      DEBUGOUT("\r\nI2C2 Data Comparison Success\r\n");
      I2C2_TRANSFER = 0 ;
    } else {
      DEBUGOUT("\r\nI2C2 Data Comparison Fail\r\n");
    }
}
