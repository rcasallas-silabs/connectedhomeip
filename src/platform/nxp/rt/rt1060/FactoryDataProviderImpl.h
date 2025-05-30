/*
 *
 *    Copyright (c) 2022-2024 Project CHIP Authors
 *    Copyright 2023-2024 NXP
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */
#pragma once

#include <platform/nxp/common/factory_data/legacy/FactoryDataProvider.h>

#define FACTORY_DATA_MAX_SIZE 4096

namespace chip {
namespace DeviceLayer {

/**
 * @brief This class provides Commissionable data and Device Attestation Credentials.
 *
 * This implementation allows to use the DCP RT1060 hardware module to load the Matter factory
 * dataset in RAM at the boot.
 *
 * Depending on how the dataset have been encrypted, specific AES hardware of software keys can be
 * used.
 *
 * Example of calls for loading the dataset using a software key:
 *
 * FactoryDataPrvdImpl().SetEncryptionMode(FactoryDataProvider::encrypt_ecb);
 * FactoryDataPrvdImpl().SetAesKey(&aes128TestKey[0], 128U);
 * FactoryDataPrvdImpl().Init();
 *
 * Example of calls for loading the dataset using a OTP key:
 *
 * FactoryDataPrvdImpl().SetEncryptionMode(FactoryDataProvider::encrypt_ecb);
 * FactoryDataPrvdImpl().SetKeySelected(KeySelect::);
 * FactoryDataPrvdImpl().Init();
 */

class FactoryDataProviderImpl : public FactoryDataProvider
{
public:
    static FactoryDataProviderImpl sInstance;

    CHIP_ERROR SearchForId(uint8_t searchedType, uint8_t * pBuf, size_t bufLength, uint16_t & length,
                           uint32_t * contentAddr = NULL);
    ~FactoryDataProviderImpl(){};

    CHIP_ERROR Init(void);
    CHIP_ERROR SignWithDacKey(const ByteSpan & digestToSign, MutableByteSpan & outSignBuffer);

    CHIP_ERROR SetKeyType(KeyType type);

private:
    enum KeySelectDcp
    {
        kDCP_UseSoftKey   = 0U,
        kDCP_OTPMKKeyLow  = 1U, /* Use [127:0] from snvs key as dcp key */
        kDCP_OTPMKKeyHigh = 2U, /* Use [255:128] from snvs key as dcp key */
        kDCP_OCOTPKeyLow  = 3U, /* Use [127:0] from ocotp key as dcp key */
        kDCP_OCOTPKeyHigh = 4U  /* Use [255:128] from ocotp key as dcp key */
    };
    uint8_t factoryDataRamBuffer[FACTORY_DATA_MAX_SIZE];
    KeySelectDcp selectedKey;
    bool dcpDriverIsInitialized;
    void SetDCP_OTPKeySelect(void);
    CHIP_ERROR ReadEncryptedData(uint8_t * desBuff, uint8_t * sourceAddr, uint16_t sizeToRead);
    CHIP_ERROR Hash256(const uint8_t * input, size_t inputSize, uint8_t * output, size_t * outputSize);
    CHIP_ERROR LoadKeypairFromRaw(ByteSpan privateKey, ByteSpan publicKey, Crypto::P256Keypair & keypair);
};

FactoryDataProvider & FactoryDataPrvdImpl();

} // namespace DeviceLayer
} // namespace chip
