# **UDP Client Socket**

## **1 Introduction**
The UDP client application demonstrates how to open and use a standard UDP client socket to send data to a UDP server socket. 

## **2 Prerequisites**
For running the application, you will need the following:
### **2.1 Hardware Requirements**
- A Windows PC
- A Wi-Fi Access Point
#### **2.1.1 SoC** 
   - Silicon Labs SiWx917 PK6030A SoC Kit which includes
      - BRD4001A/BRD4002A Wireless Starter Kit Mainboard
      - BRD4325A Radio Board
   - USB TO UART converter
#### **2.1.2 NCP**
   - Silicon Labs BRD8036A Si917 QMS SB Expansion Board
   - [Silicon Labs SLWSTK6006A EFR32xG21 Wireless Starter Kit](https://www.silabs.com/development-tools/wireless/efr32xg21-wireless-starter-kit) which includes
      - BRD4001A/BRD4002A Wireless Starter Kit Mainboard
      - BRD4180A/BRD4180B Radio Board
### **2.2 Software Requirements**
- Simplicity Studio IDE
   - To download and install the Simplicity Studio IDE, refer to the [Simplicity Studio IDE Set up]() section in ***Getting started with SiWx91x*** guide.
- [Iperf application](https://iperf.fr/iperf-download.php) 
- Tera Term software or any other serial terminal software - for viewing application prints

## **3 Set up diagram**
### **3.1 SoC** 

![Figure: Setup Diagram for UDP client Example: SoC](resources/readme/udpclientsetupsoc.png)
### **3.2 NCP** 

![Figure: Setup Diagram for UDP client Example: NCP](resources/readme/udpclientsetupncp.png)

**NOTE**: 
- The Host MCU platform (EFR32xG21) and the SiWx91x interact with each other through the SPI interface. 


## **4 Set up**
### **4.1 SoC/NCP** 
- Follow the [Hardware connections and Simplicity Studio IDE Set up]()  section in the respective ***Getting Started with SiWx91x*** guide to make the hardware connections and add the Gecko and SiWx91x COMBO SDKs to Simplicity Studio IDE.
### **4.2 SiWx91x module's Firmware Update**
- Ensure the SiWx91x module is loaded with the latest firmware following the [SiWx91x Firmware Update]() section in the respective ***Getting started with SiWx91x*** guide.

## **5 Creation of Project**
  
To create the UDP client example project in the Simplicity Studio IDE, follow the [Creation of Project]() section in the respective ***Getting started with SiWx91x*** guide. 
   - For SoC, choose the **Wi-Fi - SoC UDP Client** example.
   - For NCP, choose the **Wi-Fi - NCP UDP Client** example.


## **6 Application configuration**
Read through the following sections and make any changes needed. 
  
1. In the Project explorer pane of the IDE, expand the **udp_client** folder and open the **rsi_udp_client.c** file. Configure the following parameters based on your requirements.

   ![Application configuration](resources/readme/udpclientapplicationconfiguration.png)

2. Wi-Fi configuration    

    ```c
    //! Wi-Fi Network Name
    #define SSID           "SILABS_AP"      
    
    //! Wi-Fi Password
    #define PSK            "12345678"       

    //! Wi-Fi Security Type: RSI_OPEN/RSI_WPA/RSI_WPA2
    #define SECURITY_TYPE  RSI_WPA2         
    
    //! Wi-Fi channel
    #define CHANNEL_NO     0                 
    ```
2. Client/Server IP Settings
    ```c
    //! Remote UDP server port number which is opened in Windows PC2
    #define SERVER_PORT         5001             
    
    //! Remote server IP address
    #define SERVER_IP_ADDRESS   "192.168.10.100" 

    //How many packets to receive from UDP client (Ex: #define NUMBER_OF_PACKETS 10000) 
    #define NUMBER_OF_PACKETS   10000            
    ```
3. IP configuration
    ```c
    //! Whether IP address is configured through DHCP or STATIC
    #define DHCP_MODE               1           
    ```
   > If user wants to configure STA IP address through DHCP then set DHCP_MODE to "1" and skip configuring the DEVICE_IP, GATEWAY and NETMASK macros.
                                         (Or)
   > If user wants to configure STA IP address through STATIC then set DHCP_MODE macro to "0" and configure the DEVICE_IP, GATEWAY and NETMASK macros.
   ```c
    #define DEVICE_IP              "192.168.10.1"
    #define GATEWAY                "192.168.10.1"
    #define NETMASK                "255.255.255.0"
   ```
## **7 Setup for Serial Prints**

To Setup the serial prints, follow the [Setup for Serial Prints]() section in the respective ***Getting started with SiWx91x*** guides.
 
## **8 Build, Flash, and Run the Application**

To build, flash, and run the application project refer to the [Build and Flash the Project]() section in the respective ***Getting Started with SiWx91x*** guide.

## **9 Application Execution Flow**

1. Connect the windows PC to the Access Point
2. Open UDP server application using iperf application in Windows PC which is connected to the Access point.
      
      `iperf_demo.exe -s -u -p <SERVER_PORT> -i 1`

      ![Command](resources/readme/udpclientiperfcommand.png)

3. After program gets executed, SiWx917 module would scan and connect to the Access point and get IP.

4. After successful connection, SiWx917 module connects to UDP server socket opened on Windows PC using UDP client socket and sends configured NUMBER_OF_PACKETS to remote UDP server. Please refer the below image for reception of UDP data on UDP server.

   ![Command](resources/readme/udpclientiperflogs.png)

5. Application prints can be observed as follows:

- ### **SoC:**
  
   ![Application prints](resources/readme/udpclientapplicationprintssoc.png)

- ### **NCP:**

   ![Application prints](resources/readme/udpclientapplicationprintsncp.png)

## **Appendix**

By default, the application runs over FreeRTOS. To run the application with Bare metal configurations, follow the Bare Metal configuration section in the ***Getting Started with SiWx91x*** guides.