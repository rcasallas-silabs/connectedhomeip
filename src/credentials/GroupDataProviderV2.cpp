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
#include <credentials/GroupDataProviderV2.h>
#include <credentials/GroupDataProviderImpl.h>
#include <platform/KvsPersistentStorageDelegate.h>
#include <crypto/CHIPCryptoPAL.h>
#include <lib/core/TLV.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/CommonPersistentData.h>
#include <lib/support/DefaultStorageKeyAllocator.h>
#include <lib/support/PersistentData.h>
#include <lib/support/PersistentArray.h>
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

//
// FabricList
//

CHIP_ERROR GroupDataProviderV2::FabricList::UpdateKey(StorageKeyName & key)
{
    key = DefaultStorageKeyAllocator::GroupFabricList2();
    return CHIP_NO_ERROR;
}

void GroupDataProviderV2::FabricList::ClearEntry(FabricIndex & entry)
{
    entry = kUndefinedFabricIndex;
}

CHIP_ERROR GroupDataProviderV2::FabricList::Serialize(TLV::TLVWriter & writer, const FabricIndex & entry) const
{
    CHIP_ERROR err = writer.Put(FabricTag(), static_cast<uint16_t>(entry));
    ReturnErrorOnFailure(err);
    return CHIP_NO_ERROR;
}

CHIP_ERROR GroupDataProviderV2::FabricList::Deserialize(TLV::TLVReader & reader, FabricIndex & entry)
{
    ReturnErrorOnFailure(reader.Next(FabricTag()));
    ReturnErrorOnFailure(reader.Get(entry));
    return CHIP_NO_ERROR;
}

//
// GroupList
//

CHIP_ERROR GroupDataProviderV2::GroupList::UpdateKey(StorageKeyName & key)
{
    key = DefaultStorageKeyAllocator::FabricGroups2(this->mFabric);
    return CHIP_NO_ERROR;
}

void GroupDataProviderV2::GroupList::ClearEntry(GroupDataProvider::GroupInfo & entry)
{
    entry.group_id = kUndefinedGroupId;
}

bool GroupDataProviderV2::GroupList::Compare(const GroupDataProvider::GroupInfo & a, const GroupDataProvider::GroupInfo & b) const
{
    return a.group_id == b.group_id;
}

CHIP_ERROR GroupDataProviderV2::GroupList::Serialize(TLV::TLVWriter & writer, const GroupDataProvider::GroupInfo & entry) const
{
    // group_id
    ReturnErrorOnFailure(writer.Put(GroupTag(), static_cast<uint16_t>(entry.group_id)));
    // name
    size_t name_size = strnlen(entry.name, GroupDataProvider::GroupInfo::kGroupNameMax);
    ReturnErrorOnFailure(writer.PutString(NameTag(), entry.name, static_cast<uint32_t>(name_size)));
    return CHIP_NO_ERROR;
}

CHIP_ERROR GroupDataProviderV2::GroupList::Deserialize(TLV::TLVReader & reader, GroupDataProvider::GroupInfo & entry)
{
    // group_id
    ReturnErrorOnFailure(reader.Next(GroupTag()));
    ReturnErrorOnFailure(reader.Get(entry.group_id));
    // name
    ReturnErrorOnFailure(reader.Next(NameTag()));
    ReturnErrorOnFailure(reader.GetString(entry.name, sizeof(entry.name)));
    size_t size = strnlen(entry.name, GroupDataProvider::GroupInfo::kGroupNameMax);
    entry.name[size]  = 0;
    return CHIP_NO_ERROR;
}

void GroupDataProviderV2::GroupList::OnEntryAdded(const GroupDataProvider::GroupInfo & entry)
{
    if (mListener)
    {
        mListener->OnGroupAdded(mFabric, entry);
    }
}

void GroupDataProviderV2::GroupList::OnEntryRemoved(const GroupDataProvider::GroupInfo & entry)
{
    if (mListener)
    {
        mListener->OnGroupRemoved(mFabric, entry);
    }
}

//
// EndpointMap
//

CHIP_ERROR GroupDataProviderV2::EndpointMap::UpdateKey(StorageKeyName & key)
{
    VerifyOrReturnError(kUndefinedFabricIndex != mFabric, CHIP_ERROR_INVALID_FABRIC_INDEX);
    key = DefaultStorageKeyAllocator::FabricGroupEndpoints(mFabric);
    return CHIP_NO_ERROR;
}

void GroupDataProviderV2::EndpointMap::ClearEntry(GroupDataProvider::GroupEndpoint & entry)
{
    entry.group_id = kUndefinedGroupId;
    entry.endpoint_id = kInvalidEndpointId;
}

CHIP_ERROR GroupDataProviderV2::EndpointMap::Serialize(TLV::TLVWriter & writer, const GroupDataProvider::GroupEndpoint & entry) const
{
    // group_id
    ReturnErrorOnFailure(writer.Put(GroupIdTag(), static_cast<uint16_t>(entry.group_id)));
    // endpoint_id
    ReturnErrorOnFailure(writer.Put(EndpointIdTag(), static_cast<uint16_t>(entry.endpoint_id)));
    return CHIP_NO_ERROR;
}

CHIP_ERROR GroupDataProviderV2::EndpointMap::Deserialize(TLV::TLVReader & reader, GroupDataProvider::GroupEndpoint & entry)
{
    // group_id
    ReturnErrorOnFailure(reader.Next(GroupIdTag()));
    ReturnErrorOnFailure(reader.Get(entry.group_id));
    // endpoint_id
    ReturnErrorOnFailure(reader.Next(EndpointIdTag()));
    ReturnErrorOnFailure(reader.Get(entry.endpoint_id));
    return CHIP_NO_ERROR;
}

//
// KeysetMap
//

CHIP_ERROR GroupDataProviderV2::KeysetMap::UpdateKey(StorageKeyName & key)
{
    VerifyOrReturnError(kUndefinedFabricIndex != mFabric, CHIP_ERROR_INVALID_FABRIC_INDEX);
    key = DefaultStorageKeyAllocator::FabricGroupKeys(mFabric);
    return CHIP_NO_ERROR;
}

void GroupDataProviderV2::KeysetMap::ClearEntry(GroupDataProvider::GroupKey & entry)
{
    entry.group_id = kUndefinedGroupId;
    entry.keyset_id = 0;
}

CHIP_ERROR GroupDataProviderV2::KeysetMap::Serialize(TLV::TLVWriter & writer, const GroupDataProvider::GroupKey & entry) const
{
    // group_id
    ReturnErrorOnFailure(writer.Put(GroupIdTag(), static_cast<uint16_t>(entry.group_id)));
    // keyset_id
    ReturnErrorOnFailure(writer.Put(KeysetIdTag(), static_cast<uint16_t>(entry.keyset_id)));
    return CHIP_NO_ERROR;
}

CHIP_ERROR GroupDataProviderV2::KeysetMap::Deserialize(TLV::TLVReader & reader, GroupDataProvider::GroupKey & entry)
{
    // group_id
    ReturnErrorOnFailure(reader.Next(GroupIdTag()));
    ReturnErrorOnFailure(reader.Get(entry.group_id));
    // keyset_id
    ReturnErrorOnFailure(reader.Next(KeysetIdTag()));
    ReturnErrorOnFailure(reader.Get(entry.keyset_id));
    return CHIP_NO_ERROR;
}

//
// KeysetList
//

CHIP_ERROR GroupDataProviderV2::KeysetList::UpdateKey(StorageKeyName & key)
{
    VerifyOrReturnError(kUndefinedFabricIndex != mFabric, CHIP_ERROR_INVALID_FABRIC_INDEX);
    key = DefaultStorageKeyAllocator::FabricKeysets(mFabric);
    return CHIP_NO_ERROR;
}

void GroupDataProviderV2::KeysetList::ClearEntry(KeysetData & entry)
{
    entry.keyset_id = 0;
    entry.keys_count = 0;
    entry.policy     = GroupDataProvider::SecurityPolicy::kCacheAndSync;
    memset(entry.operational_keys, 0x00, sizeof(entry.operational_keys));
}
// KeysetIdTag(1) + sizeof(uint16_t) + TagPolicy(1) + sizeof(uint16_t) + NumKeysTag(1) + sizeof(uint16_t) +
// GroupCredentialsTag(1) + GroupDataProvider::KeySet::kEpochKeysMax * [ AnonymousTag(1)
//     StartTimeTag(1) + sizeof(uint64_t) + KeyHashTag(1) + sizeof(uint16_t) + KeyValueTag(1) + Crypto::CHIP_CRYPTO_SYMMETRIC_KEY_LENGTH_BYTES
// EndContainer(1) ] + EndContainer(1)
CHIP_ERROR GroupDataProviderV2::KeysetList::Serialize(TLV::TLVWriter & writer, const KeysetData & entry) const
{
    // keyset_id
    ReturnErrorOnFailure(writer.Put(KeysetIdTag(), static_cast<uint16_t>(entry.keyset_id)));
    // policy
    ReturnErrorOnFailure(writer.Put(PolicyTag(), static_cast<uint16_t>(entry.policy)));
    // keys_count
    ReturnErrorOnFailure(writer.Put(NumKeysTag(), static_cast<uint16_t>(entry.keys_count)));
    // operational_keys
    {
        TLV::TLVType array, item;
        ReturnErrorOnFailure(writer.StartContainer(GroupCredentialsTag(), TLV::kTLVType_Array, array));
        uint8_t keyCount   = 0;
        uint64_t startTime = 0;
        uint16_t hash      = 0;
        uint8_t encryptionKey[Crypto::CHIP_CRYPTO_SYMMETRIC_KEY_LENGTH_BYTES];
        for (auto & key : entry.operational_keys)
        {
            ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, item));
            if (keyCount++ < entry.keys_count)
            {
                startTime = key.start_time;
                hash      = key.hash;
                memcpy(encryptionKey, key.encryption_key, sizeof(encryptionKey));
            }
            else
            {
                startTime = 0;
                hash      = 0;
                memset(encryptionKey, 0, sizeof(encryptionKey));
            }
            ReturnErrorOnFailure(writer.Put(StartTimeTag(), static_cast<uint64_t>(startTime)));
            ReturnErrorOnFailure(writer.Put(KeyHashTag(), hash));
            ReturnErrorOnFailure(writer.Put(KeyValueTag(), ByteSpan(encryptionKey)));

            ReturnErrorOnFailure(writer.EndContainer(item));
        }
        ReturnErrorOnFailure(writer.EndContainer(array));
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR GroupDataProviderV2::KeysetList::Deserialize(TLV::TLVReader & reader, KeysetData & entry)
{
    // keyset_id
    ReturnErrorOnFailure(reader.Next(KeysetIdTag()));
    ReturnErrorOnFailure(reader.Get(entry.keyset_id));
    // policy
    ReturnErrorOnFailure(reader.Next(PolicyTag()));
    ReturnErrorOnFailure(reader.Get(entry.policy));
    // keys_count
    ReturnErrorOnFailure(reader.Next(NumKeysTag()));
    ReturnErrorOnFailure(reader.Get(entry.keys_count));
    // TODO(#21614): Enforce maximum number of 3 keys in a keyset
    {
        // operational_keys
        ReturnErrorOnFailure(reader.Next(GroupCredentialsTag()));
        VerifyOrReturnError(TLV::kTLVType_Array == reader.GetType(), CHIP_ERROR_INTERNAL);

        TLV::TLVType array, item;
        ReturnErrorOnFailure(reader.EnterContainer(array));
        for (auto & key : entry.operational_keys)
        {
            ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
            VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

            ReturnErrorOnFailure(reader.EnterContainer(item));
            // start_time
            ReturnErrorOnFailure(reader.Next(StartTimeTag()));
            ReturnErrorOnFailure(reader.Get(key.start_time));
            // key hash
            ReturnErrorOnFailure(reader.Next(KeyHashTag()));
            ReturnErrorOnFailure(reader.Get(key.hash));
            // key value
            ByteSpan encryption_key;
            ReturnErrorOnFailure(reader.Next(KeyValueTag()));
            ReturnErrorOnFailure(reader.Get(encryption_key));
            VerifyOrReturnError(Crypto::CHIP_CRYPTO_SYMMETRIC_KEY_LENGTH_BYTES == encryption_key.size(), CHIP_ERROR_INTERNAL);
            memcpy(key.encryption_key, encryption_key.data(), encryption_key.size());
            // Re-derive privacy key from encryption key when loading from storage to save on storage size.
            MutableByteSpan privacy_key(key.privacy_key);
            ReturnErrorOnFailure(Crypto::DeriveGroupPrivacyKey(encryption_key, privacy_key));
            ReturnErrorOnFailure(reader.ExitContainer(item));
        }
        ReturnErrorOnFailure(reader.ExitContainer(array));
    }

    return CHIP_NO_ERROR;
}

//
// General
//

constexpr size_t GroupDataProvider::GroupInfo::kGroupNameMax;
constexpr size_t GroupDataProviderV2::kIteratorsMax;

CHIP_ERROR GroupDataProviderV2::Init()
{
    if (mStorage == nullptr || mSessionKeystore == nullptr)
    {
        return CHIP_ERROR_INCORRECT_STATE;
    }
    return CHIP_NO_ERROR;
}

void GroupDataProviderV2::Finish()
{
    mGroupInfoIterators.ReleaseAll();
    mGroupKeyIterators.ReleaseAll();
    mEndpointIterators.ReleaseAll();
    mKeySetIterators.ReleaseAll();
    mGroupSessionsIterator.ReleaseAll();
    mGroupKeyContexPool.ReleaseAll();
}

//
// Group Info
//

