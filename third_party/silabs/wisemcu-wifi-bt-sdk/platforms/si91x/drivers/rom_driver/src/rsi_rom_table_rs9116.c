#include <stdint.h>
#include "rsi_chip.h"
#include "rsi_ccp_user_config.h"
#include "rsi_rom_table_rs9116.h"
#if defined(A11_ROM)
#ifdef __cplusplus
extern "C" {
#endif
extern const ROM_EGPIO_API_T egpio_api;
extern const ROM_TIMERS_API_T timer_api;
extern const ROM_UDMA_API_T udma_api;
extern const ROM_UDMA_WRAPPER_API_T udma_wrapper_api;
extern const ROM_CT_API_T ct_api;
extern const ROM_RPDMA_API_T gpdma_api;
extern const ROM_PWR_API_T pwr_api;
extern const ROM_M4SS_CLK_API_T m4ssclk_api;
extern const ROM_ULPSS_CLK_API_T ulpssclk_api;
extern const ROM_QSPI_API_T qspi_api;
extern const ROM_EFUSE_API_T efuse_api;
extern const ROM_CRC_API_T crc_api;
extern const ROM_RNG_API_T rng_api;
extern const ROM_MCPWM_API_T mcpwm_api;
extern const ROM_USART_API_T usart_api;
extern const ROM_GSPI_API_T gspi_api;
extern const ROM_I2S_API_T i2s_api;
extern const ROM_I2C_API_T i2c_api;
#if defined(CHIP_9117)
extern const ROM_SSI_API_T ssi_api;
#endif
#if defined(CHIP_9118)
extern const struct ROM_WL_API_S wl_api;
#endif
const RSI_ROM_API_T romEntry __attribute__((section(".rom_data_start"))) = {
  /*!< ROM TABLE FIXED ENTRY POINT*/
  &egpio_api,        /*!< EGPIO  driver API function table base address */
  &timer_api,        /*!< FIM driver API function table base address */
  &udma_api,         /*!< uDMA driver API function table base address */
  &udma_wrapper_api, /*!< udma wrapper driver API function table base address */
  &ct_api,           /*!< CT driver API function table base address */
  &gpdma_api,        /*!< RPDMA driver API function table base address */
  &pwr_api,          /*!< POWER SAVE driver API function table base address */
  &m4ssclk_api,      /*!< M4SS CLK driver API function table base address */
  &ulpssclk_api,     /*!< ULPSS CLK driver API function table base address */
  &qspi_api,         /*!< QSPI driver API function table base address */
  &efuse_api,        /*!< EFUSE driver API function table base address */
  &crc_api,          /*!< CRC driver API function table base address */
  &rng_api,          /*!< RNG driver API function table base address */
  &mcpwm_api,        /*!< MCPWM driver API function table base address */
  &usart_api,        /*!< USARt driver API function table base address */
  &gspi_api,         /*!< GSPI driver API function table base address */
  &i2s_api,          /*!< I2S driver API function table base address */
  &i2c_api           /*!< I2C driver API function table base address */
#if defined(CHIP_9117)
  ,
  &ssi_api
#endif
#if defined(CHIP_9118)
  ,
  &wl_api /*!< Wireless driver API function table base address */
#endif
};

#ifdef __cplusplus
}
#endif
#endif
