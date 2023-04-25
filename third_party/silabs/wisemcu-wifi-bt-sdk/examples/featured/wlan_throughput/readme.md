# WLAN Throughput

## Introduction
This application demonstrates the procedure to measure WLAN UDP/TCP/SSL throughput by configuring the SiWx91x in client/server role.
In this application, the SiWx91x connects to a Wi-Fi access point, obtains an IP address, connects to Iperf server/client or python based SSL scripts, running on a remote PC and measures Tx/Rx throughput transmitted/received from remote PC.

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

#### SoC Mode : 

![Figure: Setup Diagram SoC Mode for WLAN Throughput Example](resources/readme/setup_soc.png)
  
#### NCP Mode :  

![Figure: Setup Diagram NCP Mode for WLAN Throughput Example](resources/readme/setup_ncp.png)

### Project Setup
- **SoC Mode**
  - **Silicon Labs SiWx91x SoC**. Follow the [Getting Started with SiWx91x SoC](https://docs.silabs.com/) to setup the example to work with SiWx91x SoC and Simplicity Studio.
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
#define SERVER_IP_ADDRESS  "192.168.0.100"     // Remote server IP address
```

## Throughput Measurement Types
The application may be configured to measure throughput using UDP, TCP or SSL/TLS packets. Choose the measurement type using the `THROUGHPUT_TYPE` macro.
```c
#define THROUGHPUT_TYPE  TCP_TX     // Selects the throughput option; see the following diagrams. 
#define TCP_TX           0			// SiWx91x transmits packets to remote TCP client
#define TCP_RX           1			// SiWx91x receives packets from remote TCP server
#define UDP_TX           2			// SiWx91x transmits packets to remote UDP client
#define UDP_RX           3			// SiWx91x receives packets from remote UDP server
#define SSL_TX           4			// SiWx91x transmits packets to remote SSL client
#define SSL_RX           5			// SiWx91x receives packets from remote SSL server
```

**SiWx91x is a TCP Client (sends TCP packets to a remote server) ...**

![Figure: SiWx91x Configured in TCP Client Mode](resources/readme/image211.png)  

**SiWx91x is a TCP Server (receives TCP packets from a remote client) ...**

![Figure: SiWx91x Configured in TCP Server Mode](resources/readme/image212.png)

**SiWx91x is a UDP Client (sends UDP packets to a remote server) ...**

![Figure: SiWx91x Configured in UDP Client Mode](resources/readme/image213.png)

**SiWx91x is a UDP Server (receives UDP packets from a remote client) ...**

![Figure: SiWx91x Configured in UDP Server Mode](resources/readme/image214.png)

**SiWx91x is a SSL Client (sends SSL packets to a remote server) ...**

![Figure: SiWx91x Configured in SSL Client Mode](resources/readme/image215.png)

**SiWx91x is a SSL Server (receives SSL packets from a remote client) ...**

![Figure: SiWx91x Configured in SSL Server Mode](resources/readme/image216.png)

## Throughput Options
Various options are available to customize throughput measurements. Some options only apply for specific throughput types as described in the following sections.

### Discrete Interval Measurements (UDP Rx and SSL Tx)
```c
#define MAX_TX_PKTS 10000
```
The default value of `MAX_TX_PKTS` is 10000. To measure throughput for higher intervals, make the following changes:
- UDP Rx : Increase the value of `MAX_TX_PKTS` and provide a higher interval in the corresponding iperf command
- SSL Tx : Increase the value of `MAX_TX_PKTS` and update the equivalent value in `SSL_Server_throughput_d.py` located in the  release directory `resources/scripts/`.

### Discrete Interval Measurements (UDP Tx and TCP Tx)
```c
#define THROUGHPUT_AVG_TIME  30000   // Throughput average time in ms
```
Configure `THROUGHPUT_AVG_TIME` to suit the desired interval.

### Discrete Interval Measurements (TCP Rx and SSL Rx)
- TCP Rx : Configure the interval desired using the corresponding iperf command
- SSL Rx : Increase the packet count in `SSL_tx_throughput.py` located in the release directory `/resources/scripts/`.

### Continous Throughput Measurements
```c
#define CONTINUOUS_THROUGHPUT        0
```

**`CONTINUOUS_THROUGHPUT` = `0`** (default value)
- Throughput is calculated only once for interval of :
  - `THROUGHPUT_AVG_TIME` in case of UDP TX/TCP TX 
  - `MAX_TX_PKTS` in case of UDP RX/SSL TX  
- The time interval is provided by the server in case of TCP RX
- Default packet count is provided in server `SSL_tx_throughput.py` in case of `SSL RX`

**`CONTINUOUS_THROUGHPUT` = `1`**. 
- The application measures throughput continuously for every interval of `THROUGHPUT_AVG_TIME` regardless of `THROUGHPUT_TYPE`, when provided with the following configuration. 
  - UDP Rx/TCP Rx : Configure high interval greater than `THROUGHPUT_AVG_TIME`
  - SSL Rx/SSL Tx : Increase packet count to the maximum in the scripts `SSL_tx_throughput.py` and `SSL_Server_throughput_d.py`

***

**Note!**
If `CONTINUOUS_THROUGHPUT` = `1`, ensure that the SiWx91x client/server runs with an interval greater than `THROUGHPUT_AVG_TIME`.

***


# Testing Throughput
There are two 'ends' involved when measuring throughput, data is sent between the client end and the server end. By default, the Iperf protocol sends data from the Client to the Server to measure throughput. Depending on the configuration selected, the SiWx91x may be the client or the server. In general, it is advisable to start the server before the client since the client will immediately begin to try to connect to the server to send data. 

The following sections describe how to run the SiWx91x throughput application together with examples for various Iperf configurations that run on the PC.   


## Running the SiWx91x Application
After making any custom configuration changes required, build, download and run the application as described in the [EFx32 Getting Started](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/). 


## UDP Tx Throughput
To measure UDP Tx throughput, configure the SiWx91x as a UDP client and start a UDP server on the remote PC.
The Iperf command to start the UDP server on the PC is: 

> `C:\> iperf.exe -s -u -p <SERVER_PORT> -i 1`
> 
> For example ...
>
> `C:\> iperf.exe -s -u -p 5001 -i 1`

![Figure: UDP_TX](resources/readme/image217b.png)

## UDP Rx Throughput
To measure UDP Rx throughput, configure the SiWx91x as a UDP server and start a UDP client on the remote PC.
The Iperf command to start the UDP client is: 
	
> `C:\> iperf.exe -c <Module_IP> -u -p <Module_Port> -i 1 -b <Bandwidth> -t <time interval in seconds>`
>
> For example ...
>
> `C:\> iperf.exe -c 192.168.0.100 -u -p 5001 -i 1 -b 50M -t 30`  

![Figure: UDP_RX](resources/readme/image217a.png)
## TCP Tx Throughput
To measure TCP Tx throughput, configure the SiWx91x as a TCP client and start a TCP server on the remote PC.
The Iperf command to start the TCP server is: 
		
> `C:\> iperf.exe -s -p <SERVER_PORT> -i 1`
>
> For example ...
>
> `C:\> iperf.exe -s -p 5001 -i 1`

![Figure: TCP_TX](resources/readme/image217d.png)
## TCP Rx Throughput
To measure TCP Rx throughput, configure the SiWx91x as TCP server and start a TCP client on the remote PC.
The Iperf command to start the TCP client is: 

> `C:\> iperf.exe -c <Module_IP> -p <module_PORT> -i 1 -t <time interval in sec>`
>
> For example ...
>
> `C:\> iperf.exe -c 192.168.0.100 -p 5001 -i 1 -t 30`  

![Figure: TCP_RX](resources/readme/image217c.png)
## SSL Tx Throughput
To measure SSL Tx throughput, configure the SiWx91x as a SSL client and start a SSL server on the remote PC as described in the following bullets:
- Copy the `SSL_Server_throughput_d.py` script from the release `/resources/scripts/` directory to the `/resources/certificates/` directory
- Open a command prompt and cd to the folder `/resources/certificates/`, then run the following command:
  - `C:\> python SSL_Server_throughput_d.py`

**Note!**
**The SSL_Server_throughput_d.py script works only with Python version 2.**  

![Figure: SSL_TX](resources/readme/image217f.png)
## SSL Rx Throughput
To measure SSL RX throughput, configure the SiWx91x as a SSL client and open a SSL server on the remote PC as described in the following bullets:
- Copy the `SSL_tx_throughput.py` script from the release `/resources/scripts/` directory to the `/resources/certificates/`
- Open a command prompt and cd to the folder `/resources/certificates/`, then run the following command:
  - `C:\> python SSL_tx_throughput.py`

**Note!**
**The SSL_tx_throughput.py script works only with Python version 2.**  

![Figure: SSL_RX](resources/readme/image217e.png)

The SiWx91x, which is configured as a UDP/TCP/SSL server/client, connects to the iperf server/client and sends/receives data for configured intervals. While module is transmitting/receiving the data, application prints the throughput numbers in serial console.


***

**Note!**
In this release, due to a low SPI frequency configured for the EFR32, WLAN throughput is lower than the maximum achievable throughput. This will be addressed in the next release.

***


## Testing the Application 

Follow the below steps for the successful execution of the application.

### Loading the SiWx91x Firmware

Refer [Getting started with a PC](https://docs.silabs.com/rs9116/latest/wiseconnect-getting-started) to load the firmware into SiWx91x EVK. The firmware file is located in `<SDK>/connectivity_firmware/`


## Creating the Project and building the Application
  
Refer [Getting started with EFX32](https://docs.silabs.com/rs9116-wiseconnect/latest/wifibt-wc-getting-started-with-efx32/), for setting up EFR & EFM host platforms

### Project creation - SoC Mode : 
- Connect your board. The Si917 compatible SoC board is **BRD4325A**.
- Studio should detect your board. Your board will be shown here.

  **![Soc Board detection](resources/readme/soc_board_detection.png)**

### Project creation - NCP Mode : 
- Connect your board. The supported NCP boards are: **BRD4180A,BRD4280B**
- The EFR32 board will be detected under **Debug Adapters** pane as shown below.

  **![EFR32 Board detection](resources/readme/efr32.png)**

- The EFM32 board will be detected under **Debug Adapters** pane as shown below.

  **![EFM32 Board detection](resources/readme/efm32.png)**
### Selecting an example application and generate project
SoC
- Go to the 'EXAMPLE PROJECT & DEMOS' tab and select Wi-Fi - SoC Throughput Test application

  ![projct_selection](resources/readme/projctselection113.png)
- Click 'Create'. The "New Project Wizard" window appears. Click 'Finish'

  ![creation_final](resources/readme/creationfinal114.png)

NCP
- Go to the 'EXAMPLE PROJECT & DEMOS' tab and select Wi-Fi - NCP Throughput Test application

  ![projct_selection](resources/readme/projctselectionncp113.png)
- Click 'Create'. The "New Project Wizard" window appears. Click 'Finish'

  ![creation_final](resources/readme/creationfinalncp114.png)

#### Build Project - SoC Mode :

- Once the project is created, right click on project and go to properties → C/C++ Build → Settings → Build Steps
- Add post_build_script_SimplicityStudio.bat file path (SI917_COMBO_SDK.X.X.X.XX\utilities\isp_scripts_common_flash) in build steps settings as shown in below image.
  ![postbuild_script](resources/readme/image359.png)
- Go to properties → C/C++ Build → Settings → Tool Settings → GNU ARM C Compiler → Preprocessor → Defined symbols (-D) and check for M4 projects macro (RSI_M4_INTERFACE=1) and 9117 macro (CHIP_9117=1). If not present, add the macros and click **Apply and Close**.
  
  ![Build Project for SoC mode](resources/readme/soc_macros.png)

- Click on the build icon (hammer) or right click on project name and choose **Build Project** to build the project.

  ![building_pjt](resources/readme/build_project_soc.png)
- Successful build output will show as below. 

  ![build_success_soc](resources/readme/buildsuccesssoc116.png)

#### Build Project - NCP Mode :

- Check for CHIP_9117 macro in preprocessor settings as mentioned below.
   - Right click on project name.
   - Go to properties → C/C++ General → Paths and Symbols → Symbols → GNU C.
   - If CHIP_9117 macro is not present, add it by clicking on **ADD**.
   - Click on **Apply and Close**.

     ![Build Project for NCP mode](resources/readme/ncp_macros.png)
- Click on the build icon (hammer) or right click on project name and choose **Build Project** to build the project.

  ![Build Project for NCP mode](resources/readme/build_project_ncp.png)
- Successful build output will show as below.

  ![build_success_ncp](resources/readme/buildsuccessncp116.png)

## Program the device
Once the build was successful, right click on project and click on Debug As->Silicon Labs ARM Program as shown in below image.
 SoC

![debug_mode_soc](resources/readme/debugmodesoc117.png)

 NCP

![debug_mode_NCP](resources/readme/debugmodencp120.png)

## Observing the output prints on serial terminal

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

Application Prints
 Soc

  ![Application_Prints_SoC](resources/readme/outputprints119.png)

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
