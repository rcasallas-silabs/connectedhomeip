# USART_MASTER

## Introduction 
- This application demonstrates how to configure USART as Master, it will send and receive data in full duplex mode
- This application is configured with following configs
  - Tx and Rx enabled
  - Synchronous Master mode
  - 8 Bit data transfer
  - Stop bits 1
  - No Parity
  - No Auto Flow control
  - Baud Rates - 115200
  
## Setting Up 
- To use this application following Hardware, Software and Project Setup is required

### Hardware Requirements
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A]
  
![Figure: Introduction](resources/readme/image516a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
   

## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Configure the following parameters in usart_master.c (examples/si91x_soc/peripheral/usart_master/) file and update/modify following macros if required
   ```C
   #define BUFFER_SIZE // Number of data to be sent by USART
   #define BAUD_VALUE  // Number of bits transmitted per second
   ``` 


## Build
1. Enable RTE_USART_MODE and RTE_CONTINUOUS_CLOCK_MODE in RTE_Device_9117.h(path: /$project/wiseconnect_1.0.0/platforms/si91x/drivers/cmsis_driver/config/RTE_Device_9117.h)
2. Connect Master and slave as per pin configurations and ensure slave to be configured properly before executing master code
3. Compile the application in Simplicity Studio using build icon

![Figure: Build run and Debug](resources/readme/image516c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
|Master | GPIO | Connector | Slave |
|--- | ---| ---| ---|
|USART0_CLK_PIN|GPIO_8 | EXP_HEADER-14 |
|USART0_TX_PIN |GPIO_30| EXP_HEADER-4  |
|USART0_RX_PIN |GPIO_29| EXP_HEADER-6  |

## Executing the Application
1. Connect USART master clock pin(GPIO_8) to USART slave clock pin ,Master TX pin(GPIO_30) to Slave RX pin,Master RX pin(GPIO_29) to Slave TX pin.
2. Connect the USART master ground(GND) pin to USART slave ground(GND) pin.
3. When the application runs,USART sends data to slave in synchronous master mode and waits for receive data from slave in full duplex mmode
 
## Expected Results 
 - Will get "Data transfer success" print on console when this transfer success 
 - Add rx_buffer buffer to watch window for checking receive data
 