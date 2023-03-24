# HID on GATT

## 1. Purpose / Scope

This application demonstrates how to configure SiWx91x EVK as GATT server in BLE peripheral mode and as GATT client in BLE central mode, and provides details of how to do read, notify and indicate operations with GATT server from connected remote device using GATT client and details of getting GATT information from remote GATT server in case of our module as client. 

HID (Human Interface Device) Service GATT server configures with HID service with notification characteristic UUID. When connected remote device writes data to writable characteristic UUID, module receives the data which is received on writable characteristic UUID and writes the same data to readable characteristic UUID and sends notifications to the connected device (or) remote device can read the same data using read characteristic UUID if notification enabled on client side.

HID Service GATT client will get HID service (primary service) , Report Map (characteristic service), and descriptors(client characteristic configuration and report reference) information from the remote GATT server. If remote device supports notify, our module will enable notify property and will be notified by the remote GATT server when value changed.

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
- BLE supported Smart phone with GATT client in case of our module as GATT server
- BLE supported Smart phone with GATT Human Interface Device server  in case of our module as GATT client



### 2.2 Software Requirements
    
- Embedded Development Environment

   - For Silicon Labs EFx32, use the latest version of [Simplicity Studio](https://www.silabs.com/developers/simplicity-studio)- Download and install the Silicon Labs [EFR Connect App](https://www.silabs.com/developers/efr-connect-mobile-app) in the android smart phones for testing BLE applications. Users can also use their choice of BLE apps available in Android/iOS smart phones.

### 2.3 Setup Diagram:
   
**SoC Mode :** 
![](resources/readme/hidsoc.png)
  
**NCP Mode :**   
![](resources/readme/hidncp.png)
      
   **Note:** Use default Bluetooth application in smart phones which has BLE support.

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

**4.1** Open `rsi_ble_hid.c` file and update/modify following macros.

**4.1.1** User must update the below parameters

  - **GATT\_ROLE** refers the role of the Silicon Labs module to be selected.

      - If user configure **SERVER**, Silicon Labs module will act as GATT SERVER, means will add Human Interface Device service profile.

      - If user configure **CLIENT**, Silicon Labs module will act as GATT CLIENT, means will connect to remote GATT server and get services.
```c
	 #define GATT_ROLE                                        SERVER 
```
   Valid configurations are SERVER and CLIENT.

-   `RSI_BLE_REMOTE_BD_ADDRESS_TYPE` refers address type of the remote device to connect.
```c
	 #define RSI_BLE_REMOTE_BD_ADDRESS_TYPE                   RANDOM_ADDRESS 
```
   Valid configurations are RANDOM_ADDRESS and PUBLIC_ADDRESS.

   - `RSI_BLE_REMOTE_BD_ADDRESS` refers address of the remote device to connect. Replace this with valid BD address.
```c
	 #define RSI_BLE_REMOTE_BD_ADDRESS                        "F5:64:91:A2:F6:6F"
```
   - `RSI_REMOTE_DEVICE_NAME` refers the name of remote device to which Silicon Labs device has to connect
```c
	 #define RSI_REMOTE_DEVICE_NAME                           "Designer Keyboard"
```
   **Note:** User can configure either RSI_BLE_DEV_ADDR or RSI_REMOTE_DEVICE_NAME of the remote device.
   
   **Power save configuration**

   - By default, The Application is configured without power save.
```c 
	 #define ENABLE_POWER_SAVE 0```
-   If user wants to run the application in power save, modify the below configuration. 
```c	 
	 #define ENABLE_POWER_SAVE 1 
```

**4.1.2** The desired parameters are provided below. User can also modify the parameters as per their needs and requirements.

-   `RSI_BLE_HID_SERVICE_UUID` refers to the attribute value of the newly created service.
```c
	 #define RSI_BLE_HID_SERVICE_UUID                         0x1812 
```
   - `RSI_BLE_HID_PROTOCOL_MODE_UUID` refers to the attribute type of the first attribute under this above primary service.
```c
#define RSI_BLE_HID_PROTOCOL_MODE_UUID                   0x2A4E
```
   - `RSI_BLE_HID_REPORT_UUID` refers to the attribute type of the second attribute under this above primary service.
```c
	 #define RSI_BLE_HID_REPORT_UUID                          0x2A4D
``` 
   - `RSI_BLE_HID_REPORT_MAP_UUID` refers to the attribute type of the third attribute under this above primary service.
```c


   - `RSI_BLE_HID_INFO_UUID` refers to the attribute type of the fourth attribute under this above primary service.
```c
	 #define RSI_BLE_HID_INFO_UUID                            0x2A4A
```   
   - `RSI_BLE_HID_CONTROL_POINT_UUID` refers to the attribute type of the fifth attribute under this above primary service.
```c
	 #define RSI_BLE_HID_CONTROL_POINT_UUID                   0x2A4C 
```

-   `RSI_BLE_APP_HIDS` refers name of the Silicon Labs device to appear during scanning by remote devices.
```c
	 #define RSI_BLE_APP_HIDS                                 "HID_OVER_GATT" 
```
**Note:** Following are the non configurable macros related to attribute properties.
```c
	 #define RSI_BLE_ATT_PROP_RD                              0x02
	 #define RSI_BLE_ATT_PROP_WR_NO_RESP                      0x04
	 #define RSI_BLE_ATT_PROP_WR                              0x08
	 #define RSI_BLE_ATT_PROP_NOTIFY                          0x10
	 #define RSI_BLE_ATT_PROP_INDICATE                        0x20 
```
**Note:** Following are the **non-configurable** macros in the application.

-   `RSI_BLE_CHAR_SERV_UUID` refers to the attribute type of the characteristics to be added in a service.
```c
	 #define RSI_BLE_CHAR_SERV_UUID                           0x2803```
-   `RSI_BLE_CLIENT_CHAR_UUID` refers to the attribute type of the client characteristics descriptor to be added in a service.
```c    
	 #define RSI_BLE_CLIENT_CHAR_UUID                         0x2902
```

-  `RSI_BLE_REPORT_REFERENCE_UUID` refers to the attribute type of the report reference descriptor to be added in a service.

```c    
	 #define RSI_BLE_REPORT_REFERENCE_UUID                    0x2908 ```
-   **GLOBAL_BUFF_LEN** refers Number of bytes required by the application and the driver

	 #define GLOBAL_BUFF_LEN                               15000 

   

**4.2** Open `rsi_ble_config.h` file and update/modify following macros, #define RSI_BLE_PWR_INX 8
    
   ```c
	#define RSI_BLE_PWR_INX                                  30
	#define RSI_BLE_PWR_SAVE_OPTIONS                         BLE_DISABLE_DUTY_CYCLING 
   ```

   **Opermode command parameters**  
```c
	 #define RSI_FEATURE_BIT_MAP                              FEAT_SECURITY_OPEN
	 #define RSI_TCP_IP_BYPASS                                RSI_DISABLE
	 #define RSI_TCP_IP_FEATURE_BIT_MAP                       TCP_IP_FEAT_DHCPV4_CLIENT 
	 #define RSI_CUSTOM_FEATURE_BIT_MAP                       FEAT_CUSTOM_FEAT_EXTENTION_VALID
	 #define RSI_EXT_CUSTOM_FEATURE_BIT_MAP                   EXT_FEAT_384K_MODE
```
   **Note:** rsi_ble_config.h files are already set with desired configuration in respective example folders user need not change for each example.
## 5. Testing the Application

- Follow the below steps for the successful execution of the application.

### 5.1 Loading the SiWx91x Firmware

- Refer [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started) to load the firmware into SiWx91x EVK. The firmware file is located in `<SDK>/connectivity_firmware/`

### 5.2 Creating the Project and builing the Application
  
- Refer [Getting started with EFX32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/), for settin-up EFR & EFM host platforms

#### 5.2.1 Project Creation - SoC Mode : 

- Connect your board. The Si917 compatible SoC board is **BRD4325A**.
- Studio should detect your board. Your board will be shown here.
![soc_board_detection](resources/readme/socboarddetection111.png)
#### 5.2.2 Project Creation - NCP Mode : 

- Connect your board. The supported NCP boards are: **BRD4180A,BRD4280B**
- Studio should detect your board. Your board will be shown here.
![ncp_board_detection](resources/readme/ncpboarddetection112.png)
#### 5.2.3 Selecting an example application and generate project

- Go to the 'EXAMPLE PROJECT & DEMOS' tab and select your desired example application
![projct_selection](resources/readme/projctselection1.png)
- Click 'Create'. The "New Project Wizard" window appears. Click 'Finish'
![creation_final](resources/readme/creationfinal1.png)
#### 5.2.4 Build Project - SoC Mode

- Once the project is created, right click on project and go to properties → C/C++ Build → Settings → Build Steps
- Add post_build_script_SimplicityStudio.bat file path (SI917_COMBO_SDK.X.X.X.XX\utilities\isp_scripts_common_flash) in build steps settings as shown in below image.
![postbuild_script](resources/readme/buildsoc2.png)
- Check for M4 projects macros in preprocessor settings(RSI_M4_INTERFACE=1)
- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
![building_pjt](resources/readme/buildsoc1.png)
- Successful build output will show as below.
![build_success_soc](resources/readme/buildsuccesssoc1.png)
#### 5.2.5 Build Project - NCP Mode :

- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
![building_pjt](resources/readme/buildncp1.png)
- Successful build output will show as below.
![build_success_soc](resources/readme/buildsuccessncp1.png)
## 6. Program the device

- Once the build was successfull, right click on project and click on Debug As->Silicon Labs ARM Program as shown in below image.
### SoC Mode :
![debug_mode_soc](resources/readme/debugmodesoc.png)
### NCP Mode : 
![debug_mode_NCP](resources/readme/debugmodencp.png)
### 6.1 Running the SiWx91x Application
   
**Server role**

1. After the program gets executed, Silicon Labs module will be in Advertising state.

2. Connect any serial console for prints.

3. Open a default Bluetooth settings and do the scan.

4. In the App, Silicon Labs module will appear with the name configured in the macro **RSI\_BLE\_APP\_HIDS (Ex: "HID_OVER_GATT")** or sometimes observed as Silicon Labs device as internal name "**SimpleBLEPeripheral**".
![](resources/readme/image73.png)
5. Initiate connection from the Bluetooth settings. It automatically redirects to the pin-code entry pop-up window.
![](resources/readme/image74.png)
6. Enter the **Pin code** which is displayed in the serial teriminal. 
![](resources/readme/image75.png)
7. While connection, smart phone will do service discovery and it will find the HID service with UUID **RSI\_BLE\_HID\_SERVICE\_UUID.** After that it will read report map and enables the notification.

8. After successful connection, open note pad or any text editor in phone, you can see some text printing.
![](resources/readme/image76.png)
9. By default, the application is sending some text (i.e., "hog") in regular intervals, which will come as a notification to a smart phone. Use Notepad or Chrome to observe the received data.
![](resources/readme/image77.png)
10. Refer the below images for console prints

- For SOC the console prints are shown below
![](resources/readme/serial_teriminal_soc_prints1.png)
- For NCP the console prints are shown below
![](resources/readme/serial_teriminal_ncp_prints1.png)
**Client role**

1. Advertise a LE device which supports Human Interface Device Service.

2. After the program gets executed, Silicon Labs module will connect to that remote device based on given BD address.

3. After successful connection Silicon Labs module will read the services from the remote GATT server.

4. If remote device support notify property Silicon Labs module will enable notify, and ready to receive notifications from remote device.

5. Whenever GATT server changes value and notifies that Silicon Labs module will receive that value.


## 7. Observing the output prints on serial terminal

### 7.1 SoC Mode:
- Connect USB to UART connector Tx and GND pins to WSTK radio board.

   - Connect Tx(Pin-6) to P27 on WSTK
   - Connect GND(Pin 8 or 10) to GND on WSTK
![FTDI_prints](resources/readme/ftdiprints118.png)
- Prints can see as below in any Console terminal
![ouput_prints](resources/readme/serial_teriminal_soc_prints1.png)
### 7.2 NCP Mode:
- Prints can see as below in any Console terminal
![ouput_prints](resources/readme/serial_teriminal_ncp_prints1.png)
## 8. Selecting Bare Metal
- The application has been designed to work with FreeRTOS and Bare Metal configurations. By default, the application project files (Simplicity studio) are configured with FreeRTOS enabled. The following steps demonstrate how to configure Simplicity Studio to test the application in a Bare Metal environment.

### 8.1 Bare Metal with Simplicity Studio
- Open the project in Simplicity Studio
- Right click on the project and choose 'Properties'
![Figure: project settings in Simplicity Studio](resources/readme/with_out_os.png) 
- Go to 'C/C++ Build' | 'Settings' | 'GNU ARM C Compiler' | 'Symbols' and remove macro 'RSI_WITH_OS=1'
- Select 'Apply' and 'OK' to save the settings
![Figure: project settings in Simplicity Studio](resources/readme/with_out_os2.png)
### 8.2 Bare Metal with Keil
- Open project in Keil IDE and click on 'Options for Target'
- Go to 'C/C++' tab and remove 'RSI_WITH_OS' macro present under Preprocessor Symbols
- Click on 'OK' button to save the settings
![project settings in Keil IDE](resources/readme/keil_with_out_os.png)
