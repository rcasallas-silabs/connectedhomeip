 /* --------------------------------------------------------------------------
 * Copyright (c) 2013-2016 ARM Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 *
 * Licensed under the Apache License, Version 2.0 (the License); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an AS IS BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 * $Date:        25 Sep 2019
 * $Revision:    V1.1
 *
 * Driver:       Driver_SPI
 * Configured:   via RTE_Device.h configuration file
 * Project:      SPI Driver for RS1xxxx
 */

/* History:
 * Version 1.0
 * Initial release
 */
#include "SPI.h"
#include "UDMA.h"
#include "rsi_rom_udma_wrapper.h" 
#include "rsi_ccp_user_config.h"
#include "clock_update.h"
#include "rsi_spi.h"
#include "rsi_rom_table_rs9116.h"
#if  ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
extern const ROM_SSI_API_T ssi_api;
#endif

extern RSI_UDMA_HANDLE_T udmaHandle0;    //check
extern uint32_t dma_rom_buff0[30],dma_rom_buff1[30];     //we can keep wrapeers

#define CONTROL_STRUCT0   (UDMA_NUMBER_OF_CHANNELS * 2)
#define CONTROL_STRUCT1   (ULP_UDMA_NUMBER_OF_CHANNELS * 2)

/* IAR support */
#if defined(__ICCARM__)
#pragma location = UDMA0_SRAM_BASE
extern RSI_UDMA_DESC_T UDMA0_Table[CONTROL_STRUCT0];
#pragma location = UDMA1_SRAM_BASE
extern RSI_UDMA_DESC_T UDMA1_Table[CONTROL_STRUCT1];
#endif

/* DMA descriptors must be aligned to 16 bytes */
#if defined(__CC_ARM)
extern RSI_UDMA_DESC_T UDMA0_Table[CONTROL_STRUCT0] ;
extern RSI_UDMA_DESC_T UDMA1_Table[CONTROL_STRUCT1] ;
#endif /* defined (__CC_ARM) */

#if defined( __GNUC__ )
extern RSI_UDMA_DESC_T __attribute__ ((section(".udma_addr0"))) UDMA0_Table[CONTROL_STRUCT0];
extern RSI_UDMA_DESC_T __attribute__ ((section(".udma_addr1"))) UDMA1_Table[CONTROL_STRUCT1];
#endif /* defined (__GNUC__) */

extern UDMA_Channel_Info udma0_chnl_info[32] ;
extern UDMA_Channel_Info udma1_chnl_info[12] ;

/* UDMA0 Resources */
extern UDMA_RESOURCES UDMA0_Resources ;
/* UDMA1 Resources */
extern UDMA_RESOURCES UDMA1_Resources;

#define ARM_SPI_DRV_VERSION    ARM_DRIVER_VERSION_MAJOR_MINOR(2, 0) /* driver version */

extern RSI_UDMA_HANDLE_T udmaHandle0,udmaHandle1;

#define ARM_SPI_DRV_VERSION    ARM_DRIVER_VERSION_MAJOR_MINOR(2, 0) /* driver version */

/* Driver Version */
static const ARM_DRIVER_VERSION DriverVersion = {
		ARM_SPI_API_VERSION,
		ARM_SPI_DRV_VERSION
};

/* Driver Capabilities */
static const ARM_SPI_CAPABILITIES DriverCapabilities = {
		0, /* Simplex Mode (Master and Slave) */
		1, /* TI Synchronous Serial Interface */
		1, /* Microwire Interface */
		1  /* Signal Mode Fault event: \ref SPI_EVENT_MODE_FAULT */
};


#ifdef SSI_MASTER

#define  SSI_MASTER_IRQHandler     IRQ047_Handler
// SSI_MASTER Run-Time Information
static SPI_INFO          SSI_MASTER_Info         = { 0U };
static SPI_TRANSFER_INFO SSI_MASTER_TransferInfo = { 0U };

