# BLE Heart Rate Profile

## 1. Purpose / Scope

This application demonstrates how to configure SiWx91x EVK as a GATT server with Heart Rate Service in BLE Peripheral Mode and explains how to do indicate operations with the GATT server from a connected remote device using the GATT client.

Also configure EVK as a GATT client in BLE central mode and enable indication of operation of the heart rate service of the connected remote GATT server from the GATT client. In the application,Heart rate GATT server is configured with heart rate service and their corresponding characteristic UUIDs.

When the connected remote device writes data to writable characteristic UUID, the WiseConnect device receives the data that is received on writable characteristic UUID and writes the same data to readable characteristic UUID and sends indications to the connected device (or) remote device can read the same data using read characteristic UUID if indication enabled on client side.

## 2. Prerequisites / Setup Requirements

Before running the application, the user will need the following things to setup.

### 2.1 Hardware Requirements

- Windows PC with Host interface(UART/ SPI/ SDIO).
   - SiWx91x Wi-Fi Evaluation Kit. The SiWx91x supports multiple operating modes. See [Operating Modes]() for details.
  - **SoC Mode**: 
      - Silicon Labs [BRD4325A](https://www.silabs.com/)
  - **NCP Mode**:
      - Silicon Labs [(BRD4180A, BRD4280B)](https://www.silabs.com/);
      - Host MCU Eval Kit. This example has been tested with:
        - Silicon Labs [WSTK + EFR32MG21](https://www.silabs.com/development-tools/wireless/efr32xg21-bluetooth-starter-kit)
        - Silicon Labs [WSTK + EFM32GG11](https://www.silabs.com/development-tools/mcu/32-bit/efm32gg11-starter-kit) 
- BLE Smart Phone with GATT client
### 2.2 Software Requirements
   
- Embedded Development Environment
   - For Silicon Labs EFx32, use the latest version of [Simplicity Studio](https://www.silabs.com/developers/simplicity-studio)
   
- Download and install the Silicon Labs [EFR Connect App](https://www.silabs.com/developers/efr-connect-mobile-app) in the android smart phones for testing BLE applications. Users can also use their choice of BLE apps available in Android/iOS smart phones.

### 2.3 Setup Diagram:
**SoC Mode :**
   ![](resources/readme/bleheartratesoc.png)
 
**NCP Mode :** 
   
![](resources/readme/bleheartratencp.png)
## 3. Application Build Environment

### 3.1 Project Setup

- **SoC Mode**
  - **Silicon Labs SiWx91x SoC**. Follow the [Getting Started with SiWx91x SoC](https://docs.silabs.com/) to setup the example to work with SiWx91x SoC and Simplicity Studio.
- **NCP Mode**
  - **Silicon Labs EFx32 Host**. Follow the [Getting Started with EFx32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/) to setup the example to work with EFx32 and Simplicity Studio.

### 3.2 NCP Mode - Host Interface 

By default, the application is configured to use the SPI bus for interfacing between Host platforms(EFR32MG21) and the SiWx91x EVK.

### 3.3 Bare Metal/RTOS Support

This application supports bare metal and RTOS environment. By default, the application project files (Keil and Simplicity Studio) are provided with RTOS configuration. To select a bare metal configuration, see [Selecting bare metal](#selecting-bare-metal).

## 4. Application Configuration Parameters

The application can be configured to suit your requirements and development environment. Read through the following sections and make any changes needed.

**4.1** Open `rsi_ble_heart_rate.c` file and update/modify following macros,

**4.1.1** User must update the below parameters

- **GATT\_ROLE** refers the role of the Silicon Labs module to be selected.

   - If user configures, **SERVER**, Silicon Labs module will act as GATT SERVER, means will add heart rate profile.

   - If user configures, **CLIENT**, Silicon Labs module will act as GATT CLIENT, means will connect to remote GATT server and get services and enable notify.
```c
	 #define GATT_ROLE                                     SERVER```
- `RSI_BLE_DEV_ADDR_TYPE` refers address type of the remote device to connect.
  - Based on the address of the advertising device, Valid configurations are

    - LE_RANDOM_ADDRESS
    - LE_PUBLIC_ADDRESS
    
    **Note:** Depends 
    - LE_PUBLIC_ADDRESS
```c
	 #define RSI_BLE_DEV_ADDR_TYPE                         LE_PUBLIC_ADDRESS
``` 
   **Note:** Depends on the remote device, address type will be changed. 
   
-   `RSI_BLE_DEV_ADDR` refers address of the remote device to connect.
```c
	 #define RSI_BLE_DEV_ADDR                              "00:23:A7:80:70:B9"
```

-  `RSI_REMOTE_DEVICE_NAME` refers the name of remote device to which Silicon Labs device has to connect.
```c
	 #define RSI_REMOTE_DEVICE_NAME                        "SILABS_DEV"
```	
**Note:**
   Silicon Labs module can connect to remote device by referring either RSI_BLE_DEV_ADDR or RSI_REMOTE_DEVICE_NAME of the remote device.

   **Power save configuration**

-  By default, The Application is configured without power save.
```c	 
	 #define ENABLE_POWER_SAVE 0```
-  If user wants to run the application in power save, modify the below configuration. 
```c	 
	 #define ENABLE_POWER_SAVE 1 
```

**4.1.2** The desired parameters are provided below. User can also modify the parameters as per their needs and requirements
   
- `RSI_BLE_HEART_RATE_UUID` refers to the attribute value of the newly created service.
```c
	 #define RSI_BLE_HEART_RATE_SERVICE_UUID                0x180D```
- `RSI_BLE_HEART_RATE_MEASUREMENT_UUID` refers to the attribute type of the first attribute under this service (RSI_BLE_HEART_RATE_SERVICE_UUID`).
```c
	 #define RSI_BLE_HEART_RATE_MEASUREMENT_UUID            0x2A37```
- `RSI_BLE_SENSOR_LOCATION_UUID` refers to the attribute type of the second attribute under this service (RSI_BLE_HEART_RATE_SERVICE_UUID`).
```c
	 #define RSI_BLE_SENSOR_LOCATION_UUID                   0x2A38```
- `RSI_BLE_HEART_RATE_CONTROL_POINT_UUID` refers to the attribute type of the second attribute under this service (`RSI_BLE_HEART_RATE_SERVICE_UUID`).
```c
	 #define RSI_BLE_HEART_RATE_CONTROL_POINT_UUID          0x2A39```
- `RSI_BLE_MAX_DATA_LEN` refers to the Maximum length of the attribute data.
```c
	 #define RSI_BLE_MAX_DATA_LEN                           20```
- `BLE_HEART_RATE_PROFILE` refers name of the Repine device to appear during scanning by remote devices.
```c
	 #define RSI_BLE_HEART_RATE_PROFILE                     "BLE_HEART_RATE_PROFILE"
```
Following are the **non-configurable** macros in the application.

-  `RSI_BLE_CHAR_SERV_UUID` refers to the attribute type of the characteristics to be added in a service.
```c
	 #define RSI_BLE_CHAR_SERV_UUID                         0x2803```
- `RSI_BLE_CLIENT_CHAR_UUID` refers to the attribute type of the client characteristics descriptor to be added in a service.
```c
	 #define RSI_BLE_CLIENT_CHAR_UUID                       0x2902```
- `RSI_BLE_ATT_PROPERTY_READ` is used to set the read property to an attribute value.
```c
	 #define RSI_BLE_ATT_PROPERTY_READ                      0x02```
- `RSI_BLE_ATT_PROPERTY_WRITE` is used to set the WRITE property to an attribute value.
```c
	 #define RSI_BLE_ATT_PROPERTY_WRITE                     0x08```
- `RSI_BLE_ATT_PROPERTY_NOTIFY` is used to set the NOTIFY property to an attribute value.
```c
	 #define RSI_BLE_ATT_PROPERTY_NOTIFY                    0x10```
- `BT_GLOBAL_BUFF_LEN` refers Number of bytes required by the application and the driver.
```c
	 #define BT_GLOBAL_BUFF_LEN                             15000
```

**4.2** Open `rsi_ble_config.h` file and update/modify following macros,
```c
	 #define RSI_BLE_PWR_INX          30
	 #define RSI_BLE_PWR_SAVE_OPTIONS 0    
	 #define BLE_DISABLE_DUTY_CYCLING 0
     #define BLE_DUTY_CYCLING         1
     #define BLR_DUTY_CYCLING         2
     #define BLE_4X_PWR_SAVE_MODE     4
```
   **Opermode command parameters**
```c
	 #define RSI_FEATURE_BIT_MAP                            FEAT_SECURITY_OPEN
	 #define RSI_TCP_IP_BYPASS                              RSI_DISABLE
	 #define RSI_TCP_IP_FEATURE_BIT_MAP                     TCP_IP_FEAT_DHCPV4_CLIENT
	 #define RSI_CUSTOM_FEATURE_BIT_MAP                     FEAT_CUSTOM_FEAT_EXTENTION_VALID
	 #define RSI_EXT_CUSTOM_FEATURE_BIT_MAP                 0
```
**Note:**
    rsi_ble_config.h files are already set with desired configuration in respective example folders user need not change for each example.


## 5. Testing the Application

- Follow the below steps for the successful execution of the application.

### 5.1 Loading the SiWx91x Firmware
Refer [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started) to load the firmware into SiWx91x EVK. The firmware file is located in `<SDK>/connectivity_firmware/`

### 5.2 Creating the Project and builing the Application
  
- Refer [Getting started with EFX32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/), for settin-up EFR & EFM host platforms

#### 5.2.1 Project Creation - SoC Mode : 

- Connect your board. The Si917 compatible SoC board is **BRD4325A**.
- Studio should detect your board. Your board will be shown here.
   
![](resources/readme/socboarddetection111.png)
#### 5.2.2 Project Creation - NCP Mode : 

- Connect your board. The supported NCP boards are: **BRD4180A,BRD4280B**
- Studio should detect your board. Your board will be shown here.
   
![](resources/readme/ncpboarddetection112.png)
#### 5.2.3 Selecting an example application and generate project

- Go to the 'EXAMPLE PROJECT & DEMOS' tab and select your desired example application
   
![](resources/readme/projctselectionncp.png)
- Click 'Create'. The "New Project Wizard" window appears. Click 'Finish'.
   
![](resources/readme/creationfinalncp1.png)
#### 5.2.4 Build Project - SoC Mode

- Once the project is created, right click on project and go to properties → C/C++ Build → Settings → Build Steps
- Add post_build_script_SimplicityStudio.bat file path (SI917_COMBO_SDK.X.X.X.XX\utilities\isp_scripts_common_flash) in build steps settings as shown in below image.
   
![](resources/readme/image359.png)
- Check for M4 projects macros in preprocessor settings(RSI_M4_INTERFACE=1)
- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
   
![](resources/readme/buildsoc.png)
- Successful build output will show as below.
   
![](resources/readme/buildsuccesssoc1.png)
#### 5.2.5 Build Project - NCP Mode :

- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
   
![](resources/readme/buildncp.png)
- Successful build output will show as below.
   
![](resources/readme/buildsuccessncp1.png)
## 6. Program the device

- Once the build was successfull, right click on project and click on Debug As->Silicon Labs ARM Program as shown in below image.
### SoC Mode :
   
![](resources/readme/debugmodesoc.png)
### NCP Mode : 
   
![](resources/readme/debugmodencp.png)
**Note:** Simillarly, Choose the **Run As** option fo one shot execution.

## 6.1 Running the SiWx91x Application

### 6.1.1 Steps to be followed to verify BLE Hear rate profile application as a SERVER
1. After the program gets executed, If Silicon Labs device is configured as **SERVER** specified in the macro **GATT_ROLE**, Silicon Labs will be in Advertising state.

2. Connect any serial console for prints.

3. Open a EFR Connect App in the Smartphone and do the scan.

4. In the App, Silicon Labs module device will appear with the name configured in the macro `RSI_BLE_HEART_RATE_PROFILE (Ex: "BLE_HEART_RATE")` or sometimes observed as Silicon Labs device as internal name "**SimpleBLEPeripheral**".
   
![](resources/readme/device_advertising.png)
5. Initiate connection from the App.

6. After successful connection, EFR Connect APP displays the supported services of Silicon Labs module.
   
![](resources/readme/device_connection.png)
7. Select the attribute service which is added `RSI_BLE_HEART_RATE_SERVICE_UUID`

8. Enable notify for the characteristic `RSI_BLE_HEART_RATE_MEASUREMENT_UUID`

   So that GATT server indicates when value updated in that particular attribute.
   
![](resources/readme/enable_notifications.png)
9. Whenever the value is updated at server it will be notified to the client which can be read at Heart_Rate_Measurement attribute.
   
![](resources/readme/received_data.png)
10. Refer the below images for console prints
- For SOC the console prints are shown below
   
![](resources/readme/serial_teriminal_prints_soc1.png)
- For NCP the console prints are shown below
   
![](resources/readme/serial_teriminal_prints_ncp1.png)
### 6.1.2 Steps to be followed to verify BLE Hear rate profile application as a CLIENT

1. Configure the **GATT_ROLE** macro as **CLIENT**

2. Connect any serial console for prints.

3. Open the EFR Connect APP and Create the **Hear rate service** to configure the Remote device as a GATT server.
   - Name: Heart Rate
   - UUID: 0x180D

   **Note:** Refer the [Adding Services](https://docs.silabs.com/bluetooth/5.0/miscellaneous/mobile/efr-connect-mobile-app) for creating the GATT server the EFR connect mobile APP as advertiser.
   
![](resources/readme/gatt_configurator5.png)
4. Add the characteristic services and their coresponding properties as shown below
   | S.No | Name | UUID | Property |
   |------|------|------|----------|
   |1|Heart Rate Measurement | 0x2A37 | Notify|
   |2|Body sensor Location | 0x2A38 | Read|
   |3|Heart Rate Control Point | 0x2A39 | Write|
   
   **Note:** Refer the [Adding Characteristics and Descriptors](https://docs.silabs.com/bluetooth/5.0/miscellaneous/mobile/efr-connect-mobile-app) for creating the GATT server in the EFR connect mobile APP.
   ![](resources/readme/gatt_configurator6.png)
5. Enable the **Heart rate** service.
   ![](resources/readme/gatt_configurator9.png)
6. Configure the advertiser.
   
![](resources/readme/advertiser.png)
**Note:** Refer the [Creating New Advertisement Sets](https://docs.silabs.com/bluetooth/5.0/miscellaneous/mobile/efr-connect-mobile-app) for configuring the EFR connect mobile APP as advertiser.

7. When Silicon Labs device is configured as **CLIENT** specified in the macro **GATT_ROLE**, scans for remote device and tries to connect with the remote device specified in `RSI_BLE_DEV_ADDR or RSI_REMOTE_DEVICE_NAME` macro.

8. Get all GATT profiles of remote device and Search for profile specified in the macro `RSI_BLE_HEART_RATE_SERVICE_UUID`. And get all characteristics of the heartrate service and verify the characteristic `RSI_BLE_HEART_RATE_MEASUREMENT_UUID` which has notify property.

9. Observe notify property is enabled in the GATT server and indicates to the GATT client whenever the value is updated at server .
   ![](resources/readme/gatt_configurator10.png)
10. Observe the updated heart rate measurement value on the teraterm. Refer the below images for console prints
- For SOC the console prints are shown below
   ![](resources/readme/serial_teriminal_client_prints_soc1.png)
- For NCP the console prints are shown below
   ![](resources/readme/serial_teriminal_client_prints_ncp1.png)

## 7. Observing the output prints on serial terminal

### 7.1 SoC Mode:
- Connect USB to UART connector Tx and GND pins to WSTK radio board.

   - Connect Tx(Pin-6) to P27 on WSTK
   - Connect GND(Pin 8 or 10) to GND on WSTK
   ![](resources/readme/ftdiprints118.png)
- Prints can see as below in any Console terminal
   ![](resources/readme/serial_teriminal_client_prints_soc1.png)
### 7.2 NCP Mode:
- Prints can see as below in any Console terminal
   ![](resources/readme/serial_teriminal_client_prints_ncp1.png)
## 8. Selecting Bare Metal
- The application has been designed to work with FreeRTOS and Bare Metal configurations. By default, the application project files (Simplicity studio) are configured with FreeRTOS enabled. The following steps demonstrate how to configure Simplicity Studio to test the application in a Bare Metal environment.

### 8.1 Bare Metal with Simplicity Studio
- Open project in Simplicity Studio
- Right click on the project and choose 'Properties'
- GO to 'C/C++ Build' | 'Settings' | 'GNU ARM C Compiler' | 'Preprocessor' and remove macro 'RSI_WITH_OS=1'
- Click on 'Apply' and 'OK' to save the settings
   ![](resources/readme/with_out_os1.png)
   ![](resources/readme/with_out_os1.png)
### 8.2 Bare Metal with Keil
- Open project in Keil IDE and click on 'Options for Target'
- Go to 'C/C++' tab and remove 'RSI_WITH_OS' macro present under Preprocessor Symbols
- Click on 'OK' button to save the settings
   ![](resources/readme/keil_with_out_os.png)
