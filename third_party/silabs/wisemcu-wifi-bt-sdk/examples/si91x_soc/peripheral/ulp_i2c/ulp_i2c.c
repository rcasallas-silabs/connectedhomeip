/*******************************************************************************
 * @file  ulp_i2c.c
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
 ***************************************************************************** 
/**============================================================================
 * @brief : This file contains example application for I2C EEPROM
 * @section Description :
 * In this example I2C will be configured in master mode. The SCL and SDA lines of
 * master controller are connected to EEPROM's SCL and SDA pins. EEPROM(AT2408C)
 * is slave device. From master the slave address is sent after START on bus and
 * waits till it gets the ACK respose from the slave. Thereafter write data to
 * EEPROM memory is based on its page write sequence to the required offset locations.
 =============================================================================**/

// Include Files

#include "I2C.h"
#include "clock_update.h"
#include "rsi_board.h"

#define RESERVED_IRQ_COUNT    16
#define EXT_IRQ_COUNT         98
#define VECTOR_TABLE_ENTRIES (RESERVED_IRQ_COUNT + EXT_IRQ_COUNT)
uint32_t ramVector[VECTOR_TABLE_ENTRIES] __attribute__ ((aligned(256)));


#ifndef EEPROM_I2C_PORT
#define EEPROM_I2C_PORT     0     // I2C Port number                     
#endif

/* General return codes */
#define ARM_DRIVER_OK                 0 ///< Operation succeeded
#define ARM_DRIVER_ERROR             -1 ///< Unspecified error
#define ARM_DRIVER_ERROR_BUSY        -2 ///< Driver is busy
#define ARM_DRIVER_ERROR_TIMEOUT     -3 ///< Timeout occurred
#define ARM_DRIVER_ERROR_UNSUPPORTED -4 ///< Operation not supported
#define ARM_DRIVER_ERROR_PARAMETER   -5 ///< Parameter error
#define ARM_DRIVER_ERROR_SPECIFIC    -6 ///< Start of driver specific errors

#define SIZE_BUFFERS        16
#define EEPROM_I2C_ADDR     0x50  // 24LC128 EEPROM I2C address          

#define EEPROM_MAX_ADDR     16384 // Max memory locations available      
#define EEPROM_MAX_WRITE    16    // Max bytes to write in one step      

#define A_WR                0     // Master will write to the I2C        
#define A_RD                1     // Master will read from the I2C       
#define OFFSET_ADDR         0x0
#define TX_LEN              16
#define RX_LEN              16
#define SYSTIC_TIMER_CONFIG 1000

static uint16_t DeviceAddr;
static uint8_t wr_buf[EEPROM_MAX_WRITE + 2];
static uint8_t rd_buf[SIZE_BUFFERS];
static uint8_t buf[SIZE_BUFFERS];

extern ARM_DRIVER_I2C Driver_I2C2;
static ARM_DRIVER_I2C *I2Cdrv = &Driver_I2C2;
extern ARM_DRIVER_I2C Driver_I2C2;
ARM_DRIVER_I2C *drv_info;
volatile uint32_t tx_done = 0, rx_done = 0, xfer_done = 0, stop_det = 0;
uint32_t cnt_num = 0;
I2C_RESOURCES i2c;
ARM_I2C_CAPABILITIES drv_capabilities;

void ErrorHandler(void);
void WriteDataGenerate(void);
int32_t EEPROM_WriteBuf(uint8_t sub_addr, const uint8_t *buf, uint32_t len);
int32_t EEPROM_ReadBuf(uint16_t addr, uint8_t *buf, uint32_t len);
int32_t EEPROM_Initialize(void);
uint32_t EEPROM_GetSize(void);
void setup_i2c(void);
void read_capabilities(void);
void ARM_I2C_SignalEvent(uint32_t event);

void hardware_setup(void);

void ErrorHandler(void)
{
  while (1)
    ;
}

/*==============================================*/
/**
 * @fn     void WriteDataGenerate(void) 
 * @brief  Fills transmit buffer data
 * @return None
 */
void WriteDataGenerate(void)
{
  uint32_t loop;

  // Put some data in the source buffer for  
  for (loop = 0; loop < SIZE_BUFFERS; loop++) {
    buf[loop]    = (loop + 0x1);
    rd_buf[loop] = 0;
  }
}

/*==============================================*/
/**
 * @fn         int32_t EEPROM_WriteBuf(uint8_t sub_addr, const uint8_t *buf, uint32_t len)
 * @brief	   Writes data to EEPROM slave
 * @param[in]  sub_addr EEPROM offset to write
 * @param[in]  buf  write data buffer
 * @param[in]  len  number bytes to write
 * @return     Zero - If success
 *             Non zero - If fails
 */
int32_t EEPROM_WriteBuf(uint8_t sub_addr, const uint8_t *buf, uint32_t len)
{
  wr_buf[0] = sub_addr;

  memcpy((void *)&wr_buf[1], &buf[0], 16);

  I2Cdrv->MasterTransmit(DeviceAddr, wr_buf, len + 1, false);
  while (I2Cdrv->GetStatus().busy)
    ;

  cnt_num = I2Cdrv->GetDataCount();
  if (cnt_num != (len + 1)) {
    return -1;
    // Acknowledge polling  
  } else {
    tx_done = 1;
  }
  return 0;
}

