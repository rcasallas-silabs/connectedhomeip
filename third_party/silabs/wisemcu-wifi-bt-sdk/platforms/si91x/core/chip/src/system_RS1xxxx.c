/*******************************************************************************
* @file  system_RS1xxxx.c
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

/**
 * Includes
 */

#include <stdint.h>
#include "system_RS1xxxx.h"
#include "rsi_error.h"
#include "rsi_ccp_common.h"
#include "rsi_chip.h"
#include "rsi_ps_ram_func.h"
/*----------------------------------------------------------------------------
  Define clocks
 *----------------------------------------------------------------------------*/
#define __SYSTEM_CLOCK 32000000 // 32MhzMhz Reference clock

/*Cortex-m4 FPU registers*/
#define FPU_CPACR       0xE000ED88
#define SCB_MVFR0       0xE000EF40
#define SCB_MVFR0_RESET 0x10110021
#define SCB_MVFR1       0xE000EF44
#define SCB_MVFR1_RESET 0x11000011

/*Simulation macros*/
#define SIMULATION_SILICON_REV  0x14
#define SIMULATION_PACKAGE_TYPE 0x1
/*----------------------------------------------------------------------------
  Clock Variable definitions
 *----------------------------------------------------------------------------*/
uint32_t SystemCoreClock = __SYSTEM_CLOCK; /*!< System Clock Frequency (Core Clock)*/

SYSTEM_CLOCK_SOURCE_FREQUENCIES_T system_clocks; /*!< System Clock sources Frequencies */

uint32_t npssIntrState = 0;
uint32_t __sp;
#define MAX_NVIC_REGS 4
uint32_t nvic_enable[MAX_NVIC_REGS] = { 0 };
uint8_t SiliconRev;
uint8_t package_type;
/*----------------------------------------------------------------------------
  Clock functions
 *----------------------------------------------------------------------------*/

#if defined(__CC_ARM) /*------------------ARM CC Compiler -----------------*/
#ifndef TA_DEEP_SLEEP_COMMON_FLASH
/**
 * @fn          __asm  void RSI_PS_SaveCpuContext(void)
 * @brief        This API is used to save the CPU status register into RAM, this API should be used when sleep with RET is required
 * @return       none
 */
__asm void RSI_PS_SaveCpuContext(void)
{
  IMPORT __sp;
  PUSH{ r0 };
  PUSH{ r1 };
  PUSH{ r2 };
  PUSH{ r3 };
  PUSH{ r4 };
  PUSH{ r5 };
  PUSH{ r6 };
  PUSH{ r7 };
  PUSH{ r8 };
  PUSH{ r9 };
  PUSH{ r10 };
  PUSH{ r11 };
  PUSH{ r12 };
  PUSH{ r14 };
  LDR r0, = __sp;
  MRS r1, msp;
  STR r1, [r0];
  WFI;
}
#endif
/**
 * @fn           void RSI_PS_RestoreCpuContext(void)
 * @brief        This API is used to restore the current CPU processing content from (POP) stack
 * @return       none
 */