CHIP_ERROR GroupDataProviderV2::SetGroupInfo(chip::FabricIndex fabric_index, const GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);
    
    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index, true));

    GroupList groups(mStorage, mListener, fabric_index);
    return groups.Add(info, true);
}

CHIP_ERROR GroupDataProviderV2::GetGroupInfo(chip::FabricIndex fabric_index, chip::GroupId group_id, GroupInfo & info)
{
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));

    GroupList groups(mStorage, mListener, fabric_index);
    info.group_id = group_id;
    ReturnErrorOnFailure(groups.Find(info, found_index));
    return CHIP_NO_ERROR;
}

CHIP_ERROR GroupDataProviderV2::RemoveGroupInfo(chip::FabricIndex fabric_index, chip::GroupId group_id)
{
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));

    GroupList groups(mStorage, mListener, fabric_index);
    GroupInfo info(group_id, nullptr);
    return groups.Remove(info);
}

CHIP_ERROR GroupDataProviderV2::SetGroupInfoAt(chip::FabricIndex fabric_index, size_t index, const GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index, true));

    GroupList groups(mStorage, mListener, fabric_index);
    // If the group exists, the index must match
    GroupInfo temp = info;
    bool found = CHIP_NO_ERROR == groups.Find(temp, found_index);
    VerifyOrReturnError(!found || (found_index == index), CHIP_ERROR_DUPLICATE_KEY_ID);

    return groups.Set(index, info);
}

CHIP_ERROR GroupDataProviderV2::GetGroupInfoAt(chip::FabricIndex fabric_index, size_t index, GroupInfo & info)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));

    GroupList groups(mStorage, mListener, fabric_index);
    return groups.Get(index, info);
}

CHIP_ERROR GroupDataProviderV2::RemoveGroupInfoAt(chip::FabricIndex fabric_index, size_t index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));

    GroupList groups(mStorage, mListener, fabric_index);
    return groups.Remove(index);
}

bool GroupDataProviderV2::HasEndpoint(chip::FabricIndex fabric_index, chip::GroupId group_id, chip::EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), false);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, false);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    VerifyOrReturnError(CHIP_NO_ERROR == fabrics.Find(fabric_index, found_index), false);

    EndpointMap endpoints(mStorage, fabric_index);
    GroupEndpoint mapping = { group_id, endpoint_id };
    return (CHIP_NO_ERROR == endpoints.Find(mapping, found_index));
}

CHIP_ERROR GroupDataProviderV2::AddEndpoint(chip::FabricIndex fabric_index, chip::GroupId group_id, chip::EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index, true));

    EndpointMap endpoints(mStorage, fabric_index);
    GroupEndpoint mapping = { group_id, endpoint_id };
    endpoints.Load();
    return endpoints.Add(mapping, true);
}

CHIP_ERROR GroupDataProviderV2::RemoveEndpoint(chip::FabricIndex fabric_index, chip::GroupId group_id,
                                                 chip::EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index, true));

    EndpointMap endpoints(mStorage, fabric_index);
    GroupEndpoint mapping = { group_id, endpoint_id };
    ReturnErrorOnFailure(endpoints.Find(mapping, found_index));
    return endpoints.Remove(found_index);
}

CHIP_ERROR GroupDataProviderV2::RemoveEndpoint(chip::FabricIndex fabric_index, chip::EndpointId endpoint_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index, true));

    EndpointMap endpoints(mStorage, fabric_index);
    GroupEndpoint mapping;
    ReturnErrorOnFailure(endpoints.Load());
    for(uint16_t i = endpoints.Count(); i > 0; i--)
    {
        ReturnErrorOnFailure(endpoints.Get(i - 1, mapping));
        if(endpoint_id == mapping.endpoint_id)
        {
            ReturnErrorOnFailure(endpoints.Remove(i - 1));
        }
    }
    return CHIP_NO_ERROR;
}

CHIP_ERROR GroupDataProviderV2::RemoveEndpoints(chip::FabricIndex fabric_index, chip::GroupId group_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index, true));

    EndpointMap endpoints(mStorage, fabric_index);
    endpoints.Clear();
    return endpoints.Save();
}

GroupDataProvider::GroupInfoIterator * GroupDataProviderV2::IterateGroupInfo(chip::FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupInfoIterators.CreateObject(*this, fabric_index);
}

GroupDataProviderV2::GroupInfoIteratorImpl::GroupInfoIteratorImpl(GroupDataProviderV2 & provider,
                                                                    chip::FabricIndex fabric_index) :
    mProvider(provider),
    mFabrics(provider.mStorage),
    mGroups(provider.mStorage, nullptr, fabric_index),
    mIndex(0)
{
    size_t found_index = 0;
    if(CHIP_NO_ERROR == mFabrics.Find(fabric_index, found_index))
    {
        mGroups.Load();
    }
}

