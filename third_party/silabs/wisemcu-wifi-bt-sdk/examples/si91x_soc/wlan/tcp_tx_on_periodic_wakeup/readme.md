# **TCP Tx on Periodic Wakeup**

## **1 Introduction**

This application demonstrates the process for configuring SiWx91x in connected sleep mode while having a TCP client socket in open state.

The application creates TCP client socket and then connects to a remote server to send 64MB data to TCP Server. After completing data transfer, NWP/TA enters connected sleep and M4 goes to sleep with configurable alarm time. After the alarm times out, M4 wakes up NWP/TA by sending a packet and the data transmission repeats.

## **2 Prerequisites**
For running the application, you will need the following:
### **2.1 Hardware Requirements**
- A Windows PC
- A Wi-Fi Access Point
- Silicon Labs SiWx917 PK6030A SoC Kit which includes
  - BRD4001A/BRD4002A Wireless Starter Kit Mainboard
  - BRD4325A Radio Board
- USB TO UART converter or TTL cable
### **2.2 Software Requirements**
- Simplicity Studio IDE
   - To download and install the Simplicity Studio IDE, refer to the [Simplicity Studio IDE Set up]() section in ***Getting started with SiWx91x SoC*** guide.
- SiWx917_WiSeConnect_SDK.x.x.x.x
- [TCP/UDP peer application - Hercules](https://www.hw-group.com/software/hercules-setup-utility)
- Tera Term software or any other serial terminal software - for viewing application prints
- Energy Profiler tool (Integrated in Simplicity Studio IDE)

## **3 Set up diagram**

![Figure: Setup Diagram for Wi-Fi - SoC TCP Tx on Periodic Wakeup](resources/readme/image184socwithenergyprofiler.png)

## **4 Set up** 
- Follow the [Hardware connections and Simplicity Studio IDE Set up]()  section in the ***Getting Started with SiWx91x SoC*** guide to make the hardware connections and add the Gecko and SiWx91x COMBO SDK to Simplicity Studio IDE.
- Ensure that SiWx91x module is loaded with the latest firmware following the [SiWx91x Firmware Update]() section in the ***Getting started with SiWx91x SoC*** guide.

## **5 Creation of Project**

To create the project in the Simplicity Studio IDE, follow the [Creation of Project]() section in the ***Getting started with SiWx91x SoC*** guide, choose the **Wi-Fi - SoC TCP Tx on Periodic Wakeup** example.
   

## **6 Application configuration**
Read through the following sections and make any changes needed. 
  
In the Project explorer pane of the IDE, expand the **tcp_tx_on_periodic_wakeup_soc** folder and open the **rsi_tcp_tx_on_periodic.c** file. Configure the following parameters based on your requirements.

   ![Application configuration](resources/readme/tcptxonperiodicwakeupapplicationconfiguration.png)

- ### **Wi-Fi Configuration**

    ```c
    //! Wi-Fi Network Name
    #define SSID                                "SILABS_AP"      

    //! Wi-Fi Password
    #define PSK                                 "1234567890"     

    //! Wi-Fi Security Type: RSI_OPEN / RSI_WPA / RSI_WPA2
    #define SECURITY_TYPE                        RSI_WPA2         
    ```

- ### **Hercules Setup Configuration**

    ```c
      //! The remote TCP server port number on the PC running Hercules Setup
      #define SERVER_PORT                       5001               
      
      //! THe remote TCP server IP address on the PC running Hercules Setup
      #define SERVER_IP_ADDRESS                 "192.168.10.100"   
      
      //! Number of packets to be transmitted can also be configured
      #define NUMBER_OF_PACKETS                  45964
    ```

- ### **M4 Alarm time configuration**
  ```c
  #define ALARM_PERIODIC_TIME                   300
  ```

- ### **Major Powersave Options**
The primary powersave settings are configured with `PSP_MODE` and `PSP_TYPE`. The default power save mode is set to low power mode 2 (`RSI_SLEEP_MODE_2`) with maximum power save (`RSI_MAX_PSP`) and with M4 based handshake as follows.

```c
  #define PSP_MODE                              RSI_SLEEP_MODE_2
  #define PSP_TYPE                              RSI_MAX_PSP
```

`PSP_MODE` refers to the power save profile mode. SiWx91x module supports the following power modes:

  - `RSI_ACTIVE` : In this mode, SiWx91x module is active and power save is disabled.
  - `RSI_SLEEP_MODE_1` : In this mode, SiWx91x module goes to power save after association with the Access Point. In this sleep mode, SoC will never turn off, therefore no handshake is required before sending data to the SiWx91x module.
  - `RSI_SLEEP_MODE_2` : In this mode, SiWx91x module goes to power save after association with the Access Point. In this sleep mode, SoC will go to sleep based on GPIO hand shake or Message exchange or M4 based handshake, therefore handshake is required before sending data to the SiWx91x module.
 
---- 

**Note!**
  1. For `RSI_SLEEP_MODE_2`  modes, GPIO or Message or M4 based handshake can be selected using `RSI_HAND_SHAKE_TYPE` macro which is defined in `rsi_wlan_config.h`.
  2. In this example, `RSI_SLEEP_MODE_2` can be verified with a M4-based handshake. 

----

`PSP_TYPE` refers to power save profile type. SiWx91x module supports following power save profile types:
  - `RSI_MAX_PSP` : In this mode, SiWx91x module will be in Maximum power save mode. i.e device will wake up for every DTIM beacon and do data Tx and Rx.
  - `RSI_FAST_PSP` : In this mode, SiWx91x module will disable power save for any Tx/Rx packet for monitor interval of time (monitor interval can be set through macro in `rsi_wlan_config.h` file, default value is 50 ms). If there is no data for monitor interval of time, then SiWx91x module will again enable power save.
----

**Note!**
- `PSP_TYPE` is valid only when `PSP_MODE` is set to `RSI_ACTIVE` or `RSI_SLEEP_MODE_2` or `RSI_SLEEP_MODE_8` mode.
----

## **7 Setup for Serial Prints**

To Setup the serial prints, follow the [Setup for Serial Prints]() section in the ***Getting started with SiWx91x SoC*** guide.
 
## **8 Build, Flash, and Run the Application**

To build, flash, and run the application project refer to the [Build and Flash the Project]() section in the ***Getting Started with SiWx91x SoC*** guide.

## **9 Execution Flow**
- Before running the application on SiWx91x, set up the TCP server on remote PC. 
  - Open the TCP Server tab in Hercules application
  - Enter the server port number as configured in SERVER_PORT in the application and click on listen on Hercules application.
    
    ![Figure: Hercules Setup Utilities on the remote PC](resources/readme/image185.png)

- As the application runs on SiWx91x, it connects to the TCP server socket on remote PC. 

-  After establishment of TCP connection, "Client connected" message is seen in Client connection status.
 
      ![Figure: TCP packets to the remote peer](resources/readme/image187.png)

- Application prints can be observed as follows

  ![Figure: TCP packets to the remote peer](resources/readme/tcptxonperiodicwakeupapplicationprints1.png)

  ![Figure: TCP packets to the remote peer](resources/readme/tcptxonperiodicwakeupapplicationprints2.png)


## **10 Application flow**
As the application runs, SiWx91x scans and connects to the Wi-Fi access point and obtains an IP address. After a successful connection, the device sends 64MB data to TCP Server running on a remote peer which is connected to access point. 

After completing data transfer (number of packets sent = NO_OF_PACKETS), NWP/TA is triggered to sleep with powersave mode 2 with ram retention followed by triggering M4 to sleep with ram retention. M4 then wakes up with the configured alarm time and followed by NWP/TA waking up with a packet from M4. The program flow repeats from data transmission, each time before beginning data transmission NWP/TA is brought out of powersave mode 2.

## **Appendix**
Refer [AEM measurement]() section in ***Getting Started with SiWx91x SoC*** guide for measuring current consumption of SiWx91x module. 

