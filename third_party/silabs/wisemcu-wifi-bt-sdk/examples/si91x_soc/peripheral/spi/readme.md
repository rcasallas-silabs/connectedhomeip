# SPI

## Introduction

- This application demonstrate the SPI for data transfer and used to send and receive data in loopback mode
- This application runs in synchronous mode with full-duplex operation
  - Master transmits data on MOSI pin and receives the same data on MISO pin
  
**Note!** SPI Multi Slave is not supported.

## Setting Up 
- To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A]
 
![Figure: Introduction](resources/readme/image502a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)

## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Configure the following parameters in spi.c file and update/modify following macros if required

   ```c
   #define BUFFER_SIZE        // Number of data to be sent through SPI
   #define SPI_BAUD           // Speed at which data transmitted through SPI
   #define SPI_BIT_WIDTH      // SPI bit width can be 16/8 for 16/8 bit data transfer
   #define INTF_PLL_CLK       // Interface PLL clock
   #define INTF_PLL_REF_CLK   // Interface PLL reference Clock
   #define SOC_PLL_CLK        // SOC PLL Clock
   #define SOC_PLL_REF_CLK    // SOC PLL reference clock
   ```
- Configure following parameters in application for 16bit spi data width

```c
  -SPI_BIT_WIDTH  16
  -TX and RX buffers should be of type 16bit
  -Size of data to SPI Transfer function should be like below
   (sizeof(tx_data_buffer)/2)
   ```

## Build 
1. Compile the application in Simplicity Studio using build icon

![Figure: Build run and Debug](resources/readme/image502c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
|GPIO pin  | Description|
|--- | --- | 
|GPIO_25 [EXP_HEADER-15] |RTE_SSI_MASTER_CLK_PIN |
|GPIO_28 [EXP_HEADER-8]  |RTE_SSI_MASTER_CS0_PIN |
|GPIO_26 [EXP_HEADER-16] |RTE_SSI_MASTER_MOSI_PIN|
|GPIO_27 [EXP_HEADER-10] |RTE_SSI_MASTER_MISO_PIN|

**Note!** Make sure pin configuration in RTE_Device_9117.h file.(path: /$project/wiseconnect_1.0.0/platforms/si91x/drivers/cmsis_driver/config/RTE_Device_9117.h)

## Executing the Application
1. Compile and run the application.
2. Connect GPIO_26 to GPIO_27 for loopback connection.
3. When the application runs,It sends and receives data in loopback mode. 

## Expected Results 
 - Will get "Test Case Pass" print on console when tx and rx data both are matching.
