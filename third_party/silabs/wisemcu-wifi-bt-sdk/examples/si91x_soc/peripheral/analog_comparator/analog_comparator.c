/*******************************************************************************
* @file  rsi_comparator_example.c
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

/* Example Selection MACROs -----------------------------------------------------------*/
#define COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_EXTERNAL   1
#define COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_REF_SCALER 0

/* Private define ------------------------------------------------------------*/
#define COMP1_INTERRUPT_HANDLER IRQ008_Handler /* Comparator1 IRQ handler number */
#define HYST_ENABLE             0
#define FILTER_ENABLE           0
#define NPSS_GPIO_PIN           3
#define GPIO_TOGGLE

#if COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_EXTERNAL
#define COMP1_POSITIVE_INPUT 0 /* Select the ULP_GPIO0 for comparator non-inverting input */
#define COMP1_NEGATIVE_INPUT 0 /* Select the ULP_GPIO1 for comparator inverting input */
#endif

#if COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_REF_SCALER
#define COMP1_POSITIVE_INPUT 0 /* Select the ULP_GPIO0 for comparator non-inverting input */
#define COMP1_NEGATIVE_INPUT 4 /* Select the reference scaler output for comparator inverting input */
#define SCALER_FACT_VAL      7 /* Reference scaler output is 0.8V */
#endif

/* Private variable */
float vref_value = 2.4;        // Reference voltage to LDO, Min is 1.8V and Max is 3.3V

/**
 * @brief  This function is comparator IRQ handler , its disable the comparator IRQ.
 * @param  None
 * @retval None
 */
void COMP1_INTERRUPT_HANDLER(void)
{
  /* Toggle the UULP_GPIO3 for comparator interrupt indication */
  RSI_NPSSGPIO_SetPin(NPSS_GPIO_PIN, 1);
  RSI_NPSSGPIO_SetPin(NPSS_GPIO_PIN, 0);
			#ifdef GPIO_TOGGLE
		// Set pin 0 in GPIO mode
		RSI_EGPIO_SetPinMux(EGPIO1, 0, 5, EGPIO_PIN_MUX_MODE0);
		// Set output direction
		RSI_EGPIO_SetDir(EGPIO1, 0, 5, EGPIO_CONFIG_DIR_OUTPUT);   
		RSI_EGPIO_SetPin(EGPIO1, 0, 5, 1);
		RSI_EGPIO_SetPin(EGPIO1, 0, 5, 0); 
		#endif

  /* Mask the comparator interrupt */
  RSI_COMP_OutputMaskConfig(COMP1, ENABLE);
  /* UnMask the comparator interrupt */
  RSI_COMP_OutputMaskConfig(COMP1, DISABLE);
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
*/
int main()
{
  /* At this stage the MICROCONTROLLER clock setting is already configured,
	 * this is done through SystemInit() function which is called from startup
	 * file (startup_RS1xxxx.c) before to branch to application main.
	 * To reconfigure the default setting of SystemInit() function, refer to
	 * system_RS1xxxx.c file
	*/

  /*Configures the system default clock and power configurations*/
  SystemCoreClockUpdate();

  /* Configure the UULP_GPIO3 for comparator interrupt indication */
  RSI_NPSSGPIO_InputBufferEn(NPSS_GPIO_PIN, 1U);
  RSI_NPSSGPIO_SetPinMux(NPSS_GPIO_PIN, 0);
  RSI_NPSSGPIO_SetDir(NPSS_GPIO_PIN, NPSS_GPIO_DIR_OUTPUT);

  /* Configure the AUX clock source */
  RSI_ULPSS_AuxClkConfig(ULPCLK, ENABLE_STATIC_CLK, ULP_AUX_32MHZ_RC_CLK);

  /*  Configure the reference LDO voltage as 2.48v */
  RSI_AUX_RefVoltageConfig(vref_value, 3.2);

/* Configure the comparator parameters,Here non-inverting input 
	   configured for ULP_GPIO0 and inverting input configured for ULP_GPIO1 */
  RSI_COMP_Config(AUX_ADC_DAC_COMP, COMP1, COMP1_POSITIVE_INPUT, COMP1_NEGATIVE_INPUT, HYST_ENABLE, FILTER_ENABLE);\
  
#if COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_EXTERNAL
  /* enable  the comparator */
  RSI_COMP_Enable(AUX_ADC_DAC_COMP, COMP1, ENABLE);
#endif

#if COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_REF_SCALER
  /* Set the reference scaler factor value set as 7,
	   so inverting terminal input is 0.8V*/
  RSI_COMP_ReferenceScaler(AUX_ADC_DAC_COMP, SCALER_FACT_VAL);
    /* enable  the comparator */
  RSI_COMP_Enable(AUX_ADC_DAC_COMP, COMP1, ENABLE);
#endif

  while (1)
    ;
}
