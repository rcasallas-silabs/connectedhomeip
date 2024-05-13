#include "app.h"
#include <sl_simple_led.h>
#include <sl_simple_led_instances.h>
#include <sl_simple_button_instances.h>
#include <sl_iostream_rtt.h>
#include <sl_iostream_init_instances.h>

namespace silabs
{

void ExampleApp::Toggle(LedId led)
{
    switch(led)
    {
    case LedId::Led0:
        sl_led_toggle(&sl_led_led0);
        break;
    case LedId::Led1:
        sl_led_toggle(&sl_led_led1);
        break;
    }
}

sl_status_t ExampleApp::Read(uint8_t *buffer, size_t buffer_length, size_t &bytes_read)
{
    sl_status_t err = sl_iostream_read(sl_iostream_rtt_handle, buffer, buffer_length, &bytes_read);
    return err;
}

sl_status_t ExampleApp::Write(const uint8_t *buffer, size_t buffer_length)
{
    return sl_iostream_write(sl_iostream_rtt_handle, buffer, buffer_length);
}

} // namespace silabs


void sl_button_on_change(const sl_button_t *handle)
{
    silabs::ExampleApp &app = silabs::ExampleApp::Instance();
    bool pressed = (sl_button_get_state(handle) == SL_SIMPLE_BUTTON_PRESSED);

    if(&sl_button_btn0 == handle)
    {
        app.OnPress(silabs::ButtonId::Button0, pressed);
    }
    else if(&sl_button_btn1 == handle)
    {
        app.OnPress(silabs::ButtonId::Button1, pressed);
    }
}
