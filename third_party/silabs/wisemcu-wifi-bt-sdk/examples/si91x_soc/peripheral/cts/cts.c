/*******************************************************************************
* @file  cts.c
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
 * @brief : This file contains example application for Capacitive touch sensor
 * @section Description :
 * This example shows how to use The capacitive touch sensor (CTS) with SI917 chip.
 * The capacitive touch sensor (CTS) controller is used to detect the position of the touch from the user on the capacitive touch screen. 
 * This is achieved by sensing the change of the capacitor value of the sensor through an analog comparator, digital counter and the supporting circuitry. 
 * The touch is detected by the final count of the digital counter which will be proportional to the capacitor value.
 =============================================================================**/

/* Includes ------------------------------------------------------------------*/
#include "rsi_chip.h"
#include "rsi_board.h"
#include "rsi_cts.h"
#include "rsi_opamp.h"
#include "rsi_ds_timer.h"
#include "UDMA.h"

/* Private macro -------------------------------------------------------------*/
#define NVIC_DST       NPSS_MCU_INTR_IRQn
#define PMU_GOOD_TIME  31 /*Duration in us*/
#define XTAL_GOOD_TIME 31
#define NPSS_GPIO_PIN  3

#define UDMA1_IRQHandler IRQ010_Handler

extern RSI_UDMA_HANDLE_T udmaHandle1; //check
extern uint32_t dma_rom_buff1[30];    //we can keep wrapeers

#define CONTROL_STRUCT0 (UDMA_NUMBER_OF_CHANNELS * 2)
#define CONTROL_STRUCT1 (ULP_UDMA_NUMBER_OF_CHANNELS * 2)
/* Private variables ---------------------------------------------------------*/
#if defined(__CC_ARM)
extern RSI_UDMA_DESC_T UDMA0_Table[CONTROL_STRUCT0];
extern RSI_UDMA_DESC_T UDMA1_Table[CONTROL_STRUCT1];
#endif /* defined (__CC_ARM) */

#if defined(__GNUC__)
extern RSI_UDMA_DESC_T __attribute__((section(".udma_addr0"))) UDMA0_Table[CONTROL_STRUCT0];
extern RSI_UDMA_DESC_T __attribute__((section(".udma_addr1"))) UDMA1_Table[CONTROL_STRUCT1];
#endif /* defined (__GNUC__) */

extern UDMA_Channel_Info udma1_chnl_info[12];

/* UDMA1 Resources */
extern UDMA_RESOURCES UDMA1_Resources;

volatile uint32_t done, ret;

uint16_t Samples[NO_OF_SLOW_SAMPLES];         // __attribute__((at(0x24063800)));
uint16_t Avg_Samples[NO_OF_SLOW_AVG_SAMPLES]; // __attribute__((at(0x240638C8)));
uint8_t sensor_count[8];                      // __attribute__((at(0x24063FD0)));
uint16_t rx_buffer[BUFFER_SIZE];              // __attribute__((at(0x24063000)));

extern uint32_t Threshold;
extern uint32_t sample_count;
extern uint32_t avg_count;
extern uint32_t default_cal;
extern uint32_t calib;
extern uint32_t Ref_voltage;

uint32_t sample_sum = 0, sample_avg;

uint16_t read_data_fifo[64] = { 0 }, status = 0;
uint32_t i                 = 0;
volatile uint32_t cts_done = 0;

/* Private prototypes ---------------------------------------------------------*/
//void hardware_setup(void);

/* Private functions ---------------------------------------------------------*/
/**
 * @brief      UDMA  controller transfer descriptor chain complete callback 
 * @param[in]  event dma transfer events
 * @param[in]  ch    dma channel number
 * @return     None
 */
void udmaTransferComplete(uint32_t event, uint8_t ch)
{
  if (event == UDMA_EVENT_XFER_DONE) {
    if (ch == 9) {
      done = 1;
    }
  }
}

/*udma data read from fifo*/
void UDMA_Read()
{
  RSI_UDMA_CHA_CONFIG_DATA_T control;
  RSI_UDMA_CHA_CFG_T config;

  memset(&control, 0, sizeof(RSI_UDMA_CHA_CONFIG_DATA_T));
  memset(&config, 0, sizeof(RSI_UDMA_CHA_CFG_T));

  config.altStruct       = 0;
  config.burstReq        = 1;
  config.channelPrioHigh = 0;
  config.periAck         = 0;
  config.periphReq       = 0;
  config.reqMask         = 0;
  config.dmaCh           = 9;

  /* Setup source to desination copy for trigger for memory */
  /* Descriptor configurations */
  control.transferType       = UDMA_MODE_AUTO;
  control.nextBurst          = 0;
  control.totalNumOfDMATrans = BUFFER_SIZE - 1;
  control.rPower             = ARBSIZE_2;
  control.srcProtCtrl        = 0x000;
  control.dstProtCtrl        = 0x000;
  control.srcSize            = SRC_SIZE_16;
  control.srcInc             = SRC_INC_NONE;
  control.dstSize            = DST_SIZE_16;
  control.dstInc             = DST_INC_16;

  /* Initialise dma */
  udmaHandle1 = UDMAx_Initialize(&UDMA1_Resources, UDMA1_Table, udmaHandle1, dma_rom_buff1);

  /* Configure dma channel */
  UDMAx_ChannelConfigure(&UDMA1_Resources,
                         9,
                         (uint32_t)0x24042c04,
                         (uint32_t)rx_buffer,
                         BUFFER_SIZE,
                         control,
                         &config,
                         udmaTransferComplete,
                         udma1_chnl_info,
                         udmaHandle1);
  /* Enable dma channel */
  UDMAx_ChannelEnable(9, &UDMA1_Resources, udmaHandle1);
}

/*CAP SENSOR IRQhandler*/
void ULPSS_CAP_SENSOR_IRQHandler(void)
{
  /*Clear interrupt */
  RSI_CTS_IntrClear(CTS);

  RSI_NPSSGPIO_SetPin(2, 1U);

  RSI_NPSSGPIO_SetPin(2, 0U);

  NVIC_DisableIRQ(CAP_SENSOR_IRQn);
  /*5ms delay*/
  for (i = 25000; i > 0; i--)
    ;

  cts_done = 1;

  return;
}

/*CTS application function*/
void RSI_CTS()
{
  while (1) {
    /*enable the clock sources*/
    RSI_ULPSS_UlpPeriClkEnable(ULPCLK, TOUCH_SENSOR_PCLK_ENABLE);

    RSI_ULPSS_TouchClkConfig(ULPCLK, ULP_TOUCH_32MHZ_RC_CLK, 1);
    /*enable static clk*/
    RSI_CTS_StaticClkEnable(CTS, ENABLE);
    /*clk selection for cts operation*/
    RSI_CTS_ClkSelection(CTS, 1, 1, 10, 0);
    /*set the fifo aempty threshold*/
    RSI_CTS_ThresholdProgam(CTS, FIFO_THRESHOLD);
    /*select cts mode of operation*/
    RSI_CTS_ModeSelect(CTS, CONTINUOUS_MODE);
    /*enables sampling mode(averaging)*/
    RSI_CTS_ConfigSampleMode(CTS, ENABLE);
    /*set the buffer delay*/
    RSI_CTS_BufferDelay(CTS, 8);
    /*configure the polynomial length,seed value and polynomial value for generator*/
    RSI_CTS_ConfigPolynomial(CTS, ENABLE, 32, SEED_VALUE, POLYNOMIAL);
    /*bypass the random no generator output*/
    RSI_CTS_BypassPRS(CTS, ENABLE);
    /*config on and off duration of pwm pulse*/
    RSI_CTS_ConfigOnOffTime(CTS, ON_TIME, OFF_TIME);
    /*configures the inter sensor delay and no of repetitions of sample*/
    RSI_CTS_ConfigSampling(CTS, 4, 1);
    /*Configure sampling pattern and valid sensor*/
    RSI_CTS_ConfigSamplingPattern(CTS, SAMPLING_PATTERN, NO_OF_SENSORS);
    /*config ref voltage*/
    RSI_CTS_ConfigRefVoltage(CTS, Ref_voltage, ENABLE, Samples, Avg_Samples);
    /*if average is enabled write 1 to wakeup register*/
    RSI_CTS_ConfigWakeUp(CTS, 1, Threshold);
    //RSI_CTS_ConfigWakeUp(CTS, 1, 150);
    /*if wake interrupt enabled enable the fifo afull interrupt*/
    RSI_CTS_FifoInterruptEnable(CTS, ENABLE);

    /*configure the cts pins*/
    RSI_CTS_PinMuxing();
    /*enable the cts*/
    RSI_CTS_Enable(CTS, ENABLE);

    /*enable NVIC for cap sensor*/
    NVIC_EnableIRQ(CAP_SENSOR_IRQn);

    if (calib) //FAST CALIBRATION IF calib=1 else slow calib
    {
      while (RSI_CTS_GetStatus(CTS) & FIFO_EMPTY_STATUS)
        ;

      UDMA_Read();

      UDMAx_DMAEnable(&UDMA1_Resources, udmaHandle1);

      RSI_UDMA_ChannelSoftwareTrigger(udmaHandle1, 9);

      while (!done)
        ;

      done = 0;

      for (i = 0; i < BUFFER_SIZE; i++) {
        sample_sum += (rx_buffer[i] & 0x0fff);
      }

      sample_avg = (sample_sum / BUFFER_SIZE);

      RSI_CTS_Calibration(sample_avg, Samples, Avg_Samples);

      sample_sum = 0;

      memset(rx_buffer, 0, sizeof(rx_buffer));
    }

    if (calib) {
      continue;
    } else {
      break;
    }
  }
}

/*slow calibration function*/
void RSI_SlowCalibration()
{
  uint32_t read = 0;

  while (RSI_CTS_GetStatus(CTS) & FIFO_EMPTY_STATUS)
    ;

  read = RSI_CTS_ReadFifo(CTS);
  read += read; //dummy operation
  while (RSI_CTS_GetStatus(CTS) & FIFO_EMPTY_STATUS)
    ;

  for (i = 0; i < BUFFER_SIZE; i++) {
    rx_buffer[i] = RSI_CTS_ReadFifo(CTS);
  }

  RSI_CTS_TouchDetection(rx_buffer, sensor_count);

  for (i = 0; i < BUFFER_SIZE; i++) {
    sample_sum += (rx_buffer[i] & 0x0fff);
  }

  sample_avg = (sample_sum / BUFFER_SIZE);

  RSI_CTS_SlowCalibration(sample_avg, Samples, Avg_Samples);

  sample_sum = 0;

  // memset(rx_buffer, 0, sizeof(rx_buffer));
}

/**
 * @brief  Main program.
 * @param  None
 * @retval None
 */
int main()
{
  /*Configures the system default clock and power configurations*/
  SystemCoreClockUpdate();
#ifdef DEBUG_UART
  // DEBUGINIT();
#endif

  sample_count = 0, avg_count = 0, Threshold = 0;
  /*set the sample and avg_samples buffer with 0*/
  memset(Samples, 0, sizeof(Samples));

  memset(Avg_Samples, 0, sizeof(Avg_Samples));

  memset(rx_buffer, 0, sizeof(rx_buffer));
  /*Assign all the varibles with deafult value*/
  default_cal = 1, Ref_voltage = 4, calib = 1;
  //  DEBUGOUT("\r\nConfigured Touch_Sensor Interface\r\n");

  while (1) {
    memset(sensor_count, 0, sizeof(sensor_count));
    RSI_CTS();
    RSI_SlowCalibration();
#ifdef DEBUG_UART

    /*if valid sensor got pressed switch to ps4*/
    if ((sensor_count[0] >= 1) || (sensor_count[1] >= 1) || (sensor_count[2] >= 1) || (sensor_count[3] >= 1)
        || (sensor_count[4] >= 1) || (sensor_count[5] >= 1) || (sensor_count[6] >= 1) || (sensor_count[7] >= 1)) {

      DEBUGINIT();

      for (i = 0; i < 8; i++) {
        if (sensor_count[i] >= 1) {
          DEBUGOUT("\nsensor '%d' is pressed", i + 1);
        }
      }
      memset(rx_buffer, 0, sizeof(rx_buffer));
    }
#endif
    //adding some delay
    for (i = 25000; i > 0; i--)
      ;
  }
}
