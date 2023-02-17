/*******************************************************************************
* @file  ulp_ir_decoder.c
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
/**============================================================================
 * @brief : This file contains example application for ir_decoder
 * @section Description :
 * This example shows how to use of The ir_decoder with SI917 chip in ULP_mode.
 * IR Decoder sample the input data starting from each rising and falling edge where a bit period counter (period counter) is reset.  
 * At each sample point clocked ad 32KHz clk the period counter is incremented. 
 * This gives a number that represents the period of each high or low part of the signal. 
 =============================================================================**/

/* Includes ------------------------------------------------------------------*/
#include "rsi_chip.h"
#include "rsi_ir.h"
#include "rsi_board.h"
/* Private typedef -----------------------------------------------------------*/

#define RESERVED_IRQ_COUNT    16
#define EXT_IRQ_COUNT         98
#define VECTOR_TABLE_ENTRIES (RESERVED_IRQ_COUNT + EXT_IRQ_COUNT) 
uint32_t ramVector[VECTOR_TABLE_ENTRIES] __attribute__ ((aligned(256)));

/* Private macro -------------------------------------------------------------*/
#ifdef CHIP_9118
#define NVIC_IR IR_DECODER_IRQ
#endif
#ifdef CHIP_9117
#define NVIC_IR IR_DECODER_IRQn
#endif
/* Private define ------------------------------------------------------------*/
#define IR_OFF_DURATION         0x100
#define IR_ON_DURATION          0x10
#define IR_FRAME_DONE_THRESHOLD 0x2F
#define IR_DET_THRESHOLD        0x5
#define SOC_OPER_FREQUENCY      32000000
#define RSI_BLINK_RATE          1000
#define SYSTICK_PIN             6       //ULP GPIO PIN
#define TEST_PIN_IR_INPUT       10U
#define TEST_PIN_IR_INPUT_MODE  4U
#define TEST_PIN_IR_OUTPUT      5U
#define TEST_PIN_IR_OUTPUT_MODE 1U
void hardware_setup(void);
/* Private variables ---------------------------------------------------------*/
uint32_t Memlocation_num;
uint16_t ir_data[100];
int status               = 0, a, b;
volatile uint8_t flag    = 0;
volatile uint8_t ir_intr = 0;

/* Private function prototype---------------------------------------------------------*/
void Gpio_Pin_Mux(void);

/**
 * @brief  IR decoder interrupt handler, its clear the pending interrupt.
 * @param  None
 * @retval None
 */
void IRQ015_Handler(void)
{
  /*Clear IRQ*/
  NVIC_ClearPendingIRQ(NVIC_IR);
  ir_intr = 1;
  flag    = 0;
  return;
}

/**
 * @brief  Systic handler to emulate the IR pattern.
 * @param  None
 * @retval None
 */
void SysTick_Handler(void)
{
  static uint8_t toggle = 0;
  /*Emulates IR patterns*/
  if (flag < 10) {
    toggle = !toggle;
    RSI_EGPIO_SetPin(EGPIO1, 0, SYSTICK_PIN, toggle);
  }
  flag++;
  return;
}

/**
 * @brief  Enable the systic pin for input to IR.
 * @param  None
 * @retval None
 */
void Gpio_Pin_Mux(void)
{
  RSI_EGPIO_PadSelectionEnable(1);
  RSI_EGPIO_SetPinMux(EGPIO1, 0, SYSTICK_PIN, EGPIO_PIN_MUX_MODE0);
  RSI_EGPIO_SetDir(EGPIO1, 0, SYSTICK_PIN, EGPIO_CONFIG_DIR_OUTPUT);
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int main(void)
{
  uint16_t i = 0;

  /*Configures the system default clock and power configurations*/
  SystemCoreClockUpdate();

  //copying the vector table from flash to ram
  memcpy(ramVector, (uint32_t*)SCB->VTOR, sizeof(uint32_t) * VECTOR_TABLE_ENTRIES);

  //assing the ram vector adress to VTOR register
  SCB->VTOR = (uint32_t)ramVector; 

  /* Switching MCU from PS4 to PS2 state */
  hardware_setup();

  DEBUGINIT();

  DEBUGOUT("\r\nConfigured Ulp_ir_decoder Interface\r\n");

  /*Clock enable */
  RSI_IPMU_ClockMuxSel(1);

  RSI_PS_FsmLfClkSel(KHZ_RC_CLK_SEL);

  RSI_PS_FsmHfClkSel(FSM_32MHZ_RC);

  RSI_CLK_PeripheralClkEnable1(M4CLK, ULPSS_CLK_ENABLE);

  /* Configure the ULP-IR clock */
  RSI_ULPSS_UlpPeriClkEnable(ULPCLK, IR_PCLK_EN);

  /* Set the pin mux for systic pattern generation pin */
  Gpio_Pin_Mux();

  /*ULP pad receive enable*/
  RSI_EGPIO_PadSelectionEnable(18);

  RSI_EGPIO_UlpPadReceiverEnable(TEST_PIN_IR_INPUT);

  RSI_EGPIO_UlpPadReceiverEnable(TEST_PIN_IR_OUTPUT);
  /*GPIO Muxing enable */
  RSI_EGPIO_SetPinMux(EGPIO1, 0, TEST_PIN_IR_INPUT, TEST_PIN_IR_INPUT_MODE);

  RSI_EGPIO_SetPinMux(EGPIO1, 0, TEST_PIN_IR_OUTPUT, TEST_PIN_IR_OUTPUT_MODE);

  /*configure the IR off time */
  RSI_IR_OffDuration(IR, IR_OFF_DURATION);
  /*configure the IR on time */
  RSI_IR_OnDuration(IR, IR_ON_DURATION);

  /* define the frame done threshold value */
  RSI_IR_Framedonethreshold(IR, IR_FRAME_DONE_THRESHOLD);

  /* define the detection  threshold value */
  RSI_IR_Detectionthreshold(IR, IR_DET_THRESHOLD);

  /* set the bit of enable clock ir core */
  RSI_IR_SetConfiguration(IR, CONFIG_EN_CLK_IR_CORE);

  /* set the bit for continuous ir detection mode */
  RSI_IR_SetConfiguration(IR, CONFIG_EN_CONT_IR_DET);
  /*enable the IRQ of IR */
  NVIC_EnableIRQ(NVIC_IR);

  /* set the bit for ir detection mode */
  RSI_IR_SetConfiguration(IR, CONFIG_EN_IR_DET);

  /* Set the systic timer to generate the pattern */
  SysTick_Config(SOC_OPER_FREQUENCY / RSI_BLINK_RATE);
  while (1) {
    while (!ir_intr)
      ;
    ir_intr = 0;
    /* Wait for some time to read the data */
    i = 1000;
    while (i--)
      ;
    DEBUGOUT("\r\nIR_decoder inter\r\n");
    Memlocation_num = RSI_IR_GetMemoryDepth(IR);

    for (i = 0; i < Memlocation_num; i++) {
      ir_data[i] = RSI_IR_ReadData(IR, i);
    }
    /* Restart the IR module */
    RSI_IR_SoftwareRestart(IR);
  }
  /*Application code never reach here just to satisfy the standard main*/
}
