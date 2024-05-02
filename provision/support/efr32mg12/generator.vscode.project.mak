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
 '-DEFR32MG12P232F512GM68=1' \
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
 '-DEFR32MG12P232F512GM68=1' \
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
 -I$(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Include \
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
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -imacros sl_gcc_preinclude.h \
 -Wno-unused-parameter \
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
 -Os \
 -fdata-sections \
 -ffunction-sections \
 -fomit-frame-pointer \
 -imacros sl_gcc_preinclude.h \
 -Wno-unused-parameter \
 --specs=nano.specs \
 -g

ASM_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
 -imacros sl_gcc_preinclude.h \
 -x assembler-with-cpp

LD_FLAGS += \
 -mcpu=cortex-m4 \
 -mthumb \
 -mfpu=fpv4-sp-d16 \
 -mfloat-abi=softfp \
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

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/startup_efr32mg12p.o

$(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.o: $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.d
OBJS += $(OUTPUT_DIR)/sdk/platform/Device/SiliconLabs/EFR32MG12P/Source/system_efr32mg12p.o

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

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_crypto.o: $(SDK_PATH)/platform/emlib/src/em_crypto.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_crypto.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_crypto.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_crypto.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_crypto.o

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

$(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.o: $(SDK_PATH)/platform/emlib/src/em_system.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/emlib/src/em_system.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/emlib/src/em_system.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.d
OBJS += $(OUTPUT_DIR)/sdk/platform/emlib/src/em_system.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_aes.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/crypto_ecp.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/error.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/error.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.o: $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_mbedtls_support/src/mbedtls_sha.o

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

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/crypto_management.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/crypto_management.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/crypto_management.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/crypto_management.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/crypto_management.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/crypto_management.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sl_psa_its_nvm3.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_driver_trng.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_aead.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_cipher.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_hash.o

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_crypto_transparent_driver_mac.o

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

$(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.o: $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.d
OBJS += $(OUTPUT_DIR)/sdk/platform/security/sl_component/sl_psa_driver/src/sli_se_version_dependencies.o

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s1.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s1.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s1.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_dcdc_s1.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s1.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_dcdc_s1.o

$(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s1.o: $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s1.c
	@$(POSIX_TOOL_PATH)echo 'Building $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s1.c'
	@$(POSIX_TOOL_PATH)mkdir -p $(@D)
	$(ECHO)$(CC) $(CFLAGS) -c -o $@ $(SDK_PATH)/platform/service/device_init/src/sl_device_init_emu_s1.c
CDEPS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s1.d
OBJS += $(OUTPUT_DIR)/sdk/platform/service/device_init/src/sl_device_init_emu_s1.o

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