size_t GroupDataProviderV2::GroupInfoIteratorImpl::Count()
{
    return mGroups.Count();
}

bool GroupDataProviderV2::GroupInfoIteratorImpl::Next(GroupInfo & output)
{
    VerifyOrReturnError(mIndex < mGroups.Count(), false);
    return CHIP_NO_ERROR == mGroups.Get(mIndex++, output);
}

void GroupDataProviderV2::GroupInfoIteratorImpl::Release()
{
    mProvider.mGroupInfoIterators.ReleaseObject(this);
}

GroupDataProvider::EndpointIterator * GroupDataProviderV2::IterateEndpoints(chip::FabricIndex fabric_index,
                                                                              std::optional<GroupId> group_id)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mEndpointIterators.CreateObject(*this, fabric_index, group_id);
}

GroupDataProviderV2::EndpointIteratorImpl::EndpointIteratorImpl(GroupDataProviderV2 & provider, chip::FabricIndex fabric_index,
                                                                  std::optional<GroupId> group_id) :
    mProvider(provider),
    mFabrics(provider.mStorage),
    mEndpoints(provider.mStorage, fabric_index),
    mIndex(0)
{
    size_t found_index = 0;
    if(CHIP_NO_ERROR == mFabrics.Find(fabric_index, found_index))
    {
        mEndpoints.Load();
    }
}

size_t GroupDataProviderV2::EndpointIteratorImpl::Count()
{
    return mEndpoints.Count();
}

bool GroupDataProviderV2::EndpointIteratorImpl::Next(GroupEndpoint & output)
{
    VerifyOrReturnError(mIndex < mEndpoints.Count(), false);
    return CHIP_NO_ERROR == mEndpoints.Get(mIndex++, output);
}

void GroupDataProviderV2::EndpointIteratorImpl::Release()
{
    mProvider.mEndpointIterators.ReleaseObject(this);
}

//
// KeySet map
//

CHIP_ERROR GroupDataProviderV2::SetGroupKeyAt(chip::FabricIndex fabric_index, size_t index, const GroupKey & in_map)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index, true));

    KeysetMap keysets(mStorage, fabric_index);
    // If the mapping exists, the index must match
    GroupKey temp = in_map;
    bool found = CHIP_NO_ERROR == keysets.Find(temp, found_index);
    VerifyOrReturnError(!found || (found_index == index), CHIP_ERROR_DUPLICATE_KEY_ID);

    return keysets.Set(index, in_map);
}

CHIP_ERROR GroupDataProviderV2::GetGroupKeyAt(chip::FabricIndex fabric_index, size_t index, GroupKey & out_map)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));

    KeysetMap keysets(mStorage, fabric_index);
    return keysets.Get(index, out_map);
}

CHIP_ERROR GroupDataProviderV2::RemoveGroupKeyAt(chip::FabricIndex fabric_index, size_t index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));

    KeysetMap keysets(mStorage, fabric_index);
    return keysets.Remove(index);
}

CHIP_ERROR GroupDataProviderV2::RemoveGroupKeys(chip::FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));

    KeysetMap keysets(mStorage, fabric_index);
    keysets.Clear();
    return keysets.Save();
}

GroupDataProvider::GroupKeyIterator * GroupDataProviderV2::IterateGroupKeys(chip::FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupKeyIterators.CreateObject(*this, fabric_index);
}

GroupDataProviderV2::GroupKeyIteratorImpl::GroupKeyIteratorImpl(GroupDataProviderV2 & provider,
                                                                  chip::FabricIndex fabric_index) :
    mProvider(provider),
    mFabrics(provider.mStorage),
    mKeysets(provider.mStorage, fabric_index),
    mIndex(0)
{
    size_t found_index = 0;
    if(CHIP_NO_ERROR == mFabrics.Find(fabric_index, found_index))
    {
        mKeysets.Load();
    }
}

size_t GroupDataProviderV2::GroupKeyIteratorImpl::Count()
{
    return mKeysets.Count();
}

bool GroupDataProviderV2::GroupKeyIteratorImpl::Next(GroupKey & output)
{
    VerifyOrReturnError(mIndex < mKeysets.Count(), false);
    return CHIP_NO_ERROR == mKeysets.Get(mIndex++, output);
}

void GroupDataProviderV2::GroupKeyIteratorImpl::Release()
{
    mProvider.mGroupKeyIterators.ReleaseObject(this);
}

//
// Key Sets
//

constexpr size_t GroupDataProvider::EpochKey::kLengthBytes;

