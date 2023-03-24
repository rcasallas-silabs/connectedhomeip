# Access Point

## 1 Purpose/Scope

This example application demonstrates how to configure the SiWx91x as a SoftAP, connect a station to the SoftAP, and transfer TCP data from the connected station (TCP client) to the SiWx91x SoftAP (TCP server).

## 2 Prerequisites/Set up Requirements

For running the application, you will need the following:

### 2.1 Hardware Requirements

- **NCP Mode**: 
   - [SiWx91x Wi-Fi Expansion Board](https://www.silabs.com/)
   - A Host MCU. This example application has been tested with the following host MCUs.

     - [Silicon Labs EFR32xG21 Starter Kit with Wireless Gecko](https://www.silabs.com/development-tools/wireless/efr32xg21-bluetooth-starter-kit) (SLSWSTK6006A Base board: BRD4001A, Radio board: BRD4180a or BRD4180b)

     - [Silicon Labs EFM32GG11 Starter Kit with Wireless Gecko](https://www.silabs.com/development-tools/mcu/32-bit/efm32gg11-starter-kit) (SLSTK3701A Base board: BRD2204A)

- A Windows PC

- Iperf application

### 2.2 Software Requirements

- Simplicity Studio IDE 

   - Download the [Simplicity Studio IDE](https://www.silabs.com/developers/simplicity-studio).

   - Follow the [Simplicity Studio user guide](https://docs.silabs.com/simplicity-studio-5-users-guide/1.1.0/ss-5-users-guide-getting-started/install-ss-5-and-software#install-ssv5) to install Simplicity Studio IDE.

- [Silicon Labs Gecko SDK](https://github.com/SiliconLabs/gecko_sdk)

- [Si91x COMBO SDK](https://github.com/SiliconLabs/)

**NOTE:**

- This example application supports Bare metal and FreeRTOS configurations.

## 3 Set up
  
#### 3.1 NCP Mode  

Set up diagram for NCP mode:
![Figure: Setup Diagram NCP Mode for Access point Example](resources/readme/ap_ncp.png)

Follow the [Getting Started with EFx32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/) guide to setup the hardware connections and Simplicity Studio IDE.

**NOTE**: 
- The Host MCU platform (EFR32MG21) and the SiWx91x interact with each other through the SPI interface. 
- The Host MCU platform (EFM32GG11) and the SiWx91x interact with each other through the SDIO interface.


## 4 Application Build Environment

1. Ensure the SiWx91x loaded with the latest firmware following the [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started). The firmware file is located at **<Si917 COMBO SDK> → connectivity_firmware**.

2. Ensure the EFx32 and SiWx91x set up is connected to your PC.

### 4.1 Board detection

### 4.1.1 NCP mode

1. In the Simplicity Studio IDE, 
    - The EFR32 board will be detected under **Debug Adapters** pane as shown below.

      **![EFR32 Board detection](resources/readme/efr32.png)**

    - The EFM32 board will be detected under **Debug Adapters** pane as shown below.

      **![EFM32 Board detection](resources/readme/efm32.png)**

### 4.2 Creation of project

Ensure the latest Gecko SDK along with the extension Si91x COMBO SDK is added to Simplicity Studio.

1. Click on the board detected and go to **EXAMPLE PROJECTS & DEMOS** section.

   **![Examples and Demos](resources/readme/examples_demos.png)**

2. Filter for Wi-Fi examples from the Gecko SDK added. For this, check the *Wi-Fi* checkbox under **Wireless Technology** and *Gecko SDK Suite* checkbox under **Provider**. 

3. Under **Device Type**, for SoC based example, check the *SoC* checkbox and for NCP based example, check the *NCP* checkbox.

4. Now choose Wi-Fi- NCP Access Point v6 example for NCP mode and click on **Create**.

   For NCP mode:

   **![Access Point project](resources/readme/ap_example.png)**


5. Give the desired name to your project and cick on **Finish**.

   **![Create Access Point project](resources/readme/create_project.png)**

### 4.3 Application configurations

The application can be configured to suit your requirements and development environment. 

1. In the Project explorer pane, expand the **access_point** folder and open the **rsi_ap_start.c** file. Configure the following parameters based on your requirements.

   **![Application configuration](resources/readme/application_configuration.png)**

   - SSID refers to the name with which the SiWx91x SoftAP's Wi-Fi network shall be advertised.

     ```c
     #define SSID                                  "SILABS_AP"      
     ```
   - SECURITY_TYPE refers to the mode of the SoftAP. Supported security types are OPEN, WPA, and WPA2.

     ```c 
     #define SECURITY_TYPE                           RSI_WPA2 
     ```
   - PSK refers to the secret key if the Access point is configured in WPA-PSK/WPA2-PSK security modes.

     ```c 
     #define PSK                                    "12345678" 
     ``` 
   - ENCRYPTION_TYPE refers to the encryption method of the SoftAP. Supported encryption methods are OPEN, TKIP, CCMP encryption methods.

     ```c 
     #define ENCRYPTION_TYPE                         RSI_CCMP 
     ```
   - CHANNEL_NO refers to the channel in which the SoftAP is to be configured.

     ```c 
     #define CHANNEL_NO                                11
     ```  
   - BEACON_INTERVAL refers to the time interval between two beacons transmission of the SoftAP. Allowed values are integers from 100 to 1000 in multiples of 100.

     ```c 
     #define BEACON_INTERVAL                          100 
     ``` 
   - DTIM_INTERVAL refers to how often the SoftAP informs its connected stations about the buffered data on it. According to below value, the DTIM is sent once in every 4 beacons. Allowed values are from 1 to 255.

     ```c 
     #define DTIM_INTERVAL                             4 
     ``` 
   - DEVICE_IP6 refers to the IP address of the SoftAP.

     ```c 
     #define DEVICE_IP6                           "2001:db8:0:1::121" 
     ```
   - GATEWAY refers to gateway address of the SoftAP.

     ```c 
     #define GATEWAY6                             "2001:db8:0:1::121"
     ```

   - DEVICE_PORT refers to the port number on which TCP Server is opened on SiWx91x.

     ```c 
     #define DEVICE_PORT                           5001 
     ``` 
   - NUMBER_OF_PACKETS refers to the number of packets to be received on TCP Server socket opened on SiWx917 from the TCP client.

     ```c 
     #define NUMBER_OF_PACKETS                     1000 
     ``` 
   - RECV_BUFFER_SIZE is the buffer to store the incoming data on TCP Server socket.

     ```c 
     #define RECV_BUFFER_SIZE                      1000 
     ```
2. Open **rsi\_wlan\_config.h** file and configure the following features as per your requirements.

   **![Configuration file](resources/readme/configuration_file.png)**

   - Opermode parameters

     ```c  
     #define RSI_FEATURE_BIT_MAP           (FEAT_SECURITY_PSK )

     #define RSI_TCP_IP_BYPASS              RSI_DISABLE

     #define RSI_TCP_IP_FEATURE_BIT_MAP    (TCP_IP_FEAT_DHCPV4_SERVER | TCP_IP_FEAT_IPV6 | TCP_IP_FEAT_DHCPV6_SERVER)

     #define RSI_CUSTOM_FEATURE_BIT_MAP            0
     ```
   - Band setting parameters. The Access Point mode supports only 2.4 GHz band.

     ```c 
     #define RSI_BAND                        RSI_BAND_2P4GHZ
     ``` 
   - AP Region configurations. In this example application, the region configurations are disabled by default.

     ```c 
     #define RSI_SET_REGION_AP_SUPPORT RSI_DISABLE

     #define RSI_SET_REGION_AP_FROM_USER RSI_DISABLE

     #define RSI_COUNTRY_CODE "US"
     ```
   - AP configuration command parameters. The SiWx91x SoftAP supports a maximum of 16 stations.

     ```c
     #define RSI_AP_KEEP_ALIVE_ENABLE RSI_ENABLE

     #define RSI_AP_KEEP_ALIVE_TYPE RSI_NULL_BASED_KEEP_ALIVE

     #define RSI_AP_KEEP_ALIVE_PERIOD 100

     #define RSI_MAX_STATIONS_SUPPORT 4
     ```
 
### 4.4 Execution of the Application

Follow the below steps for the successful execution of the application

#### 4.4.1 Build the Project - NCP Mode

1. Check for CHIP_9117 and RSI_CONFIGURE_IPV6 macros in preprocessor settings as mentioned below.
   - Right click on project name.
   - Go to **Properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined Symbols (-D)**.
   - If CHIP_9117 and RSI_CONFIGURE_IPV6 macros is not present, add it by clicking on **ADD** symbol.
   - Click on **Apply and Close**.

     **![Build Project for NCP mode](resources/readme/chip_9117_macro.png)**

2. Click on the build icon (hammer) or right click on project name and choose **Build Project** to build the project.

     **![Build Project for NCP mode](resources/readme/build_project_ncp.png)**

3. Make sure the build returns 0 Errors and 0 Warnings.

### 4.4.2 Set up for application prints

**Tera Term set up - for NCP and SoC modes**

1. Open the Tera Term tool. 

   - For NCP mode, choose the J-Link port and click on **OK**.

     **![J-link - NCP](resources/readme/port_selection.png)**

2. Navigate to the Setup → Serial port and update the baud rate to **115200** and click on **OK**.

    **![Serial port](resources/readme/serial_port_setup.png)**

    **![Baud rate](resources/readme/baud_rate.png)**

### 4.4.3 Execute the application

1. Once the build was successful, right click on project and select **Debug As → Silicon Labs ARM Program** to program the device as shown in below image.

   **![debug_mode_NCP](resources/readme/program_device.png)**

2. As soon as the debug process is completed, the application control branches to the main().

3. Click on the **Resume** icon in the Simplicity Studio IDE toolbar to run the application.

   **![Run](resources/readme/run.png)**

4. After the application gets executed, SiWx91x starts advertizing its SoftAP Wi-Fi network with the specified SSID (in this example, **SILABS_AP**) and listens for TCP connections on specified DEVICE_PORT (in this example, **5001**) and DEVICE_IP6 (in this example, **2001:db8:0:1::121**).
   
5. Now scan for the SiWx91x SoftAP using a PC (you can make use of same PC on which Simplicity Studio IDE is running) and connect to it. After successful connection, run Iperf application on the PC using command prompt.

6. Connect to TCP Server running on SiWx91x using below command:

    `iperf.exe -c <DEVICE_IP6> -V -p <DEVICE_PORT> -t 30 -i 1 `

7. If SOCKET_ASYNC_FEATURE is disabled, the SiWx91x accepts connection request and receives data on the TCP server port and exits after receiving configured NUMBER_OF_PACKETS (in this example, **1000**). Else, the application keeps polling for data asynchronously from the connected client.
  
### 4.4.4 **Application Prints - NCP mode**:

   **![Application prints](resources/readme/application_prints_ncp.png)**

## 5 Selecting Bare Metal configuration

1. By default, the application runs over FreeRTOS. To run the application with Bare metal configurations, follow the below steps.
   - For Simplicity Studio IDE,
      - Right click on project name
      - Go to **Properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined Symbols (-D)**.
      - Select RSI_WITH_OS symbol and click on **Delete** symbol.
      - Click on **Apply and Close**.
      
        **![Bare metal configuration](resources/readme/bare_metal.png)**