#ifdef SSI_MASTER_MOSI_SEL
static SPI_PIN SSI_MASTER_mosi = {SSI_MASTER_MOSI_PORT, SSI_MASTER_MOSI_PIN, SSI_MASTER_MOSI_MODE, SSI_MASTER_MOSI_PADSEL};
#endif
#ifdef SSI_MASTER_MISO_SEL
static SPI_PIN SSI_MASTER_miso = {SSI_MASTER_MISO_PORT, SSI_MASTER_MISO_PIN, SSI_MASTER_MISO_MODE, SSI_MASTER_MISO_PADSEL};
#endif
#ifdef SSI_MASTER_SCK_SEL
static SPI_PIN SSI_MASTER_sck  = {SSI_MASTER_SCK_PORT,  SSI_MASTER_SCK_PIN, SSI_MASTER_SCK_MODE, SSI_MASTER_SCK_PADSEL};
#endif
#ifdef SSI_MASTER_CS0_SEL
static SPI_PIN SSI_MASTER_cs  =  {SSI_MASTER_CS0_PORT,  SSI_MASTER_CS0_PIN, SSI_MASTER_CS0_MODE, SSI_MASTER_CS0_PADSEL};
#endif

#if (SSI_MASTER_TX_DMA_Instance == 1)
void SSI_MASTER_UDMA_Tx_Event (uint32_t event ,uint8_t dmaCh);
static SPI_DMA SSI_MASTER_UDMA_TX_CHNL = {
		{
				0,
				0,
				0,
				0,
				1,
				SSIMASTER_ACK,
				SSI_MASTER_TX_DMA_Channel
		},
		SSI_MASTER_TX_DMA_Channel,
		SSI_MASTER_UDMA_Tx_Event
};
#endif
#if (SSI_MASTER_RX_DMA_Instance == 1)
void SSI_MASTER_UDMA_Rx_Event (uint32_t event ,uint8_t dmaCh);
static SPI_DMA SSI_MASTER_UDMA_RX_CHNL = {
		{
				0,
				0,
				0,
				0,
				1,
				SSIMASTER_ACK,
				SSI_MASTER_RX_DMA_Channel
		},
		SSI_MASTER_RX_DMA_Channel,
		SSI_MASTER_UDMA_Rx_Event
};
#endif

// SSI_MASTER Resources
static const SPI_RESOURCES SSI_MASTER_Resources = {
		SSI0,
		// PINS
		{
#ifdef SSI_MASTER_MOSI_SEL
				&SSI_MASTER_mosi,
#else
				NULL,
#endif
#ifdef SSI_MASTER_MISO_SEL
				&SSI_MASTER_miso,
#else
				NULL,
#endif
#ifdef SSI_MASTER_SCK_SEL
				&SSI_MASTER_sck,
#else
				NULL,
#endif
#ifdef SSI_MASTER_CS0_SEL
				&SSI_MASTER_cs,
#else
				NULL,
#endif
		},

		SSI0_IRQn,

#ifdef SSI_MASTER_RX_DMA_Instance
		&SSI_MASTER_UDMA_RX_CHNL,
#else
		NULL,
#endif

#ifdef SSI_MASTER_TX_DMA_Instance
		&SSI_MASTER_UDMA_TX_CHNL,
#else
		NULL,
#endif
		&SSI_MASTER_Info,
		&SSI_MASTER_TransferInfo,
		SPI_MASTER_MODE
};
#endif /* SSI_Master */
#ifdef SSI_SLAVE

#define  SSI_SLAVE_IRQHandler     IRQ044_Handler
// SSI_SLAVE Run-Time Information
static SPI_INFO          SSI_SLAVE_Info         = { 0U };
static SPI_TRANSFER_INFO SSI_SLAVE_TransferInfo = { 0U };

#ifdef SSI_SLAVE_MOSI_SEL
static SPI_PIN SSI_SLAVE_mosi = {SSI_SLAVE_MOSI_PORT, SSI_SLAVE_MOSI_PIN, SSI_SLAVE_MOSI_MODE, SSI_SLAVE_MOSI_PADSEL};
#endif
#ifdef SSI_SLAVE_MISO_SEL
static SPI_PIN SSI_SLAVE_miso = {SSI_SLAVE_MISO_PORT, SSI_SLAVE_MISO_PIN, SSI_SLAVE_MISO_MODE, SSI_SLAVE_MISO_PADSEL};
#endif
#ifdef SSI_SLAVE_SCK_SEL
static SPI_PIN SSI_SLAVE_sck  = {SSI_SLAVE_SCK_PORT,  SSI_SLAVE_SCK_PIN, SSI_SLAVE_SCK_MODE, SSI_SLAVE_SCK_PADSEL};
#endif
#ifdef SSI_SLAVE_CS0_SEL
static SPI_PIN SSI_SLAVE_cs  = {SSI_SLAVE_CS0_PORT,  SSI_SLAVE_CS0_PIN, SSI_SLAVE_CS0_MODE, SSI_SLAVE_CS0_PADSEL};
#endif

#if (SSI_SLAVE_TX_DMA_Instance == 1)
void SSI_SLAVE_UDMA_Tx_Event (uint32_t event ,uint8_t dmaCh);
static SPI_DMA SSI_SLAVE_UDMA_TX_CHNL = {
		{
				0,
				0,
				1,
				0,
				1,
				SSISLAVE_ACK,
				SSI_SLAVE_TX_DMA_Channel
		},
		SSI_SLAVE_TX_DMA_Channel,
		SSI_SLAVE_UDMA_Tx_Event
};
#endif
#if (SSI_SLAVE_RX_DMA_Instance == 1)
void SSI_SLAVE_UDMA_Rx_Event (uint32_t event ,uint8_t dmaCh);
static SPI_DMA SSI_SLAVE_UDMA_RX_CHNL = {
		{
				0,
				0,
				1,
				0,
				1,
				SSISLAVE_ACK,
				SSI_SLAVE_RX_DMA_Channel
		},
		SSI_SLAVE_RX_DMA_Channel,
		SSI_SLAVE_UDMA_Rx_Event
};
#endif

// SSI_SLAVE Resources
static const SPI_RESOURCES SSI_SLAVE_Resources = {
		SSISlave,
		// PINS
		{
#ifdef SSI_SLAVE_MOSI_SEL
				&SSI_SLAVE_mosi,
#else
				NULL,
#endif
#ifdef SSI_SLAVE_MISO_SEL
				&SSI_SLAVE_miso,
#else
				NULL,
#endif
#ifdef SSI_SLAVE_SCK_SEL
				&SSI_SLAVE_sck,
#else
				NULL,
#endif
#ifdef SSI_SLAVE_CS0_SEL
				&SSI_SLAVE_cs,
#else
				NULL,
#endif
		},
#ifdef	CHIP_9117
		SSISlave_IRQn,
#endif
#ifdef	CHIP_9118
		SSI1_IRQn,
#endif
		
#ifdef SSI_SLAVE_RX_DMA_Instance
		&SSI_SLAVE_UDMA_RX_CHNL,
#else
		NULL,
#endif

#ifdef SSI_SLAVE_TX_DMA_Instance
		&SSI_SLAVE_UDMA_TX_CHNL,
#else
		NULL,
#endif

		&SSI_SLAVE_Info,
		&SSI_SLAVE_TransferInfo,
		SPI_SLAVE_MODE
};
#endif /* SSI_SLAVE */

#ifdef SSI_ULP_MASTER

#define  SSI_ULP_MASTER_IRQHandler     IRQ016_Handler
// SSI_ULP_MASTER Run-Time Information
static SPI_INFO          SSI_ULP_MASTER_Info         = { 0U };
static SPI_TRANSFER_INFO SSI_ULP_MASTER_TransferInfo = { 0U };

#ifdef SSI_ULP_MASTER_MOSI_SEL
static SPI_PIN SSI_ULP_MASTER_mosi = {SSI_ULP_MASTER_MOSI_PORT, SSI_ULP_MASTER_MOSI_PIN, SSI_ULP_MASTER_MOSI_MODE};
#endif
#ifdef SSI_ULP_MASTER_MISO_SEL
static SPI_PIN SSI_ULP_MASTER_miso = {SSI_ULP_MASTER_MISO_PORT, SSI_ULP_MASTER_MISO_PIN, SSI_ULP_MASTER_MISO_MODE};
#endif
#ifdef SSI_ULP_MASTER_SCK_SEL
static SPI_PIN SSI_ULP_MASTER_sck  = {SSI_ULP_MASTER_SCK_PORT,  SSI_ULP_MASTER_SCK_PIN, SSI_ULP_MASTER_SCK_MODE};
#endif
#ifdef SSI_ULP_MASTER_CS0_SEL
static SPI_PIN SSI_ULP_MASTER_cs  = {SSI_ULP_MASTER_CS0_PORT,  SSI_ULP_MASTER_CS0_PIN, SSI_ULP_MASTER_CS0_MODE};
#endif

#if (SSI_ULP_MASTER_TX_DMA_Instance == 1)
void SSI_ULP_MASTER_UDMA_Tx_Event (uint32_t event ,uint8_t dmaCh);
static SPI_DMA SSI_ULP_MASTER_UDMA_TX_CHNL = {
		{
				0,
				0,
				1,
				0,
				1,
				0,
				SSI_ULP_MASTER_TX_DMA_Channel
		},
		SSI_ULP_MASTER_TX_DMA_Channel,
		SSI_ULP_MASTER_UDMA_Tx_Event
};
#endif
#if (SSI_ULP_MASTER_RX_DMA_Instance == 1)
void SSI_ULP_MASTER_UDMA_Rx_Event (uint32_t event ,uint8_t dmaCh);
static SPI_DMA SSI_ULP_MASTER_UDMA_RX_CHNL = {
		{
				0,
				0,
				1,
				0,
				1,
				0,
				SSI_ULP_MASTER_RX_DMA_Channel
		},
		SSI_ULP_MASTER_RX_DMA_Channel,
		SSI_ULP_MASTER_UDMA_Rx_Event
};
#endif

// SSI_ULP_MASTER Resources
static const SPI_RESOURCES SSI_ULP_MASTER_Resources = {
		SSI2,
		// PINS
		{
#ifdef SSI_ULP_MASTER_MOSI_SEL
				&SSI_ULP_MASTER_mosi,
#else
				NULL,
#endif
#ifdef SSI_ULP_MASTER_MISO_SEL
				&SSI_ULP_MASTER_miso,
#else
				NULL,
#endif
#ifdef SSI_ULP_MASTER_SCK_SEL
				&SSI_ULP_MASTER_sck,
#else
				NULL,
#endif
#ifdef SSI_ULP_MASTER_CS0_SEL
				&SSI_ULP_MASTER_cs,
#else
				NULL,
#endif
		},

		SSI2_IRQn,

#ifdef SSI_ULP_MASTER_RX_DMA_Instance
		&SSI_ULP_MASTER_UDMA_RX_CHNL,
#else
		NULL,
#endif

#ifdef SSI_ULP_MASTER_TX_DMA_Instance
		&SSI_ULP_MASTER_UDMA_TX_CHNL,
#else
		NULL,
#endif

		&SSI_ULP_MASTER_Info,
		&SSI_ULP_MASTER_TransferInfo,
		SPI_ULP_MASTER_MODE
};
#endif /* SSI_ULP_MASTER */

/**
 * @fn           ARM_DRIVER_VERSION SPI_GetVersion(void)
 * @brief        Get Driver Version.
 * @param[in]    none
 * @return 		   ARM DRIVER VERSION
 */
ARM_DRIVER_VERSION SPI_GetVersion(void)
{
	return DriverVersion;
}

/**
 * @fn           ARM_SPI_CAPABILITIES SPI_GetCapabilities(void)
 * @brief        Get Driver capabilities.
 * @param[in]    none
 * @return 		   ARM SPI VERSION
 */
ARM_SPI_CAPABILITIES SPI_GetCapabilities(void)
{
	return DriverCapabilities;
}

// SSI_MASTER
#ifdef SSI_MASTER
static int32_t SSI_MASTER_Initialize(ARM_SPI_SignalEvent_t pSignalEvent)             
   { 		 
		 /*Power up the ssi*/
		#if defined(CHIP_9117)
		RSI_PS_M4ssPeriPowerUp(M4SS_PWRGATE_ULP_EFUSE_PERI);
		#else
		RSI_PS_M4ssPeriPowerUp(M4SS_PWRGATE_ULP_PERI1);
		#endif
		 #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Initialize(pSignalEvent, &SSI_MASTER_Resources,
		   &UDMA0_Resources,UDMA0_Table,&udmaHandle0,dma_rom_buff0);
		 #else
	 return SPI_Initialize (pSignalEvent, &SSI_MASTER_Resources,
		   &UDMA0_Resources,UDMA0_Table,&udmaHandle0,dma_rom_buff0);
		 #endif
	 }
