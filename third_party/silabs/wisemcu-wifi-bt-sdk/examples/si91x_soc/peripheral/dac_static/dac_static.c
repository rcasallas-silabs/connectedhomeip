/*******************************************************************************
* @file  dac_static.c
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
#include "rsi_bod.h"
#include "aux_reference_volt_config.h"

/* User Configurable MACROs */
#define SAMPLING_RATE 500000
float vref                   = 2.8;  // Reference voltage of LDO, Min is 1.8V and Max is 3.3V
int16_t input_sample_data[1] = { 0x33A };
#ifdef CHIP_9117
volatile uint8_t intr_occur;
#endif

/**
 * @brief  Event call back function..
 * @retval None
 */
void dac_callback(uint8_t event)
{
  /* Call back function never call in DAC static mode */
#ifdef CHIP_9117
  intr_occur = 1;
#endif
}
/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int main(void)
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
	 * this is done through SystemInit() function which is called from startup
	 * file (startup_rs1xxxx.s) before to branch to application main.
	 * To reconfigure the default setting of SystemInit() function, refer to
	 * system_rs1xxxx.c file
	 */
  volatile uint32_t achived_sampling_rate = 0;
  float battery_status;
  float max_ip_volt_scdc = 2.4;

  SystemCoreClockUpdate();

  /* Read the input supply of chip */
  battery_status = RSI_BOD_SoftTriggerGetBatteryStatus();

  /*If input to chip less than 2.4V then switch input voltage supply from SCDC to HPLDO */
  if (battery_status < max_ip_volt_scdc) {
    RSI_IPMU_ProgramConfigData(hp_ldo_voltsel);
  }

  /* Initialize DAC */
  achived_sampling_rate = DAC_Init(STATIC_MODE_EN, SAMPLING_RATE, dac_callback);

  /* Configure reference voltage for analog peripheral ,here till 2.8V generate by using 
	   AUX_LDO so more than 2.8V enable LDO bypass mode */
  RSI_AUX_RefVoltageConfig(vref, battery_status);

  DAC_Start(STATIC_MODE_EN);

  DAC_WriteData(STATIC_MODE_EN, input_sample_data, 1);

#ifdef CHIP_9117
  while (!intr_occur)
    ;
  intr_occur = 0;
#endif

  while (1)
    ;
}
