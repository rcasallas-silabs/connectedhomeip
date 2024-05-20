####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = /Volumes/Resources/git/gsdk
UNAME:=$(shell $(POSIX_TOOL_PATH)uname -s | $(POSIX_TOOL_PATH)sed -e 's/^\(CYGWIN\).*/\1/' | $(POSIX_TOOL_PATH)sed -e 's/^\(MINGW\).*/\1/')
ifeq ($(UNAME),MINGW)
# Translate "C:/super" into "/C/super" for MinGW make.
SDK_PATH := /$(shell $(POSIX_TOOL_PATH)echo $(BASE_SDK_PATH) | sed s/://)
endif
SDK_PATH ?= $(BASE_SDK_PATH)
COPIED_SDK_PATH ?= gecko_sdk_4.4.3

# This uses the explicit build rules below
PROJECT_SOURCE_FILES =

C_SOURCE_FILES   += $(filter %.c, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cpp, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cc, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.s, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.S, $(PROJECT_SOURCE_FILES))
LIB_FILES        += $(filter %.a, $(PROJECT_SOURCE_FILES))

C_DEFS += \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DDEBUG_EFM=1' \
 '-DMBEDTLS_CONFIG_FILE="siwx917-chip-tinycrypt-config.h"' \
 '-DOPTIMIZE_TINYCRYPT_ASM=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=1' \
 '-DSL_MBEDTLS_USE_TINYCRYPT=1' \
 '-DTINYCRYPT_PRIMITIVES=1' \
 '-DSIWG917M111MGTBA=1' \
 '-DSLI_SI917=1' \
 '-DSLI_SI917B0=1' \
 '-DSLI_SI91X_MCU_ENABLE_FLASH_BASED_EXECUTION=1' \
 '-DSLI_SI91X_MCU_COMMON_FLASH_MODE=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_BASE_VER=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_VER2=1' \
 '-DSL_BOARD_NAME="BRD4002A"' \
 '-DSL_BOARD_REV="A06"' \
 '-DSL_NET_COMPONENT_INCLUDED=1' \
 '-D__STATIC_INLINE=static inline' \
 '-DSL_SI91X_BOARD_INIT=1' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSRAM_SIZE=0x2fc00UL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
 '-DDEBUG_ENABLE=1' \
 '-DDEBUG_UART=1' \
 '-DENABLE_DEBUG_MODULE=1' \
 '-DFLASH_PAGE_SIZE=1' \
 '-DSLI_SI91X_OFFLOAD_NETWORK_STACK=1' \
 '-DSI917=1' \
 '-DSLI_SI91X_ENABLE_OS=1' \
 '-DSLI_SI91X_MCU_INTERFACE=1' \
 '-DTA_DEEP_SLEEP_COMMON_FLASH=1' \
 '-DSI91X_PLATFORM=1' \
 '-DSI91X_SYSRTC_PRESENT=1' \
 '-DSL_SLEEP_TIMER=1' \
 '-D__WEAK=__attribute__((weak))' \
 '-DSL_WIFI_COMPONENT_INCLUDED=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

ASM_DEFS += \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DDEBUG_EFM=1' \
 '-DMBEDTLS_CONFIG_FILE="siwx917-chip-tinycrypt-config.h"' \
 '-DOPTIMIZE_TINYCRYPT_ASM=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=1' \
 '-DSL_MBEDTLS_USE_TINYCRYPT=1' \
 '-DTINYCRYPT_PRIMITIVES=1' \
 '-DSIWG917M111MGTBA=1' \
 '-DSLI_SI917=1' \
 '-DSLI_SI917B0=1' \
 '-DSLI_SI91X_MCU_ENABLE_FLASH_BASED_EXECUTION=1' \
 '-DSLI_SI91X_MCU_COMMON_FLASH_MODE=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_BASE_VER=1' \
 '-DSLI_SI91X_MCU_CONFIG_RADIO_BOARD_VER2=1' \
 '-DSL_BOARD_NAME="BRD4002A"' \
 '-DSL_BOARD_REV="A06"' \
 '-DSL_NET_COMPONENT_INCLUDED=1' \
 '-D__STATIC_INLINE=static inline' \
 '-DSL_SI91X_BOARD_INIT=1' \
 '-DSRAM_BASE=0x0cUL' \
 '-DSRAM_SIZE=0x2fc00UL' \
 '-DSLI_SI91X_MCU_ENABLE_IPMU_APIS=1' \
 '-DSL_SI91X_SI917_RAM_MEM_CONFIG=1' \
 '-DDEBUG_ENABLE=1' \
 '-DDEBUG_UART=1' \
 '-DENABLE_DEBUG_MODULE=1' \
 '-DFLASH_PAGE_SIZE=1' \
 '-DSLI_SI91X_OFFLOAD_NETWORK_STACK=1' \
 '-DSI917=1' \
 '-DSLI_SI91X_ENABLE_OS=1' \
 '-DSLI_SI91X_MCU_INTERFACE=1' \
 '-DTA_DEEP_SLEEP_COMMON_FLASH=1' \
 '-DSI91X_PLATFORM=1' \
 '-DSI91X_SYSRTC_PRESENT=1' \
 '-DSL_SLEEP_TIMER=1' \
 '-D__WEAK=__attribute__((weak))' \
 '-DSL_WIFI_COMPONENT_INCLUDED=1' \
 '-DconfigNUM_SDK_THREAD_LOCAL_STORAGE_POINTERS=2' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

INCLUDES += \
 -Iconfig \
 -Iautogen \
 -I../.. \
 -I../../../../examples \
 -I../../../../examples/platform/silabs \
 -I../../../../src \
 -I../../../../src/platform/silabs/SiWx917 \
 -I../../../../src/include \
 -I../../../../zzz_generated/app-common \
 -I../../../../third_party/nlassert/repo/include \
 -I../../../../third_party/nlio/repo/include \
 -I../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/inc \
 -I../../../../third_party/mbedtls/repo/library \
 -I../../../../third_party/mbedtls/repo/include \
 -I../../../../src/lib/support \
 -I../../../../src/platform/silabs \
 -I../../../../third_party/silabs/matter_support/matter/si91x/siwx917/BRD4338A/support/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/service/bsd_socket/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/CMSIS/Driver/Include \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/config \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/rom_driver/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/board/silabs/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_api/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_peripheral_drivers/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/button/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/led/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/sleeptimer/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/protocol/wifi/inc \
 -I$(SDK_PATH)/../stash/wifi_sdk/resources/certificates \
 -I$(SDK_PATH)/../stash/wifi_sdk/resources/html \
 -I$(SDK_PATH)/../stash/wifi_sdk/resources/other \
 -I$(SDK_PATH)/../stash/wifi_sdk/components/common/inc \
 -I$(SDK_PATH)/platform/common/inc \
 -I$(SDK_PATH)/platform/CMSIS/Core/Include \
 -I$(SDK_PATH)/platform/CMSIS/RTOS2/Include \
 -I$(SDK_PATH)/platform/service/device_init/inc \
 -I$(SDK_PATH)/platform/emdrv/common/inc \
 -I$(SDK_PATH)/platform/emlib/inc \
 -I$(SDK_PATH)/util/third_party/freertos/cmsis/Include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/include \
 -I$(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F \
 -I$(SDK_PATH)/platform/service/iostream/inc \
 -I$(SDK_PATH)/platform/emdrv/nvm3/inc \
 -I$(SDK_PATH)/util/third_party/segger/systemview/SEGGER \
 -I$(SDK_PATH)/platform/service/system/inc \
 -I$(SDK_PATH)/platform/service/sleeptimer/inc

GROUP_START =-Wl,--start-group
GROUP_END =-Wl,--end-group

PROJECT_LIBS = \
 -lgcc \
 -lnosys \
 -lstdc++ \
 -lc \
 -lm \
 $(SDK_PATH)/platform/emdrv/nvm3/lib/libnvm3_CM4_gcc.a

LIBS += $(GROUP_START) $(PROJECT_LIBS) $(GROUP_END)

LIB_FILES += $(filter %.a, $(PROJECT_LIBS))

C_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -std=c99 \
 -Wall \
 -Wextra \
 -Og \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -Wno-unused-parameter \
 -mcpu=cortex-m4 \
 --specs=nano.specs \
 -g

CXX_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -std=c++17 \
 -fno-rtti \
 -fno-exceptions \
 -Wall \
 -Wextra \
 -Og \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -Wno-unused-parameter \
 -mcpu=cortex-m4 \
 --specs=nano.specs \
 -g

ASM_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -x assembler-with-cpp

LD_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -T"autogen/linkerfile_SoC.ld" \
 --specs=nano.specs \
 -Xlinker -Map=$(OUTPUT_DIR)/$(PROJECTNAME).map \
 -u _printf_float \
 -Wl,--gc-sections \
 -Wl,--no-warn-rwx-segments


####################################################################
# Pre/Post Build Rules                                             #
####################################################################
pre-build:
	# No pre-build defined

post-build: $(OUTPUT_DIR)/$(PROJECTNAME).out
	# No post-build defined

####################################################################
# SDK Build Rules                                                  #
####################################################################
$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/board/silabs/src/rsi_board.o: $(SDK_PATH)/../stash/wifi_sdk/components/board/silabs/src/rsi_board.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/board/silabs/src/rsi_board.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/board/silabs/src/rsi_board.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/board/silabs/src/rsi_board.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/board/silabs/src/rsi_board.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/common/src/sl_utility.o: $(SDK_PATH)/../stash/wifi_sdk/components/common/src/sl_utility.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/common/src/sl_utility.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/common/src/sl_utility.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/common/src/sl_utility.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/common/src/sl_utility.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/ipmu_apis.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/iPMU_prog/iPMU_dotc/rsi_system_config_917.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_deepsleep_soc.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/rsi_ps_ram_func.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/startup_si91x.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/chip/src/system_si91x.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/rsi_debug.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/common/src/sl_si91x_stack_object_declare.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/core/config/src/rsi_nvic_priorities_config.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/UDMA.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/cmsis_driver/USART.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/button/src/sl_si91x_button.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/button/src/sl_si91x_button.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/button/src/sl_si91x_button.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/button/src/sl_si91x_button.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/button/src/sl_si91x_button.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/button/src/sl_si91x_button.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/led/src/sl_si91x_led.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/led/src/sl_si91x_led.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/led/src/sl_si91x_led.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/led/src/sl_si91x_led.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/led/src/sl_si91x_led.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/hardware_drivers/led/src/sl_si91x_led.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/clock_update.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_crc.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_egpio.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_sysrtc.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_sysrtc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_sysrtc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_sysrtc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_sysrtc.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_sysrtc.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_timers.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_udma_wrapper.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/peripheral_drivers/src/rsi_usart.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_common_flash_intf.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/nvm3/src/sl_si91x_nvm3_hal_flash.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/sleeptimer/src/sl_sleeptimer_hal_si91x_sysrtc.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/sleeptimer/src/sl_sleeptimer_hal_si91x_sysrtc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/sleeptimer/src/sl_sleeptimer_hal_si91x_sysrtc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/sleeptimer/src/sl_sleeptimer_hal_si91x_sysrtc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/sleeptimer/src/sl_sleeptimer_hal_si91x_sysrtc.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/service/sleeptimer/src/sl_sleeptimer_hal_si91x_sysrtc.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ipmu.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_pll.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_power_save.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_rtc.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_temp_sensor.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_time_period.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_ulpss_clk.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/systemlevel/src/rsi_wwdt.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_api/src/sl_si91x_driver_gpio.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_api/src/sl_si91x_driver_gpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_api/src/sl_si91x_driver_gpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_api/src/sl_si91x_driver_gpio.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_api/src/sl_si91x_driver_gpio.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_api/src/sl_si91x_driver_gpio.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_peripheral_drivers/src/sl_si91x_peripheral_gpio.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_peripheral_drivers/src/sl_si91x_peripheral_gpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_peripheral_drivers/src/sl_si91x_peripheral_gpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_peripheral_drivers/src/sl_si91x_peripheral_gpio.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_peripheral_drivers/src/sl_si91x_peripheral_gpio.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/mcu/drivers/unified_peripheral_drivers/src/sl_si91x_peripheral_gpio.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_ram.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/rsi_hal_mcu_m4_rom.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_platform_wireless.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_bus.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sl_si91x_timer.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/ahb_interface/src/sli_siwx917_soc.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/errno/src/sl_si91x_errno.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/firmware_upgrade/firmware_upgradation.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/host_mcu/si91x/siwx917_soc_ncp_host.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/icmp/sl_net_ping.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/memory/malloc_buffers.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_rsi_utility.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_net_si91x_integration_handler.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_credentials.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/sl_net/src/sl_si91x_net_internal_stack.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_rsi_utility.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_callback_framework.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/src/sl_si91x_driver.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.o: $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/device/silabs/si91x/wireless/threading/sli_si91x_multithreaded.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.o: $(SDK_PATH)/../stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/protocol/wifi/si91x/sl_wifi.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.o: $(SDK_PATH)/../stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/protocol/wifi/src/sl_wifi_callback_framework.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.o: $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/si91x/sl_net_si91x.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net.o: $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.o: $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_certificate_store.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.o: $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_credentials.o

$(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.o: $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/../stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.c
CDEPS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.d
OBJS += $(OUTPUT_DIR)/sdk/_/stash/wifi_sdk/components/service/network_manager/src/sl_net_basic_profiles.o

$(OUTPUT_DIR)/sdk/platform/CMSIS/RTOS2/Source/os_systick.o: $(SDK_PATH)/platform/CMSIS/RTOS2/Source/os_systick.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/CMSIS/RTOS2/Source/os_systick.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/CMSIS/RTOS2/Source/os_systick.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/CMSIS/RTOS2/Source/os_systick.d
OBJS += $(OUTPUT_DIR)/sdk/platform/CMSIS/RTOS2/Source/os_systick.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_assert.o: $(SDK_PATH)/platform/common/src/sl_assert.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_assert.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_assert.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_assert.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_assert.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_slist.o: $(SDK_PATH)/platform/common/src/sl_slist.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_slist.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_slist.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_slist.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_slist.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_string.o: $(SDK_PATH)/platform/common/src/sl_string.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_string.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_string.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_string.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_string.o

$(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o: $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sli_cmsis_os2_ext_task_register.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sli_cmsis_os2_ext_task_register.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o: $(SDK_PATH)/platform/emlib/src/em_core.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_core.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_core.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_nvic.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_nvic.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_nvic.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_nvic.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_nvic.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_nvic.o

$(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream.o: $(SDK_PATH)/platform/service/iostream/src/sl_iostream.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/iostream/src/sl_iostream.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/iostream/src/sl_iostream.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream.o

$(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream_rtt.o: $(SDK_PATH)/platform/service/iostream/src/sl_iostream_rtt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/iostream/src/sl_iostream_rtt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/iostream/src/sl_iostream_rtt.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream_rtt.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/iostream/src/sl_iostream_rtt.o

$(OUTPUT_DIR)/sdk/platform/service/sleeptimer/src/sl_sleeptimer.o: $(SDK_PATH)/platform/service/sleeptimer/src/sl_sleeptimer.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/sleeptimer/src/sl_sleeptimer.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/sleeptimer/src/sl_sleeptimer.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/sleeptimer/src/sl_sleeptimer.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/sleeptimer/src/sl_sleeptimer.o

$(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_init.o: $(SDK_PATH)/platform/service/system/src/sl_system_init.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/system/src/sl_system_init.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/system/src/sl_system_init.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_init.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_init.o

$(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_kernel.o: $(SDK_PATH)/platform/service/system/src/sl_system_kernel.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/system/src/sl_system_kernel.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/system/src/sl_system_kernel.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_kernel.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_kernel.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/cmsis/Source/cmsis_os2.o: $(SDK_PATH)/util/third_party/freertos/cmsis/Source/cmsis_os2.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/cmsis/Source/cmsis_os2.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/cmsis/Source/cmsis_os2.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/cmsis/Source/cmsis_os2.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/cmsis/Source/cmsis_os2.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/croutine.o: $(SDK_PATH)/util/third_party/freertos/kernel/croutine.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/croutine.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/croutine.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/croutine.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/croutine.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/event_groups.o: $(SDK_PATH)/util/third_party/freertos/kernel/event_groups.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/event_groups.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/event_groups.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/event_groups.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/event_groups.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/list.o: $(SDK_PATH)/util/third_party/freertos/kernel/list.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/list.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/list.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/list.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/list.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.o: $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/GCC/ARM_CM4F/port.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/MemMang/heap_4.o: $(SDK_PATH)/util/third_party/freertos/kernel/portable/MemMang/heap_4.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/portable/MemMang/heap_4.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/portable/MemMang/heap_4.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/MemMang/heap_4.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/portable/MemMang/heap_4.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/queue.o: $(SDK_PATH)/util/third_party/freertos/kernel/queue.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/queue.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/queue.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/queue.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/queue.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/stream_buffer.o: $(SDK_PATH)/util/third_party/freertos/kernel/stream_buffer.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/stream_buffer.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/stream_buffer.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/stream_buffer.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/stream_buffer.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/tasks.o: $(SDK_PATH)/util/third_party/freertos/kernel/tasks.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/tasks.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/tasks.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/tasks.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/tasks.o

$(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/timers.o: $(SDK_PATH)/util/third_party/freertos/kernel/timers.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/freertos/kernel/timers.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/freertos/kernel/timers.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/timers.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/freertos/kernel/timers.o

$(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.o: $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.o: ../../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o: ../../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o: ../../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/provision/ProvisionEncoder.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionManager.o: ../../../../examples/platform/silabs/provision/ProvisionManager.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/provision/ProvisionManager.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/provision/ProvisionManager.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionManager.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionManager.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o: ../../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o: ../../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o: ../../../../examples/platform/silabs/provision/ProvisionStorage.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/provision/ProvisionStorage.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/provision/ProvisionStorage.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionStorage.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o: ../../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o: ../../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o

$(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/syscalls_stubs.o: ../../../../examples/platform/silabs/syscalls_stubs.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../examples/platform/silabs/syscalls_stubs.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../examples/platform/silabs/syscalls_stubs.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/syscalls_stubs.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/examples/platform/silabs/syscalls_stubs.o

$(OUTPUT_DIR)/project/_/_/_/_/src/lib/support/Base64.o: ../../../../src/lib/support/Base64.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../src/lib/support/Base64.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../src/lib/support/Base64.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/src/lib/support/Base64.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/src/lib/support/Base64.o

$(OUTPUT_DIR)/project/_/_/_/_/src/lib/support/BytesToHex.o: ../../../../src/lib/support/BytesToHex.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../src/lib/support/BytesToHex.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../src/lib/support/BytesToHex.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/src/lib/support/BytesToHex.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/src/lib/support/BytesToHex.o

$(OUTPUT_DIR)/project/_/_/_/_/src/lib/support/logging/TextOnlyLogging.o: ../../../../src/lib/support/logging/TextOnlyLogging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../src/lib/support/logging/TextOnlyLogging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../src/lib/support/logging/TextOnlyLogging.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/src/lib/support/logging/TextOnlyLogging.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/src/lib/support/logging/TextOnlyLogging.o

$(OUTPUT_DIR)/project/_/_/_/_/src/platform/silabs/Logging.o: ../../../../src/platform/silabs/Logging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../src/platform/silabs/Logging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../src/platform/silabs/Logging.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/src/platform/silabs/Logging.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/src/platform/silabs/Logging.o

$(OUTPUT_DIR)/project/_/_/_/_/src/platform/silabs/SilabsConfig.o: ../../../../src/platform/silabs/SilabsConfig.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../src/platform/silabs/SilabsConfig.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../src/platform/silabs/SilabsConfig.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/src/platform/silabs/SilabsConfig.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/src/platform/silabs/SilabsConfig.o

$(OUTPUT_DIR)/project/_/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.o: ../../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.o

$(OUTPUT_DIR)/project/_/_/_/_/src/setup_payload/Base38Encode.o: ../../../../src/setup_payload/Base38Encode.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../src/setup_payload/Base38Encode.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../../src/setup_payload/Base38Encode.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/_/src/setup_payload/Base38Encode.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/src/setup_payload/Base38Encode.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/aes.o: ../../../../third_party/mbedtls/repo/library/aes.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/aes.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/aes.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/aes.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/asn1parse.o: ../../../../third_party/mbedtls/repo/library/asn1parse.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/asn1parse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/asn1parse.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/asn1parse.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/asn1parse.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/asn1write.o: ../../../../third_party/mbedtls/repo/library/asn1write.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/asn1write.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/asn1write.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/asn1write.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/asn1write.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/base64.o: ../../../../third_party/mbedtls/repo/library/base64.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/base64.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/base64.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/base64.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/base64.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/bignum.o: ../../../../third_party/mbedtls/repo/library/bignum.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/bignum.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/bignum.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/bignum.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/bignum.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ccm.o: ../../../../third_party/mbedtls/repo/library/ccm.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/ccm.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/ccm.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ccm.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ccm.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/cipher.o: ../../../../third_party/mbedtls/repo/library/cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/cipher.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/cipher.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/cipher.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/cipher_wrap.o: ../../../../third_party/mbedtls/repo/library/cipher_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/cipher_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/cipher_wrap.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/cipher_wrap.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/cipher_wrap.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/constant_time.o: ../../../../third_party/mbedtls/repo/library/constant_time.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/constant_time.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/constant_time.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/constant_time.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/constant_time.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ctr_drbg.o: ../../../../third_party/mbedtls/repo/library/ctr_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/ctr_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/ctr_drbg.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ctr_drbg.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ctr_drbg.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecdh.o: ../../../../third_party/mbedtls/repo/library/ecdh.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/ecdh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/ecdh.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecdh.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecdh.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecdsa.o: ../../../../third_party/mbedtls/repo/library/ecdsa.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/ecdsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/ecdsa.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecdsa.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecdsa.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecp.o: ../../../../third_party/mbedtls/repo/library/ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/ecp.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecp.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecp.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecp_curves.o: ../../../../third_party/mbedtls/repo/library/ecp_curves.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/ecp_curves.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/ecp_curves.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecp_curves.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/ecp_curves.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/entropy.o: ../../../../third_party/mbedtls/repo/library/entropy.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/entropy.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/entropy.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/entropy.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/entropy.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/hkdf.o: ../../../../third_party/mbedtls/repo/library/hkdf.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/hkdf.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/hkdf.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/hkdf.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/hkdf.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/hmac_drbg.o: ../../../../third_party/mbedtls/repo/library/hmac_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/hmac_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/hmac_drbg.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/hmac_drbg.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/hmac_drbg.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/md.o: ../../../../third_party/mbedtls/repo/library/md.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/md.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/md.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/md.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/md.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/pem.o: ../../../../third_party/mbedtls/repo/library/pem.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/pem.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/pem.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/pem.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/pem.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/pkcs5.o: ../../../../third_party/mbedtls/repo/library/pkcs5.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/pkcs5.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/pkcs5.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/pkcs5.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/pkcs5.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/platform.o: ../../../../third_party/mbedtls/repo/library/platform.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/platform.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/platform.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/platform.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/platform.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/sha256.o: ../../../../third_party/mbedtls/repo/library/sha256.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/sha256.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/sha256.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/sha256.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/sha256.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/sha512.o: ../../../../third_party/mbedtls/repo/library/sha512.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/sha512.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/sha512.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/sha512.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/sha512.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/x509.o: ../../../../third_party/mbedtls/repo/library/x509.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/x509.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/x509.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/x509.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/x509.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/x509_create.o: ../../../../third_party/mbedtls/repo/library/x509_create.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/mbedtls/repo/library/x509_create.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/mbedtls/repo/library/x509_create.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/x509_create.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/mbedtls/repo/library/x509_create.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.o

$(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.o: ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.o

$(OUTPUT_DIR)/project/_/_/app.o: ../../app.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../app.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../app.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/app.d
OBJS += $(OUTPUT_DIR)/project/_/_/app.o

$(OUTPUT_DIR)/project/_/_/main.o: ../../main.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../main.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../main.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/main.d
OBJS += $(OUTPUT_DIR)/project/_/_/main.o

$(OUTPUT_DIR)/project/_/_/si917.o: ../../si917.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../si917.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../si917.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/si917.d
OBJS += $(OUTPUT_DIR)/project/_/_/si917.o

$(OUTPUT_DIR)/project/autogen/sl_event_handler.o: autogen/sl_event_handler.c
	@$(POSIX_TOOL_PATH)echo 'Building autogen/sl_event_handler.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ autogen/sl_event_handler.c
CDEPS += $(OUTPUT_DIR)/project/autogen/sl_event_handler.d
OBJS += $(OUTPUT_DIR)/project/autogen/sl_event_handler.o

$(OUTPUT_DIR)/project/autogen/sl_iostream_handles.o: autogen/sl_iostream_handles.c
	@$(POSIX_TOOL_PATH)echo 'Building autogen/sl_iostream_handles.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ autogen/sl_iostream_handles.c
CDEPS += $(OUTPUT_DIR)/project/autogen/sl_iostream_handles.d
OBJS += $(OUTPUT_DIR)/project/autogen/sl_iostream_handles.o

$(OUTPUT_DIR)/project/autogen/sl_si91x_button_instances.o: autogen/sl_si91x_button_instances.c
	@$(POSIX_TOOL_PATH)echo 'Building autogen/sl_si91x_button_instances.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ autogen/sl_si91x_button_instances.c
CDEPS += $(OUTPUT_DIR)/project/autogen/sl_si91x_button_instances.d
OBJS += $(OUTPUT_DIR)/project/autogen/sl_si91x_button_instances.o

$(OUTPUT_DIR)/project/autogen/sl_si91x_led_instances.o: autogen/sl_si91x_led_instances.c
	@$(POSIX_TOOL_PATH)echo 'Building autogen/sl_si91x_led_instances.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ autogen/sl_si91x_led_instances.c
CDEPS += $(OUTPUT_DIR)/project/autogen/sl_si91x_led_instances.d
OBJS += $(OUTPUT_DIR)/project/autogen/sl_si91x_led_instances.o

# Automatically-generated Simplicity Studio Metadata
# Please do not edit or delete these lines!
# SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA