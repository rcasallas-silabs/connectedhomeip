# SiWx917 Wi-Fi and Bluetooth Software

# SDK Outline
The SiWx917 SDK contains the following files and folders.

```
  +--examples
  |  +--featured         > Full-featured examples including cloud, powersave, throughput and RF test apps 
  |  +--snippets         > Simpler examples to demonstrate specific features
  |  +--si91x_soc        > Examples to demonstrate SoC Peripherals
  |-   
  +--connectivity_firmware                         > Si91x firmware image(s)
  |  +--SiWG917-A.x.x.x.0.x.rps                    > Full-featured firmware image
  |  +--SiWG917-A.x.x.x.2.x.rps                    > Size-optimized firmware image(unsupported for SoC mode in the current release)
  |-   
  +--platforms            
  |  +--efx32            > Board Support for EFR32 Hosts in NCP Mode
  |  +--efm32            > Board Support for EFM32 Hosts in NCP Mode
  |  +--si91x            > Board Support for cortex M4 in SoC Mode
  |  +--component        > Component files related to each platform
  |-   
  +--resources   
  |  +--certificates     > Security certificates and keys to secure Wi-Fi, TCP and HTTP connections
  |  +--scripts          > Scripts to assist with testing of example applications
  |  +--component        > Component files related to certificates
  |
  +--sapi                
  |  +--bluetooth        > APIs to access Bluetooth Low Energy features
  |  +--common           > Common APIs including device init, driver init, firmware query, ...
  |  +--crypto           > APIs to access cryptographic functions
  |  +--driver           > Driver source for various host interfaces incluing SPI, SDIO and UART
  |  +--include          > Full collection of API function prototypes
  |  +--logging          > APIs to generate detailed SAPI logs
  |  +--network          > Collection of network related protocols including MQTT, HTTP, BSD sockets, ...
  |  +--rtos             > Wrapper files for various RTOS implementations
  |  +--wlan             > APIs to access Wi-Fi features including scan, join, powersave, ...
  |  +--component        > Component files related to sapi
  |
  +--third_party
  |  +--aws_sdk          > AWS IoT SDK source
  |  +--freertos         > FreeRTOS source
  |  +--mqtt_client      > Paho MQTT source
  |  +--component        > Component files related to third_party
  |
  +--utilities           
  |  +--python                                   > Python scripts for loading certificates 
  |  +--isp_scripts_common_flash                 > Post build scripts for isp  
  |  +--ble_provisioning_apps                    > Python scripts for BLE provisioning App
  |  +--advanced_logging                         > Scripts to decrypt the generated logs  
  |
  +--docs
  |  +--index.html        > Getting Started Section 
  |                         - Getting Started with SiWx917 in SoC Mode : This guide describes how to get started developing 
  |                                                                      an SiWx917 application on a BRD4325A radio board as SoC Mode. 
  |                         - Getting Started with an EFx32 Host       : This guide describes how to get started developing 
  |                                                                      a SiWx917 application on an EFx32 embedded host MCU in NCP Mode.
  |                       > Example Applications Section
  |                         - Featured Examples                        :  Full featured projects that demonstrate a common SiWx917 use-case.
  |                         - Snippet  Examples                        :  Smaller projects that focus on one particular feature or API.
  |                         - SoC Examples                             :  SoC Projects that demonstrate SiWx917 peripherals only in SoC Mode.
  |                       > Simple API Reference                       :  This documentation in this section describes the SiWx917 SAPI (Simple API) library.
  |                       > Release Notes                              :  Release notes is provided with each version of the SDK.
```
