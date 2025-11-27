/*
 *    Copyright (c) 2025 Project CHIP Authors
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

#include "GroupcastDataProvider.h"
#include <crypto/CHIPCryptoPAL.h>
#include <lib/core/TLVCommon.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/DefaultStorageKeyAllocator.h>
#include <lib/support/PersistentArray.h>
#include <lib/support/logging/CHIPLogging.h>
#include <system/SystemClock.h>

using namespace chip;

namespace chip {
namespace Groupcast {

struct Tags
{
    static constexpr TLV::Tag GroupId() { return TLV::ContextTag(1); }
    static constexpr TLV::Tag KeyId() { return TLV::ContextTag(2); }
    static constexpr TLV::Tag EndpointCount() { return TLV::ContextTag(10); }
    static constexpr TLV::Tag EndpointList() { return TLV::ContextTag(12); }
    static constexpr TLV::Tag EndpointEntry() { return TLV::ContextTag(13); }
};

//
// GroupList
//

static constexpr size_t kMaxMembershipCount = CHIP_CONFIG_MAX_GROUPCAST_MEMBERSHIP_COUNT;
static constexpr size_t MaxPersistentBuffer()
{
    return TLV::EstimateStructOverhead(sizeof(GroupId) + sizeof(KeysetId) + sizeof(uint16_t),
                                       kEndpointsMax * (3 + sizeof(EndpointId)));
}

struct GroupList : public PersistentArray<kMaxMembershipCount, MaxPersistentBuffer(), Group>
{
    FabricIndex mFabric;

    GroupList(FabricIndex fabric_index, PersistentStorageDelegate * storage) :
        PersistentArray<kMaxMembershipCount, MaxPersistentBuffer(), Group>(storage), mFabric(fabric_index)
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
            for (size_t i = 0; i < entry.endpoint_count; ++i)
            {
                ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, item));
                // Endpoint
                ReturnErrorOnFailure(writer.Put(Tags::EndpointEntry(), entry.endpoints[i]));
                ReturnErrorOnFailure(writer.EndContainer(item));
            }
            ReturnErrorOnFailure(writer.EndContainer(array));
        }
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
            for (size_t i = 0; i < entry.endpoint_count; ++i)
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
        return CHIP_NO_ERROR;
    }
};

//
// DataProvider
//

CHIP_ERROR DataProvider::Initialize(PersistentStorageDelegate * storage, Credentials::KeyManager *keys)
{
    // VerifyOrReturnError(fabrics != nullptr, CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(storage != nullptr, CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(keys != nullptr, CHIP_ERROR_INTERNAL);
    // mFabrics  = fabrics;
    mStorage  = storage;
    mKeyManager = keys;
    return CHIP_NO_ERROR;
}

uint8_t DataProvider::GetMaxMembershipCount()
{
    return kMaxMembershipCount;
}

CHIP_ERROR DataProvider::AddGroup(chip::FabricIndex fabric_idx, Group & grp)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INCORRECT_STATE);
    VerifyOrReturnError(grp.endpoint_count <= kEndpointsMax, CHIP_ERROR_INVALID_ARGUMENT);

    // Insert entry
    {
        GroupList list(fabric_idx, mStorage);
        Group entry(grp.group_id, grp.key_id);
        size_t index = 0;

        // Load current entry, if any
        list.Find(entry, index);

        // Endpoints
        entry.endpoint_count = grp.endpoint_count;
        memcpy(entry.endpoints, grp.endpoints, entry.endpoint_count * sizeof(EndpointId));

        ReturnErrorOnFailure(list.Add(entry, true));
        return list.Save();
    }
}

CHIP_ERROR DataProvider::GetGroup(FabricIndex fabric_idx, Group & grp)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INCORRECT_STATE);
    GroupList list(fabric_idx, mStorage);
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
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INCORRECT_STATE);
    VerifyOrReturnError(grp.endpoint_count <= kEndpointsMax, CHIP_ERROR_INVALID_ARGUMENT);
    GroupList list(fabric_idx, mStorage);
    Group entry(grp.group_id);
    size_t index = 0;
    // Find group in NVM
    ReturnErrorOnFailure(list.Find(entry, index));
    entry.endpoint_count = grp.endpoint_count;
    for (size_t i = 0; i < entry.endpoint_count; ++i)
    {
        entry.endpoints[i] = grp.endpoints[i];
    }
    ReturnErrorOnFailure(list.Set(index, entry));
    return list.Save();
}

CHIP_ERROR DataProvider::RemoveGroup(FabricIndex fabric_idx, GroupId group_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INCORRECT_STATE);
    GroupList list(fabric_idx, mStorage);
    ReturnErrorOnFailure(list.Remove(Group(group_id)));
    return list.Save();
}

chip::Crypto::SymmetricKeyContext * DataProvider::GetKeyContext(FabricIndex fabric_index, GroupId group_id)
{
    VerifyOrReturnValue(IsInitialized(), nullptr);
    // Find group in NVM
    Group entry(group_id);
    size_t index = 0;
    chip::Groupcast::GroupList list(fabric_index, mStorage);
    VerifyOrReturnValue(CHIP_NO_ERROR == list.Find(entry, index), nullptr);
    // Create key context
    return mKeyManager->CreateKeyContext(fabric_index, entry.key_id);
}

//
// Group Iterator
//

DataProvider::GroupIterator * DataProvider::IterateGroups(FabricIndex fabric_index)
{
    VerifyOrReturnValue(IsInitialized(), nullptr);
    return mGroupIteratorPool.CreateObject(*this, fabric_index);
}

DataProvider::GroupIterator::GroupIterator(DataProvider & provider, FabricIndex fabric_index) :
    mProvider(provider), mFabric(fabric_index)
{
    GroupList list(fabric_index, provider.mStorage);
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
    GroupList list(mFabric, mProvider.mStorage);
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
// Session Iterator
//

Credentials::GroupSessionIterator * DataProvider::IterateGroupSessions(FabricTable * fabrics, uint16_t session_id)
{
    VerifyOrReturnValue(IsInitialized(), nullptr);
    VerifyOrReturnValue(nullptr != fabrics, nullptr);
    return mSessionIterator.CreateObject(*this, *fabrics, *mKeyManager, session_id);
}

DataProvider::SessionIterator::SessionIterator(DataProvider & provider, FabricTable & fabrics, Credentials::KeyManager & keys, uint16_t session_id) :
    mProvider(provider), mFabrics(fabrics), mKeyManager(keys), mSessionId(session_id)
{
}

size_t DataProvider::SessionIterator::Count()
{
    size_t count = 0;
    Iterate all fabrics
    for(uint8_t i=0; mFabrics && (i < mFabrics->FabricCount()); ++i)
    {
        const FabricInfo *info = mFabrics->FindFabricWithIndex(i);
        if(info)
        {
            GroupList list(info->GetFabricIndex(), provider.mStorage);
            list.Load();
            

            mCount = list.Count();
            
            // Get the group list for the current fabric_index
            chip::Groupcast::GroupList list(info->GetFabricIndex(), mProvider.mStorage);
            Group entry(mGroupId);
            size_t index = 0;
            if(CHIP_NO_ERROR == list.Find(entry, index))
            {
                if(nullptr != group_data->GetKeyContext(mFabricIndex, entry.key_id)) {
                    count++;
                }
            }
        }
    }
    return count;
}

bool DataProvider::SessionIterator::Next(Credentials::GroupSession &output)
{
    // chip::Credentials::GroupDataProvider *group_data = chip::Credentials::GetGroupDataProvider();
    // // Iterate all fabrics
    // while (mFabrics && (mFabricIndex < mFabrics->FabricCount()))
    // {
    //     const FabricInfo *info = mFabrics->FindFabricWithIndex(mFabricIndex);
    //     if(info)
    //     {
    //         // Get the group list for the current fabric_index
    //         chip::Groupcast::GroupList list(info->GetFabricIndex(), mProvider.mStorage);
    //         Group entry(mGroupId);
    //         size_t index = 0;
    //         if(CHIP_NO_ERROR == list.Find(entry, index))
    //         {
    //             Crypto::SymmetricKeyContext *context = group_data->GetKeyContext(mFabricIndex, entry.key_id);
    //             VerifyOrReturnValue(nullptr != context, false);
    //             output.fabric_index = mFabricIndex;
    //             output.group_id = entry.group_id;
    //             output.keyContext = context;
    //             output.security_policy = Credentials::SecurityPolicy::kTrustFirst;
    //         }
    //     }
    //     // No group_id/session_id match in current fabric_index
    //     mFabricIndex++;
    //     mKeyIndex = 0;
    // }
    return false;
}

void DataProvider::SessionIterator::Release()
{
    mProvider.mSessionIterator.ReleaseObject(this);
}

namespace {

DataProvider * gGroupcastProvider = nullptr;

} // namespace

DataProvider * GetDataProvider()
{
    return gGroupcastProvider;
}

void SetDataProvider(DataProvider * provider)
{
    gGroupcastProvider = provider;
}

} // namespace Groupcast
} // namespace chip
