# ANALOG COMPARATOR

## Introduction 
- This example demonstrates analog comparator functionality. If non-inverting input voltage is greater than
  inverting input voltage then analog comparator output will be high and analog comparator interrupt will hit.

- Following Configuration are used in example :
  - Non-inverting input pin -> ULP_GPIO_0 
  - Inverting input pin     -> ULP_GPIO_1 
  - Comparator number       -> Comparator1 is using in this application.


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
 


## Configuration and Steps for Execution

- Configure the following macros in analog_comparator.c file and update/modify following macros if required.
```C
#define COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_EXTERNAL   1 : When this macro is enabled, non-invertring and inverting inputs are fed into comparator1 from GPIO.
#define COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_REF_SCALER 0 : When this macro is enabled, non-invertring input is fed into comparator1 from GPIO, while inverting input is fed into the internal reference scaler.
```
- Note -> At a time only one MACRO should be enable from above MACROs.   
  
## Build 
1. Compile the application in Simplicity Studio using build icon. 

![Figure: Build run and Debug](resources/readme/image509c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio.

## Pin Configuration
|GPIO pin  | Description|
|--- | --- | 
|ULP_GPIO_0 [EXP_HEADER-9] |Non-inverting input|
|ULP_GPIO_1(P16)           |Inverting input    |
|ULP_GPIO_5 [EXP_HEADER-13]|Output Pin         |

## Executing the Application
1. Compile and run the application. 

2. If 'COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_EXTERNAL' MACRO is enabled, then connect external voltage to following pins
  - Non-inverting input : ULP_GPIO_0 
  - Inverting input     : ULP_GPIO_1 
  
3. If 'COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_REF_SCALER' MACRO is enabled, then connect external voltage to following pin
  - voltage to non-inverting terminal : ULP_GPIO_0 
  - inverting terminal will be connected to the reference scaler output.


## Expected Results 
 - If 'COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_EXTERNAL' MACRO is enabled, then
 
  - If Applied ULP_GPIO_0 input supply >= Applied ULP_GPIO_1 input supply, then the comparator output will be high, interrupt will hit, ULP_GPIO_5 will toggle.
                                                        Observe the ULP_GPIO_5 status by using a logic analyzer.                                 
  
  - If Applied ULP_GPIO_0 input supply < Applied ULP_GPIO_1 input supply, then comparator output will be low, interrupt will not hit, ULP_GPIO_5 will not toggle.
                                                        Observe the ULP_GPIO_5 status by using a logic analyzer.
  
 - If 'COMP1_POS_INPUT_EXTERNAL_NEG_INPUT_REF_SCALER' MACRO enable
 
  - If Applied ULP_GPIO_0 input supply >= 0.8V(reference scaler output), then comparator output will be high, interrupt will hit, ULP_GPIO_5 will toggle.
                                                        Observe the ULP_GPIO_5 status by using a logic analyzer.
  
  - If Applied ULP_GPIO_0 input supply < 0.8V(reference scaler output), then comparator output will be low, interrupt will not hit, ULP_GPIO_5 will not toggle.
                                                        Observe the ULP_GPIO_5 status by using a logic analyzer.