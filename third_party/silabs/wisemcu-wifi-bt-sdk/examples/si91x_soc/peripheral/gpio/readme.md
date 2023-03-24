# GPIO

## Introduction 

 - This application demonstrate the toggling of GPIO pin in a loop
 - Instances in MCU
   - HP Domain is used to control the SoC GPIO's(GPIO_n; n=0 to 57)
   - ULP Domain is used to control the ULP GPIO's(ULP_GPIO_n; n=0 to 11)
   - UULP Domain which is used to control the UULP GPIO's(UULP_GPIO_n; n=0 to 5)
 - The features and functionality are same in all instances except Register Base Address

## Setting Up 
- To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A]
  
![Figure: Introduction](resources/readme/image501a.png)
  
### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Configure the following parameters in gpio.c (examples/si91x_soc/peripheral/gpio/) file and update/modify following macros if required

   ```c
   #define M4_GPIO_PIN   // To enable M4 GPIO pin uncomment M4_GPIO_PIN and comment ULP_GPIO_PIN ,UULP_GPIO_PIN macros
   #define ULP_GPIO_PIN  // To enable ULP GPIO pin uncomment ULP_GPIO_PIN and comment M4_GPIO_PIN ,UULP_GPIO_PIN macros
   #define UULP_GPIO_PIN // To enable UULP (NPSS) GPIO pin uncomment UULP_GPIO_PIN and comment M4_GPIO_PIN ,ULP_GPIO_PIN macros
   #define PORT 0        // Port selection
   #define PIN  6       // Pin number to connect - |GPIO_6 [P14]| on WSTK
   ```



## Build 
1. Compile the application in Simplicity Studio using build icon.

![Figure: Build run and Debug](resources/readme/image501c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Executing the Application
1. Compile and run the application 
2. Use analyser to see toggle on selected gpio pin

 **Note!** Enable M4_GPIO_PIN for toggling M4 gpio pin or enable ULP_GPIO_PIN for toggling ULP gpio pin or  UULP_GPIO_PIN for NPSS gpio pin

## Expected Results 
 - GPIO should be continously toggled ,connect logic analyser to observe the toggle state
