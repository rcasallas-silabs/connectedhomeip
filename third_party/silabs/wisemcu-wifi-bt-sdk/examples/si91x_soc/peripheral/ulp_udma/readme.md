# ULP_UDMA

## Introduction 
- This application demonstrates how to setup and use the ULP_UDMA controller in PS2 state for a limited software triggered memory to memory transfer
  Because of the limited burst transfer size of the DMA (1024 transfers max) and limited burst size


## Setting Up 
 - To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs Si917 Evaluation Kit [WSTK + BRD4325A]
 
![Figure: Introduction](resources/readme/image507a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Configure the following parameters in ulp_udma.c file and update/modify following macros if required
```C
#define SIZE_BUFFERS (1024) // Buffer size
#define DMA_DESC_LEN (1024) // DMA descriptor Length
#define CHNL         1     // 32 Channels
```   
   
## Build 
1. Compile the application in Simplicity Studio using build icon 

![Figure: Build run and Debug](resources/readme/image507c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Executing the Application
1. Compile and run the application 

## Expected Results 
 - Will get "Test Case Pass" print on console when source and destination buffers both are matching 

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
 
 