__asm void RSI_PS_RestoreCpuContext(void)
{
  IMPORT __sp;
  LDR r0, = __sp;
  LDR sp, [r0, #0];
  POP{ r14 };
  POP{ r12 };
  POP{ r11 };
  POP{ r10 };
  POP{ r9 };
  POP{ r8 };
  POP{ r7 };
  POP{ r6 };
  POP{ r5 };
  POP{ r4 };
  POP{ r3 };
  POP{ r2 };
  POP{ r1 };
  POP{ r0 };
  BX LR;
}
#endif /*------------------ARM CC Compiler -----------------*/

#if defined(__GNUC__) /*------------------ GNU Compiler ---------------------*/
#ifndef TA_DEEP_SLEEP_COMMON_FLASH
/**
 * @fn           void RSI_PS_SaveCpuContext(void)
 * @brief        This API is used to save the CPU status register into RAM, this API should be used when sleep with RET is required
 * @return       none
 */
void RSI_PS_SaveCpuContext(void)
{
  __asm("push {r0}");
  __asm("push {r1}");
  __asm("push {r2}");
  __asm("push {r3}");
  __asm("push {r4}");
  __asm("push {r5}");
  __asm("push {r6}");
  __asm("push {r7}");
  __asm("push {r8}");
  __asm("push {r9}");
  __asm("push {r10}");
  __asm("push {r11}");
  __asm("push {r12}");
  __asm("push {r14}");

  /*R13 Stack pointer */
  __asm("mov %0, sp\n\t" : "=r"(__sp));
  __asm("WFI");
}
#endif
/**
 * @fn           void RSI_PS_RestoreCpuContext(void)
 * @brief        This API is used to restore the current CPU processing content from (POP) stack
 * @return       none
 */
void RSI_PS_RestoreCpuContext(void)
{
  __asm("ldr r0 , =__sp");
  __asm("ldr sp , [r0 , #0]");
  __asm("pop {r14}");
  __asm("pop {r12}");
  __asm("pop {r11}");
  __asm("pop {r10}");
  __asm("pop {r9}");
  __asm("pop {r8}");
  __asm("pop {r7}");
  __asm("pop {r6}");
  __asm("pop {r5}");
  __asm("pop {r4}");
  __asm("pop {r3}");
  __asm("pop {r2}");
  __asm("pop {r1}");
  __asm("pop {r0}");
}
#endif /*------------------ GNU Compiler ---------------------*/

#if defined(__ICCARM__) /*------------------ IAR Compiler ---------------------*/
/**
 * @fn           void RSI_PS_SaveCpuContext(void)
 * @brief        This API is used to save the CPU status register into RAM, this API should be used when sleep with RET is required
 * @return       none
 */
void RSI_PS_SaveCpuContext(void)
{
  __asm("push {r0}");
  __asm("push {r1}");
  __asm("push {r2}");
  __asm("push {r3}");
  __asm("push {r4}");
  __asm("push {r5}");
  __asm("push {r6}");
  __asm("push {r7}");
  __asm("push {r8}");
  __asm("push {r9}");
  __asm("push {r10}");
  __asm("push {r11}");
  __asm("push {r12}");
  __asm("push {r14}");

  /*R13 Stack pointer */
  __asm("mov %0, sp\n\t" : "=r"(__sp));
  __asm("WFI");
}

/**
 * @fn           void RSI_PS_RestoreCpuContext(void)
 * @brief        This API is used to restore the current CPU processing content from (POP) stack
 * @return       none
 */
void RSI_PS_RestoreCpuContext(void)
{
  __asm("ldr r0 , =__sp");
  __asm("ldr sp , [r0 , #0]");
  __asm("pop {r14}");
  __asm("pop {r12}");
  __asm("pop {r11}");
  __asm("pop {r10}");
  __asm("pop {r9}");
  __asm("pop {r8}");
  __asm("pop {r7}");
  __asm("pop {r6}");
  __asm("pop {r5}");
  __asm("pop {r4}");
  __asm("pop {r3}");
  __asm("pop {r2}");
  __asm("pop {r1}");
  __asm("pop {r0}");
}
#endif /*------------------ IAR Compiler ---------------------*/

/**
 * @fn     void SystemCoreClockUpdate (void)
 * @brief  Updates the SystemCoreClock with current core Clock
 *         retrieved from cpu registers.
 * @return none
 */
void SystemCoreClockUpdate(void) /* Get Core Clock Frequency      */
{
  retention_boot_status_word_t *retention_reg = (retention_boot_status_word_t *)MCURET_BOOTSTATUS;
  /*Updated the default SOC clock frequency*/
  SystemCoreClock = DEFAULT_32MHZ_RC_CLOCK;
#if (defined(RAM_COMPILATION) && defined(COMMON_FLASH_EN))
  /*Initialize QSPI for RAM based execution for common flash boards  */
  RSI_FLASH_Initialize();
#endif
#ifndef SIMULATION
#if defined(RAM_COMPILATION) && defined(SIMULATION)
  if (retention_reg->product_mode == MCU) {
    SiliconRev   = SIMULATION_SILICON_REV;
    package_type = SIMULATION_PACKAGE_TYPE;
  } else {
    SiliconRev   = SILICON_REV_WMCU;
    package_type = PACKAGE_TYPE_WMCU;
  }
#else
  if (retention_reg->product_mode == MCU) {
    SiliconRev   = SILICON_REV_MCU;
    package_type = PACKAGE_TYPE_MCU;
  } else {
    SiliconRev   = SILICON_REV_WMCU;
    package_type = PACKAGE_TYPE_WMCU;
  }

#endif
  /*Initialize IPMU and MCU FSM blocks */
  RSI_Ipmu_Init();
  /*configures chip supply mode */
  RSI_Configure_Ipmu_Mode();
#endif

  /*Default clock mux configurations */
  RSI_CLK_PeripheralClkEnable3(M4CLK, M4_SOC_CLK_FOR_OTHER_ENABLE);
  RSI_CLK_M4ssRefClkConfig(M4CLK, ULP_32MHZ_RC_CLK);
  RSI_ULPSS_RefClkConfig(ULPSS_ULP_32MHZ_RC_CLK);

  /* Configuring RO-32KHz Clock for BG_PMU */
  RSI_IPMU_ClockMuxSel(1);
  /* Configuring RO-32KHz Clock for LF-FSM */
  RSI_PS_FsmLfClkSel(KHZ_RO_CLK_SEL);
  /* Configuring RC-32MHz Clock for HF-FSM */
  RSI_PS_FsmHfClkSel(FSM_32MHZ_RC);

#if ((defined COMMON_FLASH_EN) && (!(defined(RAM_COMPILATION))))
  /* Before TA is going to power save mode ,set m4ss_ref_clk_mux_ctrl ,
          tass_ref_clk_mux_ctrl, AON domain power supply controls form TA to M4 */

#ifndef M4_PS2_STATE  // this macro is for ps4 to ps2 state
  RSI_Set_Cntrls_To_M4();
#endif

#endif
  /*Update the system clock sources with source generating frequency*/
  system_clocks.m4ss_ref_clk     = DEFAULT_32MHZ_RC_CLOCK;
  system_clocks.ulpss_ref_clk    = DEFAULT_32MHZ_RC_CLOCK;
  system_clocks.soc_pll_clock    = DEFAULT_SOC_PLL_CLOCK;
  system_clocks.modem_pll_clock  = DEFAULT_MODEM_PLL_CLOCK;
  system_clocks.modem_pll_clock2 = DEFAULT_MODEM_PLL_CLOCK;
  system_clocks.intf_pll_clock   = DEFAULT_INTF_PLL_CLOCK;
  system_clocks.soc_clock        = DEFAULT_32MHZ_RC_CLOCK;
  system_clocks.rc_32khz_clock   = DEFAULT_32KHZ_RC_CLOCK;
  system_clocks.rc_32mhz_clock   = DEFAULT_32MHZ_RC_CLOCK;
  system_clocks.ro_20mhz_clock   = DEFAULT_20MHZ_RO_CLOCK;
  system_clocks.ro_32khz_clock   = DEFAULT_32KHZ_RO_CLOCK;
  system_clocks.xtal_32khz_clock = DEFAULT_32KHZ_XTAL_CLOCK;
  system_clocks.doubler_clock    = DEFAULT_DOUBLER_CLOCK;
  system_clocks.rf_ref_clock     = DEFAULT_RF_REF_CLOCK;
  system_clocks.mems_ref_clock   = DEFAULT_MEMS_REF_CLOCK;
  system_clocks.byp_rc_ref_clock = DEFAULT_32MHZ_RC_CLOCK;
  system_clocks.i2s_pll_clock    = DEFAULT_I2S_PLL_CLOCK;
  return;
}

#ifndef TA_DEEP_SLEEP_COMMON_FLASH
/**
 * @fn          error_t RSI_PS_EnterDeepSleep(SLEEP_TYPE_T sleepType , uint8_t lf_clk_mode)
 * @brief     This is the common API to keep the system in sleep state. from all possible active states.
 * @param[in]   sleepType   : selects the retention or non retention mode of processor. refer 'SLEEP_TYPE_T'.
 *                              SLEEP_WITH_RETENTION : When this is used, user must configure the which RAMs to be retained during sleep by using the 'RSI_PS_SetRamRetention()' function.
 * @param[in]   lf_clk_mode : This parameter is used to switch the processor clock from high frequency clock to low-frequency clock. This is used in some critical power save cases.
 *                            0: 'DISABLE_LF_MODE' Normal mode of operation , recommended in most of the applications.
 *                            1: 'LF_32_KHZ_RC' Processor clock is configured to low-frequency RC clock
 *                            2: 'LF_32_KHZ_XTAL' Processor clock is configured to low-frequency XTAL clock
 *                            3: 'EXTERNAL_CAP_MODE' Switches the supply to internal cap mode 0.95V.
 * @par           note
 \n User must ensure the selected clocks are active before selecting the 'LF_32_KHZ_RC' and 'LF_32_KHZ_XTAL' clocks to the processor using this API.
 * @return      Returns the execution status.
 */
error_t RSI_PS_EnterDeepSleep(SLEEP_TYPE_T sleepType, uint8_t lf_clk_mode)
{
  volatile int var = 0, enable_sdcss_based_wakeup = 0, enable_m4ulp_retention = 0, Temp;
  uint32_t ipmuDummyRead = 0, m4ulp_ram_core_status = 0, m4ulp_ram_peri_status = 0, disable_pads_ctrl = 0, ulp_proc_clk;
  volatile uint8_t in_ps2_state = 0, x = 0;

  /*Save the NVIC registers */
  for (var = 0; var < MAX_NVIC_REGS; ++var) {
    nvic_enable[var] = NVIC->ISER[var];
  }

  /*store the NPSS interrupt mask clear status*/
  npssIntrState = NPSS_INTR_MASK_CLR_REG;

  /*Clear AUX and DAC pg enables */
  if (!((MCU_FSM->MCU_FSM_SLEEP_CTRLS_AND_WAKEUP_MODE_b.SDCSS_BASED_WAKEUP_b)
        || (MCU_FSM->MCU_FSM_SLEEP_CTRLS_AND_WAKEUP_MODE_b.ULPSS_BASED_WAKEUP_b))) {
    RSI_IPMU_PowerGateClr(AUXDAC_PG_ENB | AUXADC_PG_ENB);
  }
  /*Check the PS2 state or not*/
  if (M4_ULP_SLP_STATUS_REG & ULP_MODE_SWITCHED_NPSS) {

    in_ps2_state = 1U;

    if (!((MCU_FSM->MCU_FSM_SLEEP_CTRLS_AND_WAKEUP_MODE_b.SDCSS_BASED_WAKEUP_b)
          || (MCU_FSM->MCU_FSM_SLEEP_CTRLS_AND_WAKEUP_MODE_b.ULPSS_BASED_WAKEUP_b))) {
      disable_pads_ctrl = (ULP_SPI_MEM_MAP(0x141) & BIT(11)); // ULP PADS PDO Status
      ULP_SPI_MEM_MAP(0x141) &= ~(BIT(11));                   // ULP PADS PDO OFF
      enable_sdcss_based_wakeup = 1;
      RSI_PS_SetWkpSources(SDCSS_BASED_WAKEUP);
    }

    if (!(MCU_FSM->MCU_FSM_SLEEP_CTRLS_AND_WAKEUP_MODE_b.M4ULP_RAM_RETENTION_MODE_EN_b)) {
      enable_m4ulp_retention = 1;
      m4ulp_ram_core_status  = RSI_PS_M4ssRamBanksGetPowerSts();
      m4ulp_ram_peri_status  = RSI_PS_M4ssRamBanksGetPeriPowerSts();
      RSI_PS_M4ssRamBanksPowerDown(RAM_BANK_7 | RAM_BANK_8 | RAM_BANK_9);
      RSI_PS_M4ssRamBanksPeriPowerDown(RAM_BANK_7 | RAM_BANK_8 | RAM_BANK_9);
#ifdef CHIP_9118
      RSI_PS_SetRamRetention(M4ULP_RAM_RETENTION_MODE_EN);
#endif
    }
  }
  /*Move to LP mode */
  RSI_IPMU_RetnLdoLpmode();
  if (sleepType == SLEEP_WITHOUT_RETENTION) {
    /*POC1 */
    RSI_IPMU_PocbiasCurrent();
    /*RO32K_00_EFUSE. */
    RSI_IPMU_RO32khzTrim00Efuse();
    /*RETN1 */
    RSI_IPMU_RetnLdoLpmode();
    /*RETN0 */
    RSI_IPMU_RetnLdoVoltsel();
  }
  // Before Sleep
  if (!((in_ps2_state) && (MCU_FSM->MCU_FSM_SLEEP_CTRLS_AND_WAKEUP_MODE_b.ULPSS_BASED_WAKEUP_b))) {
#if (XTAL_CAP_MODE == POWER_TARN_CONDITIONAL_USE)
    if (lf_clk_mode & BIT(4)) {
      RSI_PS_NpssPeriPowerUp(SLPSS_PWRGATE_ULP_MCUTS);
      /*configure the slope,nominal temperature and f2_nominal*/
      RSI_TS_Config(MCU_TEMP, 25);
      /*disable the bjt based temp sensor*/
      RSI_TS_RoBjtEnable(MCU_TEMP, 0);
      /*Enable the RO based temp sensor*/
      RSI_TS_Enable(MCU_TEMP, 1);
      /*update the temperature periodically*/
      RSI_Periodic_TempUpdate(TIME_PERIOD, 1, 0);
      /*read the temperature*/
      Temp = RSI_TS_ReadTemp(MCU_TEMP);
      if (Temp > 45) {
        // disable the XTAL CAP mode
        RSI_IPMU_ProgramConfigData(lp_scdc_extcapmode);
      }
    }
#endif

#if (XTAL_CAP_MODE == POWER_TARN_ALWAYS_USE)
    // disable the XTAL CAP mode
    RSI_IPMU_ProgramConfigData(lp_scdc_extcapmode);
#endif
  }

  if (!((lf_clk_mode == HF_MHZ_RO))) {
    /*Clear IPMU BITS*/
    RSI_PS_LatchCntrlClr(LATCH_TOP_SPI | LATCH_TRANSPARENT_HF | LATCH_TRANSPARENT_LF);
  }

  ipmuDummyRead = MCU_FSM->MCU_FSM_CLK_ENS_AND_FIRST_BOOTUP;

  /*Update the SCB with Deep sleep BIT */
  SCB->SCR = 0x4;

  if (in_ps2_state) {
    /*Read processor clock */
    ulp_proc_clk = ULPCLK->ULP_TA_CLK_GEN_REG_b.ULP_PROC_CLK_SEL;

    /*LF processor clock configuration */
    switch (lf_clk_mode & 0x7) {
      case DISABLE_LF_MODE:
        /*Do nothing*/
        break;
      case LF_32_KHZ_RC:
        ULPCLK->ULP_TA_CLK_GEN_REG_b.ULP_PROC_CLK_SEL = 2U;
        break;
      case LF_32_KHZ_XTAL:
        ULPCLK->ULP_TA_CLK_GEN_REG_b.ULP_PROC_CLK_SEL = 3U;
        break;
      case HF_MHZ_RO:
        ULPCLK->ULP_TA_CLK_GEN_REG_b.ULP_PROC_CLK_SEL = 5U;
        break;
      default:
        return INVALID_PARAMETERS;
    }
    /* HF processor clock */
  }

#if ((defined COMMON_FLASH_EN) && (!(defined(RAM_COMPILATION))))
  /* Reset M4_USING_FLASH bit before going to sleep */
  M4SS_P2P_INTR_CLR_REG = M4_USING_FLASH;
  /*Before M4 is going to deep sleep , set m4ss_ref_clk_mux_ctrl ,tass_ref_clk_mux_ctr, AON domain power supply controls form M4 to TA */
  RSI_Set_Cntrls_To_TA();
#endif

  /*Enter sleep with retention*/
  if (sleepType == SLEEP_WITH_RETENTION) {
    /*If retention mode is enabled save the CPU context*/
    RSI_PS_SaveCpuContext();
  } else {
    /*Clear RAM retentions*/
    RSI_PS_ClrRamRetention(M4ULP_RAM16K_RETENTION_MODE_EN | TA_RAM_RETENTION_MODE_EN | M4ULP_RAM_RETENTION_MODE_EN
                           | M4SS_RAM_RETENTION_MODE_EN);
    /*do not save CPU context and go to deep sleep */
    __asm("WFI");
  }

  /*Restore the default value to the processor clock */
  if ((in_ps2_state)) {
    ULPCLK->ULP_TA_CLK_GEN_REG_b.ULP_PROC_CLK_SEL = ulp_proc_clk;
  }

#if ((defined COMMON_FLASH_EN) && (!(defined(RAM_COMPILATION))))
  /* Before TA is going to power save mode, set m4ss_ref_clk_mux_ctrl ,tass_ref_clk_mux_ctrl ,AON domain power supply controls form TA to M4 */
  RSI_Set_Cntrls_To_M4();
#endif
  /*Update the REG Access SPI division factor to increase the SPI read/write speed*/
  if (lf_clk_mode == HF_MHZ_RO) {
    RSI_SetRegSpiDivision(0U);
  } else {
    RSI_SetRegSpiDivision(1U);
  }
  /*IPMU dummy read to make IPMU block out of RESET*/
  ipmuDummyRead = ULP_SPI_MEM_MAP(0x144);
  // After Wakeup
  if (!((in_ps2_state) && (MCU_FSM->MCU_FSM_SLEEP_CTRLS_AND_WAKEUP_MODE_b.ULPSS_BASED_WAKEUP_b))) {
#if (XTAL_CAP_MODE == POWER_TARN_CONDITIONAL_USE)
    if (lf_clk_mode & BIT(4)) {
      // disable the XTAL CAP mode
      RSI_PS_NpssPeriPowerUp(SLPSS_PWRGATE_ULP_MCUTS);
      /*configure the slope,nominal temperature and f2_nominal*/
      RSI_TS_Config(MCU_TEMP, 25);
      /*disable the bjt based temp sensor*/
      RSI_TS_RoBjtEnable(MCU_TEMP, 0);
      /*Enable the RO based temp sensor*/
      RSI_TS_Enable(MCU_TEMP, 1);
      /*update the temperature periodically*/
      RSI_Periodic_TempUpdate(TIME_PERIOD, 1, 0);
      /*read the temperature*/
      Temp = RSI_TS_ReadTemp(MCU_TEMP);
      if (Temp > 45) {
        //SCDC0
        RSI_IPMU_ProgramConfigData(scdc_volt_sel1);
        RSI_IPMU_ProgramConfigData(scdc_volt_trim_efuse);
        //SCDC0_1
        RSI_IPMU_ProgramConfigData(scdc_volt_sel2);
      }
    }
#endif

#if (XTAL_CAP_MODE == POWER_TARN_ALWAYS_USE)
    // disable the XTAL CAP mode
    //SCDC0
    RSI_IPMU_ProgramConfigData(scdc_volt_sel1);
    RSI_IPMU_ProgramConfigData(scdc_volt_trim_efuse);
    //SCDC0_1
    RSI_IPMU_ProgramConfigData(scdc_volt_sel2);
#endif
  }
  if (!(lf_clk_mode == HF_MHZ_RO)) {
    /*Spare register write sequence*/
    ipmuDummyRead          = ULP_SPI_MEM_MAP(0x1C1);
    ULP_SPI_MEM_MAP(0x141) = ipmuDummyRead;

    ipmuDummyRead          = ULP_SPI_MEM_MAP(0x1C0);
    ULP_SPI_MEM_MAP(0x140) = ipmuDummyRead;
    RSI_PS_LatchCntrlSet(LATCH_TOP_SPI);
  }
  if (in_ps2_state) {
    /*Come out  of LP  mode */
    /* enabling the RETN_LDO HP MODE */
    RSI_IPMU_RetnLdoHpmode();
  }
  if (sleepType == SLEEP_WITHOUT_RETENTION) {
    /* 	Increasing the bias current of RETN_LDO */
    RSI_IPMU_PocbiasCurrent11();
    RSI_IPMU_RO32khz_TrimEfuse();
    /* enabling the RETN_LDO HP MODE */
    RSI_IPMU_RetnLdoHpmode();
  }
  /*I2S-PLL Bypass*/
  *(volatile uint32_t *)(0x24041400 + 0x3C) |= BIT(0);

  if (enable_sdcss_based_wakeup) {
    RSI_PS_ClrWkpSources(SDCSS_BASED_WAKEUP);
    enable_sdcss_based_wakeup = 0;
  }
  if (enable_m4ulp_retention) {
    RSI_PS_M4ssRamBanksPowerUp(m4ulp_ram_core_status);
    RSI_PS_M4ssRamBanksPeriPowerUp(m4ulp_ram_peri_status);
    enable_m4ulp_retention = 0;
  }
  if (disable_pads_ctrl) {
    ULP_SPI_MEM_MAP(0x141) |= (BIT(11)); // ULP PADS PDO ON
    disable_pads_ctrl = 0;
  }

  /*Restore NPSS INTERRUPTS*/
  NPSS_INTR_MASK_CLR_REG = ~npssIntrState;

  /*Restore the ARM NVIC registers */
  for (var = 0; var < MAX_NVIC_REGS; ++var) {
    NVIC->ISER[var] = nvic_enable[var];
  }
#ifndef CHIP_9117
  M4CLK->CLK_ENABLE_SET_REG1_b.M4SS_UM_CLK_STATIC_EN_b = 0x1;
#endif
  for (x = 0; x < 200; x++) {
    __ASM("NOP");
  }
#ifndef CHIP_9117
  M4CLK->CLK_ENABLE_CLR_REG1_b.M4SS_UM_CLK_STATIC_EN_b = 0x1;
#endif
  /* Restore the NPSS domains*/

  return RSI_OK;
}
#endif
/**
 * @fn       void fpuInit(void)
 * @brief    This API is used to Early initialization of the FPU 
 * @return   none 
 *
 */
void fpuInit(void)
{
#if __FPU_PRESENT != 0
  // from arm trm manual:
  //                ; CPACR is located at address 0xE000ED88
  //                LDR.W R0, =0xE000ED88
  //                ; Read CPACR
  //                LDR R1, [R0]
  //                ; Set bits 20-23 to enable CP10 and CP11 coprocessors
  //                ORR R1, R1, #(0xF << 20)
  //                ; Write back the modified value to the CPACR
  //                STR R1, [R0]

  volatile uint32_t *regCpacr = (uint32_t *)FPU_CPACR;
  volatile uint32_t *regMvfr0 = (uint32_t *)SCB_MVFR0;
  volatile uint32_t *regMvfr1 = (uint32_t *)SCB_MVFR1;
  volatile uint32_t Cpacr;
  volatile uint32_t Mvfr0;
  volatile uint32_t Mvfr1;
  char vfpPresent = 0;

  Mvfr0 = *regMvfr0;
  Mvfr1 = *regMvfr1;

  vfpPresent = ((SCB_MVFR0_RESET == Mvfr0) && (SCB_MVFR1_RESET == Mvfr1));

  if (vfpPresent) {
    Cpacr = *regCpacr;
    Cpacr |= (0xF << 20);
    *regCpacr = Cpacr; // enable CP10 and CP11 for full access
  }
#endif /* __FPU_PRESENT != 0 */
}

/**
 * @fn     void SystemInit (void)       
 * @brief  This API is used Setup the RS1xxxx chip(Initialize the system)
 * @return none
 */
void SystemInit(void)
{
  volatile uint32_t ipmuDummyRead = 0, bypass_curr_ctrl_reg = 0;
  volatile uint32_t spareReg2 = 0;

  /*IPMU dummy read to make IPMU block out of RESET*/
  ipmuDummyRead = ULP_SPI_MEM_MAP(0x144);
  ipmuDummyRead = ipmuDummyRead;

  /*Update the REG Access SPI division factor to increase the SPI read/write speed*/
  RSI_SetRegSpiDivision(0U);

  ULP_SPI_MEM_MAP(BG_SCDC_PROG_REG_1) &= REF_SEL_LP_DCDC;

  /*Spare register write sequence*/
  spareReg2              = ULP_SPI_MEM_MAP(0x1C1);
  ULP_SPI_MEM_MAP(0x141) = spareReg2;
  //while(GSPI_CTRL_REG1 & SPI_ACTIVE);
  /*Spare register write sequence*/
  spareReg2              = ULP_SPI_MEM_MAP(0x1C0);
  ULP_SPI_MEM_MAP(0x140) = spareReg2;

  /*Set IPMU BITS*/
  ULP_SPI_MEM_MAP(SELECT_BG_CLK) |= (LATCH_TOP_SPI | LATCH_TRANSPARENT_HF | LATCH_TRANSPARENT_LF);

  while (GSPI_CTRL_REG1 & SPI_ACTIVE)
    ;

  MCU_AON->MCUAON_GEN_CTRLS_b.ENABLE_PDO      = 1;
  MCU_AON->MCUAON_GEN_CTRLS_b.NPSS_SUPPLY_0P9 = 0;

  /*Enable FPU*/
  fpuInit();

  /* Enable REF Clock Control*/
  //FIXME: This will be configured by boot-loader based on product mode
  *(volatile uint32_t *)0x41300004 = BIT(24);

  /*Moving to BG sampling mode */
  *(volatile uint32_t *)0x24048140 = (BIT(19) | BIT(1) | BIT(0));

  /*Disable WIC based wake up */
  MCU_FSM->MCU_FSM_PERI_CONFIG_REG_b.WICENREQ = 0;

  /*Set ulp_wakeup_por*/
  MCU_AON->MCUAON_KHZ_CLK_SEL_POR_RESET_STATUS_b.MCU_FIRST_POWERUP_POR     = 1U;
  MCU_AON->MCUAON_KHZ_CLK_SEL_POR_RESET_STATUS_b.MCU_FIRST_POWERUP_RESET_N = 1U;
  /*Programmable delay 4mes for WDT reset */
  PMU_DIRECT_ACCESS(BG_SLEEP_TIMER_REG_OFFSET) |= BIT(19); //bgs_active_timer_sel
  /*Programmable delay 4mes for WDT reset */
  MCU_AON->MCUAON_SHELF_MODE_b.SHELF_MODE_WAKEUP_DELAY = 0x7;
  /* Enables software based control of isolation and reset for ULP AON */
  BATT_FF->M4SS_BYPASS_PWRCTRL_REG1_b.BYPASS_M4SS_PWRCTL_ULP_AON_b = 1;
  /* Enables software based control of isolation and reset for M4ss CORE */
  BATT_FF->M4SS_BYPASS_PWRCTRL_REG1_b.BYPASS_M4SS_PWRCTL_ULP_M4_CORE_b = 1;
  return;
}
/**
 *@}
 */
