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

# Automatically-generated Simplicity Studio Metadata
# Please do not edit or delete these lines!
# SIMPLICITY_STUDIO_METADATA=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=END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA