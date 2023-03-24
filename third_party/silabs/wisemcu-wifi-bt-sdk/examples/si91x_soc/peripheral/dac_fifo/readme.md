# DAC-FIF0 [Digital To Analog Converter]

## Introduction 
- This example explains the DAC functionality in FIFO mode.
- Here input samples to DAC are fed using external UDMA with ping pong mode and DAC output is generated on ULP_GPIO4. Following configurations are used in example.

  - DAC operation mode		: FIFO mode
  - DAC FIFO threshold		: 3
  - DAC output GPIO			: ULP_GPIO4
  - DAC input samples		: Standard sine wave samples are feed to DAC input register. 
  - Reference LDO voltage	: 2.8V(Max output voltage of DAC is 2.8V)
  - M4 core clock			: 180Mhz
  - ULP Pro clock			: 90Mhz
  
- After getting ping or pong interrupt, M4 will reconfigure respective descriptor.


## Setting Up 
 - To use this application following Hardware, Software and the Project Setup is required.

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs Si917 Evaluation Kit [WSTK + BRD4325A]
 
![Figure: Introduction](resources/readme/image509a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Build 
1. Compile the application in Simplicity Studio using build icon. 

![Figure: Build run and Debug](resources/readme/image509c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio.

## Pin Configuration
|GPIO pin  | Description|
|--- | --- | 
|ULP_GPIO_4 [EXP_HEADER-11] |DAC output pin|


## Executing the Application
1. Compile and run the application.

## Expected Results 
 - Observe the output on the ULP_GPIO_4 pin by using a Logic analyzer or oscilloscope.
 - The output should be a sine wave with voltage up to 2.8V, then DAC output is proper and the test case is passed.