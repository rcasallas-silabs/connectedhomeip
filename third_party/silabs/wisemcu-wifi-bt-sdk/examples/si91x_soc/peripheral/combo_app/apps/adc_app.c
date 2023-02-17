/*******************************************************************************
 * @file  adc_app.c
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
/*************************************************************************
 *
 */

/*================================================================================
 * @brief   This example enable the multiple ADC channels with different sampling rate.
=================================================================================*/

/*Includes*/
#include "adc_app.h"
#ifdef RSI_WITH_OS
#include "rsi_os.h"
#endif

/* Private define ------------------------------------------------------------*/
#define CORE_CLOCK_180MHZ \
    1                        /* This define use for enable core clock to 180Mhz ,
CORE_CLOCK_180MHZ : 1 ; Core clock is 180Mhz SOC PLL
CORE_CLOCK_180MHZ : 0 ; Core clock is 32Mhz RC
     */
#define NUMBER_OF_CHA_EN 3 /* Number of ADC channel enable for ADC operation */
#ifdef CHIP_9118
#define CHANNEL0_SAMPLE_LENGTH 1024 /* Number of ADC sample collect for channel0 */
#define CHANNEL1_SAMPLE_LENGTH 1024 /* Number of ADC sample collect for channel1*/
#define CHANNEL2_SAMPLE_LENGTH 1024 /* Number of ADC sample collect for channel2 */
#endif
#ifdef CHIP_9117
#define CHANNEL0_SAMPLE_LENGTH 1023 /* Number of ADC sample collect for channel0 */
#define CHANNEL1_SAMPLE_LENGTH 1023 /* Number of ADC sample collect for channel1*/
#define CHANNEL2_SAMPLE_LENGTH 1023 /* Number of ADC sample collect for channel2 */
#endif

#define CHANNEL0_SAMPLING_RATE 100000 /* Number of ADC sample collect for channel0 */
#define CHANNEL1_SAMPLING_RATE 100000  /* Number of ADC sample collect for channel1*/
#define CHANNEL2_SAMPLING_RATE 100000  /* Number of ADC sample collect for channel2 */

float vref_value = 2.8; /* Reference voltage to ADC for conversion operation */

#define ENOB
#ifdef CHIP_9117
#define adc_ping_buffer0 0x0000F000
#define adc_pong_buffer0 (0x0000F000 + CHANNEL0_SAMPLE_LENGTH)

#define adc_ping_buffer1 0x00010000
#define adc_pong_buffer1 (0x00010000 + CHANNEL1_SAMPLE_LENGTH)

#define adc_ping_buffer2 0x00011000
#define adc_pong_buffer2 (0x00011000 + CHANNEL2_SAMPLE_LENGTH)

#endif

/* Private variables ---------------------------------------------------------*/
volatile uint8_t intr_done           = 0;
volatile uint8_t chnl0_complete_flag = 0;
volatile uint8_t chnl1_complete_flag = 0;
volatile uint8_t chnl2_complete_flag = 0;

/* Private output buffer ---------------------------------------------------------*/
int16_t adc_output_ch0[CHANNEL0_SAMPLE_LENGTH];
int16_t adc_output_ch1[CHANNEL1_SAMPLE_LENGTH];
int16_t adc_output_ch2[CHANNEL2_SAMPLE_LENGTH];

/* Configured sampling rate buffer */
uint32_t achived_sampling_rate[NUMBER_OF_CHA_EN];

#ifdef ENOB
int16_t adc_channel0_result[CHANNEL0_SAMPLE_LENGTH * 2];
int16_t adc_channel1_result[CHANNEL1_SAMPLE_LENGTH * 2];
int16_t adc_channel2_result[CHANNEL2_SAMPLE_LENGTH * 2];
static uint8_t adc_channel0_flag;
static uint8_t adc_channel1_flag;
static uint8_t adc_channel2_flag;
uint32_t index1   = 0;
uint32_t ch0_incr = 0;
uint32_t ch1_incr = 0;
uint32_t ch2_incr = 0;
#endif

/* Core clock modification APIs */
#if CORE_CLOCK_180MHZ
#define SOC_PLL_REF_FREQUENCY 32000000 /*<! PLL input REFERENCE clock 32MHZ */
//Note: Change this macro to required PLL frequency in hertz
#define PS4_SOC_FREQ          180000000 /*<! PLL out clock 180MHz            */
#define CONFIG_PREFETCH_LIMIT 120000000

