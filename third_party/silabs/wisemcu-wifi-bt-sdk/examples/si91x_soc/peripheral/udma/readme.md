# UDMA

## Introduction 
- This application demonstrates how to setup and use the UDMA controller for a limited software triggered memory to memory transfer
  Because of the limited burst transfer size of the DMA (1024 transfers max) and limited burst size


## Setting Up 
 - To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A]
 
![Figure: Introduction](resources/readme/image507a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDK"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Configure the following parameters in udma_mem.c file and update/modify following macros if required
```C
#define SIZE_BUFFERS (1024) // Buffer size
#define DMA_DESC_LEN (1024) // DMA descriptor Length
#define CHNL         31     // 32 Channels
```   
   
## Loading Application on Simplicity Studio
1. With the product Si917 selected, navigate to the example projects by clicking on Example Projects & Demos 
in simplicity studio and click on to UDMA Example application as shown below.

![Figure:](resources/readme/image507b.png)

## Build 
1. Compile the application in Simplicity Studio using build icon 

![Figure: Build run and Debug](resources/readme/image507c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Executing the Application
1. Compile and run the application 
2. When using thi application, the UDMA domain should not be power gated

## Expected Results 
 - Will get "Test Case Pass" print on console when source and destination buffers both are matching 
 - Add dst0 buffer to watch window for checking data
 