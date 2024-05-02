####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH ?= /git/gsdk
UNAME:=$(shell $(POSIX_TOOL_PATH)uname -s | $(POSIX_TOOL_PATH)sed -e 's/^\(CYGWIN\).*/\1/' | $(POSIX_TOOL_PATH)sed -e 's/^\(MINGW\).*/\1/')
ifeq ($(UNAME),MINGW)
# Translate "C:/super" into "/C/super" for MinGW make.
SDK_PATH := /$(shell $(POSIX_TOOL_PATH)echo $(BASE_SDK_PATH) | sed s/://)
endif
SDK_PATH ?= $(BASE_SDK_PATH)
COPIED_SDK_PATH ?= gecko_sdk_4.4.2

# This uses the explicit build rules below
PROJECT_SOURCE_FILES =

C_SOURCE_FILES   += $(filter %.c, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cpp, $(PROJECT_SOURCE_FILES))
CXX_SOURCE_FILES += $(filter %.cc, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.s, $(PROJECT_SOURCE_FILES))
ASM_SOURCE_FILES += $(filter %.S, $(PROJECT_SOURCE_FILES))
LIB_FILES        += $(filter %.a, $(PROJECT_SOURCE_FILES))

C_DEFS += \
 '-DCHIP_CONFIG_SHA256_CONTEXT_SIZE=256' \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DOTA_ENCRYPTION_ENABLE=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=0' \
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
 '-DEFR32MG24A010F1024IM48=1' \
 '-DSL_APP_PROPERTIES=1' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DMBEDTLS_CONFIG_FILE=<sl_mbedtls_config.h>' \
 '-DMBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

ASM_DEFS += \
 '-DCHIP_CONFIG_SHA256_CONTEXT_SIZE=256' \
 '-DCHIP_SYSTEM_CONFIG_USE_SOCKETS=1' \
 '-DOTA_ENCRYPTION_ENABLE=1' \
 '-DSILABS_PROVISION_PROTOCOL_V1=0' \
 '-DSL_PROVISION_CHANNEL_ENABLED=1' \
 '-DEFR32MG24A010F1024IM48=1' \
 '-DSL_APP_PROPERTIES=1' \
 '-DSL_COMPONENT_CATALOG_PRESENT=1' \
 '-DMBEDTLS_CONFIG_FILE=<sl_mbedtls_config.h>' \
 '-DMBEDTLS_PSA_CRYPTO_CONFIG_FILE=<psa_crypto_config.h>' \
 '-DRTT_USE_ASM=0' \
 '-DSEGGER_RTT_SECTION="SEGGER_RTT"'

INCLUDES += \
 -Iconfig \
 -Iautogen \
 -I../../generator \
 -I$(SDK_PATH)/../../../examples \
 -I$(SDK_PATH)/../../../examples/platform/silabs \
 -I$(SDK_PATH)/../../../src \
 -I$(SDK_PATH)/../../../src/include \
 -I$(SDK_PATH)/../../../zzz_generated/app-common \
 -I$(SDK_PATH)/../../nlassert/repo/include \
 -I$(SDK_PATH)/../../nlio/repo/include \
 -I$(SDK_PATH)/platform/bootloader \
 -I$(SDK_PATH)/protocol/bluetooth/config \
 -I$(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Include \
 -I$(SDK_PATH)/platform/CMSIS/Core/Include \
 -I$(SDK_PATH)/platform/service/device_init/inc \
 -I$(SDK_PATH)/platform/emdrv/common/inc \
 -I$(SDK_PATH)/platform/emlib/inc \
 -I$(SDK_PATH)/platform/common/inc \
 -I$(SDK_PATH)/platform/service/iostream/inc \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/config/preset \
 -I$(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/inc \
 -I$(SDK_PATH)/util/third_party/mbedtls/include \
 -I$(SDK_PATH)/util/third_party/mbedtls/library \
 -I$(SDK_PATH)/platform/emdrv/nvm3/inc \
 -I$(SDK_PATH)/platform/security/sl_component/sl_psa_driver/inc \
 -I$(SDK_PATH)/platform/security/sl_component/se_manager/inc \
 -I$(SDK_PATH)/platform/security/sl_component/se_manager/src \
 -I$(SDK_PATH)/util/third_party/segger/systemview/SEGGER \
 -I$(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager \
 -I$(SDK_PATH)/platform/common/toolchain/inc \
 -I$(SDK_PATH)/platform/service/system/inc

GROUP_START =-Wl,--start-group
GROUP_END =-Wl,--end-group

PROJECT_LIBS = \
 -lstdc++ \
 -lgcc \
 -lc \
 -lm \
 -lnosys \
 $(SDK_PATH)/platform/emdrv/nvm3/lib/libnvm3_CM33_gcc.a

LIBS += $(GROUP_START) $(PROJECT_LIBS) $(GROUP_END)

LIB_FILES += $(filter %.a, $(PROJECT_LIBS))

C_FLAGS += \
 -mcpu=cortex-m33 \
 -mthumb \
 -mfpu=fpv5-sp-d16 \
 -mfloat-abi=hard \
 -std=c99 \
 -Wall \
 -Wextra \
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -imacros sl_gcc_preinclude.h \
 -Wno-unused-parameter \
 -mcmse \
 --specs=nano.specs \
 -g

CXX_FLAGS += \
 -mcpu=cortex-m33 \
 -mthumb \
 -mfpu=fpv5-sp-d16 \
 -mfloat-abi=hard \
 -std=c++17 \
 -fno-rtti \
 -fno-exceptions \
 -Wall \
 -Wextra \
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -imacros sl_gcc_preinclude.h \
 -Wno-unused-parameter \
 -mcmse \
 --specs=nano.specs \
 -g

ASM_FLAGS += \
 -mcpu=cortex-m33 \
 -mthumb \
 -mfpu=fpv5-sp-d16 \
 -mfloat-abi=hard \
 -imacros sl_gcc_preinclude.h \
 -x assembler-with-cpp

LD_FLAGS += \
 -mcpu=cortex-m33 \
 -mthumb \
 -mfpu=fpv5-sp-d16 \
 -mfloat-abi=hard \
 -T"autogen/linkerfile.ld" \
 --specs=nano.specs \
 -Xlinker -Map=$(OUTPUT_DIR)/$(PROJECTNAME).map \
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
$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyPSA.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyPSA.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyPSA.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/AttestationKeyPSA.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyPSA.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/AttestationKeyPSA.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionChannelRTT.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionChannelRTT.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionEncoder.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionEncoder.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionEncoder.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionManager.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionManager.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionManager.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionManager.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionManager.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionManager.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV1.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV1.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionProtocolV2.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionProtocolV2.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorage.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorage.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorage.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorage.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorage.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageCustom.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageCustom.o

$(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o: $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../examples/platform/silabs/provision/ProvisionStorageDefault.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/examples/platform/silabs/provision/ProvisionStorageDefault.o

$(OUTPUT_DIR)/sdk/_/_/_/src/crypto/CHIPCryptoPALPSA.o: $(SDK_PATH)/../../../src/crypto/CHIPCryptoPALPSA.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/crypto/CHIPCryptoPALPSA.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/crypto/CHIPCryptoPALPSA.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/crypto/CHIPCryptoPALPSA.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/crypto/CHIPCryptoPALPSA.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/Base64.o: $(SDK_PATH)/../../../src/lib/support/Base64.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/Base64.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/Base64.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/Base64.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/Base64.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/BytesToHex.o: $(SDK_PATH)/../../../src/lib/support/BytesToHex.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/BytesToHex.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/BytesToHex.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/BytesToHex.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/BytesToHex.o

$(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/logging/TextOnlyLogging.o: $(SDK_PATH)/../../../src/lib/support/logging/TextOnlyLogging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/lib/support/logging/TextOnlyLogging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/lib/support/logging/TextOnlyLogging.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/logging/TextOnlyLogging.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/lib/support/logging/TextOnlyLogging.o

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/Logging.o: $(SDK_PATH)/../../../src/platform/silabs/Logging.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/Logging.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/Logging.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/Logging.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/Logging.o

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.o: $(SDK_PATH)/../../../src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/multi-ota/OtaTlvEncryptionKey.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/multi-ota/OtaTlvEncryptionKey.o

$(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.o: $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/platform/silabs/SilabsConfig.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/platform/silabs/SilabsConfig.o

$(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.o: $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ $(SDK_PATH)/../../../src/setup_payload/Base38Encode.cpp
CXXDEPS += $(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.d
OBJS += $(OUTPUT_DIR)/sdk/_/_/_/src/setup_payload/Base38Encode.o

$(OUTPUT_DIR)/sdk/platform/bootloader/app_properties/app_properties.o: $(SDK_PATH)/platform/bootloader/app_properties/app_properties.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/bootloader/app_properties/app_properties.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/bootloader/app_properties/app_properties.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/bootloader/app_properties/app_properties.d
OBJS += $(OUTPUT_DIR)/sdk/platform/bootloader/app_properties/app_properties.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_assert.o: $(SDK_PATH)/platform/common/src/sl_assert.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_assert.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_assert.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_assert.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_assert.o

$(OUTPUT_DIR)/sdk/platform/common/src/sl_syscalls.o: $(SDK_PATH)/platform/common/src/sl_syscalls.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/src/sl_syscalls.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/src/sl_syscalls.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_syscalls.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/src/sl_syscalls.o

$(OUTPUT_DIR)/sdk/platform/common/toolchain/src/sl_memory.o: $(SDK_PATH)/platform/common/toolchain/src/sl_memory.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/common/toolchain/src/sl_memory.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/common/toolchain/src/sl_memory.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/common/toolchain/src/sl_memory.d
OBJS += $(OUTPUT_DIR)/sdk/platform/common/toolchain/src/sl_memory.o

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/startup_efr32mg24.o

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG24/Source/system_efr32mg24.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_hal_flash.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_hal_flash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_hal_flash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_hal_flash.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_hal_flash.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_hal_flash.o

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_lock.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_lock.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_cmu.o: $(SDK_PATH)/platform/emlib/src/em_cmu.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_cmu.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_cmu.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_cmu.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_cmu.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o: $(SDK_PATH)/platform/emlib/src/em_core.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_core.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_core.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_core.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_emu.o: $(SDK_PATH)/platform/emlib/src/em_emu.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_emu.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_emu.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_emu.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_emu.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_gpio.o: $(SDK_PATH)/platform/emlib/src/em_gpio.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_gpio.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_gpio.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_gpio.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_gpio.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_msc.o: $(SDK_PATH)/platform/emlib/src/em_msc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_msc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_msc.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_msc.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_msc.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_se.o: $(SDK_PATH)/platform/emlib/src/em_se.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_se.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_se.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_se.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_se.o

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.o: $(SDK_PATH)/platform/emlib/src/em_system.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_system.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_system.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_attestation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_entropy.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_hash.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_hash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_hash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_hash.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_hash.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_hash.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_derivation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_key_handling.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_signature.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_signature.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_signature.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_signature.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_signature.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_signature.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_util.o: $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_util.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/se_manager/src/sl_se_manager_util.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_util.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/se_manager/src/sl_se_manager_util.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_ecdsa_ecdh.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/se_aes.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/se_aes.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/se_aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/se_aes.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/se_aes.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/se_aes.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_entropy_hardware.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_mbedtls.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sl_psa_crypto.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/sli_psa_crypto.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_common.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_driver_init.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_psa_trng.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_aead.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_builtin_keys.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_derivation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_key_management.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_mac.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_driver_signature.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_aead.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_driver_mac.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_opaque_key_derivation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_aead.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_hash.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_driver_mac.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_transparent_key_derivation.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.o

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s2.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s2.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s2.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s2.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s2.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s2.o

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s2.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s2.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s2.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s2.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s2.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s2.o

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

$(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_init.o: $(SDK_PATH)/platform/service/system/src/sl_system_init.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/system/src/sl_system_init.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/system/src/sl_system_init.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_init.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_init.o

$(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_process_action.o: $(SDK_PATH)/platform/service/system/src/sl_system_process_action.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/system/src/sl_system_process_action.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/system/src/sl_system_process_action.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_process_action.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/system/src/sl_system_process_action.o

$(OUTPUT_DIR)/sdk/util/silicon_labs/silabs_core/memory_manager/sl_malloc.o: $(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager/sl_malloc.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager/sl_malloc.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/silicon_labs/silabs_core/memory_manager/sl_malloc.c
CDEPS += $(OUTPUT_DIR)/sdk/util/silicon_labs/silabs_core/memory_manager/sl_malloc.d
OBJS += $(OUTPUT_DIR)/sdk/util/silicon_labs/silabs_core/memory_manager/sl_malloc.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/aes.o: $(SDK_PATH)/util/third_party/mbedtls/library/aes.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/aes.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/aes.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/aes.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1parse.o: $(SDK_PATH)/util/third_party/mbedtls/library/asn1parse.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/asn1parse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/asn1parse.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1parse.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1parse.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1write.o: $(SDK_PATH)/util/third_party/mbedtls/library/asn1write.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/asn1write.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/asn1write.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1write.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/asn1write.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/base64.o: $(SDK_PATH)/util/third_party/mbedtls/library/base64.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/base64.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/base64.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/base64.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/base64.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum.o: $(SDK_PATH)/util/third_party/mbedtls/library/bignum.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/bignum.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/bignum.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_core.o: $(SDK_PATH)/util/third_party/mbedtls/library/bignum_core.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/bignum_core.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/bignum_core.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_core.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_core.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod.o: $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod_raw.o: $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod_raw.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod_raw.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/bignum_mod_raw.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod_raw.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/bignum_mod_raw.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher.o: $(SDK_PATH)/util/third_party/mbedtls/library/cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher_wrap.o: $(SDK_PATH)/util/third_party/mbedtls/library/cipher_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/cipher_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/cipher_wrap.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher_wrap.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/cipher_wrap.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/constant_time.o: $(SDK_PATH)/util/third_party/mbedtls/library/constant_time.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/constant_time.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/constant_time.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/constant_time.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/constant_time.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ctr_drbg.o: $(SDK_PATH)/util/third_party/mbedtls/library/ctr_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ctr_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ctr_drbg.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ctr_drbg.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ctr_drbg.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecdsa.o: $(SDK_PATH)/util/third_party/mbedtls/library/ecdsa.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ecdsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ecdsa.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecdsa.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecdsa.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp.o: $(SDK_PATH)/util/third_party/mbedtls/library/ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ecp.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves.o: $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves_new.o: $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves_new.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves_new.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/ecp_curves_new.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves_new.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/ecp_curves_new.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy.o: $(SDK_PATH)/util/third_party/mbedtls/library/entropy.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/entropy.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/entropy.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy_poll.o: $(SDK_PATH)/util/third_party/mbedtls/library/entropy_poll.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/entropy_poll.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/entropy_poll.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy_poll.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/entropy_poll.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/hmac_drbg.o: $(SDK_PATH)/util/third_party/mbedtls/library/hmac_drbg.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/hmac_drbg.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/hmac_drbg.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/hmac_drbg.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/hmac_drbg.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/md.o: $(SDK_PATH)/util/third_party/mbedtls/library/md.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/md.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/md.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/md.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/md.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/oid.o: $(SDK_PATH)/util/third_party/mbedtls/library/oid.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/oid.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/oid.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/oid.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/oid.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pem.o: $(SDK_PATH)/util/third_party/mbedtls/library/pem.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pem.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pem.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pem.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pem.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk.o: $(SDK_PATH)/util/third_party/mbedtls/library/pk.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pk.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pk.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk_wrap.o: $(SDK_PATH)/util/third_party/mbedtls/library/pk_wrap.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pk_wrap.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pk_wrap.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk_wrap.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pk_wrap.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkcs5.o: $(SDK_PATH)/util/third_party/mbedtls/library/pkcs5.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pkcs5.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pkcs5.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkcs5.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkcs5.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkparse.o: $(SDK_PATH)/util/third_party/mbedtls/library/pkparse.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pkparse.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pkparse.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkparse.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkparse.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkwrite.o: $(SDK_PATH)/util/third_party/mbedtls/library/pkwrite.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/pkwrite.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/pkwrite.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkwrite.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/pkwrite.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform.o: $(SDK_PATH)/util/third_party/mbedtls/library/platform.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/platform.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/platform.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform_util.o: $(SDK_PATH)/util/third_party/mbedtls/library/platform_util.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/platform_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/platform_util.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform_util.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/platform_util.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_aead.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_aead.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_aead.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_cipher.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_cipher.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_client.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_client.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_client.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_client.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_client.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_client.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_driver_wrappers_no_static.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ecp.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ecp.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ecp.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ecp.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ffdh.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ffdh.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ffdh.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_ffdh.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ffdh.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_ffdh.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_hash.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_hash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_hash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_hash.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_hash.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_hash.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_mac.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_mac.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_mac.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_pake.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_pake.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_pake.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_pake.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_pake.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_pake.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_rsa.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_rsa.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_rsa.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_rsa.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_rsa.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_rsa.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_se.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_se.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_se.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_se.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_se.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_se.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_slot_management.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_slot_management.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_slot_management.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_slot_management.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_slot_management.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_slot_management.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_storage.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_storage.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_storage.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_crypto_storage.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_storage.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_crypto_storage.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_util.o: $(SDK_PATH)/util/third_party/mbedtls/library/psa_util.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/psa_util.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/psa_util.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_util.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/psa_util.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha256.o: $(SDK_PATH)/util/third_party/mbedtls/library/sha256.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/sha256.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/sha256.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha256.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/sha256.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/threading.o: $(SDK_PATH)/util/third_party/mbedtls/library/threading.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/threading.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/threading.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/threading.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/threading.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_create.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509_create.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509_create.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509_create.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_create.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_create.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crl.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509_crl.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509_crl.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509_crl.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crl.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crl.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crt.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509_crt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509_crt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509_crt.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crt.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_crt.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_csr.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509_csr.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509_csr.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509_csr.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_csr.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509_csr.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509write.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509write.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509write.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_crt.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509write_crt.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509write_crt.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509write_crt.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_crt.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_crt.o

$(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_csr.o: $(SDK_PATH)/util/third_party/mbedtls/library/x509write_csr.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/mbedtls/library/x509write_csr.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/mbedtls/library/x509write_csr.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_csr.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/mbedtls/library/x509write_csr.o

$(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.o: $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.c
CDEPS += $(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.d
OBJS += $(OUTPUT_DIR)/sdk/util/third_party/segger/systemview/SEGGER/SEGGER_RTT.o

$(OUTPUT_DIR)/project/_/_/generator/app.o: ../../generator/app.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/app.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/app.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/app.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/app.o

$(OUTPUT_DIR)/project/_/_/generator/efr32.o: ../../generator/efr32.c
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/efr32.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ ../../generator/efr32.c
CDEPS += $(OUTPUT_DIR)/project/_/_/generator/efr32.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/efr32.o

$(OUTPUT_DIR)/project/_/_/generator/main.o: ../../generator/main.cpp
	@$(POSIX_TOOL_PATH)echo 'Building ../../generator/main.cpp'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CXX) $(CXXFLAGS) -c -o $@ ../../generator/main.cpp
CXXDEPS += $(OUTPUT_DIR)/project/_/_/generator/main.d
OBJS += $(OUTPUT_DIR)/project/_/_/generator/main.o

$(OUTPUT_DIR)/project/autogen/sl_device_init_clocks.o: autogen/sl_device_init_clocks.c
	@$(POSIX_TOOL_PATH)echo 'Building autogen/sl_device_init_clocks.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ autogen/sl_device_init_clocks.c
CDEPS += $(OUTPUT_DIR)/project/autogen/sl_device_init_clocks.d
OBJS += $(OUTPUT_DIR)/project/autogen/sl_device_init_clocks.o

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

# Automatically-generated Simplicity Studio Metadata
# Please do not edit or delete these lines!
# SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA