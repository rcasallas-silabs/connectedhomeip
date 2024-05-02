####################################################################
# Automatically-generated file. Do not edit!                       #
# Makefile Version 15                                              #
####################################################################

BASE_SDK_PATH = /Volumes/Resources/git/matter/stash/third_party/silabs/gecko_sdk
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

$(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o: $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emdrv/nvm3/src/nvm3_default_common_linker.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emdrv/nvm3/src/nvm3_default_common_linker.o

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

# Automatically-generated Simplicity Studio Metadata
# Please do not edit or delete these lines!
# SIMPLICITY_STUDIO_METADATA=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END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA