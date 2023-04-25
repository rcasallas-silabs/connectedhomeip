# Throughput Dual IP v4_v6 Application

## Introduction
This application demonstrates the procedure to measure WLAN UDP/TCP throughput in both ipv4 and ipv6 simultaneously by configuring the SiWx91x in client/server role.

## Setting Up 
To use this application, the following hardware, software and project setup is required.

### Hardware Requirements
- A Windows PC
- A computer running Iperf and python version 2 (may be the same PC or Mac used to program the Host MCU)
- Wi-Fi Access Point
- SiWx91x Wi-Fi Evaluation Kit
  - **SoC Mode**: 
      - Silicon Labs [BRD4325A](https://www.silabs.com/)
  - **NCP Mode**:
      - Silicon Labs [(BRD4180A, BRD4280B)](https://www.silabs.com/); **AND**
      - Host MCU Eval Kit. This example has been tested with:
        - Silicon Labs [WSTK + EFR32MG21](https://www.silabs.com/development-tools/wireless/efr32xg21-bluetooth-starter-kit)
  
#### NCP Mode :  

![Figure: Setup Diagram NCP Mode for WLAN Throughput Example](resources/readme/setup_ncp.png)

### Project Setup
- **NCP Mode**
  - **Silicon Labs EFx32 Host**. Follow the [Getting Started with EFx32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/) to setup the example to work with EFx32 and Simplicity Studio.

## Configuring the Application
The application can be configured to suit your requirements and development environment.
Read through the following sections and make any changes needed. 

### NCP Mode - Host Interface

* By default, the application is configured to use the SPI bus for interfacing between Host platforms(EFR32MG21) and the SiWx91x EVK.

### Bare Metal/RTOS Support
To select a bare metal configuration, see [Selecting bare metal](#selecting-bare-metal).

### Wi-Fi Configuration
Configure the following parameters in **rsi_throughput_app.c** to enable your Silicon Labs Wi-Fi device to connect to your Wi-Fi network.

```c
#define SSID           "SILABS_AP"      // Wi-Fi Network Name
#define PSK            "1234567890"     // Wi-Fi Password
#define SECURITY_TYPE  RSI_WPA2         // Wi-Fi Security Type: RSI_OPEN / RSI_WPA / RSI_WPA2
#define CHANNEL_NO     0                // Wi-Fi channel if the softAP is used (0 = auto select)
```

### Client/Server IP Settings
```c
#define PORT_NUM           <local_port>   // Local port to use
#define SERVER_PORT        <remote_port>  // Remote server port
#define SERVER_IP_ADDRESS  "192.168.0.111"    // Remote server IPv4 address .
#define SERVER_IP_ADDRESS_6 "2001:db8:0:1::121" // Remote server IPv6 address .
```

## Throughput Measurement Types
The application is configured to measure throughput using UDP, TCP in ipv4 and ipv6 respectively.
```c
#define THROUGHPUT_TYPE_4 UDP_TX_4
#define THROUGHPUT_TYPE_6 TCP_TX_6
```

# Testing Throughput
There are two 'ends' involved when measuring throughput, data is sent between the client end and the server end. By default, the Iperf protocol sends data from the Client to the Server to measure throughput. Depending on the configuration selected, the SiWx91x may be the client or the server. In general, it is advisable to start the server before the client since the client will immediately begin to try to connect to the server to send data. 

The following sections describe how to run the SiWx91x throughput application together with examples for various Iperf configurations that run on the PC.   


## Running the SiWx91x Application
After making any custom configuration changes required, build, download and run the application as described in the [EFx32 Getting Started](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/). 


## UDP Tx v4 Throughput
To measure UDP Tx throughput, configure the SiWx91x as a UDP client and start a UDP server on the remote PC.
The Iperf command to start the UDP server on the PC is: 

> `C:\> iperf.exe -s -u -p <SERVER_PORT> -i 1`
> 
> For example ...
>
> `C:\> iperf.exe -s -u -p 5001 -i 1`

![Figure: UDP_TX](resources/readme/image217b.png)

## TCP Tx v6 Throuhgput
To measure TCP Tx throughput, configure the RS9116W as a TCP client and start a TCP server on the remote PC.
The Iperf command to start the TCP server is: 
		
> `C:\> iperf.exe -s -V -p <SERVER_PORT> -i 1`
>
> For example ...
>
> `C:\> iperf.exe -s -V -p 5001 -i 1`


## Testing the Application 

Follow the below steps for the successful execution of the application.

### Loading the SiWx91x Firmware

Refer [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started) to load the firmware into SiWx91x EVK. The firmware file is located in `<SDK>/connectivity_firmware/`


## Creating the Project and building the Application
  
Refer [Getting started with EFX32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/), for setting up EFR & EFM host platforms

### Project creation - NCP Mode : 
- Connect your board. The supported NCP boards are: **BRD4180A,BRD4280B**
- The EFR32 board will be detected under **Debug Adapters** pane as shown below.

  **![EFR32 Board detection](resources/readme/efr32.png)**

- The EFM32 board will be detected under **Debug Adapters** pane as shown below.

  **![EFM32 Board detection](resources/readme/efm32.png)**
### Selecting an example application and generate project
NCP
- Go to the 'EXAMPLE PROJECT & DEMOS' tab and select Wi-Fi - Throughput_dual_ip_v4_v6

  ![projct_selection](resources/readme/projctselectionncp113.png)
- Click 'Create'. The "New Project Wizard" window appears. Click 'Finish'

  ![creation_final](resources/readme/creationfinalncp114.png)

#### Build Project - NCP Mode :

- Check for CHIP_9117 and RSI_CONFIGURE_IPV6 macro in preprocessor settings as mentioned below.
   - Right click on project name.
   - Go to properties → C/C++ General → Paths and Symbols → Symbols → GNU C.
   - If CHIP_9117 and RSI_CONFIGURE_IPV6 macro is not present, add it by clicking on **ADD**.
   - Click on **Apply and Close**.

     ![Build Project for NCP mode](resources/readme/ncp_macros.png)
- Click on the build icon (hammer) or right click on project name and choose **Build Project** to build the project.

  ![Build Project for NCP mode](resources/readme/build_project_ncp.png)
- Successful build output will show as below.

  ![build_success_ncp](resources/readme/buildsuccessncp116.png)

## Program the device
Once the build was successful, right click on project and click on Debug As->Silicon Labs ARM Program as shown in below image

 NCP

![debug_mode_NCP](resources/readme/debugmodencp120.png)

## Observing the output prints on serial terminal

**Tera term set up - for NCP mode**

1. Open the Tera Term tool. 

   - For NCP mode, choose the J-Link port and click on **OK**.

     **![](resources/readme/port_selection.png)**

2. Navigate to the Setup → Serial port and update the baud rate to **115200** and click on **OK**.

    **![](resources/readme/serial_port_setup.png)**

    **![](resources/readme/serial_port.png)**

The serial port is now connected.

Application Prints
 NCP

  ![Application_Prints_NCP](resources/readme/outputprintsncp119.png)

# Selecting Bare Metal
The application has been designed to work with FreeRTOS and Bare Metal configurations. By default, the application project files (Simplicity studio) are configured with FreeRTOS enabled. The following steps demonstrate how to configure Simplicity Studio to test the application in a Bare Metal environment.

## Bare Metal with Simplicity Studio
> - Open the project in Simplicity Studio
> - Right click on the project and choose 'Properties'
> - Go to 'C/C++ Build' | 'Settings' | 'GNU ARM C Compiler' | 'Preprocessor' and remove macro 'RSI_WITH_OS=1'
> - Select 'Apply' and 'OK' to save the settings

![Figure: project settings in Simplicity Studio](resources/readme/image216b.png) 

![Figure: project settings in Simplicity Studio](resources/readme/image216c.png)