CHIP_ERROR GroupDataProviderV2::SetKeySet(chip::FabricIndex fabric_index, const ByteSpan & compressed_fabric_id,
                                            const KeySet & in_keyset)
{
    if(6 == fabric_index)
    {
        ChipLogDetail(DeviceLayer, "GroupDataProviderV2::SetKeySet");
    }
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index, true));

    KeysetList keysets(mStorage, fabric_index);
    KeysetData keyset;
    keyset.keyset_id = in_keyset.keyset_id;
    bool found = CHIP_NO_ERROR == keysets.Find(keyset, found_index);

    keyset.keyset_id  = in_keyset.keyset_id;
    keyset.policy     = in_keyset.policy;
    keyset.keys_count = in_keyset.num_keys_used;
    memset(keyset.operational_keys, 0x00, sizeof(keyset.operational_keys));
    keyset.operational_keys[0].start_time = in_keyset.epoch_keys[0].start_time;
    keyset.operational_keys[1].start_time = in_keyset.epoch_keys[1].start_time;
    keyset.operational_keys[2].start_time = in_keyset.epoch_keys[2].start_time;

    // Store the operational keys and hash instead of the epoch keys
    for (size_t i = 0; i < in_keyset.num_keys_used; ++i)
    {
        ByteSpan epoch_key(in_keyset.epoch_keys[i].key, Crypto::CHIP_CRYPTO_SYMMETRIC_KEY_LENGTH_BYTES);
        ReturnErrorOnFailure(
            Crypto::DeriveGroupOperationalCredentials(epoch_key, compressed_fabric_id, keyset.operational_keys[i]));
    }

    if (found)
    {
        // Update existing keyset info, keep next
        return keysets.Set(found_index, keyset);
    }
    else
    {
        // New keyset
        VerifyOrReturnError(keysets.Count() < mMaxGroupKeysPerFabric, CHIP_ERROR_INVALID_LIST_LENGTH);
        return keysets.Add(keyset);
    }
}

CHIP_ERROR GroupDataProviderV2::GetKeySet(chip::FabricIndex fabric_index, uint16_t target_id, KeySet & out_keyset)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));

    KeysetList keysets(mStorage, fabric_index);
    KeysetData keyset;
    keyset.keyset_id = target_id;
    VerifyOrReturnError(CHIP_NO_ERROR == keysets.Find(keyset, found_index), CHIP_ERROR_NOT_FOUND);

    // Target keyset found
    out_keyset.ClearKeys();
    out_keyset.keyset_id     = keyset.keyset_id;
    out_keyset.policy        = keyset.policy;
    out_keyset.num_keys_used = keyset.keys_count;
    // Epoch keys are not read back, only start times
    out_keyset.epoch_keys[0].start_time = keyset.operational_keys[0].start_time;
    out_keyset.epoch_keys[1].start_time = keyset.operational_keys[1].start_time;
    out_keyset.epoch_keys[2].start_time = keyset.operational_keys[2].start_time;

    return CHIP_NO_ERROR;
}

CHIP_ERROR GroupDataProviderV2::RemoveKeySet(chip::FabricIndex fabric_index, uint16_t target_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));

    KeysetList keysets(mStorage, fabric_index);
    KeysetData keyset;
    keyset.keyset_id = target_id;
    ReturnErrorOnFailure(keysets.Find(keyset, found_index));
    keysets.Remove(found_index);
    return CHIP_NO_ERROR;
}

GroupDataProvider::KeySetIterator * GroupDataProviderV2::IterateKeySets(chip::FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mKeySetIterators.CreateObject(*this, fabric_index);
}

GroupDataProviderV2::KeySetIteratorImpl::KeySetIteratorImpl(GroupDataProviderV2 & provider, chip::FabricIndex fabric_index) :
    mProvider(provider),
    mFabrics(provider.mStorage),
    mKeysets(provider.mStorage, fabric_index),
    mIndex(0)
{
    size_t found_index = 0;
    if(CHIP_NO_ERROR == mFabrics.Find(fabric_index, found_index))
    {
        mKeysets.Load();
    }
}

size_t GroupDataProviderV2::KeySetIteratorImpl::Count()
{
    return mKeysets.Count();
}

bool GroupDataProviderV2::KeySetIteratorImpl::Next(KeySet & output)
{
    KeysetData keyset;
    VerifyOrReturnError(mIndex < mKeysets.Count(), false);
    VerifyOrReturnError(CHIP_NO_ERROR == mKeysets.Get(mIndex++, keyset), false);
    output.ClearKeys();
    output.keyset_id     = keyset.keyset_id;
    output.policy        = keyset.policy;
    output.num_keys_used = keyset.keys_count;
    // Epoch keys are not read back, only start times
    output.epoch_keys[0].start_time = keyset.operational_keys[0].start_time;
    output.epoch_keys[1].start_time = keyset.operational_keys[1].start_time;
    output.epoch_keys[2].start_time = keyset.operational_keys[2].start_time;
    return true;
}

