/*******************************************************************************
* @file  rsi_qei_example.c
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

/*Includes*/

#include "rsi_chip.h"
#include "rsi_board.h"

/* Private typedef -----------------------------------------------------------*/

/* Private define ------------------------------------------------------------*/
#define QEI_IRQHandler IRQ049_Handler
#define QEI_NVIC_NAME  QEI_IRQn
/* Private macro -------------------------------------------------------------*/
#define RSI_BLINK_RATE       1000     /*<! 1000 ticks per second     */
#define SOC_OPER_FREQUENCY   30000000 /*<! 30Mhz is SOC frequency   */
#define QEI_IDX_PORT         0
#define QEI_PHB_PORT         0
#define QEI_PHA_PORT         0
#define QEI_DIR_PORT         0
#define QEI_IDX_REVOLUTIONS  10
#define QEI_STIMULUS_PHA     7
#define QEI_STIMULUS_PHB     8
#define QEI_STIMULUS_IDX     9
#define QEI_STIMULUS_PORT    0
#define QEI_DELTA_TIME_IN_US 1000000
/* Private variables ---------------------------------------------------------*/
volatile static uint32_t qeiVelocity = 0, qeiMotorRpm = 0, qeiVelocityComputeDone = 0;
/* Private function prototypes -----------------------------------------------*/

/* Private functions ---------------------------------------------------------*/
static void RSI_QEI_StimulusPinMuxInit(void);
static void QEI_EmulatePhaseAndIndexSiganls(void);

/**
 * @brief	QEI interrupt handler
 * @return	Nothing
 */
void QEI_IRQHandler(void)
{
  volatile uint16_t intStatus = 0;

  /*Get interrupt status*/
  intStatus = RSI_QEI_GetIntrStatus(QEI);

  if (intStatus & QEI_POS_CNT_RST_INTR_LVL) {
    /*Clear interrupt */
    RSI_QEI_ClrIntrStatus(QEI, QEI_POS_CNT_RST_INTR_LVL);
  }
  if (intStatus & QEI_IDX_CNT_MAT_INT_LVL) {
    /*Clear interrupt */
    RSI_QEI_ClrIntrStatus(QEI, QEI_IDX_CNT_MAT_INT_LVL);
  }
  if (intStatus & QEI_POS_CNT_ERR_INTR_LVL) {
    /*Clear interrupt */
    RSI_QEI_ClrIntrStatus(QEI, QEI_POS_CNT_ERR_INTR_LVL);
  }
  if (intStatus & QEI_VELO_LESS_THAN_INTR_LVL) {
    /*Clear interrupt */
    RSI_QEI_ClrIntrStatus(QEI, QEI_VELO_LESS_THAN_INTR_LVL);
  }
  if (intStatus & QEI_POS_CNT_MAT_INTR_LVL) {
    /*Clear interrupt */
    RSI_QEI_ClrIntrStatus(QEI, QEI_POS_CNT_MAT_INTR_LVL);
  }
  /*Velocity measurement*/
  if (intStatus & VELOCITY_COMPUTATION_OVER_INTR_LVL) {
    qeiVelocityComputeDone = 1;

    RSI_QEI_IntrMask(QEI, QEI_VEL_COMPUTATION_OVER_INTR_MASK);
    /*Clear interrupt */
    RSI_QEI_ClrIntrStatus(QEI, VELOCITY_COMPUTATION_OVER_INTR_LVL);
    /*Get QEI Velocity */
    qeiVelocity = RSI_QEI_GetVelocity(QEI);
    DEBUGOUT("QEI_Velocity = 0x%X\r\n", qeiVelocity);
    /*Velocity value returns the number of positions in given delta time*/
    /*RPM is number of positions /revolution*/
    qeiMotorRpm = (qeiVelocity / QEI_IDX_REVOLUTIONS);
    /*Start qeiVelocity counter */
    RSI_QEI_StartVelocityCounter(QEI);
  }
  return;
}

/**
 * @brief	Handle interrupt from SysTick timer
 * @return	Nothing
 */
void SysTick_Handler(void)
{
  /*Emulates QEI patterns*/
  QEI_EmulatePhaseAndIndexSiganls();
  return;
}

/**
 * @brief	Generates the QEI patterns of PHASE-A , PHASE-B and INDEX signals on
 *          Some other GPIOs to feed these signals to QEI pins
 * @return	Nothing
 */
static void QEI_EmulatePhaseAndIndexSiganls(void)
{
  static volatile uint8_t x = 0, y = 0, idxCnt = 0;

  if (y == 0) {
    y = 1;
    if (x == 0) {
      x = 1;
      RSI_EGPIO_SetPin(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHA, 1);
    } else {
      x = 0;
      RSI_EGPIO_SetPin(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHA, 0);
    }
  } else {
    y = 0;
    if (x == 0) {
      x = 0;
      idxCnt++;
      RSI_EGPIO_SetPin(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHB, 0);
      if (idxCnt > QEI_IDX_REVOLUTIONS) {
        idxCnt = 0;
        RSI_EGPIO_SetPin(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_IDX, 1);
      }
    } else {
      x = 1;
      RSI_EGPIO_SetPin(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHB, 1);
      RSI_EGPIO_SetPin(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_IDX, 0);
    }
  }
  return;
}
/**
 * @brief	Configures the pin MUX for QEI stimulus pins
 * @return	Nothing
 */
static void RSI_QEI_StimulusPinMuxInit(void)
{
#ifdef CHIP_9118
  /*Pad selection enable */
  RSI_EGPIO_PadSelectionEnable(2);
  RSI_EGPIO_PadSelectionEnable(3);
#endif
#ifdef CHIP_9117
  /*Pad selection enable */
  RSI_EGPIO_PadSelectionEnable(2);
  RSI_EGPIO_PadSelectionEnable(3);
  RSI_EGPIO_PadSelectionEnable(4);
#endif

  /*PAD receive enable */
  RSI_EGPIO_PadReceiverEnable(QEI_STIMULUS_PHA);
  RSI_EGPIO_PadReceiverEnable(QEI_STIMULUS_PHB);
  RSI_EGPIO_PadReceiverEnable(QEI_STIMULUS_IDX);
  /*QEI stimulus pin MUX configuration*/
  RSI_EGPIO_SetPinMux(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHA, EGPIO_PIN_MUX_MODE0);
  RSI_EGPIO_SetPinMux(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHB, EGPIO_PIN_MUX_MODE0);
  RSI_EGPIO_SetPinMux(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_IDX, EGPIO_PIN_MUX_MODE0);
  /*Configure the direction*/
  RSI_EGPIO_SetDir(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHA, EGPIO_CONFIG_DIR_OUTPUT);
  RSI_EGPIO_SetDir(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHB, EGPIO_CONFIG_DIR_OUTPUT);
  RSI_EGPIO_SetDir(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_IDX, EGPIO_CONFIG_DIR_OUTPUT);
  /*Configure the pin value*/
  RSI_EGPIO_SetPin(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHA, 0);
  RSI_EGPIO_SetPin(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_PHB, 1);
  RSI_EGPIO_SetPin(EGPIO, QEI_STIMULUS_PORT, QEI_STIMULUS_IDX, 0);
  return;
}

/**
 * @brief	main application entry
 * @return	Nothing
 */
int main(void)
{
  volatile uint32_t qeiPosition = 0, qeiIdx = 0;
  volatile uint8_t qeiDirection;
  volatile int forever = 0;

  /*Configures the system default clock and power configurations*/
  SystemCoreClockUpdate();

  DEBUGINIT();
  /*Pin MUX INIT */
  RSI_QEI_StimulusPinMuxInit();

  /* Enables pad selection bits,enables receive_enable for the QEI pins and 
         configures the pins for QEI.(enable gpio muxing ) */
  /*Clock enable for QEI*/
  RSI_QEI_Enable(QEI);
  /*Configure the encoding mode*/
  RSI_QEI_SetMode(QEI, QEI_ENCODING_MODE_1X);
  /*Configure the mode of QEI operation */
  /*Swap Phase A and Phase B if required*/
  RSI_QEI_SetConfiguration(QEI, QEI_SWAP_PHASE_AB_B);
  /*Configure the QEI base clock and delta time to compute the velocity*/
  RSI_QEI_ConfigureDeltaTimeAndFreq(QEI, SOC_OPER_FREQUENCY, QEI_DELTA_TIME_IN_US);
  /*Start the velocity counter*/
  RSI_QEI_StartVelocityCounter(QEI);
  /*Interrupt un mask*/
  RSI_QEI_IntrUnMask(QEI, QEI_VEL_COMPUTATION_OVER_INTR_MASK);
  /*Interrupt mask*/
  /*NVIC enable for QEI*/
  NVIC_EnableIRQ(QEI_NVIC_NAME);
  /*Configure the system tick timer to generate the QEI signals*/
  SysTick_Config(SOC_OPER_FREQUENCY / RSI_BLINK_RATE);
  /*Enable NVIC for QEI*/
  forever = 1;
  while (forever) {
    /*Get the position count*/
    qeiPosition = RSI_QEI_GetPosition(QEI);
    /*Get QEI index count*/
    qeiIdx = RSI_QEI_GetIndex(QEI);
    /*Get QEI direction*/
    qeiDirection = RSI_QEI_GetDirection(QEI);
    /**/
    if (qeiVelocityComputeDone) {
      qeiVelocityComputeDone = 0;
      /*Un mask the interrupt for velocity computation*/
      RSI_QEI_IntrUnMask(QEI, QEI_VEL_COMPUTATION_OVER_INTR_MASK);
    }
  }
  return 0;
}
