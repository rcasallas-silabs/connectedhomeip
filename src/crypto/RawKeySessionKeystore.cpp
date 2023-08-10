/*
 *    Copyright (c) 2023 Project CHIP Authors
 *    All rights reserved.
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

#include <crypto/RawKeySessionKeystore.h>

#include <lib/support/BufferReader.h>

#pragma GCC optimize("Og")

namespace chip {
namespace Crypto {

using HKDF_sha_crypto = HKDF_sha;

CHIP_ERROR RawKeySessionKeystore::CreateKey(const Aes128KeyByteArray & keyMaterial, Aes128KeyHandle & key)
{
    Progress::Debug("◇ RawKeySessionKeystore::CreateKey");
    // volatile unsigned e = 0;
    // Progress::Debug("◇ RawKeySessionKeystore::CreateKey, err:%u", e);
    // memcpy(key.AsMutable<Aes128KeyByteArray>(), keyMaterial, sizeof(Aes128KeyByteArray));
    // return CHIP_NO_ERROR;
    return CHIP_ERROR_ACCESS_DENIED;
}

CHIP_ERROR RawKeySessionKeystore::DeriveKey(const P256ECDHDerivedSecret & secret, const ByteSpan & salt, const ByteSpan & info,
                                            Aes128KeyHandle & key)
{
    HKDF_sha_crypto hkdf;
    CHIP_ERROR err = hkdf.HKDF_SHA256(secret.ConstBytes(), secret.Length(), salt.data(), salt.size(), info.data(), info.size(),
                            key.AsMutable<Aes128KeyByteArray>(), sizeof(Aes128KeyByteArray));

    auto k = key.As<Aes128KeyByteArray>();
    Progress::Debug("◇ RawKeySessionKeystore::DeriveKey, key[%02x %02x]", k[0], k[1]);
    return err;
}

CHIP_ERROR RawKeySessionKeystore::DeriveSessionKeys(const ByteSpan & secret, const ByteSpan & salt, const ByteSpan & info,
                                                    Aes128KeyHandle & i2rKey, Aes128KeyHandle & r2iKey,
                                                    AttestationChallenge & attestationChallenge)
{
    HKDF_sha_crypto hkdf;
    uint8_t keyMaterial[2 * sizeof(Aes128KeyByteArray) + AttestationChallenge::Capacity()];

    ReturnErrorOnFailure(hkdf.HKDF_SHA256(secret.data(), secret.size(), salt.data(), salt.size(), info.data(), info.size(),
                                          keyMaterial, sizeof(keyMaterial)));

    Encoding::LittleEndian::Reader reader(keyMaterial, sizeof(keyMaterial));

    CHIP_ERROR err = reader.ReadBytes(i2rKey.AsMutable<Aes128KeyByteArray>(), sizeof(Aes128KeyByteArray))
        .ReadBytes(r2iKey.AsMutable<Aes128KeyByteArray>(), sizeof(Aes128KeyByteArray))
        .ReadBytes(attestationChallenge.Bytes(), AttestationChallenge::Capacity())
        .StatusCode();


    auto i2r = i2rKey.As<Aes128KeyByteArray>();
    auto r2i = r2iKey.As<Aes128KeyByteArray>();
    Progress::Debug("◇ RawKeySessionKeystore::DeriveSessionKeys(%u), I2R[%02x %02x], R2I[%02x %02x]",
        sizeof(Aes128KeyByteArray), i2r[0], i2r[1], r2i[0], r2i[1]);

    return err;
}

void RawKeySessionKeystore::DestroyKey(Aes128KeyHandle & key)
{
    Progress::Debug("◇ RawKeySessionKeystore::DestroyKey");
    ClearSecretData(key.AsMutable<Aes128KeyByteArray>());
}

} // namespace Crypto
} // namespace chip
