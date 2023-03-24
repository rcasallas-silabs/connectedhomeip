# CTS

## Introduction
- This application demonstrates how to use Capacitive touch sensor in Si917 chip. 
- Connect the external touch pannel pins to the Si917 radio board.
  - Touch Pannel_Sensor-1         - ulp_gpio-8
  - Touch Pannel_Sensor-2         - ulp_gpio-9
  - Touch Pannel_Sensor-3         - ulp_gpio-10
  - Touch Pannel_Sensor-4         - ulp_gpio-7
  - Touch Pannel_Sensor-5         - ulp_gpio-6
  - Touch Pannel_Sensor-7         - ulp_gpio-0
  - Touch Pannel_Sensor-8         - ulp_gpio-11
  - Touch Pannel_VCC              - Vref of WPK(VRF pin)
  - Touch Pannel_GND              - Gnd of WPK(GND pin)
  - Touch Pannel_RC circuit pins  - ulp_gpio-5,ulp_gpio-4
- To integrate the RC circuits pins connect ULP_GPIO_4 to gnd (Cap = 2.2nF) and ULP_GPIO_4 to ULP_GPIO_5 (R=5Kohm)


## Note
  - Touch_sensor pin number 6 has no connection as it is disabled in the software.
  - This example works only with WPK-BRD4002A base board.
  - Touch Panel Sensor 2 and UART_TX (which is used for prints) uses same GPIO. 

## Setting Up 
- To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WPK + BRD4325A]
  - Capictive Touch Sensor part number: TTP22916
 
![Figure: Introduction](resources/readme/image502a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio


## Build 
1. Compile the application in Simplicity Studio using build icon

![Figure: Build run and Debug](resources/readme/image502c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
|GPIO pin  | Description|
|--- | --- | 
|Vref of WPK                  |Touch Pannel_VCC       |
|Gnd of WPK                   |Touch Pannel_GND       |
|ULP_GPIO_8  [F11(WPK)]       |Touch Pannel_Sensor-1  |
|ULP_GPIO_9  [P27/F20]        |Touch Pannel_Sensor-2  |
|ULP_GPIO_10 [EXP_HEADER-3]   |Touch Pannel_Sensor-3  |
|ULP_GPIO_7  [EXP_HEADER-7]   |Touch Pannel_Sensor-4  |
|ULP_GPIO_6  [P36]            |Touch Pannel_Sensor-5  |
|ULP_GPIO_0  [EXP_HEADER-9]   |Touch Pannel_Sensor-7  |
|ULP_GPIO_11 [EXP_HEADER-5]   |Touch Pannel_Sensor-8  |
|ULP_GPIO_4  [EXP_HEADER-11]  |Touch Pannel_RC Ciruct |
|ULP_GPIO_5  [EXP_HEADER-13]  |Touch Pannel_RC Circuit|


## Executing the Application
1. Compile and run the application.
2. Connect the touch pannel pins to the corresponding pins of WSTK and Radio board.

## Expected Results 
 - The console displays the corresponding print when any of the 7 sensors on the touch panel is touched.
 - EX:
    - If sensor 1 is touched then it will print "sensor 1 is pressed" on console.
