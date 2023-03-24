/*******************************************************************************
 * @file  combo_app.c
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
/*************************************************************************
 *
 */
#include "rsi_ccp_user_config.h"
#include "rsi_chip.h"
#include "rsi_board.h"
#include "i2c_app.h"
#include "push_button_app.h"
#include "pwm_app.h"
#include "pin_interrupt.h"
#include "app_config.h"
#ifdef RSI_WITH_OS
#include "rsi_os.h"
#endif

//! include file to refer data types
#include "rsi_data_types.h"

//! COMMON include file to refer wlan APIs
#include "rsi_common_apis.h"

//! WLAN include file to refer wlan APIs
#include "rsi_wlan_apis.h"
#include "rsi_wlan_non_rom.h"

//! socket include file to refer socket APIs
#include "rsi_socket.h"

//! Error include files
#include "rsi_error.h"

#include "rsi_bootup_config.h"

#include "string.h"

#include "rsi_driver.h"

#define GLOBAL_BUFF_LEN 15000

uint8_t global_buf[GLOBAL_BUFF_LEN];

#ifdef RSI_WITH_OS
#define I2C_TASK_STACK_SIZE  1024
#define I2C_TASK_PRIORITY    2
#define PWM_TASK_STACK_SIZE  1024
#define PWM_TASK_PRIORITY    3
#define MAIN_TASK_STACK_SIZE 2048
#define MAIN_TASK_PRIORITY   1
rsi_semaphore_handle_t pwm_thread_sem, i2c_thread_sem, main_thread_sem;
rsi_task_handle_t pwm_task_handle  = NULL;
rsi_task_handle_t i2c_task_handle  = NULL;
rsi_task_handle_t main_task_handle = NULL;
#endif

volatile uint32_t peripheral = 0;

int main_loop(void)
{
  int32_t status = RSI_OK;
  peripheral     = EMPTY;
  while (1) {
    switch (peripheral) {
      case EMPTY:
        //!do nothing
        break;
      case PWM:
        status = PWM_App();
        if (status != RSI_OK) {
          DEBUGOUT("\n PWM fail\n");
          break;
        }
        DEBUGOUT("\n **PWM done**\n");
        break;

      case I2C:
        status = I2C_Transfer();
        if (status != RSI_OK) {
          DEBUGOUT("\n I2C0/I2C1/I2C2 Transfer fail\n");
          break;
        }

        break;

      case PIN_INTERRUPT:
        DEBUGOUT("\n **toggle LED**\n");
        break;
    }
  }
}
int main(void)
{
  int32_t status = RSI_OK;

  //! Driver initialization
  status = rsi_driver_init(global_buf, GLOBAL_BUFF_LEN);
  if ((status < 0) || (status > GLOBAL_BUFF_LEN)) {
    return status;
  }

  //! RS9116 initialization
  status = rsi_device_init(LOAD_NWP_FW);
  if (status != RSI_SUCCESS) {
    return status;
  }

  DEBUGOUT("\n device init done\n");

  /* Initialize pin interrupt */
  status = Pin_Int0();

  /*Initialize I2C 3 stances */
  I2C_Init();
  DEBUGOUT("\n I2C Initialization success\n");

  /*Configure Push button interrupt*/
  status = Push_Button_Intr();

  /*Initialize PWM*/
  status = PWM_Init();

  /*Initialize timer interrupt*/
  Timer_Intr_App();

#ifdef RSI_WITH_OS
  rsi_semaphore_create(&pwm_thread_sem, 0);
  rsi_semaphore_create(&i2c_thread_sem, 0);
  rsi_semaphore_create(&main_thread_sem, 0);

  //! Task created for I2C task
  rsi_task_create(I2C_Transfer, "i2c_task", I2C_TASK_STACK_SIZE, NULL, I2C_TASK_PRIORITY, &i2c_task_handle);

  //! Task created for PWM task
  rsi_task_create(PWM_App, "pwm_task", PWM_TASK_STACK_SIZE, NULL, PWM_TASK_PRIORITY, &pwm_task_handle);

  //! Task created for main task
  rsi_task_create(main_loop, "main_task", MAIN_TASK_STACK_SIZE, NULL, MAIN_TASK_PRIORITY, &main_task_handle);

  //! OS TAsk Start the scheduler
  rsi_start_os_scheduler();
#else
  main_loop();
#endif

  while (1)
    ;
}
