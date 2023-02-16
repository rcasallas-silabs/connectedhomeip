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
#include <lib/support/CodeUtils.h>
#include <lib/support/CommonPersistentData.h>
#include <lib/support/DefaultStorageKeyAllocator.h>
#include <lib/support/PersistentData.h>
#include <lib/support/Pool.h>
#include <stdlib.h>

namespace chip {
namespace Credentials {

using GroupInfo     = GroupDataProvider::GroupInfo;
using GroupKey      = GroupDataProvider::GroupKey;
using GroupEndpoint = GroupDataProvider::GroupEndpoint;
using EpochKey      = GroupDataProvider::EpochKey;
using KeySet        = GroupDataProvider::KeySet;
using GroupSession  = GroupDataProvider::GroupSession;


constexpr size_t kPersistentBufferMax = 128;




template <typename EntryType, size_t kMaxListSize, size_t kMaxSerializedSize>
struct PersistentList : chip::PersistentData<kMaxSerializedSize>
{
    // static constexpr size_t kMaxListSize = kMaxListSize;
    static constexpr TLV::Tag TagItemCount() { return TLV::ContextTag(1); }
    static constexpr TLV::Tag TagItemList() { return TLV::ContextTag(2); }
    static constexpr TLV::Tag TagItemEntry() { return TLV::ContextTag(3); }

    EntryType elements[kMaxListSize]; 
    uint16_t count = 0;

    void Clear() override
    {
        this->count = 0;
        for (size_t i = 0; i < kMaxListSize; ++i)
        {
            this->ClearItem(this->elements[i]);
        }
    }

    CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
    {
        TLV::TLVType container;
        ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, container));

        ReturnErrorOnFailure(writer.Put(TagItemCount(), static_cast<uint16_t>(this->count)));

        // fabric_list
        {
            TLV::TLVType list, item;
            ReturnErrorOnFailure(writer.StartContainer(TagItemList(), TLV::kTLVType_List, list));
            for (size_t i = 0; (i < this->count) && (i < kMaxListSize); ++i)
            {
                // fabric index
                // ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, item));
                // ReturnErrorOnFailure(writer.Put(TagItemEntry(), static_cast<uint16_t>(this->elements[i])));
                ReturnErrorOnFailure(this->SerializeItem(writer, this->elements[i]));
                // ReturnErrorOnFailure(writer.EndContainer(item));
            }
            ReturnErrorOnFailure(writer.EndContainer(list));
        }
        return writer.EndContainer(container);
    }

    CHIP_ERROR Deserialize(TLV::TLVReader & reader) override
    {
        ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
        VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

        TLV::TLVType container;
        ReturnErrorOnFailure(reader.EnterContainer(container));

        // fabric_count
        ReturnErrorOnFailure(reader.Next(TagItemCount()));
        ReturnErrorOnFailure(reader.Get(this->count));
        {
            // fabric_list
            ReturnErrorOnFailure(reader.Next(TagItemList()));
            VerifyOrReturnError(TLV::kTLVType_List == reader.GetType(), CHIP_ERROR_INTERNAL);

            TLV::TLVType list;
            ReturnErrorOnFailure(reader.EnterContainer(list));

            for (size_t i = 0; i < this->count && i < kMaxListSize; ++i)
            {
                ReturnErrorOnFailure(this->DeserializeItem(reader, this->elements[i]));
            }
            ReturnErrorOnFailure(reader.ExitContainer(list));
        }

        return reader.ExitContainer(container);
    }

    CHIP_ERROR Add(PersistentStorageDelegate * storage, const EntryType item)
    {
        CHIP_ERROR err = this->Load(storage);
        if(CHIP_ERROR_NOT_FOUND == err)
        {
            this->count = 1;
            this->CopyItem(item, this->elements[0]);
            return CHIP_NO_ERROR;
        }
        ReturnErrorOnFailure(err);
        for(size_t i = 0; i < this->count; ++i)
        {
            if(this->elements[i] == item)
            {
                // Already registered
                return CHIP_NO_ERROR;
            }
        }
        VerifyOrReturnError(this->count < kMaxListSize, CHIP_ERROR_INVALID_LIST_LENGTH);
        this->CopyItem(item, this->elements[this->count++]);
        return this->Save(storage);
    }

