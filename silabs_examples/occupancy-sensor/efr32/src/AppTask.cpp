/*
 *
 *    Copyright (c) 2020 Project CHIP Authors
 *    Copyright (c) 2019 Google LLC.
 *    All rights reserved.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#include "AppTask.h"
#include "AppConfig.h"
#include "AppEvent.h"

#ifdef ENABLE_WSTK_LEDS
#include "LEDWidget.h"
#include "sl_simple_led_instances.h"
#endif // ENABLE_WSTK_LEDS

#include <app/clusters/identify-server/identify-server.h>
#include <app/clusters/occupancy-sensor-server/occupancy-sensor-server.h>
#include <app/clusters/occupancy-sensor-server/occupancy-hal.h>

#include <app/server/OnboardingCodesUtil.h>
#include <app/server/Server.h>
#include <app/util/attribute-storage.h>

#include <assert.h>

#include <setup_payload/QRCodeSetupPayloadGenerator.h>
#include <setup_payload/SetupPayload.h>

#include <lib/support/CodeUtils.h>

#include <platform/CHIPDeviceLayer.h>

#ifdef ENABLE_WSTK_LEDS
#if defined(SL_CATALOG_SIMPLE_LED_LED1_PRESENT)
#define SENSOR_LED &sl_led_led1
#else
#define SENSOR_LED &sl_led_led0
#endif
#endif // ENABLE_WSTK_LEDS

#ifdef SL_CATALOG_SIMPLE_BUTTON_PRESENT

#define APP_FUNCTION_BUTTON &sl_button_btn0
#define APP_SENSOR_SWITCH &sl_button_btn1
#endif

using namespace chip;
using namespace ::chip::DeviceLayer;

namespace {

#ifdef ENABLE_WSTK_LEDS
LEDWidget sSensorLED;
#endif // ENABLE_WSTK_LEDS

EmberAfIdentifyEffectIdentifier sIdentifyEffect = EMBER_ZCL_IDENTIFY_EFFECT_IDENTIFIER_STOP_EFFECT;

static bool isSensorTriggered = false;

/**********************************************************
 * Identify Callbacks
 *********************************************************/

namespace {
void OnTriggerIdentifyEffectCompleted(chip::System::Layer * systemLayer, void * appState)
{
    ChipLogProgress(Zcl, "Trigger Identify Complete");
    sIdentifyEffect = EMBER_ZCL_IDENTIFY_EFFECT_IDENTIFIER_STOP_EFFECT;

#if CHIP_DEVICE_CONFIG_ENABLE_SED == 1
    AppTask::GetAppTask().StopStatusLEDTimer();
#endif
}
} // namespace

void OnTriggerIdentifyEffect(Identify * identify)
{
    sIdentifyEffect = identify->mCurrentEffectIdentifier;

    if (identify->mCurrentEffectIdentifier == EMBER_ZCL_IDENTIFY_EFFECT_IDENTIFIER_CHANNEL_CHANGE)
    {
        ChipLogProgress(Zcl, "IDENTIFY_EFFECT_IDENTIFIER_CHANNEL_CHANGE - Not supported, use effect varriant %d",
                        identify->mEffectVariant);
        sIdentifyEffect = static_cast<EmberAfIdentifyEffectIdentifier>(identify->mEffectVariant);
    }

#if CHIP_DEVICE_CONFIG_ENABLE_SED == 1
    AppTask::GetAppTask().StartStatusLEDTimer();
#endif

    switch (sIdentifyEffect)
    {
    case EMBER_ZCL_IDENTIFY_EFFECT_IDENTIFIER_BLINK:
    case EMBER_ZCL_IDENTIFY_EFFECT_IDENTIFIER_BREATHE:
    case EMBER_ZCL_IDENTIFY_EFFECT_IDENTIFIER_OKAY:
        (void) chip::DeviceLayer::SystemLayer().StartTimer(chip::System::Clock::Seconds16(5), OnTriggerIdentifyEffectCompleted,
                                                           identify);
        break;
    case EMBER_ZCL_IDENTIFY_EFFECT_IDENTIFIER_FINISH_EFFECT:
        (void) chip::DeviceLayer::SystemLayer().CancelTimer(OnTriggerIdentifyEffectCompleted, identify);
        (void) chip::DeviceLayer::SystemLayer().StartTimer(chip::System::Clock::Seconds16(1), OnTriggerIdentifyEffectCompleted,
                                                           identify);
        break;
    case EMBER_ZCL_IDENTIFY_EFFECT_IDENTIFIER_STOP_EFFECT:
        (void) chip::DeviceLayer::SystemLayer().CancelTimer(OnTriggerIdentifyEffectCompleted, identify);
        sIdentifyEffect = EMBER_ZCL_IDENTIFY_EFFECT_IDENTIFIER_STOP_EFFECT;
        break;
    default:
        ChipLogProgress(Zcl, "No identifier effect");
    }
}

Identify gIdentify = {
    chip::EndpointId{ 1 },
    AppTask::GetAppTask().OnIdentifyStart,
    AppTask::GetAppTask().OnIdentifyStop,
    EMBER_ZCL_IDENTIFY_IDENTIFY_TYPE_VISIBLE_LED,
    OnTriggerIdentifyEffect,
};

} // namespace

