# SENSOR HUB

## Introduction 
- This application contains an example code to demonstrate the integration of Sensor Hub and its API's usage. 
  It is a framework which can be easily integrated into any application where sensors handling is required. The Sensor HUB works with sensors as per configurations provided by application and notifies the necessary events to the application through out run. 
  The configuration for the sensors must be provided through sensor hub config file on which the sensor hub should act on.
  The application demonstrates the sensor hub functionalities with the help of two sensors namely bh1750 Light Sensor and a Push Button and prints the data on Debug UART.
  
## Sensor Hub Framework
![Figure: Architecture](resources/readme/image508b.png)


## Setting Up 
 - To use this application following Hardware, Software and the Project Setup is required

### Hardware Requirements	
  - Windows PC 
  - Silicon Labs [Si917 Evaluation Kit WSTK + BRD4325A]
  - bh1750 Light Sensor
 
![Figure: Introduction](resources/readme/image508a.png)

### Software Requirements
  - Si91x SDK
  - Embedded Development Environment
    - For Silicon Labs Si91x, use the latest version of Simplicity Studio (refer **"Download and Install Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html**)
 
## Project Setup
- **Silicon Labs Si91x** refer **"Download SDKs"**, **"Add SDK to Simplicity Studio"**, **"Connect SiWx917"**, **"Open Example Project in Simplicity Studio"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio


### Sensor Setup
![Figure: Sensor Setup](resources/readme/image508c.png)

## Sensor Hub Configuration Parameters

- Configure the sensors info in sensorhub_config.c file, in the config structure 
```C
#define MAX_NUM_SENSORS							// Maximum sensors present in the system

sl_sensor_info_t sensor_info[MAX_NUM_SENSORS];  //  configuration for the sensors  

```   

## Build 
- Compile the application in Simplicity Studio using build icon 

![Figure: Build run and Debug](resources/readme/image508c.png)

## Device Programming
- To program the device ,refer **"Burn M4 Binary"** section in **getting-started-with-siwx917-soc** guide at **release_package/docs/index.html** to work with Si91x and Simplicity Studio


## Expected Results 
- The sensor events should be observed on the Serial Terminal as per the given configuration. 
 
