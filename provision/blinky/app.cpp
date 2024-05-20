/***************************************************************************/ /**
* @file
* @brief Top level application functions
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

#include "app.h"
#include <string.h>
#include <stdio.h>
#include <stdarg.h>
#include <stdio.h>

#include <nvm3.h>
#include <nvm3_default.h>
#include <string.h>

#include <sl_system_init.h>
#include <provision/ProvisionManager.h>
#include <platform/silabs/SilabsConfig.h>

#define MAIN_TASK_STACK_SIZE (1024)
#define MAIN_TASK_PRIORITY (configMAX_PRIORITIES - 1)
#define TIMER_TIMEOUT_MS 500

using namespace chip::DeviceLayer::Silabs;
using namespace chip::DeviceLayer::Internal;

static constexpr size_t kBufferMax = 256;
static uint8_t _buffer[kBufferMax];
static uint32_t _value = 0xa000;



namespace silabs
{
// Instance
namespace
{
static ExampleApp _app;
}


void ExampleApp::nvm3_debug1()
{
    uint32_t nvm3_key = 0x87200;

    _value++;
    Ecode_t code = nvm3_writeData(nvm3_defaultHandle, nvm3_key, &_value, sizeof(_value));
    Print("NVM3 Write(#%04x): e:#%08x, v:#%04x\n", (unsigned)nvm3_key, (unsigned)code, (unsigned)_value);

    nvm3_key = 0x87221;
    CHIP_ERROR err = SilabsConfig::WriteConfigValue(nvm3_key, _value);
    Print("NVM3 Write(#%04x): e:#%08x, v:#%04x\n", (unsigned)nvm3_key, (unsigned)err.AsInteger(), (unsigned)_value);
}

void ExampleApp::nvm3_debug2()
{
    uint32_t nvm3_key = 0x87200;
    uint32_t value = 0;

    Ecode_t code = nvm3_readData(nvm3_defaultHandle, nvm3_key, &value, sizeof(value));
    Print("NVM3 Read(#%04x): e:#%08x, v:#%04x\n", (unsigned)nvm3_key, (unsigned)code, (unsigned)value);

    nvm3_key = 0x87221;
    CHIP_ERROR err = SilabsConfig::WriteConfigValue(nvm3_key, _value);
    Print("NVM3 Read(#%04x): e:#%08x, v:#%04x\n", (unsigned)nvm3_key, (unsigned)err.AsInteger(), (unsigned)_value);

}


ExampleApp::ExampleApp() {}


void ExampleApp::Start()
{

    xTaskCreate(ExampleApp::Run, "Main Task", MAIN_TASK_STACK_SIZE, this,
                MAIN_TASK_PRIORITY, &_task);

    sl_sleeptimer_start_periodic_timer_ms(
        &_timer, TIMER_TIMEOUT_MS, ExampleApp::TimerCallback, this, 0,
        SL_SLEEPTIMER_NO_HIGH_PRECISION_HF_CLOCKS_REQUIRED_FLAG);
}


void ExampleApp::Step()
{
    // Busywork
    if (++_counter > 10000) {
        _counter = 0;

        // Read
        size_t bytes = 0;
        sl_status_t err = Read(_buffer, sizeof(_buffer), bytes);
        if(!err)
        {
            Print("Received(%u): \"%s\"\n", (unsigned)bytes, (char*)_buffer);
        }

        // Events
        switch(_event)
        {
        case EventId::OnPress0:
            OnPress(ButtonId::Button0, true);
            break;
        case EventId::OnPress1:
            OnPress(ButtonId::Button1, true);
            break;
        case EventId::None:
            break;
        }

        _event = EventId::None;
    }
}


void ExampleApp::Run(void *data)
{
    ExampleApp *app = static_cast<ExampleApp *>(data);

    app->Print("-------- Example App v%s --------\n", APP_VERSION);
    app->Init();

    CHIP_ERROR err = SilabsConfig::Init();
    app->Print("NVM3 Open: #%08x\n",  (unsigned)err.AsInteger());

    Provision::Manager::GetInstance().Init();
    while (app) {
        app->Step();
        Provision::Manager::GetInstance().Step();
    }
}

void ExampleApp::Print(const char* format, ...)
{
    char temp[256];
    va_list args;
    va_start(args, format);
    size_t n =  vsnprintf((char*)temp, sizeof(temp)-1, format, args);
    // Write((uint8_t*)temp, n);
    va_end(args);
}


void ExampleApp::OnEvent(EventId event, void *data)
{
    // FIXME: USE AN ACTUAL EVENT QUEUE
    _event = event;
}

void ExampleApp::OnPress(ButtonId button, bool state)
{
    if(state && (ButtonId::Button0 == button))
    {
        Print("Toggle!\n");
        Toggle(LedId::Led1);
        nvm3_debug1();
    }
    else if(state && (ButtonId::Button1 == button))
    {
        Print("Debug!\n");
        Toggle(LedId::Led1);
        nvm3_debug2();
    }
}

void ExampleApp::TimerCallback(sl_sleeptimer_timer_handle_t *handle, void *data)
{
    ExampleApp *app = static_cast<ExampleApp *>(data);
    if (app) {
        app->Toggle(LedId::Led0);
    }
}

ExampleApp &ExampleApp::Instance() { return _app; }

} // namespace silabs


// CHIP_ERROR debug()
// {
//     // return silabs::ExampleApp::Instance()::Write();
//     Ecode_t err = nvm3_writeData(nvm3_defaultHandle, _nvm3_key, &_value, sizeof(_value));

//     return CHIP_ERROR(0x0e000000 + (err & 0xffffff));
// }