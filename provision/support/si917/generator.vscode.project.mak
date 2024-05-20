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
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
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
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
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
 -I../../generator \
 -I../../../examples \
 -I../../../examples/platform/silabs \
 -I../../../src \
 -I../../../src/platform/silabs/SiWx917 \
 -I../../../src/include \
 -I../../../zzz_generated/app-common \
 -I../../../third_party/nlassert/repo/include \
 -I../../../third_party/nlio/repo/include \
 -I../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/inc \
 -I../../../third_party/mbedtls/repo/library \
 -I../../../third_party/mbedtls/repo/include \
 -I../../../src/lib/support \
 -I../../../src/platform/silabs \
 -I../../../third_party/silabs/matter_support/matter/si91x/siwx917/BRD4338A/support/inc \
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

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.o: ../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/AttestationKeyMbed.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/AttestationKeyMbed.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o: ../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o: ../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionEncoder.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionManager.o: ../../../examples/platform/silabs/provision/ProvisionManager.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionManager.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionManager.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionManager.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionManager.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o: ../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o: ../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o: ../../../examples/platform/silabs/provision/ProvisionStorage.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionStorage.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionStorage.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorage.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o: ../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o: ../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o

$(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/syscalls_stubs.o: ../../../examples/platform/silabs/syscalls_stubs.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../examples/platform/silabs/syscalls_stubs.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../examples/platform/silabs/syscalls_stubs.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/syscalls_stubs.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/examples/platform/silabs/syscalls_stubs.o

$(OUTPUT_DIR)/project/_/_/_/src/lib/support/Base64.o: ../../../src/lib/support/Base64.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/lib/support/Base64.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/lib/support/Base64.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/Base64.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/Base64.o

$(OUTPUT_DIR)/project/_/_/_/src/lib/support/BytesToHex.o: ../../../src/lib/support/BytesToHex.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/lib/support/BytesToHex.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/lib/support/BytesToHex.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/BytesToHex.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/BytesToHex.o

$(OUTPUT_DIR)/project/_/_/_/src/lib/support/logging/TextOnlyLogging.o: ../../../src/lib/support/logging/TextOnlyLogging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/lib/support/logging/TextOnlyLogging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/lib/support/logging/TextOnlyLogging.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/logging/TextOnlyLogging.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/lib/support/logging/TextOnlyLogging.o

$(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/Logging.o: ../../../src/platform/silabs/Logging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/platform/silabs/Logging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/platform/silabs/Logging.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/Logging.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/Logging.o

$(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/SilabsConfig.o: ../../../src/platform/silabs/SilabsConfig.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/platform/silabs/SilabsConfig.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/platform/silabs/SilabsConfig.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/SilabsConfig.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/SilabsConfig.o

$(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.o: ../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/platform/silabs/SiWx917/CHIPCryptoPALTinyCrypt.o

$(OUTPUT_DIR)/project/_/_/_/src/setup_payload/Base38Encode.o: ../../../src/setup_payload/Base38Encode.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../../src/setup_payload/Base38Encode.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../../src/setup_payload/Base38Encode.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/_/src/setup_payload/Base38Encode.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/src/setup_payload/Base38Encode.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/aes.o: ../../../third_party/mbedtls/repo/library/aes.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/aes.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/aes.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/aes.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/asn1parse.o: ../../../third_party/mbedtls/repo/library/asn1parse.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/asn1parse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/asn1parse.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/asn1parse.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/asn1parse.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/asn1write.o: ../../../third_party/mbedtls/repo/library/asn1write.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/asn1write.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/asn1write.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/asn1write.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/asn1write.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/base64.o: ../../../third_party/mbedtls/repo/library/base64.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/base64.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/base64.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/base64.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/base64.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/bignum.o: ../../../third_party/mbedtls/repo/library/bignum.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/bignum.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/bignum.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/bignum.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/bignum.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ccm.o: ../../../third_party/mbedtls/repo/library/ccm.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/ccm.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/ccm.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ccm.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ccm.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/cipher.o: ../../../third_party/mbedtls/repo/library/cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/cipher.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/cipher.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/cipher.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/cipher_wrap.o: ../../../third_party/mbedtls/repo/library/cipher_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/cipher_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/cipher_wrap.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/cipher_wrap.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/cipher_wrap.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/constant_time.o: ../../../third_party/mbedtls/repo/library/constant_time.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/constant_time.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/constant_time.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/constant_time.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/constant_time.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ctr_drbg.o: ../../../third_party/mbedtls/repo/library/ctr_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/ctr_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/ctr_drbg.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ctr_drbg.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ctr_drbg.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecdh.o: ../../../third_party/mbedtls/repo/library/ecdh.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/ecdh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/ecdh.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecdh.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecdh.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecdsa.o: ../../../third_party/mbedtls/repo/library/ecdsa.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/ecdsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/ecdsa.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecdsa.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecdsa.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecp.o: ../../../third_party/mbedtls/repo/library/ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/ecp.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecp.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecp.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecp_curves.o: ../../../third_party/mbedtls/repo/library/ecp_curves.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/ecp_curves.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/ecp_curves.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecp_curves.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/ecp_curves.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/entropy.o: ../../../third_party/mbedtls/repo/library/entropy.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/entropy.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/entropy.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/entropy.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/entropy.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/hkdf.o: ../../../third_party/mbedtls/repo/library/hkdf.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/hkdf.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/hkdf.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/hkdf.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/hkdf.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/hmac_drbg.o: ../../../third_party/mbedtls/repo/library/hmac_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/hmac_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/hmac_drbg.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/hmac_drbg.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/hmac_drbg.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/md.o: ../../../third_party/mbedtls/repo/library/md.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/md.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/md.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/md.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/md.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/pem.o: ../../../third_party/mbedtls/repo/library/pem.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/pem.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/pem.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/pem.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/pem.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/pkcs5.o: ../../../third_party/mbedtls/repo/library/pkcs5.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/pkcs5.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/pkcs5.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/pkcs5.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/pkcs5.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/platform.o: ../../../third_party/mbedtls/repo/library/platform.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/platform.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/platform.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/platform.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/platform.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/sha256.o: ../../../third_party/mbedtls/repo/library/sha256.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/sha256.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/sha256.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/sha256.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/sha256.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/sha512.o: ../../../third_party/mbedtls/repo/library/sha512.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/sha512.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/sha512.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/sha512.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/sha512.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/x509.o: ../../../third_party/mbedtls/repo/library/x509.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/x509.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/x509.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/x509.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/x509.o

$(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/x509_create.o: ../../../third_party/mbedtls/repo/library/x509_create.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/mbedtls/repo/library/x509_create.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/mbedtls/repo/library/x509_create.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/x509_create.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/mbedtls/repo/library/x509_create.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dh.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/ecc_dsa.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/error.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/oid.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pk_wrap.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkparse.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/pkwrite.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/platform_util.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509_crt.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.o: ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/mbedtls/tinycrypt/src/x509write_csr.o

$(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.o: ../../../third_party/silabs/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../../third_party/silabs/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../../third_party/silabs/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.c
CDEPS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.d
OBJS += $(OUTPUT_DIR)/project/_/_/_/third_party/silabs/matter_support/matter/si91x/siwx917/BRD4338A/support/src/startup_common_RS1xxxx.o

$(OUTPUT_DIR)/project/_/_/generator/app.o: ../../generator/app.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/app.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/app.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/app.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/app.o

$(OUTPUT_DIR)/project/_/_/generator/main.o: ../../generator/main.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/main.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/main.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/main.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/main.o

$(OUTPUT_DIR)/project/_/_/generator/si917.o: ../../generator/si917.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/si917.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/si917.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/si917.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/si917.o

# Automatically-generated Simplicity Studio Metadata
# Please do not edit or delete these lines!
# SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA