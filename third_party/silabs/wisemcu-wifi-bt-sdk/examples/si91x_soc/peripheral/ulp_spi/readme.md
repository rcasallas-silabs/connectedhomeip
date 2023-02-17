# ULP_SPI

## Introduction

- This application demonstrate the ULP_SPI for data transfer and used to send and receive data in loopback mode in PS2 state.
- This application runs in synchronous mode with full-duplex operation
  - Master transmits data on MOSI pin and receives the same data on MISO pin
  
## Setting Up 
- To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs Si917 Evaluation Kit [WSTK + BRD4325A]
 
![Figure: Introduction](resources/readme/image502a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDK"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Configure the following parameters in ulp_spi.c (examples/si91x_soc/peripheral/ulp_spi/)file and update/modify following macros if required

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

## Loading Application on Simplicity Studio
1. With the product Si917 selected, navigate to the example projects by clicking on Example Projects & Demos 
  in simplicity studio and click on to ulp_spi Example application as shown below.

![Figure:](resources/readme/image502b.png)

## Build 
1. Compile the application in Simplicity Studio using build icon

![Figure: Build run and Debug](resources/readme/image502c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
|GPIO pin  | Description|
|--- | --- | 
|ULP_GPIO_8  [F11]           |ULP_SSI_MASTER_CLK_PIN |
|ULP_GPIO_10 [EXP_HEADER-3]  |ULP_SSI_MASTER_CS0_PIN |0
|ULP_GPIO_11 [EXP_HEADER-5]  |ULP_SSI_MASTER_MOSI_PIN|
|ULP_GPIO_9  [P27]           |ULP_SSI_MASTER_MISO_PIN|

## Executing the Application
1. Compile and run the application.
2. Connect ULP_GPIO_11 to ULP_GPIO_9 for loopback connection.
3. When the application runs,It sends and receives data in loopback mode. 

## Expected Results 
 - Will get "Test Case Pass" print on console when tx and rx data both are matching.

## Note
 - This applicatin is executed from RAM.
 - In this application while changing the MCU mode from PS4 to PS2, M4 flash will be turned off.
 - The debug feature of Simplicity Studio will not work after M4 flash is turned off.
 - To check **Prints** for ULP Peripheral examples, connect the USB to TTL uart connector's RX_pin, 
    to the **EXP_HEADER-7** of the WPK[BRD4002A]/WSTK[BRD4001A] Base Board.

## Expected Scenario:
 - After Flashing ULP examples as M4 flash will be turned off,flash erase does not work.
 - To Erase the chip follow the below procedure
   - Turn ON ISP switch and press the reset button → Turn OFF ISP Switch → Now perform Chip erase 
      through commander. 