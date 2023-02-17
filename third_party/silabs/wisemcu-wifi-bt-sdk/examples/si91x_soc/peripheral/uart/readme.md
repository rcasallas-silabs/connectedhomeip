# UART

## Introduction 
- This application demonstrates how to use UART to send and receive data in loopback mode
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
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A]
  
![Figure: Introduction](resources/readme/image506a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
   

## Project Setup
- **Silicon Labs Si91x** refer **"Download SDK"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
|GPIO pin  | Description|
|--- | --- |
|GPIO_30 [EXP_HEADER-4]|USART0_TX_PIN |
|GPIO_29 [EXP_HEADER-6]|USART0_RX_PIN |

## Configuration and Steps for Execution

- Configure the following parameters in uart_exp.c (/examples/si91x_soc/peripheral/uart/) file and update/modify following macros if required. 
   ```C
   #define BUFFER_SIZE  // Number of data to be sent by UART
   #define BAUD_VALUE   // Number of bits transmitted per second
   ``` 
   
## Loading Application on Simplicity Studio
1. With the product Si917 selected, navigate to the example projects by clicking on Example Projects & Demos 
   in simplicity studio and click on to UART Example application as shown below.

![Figure:](resources/readme/image506b.png)

## Build
1. Compile the application in Simplicity Studio using build icon

![Figure: Build run and Debug](resources/readme/image506c.png)

## Program the device
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Executing the Application
1. When the application runs,It sends and receives data in loopback mode
2. Connect TX Pin GPIO_30 to RX Pin GPIO_29 for Loop back

## Expected Results 
 - Will get "Test Case Pass" print on console when tx and rx data both are matching 
 - Add rx_buffer to watch window for checking receive data
 