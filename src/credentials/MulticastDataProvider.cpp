/**
 *
 *    Copyright (c) 2020 Project CHIP Authors
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

#include "MulticastDataProvider.h"
#include <lib/support/PersistentArray.h>
#include <lib/support/DefaultStorageKeyAllocator.h>
#include <lib/support/CodeUtils.h>
#include <crypto/CHIPCryptoPAL.h>
#include <lib/support/logging/CHIPLogging.h>

using namespace chip;

namespace {
    chip::Multicast::DataProvider sInstance;
}
namespace chip {
namespace Multicast {

constexpr size_t kPersistentBufferMax = 256;

static constexpr TLV::Tag TargetIdTag() { return TLV::ContextTag(1); }
static constexpr TLV::Tag EndpointCountTag() { return TLV::ContextTag(2); }
static constexpr TLV::Tag EndpointListTag() { return TLV::ContextTag(3); }
static constexpr TLV::Tag EndpointEntryTag() { return TLV::ContextTag(4); }
static constexpr TLV::Tag TargetEncrKeyTag() { return TLV::ContextTag(5); }
static constexpr TLV::Tag TargetPrivKeyTag() { return TLV::ContextTag(6); }


struct TargetList: public PersistentArray<CHIP_CONFIG_MAX_FABRICS, kPersistentBufferMax, Target>
{
    TargetList(FabricIndex fabric, PersistentStorageDelegate * storage):
        PersistentArray<CHIP_CONFIG_MAX_FABRICS, kPersistentBufferMax, Target>(storage),
        mFabric(fabric) {}

    CHIP_ERROR UpdateKey(StorageKeyName & key) override
    {
        VerifyOrReturnError(kUndefinedFabricIndex != mFabric, CHIP_ERROR_INVALID_FABRIC_INDEX);
        key = DefaultStorageKeyAllocator::MulticastTargets(mFabric);
        return CHIP_NO_ERROR;
    }    
    
    void ClearEntry(Target & entry) override
    {
        entry.mTargetId = 0;
        entry.mEndpointCount = 0;
        memset(entry.mEndpoints, 0x00, sizeof(entry.mEndpoints));
    }

    CHIP_ERROR Copy(Target & dest, const Target & src) const override
    {
        dest.mTargetId = src.mTargetId;
        dest.mEndpointCount = src.mEndpointCount;
        memset(dest.mEndpoints, 0x00, sizeof(dest.mEndpoints));
        memcpy(dest.mEndpoints, src.mEndpoints, src.mEndpointCount * sizeof(EndpointId));
        memcpy(dest.mEncryptionKey.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(), src.mEncryptionKey.As<Crypto::Symmetric128BitsKeyByteArray>(), sizeof(Crypto::Symmetric128BitsKeyByteArray));
        memcpy(dest.mPrivacyKey.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(), src.mPrivacyKey.As<Crypto::Symmetric128BitsKeyByteArray>(), sizeof(Crypto::Symmetric128BitsKeyByteArray));
        return CHIP_NO_ERROR;
    }


    CHIP_ERROR Serialize(TLV::TLVWriter & writer, const Target & entry) const override
    {
        ReturnErrorOnFailure(writer.Put(TargetIdTag(), static_cast<uint16_t>(entry.mTargetId)));
        ReturnErrorOnFailure(writer.Put(EndpointCountTag(), static_cast<uint16_t>(entry.mEndpointCount)));
        {
            TLV::TLVType array, item;
            ReturnErrorOnFailure(writer.StartContainer(EndpointListTag(), TLV::kTLVType_Array, array));
            for(size_t i = 0; i < entry.mEndpointCount; ++i)
            {
                // Endpoint
                ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, item));
                ReturnErrorOnFailure(writer.Put(EndpointEntryTag(), entry.mEndpoints[i]));
                ReturnErrorOnFailure(writer.EndContainer(item));
            }
            ReturnErrorOnFailure(writer.EndContainer(array));    
        }
        // Encryption Key
        ByteSpan encrypt_key(entry.mEncryptionKey.As<Crypto::Symmetric128BitsKeyByteArray>());
        ReturnErrorOnFailure(writer.Put(TargetEncrKeyTag(), encrypt_key));
        // Privacy Key
        ByteSpan privacy_key(entry.mPrivacyKey.As<Crypto::Symmetric128BitsKeyByteArray>());
        ReturnErrorOnFailure(writer.Put(TargetPrivKeyTag(), privacy_key));
        return CHIP_NO_ERROR;
    }
    
    CHIP_ERROR Deserialize(TLV::TLVReader & reader, Target & entry) override
    {
        // Target Id
        ReturnErrorOnFailure(reader.Next(TargetIdTag()));
        ReturnErrorOnFailure(reader.Get(entry.mTargetId));
        // Endpoint Count
        ReturnErrorOnFailure(reader.Next(EndpointCountTag()));
        ReturnErrorOnFailure(reader.Get(entry.mEndpointCount));
        // Endpoints
        ReturnErrorOnFailure(reader.Next(EndpointListTag()));
        VerifyOrReturnError(TLV::kTLVType_Array == reader.GetType(), CHIP_ERROR_INTERNAL);
        {
            TLV::TLVType array, item;
            ReturnErrorOnFailure(reader.EnterContainer(array));
            for(size_t i = 0; i < entry.mEndpointCount; ++i)
            {
                // Endpoint
                ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
                VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);
                ReturnErrorOnFailure(reader.EnterContainer(item));
    
                ReturnErrorOnFailure(reader.Next(EndpointEntryTag()));
                ReturnErrorOnFailure(reader.Get(entry.mEndpoints[i]));
    
                ReturnErrorOnFailure(reader.ExitContainer(item));
            }
            ReturnErrorOnFailure(reader.ExitContainer(array));   
        }
        {
            ByteSpan buf;
            // Encryption Key
            ReturnErrorOnFailure(reader.Next(TargetEncrKeyTag()));
            ReturnErrorOnFailure(reader.Get(buf));
            memcpy(entry.mEncryptionKey.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(), buf.data(), sizeof(Crypto::Symmetric128BitsKeyByteArray));
            // Privacy Key
            ReturnErrorOnFailure(reader.Next(TargetPrivKeyTag()));
            ReturnErrorOnFailure(reader.Get(buf));
            memcpy(entry.mPrivacyKey.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(), buf.data(), sizeof(Crypto::Symmetric128BitsKeyByteArray));
        }

        return CHIP_NO_ERROR;
    }

    FabricIndex mFabric;
};


struct MulticastKeyContext: chip::Crypto::SymmetricKeyContext
{
    MulticastKeyContext(const Crypto::Aes128KeyHandle &encryption_key, const Crypto::Aes128KeyHandle &privacy_key)
    {
        memcpy(mEncryptionKey.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(), encryption_key.As<Crypto::Symmetric128BitsKeyByteArray>(), sizeof(Crypto::Symmetric128BitsKeyByteArray));
        memcpy(mPrivacyKey.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(), privacy_key.As<Crypto::Symmetric128BitsKeyByteArray>(), sizeof(Crypto::Symmetric128BitsKeyByteArray));
    }

    uint16_t GetKeyHash() override
    {
        return 0;
    }

    CHIP_ERROR MessageEncrypt(const ByteSpan & plaintext, const ByteSpan & aad, const ByteSpan & nonce,
                                    MutableByteSpan & mic, MutableByteSpan & ciphertext) const override
    {
        uint8_t * output = ciphertext.data();
        return Crypto::AES_CCM_encrypt(plaintext.data(), plaintext.size(), aad.data(), aad.size(), mEncryptionKey, nonce.data(),
                                       nonce.size(), output, mic.data(), mic.size());
    }

    CHIP_ERROR MessageDecrypt(const ByteSpan & ciphertext, const ByteSpan & aad, const ByteSpan & nonce,
                                        const ByteSpan & mic, MutableByteSpan & plaintext) const override
    {
        uint8_t * output = plaintext.data();
        return Crypto::AES_CCM_decrypt(ciphertext.data(), ciphertext.size(), aad.data(), aad.size(), mic.data(), mic.size(),
                                       mEncryptionKey, nonce.data(), nonce.size(), output);
    }

    CHIP_ERROR PrivacyEncrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const override
    {
        return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
    }

    CHIP_ERROR PrivacyDecrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const override
    {
        return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
    }

    void Release() override
    {
        // mKeystore->DestroyKey(mEncryptionKey);
        // mKeystore->DestroyKey(mPrivacyKey);
    }

private:
    // chip::Crypto::SessionKeystore *mKeystore = nullptr;
    // uint16_t mKeyHash = 0;
    Crypto::Aes128KeyHandle mEncryptionKey;
    Crypto::Aes128KeyHandle mPrivacyKey;

};

DataProvider &DataProvider::DataProvider::Instance()
{
    return sInstance;
}

CHIP_ERROR DataProvider::Initialize(PersistentStorageDelegate *storage, chip::Crypto::SessionKeystore *keystore)
{
   VerifyOrReturnError(storage != nullptr, CHIP_ERROR_INTERNAL);
   VerifyOrReturnError(keystore != nullptr, CHIP_ERROR_INTERNAL);
   mStorage = storage;
   mKeystore = keystore;
   return CHIP_NO_ERROR;
}

CHIP_ERROR DataProvider::SetTarget(const FabricInfo *fabric, const ByteSpan &key, Target &target)
{
    VerifyOrReturnError(mStorage != nullptr, CHIP_ERROR_INCORRECT_STATE);
    VerifyOrReturnError(mKeystore != nullptr, CHIP_ERROR_INCORRECT_STATE);

    uint8_t compressed_fabric_id_buffer[sizeof(uint64_t)];
    MutableByteSpan compressed_fabric_id(compressed_fabric_id_buffer);
    Crypto::GroupOperationalCredentials credentials;
    FabricIndex fabric_idx = fabric->GetFabricIndex();
    Crypto::Aes128KeyHandle encryption_key;
    Crypto::Aes128KeyHandle privacy_key;

    // Obtain compressed fabric Id
    ReturnErrorOnFailure(fabric->GetCompressedFabricIdBytes(compressed_fabric_id));

    // Generate credentials
    ReturnErrorOnFailure(Crypto::DeriveGroupOperationalCredentials(key, compressed_fabric_id, credentials));
    ByteSpan key1(credentials.encryption_key);
    ByteSpan key2(credentials.privacy_key);
    ChipLogProgress(Crypto, "~~~ ENCRYPTION(%u)", (unsigned)key1.size());
    ChipLogByteSpan(Crypto, key1);
    ChipLogProgress(Crypto, "~~~ PRIVACY(%u)", (unsigned)key2.size());
    ChipLogByteSpan(Crypto, key2);

    // Create keys
    ReturnErrorOnFailure(mKeystore->CreateKey(credentials.encryption_key, target.mEncryptionKey));
    ReturnErrorOnFailure(mKeystore->CreateKey(credentials.privacy_key, target.mPrivacyKey));

    chip::Multicast::TargetList list(fabric_idx, mStorage);
    return list.Add(target, true);
}

CHIP_ERROR DataProvider::GetTarget(FabricIndex fabric_idx, Target &target)
{
    chip::Multicast::TargetList list(fabric_idx, mStorage);
    size_t index = 0;
    ReturnErrorOnFailure(list.Find(target, index));
    return CHIP_NO_ERROR;
}

chip::Crypto::SymmetricKeyContext *DataProvider::CreateKeyContext(FabricIndex fabric, GroupId group_id)
{
    // Crypto::Symmetric128BitsKeyByteArray debug_key = {0xa0, 0xa1, 0xa2, 0xa3, 0xa4, 0xa5, 0xa6, 0xa7, 0xa8, 0xa9, 0xaa, 0xab, 0xac, 0xad, 0xae, 0xaf};
    Target target(group_id);
    size_t index = 0;
    chip::Multicast::TargetList list(fabric, mStorage);
    VerifyOrReturnValue(CHIP_NO_ERROR == list.Find(target, index), nullptr);
    return new MulticastKeyContext(target.mEncryptionKey, target.mPrivacyKey);
}


} // namespace chip
} // namespace Multicast
    