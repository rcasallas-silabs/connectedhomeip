# ULP_UART

## Introduction 
- This application demonstrates how to use ULP_UART to send and receive data in loopback mode in PS2 state.
- This application is configured with following configs
  - Tx and Rx enabled
  - Asynchronous mode
  - 8 Bit data transfer
  - No Parity
  - No Auto Flow control
  - Baud Rates - 115200
  
## Setting Up 
- To use this application following Hardware, Software and Project Setup is required

### Hardware Requirements
  - Windows PC 
  - Silicon Labs Si917 Evaluation Kit [WSTK + BRD4325A]
  
![Figure: Introduction](resources/readme/image506a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
   

## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
|GPIO pin  | Description|
|--- | --- |
|ULP_GPIO_7 [EXP_HEADER-7]  |ULP_USART_TX_PIN |
|ULP_GPIO_6 [P36]           |ULP_USART_RX_PIN |
|ULP_GPIO_0 [EXP_HEADER-9]  |GPIO_Toggle      |

## Configuration and Steps for Execution

- Configure the following parameters in ulp_uart.c file and update/modify following macros if required. 
   ```C
   #define BUFFER_SIZE  // Number of data to be sent by UART
   #define BAUD_VALUE   // Number of bits transmitted per second
   ``` 
   

## Build
1. Compile the application in Simplicity Studio using build icon

![Figure: Build run and Debug](resources/readme/image506c.png)

## Program the device
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Executing the Application
1. When the application runs,It sends and receives data in loopback mode
2. Connect TX Pin ULP_GPIO_7 to RX Pin ULP_GPIO_6 for Loop back

## Expected Results 
 - When tx and rx data both are matching ULP_GPIO_0 should be toggled ,connect logic analyser to observe the toggle state. 

## Note
 - This applicatin is executed from RAM.
 - In this application while changing the MCU mode from PS4 to PS2, M4 flash will be turned off.
 - The debug feature of Simplicity Studio will not work after M4 flash is turned off.

## Expected Scenario:
 - After Flashing ULP examples as M4 flash will be turned off,flash erase does not work.
 - To Erase the chip follow the below procedure
   - Turn ON ISP switch and press the reset button → Turn OFF ISP Switch → Now perform Chip erase 
      through commander.
 