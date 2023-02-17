# BLINKY

## Introduction 
- This application contains an example code to demonstrate the GPIO/LED toggle functionality


## Setting Up 
 - To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A]
 
![Figure: Introduction](resources/readme/image508a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDK"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Configure the following parameter in blinky.c file, update/modify following macro if required
```C
#define RSI_BLINK_RATE //  configured for 10 ticks per second   
```   
   
## Loading Application on Simplicity Studio
- With the product Si917 selected, navigate to the example projects by clicking on Example Projects & Demos 
in simplicity studio and click on to Blinky Example application as shown below
	
![Figure:](resources/readme/image508b.png)

## Build 
- Compile the application in Simplicity Studio using build icon 

![Figure: Build run and Debug](resources/readme/image508c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Executing the Application
- Sets the board state of LED to on and off for configured blink rate and then device goes to sleep 
 **Note!** LED off ,LED ON ,device sleep will be a continous process 

## Expected Results 
- LED0/LED1 should blink on WSTK base board 
 