void GroupDataProviderV2::KeySetIteratorImpl::Release()
{
    mProvider.mKeySetIterators.ReleaseObject(this);
}

//
// Fabrics
//

CHIP_ERROR GroupDataProviderV2::RemoveFabric(chip::FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);
    VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);

    size_t found_index = 0;
    FabricList fabrics(mStorage);
    ReturnErrorOnFailure(fabrics.Find(fabric_index, found_index));
    // Group Info
    GroupList groups(mStorage, mListener, fabric_index);
    ReturnErrorOnFailure(groups.Load());
    for(uint16_t i = groups.Count(); i > 0; i--)
    {
        groups.Remove(i - 1);
    }
    // Group Endpoints
    EndpointMap endpoints(mStorage, fabric_index);
    ReturnErrorOnFailure(endpoints.Load());
    for(uint16_t i = endpoints.Count(); i > 0; i--)
    {
        endpoints.Remove(i - 1);
    }
    // Keyset Map
    KeysetMap keysmap(mStorage, fabric_index);
    ReturnErrorOnFailure(keysmap.Load());
    for(uint16_t i = keysmap.Count(); i > 0; i--)
    {
        keysmap.Remove(i - 1);
    }
    // Keyset List
    KeysetList keysets(mStorage, fabric_index);
    ReturnErrorOnFailure(keysets.Load());
    for(uint16_t i = keysets.Count(); i > 0; i--)
    {
        keysets.Remove(i - 1);
    }
    fabrics.Remove(found_index);
    return CHIP_NO_ERROR;
}

//
// Cryptography
//

Crypto::SymmetricKeyContext * GroupDataProviderV2::GetKeyContext(FabricIndex fabric_index, GroupId group_id)
{
    size_t found_index = 0;
    FabricList fabrics(mStorage);
    VerifyOrReturnError(CHIP_NO_ERROR == fabrics.Find(fabric_index, found_index), nullptr);

    KeysetMap mappings(mStorage, fabric_index);
    VerifyOrReturnError(CHIP_NO_ERROR == mappings.Load(), nullptr);
    GroupKey mapping;

    // Look for the target group in the fabric's keyset-group pairs
    for (uint16_t i = 0; i < mappings.Count(); ++i)
    {
        VerifyOrReturnError(CHIP_NO_ERROR == mappings.Get(i, mapping), nullptr);
        // GroupKeySetID of 0 is reserved for the Identity Protection Key (IPK),
        // it cannot be used for operational group communication.
        if (mapping.keyset_id > 0 && mapping.group_id == group_id)
        {
            // Group found, get the keyset
            KeysetList keysets(mStorage, fabric_index);
            KeysetData keyset;
            keyset.keyset_id = mapping.keyset_id;
            VerifyOrReturnError(CHIP_NO_ERROR == keysets.Find(keyset, found_index), nullptr);
            Crypto::GroupOperationalCredentials * creds = keyset.GetCurrentGroupCredentials();
            if (nullptr != creds)
            {
                return mGroupKeyContexPool.CreateObject(*this, creds->encryption_key, creds->hash, creds->privacy_key);
            }
        }
    }
    return nullptr;
}

CHIP_ERROR GroupDataProviderV2::GetIpkKeySet(FabricIndex fabric_index, KeySet & out_keyset)
{
    size_t found_index = 0;
    FabricList fabrics(mStorage);
    VerifyOrReturnError(CHIP_NO_ERROR == fabrics.Find(fabric_index, found_index), CHIP_ERROR_NOT_FOUND);

    // Fabric found, get the keyset
    KeysetList keysets(mStorage, fabric_index);
    KeysetData keyset;
    keyset.keyset_id = kIdentityProtectionKeySetId;

    VerifyOrReturnError(CHIP_NO_ERROR == keysets.Find(keyset, found_index), CHIP_ERROR_NOT_FOUND);

    // If the keyset ID doesn't match, we have a ... problem.
    VerifyOrReturnError(keyset.keyset_id == kIdentityProtectionKeySetId, CHIP_ERROR_INTERNAL);

    out_keyset.keyset_id     = keyset.keyset_id;
    out_keyset.num_keys_used = keyset.keys_count;
    out_keyset.policy        = keyset.policy;

    for (size_t key_idx = 0; key_idx < ArraySize(out_keyset.epoch_keys); ++key_idx)
    {
        out_keyset.epoch_keys[key_idx].Clear();
        if (key_idx < keyset.keys_count)
        {
            out_keyset.epoch_keys[key_idx].start_time = keyset.operational_keys[key_idx].start_time;
            memcpy(&out_keyset.epoch_keys[key_idx].key[0], keyset.operational_keys[key_idx].encryption_key, EpochKey::kLengthBytes);
        }
    }

    return CHIP_NO_ERROR;
}

