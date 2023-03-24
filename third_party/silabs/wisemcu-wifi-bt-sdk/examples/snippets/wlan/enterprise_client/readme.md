# Enterprise client

## 1 Purpose/Scope

This application demonstrates how to configure SiWx91x in enterprise client mode, connect SiWx91x to an enterprise secured Access point using any of the EAP-TLS, EAP-TTLS, EAP-FAST, and PEAP methods. Subsequently, the application pings to a specified IP address continuously.

## 2 Prerequisites/Set up Requirements

Before running the application, the user will need the following things to setup.

### 2.1 Hardware Requirements

- **SoC Mode**: [Silicon Labs EFR32xG21 Starter Kit with Wireless Gecko](https://www.silabs.com/) (SLSWSTK6006A Base board: BRD4001A, Radio board: BRD4325A)

- **NCP Mode**: 
   - [SiWx91x Wi-Fi Expansion Board](https://www.silabs.com/)
   - A Host MCU. This example application has been tested with the following host MCUs.

     - [Silicon Labs EFR32xG21 Starter Kit with Wireless Gecko](https://www.silabs.com/development-tools/wireless/efr32xg21-bluetooth-starter-kit) (SLSWSTK6006A Base board: BRD4001A, Radio board: BRD4180a or BRD4180b)

     - [Silicon Labs EFM32GG11 Starter Kit with Wireless Gecko](https://www.silabs.com/development-tools/mcu/32-bit/efm32gg11-starter-kit) (SLSTK3701A Base board: BRD2204A)

- A Wireless Access point with WPA2-Enterprise configuration

- A windows PC
   
### 2.2 Software Requirements

- Simplicity Studio IDE 

   - Download the [Simplicity Studio IDE](https://www.silabs.com/developers/simplicity-studio).

   - Follow the [Simplicity Studio user guide](https://docs.silabs.com/simplicity-studio-5-users-guide/1.1.0/ss-5-users-guide-getting-started/install-ss-5-and-software#install-ssv5) to install Simplicity Studio IDE.

- [Silicon Labs Gecko SDK](https://github.com/SiliconLabs/gecko_sdk)

- [Si91x COMBO SDK](https://github.com/SiliconLabs/wiseconnect-wifi-bt-sdk/) 

- [FreeRADIUS Server](https://freeradius.org/) 

**NOTE:**

> This example application supports Bare metal and FreeRTOS configurations.

## 3 Set up

#### 3.1 SoC Mode

The picture below illustrates the EAP frame exchanges between SiWx91x, Access Point and FreeRADIUS Server.

**![Figure: Setup Diagram for Enterprise Client soc Example](resources/readme/eap_exchanges.png)**


Set up diagram for SoC mode:

**![Figure: Setup Diagram for Enterprise Client soc Example](resources/readme/setup_soc.png)**

Follow the [Getting Started with SiWx91x SoC](https://docs.silabs.com/) guide to set up the hardware connections and Simplicity Studio IDE.
  
#### 3.2 NCP Mode 

**![Figure: Setup Diagram for Enterprise Client ncp Example](resources/readme/setup_ncp.png)**

Follow the [Getting Started with EFx32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/) to setup the example to work with EFx32 and Simplicity Studio.

**NOTE**: 
- The Host MCU platform (EFR32MG21) and the SiWx91x interact with each other through the SPI interface.

- The Host MCU platform (EFM32GG11) and the SiWx91x interact with each other through the SDIO interface.


## 4 Application Build Environment

1. Ensure the SiWx91x is loaded with the latest firmware following the [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started). The firmware file is located at **< Si91x COMBO SDK > → connectivity_firmware**.

2. Ensure the EFx32 and SiWx91x set up is connected to your PC.

### 4.1 Board detection

### 4.1.1 SoC mode

1. In the Simplicity Studio IDE, 
    - The SiWx91x SoC board will be detected under **Debug Adapters** pane as shown below.

      **![Soc Board detection](resources/readme/soc_board_detection.png)**

### 4.1.2 NCP mode

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

4. Now choose Wi-Fi- NCP Client with Enterprise Security example for NCP mode or choose Wi-Fi- SoC Client with Enterprise Security example for SoC mode and click on **Create**.

    For NCP mode:

    **![Enterprise Client project](resources/readme/enterprise_client_example.png)**

    For SoC mode:
      
    **![Enterprise Client project](resources/readme/enterprise_client_example_soc.png)**

5. Give the desired name to your project and cick on **Finish**.

   **![Create Enterprise Client project](resources/readme/create_project.png)**


## 4.3 Application Configurations

The application can be configured to suit your requirements and development environment.

1. In the Project explorer pane, expand the **enterprise_client** folder and open the **rsi_enterprise_client.c** file. Configure the following parameters based on your requirements.

    **![Application configuration](resources/readme/application_configuration.png)**

    - SSID refers to the name of the Access point configured in WAP/WPA2-EAP security mode.

    ```c
    #define SSID                                                 "SILABS_AP"
    ```
  
   - SECURITY_TYPE refers to the type of security. In this example, SiWx91x supports WPA-EAP, WPA2-EAP security types.
    
        
    ```c
    #define SECURITY_TYPE                                       RSI_WPA2_EAP
    ```
   
   - In most of the cases, the EAP-TLS method uses root CA certificate and public-private key pairs for authentication. LOAD_CERTIFICATE value defines whether to load the certificates onto module or not.
   
    ```c
    #define LOAD_CERTIFICATE                                       1
    ```      
      
    **NOTE**: 
      1. If LOAD_CERTIFICATE set to 1, application shall load the certificates using **rsi_wlan_set_certificate** API.

      2. By default, the application loads **wifiuser.pem** certificate present at **<SiWx91x COMBO SDK> → resources → certificates**. 
         In order to load your own certificate, follow the below steps:
   
         -  The certificate has to be passed as a parameter to **rsi_wlan_set_certificate** API in linear array format. Convert the **.pem** format certificate into linear array form using python script provided in the SDK **<SiWx91x COMBO SDK → resources → certificates → certificate_to_array.py**.

         -  You can load the certificate in two ways as mentioned below. 
             - Aggregate the certificates in to one file in a fixed order of private key, public key, intermediate CA/dummy certificate, and CA certificate and load the certificate with certificate type **1**. Place the certificate at **<SiWx91x COMBO SDK> → resources → certificates**. Convert the single certificate file into linear array using the following command.

                `python certificate_to_array.py wifi-user.pem`

            - Load the EAP certificates - private key, public key, and CA certificates individually with certificate type as 17,33 and 49 respectively. Maximum certificate length for each individual certificate is 4088 bytes. Place the certificate at **<SiWx91x COMBO SDK> → resources → certificates**. Convert the certificates into linear array using the following commands.

                `python certificate_to_array.py <private key file name>`

                `python certificate_to_array.py <public key file name>`

                `python certificate_to_array.py <CA certificate file name>`

            - The above commands shall generate .h files which contains certificate as a character array. Include these files in **rsi_enterprise_client.c** file.
     
   - USER_IDENTITY refers to user ID which is configured in the user configuration file of the radius server. In this example, user identity is **user1**.
   
    ```c
    #define USER_IDENTITY                                  "\"user1\""
    ```

   - PASSWORD refers to the password which is configured in the user configuration file of the Radius Server for that User Identity. In this example, password is **test123**.
   
    ```c
    #define PASSWORD                                      "\"test123\""
    ```

   
   -  DHCP_MODE refers to whether the IP assignment of SiWx91x is done statically or through DHCP.
      
      1  - DHCP_MODE
      0  - Static IP assignment
   
   ```c
   #define DHCP_MODE                                          1
   ```

   - If you want to assign the IP address Statically, then set DHCP_MODE macro to **0** and configure DEVICE_IP, GATEWAY and NETMASK macros.

  
   ```c
   #define DEVICE_IP                                    "192.168.10.101"
   ```

   ```c
   #define GATEWAY                                      "192.168.10.1"
   ```
  
   ```c
   #define NETMASK                                      "255.255.255.0"
   ```
   - REMOTE_IP refers to the remote peer IP address that is to be pinged.
   
   ```c
   #define REMOTE_IP                                    "192.168.0.100"
   ```
   - PING_SIZE refers to the size of the ping packet
   
   ```c
   #define PING_SIZE                                             100
   ```

   - NUMBER_OF_PING_PKTS refers to number of packets sent to remote peer's IP address.
   
   ```c
   #define NUMBER_OF_PING_PKTS                                   1000
   ```

2. Open **rsi\_wlan\_config.h** file and configure the following features as per your requirements.

   **![Configuration file](resources/readme/configuration_file.png)**

   - Opermode parameters

      ```c
      #define CONCURRENT_MODE                                 RSI_DISABLE

      #define RSI_FEATURE_BIT_MAP                            FEAT_SECURITY_PSK

      #define RSI_TCP_IP_BYPASS                               RSI_DISABLE

      #define RSI_TCP_IP_FEATURE_BIT_MAP        (TCP_IP_FEAT_DHCPV4_CLIENT | TCP_IP_FEAT_ICMP)

      #define RSI_CUSTOM_FEATURE_BIT_MAP                           0
   
      #define RSI_BAND                                       RSI_BAND_2P4GHZ
      ```
   - Enterprise configuration parameters. By default, the EAP method is set to **TLS**. If you use encrypted private key, provide the private key password in **RSI_PRIVATE_KEY_PASSWORD**.
   
      ```c
      #define RSI_EAP_METHOD                                      "TLS"

      #define RSI_EAP_INNER_METHOD                          "\"auth=MSCHAPV2\""

      #define RSI_PRIVATE_KEY_PASSWORD                              "" 
      ```

**Note**:
For TLS version selection, use `rsi_wlan_common_config.h` at `<SDK>\sapis\include` instead of `rsi_wlan_config.h` and enable respective bits as mentioned below.

-  To select TLS 1.0 version, enable `RSI_FEAT_EAP_TLS_V1P0` (BIT(14)) in `RSI_CONFIG_FEATURE_BITMAP`
-  To select TLS 1.2 version, enable `RSI_FEAT_EAP_TLS_V1P2` (BIT(15)) in `RSI_CONFIG_FEATURE_BITMAP`

**Important Notes**: 
-  Ensure the Access Point is configured in WPA2-Enterprise security mode. For more details, please refer to [Configure Access Point in WAP2-EAP](#configure-access-point-in-WAP2-EAP) in Appendix section.
-  Ensure the FreeRADIUS set up is ready before running the application project. For more details, please refer to [FreeRADIUS Server set up](#freeradius-server-set-up) in Appendix section.

### 4.4 Execution of the Application

Follow the below steps for the successful execution of the application.

#### 4.4.1 Build the Project - SoC Mode

1. Once the project is created, right click on project and go to **Properties → C/C++ Build → Settings → Build Steps**.

2. Add **post_build_script_SimplicityStudio.bat** file path present at **SI917_COMBO_SDK.X.X.X.XX → utilities → isp_scripts_common_flash** in build steps settings as shown in below image.

   **![Post build script](resources/readme/post_build_script.png)**

3. Go to **Properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined symbols (-D)** and check for M4 projects macro (RSI_M4_INTERFACE=1) and 9117 macro (CHIP_9117=1). If not present, add the macros by clicking on **ADD** symbol and click **Apply and Close**.
  
   **![Enable macros](resources/readme/soc_macros.png)**

4. Click on the build icon (hammer) or right click on project name and choose **Build Project** to build the project.

   **![Build Project](resources/readme/build_project_soc.png)**

- Make sure the build returns 0 Errors and 0 Warnings.
  

#### 4.4.2 Build the Project - NCP Mode

1. Check for CHIP_9117 macro in preprocessor settings as mentioned below.
   - Right click on project name.
   - Go to **Properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined Symbols (-D)**.
   - If CHIP_9117 macro is not present, add it by clicking on **ADD** symbol.
   - Click on **Apply and Close**.

     **![Build Project for NCP mode](resources/readme/ncp_macros.png)**

2. Click on the build icon (hammer) or right click on project name and choose **Build Project** to build the project.

     **![Build Project for NCP mode](resources/readme/build_project_ncp.png)**

- Make sure the build returns 0 Errors and 0 Warnings.

### 4.4.3 Set up for application prints

Before setting up Tera Term, do the following for SoC mode.

**SoC mode**: 
You can use either of the below USB to UART converters for application prints.
1. Set up using USB to UART converter board.

  - Connect Tx (Pin-6) to P27 on WSTK
  - Connect GND (Pin 8 or 10) to GND on WSTK

    **![FTDI_prints](resources/readme/usb_to_uart_1.png)**

2. Set up using USB to UART converter cable.

  - Connect RX (Pin 5) of TTL convertor to P27 on WSTK
  - Connect GND (Pin1) of TTL convertor to GND on WSTK

    **![FTDI_prints](resources/readme/usb_to_uart_2.png)**

**Tera term set up - for NCP and SoC modes**

1. Open the Tera Term tool. 
   - For SoC mode, choose the serial port to which USB to UART converter is connected and click on **OK**. 

     **![UART - SoC](resources/readme/port_selection_soc.png)**

   - For NCP mode, choose the J-Link port and click on **OK**.

     **![J-link - NCP](resources/readme/port_selection.png)**

2. Navigate to the Setup → Serial port and update the baud rate to **115200** and click on **OK**.

    **![Serial port](resources/readme/serial_port_setup.png)**

    **![Baud rate](resources/readme/serial_port.png)**

### 4.4.4 Execute the application

1. Once the build was successful, right click on project and select **Debug As → Silicon Labs ARM Program** to program the device as shown in below image.

   **![debug_mode_NCP](resources/readme/program_device.png)**

2. As soon as the debug process is completed, the application control branches to the main().

3. Go to the J-link Silicon Labs console pane to observe the debug prints in the Serial 1 tab.

4. Click on the **Resume** icon in the Simplicity Studio IDE toolbar to run the application.

   **![Run](resources/readme/run.png)**

5. As soon as the application gets executed, the SiWx91x connects to the specified Access point configured in WPA-EAP/WPA2-EAP mode.
 
6. After a successful connection with the Access Point, the application starts sending ping requests to the given REMOTE_IP with configured PING_SIZE to check the availability of the target device.
   
7. In this example, the ping requests are continuously sent 1000 times continuously.

### 4.4.5 **Application Prints - SoC mode**:

   **![Application prints](resources/readme/application_prints_soc.png)**

**Application Prints - NCP mode**:

   **![Application prints](resources/readme/application_prints_ncp.png)**
   
## 5 Selecting Bare Metal

1. By default, the application runs over FreeRTOS. To run the application with Bare metal configurations, follow the below steps.
   - For Simplicity Studio IDE,
      - Right click on project name
      - Go to **Properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined Symbols (-D)**.
      - Select RSI_WITH_OS symbol and click on **Delete** symbol.
      - Click on **Apply and Close**.
      
        **![Bare metal configuration](resources/readme/bare_metal.png)**

## Appendix 

### Configure Access Point in WAP2-EAP

   - Navigate to the Wireless Security section and enable the **WPA/WPA2 - Enterprise** option, as shown in the figure below. The image below is for a TP-Link Access Point.
   
      **![Enable the WPA/WPA2 - Enterprise option](resources/readme/wpa2_eap.png)**
    
   - Enter the IP address of the Radius Server in the field labeled, **Radius Server IP**. In the above figure, it is **192.168.50.100**.
   **NOTE**: Give **Radius Server IP** as the IP address of the PC on which you want to run the FreeRADIUS server.
       
   - Enter the Radius Password as **12345678**. This password should be given as a **secret** in FreeRADIUS server.

### FreeRADIUS server set up

The configuration explained below is for Windows OS, similar process may be followed for other OS.

- FreeRADIUS Server installation links:

   [https://freeradius.org/](https://freeradius.org/)
   
   [http://xperiencetech.com/download/radius-free-download.asp](http://xperiencetech.com/download/radius-free-download.asp)
   
   **Note**: This example application has been tested with tested with FreeRADIUS-server-2.2.3-x86.

- Once installed, go to the **C: → FreeRADIUS → etc → raddb** folder. Open the **clients.conf** file and add the following lines at the end of the file. 
      
   ```c     
   client 192.168.50.1/24 {
   secret = 12345678
   shortname = private-network-1
   }
   ```      

- The IP address in the above lines (**192.168.50.1**) is the IP address of the Access Point to which SiWx91x is going to connect. The **secret = 12345678** is the key that is given in the Access Point's radius server configurations to authenticate it with the FreeRADIUS Server.
   
- Open the **eap.conf** file and make the following changes:
   - Change the **default_eap_type** field under the **eap** section to  **tls**, as shown in the figure below.
    
      **![Change the input for the default_eap_type field ](resources/readme/eap_type.png)**
    
   - Change the paths for **private_key_file**, **certificate_file** and **CA_file** under the **tls** section to **${certdir}/wifi-user.pem**, as shown in the figure below.
    
      **![Change the inputs](resources/readme/certs_path.png)**
  
   - Uncomment the **fragment_size** and **include_length** lines under the **tls** section, as shown in the figure below.

      **![Uncomment the fragment_size and include_length lines](resources/readme/eap_fragment_size.png)**
  
   - Open the **users** file present at **C: → FreeRADIUS → etc → raddb** and add the lines shown below. This adds/registers a user with username **user1** and password **test123**.

     **![Open the users file and add the lines](resources/readme/eap_credentials.png)**
   
   - Copy the **wifi-user.pem** file from **<Si91x COMBO SDK> → resources → certificates** folder to **C: → FreeRADIUS → etc → raddb → certs** folder.
   
   - Click on the windows key and just search for Start RADIUS Server and click on it. 
   
   - Then Radius server has started successfully you will see a print at the end which says, **Ready to process requests**.

     **![Run Radius server in Windows PC2](resources/readme/radius_server.png)**
   
**Note:**
 The radius server has to run before the application is executed. You will observe some transactions when the module is trying to connect to the radius server. Restart the Radius server when you execute the application every time.