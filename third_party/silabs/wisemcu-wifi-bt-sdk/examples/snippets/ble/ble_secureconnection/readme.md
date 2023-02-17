# BLE Secure Connection

## 1. Purpose / Scope

This application demonstrates how to configure SiWx91x EVK device in peripheral role and how to connect it to a remote device. By default, our module has enable the SMP secure connection is enabled in the module.

In this application, module connects with remote device and initiates SMP pairing process.  After successful SMP pairing, SMP encryption will be enabled in both Central and Peripheral device.


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
- BLE peripheral device which supports privacy feature(Generally phones with the BLE Connect application)
- BLE peripheral device which supports SMP pairing(This Application uses TI sensor tag for a remote device)

### 2.2 Software Requirements
- Embedded Development Environment
   - For Silicon Labs EFx32, use the latest version of [Simplicity Studio](https://www.silabs.com/developers/simplicity-studio)
   
- Download and install the Silicon Labs [EFR Connect App](https://www.silabs.com/developers/efr-connect-mobile-app) in the android smart phones for testing BLE applications. Users can also use their choice of BLE apps available in Android/iOS smart phones.

### 2.3 Setup Diagram:
   
**SoC Mode :**
 <br><img src="resources/readme/blescsoc.png" width=500 height=250 alt=""><br> 
  
**NCP Mode :** 
 <br><img src="resources/readme/blescncp.png" width=500 height=250 alt=""><br> 



## 3. Application Build Environment

### 3.1 Project Setup

- **SoC Mode**
  - **Silicon Labs SiWx91x SoC**. Follow the [Getting Started with SiWx91x SoC](https://docs.silabs.com/) to setup the example to work with SiWx91x SoC and Simplicity Studio.
- **NCP Mode**
  - **Silicon Labs EFx32 Host**. Follow the [Getting Started with EFx32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/) to setup the example to work with EFx32 and Simplicity Studio.
  
### 3.2 NCP Mode - Host Interface 

* By default, the application is configured to use the SPI bus for interfacing between Host platforms(EFR32MG21) and the SiWx91x EVK.
		
### 3.3 Bare Metal/RTOS Support

This application supports bare metal and RTOS environment. By default, the application project files (Keil and Simplicity Studio) are provided with RTOS configuration. To select a bare metal configuration, see [Selecting bare metal](#selecting-bare-metal).

## 4. Application Configuration Parameters

The application can be configured to suit your requirements and development environment. Read through the following sections and make any changes needed.

**4.1** Open `rsi_ble_sc.c` file

**4.1.1** User must update the below parameters 

   `RSI_BLE_DEVICE_NAME` refers the name of the WiSeConnect device to appear during scanning by remote devices.
```c
	 #define RSI_BLE_DEVICE_NAME                              "BLE_SMP_SC"
 ```

   RSI_BLE_SMP_IO_CAPABILITY refers IO capability.
```c
	 #define RSI_BLE_SMP_IO_CAPABILITY                        0x00
```
   RSI_BLE_SMP_PASSKEY refers SMP Passkey
```c
	 #define RSI_BLE_SMP_PASSKEY                              0
```
   Following are the non-configurable macros in the application.
```c
	 #define RSI_BLE_CONN_EVENT                               0x01
	 #define RSI_BLE_DISCONN_EVENT                            0x02
	 #define RSI_BLE_SMP_REQ_EVENT                            0x03
	 #define RSI_BLE_SMP_RESP_EVENT                           0x04
	 #define RSI_BLE_SMP_PASSKEY_EVENT                        0x05
	 #define RSI_BLE_SMP_FAILED_EVENT                         0x06
	 #define RSI_BLE_ENCRYPT_STARTED_EVENT                    0x07
	 #define RSI_BLE_SMP_PASSKEY_DISPLAY_EVENT                0x08
	 #define RSI_BLE_SC_PASSKEY_EVENT                         0X09
	 #define RSI_BLE_LTK_REQ_EVENT                            0x0A
```
   BT_GLOBAL_BUFF_LEN refers Number of bytes required by the application and the driver
```c
	 #define BT_GLOBAL_BUFF_LEN                               15000
```	 
   **Power save configuration**

   By default, The Application is configured without power save.
```c	 
	 #define ENABLE_POWER_SAVE 0
```
   If user wants to run the application in power save, modify the below configuration. 
```c	 
	 #define ENABLE_POWER_SAVE 1 
```

**4.2** Open `rsi_ble_config.h` file and update/modify following macros,

   **Opermode command parameters**
```c
	 #define RSI_FEATURE_BIT_MAP                            FEAT_SECURITY_OPEN
	 #define RSI_TCP_IP_BYPASS                              RSI_DISABLE
	 #define RSI_TCP_IP_FEATURE_BIT_MAP                     TCP_IP_FEAT_DHCPV4_CLIENT
	 #define RSI_CUSTOM_FEATURE_BIT_MAP                     FEAT_CUSTOM_FEAT_EXTENTION_VALID
	 #define RSI_EXT_CUSTOM_FEATURE_BIT_MAP                  0
```

## 5. Testing the Application

Follow the below steps for the successful execution of the application.

### 5.1 Loading the SiWx91x Firmware

Refer [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started) to load the firmware into SiWx91x EVK. The firmware file is located in `<SDK>/firmware/`

### 5.2 Creating the Project and builing the Application
  
Refer [Getting started with EFX32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/), for settin-up EFR & EFM host platforms

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
![projct_selection](resources/readme/projctselection.PNG)
- Click 'Create'. The "New Project Wizard" window appears. Click 'Finish'
![creation_final](resources/readme/creationfinal.PNG)

#### 5.2.4 Build Project - SoC Mode

- Once the project is created, right click on project and go to properties → C/C++ Build → Settings → Build Steps
- Add post_build_script_SimplicityStudio.bat file path (SI917_COMBO_SDK.X.X.X.XX\utilities\isp_scripts_common_flash) in build steps settings as shown in below image.
![postbuild_script](resources/readme/buildsoc.PNG)
- Check for M4 projects macros in preprocessor settings(RSI_M4_INTERFACE=1)
- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
![building_pjt](resources/readme/buildsoc1.png)
- Successful build output will show as below.
![build_success_soc](resources/readme/buildsuccesssoc.PNG)

#### 5.2.5 Build Project - NCP Mode :

- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
![building_pjt](resources/readme/buildncp.PNG)
- Successful build output will show as below.
![build_success_soc](resources/readme/buildsuccessncp.PNG)

## 6. Program the device

Once the build was successfull, right click on project and click on Debug As->Silicon Labs ARM Program as shown in below image.
### SoC Mode :
![debug_mode_soc](resources/readme/debugmodesoc.png)
### NCP Mode : 
![debug_mode_NCP](resources/readme/debugmodencp.png)

### 6.1 Running the SiWx91x Application
   
1. After the program gets executed, Silicon Labs device will be in advertising state.

2. Connect any serial console for prints.

3. Open a EFR Connect mobile App in the Smartphone and do the scan.Ensure that the device is not bonded prior . Open the bonded tab and if the application name appears then click on the three dots beside the name and select delete bond information.

4. In the App, Silcion Labs  will appear with the name configured in the macro "BLE_SMP_SC" or sometimes observed as Silicon Labs device as internal name "SimpleBLEPeripheral".
<br><img src="resources/readme/device_advertising.png"  width=250 alt=""><br>

5. Initiate connection from the App.

6. Observe that the connection is established between the desired device and Silicon Labs device.When application sends a smp request accept it on remote side by clicking ok(pair) and after smp passkey display event .
<br><img src="resources/readme/smp_pairing1.png"  width=250 alt=""><br>

7. Enter the passkey displayed on the console (host logs) on the remote mobile side
<br><img src="resources/readme/smp_pairing.png"  width=250 alt=""><br>

8. After successful connection, application will initiate SMP paring and wait for SMP response event and SMP passkey request event. After receiving SMP response and SMP SC passkey events, application sends SMP response and stores passkey in numeric value and sets SMP Sc Passkey responses event. 
<br><img src="resources/readme/device_connected.png"  width=250 alt=""><br>

9. If SMP is successful, Device sends SMP encrypt started event to host. If not success, Device sends SMP failure event to host.
<br><img src="resources/readme/serial_teriminal_ncp_prints.png"  alt=""><br>


## 7. Observing the output prints on serial terminal

### 7.1 SoC Mode:
- Connect USB to UART connector Tx and GND pins to WSTK radio board.

   - Connect Tx(Pin-6) to P27 on WSTK
   - Connect GND(Pin 8 or 10) to GND on WSTK

      ![FTDI_prints](resources/readme/ftdiprints118.png)
- Prints can see as below in any Console terminal

   ![ouput_prints](resources/readme/serial_teriminal_soc_prints.PNG)

### 7.2 NCP Mode:
- Prints can see as below in any Console terminal

   ![ouput_prints](resources/readme/serial_teriminal_ncp_prints.PNG)

## 8. Selecting Bare Metal
The application has been designed to work with FreeRTOS and Bare Metal configurations. By default, the application project files (Simplicity studio) are configured with FreeRTOS enabled. The following steps demonstrate how to configure Simplicity Studio to test the application in a Bare Metal environment.

### 8.1 Bare Metal with Simplicity Studio
- Open the project in Simplicity Studio
- Right click on the project and choose 'Properties'
- Go to 'C/C++ Build' | 'Settings' | 'GNU ARM C Compiler' | 'Symbols' and remove macro 'RSI_WITH_OS=1'
- Select 'Apply' and 'OK' to save the settings

   ![Figure: project settings in Simplicity Studio](resources/readme/with_out_os.png) 

   ![Figure: project settings in Simplicity Studio](resources/readme/with_out_os1.PNG)

### 8.2 Bare Metal with Keil
- Open project in Keil IDE and click on 'Options for Target'
- Go to 'C/C++' tab and remove 'RSI_WITH_OS' macro present under Preprocessor Symbols
- Click on 'OK' button to save the settings
![project settings in Keil IDE](resources/readme/keil_with_out_os.png)