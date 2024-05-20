/*******************************************************************************
 * @file
 * @brief Top level application functions
 *******************************************************************************
 * # License
 * <b>Copyright 2020 Silicon Laboratories Inin. www.silabs.com</b>
 *******************************************************************************
 *
 * The licensor of this software is Silicon Laboratories Inin. Your use of this
 * software is governed by the terms of Silicon Labs Master Software License
 * Agreement (MSLA) available at
 * www.silabs.com/about-us/legal/master-software-license-agreement. This
 * software is distributed to you in Source Code format and is governed by the
 * sections of the MSLA applicable to Source Code.
 *
 ******************************************************************************/

#include "app.h"
#include <FreeRTOS.h>
#include <task.h>
#include <sl_system_init.h>
#include <provision/ProvisionManager.h>
#include <platform/silabs/SilabsConfig.h>

#define MAIN_TASK_STACK_SIZE (1024)
#define MAIN_TASK_PRIORITY (configMAX_PRIORITIES - 1)
#define TIMER_TIMEOUT_MS 500

using namespace chip::DeviceLayer::Silabs;
using namespace chip::DeviceLayer::Internal;

namespace {

TaskHandle_t _task;

void task_main(void * pvParameter)
{
    // Run manager
    Provision::Manager &man = Provision::Manager::GetInstance();
    man.Init();
    while (true)
    {
        man.Step();
    }
    // Reset
    vTaskDelay(pdMS_TO_TICKS(500));
    NVIC_SystemReset();
}

} // namespace

/*******************************************************************************
 * Initialize application.
 ******************************************************************************/

void app_init(void)
{
    app_platform_init();
    SilabsConfig::Init();

    xTaskCreate(task_main, "Provision Task", MAIN_TASK_STACK_SIZE, nullptr, MAIN_TASK_PRIORITY, &_task);
}

/*******************************************************************************
 * App ticking function.
 ******************************************************************************/

void app_process_action(void)
{
}