static int32_t SSI_MASTER_Uninitialize (void)
{ 
	/*Power down the ssi*/
		#if defined(CHIP_9117)
		RSI_PS_M4ssPeriPowerDown(M4SS_PWRGATE_ULP_EFUSE_PERI);
		#else
		RSI_PS_M4ssPeriPowerDown(M4SS_PWRGATE_ULP_PERI1);
		#endif
			 #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Uninitialize(&SSI_MASTER_Resources,&UDMA0_Resources);
		 #else
return SPI_Uninitialize (&SSI_MASTER_Resources,&UDMA0_Resources); 
	#endif
}
static int32_t SSI_MASTER_PowerControl(ARM_POWER_STATE state)
{
	 #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_PowerControl(state, &SSI_MASTER_Resources);
	#else
return SPI_PowerControl (state, &SSI_MASTER_Resources); 
	#endif
}
static int32_t SSI_MASTER_Send (const void *data, uint32_t num)
{ 
			 #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Send(data, num, &SSI_MASTER_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0);
		 #else
return SPI_Send (data, num, &SSI_MASTER_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0); 
	#endif
}
static int32_t SSI_MASTER_Receive (void *data, uint32_t num)
{ 
			 #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Receive(data, num, &SSI_MASTER_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0);
		 #else
  return SPI_Receive (data, num, &SSI_MASTER_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0); 
	#endif
}
static int32_t SSI_MASTER_Transfer(const void *data_out, void *data_in, uint32_t num)
 {
	 		 #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Transfer(data_out, data_in, num, &SSI_MASTER_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0);
		 #else
 return SPI_Transfer (data_out, data_in, num, &SSI_MASTER_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0) ;
	 #endif
 }
static uint32_t SSI_MASTER_GetDataCount(void)
{
		 #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_GetDataCount(&SSI_MASTER_Resources);
		 #else	
return SPI_GetDataCount (&SSI_MASTER_Resources); 
	#endif
}
static int32_t SSI_MASTER_Control(uint32_t control, uint32_t arg)   
{ 
//!ROM bypass
 uint32_t ssi_get_clock=0;
 ssi_get_clock = RSI_CLK_GetBaseClock(M4_SSI_MST);
  #ifndef SSI_MULTI_SLAVE
       #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Control(control, arg, &SSI_MASTER_Resources,ssi_get_clock);
  #endif
     #else
 return SPI_Control (control, arg, &SSI_MASTER_Resources,ssi_get_clock); 
  #endif

}
static ARM_SPI_STATUS SSI_MASTER_GetStatus (void)
	{
				 #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_GetStatus(&SSI_MASTER_Resources);
		 #else
   return SPI_GetStatus (&SSI_MASTER_Resources); 
		#endif
	}
void SSI_MASTER_IRQHandler (void) 
{		 
	#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
        ROMAPI_SSI_API->SPI_IRQHandler(&SSI_MASTER_Resources);
		 #else 
SPI_IRQHandler (&SSI_MASTER_Resources);
	#endif
}
#if (SSI_MASTER_TX_DMA_Instance == 1)
void SSI_MASTER_UDMA_Tx_Event (uint32_t event, uint8_t dmaCh) 
{
		 #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
        ROMAPI_SSI_API->SPI_UDMA_Tx_Event(event,dmaCh, &SSI_MASTER_Resources);
		 #else
SPI_UDMA_Tx_Event (event,dmaCh, &SSI_MASTER_Resources);	
#endif
}
#endif

#if (SSI_MASTER_RX_DMA_Instance == 1)
void SSI_MASTER_UDMA_Rx_Event (uint32_t event, uint8_t dmaCh) 
{		 
#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
        ROMAPI_SSI_API->SPI_UDMA_Rx_Event(event,dmaCh, &SSI_MASTER_Resources);
		 #else
SPI_UDMA_Rx_Event (event,dmaCh, &SSI_MASTER_Resources);	
#endif
}
#endif


