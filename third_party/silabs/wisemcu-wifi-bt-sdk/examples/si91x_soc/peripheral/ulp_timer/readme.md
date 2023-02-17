# ULP_TIMER

## Introduction 
- This ULP_Timer example uses timer0 to toggle the ULP_GPIO-5  at 1sec rates. The timer0 is configured to 
generate interrupts upon expiration which is when the ULP_GPIO-5 toggled. The first timer is Timer-0 
set to expire at 1-second (1Hz) intervals.
- ULP Timer depends on the TIMER_MATCH_VALUE, which is configurable. When Timer count matches to TIMER_MATCH_VALUE the interrupt hits and the GPIO toggle can be seen. 

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
- **Silicon Labs Si91x** refer **"Download SDK"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio.
 
## Loading Application on Simplicity Studio
1. With the product Si917 selected, navigate to the example projects by clicking on Example Projects & Demos 
in simplicity studio and click on to ULP_TIMER Example application as shown below.

![Figure:](resources/readme/image509b.png)

## Configuration and Steps for Execution

- Configure the following macros in ulp_timer.c file and update/modify following macros if required.
```C
#define TIMER_MATCH_VALUE 500000
```  
## Build 
1. Compile the application in Simplicity Studio using build icon. 

![Figure: Build run and Debug](resources/readme/image509c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio.

## Pin Configuration
|GPIO pin  | Description|
|--- | --- | 
|ULP_GPIO_5 [EXP_HEADER-13] |GPIO_Toggle|

## Executing the Application
1. Compile and run the application. 

## Expected Results 
 - ULP_GPIO_5 should be continously toggled ,connect logic analyser to observe the toggle state.

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