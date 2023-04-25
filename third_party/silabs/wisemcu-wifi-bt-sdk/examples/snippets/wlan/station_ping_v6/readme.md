# Station Ping

## 1 Purpose/Scope

Ping is used diagnostically to ensure that a host computer the user is trying to reach is actually operating. Ping works by sending an Internet Control Message Protocol (ICMP) Echo Request to a specified interface on the network and waiting for a reply. Ping can be used for troubleshooting to test connectivity and determine response time.
The application demonstrates how to configure Silicon Labs device in client mode to send ping request to target IP address.

## 2 Prerequisites/Set up Requirements

For running the application, you will need the following:

### 2.1 Hardware Requirements

- **NCP Mode**:
   - [SiWx91x Wi-Fi Expansion Board](https://www.silabs.com/)
   - A Host MCU. This example application has been tested with the following host MCUs.

     - [Silicon Labs EFR32xG21 Starter Kit with Wireless Gecko](https://www.silabs.com/development-tools/wireless/efr32xg21-bluetooth-starter-kit) (SLSWSTK6006A Base board: BRD4001A, Radio board: BRD4180a or BRD4180b)

     - [Silicon Labs EFM32GG11 Starter Kit with Wireless Gecko](https://www.silabs.com/development-tools/mcu/32-bit/efm32gg11-starter-kit) (SLSTK3701A Base board: BRD2204A)

- A Windows PC

### 2.2 Software Requirements

- Simplicity Studio IDE

   - Download the [Simplicity Studio IDE](https://www.silabs.com/developers/simplicity-studio).

   - Follow the [Simplicity Studio user guide](https://docs.silabs.com/simplicity-studio-5-users-guide/1.1.0/ss-5-users-guide-getting-started/install-ss-5-and-software#install-ssv5) to install Simplicity Studio IDE.

- [Silicon Labs Gecko SDK](https://github.com/SiliconLabs/gecko_sdk)

- [Si917 COMBO SDK](https://github.com/SiliconLabs/)

**NOTE:**

- This example application supports Bare metal and FreeRTOS configurations.

## 3 Set up

#### 3.1 NCP Mode  

Set up diagram for NCP mode:

![Figure: Setup Diagram NCP Mode for Station Ping Example](resources/readme/setup_ncp.png)

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

      **![EFR32 Board detection](resources/readme/efr32_board_detection.png)**

    - The EFM32 board will be detected under **Debug Adapters** pane as shown below.

      **![EFM32 Board detection](resources/readme/efm32_board_detection.png)**

### 4.2 Creation of project

Ensure the latest Gecko SDK along with the extension Si917 COMBO SDK is added to Simplicity Studio.

1. Click on the board detected and go to **EXAMPLE PROJECTS & DEMOS** section.

   **![Examples and Demos](resources/readme/examples_demos.png)**

2. Filter for Wi-Fi examples from the Gecko SDK added. For this, check the *Wi-Fi* checkbox under **Wireless Technology** and *Gecko SDK Suite* checkbox under **Provider**.

3. Under provider, for SoC based example, check the *SoC* checkbox and for NCP based example, check the *NCP* checkbox.

4. Now choose Wi-Fi- NCP  Client ICMP Ping v6 example for NCP mode and click on **Create**.

    For NCP mode:

   **![Station Ping project](resources/readme/station_ping_example_ncp.png)**

5. Give the desired name to your project and cick on **Finish**.

   **![Create Station Ping project](resources/readme/create_project.png)**

### 4.3 Application configurations

The application can be configured to suit user requirements and development environment.
  
1. In the Project explorer pane, expand the **station_ping** folder and open the **rsi_station_ping.c** file. Configure the following parameters based on your requirements.

   **![Application configuration](resources/readme/application_configuration.png)**
  
```c
#define SSID           "SILABS_AP"      // Wi-Fi Network Name
#define PSK            "1234567890"     // Wi-Fi Password
#define SECURITY_TYPE  RSI_WPA2         // Wi-Fi Security Type: RSI_OPEN / RSI_WPA / RSI_WPA2
#define CHANNEL_NO     0                // Wi-Fi channel if the softAP is used (0 = auto select)
```

AP_BSSID  refer  to BSSID of AP, join based up on BSSID (Example : If two Access points had same SSID then at the time based on this BSSID,module will join to particular AP). This feature is valid only if  RSI_JOIN_FEAT_BIT_MAP set to RSI_JOIN_FEAT_BSSID_BASED in the rsi_wlan_config.h file.

```c
#define AP_BSSID                                    { }
```
  
PSK refers to the secret key if the Access point configured in WPA-PSK/WPA2-PSK security modes.

```c
#define PSK                                     "1234567890"
```

**To configure IP address**

DHCP_MODE refers whether IP address configured through DHCP or STATIC

```c
#define DHCP_MODE                                  1
```

> Note
> If user wants to configure STA IP address through DHCP then set DHCP_MODE to 1 and skip configuring the following DEVICE_IP,GATEWAY and NETMASK macros.
> (Or)
> If user wants to configure STA IP address through STATIC then set DHCP_MODE macro to "0" and configure following DEVICE_IP, GATEWAY and NETMASK macros.

IP address to be configured to the device in STA mode

```c
#define DEVICE_IP6                               "2001:db8:0:1::121"
```
  
IP address of the gateway

```c
#define GATEWAY6                                 "2001:db8:0:1::121"
```

Configure following macro stoping initiate ping with the remote peer. IP address of the remote peer (AP IP address).

```c
#define REMOTE_IP                               "2001:db8:0:1::121"
```
  
PING_SIZE refers the size of ping packet.

```c
#define PING_SIZE                               100
```

NUMBER_OF_PACKETS refers how many number of pings to send from device.

```c
#define NUMBER_OF_PACKETS                       1000
```  

Application memory length which is required by the driver

```c
#define GLOBAL_BUFF_LEN                         15000
```

User can connect to access point through PMK. To Enable keep 1 else 0

```c
#define CONNECT_WITH_PMK                         0
```

**Note:**
 If `CONNECT_WITH_PMK` is enable ,`SECURITY_TYPE` is set to `RSI_WPA2_PMK`

2. Open **rsi\_wlan\_config.h** file and configure the following features as per your requirements.

   **![Configuration file](resources/readme/configuration_file.png)**

   - Opermode parameters

     ```c  
     #define RSI_FEATURE_BIT_MAP              FEAT_SECURITY_OPEN

     #define RSI_TCP_IP_BYPASS                RSI_DISABLE

     #define RSI_TCP_IP_FEATURE_BIT_MAP       (TCP_IP_FEAT_DHCPV4_CLIENT | TCP_IP_FEAT_ICMP | TCP_IP_FEAT_DHCPV6_CLIENT | TCP_IP_FEAT_IPV6)

     #define RSI_CUSTOM_FEATURE_BIT_MAP       FEAT_CUSTOM_FEAT_EXTENTION_VALID

     #define RSI_EXT_CUSTOM_FEATURE_BIT_MAP   EXT_FEAT_UART_SEL_FOR_DEBUG_PRINTS

     #define RSI_EXT_TCPIP_FEATURE_BITMAP     0

     #define RSI_BAND                        RSI_BAND_2P4GHZ
     ```

### 4.4 Execution of the Application

Follow the below steps for the successful execution of the application.

#### 4.4.1 Build the Project - NCP Mode

1. Check for CHIP_9117 and RSI_CONFIGURE_IPV6 macro in preprocessor settings as mentioned below.
   - Right click on project name.
   - Go to **Properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined Symbols (-D)**.
   - If CHIP_9117 and RSI_CONFIGURE_IPV6 macro is not present, add it by clicking on **ADD** symbol.
   - Click on **Apply and Close**.

   ![Build Project for NCP mode](resources/readme/chip_9117_macro.png)

2. Click on the build icon (hammer) or right click on project name and choose **Build Project** to build the project.

   ![Build Project for NCP mode](resources/readme/build_project_ncp.png)

- Make sure the build returns 0 Errors and 0 Warnings.

### 4.4.2 Set up for application prints

**Tera term set up - for NCP mode**

1. Open the Tera Term tool.
 
   - For NCP mode, choose the J-Link port and click on **OK**.

     **![J-link - NCP](resources/readme/port_selection_ncp.png)**

2. Navigate to the Setup → Serial port and update the baud rate to **115200** and click on **OK**.

    **![Serial port](resources/readme/serial_port_setup.png)**

    **![Baud rate](resources/readme/serial_port.png)**

The serial port is now connected.

### 4.4.3 Execute the application

1. Once the build was successful, right click on project and select Debug As → Silicon Labs ARM Program to program the device as shown in below image.

   **![debug_mode_NCP](resources/readme/program_device.png)**

2. As soon as the debug process is completed, the application control branches to the main().

3. Go to the J-link Silicon Labs console pane to observe the debug prints in the Serial 1 tab.

4. Click on the **Resume** icon in the Simplicity Studio IDE toolbar to run the application.

   **![Run](resources/readme/run_example.png)**

5. Configure the Access point in OPEN/WPA-PSK/WPA2-PSK mode to connect Silicon Labs device in STA mode.

6. After the program gets executed, Silicon Labs module configured as client and connects to AP and gets IP.

7. After successful connection with the Access Point, the device starts sending ping requests to the given **REMOTE_IP** with configured **PING_SIZE** to check availability of target Device.
Device sends the number of ping packets configured in **NUMBER_OF_PACKETS**.

8. In rsi_station_ping.c file, **rsi_wlan_ping_async** API returns success status, which means that the ping request packet is successfully sent in to the medium. When actual ping response
comes from the remote node, it is known from the status parameter of the callback function (**rsi_ping_response_handler**) registered in the Ping API.

### 4.4.4 **Application Prints

- **NCP mode:**

   **![Application Prints NCP](resources/readme/application_prints_ncp.png)**

## 5 Selecting Bare Metal configuration

1. By default, the application runs over FreeRTOS. To run the application with Bare metal configurations, follow the below steps.
   - For Simplicity Studio IDE,
      - Right click on project name
      - Go to **Properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined Symbols (-D)**.
      - Select RSI_WITH_OS symbol and click on **Delete** symbol.
      - Click on **Apply and Close**.

   **![Bare metal configuration](resources/readme/bare_metal.png)**