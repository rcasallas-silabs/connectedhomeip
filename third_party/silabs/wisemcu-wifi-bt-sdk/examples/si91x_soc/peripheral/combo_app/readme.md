# COMBO APP

## Introduction 
- This application contains a comprehensive sample application which includes multiple perpherals listed below
  - PWM
  - I2C
  - GPIO Interrupts

- This example contains 3 tasks 

**1.I2C**
 - I2C task will initiate once timer interrupt occurs
 - I2C Three instances will be configured in master mode. The SCL and SDA lines of master controller are connected to EEPROM's SCL and SDA pins
  - EEPROM is slave device
  - From master the slave address is sent after START on bus and waits till it gets the ACK respose from the slave
  - The write data to EEPROM memory is based on its page write sequence
  - I2C can be configured with following features
    - I2C standard compliant bus interface with open-drain pins
	- Configurable as Master or Slave
	- Four speed modes: Standard Mode (100 kbps), Fast Mode (400 kbps), Fast Mode Plus (1Mbps) and High-Speed Mode (3.4 Mbps)
	- 7 or 10-bit addressing and combined format transfers	
	
**2.PWM**
 - PWM task will initiate once the push button BTN1 on WSTK interrupt occurs
 - The Motor Control PWM (MCPWM) controller is used to generate a periodic pulse waveform, which is useful in motor control and power control applications 
 - The MCPWM controller acts as a timer to count up to a period count value,the time period and the duty cycle of the pulses are both programmable
 - This application uses the MCPWM driver to create 4 independent PWMs (running at the same frequency),square wave will be generated on 
  PWM_1L,PWM_1H,PWM_2L,PWM_2H
  
  
## Setting Up 
 - To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A]
  - EEPROM devices 3 
 
![Figure: Introduction](resources/readme/image510a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDK"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Pin Configuration
**I2C0**

| PIN | GPIO PIN | Description |
| --- | --- | --- |
| SCL | ULP_GPIO_11 [EXP_HEADER-5] | Connect to EEPROM SCL pin |
| SDA | ULP_GPIO_10 [EXP_HEADER-3] | Connect to EEPROM SDA pin |

**I2C1**

| PIN | GPIO PIN | Description |
| --- | --- | --- |
| SCL | GPIO_50(P19) | Connect to EEPROM SCL pin |
| SDA | GPIO_51(P20) | Connect to EEPROM SDA pin |

**I2C2**

| PIN | GPIO PIN | Description |
| --- | --- | --- |
| SCL | ULP_GPIO_5 [EXP_HEADER-13] | Connect to EEPROM SCL pin |
| SDA | ULP_GPIO_4 [EXP_HEADER-11] | Connect to EEPROM SDA pin |

**PWM**

| PIN | GPIO PIN | Connector |
| --- | --- | --- |
| PWM_1L | GPIO_64(ULP_GPIO_0) | EXP_HEADER-9  |
| PWM_1H | GPIO_7              | P37           |
| PWM_2L | GPIO_8              | EXP_HEADER-14 |
| PWM_2H | GPIO_9              | EXP_HEADER-12 |


**GPIO Interrupt**

| GPIO PIN | Connector |
| --- | --- | 
| GPIO_11 | P15 |
 


## Loading Application on Simplicity Studio
1. With the product Si917 selected, navigate to the example projects by clicking on Example Projects & Demos 
in simplicity studio and click on to combo_app Example application as shown below.
	
![Figure:](resources/readme/image510b.png)

## Build 
1. Compile the application in Simplicity Studio using build icon

![Figure: Build run and Debug](resources/readme/image510c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio

## Executing the Application
1. When the application runs,it triggers 3 tasks(I2C,PWM,Main task) 
2. For each timer interrupt I2C will be initiated ,Three I2C instances will writes data to EPPROM and reads back from EEPROM.
3. Press push button BTN1 on WSTK board ,and check PWM output on PWM pins as mentioned above

## Expected Results 
**I2C**

 - Will get "I2C Transfer success" print on console when three I2C instances data transfers are success
 - Add read_buff,read_buff1,read_buff2 to the watch window to check data
 - Both write and read 16 bits of data should be same 
 
**PWM**
 
 - Check PWM output on PWM GPIOs by connecting logic analyser 
