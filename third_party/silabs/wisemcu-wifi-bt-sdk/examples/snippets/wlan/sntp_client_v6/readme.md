# SNTP Client

## 1. Purpose / Scope

This application demonstrates how Silicon Labs device gets info from SNTP server. In this application, Silicon Labs device connects to Access Point in client mode and connects to SNTP server. After successful connection with SNTP server, application gets time and date info from SNTP server.

## 2. Prerequisites / Setup Requirements

Before running the application, set up the following:

### 2.1 Hardware Requirements

- A Windows PC.
- WiFi Access point with internet
- SiWx91x Wi-Fi Evaluation Kit
  - **NCP Mode**:
      - Silicon Labs [(BRD4180A, BRD4280B)](https://www.silabs.com/); **AND**
      - Host MCU Eval Kit. This example has been tested with:
        - Silicon Labs [WSTK + EFR32MG21](https://www.silabs.com/development-tools/wireless/efr32xg21-bluetooth-starter-kit)

#### NCP Mode :  

![Figure: Setup Diagram NCP Mode for SNTP client Example](resources/readme/sntpclientncp.png)

## 3. Application Build Environment

### 3.1 Project Setup

- **NCP Mode**
  - **Silicon Labs EFx32 Host**. Follow the [Getting Started with EFx32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/) to setup the example to work with EFx32 and Simplicity Studio.

### 3.2 NCP Mode - Host Interface 

* By default, the application is configured to use the SPI bus for interfacing between Host platforms(EFR32MG21) and the SiWx91x EVK.

### 3.3 Bare Metal/RTOS Support
To select a bare metal configuration, see [Selecting bare metal](#selecting-bare-metal).

## 4. Application Configuration Parameters

The application can be configured to suit your requirements and development environment. Read through the following sections and make any changes needed.

**4.1** Configure the following parameters in **rsi_sntp_client_app.c** to enable your Silicon Labs Wi-Fi device to connect to your Wi-Fi network.
  
```                                     
#define SSID               "SILABS_AP"      // Wi-Fi Network Name
#define PSK                "1234567890"     // Wi-Fi Password
#define SECURITY_TYPE      RSI_WPA2         // Wi-Fi Security Type: RSI_OPEN / RSI_WPA / RSI_WPA2
#define CHANNEL_NO         0                // Wi-Fi channel if the softAP is used (0 = auto select)
```

To select IPv6, FLAGS should be set to 1, by default it supports IPv4

```
#define FLAGS                               0
```

SERVER_IP_ADDRESS refers remote SNTP Server IP address to connect.
IP address should be in long format and in little endian byte order.

```
#define SERVER_IP                          "2610:20:6f96:96::4"
```

Configure the SNTP method to use the server

```
#define SNTP_METHOD                        RSI_SNTP_UNICAST_MODE
```

SNTP time out value to use

```
#define SNTP_TIMEOUT                       50
```

GLOBAL_BUFF_LEN refers the memory length for driver

```
#define GLOBAL_BUFF_LEN                    15000
```

To configure IPaddress
DHCP_MODErefers whether IP address configured through DHCP or STATIC

```
#define DHCP_MODE                          1
```

IP address to be configured to the device 

```
#define DEVICE_IP6                          "2001:db8:0:1::121"
```

IP address of the gateway 

```
#define GATEWAY6                            "2001:db8:0:1::121"
```

**4.2** Configure the following parameters in **rsi_wlan_config.h** to enable your Silicon Labs Wi-Fi device to connect to your Wi-Fi network.

```
#define CONCURRENT_MODE                             RSI_DISABLE
#define RSI_FEATURE_BIT_MAP                         FEAT_SECURITY_OPEN
#define RSI_TCP_IP_BYPASS                           RSI_DISABLE
#define RSI_TCP_IP_FEATURE_BIT_MAP                  (TCP_IP_FEAT_DHCPV4_CLIENT | TCP_IP_FEAT_SNTP_CLIENT)
#define RSI_CUSTOM_FEATURE_BIT_MAP                  FEAT_CUSTOM_FEAT_EXTENTION_VALID
#define RSI_EXT_CUSTOM_FEAT_BIT_MAP                 EXT_FEAT_256k_MODE 
#define RSI_BAND                                    RSI_BAND_2P4GHZ                  
```

## 5. Testing the Application

Follow the below steps for the successful execution of the application.

### 5.1 Loading the SiWx91x Firmware

Refer [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started) to load the firmware into SiWx91x EVK. The firmware file is located in `<SDK>/firmware/`

### 5.2 Creating the Project and builing the Application
  
Refer [Getting started with EFX32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/), for settin-up EFR & EFM host platforms

#### 5.2.1 Project Creation - NCP Mode : 

- Connect your board. The supported NCP boards are: **BRD4180A,BRD4280B**
- Studio should detect your board. Your board will be shown here.
![ncp_board_detection](resources/readme/ncpboarddetection112.png)

#### 5.2.2 Selecting an example application and generate project

- Go to the 'EXAMPLE PROJECT & DEMOS' tab and select your desired example application
![projct_selection](resources/readme/projctselection113.png)
- Click 'Create'. The "New Project Wizard" window appears. Click 'Finish'
![creation_final](resources/readme/creationfinal114.png)

#### 5.2.3 Build Project - NCP Mode :

- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
![building_pjt](resources/readme/buildingpjt115.png)
- Successful build output will show as below.
![build_success_soc](resources/readme/buildsuccesssoc116.png)

## 6. Program the device

Once the build was successfull, right click on project and click on Debug As->Silicon Labs ARM Program as shown in below image.
### NCP Mode : 
![debug_mode_NCP](resources/readme/debugmodencp120.png)

### 6.1 Running the SiWx91x Application

- Configure the Access point (internet AP) in OPEN / WPA-PSK / WPA2-PSK mode in order to connect Silicon Labs device in STA mode.

- Connect to SNTP server and request server for information.
  Eg: SNTP server ip address 2610:20:6f96:96::4
  
- After the program gets executed, Silicon Labs Device would be connected to Access point and gets IP.

- After successful connection with access Point, Device starts connection with the SNTP server.

- After successful connection, module will send request to the server for time,date and Server Details.

- Application gets  all the information requested.

- Analyze the sniffer capture for NTP server response which contains date and time.

## 7. Observing the output prints on serial terminal

### 7.1 NCP Mode:
Prints can see as below in any Console terminal
![ouput_prints](resources/readme/ouputprints119.png)

## 8. Selecting Bare Metal
The application has been designed to work with FreeRTOS and Bare Metal configurations. By default, the application project files (Simplicity studio) are configured with FreeRTOS enabled. The following steps demonstrate how to configure Simplicity Studio to test the application in a Bare Metal environment.

### 8.1 Bare Metal with Simplicity Studio
> - Open the project in Simplicity Studio
> - Right click on the project and choose 'Properties'
> - Go to 'C/C++ Build' | 'Settings' | 'GNU ARM C Compiler' | 'Symbols' and remove macro 'RSI_WITH_OS=1'
> - Select 'Apply' and 'OK' to save the settings

![Figure: project settings in Simplicity Studio](resources/readme/image216b.png) 

![Figure: project settings in Simplicity Studio](resources/readme/image216c.png)
