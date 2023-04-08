# SDIO Slave Application

## Introduction
The SDIO slave example shows how to read and write data in SDIO slave using GPDMA
## Setting Up 
To use this application following Hardware, Software and the Project Setup is required:

### Hardware Requirements 
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A] as slave
  - An external SDIO master device

 
![Figure: Introduction](resources/readme/image502a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
### Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Modify TRANSMISSION_TYPE in sdio_slave.c file to configure transmission mode for SDIO slave:

   ```c
  /* Mode of Transmission */
  #define TX_PATH 2 /* Transmit data to the master  */
  #define RX_PATH 1 /* Receive data from the master */

  /* Modify this macro to change mode of transmission for sdio slave */
  #define TRANSMISSION_TYPE RX_PATH /* Default is receive mode, i.e., RX_PATH */
   ```

- Modify TRANSFER_LEN and NO_OF_BLOCKS in sdio_slave.c file to configure transmission size for TX and RX:

   ```c
  #define TRANSFER_LEN  256
  #define NO_OF_BLOCKS  4
  #define TX_BLOCK_SIZE (TRANSFER_LEN * NO_OF_BLOCKS) /* Transfer size is 256B*4 = 1KB */
  #define RX_BLOCK_SIZE (TRANSFER_LEN * NO_OF_BLOCKS) /* Transfer size is 256B*4 = 1KB */
   ```

## Device Programming
To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
|Si917 GPIO pin  | EXP Header Connection  |  Description|
|--- | --- | ---  |
|GPIO_25  | 15 |SDIO_CLK|
|GPIO_26  | 16 |SDIO_CMD |
|GPIO_27  | 10 |SDIO_DATA0 |
|GPIO_28  | 8 |SDIO_DATA1 |
|GPIO_29  | 6 |SDIO_DATA2 |
|GPIO_30  | 4 |SDIO_DATA3 |

## Executing the Application
1. Compile and run the application.
2. Connect Slave DATA*,CLK,CMD pins to Master DATA*,CLK,CMD pins properly.
3. Modify main file for SDIO Slave as per requirement.
4. When the application runs, master sends and slave receives the data. 

## Expected Results 
 - TX_PATH (Transmit data from SDIO slave to SDIO master).
   SDIO slave transmits data from 'tx_buffer'
 - RX_PATH (Receive data from SDIO master to SDIO slave).
   SDIO slave receive data in 'rx_buffer'