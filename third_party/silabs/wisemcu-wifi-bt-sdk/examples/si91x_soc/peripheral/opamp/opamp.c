/*******************************************************************************
* @file  opamp_example.c
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

/* Includes ------------------------------------------------------------------*/
#include "rsi_chip.h"

/* Private macro -------------------------------------------------------------*/

/*DAC */
#define SAMPLE_LENGTH 1
#define DAC_ENABLE    0
#define SAMPLING_RATE 1000000

/* OPAMP */
#define OPAMP1_PINMUX     1
#define OPAMP2_PINMUX     0
#define OPAMP3_PINMUX     0
#define OPAMP_OUT_MUX_SEL 0
#define OPAMP_DYN_MODE_EN 0 /*OPAMP Dynamic mode*/
#define CHANNEL_NO        0 /*adc channel no in dynamic mode*/
#define OPAMP_LP_MODE     0 /*OPAMP low power enable*/
#define OPAMP_GPIO        1
#define OUTPUT_MUX_ENABLE 1
/* Private variables ---------------------------------------------------------*/
/* Verf configuration */
float vref_value = 2.48; 					// Reference voltage of LDO, Min is 1.6V and Max is 3.3V
/* Standard sin wave samples */
int16_t input_sample_data[SAMPLE_LENGTH] = { 0x33A };

/* Private functions ---------------------------------------------------------*/
/**
 * @brief      Configures the opamp related pins
 * @return     None
 */
void OPAMP_Pinmuxing()
{

#if OPAMP1_PINMUX
  RSI_EGPIO_SetPinMux(EGPIO, 0, OPAMP1_N_SEL_PIN, AGPIO_MODE);
  RSI_EGPIO_SetPinMux(EGPIO1, 0, OPAMP1_P_SEL_PIN, AGPIO_MODE);
  RSI_EGPIO_SetPinMux(EGPIO1, 0, OPAMP1_OUT, AGPIO_MODE);
#endif

#if OPAMP2_PINMUX
  RSI_EGPIO_SetPinMux(EGPIO1, 0, OPAMP2_P_SEL_PIN, AGPIO_MODE);
  RSI_EGPIO_SetPinMux(EGPIO1, 0, OPAMP2_N_SEL_PIN, AGPIO_MODE);
  RSI_EGPIO_SetPinMux(EGPIO1, 0, OPAMP2_OUT, AGPIO_MODE);
#endif

#if OPAMP3_PINMUX
  /* Pad receive Disable*/
  RSI_EGPIO_PadReceiverDisable(OPAMP3_OUT);
  RSI_EGPIO_HostPadsGpioModeEnable(OPAMP3_OUT);
  RSI_EGPIO_PadSdioConnected();
  RSI_EGPIO_SetPinMux(EGPIO1, 0, OPAMP3_P_SEL_PIN, AGPIO_MODE);
  RSI_EGPIO_SetPinMux(EGPIO1, 0, OPAMP3_OUT, TGPIO_MODE);
#endif
}

#if DAC_ENABLE
/**
 * @brief  Event call back function..
 * @retval None
 */
void dac_callback(uint8_t event)
{
  /* Call back function never call in DAC static mode */
}
#endif

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int main()
{
  volatile uint32_t achived_sampling_rate = 0;

  /*Configures the system default clock and power configurations*/
  SystemCoreClockUpdate();

  /* Configure an AUX clock source */
  RSI_ULPSS_AuxClkConfig(ULPCLK, ENABLE_STATIC_CLK, ULP_AUX_32MHZ_RC_CLK);

  ULP_SPI_MEM_MAP(BG_SCDC_PROG_REG_1) |= BIT(3);

  /*  Configure the reference LDO voltage as 2.48v */
  RSI_AUX_RefVoltageConfig(vref_value, 3.2);

#if DAC_ENABLE

  /* Initialize DAC */
  achived_sampling_rate = DAC_Init(STATIC_MODE_EN, SAMPLING_RATE, dac_callback);

  DAC_WriteData(STATIC_MODE_EN, input_sample_data, 1);

  DAC_Start(STATIC_MODE_EN);

#endif

  OPAMP_Pinmuxing();

  RSI_OPAMP1_UGB(OPAMP_GPIO,
                 ENABLE,
                 OPAMP_LP_MODE,
                 OUTPUT_MUX_ENABLE,
                 OPAMP_OUT_MUX_SEL,
                 OPAMP_DYN_MODE_EN,
                 CHANNEL_NO);

  while (1)
    ;
}