GroupDataProviderV2::GroupSessionIterator * GroupDataProviderV2::IterateGroupSessions(uint16_t session_id)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupSessionsIterator.CreateObject(*this, session_id);
}

GroupDataProviderV2::GroupSessionIteratorImpl::GroupSessionIteratorImpl(GroupDataProviderV2 & provider, uint16_t session_id) :
        mProvider(provider),
        mGroupKeyContext(provider),
        mSessionId(session_id),
        mFabricIndex(0),
        mMapIndex(0),
        mSetIndex(0),
        mKeyIndex(0),
        mFabrics(provider.mStorage),
        mKeymaps(provider.mStorage, kUndefinedFabricIndex),
        mKeysets(provider.mStorage, kUndefinedFabricIndex)
{
    if(CHIP_NO_ERROR == mFabrics.Load())
    {
        FabricIndex & fabric_index = mFabrics.At(mFabricIndex);
        mKeymaps.mFabric = fabric_index;
        mKeymaps.Load();
        mKeysets.mFabric = fabric_index;
        mKeysets.Load();
    }
}

size_t GroupDataProviderV2::GroupSessionIteratorImpl::Count()
{
    size_t count = 0;

    for (size_t f = 0; f < mFabrics.Count(); f++)
    {
        FabricIndex & fabric_index = mFabrics.At(f);

        // Iterate key sets
        KeysetMap keymaps(mProvider.mStorage, fabric_index);
        KeysetList keysets(mProvider.mStorage, fabric_index);
        if ((CHIP_NO_ERROR == keymaps.Load()) && (CHIP_NO_ERROR == keysets.Load()))
        {
            for (size_t m = 0; m < keymaps.Count(); m++)
            {
                GroupKey & mapping = keymaps.At(m);
                for (size_t k = 0; k < keysets.Count(); k++)
                {
                    KeysetData &keyset = keysets.At(k);
                    if ((keyset.keyset_id == mapping.keyset_id) && (keyset.operational_keys[k].hash == mSessionId))
                    {
                        count++;
                    }
                }
            }
        }        
    }
    return count;
}

bool GroupDataProviderV2::GroupSessionIteratorImpl::Next(GroupSession & output)
{
    while (mFabricIndex < mFabrics.Count())
    {
        FabricIndex & fabric_index = mFabrics.At(mFabricIndex);
        mKeymaps.mFabric = fabric_index;
        mKeymaps.Load(mLoad);
        mKeysets.mFabric = fabric_index;
        mKeysets.Load(mLoad);
        mLoad = false;

        if(mMapIndex >= mKeymaps.Count())
        {
            mFabricIndex++;
            mMapIndex = 0;
            mSetIndex = 0;
            mKeyIndex = 0;
            mLoad = true;
            continue;
        }

        GroupKey & mapping = mKeymaps.At(mMapIndex);
        if(mSetIndex >= mKeysets.Count())
        {
            mMapIndex++;
            mSetIndex = 0;
            mKeyIndex = 0;
            continue;
        }

        KeysetData & keyset = mKeysets.At(mSetIndex);
        if(mKeyIndex >= keyset.keys_count)
        {
            mSetIndex++;
            mKeyIndex = 0;
            continue;
        }

        Crypto::GroupOperationalCredentials & creds = keyset.operational_keys[mKeyIndex++];
        if ((keyset.keyset_id == mapping.keyset_id) && (creds.hash == mSessionId))
        {
            mGroupKeyContext.Initialize(creds.encryption_key, mSessionId, creds.privacy_key);
            output.fabric_index    = fabric_index;
            output.group_id        = mapping.group_id;
            output.security_policy = keyset.policy;
            output.keyContext      = &mGroupKeyContext;
            return true;
        }
    }
    return false;
}

void GroupDataProviderV2::GroupSessionIteratorImpl::Release()
{
    mGroupKeyContext.ReleaseKeys();
    mProvider.mGroupSessionsIterator.ReleaseObject(this);
}

void GroupDataProviderV2::Debug()
{
    FabricList fabrics(mStorage);
    fabrics.Load();
    ChipLogProgress(Zcl, "~~~ GROUP FABRICS+(%u)", (unsigned) fabrics.Count());
    for (size_t i = 0; i < fabrics.Count(); i++)
    {
        DebugFabric(fabrics.At(i));
    }
}


} // namespace Credentials
} // namespace chip
