# ULP_IR_DECODER

## Introduction 

- This example demonstrates the decoding IR signal pattern and read the receiving data pattern
- In this example generating IR pulse on ULP_GPIO_6 by using systic timer and generate pulses on ULP_GPIO_6
give the input to IR decoder.
- If IR decoder recognize the pulse then IR interrupt is hit,Read the pulses data in  'ir_data[]' 
receiver buffer.


## Setting Up 
- To use this application, following Hardware, Software and the project setup is required

### Hardware Requirements
  - Windows PC 
  - Silicon Labs Si917 Evaluation Kit [WSTK + BRD4325A]
  
![Figure: Introduction](resources/readme/image505a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
  
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDK"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Configuration and Steps for Execution
- Configure the following parameters in ulp_ir_decoder.c file and update/modify following macros if required
   ```C
    #define IR_OFF_DURATION         0x100       //Ir off duration
    #define IR_ON_DURATION          0x10        //Ir on duration
    #define RSI_BLINK_RATE          1000        //Blink rate
    #define SYSTICK_PIN             6           //ULP GPIO PIN
    #define TEST_PIN_IR_INPUT       10U         //Ir decoder input pin
   ``` 

## Loading Application on Simplicity Studio
1. With the product Si917 selected, navigate to the example projects by clicking on Example Projects & Demos 
in simplicity studio and click on to ULP_IR_DECODER Example application as shown below.

![Figure:](resources/readme/image505b.png)

## Build 
1. Compile the application in Simplicity Studio using build icon

![Figure: Build run and Debug](resources/readme/image505c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio


## Pin Configuration
|GPIO pin | Description|
|--- | ---|
|ULP_GPIO_6 [P36]|ULP Gpio pin|
|ULP_GPIO_10 [EXP_HEADER-3]|Ir decoder input pin|

## Executing the Application
 - Compile and run the application.
 - In this example loop back the following pins:
    - ULP_GPIO_10 (IR Decoder input) <==> ULP_GPIO_6 (Systic timer output pin)

## Expected Results 
 - Systic timer generate proper waveform then interrupt is hitting.
 - Connect the logic analyzer ULP_GPIO_6 and Check output.

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