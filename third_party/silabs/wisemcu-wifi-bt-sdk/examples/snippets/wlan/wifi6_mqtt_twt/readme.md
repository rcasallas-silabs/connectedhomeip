# Embedded MQTT with TWT

## 1 Introduction

This application demonstrates how to configure the SiWx91x EVK as MQTT client and establish connection with MQTT broker and how to subscribe, publish and receive the MQTT messages from MQTT broker.

This application uses MQTT library present in our Firmware.

In this application, SiWx91x EVK configured as WiFi station and connects to the Access Point. After successful WiFi connection, SiWx91x EVK connects to MQTT broker and subscribes to the topic "SILABS_TEST" and publishes a message "THIS IS MQTT CLIENT DEMO FROM SILABS" on that subscribed topic. After publishing the message on the subscribed topic, the MQTT client un-subscribes and disconnects with the MQTT broker.After the disconnection, module enters powersave, module wakes as per the configured TWT interval. 

## 2 Setting Up

Before running the application, the user will need the following things to setup.

### Hardware Requirements
  
* Windows PC
* Wireless Access point
* Windows PC1 with MQTT broker installed in it
* Windows PC2 with MQTT client utility installed in it
* SiWx91x Wi-Fi Evaluation Kit. The SiWx91x supports multiple operating modes. See [Operating Modes]() for details.
  - **SoC Mode**:
      - Silicon Labs [BRD4325A](https://www.silabs.com/)
  - **NCP Mode**:
      - Silicon Labs [(BRD4180A, BRD4280B)](https://www.silabs.com/)
      - Host MCU Eval Kit. This example has been tested with:
        - Silicon Labs [WSTK + EFR32MG21](https://www.silabs.com/development-tools/wireless/efr32xg21-bluetooth-starter-kit)
        - Silicon Labs [WSTK + EFM32GG11](https://www.silabs.com/development-tools/mcu/32-bit/efm32gg11-starter-kit)

### Software Requirements
- Install MQTT Broker
	  - Access the link http://mosquitto.org/download/ to install MQTT broker for different OS platforms in Windows PC1.
- Install MQTT Utility
	  - Access the link http://mqtt-explorer.com/ to install MQTT Explorer in Windows PC2.
	  
#### SoC Mode : 

![Figure: Setup Diagram SoC Mode for MQTT Subscribe-Publish Example](resources/readme/setup_soc.png)
  
#### NCP Mode :  

![Figure: Setup Diagram NCP Mode for MQTT Subscribe-Publish Example](resources/readme/setup_ncp.png)


### 3 Project Setup
- **SoC Mode**
  - **Silicon Labs SiWx91x SoC**. Follow the [Getting Started with SiWx91x SoC](https://docs.silabs.com/) to setup the example to work with SiWx91x SoC and Simplicity Studio.
- **NCP Mode**
  - **Silicon Labs EFx32 Host**. Follow the [Getting Started with EFx32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/) to setup the example to work with EFx32 and Simplicity Studio.

## Configuring the Application
The application can be configured to suit user requirements and development environment.
Read through the following sections and make any changes needed. 

### NCP Mode - Host Interface

* By default, the application is configured to use the SPI bus for interfacing between Host platforms(STM32F411 Nucleo / EFR32MG21) and the SiWx91x EVK.

### Bare Metal/RTOS Support

This application supports bare metal and RTOS configuration. By default, the application project files (Keil and Simplicity studio) are provided with bare metal environment in the SDK. 

## 4 Creating the project

### 4.1 Board detection

### 4.1.1 SoC mode
1. In the Simplicity Studio IDE, 
    - The 917 SoC board will be detected under **Debug Adapters** pane as shown below.

      **![Soc Board detection](resources/readme/soc_board_detection.png)**

### 4.1.2 NCP mode

1. In the Simplicity Studio IDE, 
    - The EFR32 board will be detected under **Debug Adapters** pane as shown below.

      **![EFR32 Board detection](resources/readme/efr32.png)**

    - The EFM32 board will be detected under **Debug Adapters** pane as shown below.

      **![EFM32 Board detection](resources/readme/efm32.png)**

### 4.2 Creation of project

Ensure the latest Gecko SDK along with the extension Si917 COMBO SDK is added to Simplicity Studio.

1. Click on the board detected and go to **EXAMPLE PROJECTS & DEMOS** section.

   **![Examples and Demos](resources/readme/examples_demos.png)**

2. Filter for Wi-Fi examples from the Gecko SDK added. For this, check the *Wi-Fi* checkbox under **Wireless Technology** and *Gecko SDK Suite* checkbox under **Provider**. 

3. Under provider, for SoC based example, check the *SoC* checkbox and for NCP based example, check the *NCP* checkbox.

4. Now choose Wi-Fi- NCP Embedded MQTT TWT example for NCP mode or choose Wi-Fi- SoC Embedded MQTT TWT example for SoC mode and click on **Create**.
  For NCP mode:

   **![MQTT TWT project](resources/readme/mqtt_twt_example_ncp.png)**

    For SoC mode:
      
   **![MQTT TWT  project](resources/readme/mqtt_twt_example.png)**

5. Give the desired name to your project and cick on **Finish**.

   **![Create MQTT TWT project](resources/readme/create_project.png)**



## 5 Application Configuration Parameters

>  Note :
>  If the user wants to use embedded (in firmware) MQTT library, then user can opt for this emb_mqtt application. 

The application can be configured to suit user requirements and development environment. Read through the following sections and make any changes needed.

### Open rsi_emb_mqtt_twt.c file 

#### User must update the below parameters  

SSID refers to the name of the Access point.

```c
#define SSID                                       "SILABS_AP"
```

SECURITY_TYPE refers to the type of security. In this application, STA supports Open, WPA-PSK, WPA2-PSK securities.

   The valid configuration is:

   - RSI_OPEN - For OPEN security mode

   - RSI_WPA  - For WPA security mode

   - RSI_WPA2 - For WPA2 security mode

```c
#define SECURITY_TYPE                              RSI_OPEN
```

PSK refers to the secret key if the Access point configured in WPA-PSK/WPA2-PSK security modes.

```c
#define PSK                                        "<psk>"
```

CLIENT_PORT port refers to device MQTT client port number

```c
#define CLIENT_PORT                                5001
```

SERVER_PORT port refers remote MQTT broker/server port number

```c
#define SERVER_PORT                                1883
```

SERVER_IP_ADDRESS refers remote peer IP address (Windows PC2) to connect with MQTT broker/server socket.

```c
#define SERVER_IP_ADDRESS                          192.168.10.100
```

MQTT client keep alive period

```c
#define RSI_KEEP_ALIVE_PERIOD                      0
```

QOS indicates the level of assurance for delivery of an Application Message.

   QoS levels are:

   0 - At most once delivery

   1 - At least once delivery

   2 - Exactly once delivery

```c
#define QOS                                        0
```

RSI_MQTT_TOPIC refers to which topic WiSeConnect MQTT client is supposed to subscribe.

```c
#define RSI_MQTT_TOPIC                             "SILABS_TEST"
```
   
MQTT Message to publish on the topic subscribed

```c
uint8_t publish_message[] ="THIS IS MQTT CLIENT DEMO FROM SILABS"
```
MQTT Client ID with which MQTT client connects to MQTT broker/server

```c
uint8_t clientID[] = "MQTTCLIENT"
```

User name for login credentials

```c
int8_t username[] = "username"
```

Password for login credentials

```c
int8_t password[] = "password"
```

#### The desired parameters are provided below. User can also modify the parameters as per their needs and requirements.

Application memory length which is required by the driver

```c
#define GLOBAL_BUFF_LEN                            15000
```

To configure IP address
   DHCP_MODE refers whether IP address configured through DHCP or STATIC

```c
#define DHCP_MODE                                  1
```
   
> Note:
> - If user wants to configure STA IP address through DHCP then set DHCP_MODE to "1" and skip configuring the following DEVICE_IP, GATEWAY and NETMASK macros.
> **(Or)**
> - If user wants to configure STA IP address through STATIC then set DHCP_MODE macro to "0" and configure following DEVICE_IP, GATEWAY and NETMASK macros. 
> - AP and STA should be in the same network domain.

Following are the sample STATIC IP configurations.
```c
#define DEVICE_IP                                  "192.168.10.101"
```
```c
#define GATEWAY                                    "192.168.10.1"
```
```c
#define NETMASK                                    "255.255.255.0"
```

### Open rsi_wlan_config.h file. User can also modify the below parameters as per their needs and requirements. 


```c
#define CONCURRENT_MODE                            RSI_DISABLE
#define RSI_FEATURE_BIT_MAP                        FEAT_SECURITY_OPEN
#define RSI_TCP_IP_BYPASS                          RSI_DISABLE
#define RSI_TCP_IP_FEATURE_BIT_MAP                 (TCP_IP_FEAT_DHCPV4_CLIENT | TCP_IP_FEAT_EXTENSION_VALID)
#define RSI_CUSTOM_FEATURE_BIT_MAP                 0
#define RSI_EXT_TCPIP_FEATURE_BITMAP               EXT_EMB_MQTT_ENABLE
#define RSI_BAND                                   RSI_BAND_2P4GHZ
```

 For running **EMB_MQTT** with **SSL**, please enable **TCP_IP_FEAT_SSL** in **rsi_wlan_config.h** file, as shown below. Also load the related **SSL Certificates** in the module using rsi_wlan_set_certificate() API and and Need to enable **SSL** flag **RSI_EMB_MQTT_SSL_ENABLE** in rsi_emb_mqtt_client_init() API. 


```c
#define CONCURRENT_MODE                            RSI_DISABLE
#define RSI_FEATURE_BIT_MAP                        FEAT_SECURITY_OPEN
#define RSI_TCP_IP_BYPASS                          RSI_DISABLE
#define RSI_TCP_IP_FEATURE_BIT_MAP                 (TCP_IP_FEAT_DHCPV4_CLIENT | TCP_IP_FEAT_SSLTCP_IP_FEAT_DNS_CLIENT | TCP_IP_FEAT_EXTENSION_VALID)
#define RSI_CUSTOM_FEATURE_BIT_MAP                 EXT_FEAT_CUSTOM_FEAT_EXTENTION_VALID
#define RSI_EXT_CUSTOM_FEATURE_BIT_MAP             EXT_FEAT_256k_MODE
#define RSI_EXT_TCPIP_FEATURE_BITMAP               EXT_EMB_MQTT_ENABLE
#define RSI_BAND                                   RSI_BAND_2P4GHZ
```

**Power save configuration**

   - By default, the application is configured without power save.

```c
#define ENABLE_POWER_SAVE 0
```
   - If user wants to run the application in power save, modify the below macro.

```c
#define ENABLE_POWER_SAVE 1
```

> Note: 
>  * In rsi_mqtt_client.h change 'MQTT_VERSION' macro to either 3 or 4 based on the MQTT broker support version (Supported versions are 3 and 4).
>  *  Once TWT SP started, beacon sync will happen as described below. This will be applicable till TWT teardown.
>     * Beacon sync will happen every 5 second if TWT interval is less then 5 second. Else it will happen at 600ms before every TWT SP start.
>  * Listen interval/DTIM skip/DTIM based sleep setting will not be applicable once TWT SP started. These setting will be applicable once TWT is teardown.


**Configurations in rsi_wlan_config.h**

Open rsi_wlan_config.h. Following is the default configured listen interval (in milliseconds) for this particular application. It can be configured as follows.

```c
//! RSI_JOIN_FEAT_STA_BG_ONLY_MODE_ENABLE or RSI_JOIN_FEAT_LISTEN_INTERVAL_VALID
#define RSI_JOIN_FEAT_BIT_MAP RSI_JOIN_FEAT_LISTEN_INTERVAL_VALID

//! Listen interval value in milli seconds
#define RSI_LISTEN_INTERVAL 5000
```

## iTWT Configuration

TWT (Target Wake Time) setup is only supported in 11ax (HE) connectivity. Please follow below procedure to enable TWT.

- In NCP mode, right click on the project, go to *properties > C/C++ Build > Settings > Tool Settings > GNU ARM C compiler > Preprocessor > Defined Symbols* and add CHIP_9117 = 1 to the list. It is by default enabled in CCP mode.
- In the project explorer, go to *<project_name> > includes > "C:/silabs/gecko_sdk/extension/wiseconnect/sapi/include" > rsi_wlan_common_config.h* (To enable HE and TWT).


```c
#define HE_PARAMS_SUPPORT  RSI_ENABLE
```
```c
#define TWT_SUPPORT  	   RSI_ENABLE
```
> Note :
> In simplicity IDE, user can ctrl + click on TWT_SUPPORT macro to open the containing file.

### iTWT Configuration API:

```c
int32_t rsi_wlan_twt_config(uint8_t twt_enable, uint8_t twt_flow_id, twt_user_params_t *twt_req_params)
```
Parameters of function are explained below:

- twt_enable  :  1- Setup ; 0 - teardown

- twt_flow_id: range 0-7 or 0xFF

- twt_req_params: Structure with parameters in case of setup and NULL in case of teardown.

### iTWT Setup Configuration

iTWT parameters should be configured and filled into the structure type *twt_user_params_t*  in .c and passed as a parameter to *rsi_wlan_twt_config()* API.

Given below are sample configurations.

```c
        twt_user_params_t twt_req;
        twt_req.wake_duration           = 0x80;
        twt_req.wake_duration_unit      = 0;  
        twt_req.wake_duration_tol       = 0x80;
        twt_req.wake_int_exp            = 13;
        twt_req.wake_int_exp_tol        = 13;
        twt_req.wake_int_mantissa       = 0x1B00;  
        twt_req.wake_int_mantissa_tol   = 0x1B00;
        twt_req.implicit_twt            = 1;
        twt_req.un_announced_twt        = 1;
        twt_req.triggered_twt           = 0;
        twt_req.twt_channel             = 0; 
        twt_req.twt_protection          = 0;
        twt_req.restrict_tx_outside_tsp = 1;
        twt_req.twt_retry_limit         = 6;
        twt_req.twt_retry_interval      = 10;
        twt_req.req_type                = 1;
```
These parameters with their limits are defined as below.

- **wake_duration**: This is the nominal minimum wake duration of TWT. This is the time for which DUT will be in wake state for Transmission or reception of data. Allowed values range is  0-255.
- **wake_duration_unit**: This parameter defines unit for wake_duration. Allowed values are  0 (256uS) and 1 (1024uS).
- **wake_duration_tol**: This is the tolerance allowed for wake duration in case of suggest TWT. Received TWT wake duration from AP will be validated against tolerance limits and decided if TWT config received is in acceptable range. Allowed values are 0-255.
- **wake_int_exp**: TWT Wake interval exponent. It is exponent to base 2. Allowed values are 0 - 31.
- **wake_int_exp_tol**: This is the allowed tolerance for wake_int_exp in case of suggest TWT request. Received TWT wake interval exponent from AP will be validated against tolerance limits and decided if TWT config received is in acceptable range. Allowed values are 0 - 31.
- **wake_int_mantissa**: This is the TWT wake interval mantissa. Allowed values are 0-65535.
- **wake_int_mantissa_tol**: This is tolerance allowed for wake_int_mantissa in case of suggest TWT. Received TWT wake interval mantissa from AP will be validated against tolerance limits and decided if TWT config received is in acceptable range. Allowed values are 0-65535.
- **implicit_twt**: If enabled (1), the TWT requesting STA calculates the Next TWT by adding a fixed value to the current TWT value. Explicit TWT is currently not allowed.
- **un_announced_twt**: If enabled (1), TWT requesting STA does not announce its wake up to AP through PS-POLLs or UAPSD Trigger frames.
- **triggered_twt**: If enabled(1), atleast one trigger frame is included in the TWT Service Period(TSP).
- **twt_channel**: Currently this configuration is not supported. Allowed values are 0-7.
- **twt_protection**:  If enabled (1), TSP is protected. This is negotiable with AP. Currently not supported. Only zero is allowed.
- **restrict_tx_outside_tsp**: If enabled (1), any Tx outside the TSP is restricted. Else, TX can happen outside the TSP also.
- **twt_retry_limit**: This is the maximum number of retries allowed, if the TWT response frame is not recieved for the sent TWT request frame. Allowed values are 0 - 15.
- **twt_retry_interval**: The interval, in seconds, between two twt request retries. Allowed values are 5 - 255.
- **req_type**: This is the TWT request type.
> * 0 - Request TWT
> * 1 - Suggest TWT
> * 2 - Demand TWT

Below is the sample TWT setup API call with twt_enable = 1 and flow_id = 1.
```c
status = rsi_wlan_twt_config(1,1, &twt_req);
```
> Note:
> * TWT Wake duration depends on the wake duration unit. For example, for the above configuration, wake duration value is  (0xE0 * 256 = 57.3 msec).
> * TWT Wake interval is calculated as mantissa *2 ^ exp.  For example, for the above configuration, wake interval value is (0x1B00 * 2^13  = 55.2 sec). 
> * Configuring TWT Wake interval beyond 1 min might lead to disconnections from the AP.
> * There might be disconnections while using TWT with wake interval > 4sec when connected to an AP with non-zero GTK key renewal time.
> * Keep Alive timeout should be non-zero when negotiated TWT setup is **unannounced**, otherwise there might be disconnections.
   
If TWT session setup is successful, the following notification will be printed with TWT Response parameters from the AP.

   ![Figure: TWT Setup Success Response](resources/readme/image218.png)


### iTWT Teardown Configuration

To teardown TWT session, call the API as follows:

```c
status = rsi_wlan_twt_config(0,1, NULL);
```
* 1st parameter: twt_enable: 0 - teardown

* 2nd parameter: twt_flow_id: 
> * Range: 0-7 (should be same as setup ID, other wise error will be triggered)
> * 0xFF - To teardown all active sessions. This value is valid only in case of teardown command.

* 3rd parameter: NULL

### iTWT Command Status Codes
The following are the possible TWT command status codes.

|S.No	|MACRO	|Error code	|Description|	SAPI/WLAN error code|
|:------:|:--------|:--------|:-----------------------------|:--------|
|1.|RSI_ERROR_COMMAND_GIVEN_IN_WRONG_STATE|	0xFFFD|	Occurs when the API is given before opermode is done for this particular API.|SAPI|
|2.|RSI_ERROR_INVALID_PARAM|0xFFFE|Occurs when invalid parameters are passed to this API.|SAPI|
|3.|TWT_SUPPORT_NOT_ENABLED_ERR|0x70|When HE_PARAMS_SUPPORT and TWT_SUPPORT macros are not enabled|FW|
|4.|TWT_SETUP_ERR_SESSION_ACTIVE|0x71|Occurs when user tries to give TWT config command when there is an already active TWT session.|FW|
|5.|TWT_TEARDOWN_ERR_FLOWID_NOT_MATCHED|0x72|Occurs when TWT teardown command is given with a flow ID that does not match existing session flow ID.|FW|
|6.|TWT_TEARDOWN_ERR_NOACTIVE_SESS|0x73|Occurs when teardown command is given while there is no active session.|FW|

### iTWT Session Status Codes

User can get asynchronous TWT session updates if *twt_response_handler* is defined and the callback is registered. A *twt_response_handler* is provided in the example application. The following are the TWT session status codes.

|S.No|	MACRO|	Session status code|	Description|
|:----|:------|:-------------------|:--------------|
|1.|	TWT_SESSION_SUCC|	0|	TWT session setup success. TWT session is active.|
|2.|	TWT_UNSOL_SESSION_SUCC|	1|	Unsolicited TWT setup response from AP accepted. TWT session is active.|
|3.|	TWT_SETUP_AP_REJECTED|	4|	TWT Reject frame recieved in response for the sent TWT setup frame.|
|4.|	TWT_SETUP_RSP_OUTOF_TOL|5|	TWT response parameters from AP for TWT Suggest request is not within tolerance set by User.|
|5.|	TWT_SETUP_RSP_NOT_MATCHED|	6|	TWT response parameters from AP for TWT Demand request does not match parameters given by User.|
|6.|	TWT_SETUP_UNSUPPORTED_RSP|	10|	Unsupported TWT response from AP.|
|7.|	TWT_TEARDOWN_SUCC|	11|	TWT session teardown success|
|8.|	TWT_AP_TEARDOWN_SUCC|	12|	TWT session teardown from AP success|
|9.|	TWT_SETUP_FAIL_MAX_RETRIES_REACHED|	15|	TWT setup request retried maximum number of times as configured by user.|
|10.|	TWT_INACTIVE_DUETO_ROAMING|	16	|TWT session inactive due to roaming|
|11.|	TWT_INACTIVE_DUETO_DISCONNECT|	17|	TWT session inactive due to disconnect|
|12.|	TWT_INACTIVE_NO_AP_SUPPORT|	18|	TWT session inactive as connected AP does not support TWT.|

> Note:
> **twt_session_active** variable is provided in the example application and is updated according to the asychronous TWT session notifications. User can utilise this variable to teardown or configure new session parameters depending upon existing session status. 

Macros to check for and enable (steps to enable the macros included in [building the project](#building-the-project) section): 
For SoC mode - RSI_M4_INTERFACE, CHIP_9117
For NCP mode - CHIP_9117, EXP_BOARD


## 5 Building and Testing the Application

Follow the below steps for the successful execution of the application.

### 5.1 Loading the SiWx91x Firmware

Refer [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started) to load the firmware into SiWx91x EVK. The firmware file is located in `<SDK>/connectivity_firmware/`

### 5.2 Building the Project
#### 5.2.1 Building the Project - SoC Mode

- Once the project is created, right click on project and go to properties → C/C++ Build → Settings → Build Steps.

- Add **post_build_script_SimplicityStudio.bat** file path present at SI917_COMBO_SDK.X.X.X.XX → utilities → isp_scripts_common_flash in build steps settings as shown in below image.

  ![postbuild_script](resources/readme/post_build_script.png)

- Go to properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined symbols (-D) and check for M4 projects macro (RSI_M4_INTERFACE=1) and 9117 macro (CHIP_9117=1). If not present, add the macros and click **Apply and Close**.
  
  ![Build Project for SoC mode](resources/readme/soc_macros.png)

- Click on the build icon (hammer) or right click on project name and choose **Build Project** to build the project.

  ![building_pjt](resources/readme/build_project_soc.png)

- Make sure the build returns 0 Errors and 0 Warnings.
  

#### 5.2.2 Build the Project - NCP Mode

- Check for CHIP_9117 macro in preprocessor settings as mentioned below.
   - Right click on project name.
   - Go to properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined symbols (-D).
   -  If **CHIP_9117 macro** and **EXP_BOARD** are not present, add them by clicking on add macro option.
    
      **NOTE**: In this example, **EXP_BOARD** macro should also be enabled
   - Click on **Apply and Close**.

     ![Build Project for NCP mode](resources/readme/ncp_macros.png)

- Click on the build icon (hammer) or right click on project name and choose **Build Project** to build the project.

  ![Build Project for NCP mode](resources/readme/build_project_ncp.png)

- Make sure the build returns 0 Errors and 0 Warnings.

### 5.3 Set up for application prints

Before setting up Tera Term, do the following for SoC mode.

**SoC mode**: 
You can use either of the below USB to UART converters for application prints.
1. Set up using USB to UART converter board.

  - Connect Tx (Pin-6) to P27 on WSTK
  - Connect GND (Pin 8 or 10) to GND on WSTK

    ![FTDI_prints](resources/readme/usb_to_uart_1.png)

2. Set up using USB to UART converter cable.

  - Connect RX (Pin 5) of TTL convertor to P27 on WSTK
  - Connect GND (Pin1) of TTL convertor to GND on WSTK

    ![FTDI_prints](resources/readme/usb_to_uart_2.png)

**Tera term set up - for NCP and SoC modes**

1. Open the Tera Term tool. 
   - For SoC mode, choose the serial port to which USB to UART converter is connected and click on **OK**. 

     **![](resources/readme/port_selection_soc.png)**

   - For NCP mode, choose the J-Link port and click on **OK**.

     **![](resources/readme/port_selection.png)**

2. Navigate to the Setup → Serial port and update the baud rate to **115200** and click on **OK**.

    **![](resources/readme/serial_port_setup.png)**

    **![](resources/readme/serial_port.png)**

The serial port is now connected. 

### 5.4 Execute the application

1. Once the build was successful, right click on project and select Debug As → Silicon Labs ARM Program to program the device as shown in below image.

   **![debug_mode_NCP](resources/readme/program_device.png)**

2. As soon as the debug process is completed, the application control branches to the main().

3. Click on the **Resume** icon in the Simplicity Studio IDE toolbar to run the application.

   **![Run](resources/readme/run.png)**

### Running the SiWx91x Application

1. Configure the Access point in OPEN/WPA-PSK/WPA2-PSK mode to connect SI917 device in STA mode.

2. Install MQTT broker in Windows PC1 which is connected to Access Point.

3. Run MQTT broker in Windows PC1 using following command. Open Command prompt and go to MQTT installed folder (Ex: C:\Program Files\mosquitto) and run the following command:

   `mosquito.exe -p 1883 -v`
   
   ![Run MQTT broker in Windows PC1](resources/readme/image148.png)

4. Open MQTT.fx client in Windows PC2 and connect to MQTT broker by giving Windows PC1 IP address and MQTT broker port number in Broker Address and Broker Port fields respectively.
   
   ![MQTT.fx client in Windows PC2](resources/readme/image149.png)
   
5. After successful connection, subscribe to the topic from MQTT.fx client.
   
   ![Subscribe to the topic from MQTT client utility](resources/readme/image150.png)

6. After the program gets executed, SI917 EVK will get connected to the same access point having the configuration same as that of in the application and get IP.

7. Once the SI917 EVK gets connected to the MQTT broker, it will subscribe to the topic RSI_MQTT_TOPIC (Ex: "SILABS_TEST"). The user can see the client connected and subscribe information in the MQTT broker.
   
   ![Client Connected and Subscribe Information in the MQTT broker](resources/readme/image151.png)

8. After successful subscription to the topic RSI_MQTT_TOPIC (Ex: "SILABS"), the device publishes a message which is given in publish_message array (Ex: "THIS IS MQTT CLIENT DEMO FROM SILABS") on the subscribed topic.

9. MQTT.fx client which is running on Windows PC3 will receive the message published by the device as it subscribes to the same topic.
   - Refer to the below image for MQTT.fx client and message history.
   
   ![MQTT.fx client and message history](resources/readme/image152.png)

10. Now publish a message using MQTT.fx on the same topic. Now this message is the message received by the device.
   
      ![Publish a message using MQTT.fx](resources/readme/image153.png) 
   
      ![Publish a message using MQTT.fx](resources/readme/image155.png)
  
   **Note:**
   Multiple MQTT client instances can be created
### Procedure For exexcuting the Application when enabled with SSL

1. Configure the Access point in OPEN/WPA-PSK/WPA2-PSK mode to connect Silicon Labs device in STA mode.

2. Install MQTT broker in Windows PC2 which is connected to Access Point through LAN.

3. User needs to update the mosquitto.conf file with the proper file paths, in which the certificates are available in the mosquitto.conf file.

4. Also, add "certs" folder to the mosquitto broker folder.

5. Execute the following command in MQTT server installed folder. (Ex:  C:\Program Files\mosquitto>mosquitto.exe -c mosquitto.conf -v) (Port can be 1883/8883)
   
   `mosquitto.exe -c mosquitto.conf -v`  
   
   ![For opening MQTT server ](resources/readme/image154.png)  

6. If you see any error - Unsupported tls_version "tlsv1", just comment the "tls_version tlsv1" in mosquitto.conf file.

# Selecting Bare Metal
The application has been designed to work with FreeRTOS and Bare Metal configurations. By default, the application project files (Simplicity studio) are configured with FreeRTOS enabled. The following steps demonstrate how to configure Simplicity Studio to test the application in a Bare Metal environment.

## Bare Metal with Simplicity Studio
> - Open the project in Simplicity Studio
> - Right click on the project and choose 'Properties'
> - Go to 'C/C++ Build' | 'Settings' | 'GNU ARM C Compiler' | 'Preprocessor' and remove macro 'RSI_WITH_OS=1'
> - Select 'Apply' and 'OK' to save the settings

![Figure: project settings in Simplicity Studio](resources/readme/image216b.png) 

![Figure: project settings in Simplicity Studio](resources/readme/image216c.png)


