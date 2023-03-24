/*******************************************************************************
 * @file  i2c_app.c
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
#include "i2c0_app.h"
#include "i2c1_app.h"
#include "i2c2_app.h"
#ifdef RSI_WITH_OS
#include "rsi_os.h"
extern rsi_semaphore_handle_t i2c_thread_sem;
#endif
extern uint8_t I2C0_TRANSFER, I2C1_TRANSFER, I2C2_TRANSFER;
void I2C_Init(void)
{
  int32_t status = RSI_OK;

  /*I2C Initialization */
  I2C0_Init();
  I2C1_Init();
  I2C2_Init();
}

int I2C_Transfer(void)
{
  int32_t status = RSI_OK;

#ifdef RSI_WITH_OS
  while (1) {
    rsi_semaphore_wait(&i2c_thread_sem, 0);
#endif
    status = I2c0_Transfer();
    if (I2C0_TRANSFER != RSI_OK) {
      DEBUGOUT("\nI2C0 transfer fail\n");
    } else {
      DEBUGOUT("\nI2C0 transfer success\n");
      I2C0_TRANSFER = 1;
    }
    status = I2c1_Transfer();
    if (I2C1_TRANSFER != RSI_OK) {
      DEBUGOUT("\nI2C1 transfer fail\n");
    } else {
      DEBUGOUT("\nI2C1 transfer success\n");
      I2C1_TRANSFER = 1;
    }
    status = I2c2_Transfer();
    if (I2C2_TRANSFER != RSI_OK) {
      DEBUGOUT("\nI2C2 transfer fail\n");
    } else {
      DEBUGOUT("\nI2C2 transfer success\n");
      I2C2_TRANSFER = 1;
    }
#ifdef RSI_WITH_OS
  }
#endif
  return status;
}
