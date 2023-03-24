# WDT [Watch Dog Timer]

## Introduction 
- This examples demonstrates the WDT warning triggers in the WDT interrupt handler and then restarts the application.

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

## Executing the Application
1. Compile and run the application.

## Expected Results 
 - The watchdog timer generates 10 warning messages on console and for every warning message LED0 will be toggled. 
 - After 10 warning masseges watchdog time will restart the application.
 - The following prints are displayed on the console or any serial terminal.
    Main..!
    Power on RESET occurred..
    WDT handler 1
    WDT handler 2
    WDT handler 3
    WDT handler 4
    WDT handler 5
    WDT handler 6
    WDT handler 7
    WDT handler 8
    WDT handler 9
    WDT handler 10
    Main..!
    WDT RESET occurred..