# RTC [Real Time Clock]

## Introduction 
- This example demonstrates the periodic alarm configuration for every 5 sec with alarm ISR and RTC milliseconds,
 seconds interrupts are also enabled in this example.

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

- Configure the following macros in rtc.c file and update/modify following macros if required.
```C
#define ALARM_PERIODIC_TIME                    5 /*<! periodic alarm configuration in SEC */
#define NO_OF_HOURS_IN_A_DAY                   24
#define NO_OF_MINUTES_IN_AN_HOUR               60
#define NO_OF_SECONDS_IN_A_MINUTE              60
#define NO_OF_MONTHS_IN_A_YEAR                 12
#define BASE_YEAR                              2000
#define NO_OF_DAYS_IN_A_MONTH_1                28
#define NO_OF_DAYS_IN_A_MONTH_2                29
#define NO_OF_DAYS_IN_A_MONTH_3                30
#define NO_OF_DAYS_IN_A_MONTH_4                31

#define ENABLE_RC_CLOCK   1         //By using macro enable the Rc_Clock
#define ENABLE_RO_CLOCK   0         //By using macro enable the Ro_Clock
#define ALARM_INTR        1         //By using macro enable the ALARM_INTR
#define MILLI_SEC_INTR    0         //By using macro enable the MILLI_SEC_INTR
#define SEC_INTR          0         //By using macro enable the SEC_INTR
#define GPIO_TOGGLE       1         //By using macro enable the GPIO_TOGGLE
```   
  
## Build 
1. Compile the application in Simplicity Studio using build icon. 

![Figure: Build run and Debug](resources/readme/image509c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio.

## Pin Configuration
|GPIO pin  | Description|
|--- | --- | 
|ULP_GPIO_5 [EXP_HEADER-13]  |GPIO_TOGGLE|

## Executing the Application
1. configure the ALARM_PERIODIC_TIME as 5 sec in rtc.c file.
2. Compile and run the application.


## Expected Results 
 - Will get "Time and date" print on serial console for every 5 seconds, if ALARM_INTR is enabled.
 - ULP_GPIO will be toggled for every milisecond, if MILI_SEC_INTR is enabled. Observe the output in logic analyser.
 - ULP_GPIO will be toggled for every second, if SEC_INTR is enabled. Observe the output in logic analyser.