/*Pre-fetch and regestring */
#define ICACHE2_ADDR_TRANSLATE_1_REG  *(volatile uint32_t *)(0x20280000 + 0x24)
#define MISC_CFG_SRAM_REDUNDANCY_CTRL *(volatile uint32_t *)(0x46008000 + 0x18)
#define MISC_CONFIG_MISC_CTRL1        *(volatile uint32_t *)(0x46008000 + 0x44)
#define SWITCH_QSPI_TO_SOC_PLL

#ifdef RSI_WITH_OS
extern rsi_semaphore_handle_t pwm_thread_sem ,adc_thread_sem;
#endif
/**
 * @brief  This function is callback function to reconfigure ping and pong address.
 * @param  channel_no  :  Channel number
 * @param  event       :  Event type 
 * @retval None
 */
void soc_pll_config(void)
{
  /*Default keep M4 in reference clock*/
  RSI_CLK_M4SocClkConfig(M4CLK, M4_ULPREFCLK, 0);
#if (PS4_SOC_FREQ >= CONFIG_PREFETCH_LIMIT)
  /*Configure the prefetch and registering when SOC clock is more than 120Mhz*/
  /*Configure the SOC PLL to 220MHz*/
  ICACHE2_ADDR_TRANSLATE_1_REG = BIT(21); //Icache registering when clk freq more than 120
  /*When set, enables registering in M4-TA AHB2AHB. This will have performance penalty. This has to be set above 100MHz*/
  MISC_CFG_SRAM_REDUNDANCY_CTRL = BIT(4);
  MISC_CONFIG_MISC_CTRL1 |= BIT(4); //Enable Register ROM as clock frequency is 200 Mhz
#endif
  /*Configure the PLL frequency*/
  RSI_CLK_SetSocPllFreq(M4CLK, PS4_SOC_FREQ, SOC_PLL_REF_FREQUENCY);

  /*Switch M4 clock to PLL clock for speed operations*/
  RSI_CLK_M4SocClkConfig(M4CLK, M4_SOCPLLCLK, 0);
#ifdef SWITCH_QSPI_TO_SOC_PLL
  ROMAPI_M4SS_CLK_API->clk_qspi_clk_config(M4CLK, QSPI_SOCPLLCLK, 0, 0, 0);
#endif
  /* Switch ULP Pro clock to 90 MHZ */
  RSI_ULPSS_ClockConfig(M4CLK, 1, 1, 0);
}
#endif

#ifdef CHIP_9117
/**
 * @brief  Call back function , This function interrupt handler  
 * @param  channel_no  : Channel number for clearing   
 * @retval None
 */
void callback_handler(uint8_t channel_no, uint8_t event)
{
  if (event == INTERNAL_DMA) {
      if (channel_no == ADC_CHNL0_INTR) {
          chnl0_complete_flag++;
      } else if (channel_no == ADC_CHNL1_INTR) {
          chnl1_complete_flag++;
      } else if (channel_no == ADC_CHNL2_INTR) {
          chnl2_complete_flag++;
      }
  }
}
#endif

int ADC_App()
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
   * this is done through SystemInit() function which is called from startup
   * file (startup_rs1xxxx.s) before to branch to application main.
   * To reconfigure the default setting of SystemInit() function, refer to
   * system_rs1xxxx.c file
   */
  int32_t status  = 0;
  uint8_t forever = 1;
  uint8_t ch_incr;
  float battery_status;
  float max_ip_volt_scdc = 2.4;

  adc_ch_config_t adcChConfig;
  adc_config_t adcConfig;

  /* Read the input supply of chip */
  battery_status = RSI_BOD_SoftTriggerGetBatteryStatus();

  /*If input to chip less than 2.4V then switch input voltage supply from SCDC to HPLDO */
  if (battery_status < max_ip_volt_scdc) {
      RSI_IPMU_ProgramConfigData(hp_ldo_voltsel);
  }

#if CORE_CLOCK_180MHZ
  /* Increase M4 Clock */
  soc_pll_config();
#endif

  /* Configure ADC module related parameter */
  adcConfig.num_of_channel_enable = NUMBER_OF_CHA_EN; /* Number of channel enable for ADC operation,here enable two ADC channel */
  adcConfig.operation_mode = ADC_FIFOMODE_ENABLE; /* ADC operation mode */

  /* Configure ADC channels related parameter */
  adcChConfig.input_type[0]    = 0;                      /* Single ended input to ADC Channel0 */
  adcChConfig.sampling_rate[0] = CHANNEL0_SAMPLING_RATE; /* Sampling rate for channel0 */
  adcChConfig.pos_inp_sel[0]   = POS6;                      /* Positive input to channel0 from ULP_GPIO4 */
  adcChConfig.neg_inp_sel[0]   = 2; /* Negative input to ADC from ULP_GPIO5,For single ended data acquisition this parameter not used */
  adcChConfig.opamp_gain[0]     = 0;                      /* OPAMP gain value if opamp output is one of input to ADC*/
  adcChConfig.rx_buf[0]         = adc_output_ch0;         /* Channel0 output buffer */
  adcChConfig.num_of_samples[0] = CHANNEL0_SAMPLE_LENGTH; /* Number of ADC samples collect for channel0 */
