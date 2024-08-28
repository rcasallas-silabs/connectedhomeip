/*
 *
 *    Copyright (c) 2021 Project CHIP Authors
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

#include <credentials/GroupDataProvider.h>
#include <crypto/SessionKeystore.h>
#include <lib/core/CHIPPersistentStorageDelegate.h>
#include <lib/core/DataModelTypes.h>
#include <lib/support/Pool.h>

namespace chip {
namespace Credentials {

class GroupDataProviderBase : public GroupDataProvider
{
public:
    static constexpr size_t kIteratorsMax = CHIP_CONFIG_MAX_GROUP_CONCURRENT_ITERATORS;

    GroupDataProviderBase() = default;
    GroupDataProviderBase(uint16_t maxGroupsPerFabric, uint16_t maxGroupKeysPerFabric) :
        GroupDataProvider(maxGroupsPerFabric, maxGroupKeysPerFabric)
    {}

    /**
     * @brief Set the storage implementation used for non-volatile storage of configuration data.
     *        This method MUST be called before Init().
     *
     * @param storage Pointer to storage instance to set. Cannot be nullptr, will assert.
     */
    void SetStorageDelegate(PersistentStorageDelegate * storage)
    {
        VerifyOrDie(storage != nullptr);
        mStorage = storage;
    }

    void SetSessionKeystore(Crypto::SessionKeystore * keystore) { mSessionKeystore = keystore; }
    Crypto::SessionKeystore * GetSessionKeystore() const { return mSessionKeystore; }
   
protected:

    bool IsInitialized() { return (mStorage != nullptr); }
    void DebugFabric(FabricIndex fabric) override;

    class GroupKeyContext : public Crypto::SymmetricKeyContext
    {
    public:
        GroupKeyContext(GroupDataProviderBase & provider) : mProvider(provider) {}

        GroupKeyContext(GroupDataProviderBase & provider, const Crypto::Symmetric128BitsKeyByteArray & encryptionKey, uint16_t hash,
                        const Crypto::Symmetric128BitsKeyByteArray & privacyKey) :
            mProvider(provider)

        {
            Initialize(encryptionKey, hash, privacyKey);
        }

        void Initialize(const Crypto::Symmetric128BitsKeyByteArray & encryptionKey, uint16_t hash,
                        const Crypto::Symmetric128BitsKeyByteArray & privacyKey)
        {
            ReleaseKeys();
            mKeyHash = hash;
            // TODO: Load group keys to the session keystore upon loading from persistent storage
            //
            // Group keys should be transformed into a key handle as soon as possible or even
            // the key storage should be taken over by SessionKeystore interface, but this looks
            // like more work, so let's use the transitional code below for now.

            Crypto::SessionKeystore * keystore = mProvider.GetSessionKeystore();
            keystore->CreateKey(encryptionKey, mEncryptionKey);
            keystore->CreateKey(privacyKey, mPrivacyKey);
        }

        void ReleaseKeys()
        {
            Crypto::SessionKeystore * keystore = mProvider.GetSessionKeystore();
            keystore->DestroyKey(mEncryptionKey);
            keystore->DestroyKey(mPrivacyKey);
        }

        uint16_t GetKeyHash() override { return mKeyHash; }

        CHIP_ERROR MessageEncrypt(const ByteSpan & plaintext, const ByteSpan & aad, const ByteSpan & nonce, MutableByteSpan & mic,
                                  MutableByteSpan & ciphertext) const override;
        CHIP_ERROR MessageDecrypt(const ByteSpan & ciphertext, const ByteSpan & aad, const ByteSpan & nonce, const ByteSpan & mic,
                                  MutableByteSpan & plaintext) const override;
        CHIP_ERROR PrivacyEncrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const override;
        CHIP_ERROR PrivacyDecrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const override;

        void Release() override;

    protected:
        GroupDataProviderBase & mProvider;
        uint16_t mKeyHash = 0;
        Crypto::Aes128KeyHandle mEncryptionKey;
        Crypto::Aes128KeyHandle mPrivacyKey;
    };

    PersistentStorageDelegate * mStorage       = nullptr;
    Crypto::SessionKeystore * mSessionKeystore = nullptr;
    ObjectPool<GroupKeyContext, kIteratorsMax> mGroupKeyContexPool;
};

} // namespace Credentials
} // namespace chip