    CHIP_ERROR Set(PersistentStorageDelegate * storage, size_t index, const EntryType item)
    {
        CHIP_ERROR err = this->Load(storage);
        if(CHIP_ERROR_NOT_FOUND == err)
        {
            // First group
            VerifyOrReturnError(0 == index, CHIP_ERROR_INVALID_ARGUMENT);
            this->count = 1;
            this->CopyItem(item, this->elements[0]);
            return CHIP_NO_ERROR;
        }
        // Second to last
        ReturnErrorOnFailure(err);
        VerifyOrReturnError(this->count < kMaxListSize, CHIP_ERROR_INVALID_LIST_LENGTH);
        VerifyOrReturnError(index == this->count, CHIP_ERROR_INVALID_ARGUMENT);
        this->CopyItem(item, this->elements[this->count++]);
        return this->Save(storage);
    }

    virtual void ClearItem(EntryType & item) = 0;
    virtual void CopyItem(const EntryType & from, EntryType & into) const
    {
        into = from;
    }
    virtual CHIP_ERROR SerializeItem(TLV::TLVWriter & writer, const EntryType & item) const = 0;
    virtual CHIP_ERROR DeserializeItem(TLV::TLVReader & reader, EntryType & item) = 0;

};


struct FabricList : PersistentList<FabricIndex, CHIP_CONFIG_MAX_FABRICS, kPersistentBufferMax>
{
    static constexpr size_t kFabricCountMax = CHIP_CONFIG_MAX_FABRICS;

    FabricList() = default;

    CHIP_ERROR UpdateKey(StorageKeyName & key) override
    {
        // TODO: key = DefaultStorageKeyAllocator::FabricKeyset(fabric_index, keyset_id);
        key = StorageKeyName::FromConst("g/f2"); // FIXME
        return CHIP_NO_ERROR;
    }

    void ClearItem(FabricIndex & item) override
    {
        item = kUndefinedFabricIndex;
    }

    void CopyItem(const FabricIndex & from, FabricIndex & into) const override
    {
        into = from;
    }

    CHIP_ERROR SerializeItem(TLV::TLVWriter & writer, const FabricIndex & item) const override
    {
        ReturnErrorOnFailure(writer.Put(TagItemEntry(), static_cast<uint16_t>(item)));
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR DeserializeItem(TLV::TLVReader & reader, FabricIndex & item) override
    {
        ReturnErrorOnFailure(reader.Next(TagItemEntry()));
        ReturnErrorOnFailure(reader.Get(item));
        return CHIP_NO_ERROR;
    }
};


struct GroupInfoList : public PersistentList<GroupInfo, CHIP_CONFIG_MAX_GROUPS_PER_FABRIC, kPersistentBufferMax>
{
    static constexpr size_t kFabricCountMax = CHIP_CONFIG_MAX_FABRICS;

    FabricIndex fabric;
    
    GroupInfoList(FabricIndex fabric_index) : fabric(fabric_index) {}

    CHIP_ERROR UpdateKey(StorageKeyName & key) override
    {
        // TODO: key = DefaultStorageKeyAllocator::FabricKeyset(fabric_index, keyset_id);
        key = StorageKeyName::Formatted("f2/%x/gi", fabric);
        return CHIP_NO_ERROR;
    }

    void ClearItem(GroupInfo & item) override
    {
        item.group_id = kUndefinedGroupId;
    }

    void CopyItem(const GroupInfo & from, GroupInfo & into) const override
    {
        into.group_id = from.group_id;
    }