using namespace chip::TLV;
using namespace ::chip::DeviceLayer;

AppTask AppTask::sAppTask;

CHIP_ERROR AppTask::Init()
{
    CHIP_ERROR err = CHIP_NO_ERROR;
#ifdef DISPLAY_ENABLED
    GetLCD().Init((uint8_t *) "Occupancy-App");
#endif

    err = BaseApplication::Init(&gIdentify);
    if (err != CHIP_NO_ERROR)
    {
        SILABS_LOG("BaseApplication::Init() failed");
        appError(err);
    }

#ifdef ENABLE_WSTK_LEDS
    sSensorLED.Init(SENSOR_LED);
    sSensorLED.Set(isSensorTriggered);
#endif // ENABLE_WSTK_LEDS

// Update the LCD with the Stored value. Show QR Code if not provisioned
#ifdef DISPLAY_ENABLED
    GetLCD().WriteDemoUI(isSensorTriggered);
#ifdef QR_CODE_ENABLED
#ifdef SL_WIFI
    if (!ConnectivityMgr().IsWiFiStationProvisioned())
#else
    if (!ConnectivityMgr().IsThreadProvisioned())
#endif /* !SL_WIFI */
    {
        GetLCD().ShowQRCode(true, true);
    }
#endif // QR_CODE_ENABLED
#endif

    return err;
}

CHIP_ERROR AppTask::StartAppTask()
{
    return BaseApplication::StartAppTask(AppTaskMain);
}

void AppTask::AppTaskMain(void * pvParameter)
{
    AppEvent event;
    QueueHandle_t sAppEventQueue = *(static_cast<QueueHandle_t *>(pvParameter));

    CHIP_ERROR err = sAppTask.Init();
    if (err != CHIP_NO_ERROR)
    {
        SILABS_LOG("AppTask.Init() failed");
        appError(err);
    }

#if !(defined(CHIP_DEVICE_CONFIG_ENABLE_SED) && CHIP_DEVICE_CONFIG_ENABLE_SED)
    sAppTask.StartStatusLEDTimer();
#endif

    SILABS_LOG("App Task started");

    while (true)
    {
        BaseType_t eventReceived = xQueueReceive(sAppEventQueue, &event, portMAX_DELAY);
        while (eventReceived == pdTRUE)
        {
            sAppTask.DispatchEvent(&event);
            eventReceived = xQueueReceive(sAppEventQueue, &event, 0);
        }
    }
}

void AppTask::OnIdentifyStart(Identify * identify)
{
    ChipLogProgress(Zcl, "onIdentifyStart");

#if CHIP_DEVICE_CONFIG_ENABLE_SED == 1
    sAppTask.StartStatusLEDTimer();
#endif
}

void AppTask::OnIdentifyStop(Identify * identify)
{
    ChipLogProgress(Zcl, "onIdentifyStop");

#if CHIP_DEVICE_CONFIG_ENABLE_SED == 1
    sAppTask.StopStatusLEDTimer();
#endif
}

void AppTask::SensorActionEventHandler(AppEvent * aEvent)
{

#ifdef SL_CATALOG_SIMPLE_BUTTON_PRESENT
    if (aEvent->Type == AppEvent::kEventType_Button)
    {
        if(aEvent->ButtonEvent.Action == SL_SIMPLE_BUTTON_PRESSED)
        {
            isSensorTriggered = true;
            // TODO update CLuster
        } 
        else if (aEvent->ButtonEvent.Action == SL_SIMPLE_BUTTON_RELEASED)
        {
            isSensorTriggered = false;
            // TODO update CLuster
        }

#ifdef ENABLE_WSTK_LEDS
        sSensorLED.Set(isSensorTriggered);
#endif // ENABLE_WSTK_LEDS

#ifdef DISPLAY_ENABLED
        sAppTask.GetLCD().WriteDemoUI(isSensorTriggered);
#endif
        chip::DeviceLayer::PlatformMgr().LockChipStack();
        halOccupancyStateChangedCallback(1, static_cast<HalOccupancyState>(isSensorTriggered));
        chip::DeviceLayer::PlatformMgr().UnlockChipStack();
    }
#endif

}
#ifdef SL_CATALOG_SIMPLE_BUTTON_PRESENT
void AppTask::ButtonEventHandler(const sl_button_t * buttonHandle, uint8_t btnAction)
{
    if (buttonHandle == NULL)
    {
        return;
    }

    AppEvent button_event           = {};
    button_event.Type               = AppEvent::kEventType_Button;
    button_event.ButtonEvent.Action = btnAction;

    if (buttonHandle == APP_SENSOR_SWITCH)
    {
        button_event.Handler = SensorActionEventHandler;
        sAppTask.PostEvent(&button_event);
    }
    else if (buttonHandle == APP_FUNCTION_BUTTON)
    {
        button_event.Handler = BaseApplication::ButtonHandler;
        sAppTask.PostEvent(&button_event);
    }
}

#endif