/*==============================================*/
/**
 * @fn         int32_t EEPROM_ReadBuf(uint16_t addr, uint8_t *buf, uint32_t len)
 * @brief	   Reads data from EEPROM slave
 * @param[in]  addr EEPROM offset to read
 * @param[in]  buf  Read data buffer
 * @param[in]  len  number bytes to read
 * @return     Zero - If success
 *             Non zero - If fails
 */
int32_t EEPROM_ReadBuf(uint16_t addr, uint8_t *buf, uint32_t len)
{
  uint8_t a[2];

  a[0] = (uint8_t)(addr & 0xFF);

  I2Cdrv->MasterTransmit(DeviceAddr, a, 1, false);
  while (I2Cdrv->GetStatus().busy)
    ;

  I2Cdrv->MasterReceive(DeviceAddr, rd_buf, len, false);
  while (I2Cdrv->GetStatus().busy)
    ;

  cnt_num = I2Cdrv->GetDataCount();

  if (cnt_num != (len)) {
    return -1;
    // Acknowledge polling  
  } else {
    rx_done = 1;
  }
  return 0;
}

/*==============================================*/
/**
 * @fn         int32_t EEPROM_Initialize(void)
 * @brief	   Reads data from EEPROM slave
 * @param[in]  Initializes I2C interface
 * @return     Zero - If successful I2C interdace configuration.
 *             Non zero - If fails
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

/*==============================================*/
/**
 * @fn      uint32_t EEPROM_GetSize(void)
 * @brief	Gets EEPROM Max size
 * @return  EEPROM size
 */
uint32_t EEPROM_GetSize(void)
{
  return EEPROM_MAX_ADDR;
}

/*==============================================*/
/**
 * @fn       void setup_i2c(void)
 * @brief	 I2C driver version check
 * @return	 None
 */
void setup_i2c(void)
{
  ARM_DRIVER_VERSION version;

  drv_info = &Driver_I2C2;
  version  = drv_info->GetVersion();
  if (version.api < 0x10A) {
    // error handling
    ErrorHandler();
    return;
  }
}

/*==============================================*/
/**
 * @fn      void read_capabilities(void)
 * @brief	Capabilities of I2C driver
 * @return  None 
 */
void read_capabilities(void)
{
  // interrogate capabilities
  drv_info         = &Driver_I2C2;
  drv_capabilities = drv_info->GetCapabilities();
}

/*==============================================*/
/**
 * @fn     void ARM_I2C_SignalEvent(uint32_t event)
 * @brief  I2C event handler
 * @param  event I2C transmit and receive events
 * @return None
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

/*==============================================*/
/**
 * @fn     int main(void)
 * @brief  Main Application Function
 * @return None
 */
int main(void)
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_RS1xxxx.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * startup_RS1xxxx.c file
   */
  uint32_t forever = 1, comp = 0;

  int32_t status = ARM_DRIVER_OK;

 //copying the vector table from flash to ram
  memcpy(ramVector, (uint32_t*)SCB->VTOR, sizeof(uint32_t) * VECTOR_TABLE_ENTRIES);

//assing the ram vector adress to VTOR register
  SCB->VTOR = (uint32_t)ramVector;

  //Configures the system default clock and power configurations 
  SystemCoreClockUpdate();

  //Switching MCU from PS4 to PS2 state
  hardware_setup();

  //Initialized board UART 
  DEBUGINIT();

  // Enable SysTick Timer  
  SysTick_Config(SystemCoreClock / SYSTIC_TIMER_CONFIG);

  // check's I2C driver version  
  setup_i2c();

  // Fills transmit buffer with data 
  WriteDataGenerate();

  //Read capabilities of I2C driver 
  read_capabilities();

  // Initialized I2C interface   
  status = EEPROM_Initialize();
  if (status != ARM_DRIVER_OK) {
    DEBUGOUT("\r\nFailed to Configure I2C Interface, Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nConfigured I2C Interface\r\n");
  }

  // Gets EEPROM Max size  
  EEPROM_GetSize();


    // Writes data to EEPROM slave  
    status = EEPROM_WriteBuf(OFFSET_ADDR, buf, TX_LEN);
    if (status != ARM_DRIVER_OK) {
      DEBUGOUT("\r\nFailed to Write Data into EEPROM(I2C Slave), Error Code : %d\r\n", status);
      return status;
    } else {
      DEBUGOUT("\r\nWrite Data into EEPROM(I2C Slave)\r\n");
    }

    //5ms delay after stop to start
    rsi_delay_ms(5);

    // Reads data from EEPROM slave  
    status = EEPROM_ReadBuf(OFFSET_ADDR, rd_buf, RX_LEN);
    if (status != ARM_DRIVER_OK) {
      DEBUGOUT("\r\nFailed to Read Data From EEPROM(I2C Slave), Error Code : %d\r\n", status);
      return status;
    } else {
      DEBUGOUT("\r\nStart Reading Data From EEPROM(I2C Slave)\r\n");
    }

    //waits until rx_done=0   
    while (!rx_done)
      ;
    rx_done = 0;

    DEBUGOUT("\r\nCompleted Reading Data From EEPROM\r\n");

    for (comp = 0; comp < sizeof(rd_buf); comp++) {
      if (buf[comp] == rd_buf[comp]) {
        continue;
      } else {
        break;
      }
    }

    if (comp == sizeof(rd_buf)) {
      DEBUGOUT("\r\nData Comparison Success\r\n");
      DEBUGOUT("\r\nTest Case Pass\r\n");
    } else {
      DEBUGOUT("\r\nData Comparison Fail\r\n");
      DEBUGOUT("\r\nTest Case Fail\r\n");
    }
    while (forever) {
        ;
    }
}

