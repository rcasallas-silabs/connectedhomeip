# OPAMP [Operational Amplifier]

## Introduction 
- The opamp example demonstrates the Unity Gain Buffer or Voltage follower by giving input on
non-inverting terminal of the opamp and checking output.
- In this application we can configure the OPAMP1_PINMUX or OPAMP2_PINMUX or OPAMP3_PINMUX.
  

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

## Configuration and Steps for Execution

- Configure the following macros in opamp.c file and update/modify following macros if required.
```C
#define OPAMP1_PINMUX     1
#define OPAMP2_PINMUX     0
#define OPAMP3_PINMUX     0
``` 
  
## Build 
1. Compile the application in Simplicity Studio using build icon. 

![Figure: Build run and Debug](resources/readme/image509c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio.

## Pin Configuration
|GPIO pin  | Description|
|--- | --- | 
|ULP_GPIO_7 [EXP_HEADER-7] |Non-inverting input|
|ULP_GPIO_4 [EXP_HEADER-11]  |output pin|

## Executing the Application
1. Compile and run the application. 
2. Apply input voltage on Non-Inverting terminal ULP_GPIO_7 pin from constant D.C supply source upto 2.4v.

## Expected Results 
 - Apply input voltage on Non-Inverting terminal ULP_GPIO_7 pin from constant D.C supply source upto2.4v.
 Check the output voltage on the ULP_GPIO_4 pin.
 - Output voltage should be equal to input voltage. Use a Logic analyzer / Oscilloscope  to check output voltage.
  - calculate the offset voltage[offset=Vout-Vin].