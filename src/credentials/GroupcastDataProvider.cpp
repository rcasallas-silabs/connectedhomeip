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

#include "GroupcastDataProvider.h"
#include <crypto/CHIPCryptoPAL.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/DefaultStorageKeyAllocator.h>
#include <lib/support/PersistentArray.h>
#include <lib/support/logging/CHIPLogging.h>
#include <system/SystemClock.h>
#include <credentials/GroupDataProvider.h>

using namespace chip;

namespace chip {
namespace Groupcast {

constexpr size_t kPersistentBufferMax = 256;

struct Tags {
    static constexpr TLV::Tag GroupId() { return TLV::ContextTag(1); }
    static constexpr TLV::Tag KeyId() { return TLV::ContextTag(2); }
    static constexpr TLV::Tag EndpointCount() { return TLV::ContextTag(10); }
    static constexpr TLV::Tag EndpointList() { return TLV::ContextTag(12); }
    static constexpr TLV::Tag EndpointEntry() { return TLV::ContextTag(13); }
    // static constexpr TLV::Tag KeyList() { return TLV::ContextTag(4); }
    // static constexpr TLV::Tag Hash() { return TLV::ContextTag(41); }
    // static constexpr TLV::Tag EncryptKey() { return TLV::ContextTag(42); }
    // static constexpr TLV::Tag PrivacyKey() { return TLV::ContextTag(43); }
    // static constexpr TLV::Tag Expiration() { return TLV::ContextTag(44); }
};

#if 0
bool GroupKey::IsActive()
{
    uint64_t now = System::SystemClock().GetMonotonicTimestamp().count();
    return (0 == this->expiration) || (now < this->expiration);
}

bool GroupEntry::operator==(const GroupEntry & other) const
{
    return this->group_id == other.group_id;
}

GroupEntry & GroupEntry::operator=(const GroupEntry & t)
{
    this->group_id       = t.group_id;
    this->endpoint_count = t.endpoint_count;
    memcpy(this->endpoints, t.endpoints, this->endpoint_count * sizeof(EndpointId));
    for (size_t i = 0; i < kGroupKeyCount; ++i)
    {
        this->keys[i] = t.keys[i];
    }
    return *this;
}

void GroupEntry::InvalidateKeys()
{
    memset((void *) this->keys, 0x00, kGroupKeyCount * sizeof(GroupKey));
    keys[0].expiration = keys[1].expiration = 1;
}

void GroupEntry::SetActiveKey(const GroupKey & key, uint32_t period)
{
    size_t active_index = (0 == keys[1].expiration) ? 1 : 0;
    size_t new_index    = active_index ? 0 : 1;

    // Set active key (new value, no expiration)
    keys[new_index]            = key;
    keys[new_index].expiration = 0;
    // Set previous key (keep value, set expiration)
    keys[active_index].expiration = 1;
    if (period > 0)
    {
        uint64_t now                  = System::SystemClock().GetMonotonicTimestamp().count();
        keys[active_index].expiration = (period * 1000) + now;
    }
}

CHIP_ERROR GroupEntry::GetActiveKey(GroupKey & key)
{
    for (size_t i = 0; i < kGroupKeyCount; ++i)
    {
        if (keys[i].IsActive())
        {
            key = keys[i];
            return CHIP_NO_ERROR;
        }
    }
    return CHIP_ERROR_NOT_FOUND;
}
#endif

//
// GroupList
//

static constexpr size_t kMaxMembershipCount = CHIP_CONFIG_MAX_FABRICS; // TODO

struct GroupList : public PersistentArray<kMaxMembershipCount, kPersistentBufferMax, Group>
{
    GroupList(FabricIndex fabric, PersistentStorageDelegate * storage) :
        PersistentArray<CHIP_CONFIG_MAX_FABRICS, kPersistentBufferMax, Group>(storage), mFabric(fabric)
    {}

    CHIP_ERROR UpdateKey(StorageKeyName & key) const override
    {
        VerifyOrReturnError(kUndefinedFabricIndex != mFabric, CHIP_ERROR_INVALID_FABRIC_INDEX);
        key = DefaultStorageKeyAllocator::GroupcastMembership(mFabric);
        return CHIP_NO_ERROR;
    }

    void ClearEntry(Group & entry) override
    {
        entry.group_id       = 0;
        entry.endpoint_count = 0;
        memset(entry.endpoints, 0x00, sizeof(entry.endpoints));
    }

    CHIP_ERROR Serialize(TLV::TLVWriter & writer, const Group & entry) const override
    {
        ReturnErrorOnFailure(writer.Put(Tags::GroupId(), static_cast<uint16_t>(entry.group_id)));
        ReturnErrorOnFailure(writer.Put(Tags::KeyId(), static_cast<uint32_t>(entry.key_id)));
        ReturnErrorOnFailure(writer.Put(Tags::EndpointCount(), static_cast<uint16_t>(entry.endpoint_count)));
        // Endpoints
        {
            TLV::TLVType array, item;
            ReturnErrorOnFailure(writer.StartContainer(Tags::EndpointList(), TLV::kTLVType_Array, array));
            for (size_t i = 0; i < kEndpointsMax; ++i)
            {
                ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, item));
                // Endpoint
                ReturnErrorOnFailure(writer.Put(Tags::EndpointEntry(), entry.endpoints[i]));
                ReturnErrorOnFailure(writer.EndContainer(item));
            }
            ReturnErrorOnFailure(writer.EndContainer(array));
        }
        // Keys
        // {
        //     TLV::TLVType array, item;
        //     ReturnErrorOnFailure(writer.StartContainer(Tags::KeyList(), TLV::kTLVType_Array, array));
        //     for (size_t i = 0; i < kGroupKeyCount; ++i)
        //     {
        //         ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, item));
        //         // Hash
        //         ReturnErrorOnFailure(writer.Put(Tags::Hash(), static_cast<uint16_t>(entry.keys[i].hash)));
        //         // Encryption Key
        //         ByteSpan encrypt_key(entry.keys[i].encryption.As<Crypto::Symmetric128BitsKeyByteArray>());
        //         ReturnErrorOnFailure(writer.Put(Tags::EncryptKey(), encrypt_key));
        //         // Privacy Key
        //         ByteSpan privacy_key(entry.keys[i].privacy.As<Crypto::Symmetric128BitsKeyByteArray>());
        //         ReturnErrorOnFailure(writer.Put(Tags::PrivacyKey(), privacy_key));
        //         // Expiration
        //         ReturnErrorOnFailure(writer.Put(Tags::Expiration(), static_cast<uint64_t>(entry.keys[i].expiration)));
        //         ReturnErrorOnFailure(writer.EndContainer(item));
        //     }
        //     ReturnErrorOnFailure(writer.EndContainer(array));
        // }
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Deserialize(TLV::TLVReader & reader, Group & entry) override
    {
        // Group Id
        ReturnErrorOnFailure(reader.Next(Tags::GroupId()));
        ReturnErrorOnFailure(reader.Get(entry.group_id));
        // Key Id
        ReturnErrorOnFailure(reader.Next(Tags::KeyId()));
        ReturnErrorOnFailure(reader.Get(entry.key_id));
        // Endpoint Count
        ReturnErrorOnFailure(reader.Next(Tags::EndpointCount()));
        ReturnErrorOnFailure(reader.Get(entry.endpoint_count));
        // Endpoints
        ReturnErrorOnFailure(reader.Next(Tags::EndpointList()));
        VerifyOrReturnError(TLV::kTLVType_Array == reader.GetType(), CHIP_ERROR_INTERNAL);
        {
            TLV::TLVType array, item;
            ReturnErrorOnFailure(reader.EnterContainer(array));
            for (size_t i = 0; i < kEndpointsMax; ++i)
            {
                ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
                VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);
                ReturnErrorOnFailure(reader.EnterContainer(item));
                // Endpoint
                ReturnErrorOnFailure(reader.Next(Tags::EndpointEntry()));
                ReturnErrorOnFailure(reader.Get(entry.endpoints[i]));
                ReturnErrorOnFailure(reader.ExitContainer(item));
            }
            ReturnErrorOnFailure(reader.ExitContainer(array));
        }
        // Keys
        // ReturnErrorOnFailure(reader.Next(Tags::KeyList()));
        // VerifyOrReturnError(TLV::kTLVType_Array == reader.GetType(), CHIP_ERROR_INTERNAL);
        // {
        //     TLV::TLVType array, item;
        //     ReturnErrorOnFailure(reader.EnterContainer(array));
        //     for (size_t i = 0; i < kGroupKeyCount; ++i)
        //     {
        //         ByteSpan buf;
        //         ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
        //         VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);
        //         ReturnErrorOnFailure(reader.EnterContainer(item));
        //         // Hash
        //         ReturnErrorOnFailure(reader.Next(Tags::Hash()));
        //         ReturnErrorOnFailure(reader.Get(entry.keys[i].hash));
        //         // Encryption Key
        //         ReturnErrorOnFailure(reader.Next(Tags::EncryptKey()));
        //         ReturnErrorOnFailure(reader.Get(buf));
        //         memcpy(entry.keys[i].encryption.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(), buf.data(),
        //                sizeof(Crypto::Symmetric128BitsKeyByteArray));
        //         // Privacy Key
        //         ReturnErrorOnFailure(reader.Next(Tags::PrivacyKey()));
        //         ReturnErrorOnFailure(reader.Get(buf));
        //         memcpy(entry.keys[i].privacy.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(), buf.data(),
        //                sizeof(Crypto::Symmetric128BitsKeyByteArray));
        //         // Expiration
        //         ReturnErrorOnFailure(reader.Next(Tags::Expiration()));
        //         ReturnErrorOnFailure(reader.Get(entry.keys[i].expiration));
        //         ReturnErrorOnFailure(reader.ExitContainer(item));
        //     }
        //     ReturnErrorOnFailure(reader.ExitContainer(array));
        // }

        return CHIP_NO_ERROR;
    }

    FabricIndex mFabric;
};

#if 0
void DataProvider::KeyContext::KeyContext::Set(const GroupKey & key)
{
    mHash = key.hash;
    memcpy(mEncryptionKey.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(),
           key.encryption.As<Crypto::Symmetric128BitsKeyByteArray>(), sizeof(Crypto::Symmetric128BitsKeyByteArray));
    memcpy(mPrivacyKey.AsMutable<Crypto::Symmetric128BitsKeyByteArray>(), key.privacy.As<Crypto::Symmetric128BitsKeyByteArray>(),
           sizeof(Crypto::Symmetric128BitsKeyByteArray));
}

uint16_t DataProvider::KeyContext::GetKeyHash()
{
    return mHash;
}

CHIP_ERROR DataProvider::KeyContext::MessageEncrypt(const ByteSpan & plaintext, const ByteSpan & aad, const ByteSpan & nonce,
                                                    MutableByteSpan & mic, MutableByteSpan & ciphertext) const
{
    uint8_t * output = ciphertext.data();
    return Crypto::AES_CCM_encrypt(plaintext.data(), plaintext.size(), aad.data(), aad.size(), mEncryptionKey, nonce.data(),
                                   nonce.size(), output, mic.data(), mic.size());
}

CHIP_ERROR DataProvider::KeyContext::MessageDecrypt(const ByteSpan & ciphertext, const ByteSpan & aad, const ByteSpan & nonce,
                                                    const ByteSpan & mic, MutableByteSpan & plaintext) const
{
    uint8_t * output = plaintext.data();
    return Crypto::AES_CCM_decrypt(ciphertext.data(), ciphertext.size(), aad.data(), aad.size(), mic.data(), mic.size(),
                                   mEncryptionKey, nonce.data(), nonce.size(), output);
}

CHIP_ERROR DataProvider::KeyContext::PrivacyEncrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const
{
    return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
}

CHIP_ERROR DataProvider::KeyContext::PrivacyDecrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const
{
    return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
}

void DataProvider::KeyContext::Release()
{
    // mProvider.mKeyContextPool.ReleaseObject(this);
}

//
// KeyContext Iterator
//
DataProvider::KeyIterator::KeyIterator(DataProvider & group_data, FabricTable *fabrics, GroupId group_id, uint16_t session_id) :
    mProvider(group_data), mFabrics(fabrics), mGroupId(group_id), mContext(group_data), mSessionId(session_id)
{
}

size_t DataProvider::KeyIterator::Count()
{
    chip::Credentials::GroupDataProvider *group_data = chip::Credentials::GetGroupDataProvider();
    size_t count = 0;
    // Iterate all fabrics
    for(uint8_t i=0; mFabrics && (i < mFabrics->FabricCount()); ++i)
    {
        const FabricInfo *info = mFabrics->FindFabricWithIndex(i);
        if(info)
        {
            // Get the group list for the current fabric
            chip::Groupcast::GroupList list(info->GetFabricIndex(), mProvider.mStorage);
            GroupEntry entry(mGroupId);
            size_t index = 0;
            if(CHIP_NO_ERROR == list.Find(entry, index))
            {
                // GroupId find in fabric, iterate keys
                for (size_t k = 0; k < kGroupKeyCount; ++k)
                {
                    auto &key = entry.keys[k];
                    if (key.IsActive() && (key.hash == mSessionId))
                    {
                        count++;
                    }
                }
            }
        }
    }
    return count;
}

bool DataProvider::KeyIterator::Next(KeyContext *&output)
{
    chip::Credentials::GroupDataProvider *group_data = chip::Credentials::GetGroupDataProvider();
    // Iterate all fabrics
    while (mFabrics && (mFabricIndex < mFabrics->FabricCount()))
    {
        const FabricInfo *info = mFabrics->FindFabricWithIndex(mFabricIndex);
        if(info)
        {
            // Get the group list for the current fabric
            chip::Groupcast::GroupList list(info->GetFabricIndex(), mProvider.mStorage);
            GroupEntry entry(mGroupId);
            size_t index = 0;
            if(CHIP_NO_ERROR == list.Find(entry, index))
            {
                Crypto::SymmetricKeyContext *context = group_data->GetKeysetContext(mFabricIndex, entry.key_id);
                VerifyOrReturnValue(nullptr != context, false);
                output = context;
            }
        }
        // No group_id/session_id match in current fabric
        mFabricIndex++;
        mKeyIndex = 0;
    }
    return false;
}

void DataProvider::KeyIterator::Release()
{
    mProvider.mKeyIteratorPool.ReleaseObject(this);
}
#endif

//
// Group Iterator
//

DataProvider::GroupIterator::GroupIterator(DataProvider & group_data, FabricIndex fabric) : mProvider(group_data), mFabric(fabric)
{
    chip::Groupcast::GroupList list(fabric, group_data.mStorage);
    list.Load();
    mCount = list.Count();
}

size_t DataProvider::GroupIterator::Count()
{
    return mCount;
}

bool DataProvider::GroupIterator::Next(Group & out)
{
    VerifyOrReturnValue(mIndex < mCount, false);
    Group entry;
    chip::Groupcast::GroupList list(mFabric, mProvider.mStorage);
    list.Load();
    VerifyOrReturnValue(CHIP_NO_ERROR == list.Get(mIndex++, entry), false);
    out = entry;
    return true;
}

void DataProvider::GroupIterator::Release()
{
    mProvider.mGroupIteratorPool.ReleaseObject(this);
}

//
// DataProvider
//

namespace {
DataProvider sInstance;
}

DataProvider & DataProvider::DataProvider::Instance()
{
    return sInstance;
}

CHIP_ERROR DataProvider::Initialize(PersistentStorageDelegate * storage, chip::Crypto::SessionKeystore * keystore)
{
    VerifyOrReturnError(storage != nullptr, CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(keystore != nullptr, CHIP_ERROR_INTERNAL);
    mStorage  = storage;
    mKeystore = keystore;
    return CHIP_NO_ERROR;
}

uint8_t DataProvider::GetMaxMembershipCount()
{
    return kMaxMembershipCount;
}

CHIP_ERROR DataProvider::AddGroup(chip::FabricIndex fabric_idx,
                                  Group & grp)
{
    VerifyOrReturnError(mStorage != nullptr, CHIP_ERROR_INCORRECT_STATE);
    VerifyOrReturnError(mKeystore != nullptr, CHIP_ERROR_INCORRECT_STATE);

    // Insert entry
    {
        chip::Groupcast::GroupList list(fabric_idx, mStorage);
        Group entry(grp.group_id, grp.key_id);
        size_t index = 0;

        // Load current entry, if any
        list.Find(entry, index);

        // Endpoints
        entry.endpoint_count = grp.endpoint_count;
        memcpy(entry.endpoints, grp.endpoints, entry.endpoint_count * sizeof(EndpointId));

        // Keys
        // Generate credentials (const ByteSpan & compressed_fabric_id, uint32_t period)
        // Crypto::GroupOperationalCredentials credentials;
        // ReturnErrorOnFailure(Crypto::DeriveGroupOperationalCredentials(key, compressed_fabric_id, credentials));
        // if (0 == key.size())
        // {
        //     // Invalidate all keys
        //     entry.InvalidateKeys();
        // }
        // else
        // {
        //     // Set new key
        //     GroupKey group_key(credentials.hash);
        //     ReturnErrorOnFailure(mKeystore->CreateKey(credentials.encryption_key, group_key.encryption));
        //     ReturnErrorOnFailure(mKeystore->CreateKey(credentials.privacy_key, group_key.privacy));
        //     entry.SetActiveKey(group_key, period);
        // }

        return list.Add(entry, true);
    }
}

CHIP_ERROR DataProvider::GetGroup(FabricIndex fabric_idx, Group & grp)
{
    chip::Groupcast::GroupList list(fabric_idx, mStorage);
    Group entry(grp.group_id);
    size_t index = 0;
    // Find grp in NVM
    ReturnErrorOnFailure(list.Find(entry, index));
    // Copy to output
    grp = entry;
    return CHIP_NO_ERROR;
}

CHIP_ERROR DataProvider::SetEndpoints(FabricIndex fabric_idx, Group & grp)
{
    chip::Groupcast::GroupList list(fabric_idx, mStorage);
    Group entry(grp.group_id);
    size_t index = 0;
    // Find group in NVM
    ReturnErrorOnFailure(list.Find(entry, index));
    entry.endpoint_count = grp.endpoint_count;
    for(size_t i=0; i < entry.endpoint_count; ++i) {
        entry.endpoints[i] = grp.endpoints[i];
    }
    return list.Save();
}

CHIP_ERROR DataProvider::RemoveGroup(FabricIndex fabric_idx, GroupId group_id)
{
    chip::Groupcast::GroupList list(fabric_idx, mStorage);
    ReturnErrorOnFailure(list.Remove(Group(group_id)));
    return list.Save();
}

// chip::Crypto::SymmetricKeyContext * DataProvider::CreateKeyContext(FabricIndex fabric, GroupId group_id)
// {
//     // Find group in NVM
//     GroupEntry entry(group_id);
//     size_t index = 0;
//     chip::Groupcast::GroupList list(fabric, mStorage);
//     VerifyOrReturnValue(CHIP_NO_ERROR == list.Find(entry, index), nullptr);
//     // Get active key
//     GroupKey key;
//     VerifyOrReturnValue(CHIP_NO_ERROR == entry.GetActiveKey(key), nullptr);
//     // Create context with loaded keys
//     chip::Crypto::SymmetricKeyContext * context = mKeyContextPool.CreateObject(*this, key);
//     return context;
// }

// DataProvider::KeyIterator * DataProvider::IterateKeys(FabricTable *fabrics, GroupId group_id, uint16_t session_id)
// {
//     return mKeyIteratorPool.CreateObject(*this, fabrics, group_id, session_id);
// }

DataProvider::GroupIterator * DataProvider::IterateGroups(FabricIndex fabric)
{
    return mGroupIteratorPool.CreateObject(*this, fabric);
}

} // namespace Groupcast
} // namespace chip
