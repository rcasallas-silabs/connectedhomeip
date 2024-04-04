#include <platform/silabs/SilabsConfig.h>
#include <platform/silabs/platformAbstraction/SilabsPlatform.h>
#include <provision/ProvisionManager.h>
#include <lib/support/CHIPPlatformMemory.h>
#include <lib/support/CHIPMem.h>
#include <lib/support/CodeUtils.h>
#include <lib/core/CHIPError.h>
#include <sl_system_init.h>
#include <MatterConfig.h>

#include <mbedtls/platform.h>
#include <FreeRTOS.h>
#include <task.h>
#include <nvm3.h>
#include <nvm3_default.h>
#include <nvm3_hal_flash.h>
#include <nvm3_lock.h>
#include <string.h>

#define MAIN_TASK_STACK_SIZE (1024 * 5)
#define MAIN_TASK_PRIORITY (configMAX_PRIORITIES - 1)

using namespace chip::DeviceLayer::Silabs;

/**********************************************************
 * Defines
 *********************************************************/

#define MAIN_TASK_STACK_SIZE (1024 * 5)
#define MAIN_TASK_PRIORITY (configMAX_PRIORITIES - 1)

namespace {

static TaskHandle_t _task;

void taskMain(void *data)
{
    // Initialization
    chip::Platform::MemoryInit();
#ifdef SL_WIFI
    SilabsMatterConfig::InitWiFi();
#endif
    nvm3_open(nvm3_defaultHandle, nvm3_defaultInit);

    // Provision
    Provision::Manager &man = Provision::Manager::GetInstance();
    man.Init();
    while(true) man.Step();
}

} // namespace

// ================================================================================
// Main Code
// ================================================================================

int main(void)
{
    sl_system_init();
    xTaskCreate(taskMain, "Main Task", MAIN_TASK_STACK_SIZE, nullptr, MAIN_TASK_PRIORITY, &_task);
    vTaskStartScheduler();
    while(true);
}
