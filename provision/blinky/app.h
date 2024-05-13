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
#pragma once

#ifndef SILABS_EXAMPLE_APP_H
#define SILABS_EXAMPLE_APP_H

#include <stddef.h>
#include <stdint.h>
#include <FreeRTOS.h>
#include <task.h>
#include <sl_status.h>
#include <sl_sleeptimer.h>

#define APP_VERSION "1.2.0"

namespace silabs
{

enum class LedId { Led0, Led1 };
enum class ButtonId { Button0, Button1 };
enum class EventId { None = 0, OnPress0, OnPress1 };

struct ExampleApp
{
    ExampleApp();
    void Start();
    void Step();
    void OnEvent(EventId event, void *data);
    void OnPress(ButtonId button, bool state);
    void Print(const char* format, ...);

    // Platform-specific
    sl_status_t Init();
    sl_status_t Toggle(LedId led);
    sl_status_t Read(uint8_t *buffer, size_t buffer_length, size_t &bytes_read);
    sl_status_t Write(const uint8_t *buffer, size_t buffer_length);

    static ExampleApp &Instance();
    static void TimerCallback(sl_sleeptimer_timer_handle_t *handle, void *data);

  void nvm3_debug1();
  void nvm3_debug2();

  private:
    static void Run(void *data);
    TaskHandle_t _task;
    sl_sleeptimer_timer_handle_t _timer;
    size_t _counter = 0;
    EventId _event = EventId::None;
};

} // namespace silabs

#endif // SILABS_EXAMPLE_APP_H
