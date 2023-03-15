/*
 *
 *    Copyright (c) 2021-2022 Project CHIP Authors
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
#include <credentials/GroupDataProviderImpl.h>
#include <crypto/CHIPCryptoPAL.h>
#include <lib/core/TLV.h>
#include <lib/support/Pool.h>
#include <lib/support/DefaultStorageKeyAllocator.h>
#include "PersistentData.h"
#include <stdlib.h>

namespace chip {
namespace Credentials {

// using FabricList    = CommonPersistentData::FabricList;
using GroupInfo     = GroupDataProvider::GroupInfo;
using GroupKey      = GroupDataProvider::GroupKey;
using GroupEndpoint = GroupDataProvider::GroupEndpoint;
using EpochKey      = GroupDataProvider::EpochKey;
using KeySet        = GroupDataProvider::KeySet;
using GroupSession  = GroupDataProvider::GroupSession;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

enum class GroupTags : uint8_t
{
    kFabric = static_cast<uint8_t>(PersistentTags::kEntryData) + 1,
};

struct FabricEntry: public PersistentEntry {

    FabricEntry(): mIndex(kUndefinedFabricIndex) {}
    FabricEntry(FabricIndex index): mIndex(index) {}

    void Clear() override
    {
        mIndex = kUndefinedFabricIndex;
    }

    bool Compare(const PersistentEntry & other) const override
    {
        const FabricEntry &f = dynamic_cast<const FabricEntry &>(other);
        return f.mIndex == mIndex;
    }
    
    CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
    {
        // Fabric
        ReturnErrorOnFailure(writer.Put(TLV::ContextTag(GroupTags::kFabric), static_cast<uint16_t>(mIndex)));
        return CHIP_NO_ERROR;
    }
    
    CHIP_ERROR Deserialize(TLV::TLVReader & reader) override
    {
        // Fabric
        ReturnErrorOnFailure(reader.Next(TLV::ContextTag(GroupTags::kFabric)));
        ReturnErrorOnFailure(reader.Get(mIndex));
        return CHIP_NO_ERROR;
    }

    FabricIndex mIndex = kUndefinedFabricIndex;
};

constexpr size_t kPersistentFabricBufferMax = 1024;
struct FabricList: public PersistentArray<kPersistentFabricBufferMax, 32, FabricEntry> {

    FabricList(PersistentStorageDelegate * storage): PersistentArray<kPersistentFabricBufferMax, 32, FabricEntry>(storage) {}

    CHIP_ERROR UpdateKey(StorageKeyName & key) override
    {
        key = DefaultStorageKeyAllocator::GroupFabricList();
        return CHIP_NO_ERROR;
    }
};


//------------------------------------------------------------------------------
// Initialization
//------------------------------------------------------------------------------


CHIP_ERROR GroupDataProviderImpl::Init()
{
    if (mStorage == nullptr)
    {
        return CHIP_ERROR_INCORRECT_STATE;
    }


    FabricList list(mStorage);
    for(size_t i = 0; i < 25; i++)
    {
        FabricEntry f(static_cast<FabricIndex>(100 + i));
        list.Set(i, f);
    }
    FabricEntry g;
    list.Remove(15, g);
    list.Remove(20, g);
    list.Remove(24, g);

    for(size_t i = 23; i < 32; i++)
    {
        FabricEntry f(static_cast<FabricIndex>(200 + i));
        list.Set(i, f);
    }

    return CHIP_NO_ERROR;
}

void GroupDataProviderImpl::Finish()
{
    mGroupInfoIterators.ReleaseAll();
    mGroupKeyIterators.ReleaseAll();
    mEndpointIterators.ReleaseAll();
    mKeySetIterators.ReleaseAll();
    mGroupSessionsIterator.ReleaseAll();
    mGroupKeyContexPool.ReleaseAll();
}

void GroupDataProviderImpl::SetStorageDelegate(PersistentStorageDelegate * storage)
{
    VerifyOrDie(storage != nullptr);
    mStorage = storage;
}

//------------------------------------------------------------------------------
// Group Table
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::SetGroupInfo(FabricIndex fabric_index, const GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);
    
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GetGroupInfo(FabricIndex fabric_index, GroupId group_id, GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::RemoveGroupInfo(FabricIndex fabric_index, GroupId group_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// By index

CHIP_ERROR GroupDataProviderImpl::SetGroupInfoAt(FabricIndex fabric_index, size_t index, const GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GetGroupInfoAt(FabricIndex fabric_index, size_t index, GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::RemoveGroupInfoAt(FabricIndex fabric_index, size_t index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Endpoints

bool GroupDataProviderImpl::HasEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), false);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, false);

    return false;
}

CHIP_ERROR GroupDataProviderImpl::AddEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::RemoveEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::RemoveEndpoint(FabricIndex fabric_index, EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProvider::GroupInfoIterator * GroupDataProviderImpl::IterateGroupInfo(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, nullptr);
    return mGroupInfoIterators.CreateObject(*this, fabric_index);
}


GroupDataProvider::EndpointIterator * GroupDataProviderImpl::IterateEndpoints(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, nullptr);
    return mEndpointIterators.CreateObject(*this, fabric_index);
}

//------------------------------------------------------------------------------
// Group-Key map
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::SetGroupKeyAt(FabricIndex fabric_index, size_t index, const GroupKey & pair)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GetGroupKeyAt(FabricIndex fabric_index, size_t index, GroupKey & pair)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::RemoveGroupKeyAt(FabricIndex fabric_index, size_t index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::RemoveGroupKeys(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

GroupDataProvider::GroupKeyIterator * GroupDataProviderImpl::IterateGroupKeys(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, nullptr);
    return mGroupKeyIterators.CreateObject(*this, fabric_index);
}

//------------------------------------------------------------------------------
// Key Sets
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::SetKeySet(FabricIndex fabric_index, const ByteSpan & compressed_fabric_id, const KeySet & in_keyset)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GetKeySet(FabricIndex fabric_index, KeysetId keyset_id, KeySet & out_keyset)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::RemoveKeySet(FabricIndex fabric_index, KeysetId keyset_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GetIpkKeySet(FabricIndex fabric_index, KeySet & out_keyset)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}

GroupDataProvider::KeySetIterator * GroupDataProviderImpl::IterateKeySets(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, nullptr);
    return mKeySetIterators.CreateObject(*this, fabric_index);
}

//------------------------------------------------------------------------------
// Fabrics
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::RemoveFabric(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    return CHIP_ERROR_NOT_IMPLEMENTED;
}


GroupDataProvider::GroupSessionIterator * GroupDataProviderImpl::IterateGroupSessions(uint16_t session_id)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupSessionsIterator.CreateObject(*this, session_id);
}


Crypto::SymmetricKeyContext * GroupDataProviderImpl::GetKeyContext(FabricIndex fabric_index, GroupId group_id)
{
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, nullptr);

    return nullptr;
}

//------------------------------------------------------------------------------
// Iterators
//------------------------------------------------------------------------------

GroupDataProviderImpl::GroupInfoIteratorImpl::GroupInfoIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index) :
    mProvider(provider)
    // mFabric(fabric_index),
    // mList(fabric_index, nullptr)
{
    VerifyOrReturn(mProvider.IsInitialized());
    VerifyOrReturn(kUndefinedFabricIndex != mFabric);
}

size_t GroupDataProviderImpl::GroupInfoIteratorImpl::Count()
{
    return 0;
}

bool GroupDataProviderImpl::GroupInfoIteratorImpl::Next(GroupInfo & output)
{
    return false;
}

void GroupDataProviderImpl::GroupInfoIteratorImpl::Release()
{
    mProvider.mGroupInfoIterators.ReleaseObject(this);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProviderImpl::GroupKeyIteratorImpl::GroupKeyIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index) :
    mProvider(provider),
    mFabric(fabric_index)
    // ,
    // mMap(fabric_index)
{
}

size_t GroupDataProviderImpl::GroupKeyIteratorImpl::Count()
{
    return 0;
}

bool GroupDataProviderImpl::GroupKeyIteratorImpl::Next(GroupKey & output)
{
    return false;
}

void GroupDataProviderImpl::GroupKeyIteratorImpl::Release()
{
    mProvider.mGroupKeyIterators.ReleaseObject(this);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProviderImpl::EndpointIteratorImpl::EndpointIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index) :
    mProvider(provider),
    mFabric(fabric_index)
    // , mGroups(fabric_index, nullptr),
    // mEndpoints(fabric_index, kUndefinedGroupId)
{
}

size_t GroupDataProviderImpl::EndpointIteratorImpl::Count()
{
    return 0;
}

bool GroupDataProviderImpl::EndpointIteratorImpl::Next(GroupEndpoint & output)
{
    return false;
}

void GroupDataProviderImpl::EndpointIteratorImpl::Release()
{
    mProvider.mEndpointIterators.ReleaseObject(this);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProviderImpl::KeySetIteratorImpl::KeySetIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index) :
    mProvider(provider), mFabric(fabric_index)
    // , mList(fabric_index)
{
}

size_t GroupDataProviderImpl::KeySetIteratorImpl::Count()
{
    return 0;
}

bool GroupDataProviderImpl::KeySetIteratorImpl::Next(KeySet & output)
{
    return false;
}


void GroupDataProviderImpl::KeySetIteratorImpl::Release()
{
    mProvider.mKeySetIterators.ReleaseObject(this);
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProviderImpl::GroupSessionIteratorImpl::GroupSessionIteratorImpl(GroupDataProviderImpl & provider, uint16_t session_id):
    mProvider(provider), mGroupKeyContext(provider), mSessionId(session_id)
    // , mMap(kUndefinedFabricIndex), mList(kUndefinedFabricIndex)
{
}

size_t GroupDataProviderImpl::GroupSessionIteratorImpl::Count()
{
    size_t count = 0;
    return count;
}


bool GroupDataProviderImpl::GroupSessionIteratorImpl::Next(GroupSession & output)
{
    return false;
}


void GroupDataProviderImpl::GroupSessionIteratorImpl::Release()
{
    mProvider.mGroupSessionsIterator.ReleaseObject(this);
}


//------------------------------------------------------------------------------
// Encryption
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::MessageEncrypt(const ByteSpan & plaintext, const ByteSpan & aad, const ByteSpan & nonce, MutableByteSpan & mic,
                            MutableByteSpan & ciphertext) const
{
    uint8_t * output = ciphertext.data();
    return Crypto::AES_CCM_encrypt(plaintext.data(), plaintext.size(), aad.data(), aad.size(), mEncryptionKey, nonce.data(),
                                   nonce.size(), output, mic.data(), mic.size());
}

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::MessageDecrypt(const ByteSpan & ciphertext, const ByteSpan & aad, const ByteSpan & nonce, const ByteSpan & mic,
                            MutableByteSpan & plaintext) const
{
    uint8_t * output = plaintext.data();
    return Crypto::AES_CCM_decrypt(ciphertext.data(), ciphertext.size(), aad.data(), aad.size(), mic.data(), mic.size(),
                                   mEncryptionKey, nonce.data(), nonce.size(), output);
}

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::PrivacyEncrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const

{
    return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
}

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::PrivacyDecrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const
{
    return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
}

void GroupDataProviderImpl::GroupKeyContext::Release()
{
    ReleaseKeys();
    mProvider.mGroupKeyContexPool.ReleaseObject(this);
}

namespace {

GroupDataProvider * gGroupsProvider = nullptr;

} // namespace

GroupDataProvider * GetGroupDataProvider()
{
    return gGroupsProvider;
}

void SetGroupDataProvider(GroupDataProvider * provider)
{
    gGroupsProvider = provider;
}

} // namespace Credentials
} // namespace chip