// End SPI Interface

ARM_DRIVER_SPI Driver_SSI_MASTER = {
		SPI_GetVersion,
		SPI_GetCapabilities,
		SSI_MASTER_Initialize,
		SSI_MASTER_Uninitialize,
		SSI_MASTER_PowerControl,
		SSI_MASTER_Send,
		SSI_MASTER_Receive,
		SSI_MASTER_Transfer,
		SSI_MASTER_GetDataCount,
		SSI_MASTER_Control,
		SSI_MASTER_GetStatus
};
#endif

// SSI_SLAVE
#ifdef SSI_SLAVE
static int32_t SSI_SLAVE_Initialize (ARM_SPI_SignalEvent_t pSignalEvent)
{ 
		 /*Power up the ssi*/
		#if defined(CHIP_9117)
		RSI_PS_M4ssPeriPowerUp(M4SS_PWRGATE_ULP_EFUSE_PERI);
		#else
		RSI_PS_M4ssPeriPowerUp(M4SS_PWRGATE_ULP_PERI1);
		#endif
	#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Initialize(pSignalEvent, &SSI_SLAVE_Resources,
	&UDMA0_Resources,UDMA0_Table,&udmaHandle0,dma_rom_buff0);
		 #else
return SPI_Initialize (pSignalEvent, &SSI_SLAVE_Resources,
	&UDMA0_Resources,UDMA0_Table,&udmaHandle0,dma_rom_buff0);
	#endif
}
static int32_t SSI_SLAVE_Uninitialize (void)
{
/*Power down the ssi*/
		#if defined(CHIP_9117)
		RSI_PS_M4ssPeriPowerDown(M4SS_PWRGATE_ULP_EFUSE_PERI);
		#else
		RSI_PS_M4ssPeriPowerDown(M4SS_PWRGATE_ULP_PERI1);
		#endif
		#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Uninitialize(&SSI_SLAVE_Resources,&UDMA0_Resources);
	#else
return SPI_Uninitialize (&SSI_SLAVE_Resources,&UDMA0_Resources); 
	#endif
}
static int32_t SSI_SLAVE_PowerControl (ARM_POWER_STATE state)
{
			#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_PowerControl(state, &SSI_SLAVE_Resources);
	#else
return SPI_PowerControl (state, &SSI_SLAVE_Resources);
	#endif
}
static int32_t SSI_SLAVE_Send (const void *data, uint32_t num) 
{ 
		#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Send(data, num, &SSI_SLAVE_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0);
	#else
 return SPI_Send (data, num, &SSI_SLAVE_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0);
	#endif
}
static int32_t SSI_SLAVE_Receive(void *data, uint32_t num)
{
		#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Receive(data, num, &SSI_SLAVE_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0);
	#else
 return SPI_Receive (data, num, &SSI_SLAVE_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0);
	#endif
}
static int32_t SSI_SLAVE_Transfer(const void *data_out, void *data_in, uint32_t num) 
{ 
			#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Transfer(data_out, data_in, num, &SSI_SLAVE_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0);
	#else
	return SPI_Transfer (data_out, data_in, num, &SSI_SLAVE_Resources,&UDMA0_Resources,
                        udma0_chnl_info,
                        udmaHandle0); 
	#endif
}
static uint32_t       SSI_SLAVE_GetDataCount(void)
{
	#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_GetDataCount(&SSI_SLAVE_Resources);
	#else 
return SPI_GetDataCount (&SSI_SLAVE_Resources);
	#endif
}
static int32_t  SSI_SLAVE_Control (uint32_t control, uint32_t arg) 
{ 
  //!ROM bypass  
   uint32_t ssi_get_clock=0;
   #ifndef SSI_MULTI_SLAVE
    #if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Control(control, arg, &SSI_SLAVE_Resources,ssi_get_clock);
  #endif
  #else
   return SPI_Control (control, arg, &SSI_SLAVE_Resources,ssi_get_clock); 
  #endif
}
static ARM_SPI_STATUS SSI_SLAVE_GetStatus(void)
{
#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_GetStatus(&SSI_SLAVE_Resources);
	#else
return SPI_GetStatus (&SSI_SLAVE_Resources);
	#endif
}
void SSI_SLAVE_IRQHandler (void)
{     
	#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
        ROMAPI_SSI_API->SPI_IRQHandler(&SSI_SLAVE_Resources);
	#else
SPI_IRQHandler (&SSI_SLAVE_Resources); 
	#endif
}
#if (SSI_SLAVE_TX_DMA_Instance == 1)
void SSI_SLAVE_UDMA_Tx_Event  (uint32_t event, uint8_t dmaCh) 
{	
	#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
        ROMAPI_SSI_API->SPI_UDMA_Tx_Event (event,dmaCh, &SSI_SLAVE_Resources);	
#else
SPI_UDMA_Tx_Event (event,dmaCh, &SSI_SLAVE_Resources);	
#endif
}
#endif