    CHIP_ERROR SerializeItem(TLV::TLVWriter & writer, const GroupInfo & item) const override
    {
        ReturnErrorOnFailure(writer.Put(TagItemEntry(), static_cast<uint16_t>(item.group_id)));
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR DeserializeItem(TLV::TLVReader & reader, GroupInfo & item) override
    {
        ReturnErrorOnFailure(reader.Next(TagItemEntry()));
        ReturnErrorOnFailure(reader.Get(item.group_id));
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
    
    FabricList fabrics;
    ReturnErrorOnFailure(fabrics.Add(mStorage, fabric_index));

    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetGroupInfo(FabricIndex fabric_index, GroupId group_id, GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveGroupInfo(FabricIndex fabric_index, GroupId group_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// By index

CHIP_ERROR GroupDataProviderImpl::SetGroupInfoAt(FabricIndex fabric_index, size_t index, const GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);

    FabricList fabrics;
    ReturnErrorOnFailure(fabrics.Add(mStorage, fabric_index));

    GroupInfoList groups(fabric_index);
    ReturnErrorOnFailure(groups.Set(mStorage, index, info));


    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetGroupInfoAt(FabricIndex fabric_index, size_t index, GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveGroupInfoAt(FabricIndex fabric_index, size_t index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Endpoints

bool GroupDataProviderImpl::HasEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), false);
    return false;
}

CHIP_ERROR GroupDataProviderImpl::AddEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::RemoveEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveEndpoint(FabricIndex fabric_index, EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProvider::GroupInfoIterator * GroupDataProviderImpl::IterateGroupInfo(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupInfoIterators.CreateObject(*this, fabric_index);
}


GroupDataProvider::EndpointIterator * GroupDataProviderImpl::IterateEndpoints(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mEndpointIterators.CreateObject(*this, fabric_index);
}

//------------------------------------------------------------------------------
// Group-Key map
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::SetGroupKeyAt(FabricIndex fabric_index, size_t index, const GroupKey & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetGroupKeyAt(FabricIndex fabric_index, size_t index, GroupKey & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveGroupKeyAt(FabricIndex fabric_index, size_t index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveGroupKeys(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


GroupDataProvider::GroupKeyIterator * GroupDataProviderImpl::IterateGroupKeys(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupKeyIterators.CreateObject(*this, fabric_index);
}

//------------------------------------------------------------------------------
// Key Sets
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::SetKeySet(FabricIndex fabric_index, const ByteSpan & compressed_fabric_id, const KeySet & keys)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetKeySet(FabricIndex fabric_index, KeysetId keyset_id, KeySet & keys)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveKeySet(FabricIndex fabric_index, KeysetId keyset_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetIpkKeySet(FabricIndex fabric_index, KeySet & out_keyset)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


GroupDataProvider::KeySetIterator * GroupDataProviderImpl::IterateKeySets(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mKeySetIterators.CreateObject(*this, fabric_index);
}


//------------------------------------------------------------------------------
// Fabrics
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::RemoveFabric(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


GroupDataProvider::GroupSessionIterator * GroupDataProviderImpl::IterateGroupSessions(uint16_t session_id)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupSessionsIterator.CreateObject(*this, session_id);
}


Crypto::SymmetricKeyContext * GroupDataProviderImpl::GetKeyContext(FabricIndex fabric_index, GroupId group_id)
{
    return nullptr;
}

//------------------------------------------------------------------------------
// Iterators
//------------------------------------------------------------------------------


GroupDataProviderImpl::GroupInfoIteratorImpl::GroupInfoIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index) :
    mProvider(provider),
    mFabric(fabric_index)
{

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
    mProvider(provider), mSessionId(session_id), mGroupKeyContext(provider)
{
}


size_t GroupDataProviderImpl::GroupSessionIteratorImpl::Count()
{
    return 0;
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
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::MessageDecrypt(const ByteSpan & ciphertext, const ByteSpan & aad, const ByteSpan & nonce, const ByteSpan & mic,
                            MutableByteSpan & plaintext) const
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::PrivacyEncrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const

{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::PrivacyDecrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

void GroupDataProviderImpl::GroupKeyContext::Release()
{
    memset(mEncryptionKey, 0, sizeof(mEncryptionKey));
    memset(mPrivacyKey, 0, sizeof(mPrivacyKey));
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
