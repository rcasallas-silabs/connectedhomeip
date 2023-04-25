# SDIO_Slave

## Introduction
The SDIO slave example shows how to write and read data in SDIO master using smih interface.
## Setting Up 
- To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs [EFM32GG11] as master
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A] as slave
 
![Figure: Introduction](resources/readme/image502a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Configure the following parameters in sdio_slave.c file and update/modify following macros if required

   ```c
   #define RX_PATH   1     /*Enable this MACRO to receive data from SDIO master to SDIO slave*/
   #define TX_PATH   0     /*Enable this MACRO to send data from SDIO slave to SDIO master*/
   #define TRNSFER_LEN   256
   #define TX_BLOCK_SIZE (TRNSFER_LEN * 4)
   #define RX_BLOCK_SIZE (TRNSFER_LEN * 4)
   ```

## EFM32GG11 Master setup :
1)	Import any sample application of EFM32GG11 in Simplicity studio
2)	Add the SDIO, HAL, DRIVER and COMMON folders in to sample project from wiseconnect
From Imported sample applicatiom: GoTo -> properties -> C/C++ General -> Paths and Symbols -> Source Location -> Add files  add above folders from wiseconnect
3)	Add all required include files paths in includes
GoTo -> properties -> C/C++ General -> Paths and Symbols -> Includes -> GNU C -> Add directory path then Apply and close
4)	Build the project with out any errors.   
## Build 
1. Compile the application in Simplicity Studio using build icon

![Figure: Build run and Debug](resources/readme/image502c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
|Si917 GPIO pin  | GG1 GPIO pin  |  Description|
|--- | --- | ---  |
|GPIO_25 [EXP_HEADER-15] | PE13 [EXP_HEADER-10] |SDIO_CLK|
|GPIO_26 [EXP_HEADER-16] | PE12 [EXP_HEADER-8] |SDIO_CMD |
|GPIO_27 [EXP_HEADER-10] | PE11 [EXP_HEADER-6] |SDIO_DATA0 |
|GPIO_28 [EXP_HEADER-8] | PE10 [EXP_HEADER-4] |SDIO_DATA1 |
|GPIO_29 [EXP_HEADER-6] | PE9 [EXP_HEADER-14] |SDIO_DATA2 |
|GPIO_30 [EXP_HEADER-4] | PE8 [EXP_HEADER-12] |SDIO_DATA3 |

**Note!** Make sure pin configuration in RTE_Device_9117.h file.(path: /$project/wiseconnect_1.0.0/platforms/si91x/drivers/cmsis_driver/config/RTE_Device_9117.h)
## High Speed mode:
- Set the AUXCLK to 50MHz by calling the below function in sl_device_init_clocks() function in sl_device_init_clocks.c file
CMU_AUXHFRCOBandSet(cmuAUXHFRCOFreq_50M0Hz);

Note: It is not required for default mode. Default it will take @19MHz
## Executing the Application
1. Compile and run the application.
2. Connect Slave DATA*,CLK,CMD pins to Master DATA*,CLK,CMD pins properly.
3. Modify main file for SDIO module to transmit the data. 
4. When the application runs,master sends and slave receives the data. 

## Expected Results 
 - TX_PATH(Transmit data from SDIO slave to SDIO master)
   SDIO master receive data(receive buffer) should be match with 'tx_buffer'buffer data.
 - RX_PATH(Receive data from SDIO master to SDIO slave)
   'rx_buffer' buffer data should match with SDIO master transmit data(transmit buffer)