#if (SSI_SLAVE_RX_DMA_Instance == 1)
void  SSI_SLAVE_UDMA_Rx_Event (uint32_t event, uint8_t dmaCh)
{
	#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
        ROMAPI_SSI_API->SPI_UDMA_Rx_Event (event,dmaCh, &SSI_SLAVE_Resources);	
#else
SPI_UDMA_Rx_Event (event,dmaCh, &SSI_SLAVE_Resources);	
#endif
}
#endif


// End SPI Interface

ARM_DRIVER_SPI Driver_SSI_SLAVE = {
		SPI_GetVersion,
		SPI_GetCapabilities,
		SSI_SLAVE_Initialize,
		SSI_SLAVE_Uninitialize,
		SSI_SLAVE_PowerControl,
		SSI_SLAVE_Send,
		SSI_SLAVE_Receive,
		SSI_SLAVE_Transfer,
		SSI_SLAVE_GetDataCount,
		SSI_SLAVE_Control,
		SSI_SLAVE_GetStatus
};
#endif

// SSI_ULP_MASTER
#ifdef SSI_ULP_MASTER
static int32_t SSI_ULP_MASTER_Initialize (ARM_SPI_SignalEvent_t pSignalEvent)
{
		/*power up the ssi peripheral*/
		RSI_PS_UlpssPeriPowerUp(ULPSS_PWRGATE_ULP_SSI);
#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Initialize (pSignalEvent, &SSI_ULP_MASTER_Resources,
	                &UDMA1_Resources,UDMA1_Table,&udmaHandle1,dma_rom_buff1);
#else
return SPI_Initialize (pSignalEvent, &SSI_ULP_MASTER_Resources,
	                &UDMA1_Resources,UDMA1_Table,&udmaHandle1,dma_rom_buff1);
#endif
}
static int32_t SSI_ULP_MASTER_Uninitialize(void)
{ 
	/*power up the ssi peripheral*/
	RSI_PS_UlpssPeriPowerDown(ULPSS_PWRGATE_ULP_SSI);
#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Uninitialize (&SSI_ULP_MASTER_Resources,&UDMA1_Resources);
#else
	return SPI_Uninitialize (&SSI_ULP_MASTER_Resources,&UDMA1_Resources);
	#endif
}
static int32_t        SSI_ULP_MASTER_PowerControl (ARM_POWER_STATE state)
{
#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_PowerControl (state, &SSI_ULP_MASTER_Resources);
#else
return SPI_PowerControl (state, &SSI_ULP_MASTER_Resources);
	#endif
}
static int32_t SSI_ULP_MASTER_Send (const void *data, uint32_t num)
 { 
#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Send (data, num, &SSI_ULP_MASTER_Resources,
		              &UDMA1_Resources,udma1_chnl_info,udmaHandle1); 
#else
	 return SPI_Send (data, num, &SSI_ULP_MASTER_Resources,
		              &UDMA1_Resources,udma1_chnl_info,udmaHandle1); 
	#endif 
 }
static int32_t SSI_ULP_MASTER_Receive (void *data, uint32_t num)
{
#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Receive (data, num, &SSI_ULP_MASTER_Resources,
	                &UDMA1_Resources,udma1_chnl_info,udmaHandle1); 
