# ADC Static Mode Example

## Introduction 
 - In this mode ADC will generate only one digital value,this mode is used for temperature sensor application
 - ADC Static Mode application configured with following configs in example : 
  - Sampling rate  : 1MSPS (Minimum is 1MSPS[1000000] and Maximum is 2.5MSPS[2500000])
	- Input type     : ADC_INPUT_TYPE  ( Differential ended-1; Single ended-0)
	- Positive input to ADC : ULP_GPIO4
	- Negative input to ADC : ULP_GPIO5
	- Reference Voltage     : 2.8V (Ref vol. to LDO for conversion operation. Min is 1.8V and Max is 3.3V)
	- Number of samples collection for each interrupt : 1
	- Enable "GAIN_OFFSET_CAL_EN" macro and apply the gain-offset calculation on ADC output
	  ADC will convert till 2.8V input voltage(Vref value)

## Setting Up 
 - To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A]
 
![Figure: Introduction](resources/readme/image509a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)   
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution

- Configure the following parameters in adc_static_mode.c file and update/modify following macros if required.
```C
#define NUMBER_OF_CHA_EN       1       // In ADC static mode enable only one ADC channel  
#define CHANNEL0_SAMPLE_LENGTH 1       // Length of sample to collect   
#define CHANNEL0_SAMPLING_RATE 1000000 // Number of samples to collect Min is 1msps and Max is 2.5msps
#define ADC_INPUT_TYPE         1       // Single ended - 0 , Differential ended - 1
float vref_value = 2.8;                // Reference voltage to LDO, Min is 1.8V and Max is 3.3V
```   
   
## Build 
- Compile the application in Simplicity Studio using build icon. 

![Figure: Build run and Debug](resources/readme/image509c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
|Mode | +Ve Input| -Ve Input|
|--- | --- | ---| 
|Single Ended      |ULP_GPIO4 [EXP_HEADER-11]  |    -    |
|Differential Ended|ULP_GPIO4 [EXP_HEADER-11]  |ULP_GPIO5 [EXP_HEADER-13] |
 
**Note!** Make sure "GAIN_OFFSET_CAL_EN" macro is enabled in Preprocessor settings. 

## Executing the Application
1. Compile and run the application 
2. Give the input to ULP_GPIO_4 for single ended mode
  
## Expected Results 
 - ADC output will be printed on UART console
 - Use following formula to find equivalent input voltage of ADC
   **Differential Ended Mode:**
   vout = ((((float)ADC output/(float)4096) * Vref Voltage) - (Verf Voltage/2));
   **Exp**
   If Positive input to ADC given as 2.4V and Negative input given as 1.5 voltage then 
   ADC output will be digital value which is equivalent to 0.9V
   
   **Single ended Mode:** 
   vout = (((float)ADC output/(float)4096) * Vref Voltage);
   **Exp**
   If Positive input to ADC given as 2.4V then ADC output will be digital value which is equivalent to 2.4V      
