/*******************************************************************************
 * @file  adc_static_mode.c
 * @brief
 *******************************************************************************
 * # License
 * <b>Copyright 2022 Silicon Laboratories Inc. www.silabs.com</b>
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

// Include Files

#include "rsi_chip.h"
#include "aux_reference_volt_config.h"
#include "rsi_adc.h"
#include "rsi_bod.h"
#include "rsi_board.h"

#define NUMBER_OF_CHA_EN       1 // In ADC static mode enable only one ADC channel
#define CHANNEL0_SAMPLE_LENGTH 1 // Length of sample to collect
#define CHANNEL0_SAMPLING_RATE \
  1000000                // Number of samples to collect Minimum is 1msps(1000000) and Maximum is 2.5msps (2500000)
#define ADC_INPUT_TYPE 1 // Single ended - 0 , Differential ended - 1
float vref_value = 2.8;  // Reference voltage to LDO for ADC conversion operation. Min is 1.8V and Max is 3.3V

volatile uint8_t intr_done = 0;
int16_t adc_output_ch0[CHANNEL0_SAMPLE_LENGTH]; // ADC output buffer

/*==============================================*/
/**
 * @fn     void callback_handler(uint8_t channel_no, uint8_t event)
 * @brief  Call back function , This function interrupt handler
 * @param  channel_no  : Channel number for clearing
 * @return None
 */
void callback_handler(uint8_t channel_no, uint8_t event)
{
#ifdef CHIP_9118
  // Call back handler never call in ADC static mode
#endif
#ifdef CHIP_9117
  if (event == ADC_STATIC_MODE_CALLBACK) {
    intr_done = 1;
  }
#endif
}

/*==============================================*/
/**
 * @fn     int main()
 * @brief  Main Application Function
 * @return None
 */
int main()
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_rs1xxxx.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * system_rs1xxxx.c file
   */
  int32_t status = RSI_OK;
  volatile float vout;
  float battery_status;
  float max_ip_volt_scdc = 2.4;

  // ADC Channel configuration structure variable
  adc_ch_config_t adcChConfig;
  // ADC module configuration structure variable
  adc_config_t adcConfig;

  //Configures the system default clock and power configurations
  SystemCoreClockUpdate();

  // Read the input supply of chip
  battery_status = RSI_BOD_SoftTriggerGetBatteryStatus();

  //If input to chip less than 2.4V then swith input voltage supply from SCDC to HPLDO
  if (battery_status < max_ip_volt_scdc) {
    RSI_IPMU_ProgramConfigData(hp_ldo_voltsel);
  }

  // Initialize board UART
  DEBUGINIT();

  // Configure ADC module related parameter
  adcConfig.num_of_channel_enable =
    NUMBER_OF_CHA_EN; // Number of channel enable for ADC operation,here enable two ADC channel
  adcConfig.operation_mode = ADC_STATICMODE_ENABLE; // ADC operation mode

  // Configure ADC channel related parameter
  adcChConfig.input_type[0]    = ADC_INPUT_TYPE;         // Differential ended input to ADC
  adcChConfig.sampling_rate[0] = CHANNEL0_SAMPLING_RATE; // Sampling rate value ,Maximum value is 2.5msps (2500000)
  adcChConfig.pos_inp_sel[0]   = 2;                      // Positive input to ADC from ULP_GPIO4
  adcChConfig.neg_inp_sel[0] =
    2; // Negative input to ADC from ULP_GPIO5,For single ended data aqcquisition this parameter not used
  adcChConfig.opamp_gain[0]     = 0;                      // OPAMP gain value if opamp output is one of input to ADC
  adcChConfig.rx_buf[0]         = adc_output_ch0;         // Output buffer
  adcChConfig.num_of_samples[0] = CHANNEL0_SAMPLE_LENGTH; // Number of ADC samples collect for operation

  // Configure the Verf value ADC calibration and enable ADC power gate)
  status = ADC_Init(adcChConfig, adcConfig, callback_handler);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nADC Initialization Failed,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nADC Initialization Success\r\n");
  }

  /* Configure reference voltage for analog peripheral ,here till 2.8V generate by using
     AUX_LDO so more than 2.8V enable LDO bypass mode */
  status = RSI_AUX_RefVoltageConfig(vref_value, battery_status);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Set Reference Voltage to ADC,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nSet Reference Voltage to ADC\r\n");
  }

  status = ADC_ChannelConfig(adcChConfig, adcConfig);
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Configured Parameters to ADC Channels,Error Code : %d\r\n", status);
    return status;
  } else {
    DEBUGOUT("\r\nConfigured Parameters to ADC Channels\r\n");
  }

  DEBUGOUT("\r\nStart ADC\r\n");

#ifdef CHIP_9118
  // Start the ADC block
  status = ADC_Start();
#endif

#ifdef CHIP_9117
  status = ADC_Start(adcConfig);
#endif
  if (status != RSI_OK) {
    DEBUGOUT("\r\nFailed to Start ADC,Error Code : %d\r\n", status);
    return status;
  }

  while (1) {
#ifdef CHIP_9117
    while (!intr_done)
      ;
    intr_done = 0;
#endif
    // wait for two ADC cycle before reading ADC sample,here ADC sampling rate=1M so 1 ADC Cycle=1us
    adc_output_ch0[0] = RSI_ADC_ReadDataStatic(AUX_ADC_DAC_COMP, 1, adcChConfig.input_type[0]);

    if (adc_output_ch0[0] & BIT(11)) {
      adc_output_ch0[0] = (adc_output_ch0[0] & (ADC_MASK_VALUE));
    } else {
      adc_output_ch0[0] = adc_output_ch0[0] | BIT(11);
    }

    DEBUGOUT("ADC Output :%d\n", adc_output_ch0[0]);

    vout = (((float)adc_output_ch0[0] / (float)4096) * vref_value);

    if (adcChConfig.input_type[0]) {
      vout = vout - (vref_value / 2);
      DEBUGOUT("Differential ended input  :%f\n", vout);
    } else {
      DEBUGOUT("Single ended input :%f\n", vout);
    }
#ifdef CHIP_9117
    RSI_ADC_ChnlIntrUnMask(AUX_ADC_DAC_COMP, 0, adcConfig.operation_mode);
#endif
  }
}
