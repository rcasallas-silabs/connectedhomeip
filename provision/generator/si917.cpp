#include "app.h"
// #include <rsi_debug.h>
extern "C" {
#include <sl_si91x_button_instances.h>
#include <sl_si91x_led_instances.h>
#include <sl_wifi_callback_framework.h>
#include <sl_wifi.h>
#include <sl_wifi_device.h>
#include <sl_net.h>
}
#include <sl_iostream_rtt.h>
#include <sl_iostream_init_instances.h>
#include <sl_net_constants.h>


static const sl_wifi_device_configuration_t _wifi_config = {
  .boot_option = LOAD_NWP_FW,
  .mac_address = NULL,
  .band        = SL_SI91X_WIFI_BAND_2_4GHZ,
  .region_code = US,
  .boot_config = { .oper_mode              = SL_SI91X_CLIENT_MODE,
                   .coex_mode              = SL_SI91X_WLAN_ONLY_MODE,
                   .feature_bit_map        = (SL_SI91X_FEAT_SECURITY_PSK | SL_SI91X_FEAT_AGGREGATION),
                   .tcp_ip_feature_bit_map = (SL_SI91X_TCP_IP_FEAT_DHCPV4_CLIENT | SL_SI91X_TCP_IP_FEAT_HTTP_CLIENT
                                              | SL_SI91X_TCP_IP_FEAT_EXTENSION_VALID | SL_SI91X_TCP_IP_FEAT_OTAF
                                              | SL_SI91X_TCP_IP_FEAT_DNS_CLIENT),
                   .custom_feature_bit_map = SL_SI91X_CUSTOM_FEAT_EXTENTION_VALID,
                   .ext_custom_feature_bit_map =
                     (SL_SI91X_EXT_FEAT_XTAL_CLK | SL_SI91X_EXT_FEAT_UART_SEL_FOR_DEBUG_PRINTS |
#ifndef SLI_SI91X_MCU_INTERFACE
                      SL_SI91X_RAM_LEVEL_NWP_ALL_MCU_ZERO
#else
                      SL_SI91X_RAM_LEVEL_NWP_MEDIUM_MCU_MEDIUM
#endif
                      ),
                   .bt_feature_bit_map = 0,
                   .ext_tcp_ip_feature_bit_map =
                     (SL_SI91X_EXT_FEAT_HTTP_OTAF_SUPPORT | SL_SI91X_EXT_TCP_IP_SSL_16K_RECORD
                      | SL_SI91X_CONFIG_FEAT_EXTENTION_VALID),
                   .ble_feature_bit_map     = 0,
                   .ble_ext_feature_bit_map = 0,
                   .config_feature_bit_map  = 0 }
};


sl_status_t app_platform_init()
{
    // Print("* boot_option:                   0x%08x\n", _wifi_config.boot_option);
    // Print("* mac_address:                   0x%08x\n", _wifi_config.mac_address);
    // Print("* band:                          0x%08x\n", _wifi_config.band);
    // Print("* region_code:                   0x%08x\n", _wifi_config.region_code);
    // Print("* boot_config:\n");
    // Print("  - oper_mode:                   0x%08x\n", _wifi_config.boot_config.oper_mode);
    // Print("  - coex_mode:                   0x%08x\n", _wifi_config.boot_config.coex_mode);
    // Print("  - feature_bit_map:             0x%08x\n", _wifi_config.boot_config.feature_bit_map);
    // Print("  - tcp_ip_feature_bit_map:      0x%08x\n", _wifi_config.boot_config.tcp_ip_feature_bit_map);
    // Print("  - custom_feature_bit_map:      0x%08x\n", _wifi_config.boot_config.custom_feature_bit_map);
    // Print("  - ext_custom_feature_bit_map:  0x%08x\n", _wifi_config.boot_config.ext_custom_feature_bit_map);
    // Print("  - bt_feature_bit_map:          0x%08x\n", _wifi_config.boot_config.bt_feature_bit_map);
    // Print("  - ext_tcp_ip_feature_bit_map:  0x%08x\n", _wifi_config.boot_config.ext_tcp_ip_feature_bit_map);
    // Print("  - ble_feature_bit_map:         0x%08x\n", _wifi_config.boot_config.ble_feature_bit_map);
    // Print("  - ble_ext_feature_bit_map:     0x%08x\n", _wifi_config.boot_config.ble_ext_feature_bit_map);
    // Print("  - config_feature_bit_map:      0x%08x\n", _wifi_config.boot_config.config_feature_bit_map);

    return sl_wifi_init(&_wifi_config, NULL, sl_wifi_default_event_handler);
}


void sl_si91x_button_isr(uint8_t pin, int8_t state)
{
}