#ifdef CHIP_9117
  adcChConfig.chnl_ping_address[0] = adc_ping_buffer0; /* ADC Channel 0 Ping address */
  adcChConfig.chnl_pong_address[0] = adc_pong_buffer0; /* ADC Channel 0 Pong address */
#endif

  adcChConfig.input_type[1]    = 0;                      /* Single ended input to ADC Channel1 */
  adcChConfig.sampling_rate[1] = CHANNEL1_SAMPLING_RATE; /* Sampling rate for channel1 */
  adcChConfig.pos_inp_sel[1]   = POS7;                     /* Positive input to channel1 from ULP_GPIO5 */
  adcChConfig.neg_inp_sel[1] =  2; /* Negative input to ADC from ULP_GPIO5,For single ended data acquisition this parameter not used */
  adcChConfig.opamp_gain[1]     = 0;                      /* OPAMP gain value if opamp output is one of input to ADC*/
  adcChConfig.rx_buf[1]         = adc_output_ch1;         /* Channel1 output buffer */
  adcChConfig.num_of_samples[1] = CHANNEL1_SAMPLE_LENGTH; /* Number of ADC samples collect for channel1 */
#ifdef CHIP_9117
  adcChConfig.chnl_ping_address[1] = adc_ping_buffer1; /* ADC Channel 1 Ping address */
  adcChConfig.chnl_pong_address[1] = adc_pong_buffer1; /* ADC Channel 1 Pong address */
#endif

  adcChConfig.input_type[2]    = 0;                      /* Single ended input to ADC Channel2 */
  adcChConfig.sampling_rate[2] = CHANNEL2_SAMPLING_RATE; /* Sampling rate for channel2 */
  adcChConfig.pos_inp_sel[2]   = POS8;                      /* Positive input to channel2 from ULP_GPIO6 */
  adcChConfig.neg_inp_sel[2] = 2; /* Negative input to ADC from ULP_GPIO5,For single ended data acquisition this parameter not used */
  adcChConfig.opamp_gain[2]     = 0;                      /* OPAMP gain value if opamp output is one of input to ADC*/
  adcChConfig.rx_buf[2]         = adc_output_ch2;         /* Channel2 output buffer */
  adcChConfig.num_of_samples[2] = CHANNEL2_SAMPLE_LENGTH; /* Number of ADC samples collect for channel2 */
#ifdef CHIP_9117
  adcChConfig.chnl_ping_address[2] = adc_ping_buffer2; /* ADC Channel 2 Ping address */
  adcChConfig.chnl_pong_address[2] = adc_pong_buffer2; /* ADC Channel 2 Pong address */
#endif

  /* Configure the Verf value ADC calibration and enable ADC power gate)*/
  status = ADC_Init(adcChConfig, adcConfig, callback_handler);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nADC Initialization Failed,Error Code : %d\r\n", status);
      return status;
  }
  /* Configure reference voltage for analog peripheral ,here till 2.8V generate by using
	   AUX_LDO so more than 2.8V enable LDO bypass mode */
  status = RSI_AUX_RefVoltageConfig(vref_value, battery_status);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Set Reference Voltage to ADC,Error Code : %d\r\n", status);
      return status;
  }

  status = ADC_ChannelConfig(adcChConfig, adcConfig);
  if (status != RSI_OK) {
      DEBUGOUT("\r\nFailed to Configured Parameters to ADC Channels,Error Code : %d\r\n", status);
      return status;
  }

  for (ch_incr = 0; ch_incr < NUMBER_OF_CHA_EN; ch_incr++) {
      achived_sampling_rate[ch_incr] = ADC_GetSamplingRate(ch_incr);
  }

status = ADC_Start(adcConfig);
      if (status != RSI_OK) {
          DEBUGOUT("\r\nFailed to Start ADC,Error Code : %d\r\n", status);
          return status;
      }

#ifdef RSI_WITH_OS
  while (forever) {
      rsi_semaphore_wait(&adc_thread_sem, 0);
      DEBUGOUT("\r\ ADC Task\r\n");     
  }
#else
        DEBUGOUT("\r\ ADC Task\r\n");     
#endif
  return 0;
}