#else
 return SPI_Receive (data, num, &SSI_ULP_MASTER_Resources,
	                &UDMA1_Resources,udma1_chnl_info,udmaHandle1); 
	#endif
}
static int32_t SSI_ULP_MASTER_Transfer (const void *data_out, void *data_in, uint32_t num)
 {
 			#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_Transfer (data_out, data_in, num, &SSI_ULP_MASTER_Resources,
		                &UDMA1_Resources,udma1_chnl_info,udmaHandle1);
#else
  return SPI_Transfer (data_out, data_in, num, &SSI_ULP_MASTER_Resources,
		                &UDMA1_Resources,udma1_chnl_info,udmaHandle1); 
	 #endif
 }
static uint32_t       SSI_ULP_MASTER_GetDataCount        (void)
{
			#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
       return ROMAPI_SSI_API->SPI_GetDataCount (&SSI_ULP_MASTER_Resources);
#else
return SPI_GetDataCount (&SSI_ULP_MASTER_Resources);
	#endif
}
static int32_t        SSI_ULP_MASTER_Control(uint32_t control, uint32_t arg)
{ 
 //!ROM bypass
 uint32_t ssi_get_clock=0;
 ssi_get_clock = RSI_CLK_GetBaseClock(ULPSS_SSI);
 #ifndef SSI_MULTI_SLAVE
      #if (defined(A11_ROM)) &&( defined(ROMDRIVER_PRESENT)) &&( defined(CHIP_9117))
       return ROMAPI_SSI_API->SPI_Control (control, arg, &SSI_ULP_MASTER_Resources,ssi_get_clock);
 #endif
#else
 return SPI_Control (control, arg, &SSI_ULP_MASTER_Resources,ssi_get_clock); 
  #endif
}
static ARM_SPI_STATUS SSI_ULP_MASTER_GetStatus           (void)
{
			#if (defined(A11_ROM)) &&( defined(ROMDRIVER_PRESENT)) &&( defined(CHIP_9117))
       return ROMAPI_SSI_API->SPI_GetStatus (&SSI_ULP_MASTER_Resources);
#else
return SPI_GetStatus (&SSI_ULP_MASTER_Resources);
	#endif
}
void SSI_ULP_MASTER_IRQHandler (void)
{
#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
        ROMAPI_SSI_API->SPI_IRQHandler (&SSI_ULP_MASTER_Resources);
#else
SPI_IRQHandler (&SSI_ULP_MASTER_Resources);
	#endif
}
#if (SSI_ULP_MASTER_TX_DMA_Instance == 1)
void 				  SSI_ULP_MASTER_UDMA_Tx_Event		 (uint32_t event, uint8_t dmaCh)
{
			#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
        ROMAPI_SSI_API->SPI_UDMA_Tx_Event (event,dmaCh, &SSI_ULP_MASTER_Resources);
#else
SPI_UDMA_Tx_Event (event,dmaCh, &SSI_ULP_MASTER_Resources);
	#endif
}
#endif

#if (SSI_ULP_MASTER_RX_DMA_Instance == 1)
void SSI_ULP_MASTER_UDMA_Rx_Event (uint32_t event, uint8_t dmaCh)
{
			#if ( (defined(A11_ROM)) && (defined(ROMDRIVER_PRESENT)) && (defined(CHIP_9117)) )
        ROMAPI_SSI_API->SPI_UDMA_Rx_Event (event,dmaCh, &SSI_ULP_MASTER_Resources);
#else
SPI_UDMA_Rx_Event (event,dmaCh, &SSI_ULP_MASTER_Resources);
	#endif
}
#endif

// End SPI Interface

ARM_DRIVER_SPI Driver_SSI_ULP_MASTER = {
		SPI_GetVersion,
		SPI_GetCapabilities,
		SSI_ULP_MASTER_Initialize,
		SSI_ULP_MASTER_Uninitialize,
		SSI_ULP_MASTER_PowerControl,
		SSI_ULP_MASTER_Send,
		SSI_ULP_MASTER_Receive,
		SSI_ULP_MASTER_Transfer,
		SSI_ULP_MASTER_GetDataCount,
		SSI_ULP_MASTER_Control,
		SSI_ULP_MASTER_GetStatus
};
#endif