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
# SIMPLICITY_STUDIO_METADATA=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=END_SIMPLICITY_STUDIO_METADATA
# END OF METADATA