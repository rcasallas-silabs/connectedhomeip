# Enterprise client

## 1. Purpose / Scope

This application demonstrates how to configure SiWx91x EVK in Enterprise client and connects with Enterprise secured Access point and data traffic in Enterprise security mode.

In this application, SiWx91x EVK connects to Enterprise secured AP using EAP-TLS/TTLS/PEAP/FAST method. After successful connection, application opens TCP client socket and connects with TCP server opened on remote peer and sends TCP data on opened socket.

## 2. Prerequisites / Setup Requirements

Before running the application, the user will need the following things to setup.

### 2.1 Hardware Requirements

* Windows PC
* Wireless Access point
* Windows PC with AAA Radius Server or Free Radius server
* Wifi router connected to Windows PC.
* SiWx91x Wi-Fi Evaluation Kit. The SiWx91x supports multiple operating modes. See [Operating Modes]() for details.
  - **SoC Mode**:
      - Silicon Labs [BRD4325A](https://www.silabs.com/)
  - **NCP Mode**:
      - Silicon Labs [(BRD4180A, BRD4280B)](https://www.silabs.com/); **AND**
      - Host MCU Eval Kit. This example has been tested with:
        - Silicon Labs [WSTK + EFR32MG21](https://www.silabs.com/development-tools/wireless/efr32xg21-bluetooth-starter-kit)
        - Silicon Labs [WSTK + EFM32GG11](https://www.silabs.com/development-tools/mcu/32-bit/efm32gg11-starter-kit)
   
#### SoC Mode : 

![Figure: Setup Diagram for Enterprise Client soc Example](resources/readme/enterprisesoc.png)
  
#### NCP Mode :  

![Figure: Setup Diagram for Enterprise Client ncp Example](resources/readme/enterprisencp.png)
   
### 2.2 Software Requirements

- [WiSeConnect SDK](https://github.com/SiliconLabs/wiseconnect-wifi-bt-sdk/) 
- Embedded Development Environment

   - For Silicon Labs EFx32, use the latest version of [Simplicity Studio](https://www.silabs.com/developers/simplicity-studio)

- [Iperf Application](https://iperf.fr/iperf-download.php)
- [Free Radius Server](https://freeradius.org/) in Windows PC1(Remote PC)

## 3. Application Build Environment
### 3.1 Project Setup
- **SoC Mode**
  - **Silicon Labs SiWx91x SoC**. Follow the [Getting Started with SiWx91x SoC](https://docs.silabs.com/) to setup the example to work with SiWx91x SoC and Simplicity Studio.
- **NCP Mode**
  - **Silicon Labs EFx32 Host**. Follow the [Getting Started with EFx32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/) to setup the example to work with EFx32 and Simplicity Studio.

### 3.2 NCP Mode - Host Interface 

* By default, the application is configured to use the SPI bus for interfacing between Host platforms(EFR32MG21) and the SiWx91x EVK.
* This application is also configured to use the SDIO bus for interfacing between Host platforms(EFM32GG11) and the SiWx91x EVK.


### 3.3 Bare Metal/RTOS Support

This application supports bare metal and RTOS environment. By default, the application project files (Keil and Simplicity studio) are provided with bare metal configuration in the SDK. 

## 4. Application Configuration Parameters

The application can be configured to suit user requirements and development environment. Read through the following sections and make any changes needed.

### 4.1 Open rsi_eap_connectivity.c file

#### 4.1.1 User must update the below parameters

SSID refers to the name of the Access point.

```c
#define SSID                                                  "SILABS_AP"
```
  
SECURITY_TYPE refers to the type of security. In In this application STA supports WPA-EAP, WPA2-EAP securities.
    
   Valid configuration is:
    
   - RSI_WPA_EAP - For WPA-EAP security mode
    
   - RSI_WPA2_EAP - For WPA2-EAP security mode
    
```c
#define SECURITY_TYPE                                         RSI_WPA2_EAP
```
   
LOAD_CERTIFICATE refers whether certificate to load into module or not.
   
```c
#define LOAD_CERTIFICATE                                      1
```      
      
If LOAD_CERTIFICATE set to 1, application will load certificate which is included using rsi_wlan_set_certificate API.
   
By default, application is loading "wifiuser.pem" certificate when LOAD_CERTIFICATE enabled. In order to load different certificate, user has to do the following steps:
   
rsi_wlan_set_certificate API expects the certificate in the form of linear array. So convert the pem certificate into linear array form using python script provided in the SDK "resources/certificates/certificate_to_array.py"

  Example: If the certificate is wifi-user.pem, give the command like the following way: 

  `python certificate_to_array.py wifi-user.pem`
   
  The script will generate `wifiuser.pem` in which one linear array named wifiuser contains the certificate.
     
After conversion of certificate, update rsi_eap_connectivity.c source file by including the certificate file and by providing the required parameters to rsi_wlan_set_certificate API.
   
Once the certificate loads into the device, it will write into the device flash. So, user need not load certificate for every boot up unless certificate change.

   So define LOAD_CERTIFICATE as 0, if certificate is already present in the device.
   
USER_IDENTITY refers to user ID which is configured in the user configuration file of the radius server. In this example, user identity is "user1".
   
```c
#define USER_IDENTITY                                         "\"user1\""
```

PASSWORD refers to the password which is configured in the user configuration file of the Radius Server for that User Identity.
   
   In this example, password is "test123"
   
```c
#define PASSWORD                                              "\"test123\""
```
DEVICE_PORT port refers TCP client port number
   
```c
#define DEVICE_PORT                                           5001
```

SERVER_PORT port refers remote TCP server port number which is opened in Windows PC2.
   
```c
#define SERVER_PORT                                           5001
```

SERVER_IP_ADDRESS refers remote peer IP address to connect with TCP server socket.
   
   IP address should be in long format and in little endian byte order.
   
   Example: To configure "192.168.0.100" as remote IP address, update the macro SERVER_IP_ADDRESS as 0x6400A8C0.
   
```c
#define SERVER_IP_ADDRESS                                     0x640AA8C0
```

#### 4.1.2 The desired parameters are provided below. User can also modify the parameters as per their needs and requirements.

GLOBAL_BUFF_LEN memory length which is required by the driver

```c
#define GLOBAL_BUFF_LEN                            15000
```

NUMEBR_OF_PACKETS refers how many packets to receive from TCP client
   
```c
#define NUMBER_OF_PACKETS                                     1000
```
   
DHCP_MODE refers whether IP address configured through DHCP or STATIC in STA mode
   
```c
#define DHCP_MODE                                             1
```

> Note:
> If the user wants to configure STA IP address through DHCP then skip configuring the DEVICE_IP, GATEWAY and NETMASK macros.
> (Or)
> If the user wants to configure STA IP address through STATIC then set DHCP_MODE macro to "0" and configure DEVICE_IP, GATEWAY and NETMASK macros.

IP address to be configured to the device in STA mode should be in long format and in little endian byte order.
  
   Example: To configure "192.168.0.10" as IP address, update the macro DEVICE_IP as 0x010AA8C0.
  
```c
#define DEVICE_IP                                             0X0A00A8C0
```
IP address of the gateway should also be in long format and in little endian byte order.
   Example: To configure "192.168.0.1" as Gateway, update the macro GATEWAY as 0x0100A8C0
  
```c
#define GATEWAY                                               0x0100A8C0
```

IP address of the network mask should also be in long format and in little endian byte order.

   Example: To configure "255.255.255.0" as network mask, update the macro NETMASK as **0x00FFFFFF**
  
```c
#define NETMASK                                               0x00FFFFFF
```

Configure the following macro to initiate ping with the remote peer IP address (AP IP address).

   Example: To configure "192.168.10.1" as remote IP, update the macro REMOTE_IP as 0x6B01A8C0
   
```c
#define REMOTE_IP                                             0x010AA8C0
```

PING_SIZE refers to the size of the ping packet
   
```c
#define PING_SIZE                                             100
```

### 4.2 Open rsi_wlan_config.h file 


```c
#define CONCURRENT_MODE                                       RSI_DISABLE
#define RSI_FEATURE_BIT_MAP                                   FEAT_SECURITY_PSK
#define RSI_TCP_IP_BYPASS                                     RSI_DISABLE
#define RSI_TCP_IP_FEATURE_BIT_MAP                            (TCP_IP_FEAT_DHCPV4_CLIENT | TCP_IP_FEAT_ICMP)
#define RSI_CUSTOM_FEATURE_BIT_MAP                            0
#define RSI_BAND                                              RSI_BAND_2P4GHZ
```
    
> Note:
> For TLS version selection, use `rsi_wlan_common_config.h` at `<SDK>\sapis\include` instead of `rsi_wlan_config.h` and enable respective bits as shown below.
> To select TLS 1.0 version, enable `RSI_FEAT_EAP_TLS_V1P0` (BIT(14)) in `RSI_CONFIG_FEATURE_BITMAP`
> To select TLS 1.2 version, enable `RSI_FEAT_EAP_TLS_V1P2` (BIT(15)) in `RSI_CONFIG_FEATURE_BITMAP`

## 5. Testing the Application

User has to follow the below steps for the successful execution of the application.

### 5.1 Loading the SiWx91x Firmware

Refer [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started) to load the firmware into SiWx91x EVK. The firmware file is located in `<SDK>/firmware/`

### 5.1.1 Access Point Setup

When working with the EAP-Ping example, LAN cable is connected between the Access point modem and CPU.

   - After the connection, using the command prompt give "ipconfig" command to know the IP and gateway1. address of the Radius server. The below image is for reference purpose.
   
![Give "ipconfig" command in command prompt](resources/readme/image136.png)

   - Connect the Access Point to PC over Ethernet and open the Access Point page in browser by typing the IP address of the AP's Default Gateway address and configure it.
   
   - Navigate to the Wireless Security section and enable the "WPA/WPA2 - Enterprise" option, as shown in the figure below. The image below is for a TP-Link Access Point.
   
![Enable the "WPA/WPA2 - Enterprise" option](resources/readme/image137.png)
    
   - Enter the IP address of the Radius Server in the field labeled, "Radius Server IP". In the above figure, it is 192.168.50.100.
   
   - Enter the Radius Password as "12345678". This is the same as that entered in the 'clients.conf' file of the Radius Server.
   
### 5.1.2 Radius Server Setup

**Description :**

The figure below shows the setup for Wi-Fi Client in Enterprise Security Mode.

![Setup for Wi-Fi Client in Enterprise Security Mode](resources/readme/image138.png)

**Radius server Set-up guide :**

The WiSeConnect module supports four Enterprise Security modes:
   1. EAP-TLS
   2. EAP-TTLS
   3. EAP-PEAP
   4. EAP-FAST

**Radius Server Configuration**

The configuration explained below is for Windows OS, similar process may be followed for other OS.

- Free Radius Server installation link:

   [https://freeradius.org/](https://freeradius.org/)
   
   [http://xperiencetech.com/download/radius-free-download.asp](http://xperiencetech.com/download/radius-free-download.asp)
   
   **Note**
   Application was tested in FreeRADIUS-server-2.2.3-x86.

- Once installed, go to the C:\FreeRADIUS\etc\raddb folder and make the following modifications.

- Open the 'clients.conf' file and add the following lines at the end of the file. 
      
```sh      
   client 192.168.50.1/24 {
   secret = 12345678
   shortname = private-network-1
   }
```      

- The IP address in the above lines (192.168.50.1) is the IP address of the Access Point in this example setup. The "12345678" input is the key to be entered in the Access Point's radius server configuration page to authenticate it with the Radius Server.
   
- Open the 'eap.conf' file and make the following changes:
   - Change the input for the "default_eap_type" field under the "eap" section to  "tls", as shown in the figure below.
    
![Change the input for the "default_eap_type" field ](resources/readme/image139.png)
    
   - Change the inputs for "private_key_file", "certificate_file" and "CA_file" fields under the "tls" section to "${certdir}/wifi-user.pem", as shown in the figure below.
    
![Change the inputs](resources/readme/image140.png)
  
   - Uncomment the "fragment_size" and "include_length" lines under the "tls" section, as shown in the figure below.

![Uncomment the "fragment_size" and "include_length" lines](resources/readme/image141.png)
  
- Open the users file and add the lines shown in the figure below starting with "user1". This adds a user with username "user1" and password "test123".

![Open the users file and add the lines](resources/readme/image142.png)
   
- Copy the 'wifi-user.pem; file from `<SDK>\resources\certificates` folder to **C:\FreeRADIUS\etc\raddb\certs** folder.
   
- Click on the windows key and just search for Start RADIUS Server and click on it. 
   
- Then Radius server has started successfully you will see a print at the end which says, "Ready to process requests".
   
> Note:
> 
> The radius server has to run before the application is executed. You will observe some transactions when the module is trying to connect to the radius server. Restart the Radius server when you execute the application every time.

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
![projct_selection](resources/readme/projctselection113.png)
- Click 'Create'. The "New Project Wizard" window appears. Click 'Finish'
![creation_final](resources/readme/creationfinal114.png)

#### 5.2.4 Build Project - SoC Mode

- Once the project is created, right click on project and go to properties → C/C++ Build → Settings → Build Steps
- Add post_build_script_SimplicityStudio.bat file path (SI917_COMBO_SDK.X.X.X.XX\utilities\isp_scripts_common_flash) in build steps settings as shown in below image.
![postbuild_script](resources/readme/image359.png)
- Check for M4 projects macros in preprocessor settings(RSI_M4_INTERFACE=1)
- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
![building_pjt](resources/readme/buildingpjt115.png)
- Successful build output will show as below.
![build_success_soc](resources/readme/buildsuccesssoc116.png)

#### 5.2.5 Build Project - NCP Mode :

- Check for 9117 macro in preprocessor settings(CHIP_9117=1).
- Click on the build icon (hammer) to build the project
![building_pjt](resources/readme/buildingpjt115.png)
- Successful build output will show as below.
![build_success_soc](resources/readme/buildsuccesssoc116.png)

## 6. Program the device

Once the build was successfull, right click on project and click on Debug As->Silicon Labs ARM Program as shown in below image.
### SoC Mode :
![debug_mode_soc](resources/readme/debugmodesoc117.png)
### NCP Mode : 
![debug_mode_NCP](resources/readme/debugmodencp120.png)

### 6.1 Running the SiWx91x Application
1. Connect the SiWx91x EVK (Silicon Labs module) to the Windows PC running IDE.
   
2. Configure the Access point in WPA-EAP/WPA2-EAP mode to connect the SiWx91x EVK (Silicon Labs module) in ent erprise secured mode.
   
3. Run Radius server in Windows PC2 which is connected to AP by providing required certificate and credentials.
   
![Run Radius server in Windows PC2](resources/readme/image144.png)
   
4. After the program gets executed, SiWx91x EVK (Silicon Labs module) will get connected to access point which is in enterprise security having the configuration provide in **Section 4** and gets IP.
   
5. After a successful connection with the Access Point, the starts sending ping requests to the given REMOTE_IP with configured PING_SIZE to check the availability of the target device.
   
6. The SiWx91x EVK sends the number of ping packets configured in NUMBER_OF_PACKETS.
   
7. In the rsi_eap_connectivity.c file, rsi_wlan_ping_async API returns success status, which means that the ping request packet is successfully sent into the medium. When the actual ping response comes from the remote node, it is known from the status parameter of the callback function (rsi_ping_response_handler) registered in the Ping API.
   
8. The following figures shows the Packet_count is continuously incremented, which means the ping request packet is successfully sent into the medium. Place a breakpoint at rsi_delay_ms(1000) and add the packet_count variable to watch the window and monitor the packet count.
   
![The Packet_count is continuously incremented-1](resources/readme/image145.png)
   
![The Packet_count is continuously incremented-2](resources/readme/image146.png)

## 7. Observing the output prints on serial terminal

### 7.1 SoC Mode:
> Connect USB to UART connector Tx and GND pins to WSTK radio board.

   - Connect Tx(Pin-6) to P27 on WSTK
   - Connect GND(Pin 8 or 10) to GND on WSTK
![FTDI_prints](resources/readme/ftdiprints118.png)
> Prints can see as below in any Console terminal
![ouput_prints](resources/readme/ouputprints119.png)

### 7.2 NCP Mode:
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