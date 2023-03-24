# WLAN Station BLE Provisioning

##  1. Purpose / Scope

This example demonstrates how to configure/connects SiWx91x EVK to get the WLAN connection functionality using BLE provisioning.

SiWx91x EVK starts advertising in BLE mode and Access Point details are fetched using BLE Provisioning.

SiWx91x EVK is configured as a WiFi station and connects to an Access Point.

## 2. Prerequisites / Setup Requirements

Before running the application, the user will need the following things to setup.

### 2.1 Hardware Requirements

- Windows PC.
- SiWx91x Wi-Fi Evaluation Kit. The SiWx91x supports multiple operating modes. See [Operating Modes]() for details.
  - **SoC Mode**: 
      - Silicon Labs [BRD4325A](https://www.silabs.com/)
  - **NCP Mode**:
      - Silicon Labs [(BRD4180A, BRD4280B)](https://www.silabs.com/); **AND**
      - Host MCU Eval Kit. This example has been tested with:
        - Silicon Labs [WSTK + EFR32MG21](https://www.silabs.com/development-tools/wireless/efr32xg21-bluetooth-starter-kit)
        - Silicon Labs [WSTK + EFM32GG11](https://www.silabs.com/development-tools/mcu/32-bit/efm32gg11-starter-kit)
        - [STM32F411 Nucleo](https://st.com/)
-  Wireless Access point
-  Android Phone or iPhone with **EFR Connect** App, which is available in Play Store and App Store.
            
      (**OR**)
-  Android Phone or iPhone with **Silabs_connect.apk** App, which is available in $\wiseconnect\utilities\ble_provisioning_apps\android_based_provisioning_app in Si917 release.

     (**OR**)
-  Windows PC with windows Silicon labs connect application.
### 2.2 Software Requirements
    
- Embedded Development Environment

   - For Silicon Labs EFx32, use the latest version of [Simplicity Studio](https://www.silabs.com/developers/simplicity-studio)- Download and install the Silicon Labs [EFR Connect App](https://www.silabs.com/developers/efr-connect-mobile-app) in the android smart phones for testing BLE applications. Users can also use their choice of BLE apps available in Android/iOS smart phones.
- Python version 3.7.9 (https://www.python.org/downloads/release/python-379)
- Install the “bleak” & “pillow” python packages (“pip install bleak”, “pip install pillow”)
### **SoC Mode** : 

- WLAN Station BLE Provisioning with Android EFR Connect App
![](resources/readme/image279wsbpa.png)
- WLAN Station BLE Provisioning with windows based Silicon Labs Connect App
  ![](resources/readme/bleprovisioningsetup.png)
  
### **NCP Mode** : 

- WLAN Station BLE Provisioning with Android EFR Connect App
![](resources/readme/image279wsbpancp.png)
- WLAN Station BLE Provisioning with windows based Silicon Labs Connect App
  ![](resources/readme/bleprovisioningncp.png)
### 3. Application Build Environment

### 3.1 Project Setup
- **SoC Mode**
  - **Silicon Labs SiWx91x SoC**. Follow the [Getting Started with SiWx91x SoC](https://docs.silabs.com/) to setup the example to work with SiWx91x SoC and Simplicity Studio.
- **NCP Mode**
  - **Silicon Labs EFx32 Host**. Follow the [Getting Started with EFx32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/) to setup the example to work with EFx32 and Simplicity Studio.
  - **STM32F411 Host**. Follow the [Getting Started with STM32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-stm32/) to setup the example to work with STM32 and Keil.

### 3.2 NCP Mode-Host Interface

* By default, the application is configured to use the SPI bus for interfacing between Host platforms and the SiWx91x EVK.
* The SAPI driver provides the macros to enable other host interfaces if SPI is not suitable for your needs.

### Bare Metal/RTOS Support

The Application supports both FreeRTOS and bare metal configurations.

- By default, the application project files (Keil and Simplicity Studio) are provided with RTOS enabled in the SDK, so the application can be tested/validated under OS environment. 
- Follow the below steps for changing the project configuration in Keil and Simplicity Studio  to test the application in the bare metal environment.
    
   **Steps to configure project settings in Keil IDE**
    - Open project in Keil IDE and click on 'Options for Target'
    - Go to 'C/C++' tab and remove 'RSI_WITH_OS' macro present under Preprocessor Symbols
    - Click on 'OK' button to save the settings
   ![](resources/readme/keil_with_out_os.png)
  **Steps to configure project settings in Simplicity Studio**
    - Open project in Simplicity Studio
    - Right click on the project and choose 'Properties'
    - GO to 'C/C++ Build' | 'Settings' | 'GNU ARM C Compiler' | 'Preprocessor' and remove macro 'RSI_WITH_OS=1'
    - Click on 'Apply' and 'OK' to save the settings 
![](resources/readme/image279b.png)
![](resources/readme/image279c.png)

## 4. Application Configuration Parameters

The application can be configured to suit your requirements and development environment. Read through the following sections and make any changes needed.

**4.1** Open `main.c` file

Memory length for driver
```c
#define GLOBAL_BUFF_LEN                            15000
```

The following parameters are configured if OS is used. 

Task Priotrities should be given as below. Application task priority should be given as low priority and Driver task priority should be given as highest priority
```c
#define RSI_APPLICATION_TASK_PRIORITY                 1
#define RSI_BLE_TASK_PRIORITY                         2
#define RSI_DRIVER_TASK_PRIORITY                      3
```
   
Application Task stack size is configured by this macro
```c
#define RSI_APPLICATION_TASK_STACK_SIZE             1000
```

BLE Task stack size is configured by this macro
```c
#define RSI_BLE_TASK_STACK_SIZE                     1000
```
   
Driver Task stack size is configured by this macro
```c
#define RSI_DRIVER_TASK_STACK_SIZE                  2000
```

**4.2** Open `rsi_wlan_app.c` file and update/modify following macro

Memory length for the send buffer
```c
#define RSI_APP_BUF_SIZE                            1600
```


**4.3** Open `rsi_wlan_config.h` file 

```c
#define CONCURRENT_MODE                          RSI_DISABLE
#define RSI_FEATURE_BIT_MAP                      (FEAT_SECURITY_OPEN | FEAT_AGGREGATION)
#define RSI_TCP_IP_BYPASS                        RSI_DISABLE
#define RSI_TCP_IP_FEATURE_BIT_MAP               (TCP_IP_FEAT_DHCPV4_CLIENT | TCP_IP_TOTAL_SOCKETS_1 | TCP_IP_FEAT_EXTENSION_VALID) 
#define RSI_CUSTOM_FEATURE_BIT_MAP               FEAT_CUSTOM_FEAT_EXTENTION_VALID
#define RSI_EXT_CUSTOM_FEATURE_BIT_MAP           (EXT_FEAT_LOW_POWER_MODE | EXT_FEAT_XTAL_CLK_ENABLE | EXT_FEAT_512K_M4SS_192K)
#define RSI_EXT_TCPIP_FEATURE_BIT_MAP            EXT_DYNAMIC_COEX_MEMORY
#define RSI_BAND                                 RSI_BAND_2P4GHZ
#define RSI_BT_FEATURE_BITMAP                    (BT_RF_TYPE | ENABLE_BLE_PROTOCOL)
```

> Note: 
> rsi_wlan_config.h, rsi_bt_config.h and rsi_ble_config.h files are already set with the above desired configuration for this example.


**4.4** Open `rsi_ble_app.c` file and update/modify following macros

RSI\_BLE\_CHAR\_SERV\_UUID refers to the attribute type of the characteristics to be added in a service.
   
```c
#define  RSI_BLE_CHAR_SERV_UUID                         0x2803
```

RSI\_BLE\_CLIENT\_CHAR\_UUID refers to the attribute type of the client characteristics descriptor to be added in a service.
    
```c
#define RSI_BLE_CLIENT_CHAR_UUID                        0x2902
```

RSI\_BLE\_NEW\_SERVICE\_UUID refers to the attribute value of the newly created service.
```c
#define  RSI_BLE_NEW_SERVICE_UUID                       0xAABB
```

RSI\_BLE\_ATTRIBUTE\_1\_UUID refers to the attribute type of the first attribute under this service (RSI_BLE_NEW_SERVICE_UUID).
```c
#define  RSI_BLE_ATTRIBUTE_1_UUID                        0x1AA1
```

RSI\_BLE\_ATTRIBUTE\_2\_UUID refers to the attribute type of the second attribute under this service (RSI_BLE_NEW_SERVICE_UUID).
```c
#define RSI_BLE_ATTRIBUTE_2_UUID                         0x1BB1
```

RSI\_BLE\_ATTRIBUTE\_3\_UUID refers to the attribute type of the third attribute under this service (RSI_BLE_NEW_SERVICE_UUID).
```c
#define RSI_BLE_ATTRIBUTE_3_UUID                         0x1CC1
```

RSI\_BLE\_MAX\_DATA\_LEN refers to the Maximum length of the attribute data.
```c
#define RSI_BLE_MAX_DATA_LEN                             66
```

RSI\_BLE\_APP\_DEVICE\_NAME refers to the name of the SiWx91x EVK to appear during scanning by remote devices.
```c
#define  RSI_BLE_APP_DEVICE_NAME                         "BLE_CONFIGURATOR"
```

The following are the **non-configurable** macros in the application.

RSI_BLE_ATT_PROPERTY_READ is used to set the READ property to an attribute value.
```c
#define  RSI_BLE_ATT_PROPERTY_READ                       0x02
```

RSI\_BLE\_ATT\_PROPERTY\_WRITE is used to set the WRITE property to an attribute value.
```c
#define RSI_BLE_ATT_PROPERTY_WRITE                       0x08
```

RSI\_BLE_ATT\_PROPERTY\_NOTIFY is used to set the NOTIFY property to an attribute value.
```c
#define  RSI_BLE_ATT_PROPERTY_NOTIFY                     0x10
```

BT\_GLOBAL\_BUFF\_LEN refers to the number of bytes required by the application and the driver.
```c
#define  BT_GLOBAL_BUFF_LEN                              15000
```

## 5. Testing the Application

- Follow the below steps for the successful execution of the application.

### 5.1 Loading the SiWx91x Firmware

- Refer [Getting started with PC ](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started) to load the firmware into SiWx91x EVK. The firmware binary is located in `<SDK>/connectivity_firmware/`

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
![](resources/readme/projctselection.png)
- Click 'Create'. The "New Project Wizard" window appears. Click 'Finish'
![](resources/readme/creationfinal.png)
#### 5.2.4 Build Project - SoC Mode
- Once the project is created, right click on project and go to properties -> C/C++ Build -> Settings -> Build Steps
- Add post_build_script_SimplicityStudio.bat file path (SI917_COMBO_SDK.X.X.X.XX\utilities\isp_scripts_common_flash) in build steps settings as shown in below image.
![](resources/readme/buildpathsoc1.png)
- Check for M4 projects macros in preprocessor settings(RSI_M4_INTERFACE=1)
- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
![](resources/readme/buildsoc2.png)
- Successful build output will show as below.  
![](resources/readme/buildsuccesssoc1.png)
#### 5.2.5 Build Project - NCP Mode :

##### **Using EFX32:**

- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
![](resources/readme/buildncp.png)
- Successful build output will show as below.
![](resources/readme/buildsuccessncp1.png)
- Compile and flash the project in to Host MCU
- Debug the project
- Free run the project
- Then continue the common steps from **Section 5.3**

##### **Using STM32:**

- Refer [STM32 Getting Started](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/)  

- Open the project `<SDK>/examples/snippets/wlan_ble/wlan_station_ble_provisioning/projects/wlan_station_ble_provisioning-nucleo-f411re.uvprojx` in Keil IDE.
- Build and Debug the project
- Check for the RESET pin:
  - If RESET pin is connected from STM32 to SiWx91x EVK, then user need not press the RESET button on SiWx91x EVK before free run.
  - If RESET pin is not connected from STM32 to SiWx91x EVK, then user need to press the RESET button on SiWx91x EVK before free run.
- Free run the project
- Then continue the common steps from **Section 5.3**


### 5.3 Steps to verify the WLAN Station BLE Provisioning Example


#### 5.3.1 Steps to be followed to verify WLAN Station BLE Provisioning with Android **EFR Connect** App

1. Configure the Access point in OPEN/WPA-PSK/WPA2-PSK mode to connect the SiWx91x EVK in STA mode.
2. Connect any serial console for prints.
3. When SiWx91x EVK enters BLE advertising mode, launch the **EFR Connect** App.
  ![](resources/readme/efr_connect.png)
4. Click on Demo and select Wifi-Commissioning tile.
![](resources/readme/demo.png)
5. The Si917 advertises as the "BLE_CONFIGURATOR". Click on "BLE_CONFIGURATOR".
![](resources/readme/ble_configurator.png)
6. Once the BLE got the connected, list of available Access Points in the vicinity, get displayed on the screen.
![](resources/readme/list_of_aps.png)
7. Select the AP from the scanned list as shown below. 
![](resources/readme/ap_selection.png)
8. If the selected AP is configured in the security, the password entry pop-up window will be appeared. 
![](resources/readme/ap_connection.png)
9. Enter the password and click on "CONNECT".
![](resources/readme/psk.png)
10. Connect to an Access Point, once the SiWx91x EVK gets connected to AP, IP address of SiWx91x EVK get displyed on the screen.
![](resources/readme/ip_address.png)
11. To disconnect from Access Point, click on connected AP and click on YES 
![](resources/readme/disconnect_ap.png)
12. Refer the below figure for console prints
- For SOC the console prints are shown below
![](resources/readme/serial_teriminal_soc_prints1.png)
- For NCP the console prints are shown below
![](resources/readme/serial_teriminal_ncp_prints1.png)
#### 5.3.2 Steps to be followed to verify WLAN Station BLE Provisioning with windows based Silicon Labs Connect App

1. Configure the Access point in OPEN/WPA-PSK/WPA2-PSK mode to connect the SiWx91x EVK in STA mode.
2. Connect any serial console for prints.
   **Note:** 
   - Turn on BT in the PC.
   - Make sure to install the pillow & bleak tools. For more information on tools installation please refer the "Installation steps to run silabs connect windows application" document will be available in the `<SDK>/utilities/ble_provisioning_apps/windows_based_provisioning_app/` path.
3. Go to folder  `<SDK>/utilities/ble_provisioning_apps/windows_based_provisioning_app/` and Run **Silabs_Connect.py** in the command prompt.   
4. Executing the application in the command prompt as stated in the above point will open the GUI (with the "BLE SCAN ON" button.)
![](resources/readme/imageble1.png)  
5. When click on the **BLE SCAN ON** button, all the RS9116 BLE Devices that are available nearby are displayed in the window.  
![](resources/readme/imageble3.png)   
   **Note:** - RS9116 BLE device will advertise with different names based on the application configuration.
6. Once RS9116 BLE device displayed on the scanning list, initiate the connection by clicking a button on the available RS9116 BLE device.
![](resources/readme/imageble4.png)   
7. Once the BLE get connected, **Firmware version** and list of available Access Points get displayed on the screen.
![](resources/readme/imageble5.png) 
8. By clicking on one of the scanned AP's, RS9116 will connect to that particular AP. If Access Point is secured it will ask the password as input but if that Access point as not secured, then directly connect to that Access Point.
![](resources/readme/imageble7.png)
9. After successful connection, IP & Mac address of connected Access point get displayed.
![](resources/readme/imageble8.png)
10. To disconnect from Access Point, click on connected AP.
11. After successful disconnection of WLAN, pop-up comes like **WLAN GOT DISCONNECTED**. Click on the "POCO C3".
![](resources/readme/imageble9.png)
![](resources/readme/imageble10.png)
   **Note:**   For more information refer **Silabs_Connect_Windows_Application_User_Guide.pdf** in the path 
   `<SDK>/utilities/ble_provisioning_apps/windows_based_provisioning_app/`

