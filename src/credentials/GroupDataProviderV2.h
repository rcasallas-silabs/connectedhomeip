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

#include <credentials/GroupDataProviderBase.h>
#include <crypto/SessionKeystore.h>
#include <lib/core/CHIPPersistentStorageDelegate.h>
#include <lib/core/DataModelTypes.h>
#include <lib/support/PersistentArray.h>
#include <lib/support/Pool.h>

namespace chip {
namespace Credentials {


class GroupDataProviderV2 : public GroupDataProviderBase
{
public:
    static constexpr size_t kIteratorsMax = CHIP_CONFIG_MAX_GROUP_CONCURRENT_ITERATORS;

    GroupDataProviderV2() = default;
    GroupDataProviderV2(uint16_t maxGroupsPerFabric, uint16_t maxGroupKeysPerFabric) :
        GroupDataProviderBase(maxGroupsPerFabric, maxGroupKeysPerFabric) {}

    CHIP_ERROR Init() override;
    void Finish() override;

    //
    // Group Info
    //

    // By id
    CHIP_ERROR SetGroupInfo(FabricIndex fabric_index, const GroupInfo & info) override;
    CHIP_ERROR GetGroupInfo(FabricIndex fabric_index, GroupId group_id, GroupInfo & info) override;
    CHIP_ERROR RemoveGroupInfo(FabricIndex fabric_index, GroupId group_id) override;
    // By index
    CHIP_ERROR SetGroupInfoAt(FabricIndex fabric_index, size_t index, const GroupInfo & info) override;
    CHIP_ERROR GetGroupInfoAt(FabricIndex fabric_index, size_t index, GroupInfo & info) override;
    CHIP_ERROR RemoveGroupInfoAt(FabricIndex fabric_index, size_t index) override;
    // Endpoints
    bool HasEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id) override;
    CHIP_ERROR AddEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id) override;
    CHIP_ERROR RemoveEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id) override;
    CHIP_ERROR RemoveEndpoint(FabricIndex fabric_index, EndpointId endpoint_id) override;
    CHIP_ERROR RemoveEndpoints(FabricIndex fabric_index, GroupId group_id) override;
    // Iterators
    GroupInfoIterator * IterateGroupInfo(FabricIndex fabric_index) override;
    EndpointIterator * IterateEndpoints(FabricIndex fabric_index, std::optional<GroupId> group_id = std::nullopt) override;

    //
    // Group-Key map
    //

    CHIP_ERROR SetGroupKeyAt(FabricIndex fabric_index, size_t index, const GroupKey & info) override;
    CHIP_ERROR GetGroupKeyAt(FabricIndex fabric_index, size_t index, GroupKey & info) override;
    CHIP_ERROR RemoveGroupKeyAt(FabricIndex fabric_index, size_t index) override;
    CHIP_ERROR RemoveGroupKeys(FabricIndex fabric_index) override;
    GroupKeyIterator * IterateGroupKeys(FabricIndex fabric_index) override;

    //
    // Key Sets
    //

    CHIP_ERROR SetKeySet(FabricIndex fabric_index, const ByteSpan & compressed_fabric_id, const KeySet & keys) override;
    CHIP_ERROR GetKeySet(FabricIndex fabric_index, chip::KeysetId keyset_id, KeySet & keys) override;
    CHIP_ERROR RemoveKeySet(FabricIndex fabric_index, chip::KeysetId keyset_id) override;
    CHIP_ERROR GetIpkKeySet(FabricIndex fabric_index, KeySet & out_keyset) override;
    KeySetIterator * IterateKeySets(FabricIndex fabric_index) override;

    // Fabrics
    CHIP_ERROR RemoveFabric(FabricIndex fabric_index) override;

    // Decryption
    Crypto::SymmetricKeyContext * GetKeyContext(FabricIndex fabric_index, GroupId group_id) override;
    GroupSessionIterator * IterateGroupSessions(uint16_t session_id) override;

    void Debug() override;

protected:
    static constexpr size_t kFabricListListMax = CHIP_CONFIG_MAX_FABRICS;
    static constexpr size_t kFabricSerializedMax = 1 + sizeof(FabricIndex); // FabricTag(1) + sizeof(FabricIndex)

    struct FabricList: public PersistentArray<kFabricListListMax, kFabricSerializedMax, FabricIndex> {

        static constexpr TLV::Tag FabricTag() { return TLV::ContextTag(11); }

        FabricList(PersistentStorageDelegate * storage): PersistentArray<kFabricListListMax, kFabricSerializedMax, FabricIndex>(storage) {}
        CHIP_ERROR UpdateKey(StorageKeyName & key) override;
        void ClearEntry(FabricIndex & entry) override;
        CHIP_ERROR Serialize(TLV::TLVWriter & writer, const FabricIndex & entry) const override;
        CHIP_ERROR Deserialize(TLV::TLVReader & reader, FabricIndex & entry) override;
    };


    static constexpr size_t kGroupListListMax = CHIP_CONFIG_MAX_GROUPS_PER_FABRIC;
    static constexpr size_t kGroupSerializedMax = 2 + sizeof(GroupDataProvider::GroupInfo); // GroupTag(1) + NameTag(1) + sizeof(GroupInfo);
    struct GroupList: public PersistentArray<kGroupListListMax, kGroupSerializedMax, GroupDataProvider::GroupInfo>
    {
        static constexpr TLV::Tag GroupTag() { return TLV::ContextTag(11); }
        static constexpr TLV::Tag NameTag() { return TLV::ContextTag(12); }

        GroupList(PersistentStorageDelegate * storage,
                GroupDataProvider::GroupListener * listener,
                FabricIndex fabric):
            PersistentArray<kGroupListListMax, kGroupSerializedMax, GroupDataProvider::GroupInfo>(storage),
            mFabric(fabric), mListener(listener) {}

        CHIP_ERROR UpdateKey(StorageKeyName & key) override;
        void ClearEntry(GroupDataProvider::GroupInfo & entry) override;
        bool Compare(const GroupDataProvider::GroupInfo & a, const GroupDataProvider::GroupInfo & b) const override;
        CHIP_ERROR Serialize(TLV::TLVWriter & writer, const GroupDataProvider::GroupInfo & entry) const override;
        CHIP_ERROR Deserialize(TLV::TLVReader & reader, GroupDataProvider::GroupInfo & entry) override;
        void OnEntryAdded(const GroupDataProvider::GroupInfo & entry) override;
        void OnEntryRemoved(const GroupDataProvider::GroupInfo & entry) override;

        FabricIndex mFabric;
    private:
        GroupDataProvider::GroupListener *mListener = nullptr;
    };


    static constexpr size_t kEndpointMapMax = CHIP_CONFIG_MAX_GROUP_ENDPOINTS_PER_FABRIC  * CHIP_CONFIG_MAX_FABRICS;
    static constexpr size_t kEndpointSerializedMax = 2 + sizeof(GroupDataProvider::GroupEndpoint); // GroupIdTag(1) + EndpointIdTag(1) + sizeof(GroupEndpoint)

    struct EndpointMap: public PersistentArray<kEndpointMapMax, kEndpointSerializedMax, GroupDataProvider::GroupEndpoint>
    {
        static constexpr TLV::Tag GroupIdTag() { return TLV::ContextTag(11); }
        static constexpr TLV::Tag EndpointIdTag() { return TLV::ContextTag(12); }

        EndpointMap(PersistentStorageDelegate * storage,
                FabricIndex fabric):
            PersistentArray<kEndpointMapMax, kEndpointSerializedMax, GroupDataProvider::GroupEndpoint>(storage),
            mFabric(fabric) {}

        CHIP_ERROR UpdateKey(StorageKeyName & key) override;
        void ClearEntry(GroupDataProvider::GroupEndpoint & entry) override;
        // bool Compare(const GroupDataProvider::GroupEndpoint & a, const GroupDataProvider::GroupEndpoint & b) const override;
        CHIP_ERROR Serialize(TLV::TLVWriter & writer, const GroupDataProvider::GroupEndpoint & entry) const override;
        CHIP_ERROR Deserialize(TLV::TLVReader & reader, GroupDataProvider::GroupEndpoint & entry) override;

        FabricIndex mFabric;
    };


    static constexpr size_t kKeymapListMax = CHIP_CONFIG_MAX_GROUP_KEYS_PER_FABRIC * CHIP_CONFIG_MAX_FABRICS;
    static constexpr size_t kKeymapSerializedMax = 2 + sizeof(GroupDataProvider::GroupKey); // GroupIdTag(1) + KeysetIdTag(1) + sizeof(GroupKey)

    struct KeysetMap: public PersistentArray<kKeymapListMax, kKeymapSerializedMax, GroupDataProvider::GroupKey>
    {
        static constexpr TLV::Tag GroupIdTag() { return TLV::ContextTag(11); }
        static constexpr TLV::Tag KeysetIdTag() { return TLV::ContextTag(12); }

        KeysetMap(PersistentStorageDelegate * storage, FabricIndex fabric):
            PersistentArray<kKeymapListMax, kKeymapSerializedMax, GroupDataProvider::GroupKey>(storage),
            mFabric(fabric) {}

        CHIP_ERROR UpdateKey(StorageKeyName & key) override;
        void ClearEntry(GroupDataProvider::GroupKey & entry) override;
        // bool Compare(const GroupDataProvider::GroupKey & a, const GroupDataProvider::GroupKey & b) const override;
        CHIP_ERROR Serialize(TLV::TLVWriter & writer, const GroupDataProvider::GroupKey & entry) const override;
        CHIP_ERROR Deserialize(TLV::TLVReader & reader, GroupDataProvider::GroupKey & entry) override;

        FabricIndex mFabric;
    };

    struct KeysetData
    {
        KeysetData() = default;
        KeysetData(chip::KeysetId id) { keyset_id = id; }
        KeysetData(chip::KeysetId id, GroupDataProvider::SecurityPolicy policy_id, uint8_t num_keys) :
            keyset_id(id), policy(policy_id), keys_count(num_keys)
        {}

        bool operator==(const KeysetData & other) const
        {
            return this->keyset_id == other.keyset_id;
        }
    
        Crypto::GroupOperationalCredentials * GetCurrentGroupCredentials()
        {
            // An epoch key update SHALL order the keys from oldest to newest,
            // the current epoch key having the second newest time if time
            // synchronization is not achieved or guaranteed.
            switch (this->keys_count)
            {
            case 1:
            case 2:
                return &operational_keys[0];
            case 3:
                return &operational_keys[1];
            default:
                return nullptr;
            }
        }

        uint16_t keyset_id                       = 0;
        GroupDataProvider::SecurityPolicy policy = GroupDataProvider::SecurityPolicy::kCacheAndSync;
        uint8_t keys_count                       = 0;
        Crypto::GroupOperationalCredentials operational_keys[GroupDataProvider::KeySet::kEpochKeysMax];
    };

    static constexpr size_t kKeysetListMax = CHIP_CONFIG_MAX_GROUP_KEYS_PER_FABRIC;
    static constexpr size_t kKeysetSerializedMax = 5 + 3 * sizeof(uint16_t) + GroupDataProvider::KeySet::kEpochKeysMax * (5 + sizeof(uint64_t) +  sizeof(uint16_t) + Crypto::CHIP_CRYPTO_SYMMETRIC_KEY_LENGTH_BYTES);
    // KeysetIdTag(1) + sizeof(uint16_t) + TagPolicy(1) + sizeof(uint16_t) + NumKeysTag(1) + sizeof(uint16_t) +
    // GroupCredentialsTag(1) + GroupDataProvider::KeySet::kEpochKeysMax * [ AnonymousTag(1)
    //     StartTimeTag(1) + sizeof(uint64_t) + KeyHashTag(1) + sizeof(uint16_t) + KeyValueTag(1) + Crypto::CHIP_CRYPTO_SYMMETRIC_KEY_LENGTH_BYTES
    // EndContainer(1) ] + EndContainer(1)
        
    struct KeysetList: public PersistentArray<kKeysetListMax, kKeysetSerializedMax, KeysetData>
    {
        static constexpr TLV::Tag KeysetIdTag() { return TLV::ContextTag(11); }
        static constexpr TLV::Tag PolicyTag() { return TLV::ContextTag(12); }
        static constexpr TLV::Tag NumKeysTag() { return TLV::ContextTag(13); }
        static constexpr TLV::Tag GroupCredentialsTag() { return TLV::ContextTag(14); }
        static constexpr TLV::Tag StartTimeTag() { return TLV::ContextTag(15); }
        static constexpr TLV::Tag KeyHashTag() { return TLV::ContextTag(16); }
        static constexpr TLV::Tag KeyValueTag() { return TLV::ContextTag(17); }

        KeysetList(PersistentStorageDelegate * storage, FabricIndex fabric, uint16_t count = 0):
            PersistentArray<kKeysetListMax, kKeysetSerializedMax, KeysetData>(storage, count),
            mFabric(fabric) {}

        CHIP_ERROR UpdateKey(StorageKeyName & key) override;
        void ClearEntry(KeysetData & entry) override;
        CHIP_ERROR Serialize(TLV::TLVWriter & writer, const KeysetData & entry) const override;
        CHIP_ERROR Deserialize(TLV::TLVReader & reader, KeysetData & entry) override;

        FabricIndex mFabric;
    };


    class GroupInfoIteratorImpl : public GroupInfoIterator
    {
    public:
        GroupInfoIteratorImpl(GroupDataProviderV2 & provider, FabricIndex fabric_index);
        size_t Count() override;
        bool Next(GroupInfo & output) override;
        void Release() override;

    protected:
        GroupDataProviderV2 & mProvider;
        FabricList mFabrics;
        GroupList mGroups;
        size_t mIndex = 0;
    };


    class GroupKeyIteratorImpl : public GroupKeyIterator
    {
    public:
        GroupKeyIteratorImpl(GroupDataProviderV2 & provider, FabricIndex fabric_index);
        size_t Count() override;
        bool Next(GroupKey & output) override;
        void Release() override;

    protected:
        GroupDataProviderV2 & mProvider;
        FabricList mFabrics;
        KeysetMap mKeysets;
        size_t mIndex = 0;
    };


    class EndpointIteratorImpl : public EndpointIterator
    {
    public:
        EndpointIteratorImpl(GroupDataProviderV2 & provider, FabricIndex fabric_index, std::optional<GroupId> group_id);
        size_t Count() override;
        bool Next(GroupEndpoint & output) override;
        void Release() override;

    protected:
        GroupDataProviderV2 & mProvider;
        FabricList mFabrics;
        EndpointMap mEndpoints;
        size_t mIndex = 0;
    };


    class KeySetIteratorImpl : public KeySetIterator
    {
    public:
        KeySetIteratorImpl(GroupDataProviderV2 & provider, FabricIndex fabric_index);
        size_t Count() override;
        bool Next(KeySet & output) override;
        void Release() override;

    protected:
        GroupDataProviderV2 & mProvider;
        FabricList mFabrics;
        KeysetList mKeysets;
        size_t mIndex = 0;
    };


    class GroupSessionIteratorImpl : public GroupSessionIterator
    {
    public:
        GroupSessionIteratorImpl(GroupDataProviderV2 & provider, uint16_t session_id);
        size_t Count() override;
        bool Next(GroupSession & output) override;
        void Release() override;

    protected:
        GroupDataProviderV2 & mProvider;
        GroupKeyContext mGroupKeyContext;
        uint16_t mSessionId      = 0;
        uint16_t mFabricIndex    = 0;
        uint16_t mMapIndex       = 0;
        uint16_t mSetIndex       = 0;
        uint16_t mKeyIndex       = 0;
        bool mLoad = true;
        FabricList mFabrics;
        KeysetMap mKeymaps;
        KeysetList mKeysets;
    };

    ObjectPool<GroupInfoIteratorImpl, kIteratorsMax> mGroupInfoIterators;
    ObjectPool<GroupKeyIteratorImpl, kIteratorsMax> mGroupKeyIterators;
    ObjectPool<EndpointIteratorImpl, kIteratorsMax> mEndpointIterators;
    ObjectPool<KeySetIteratorImpl, kIteratorsMax> mKeySetIterators;
    ObjectPool<GroupSessionIteratorImpl, kIteratorsMax> mGroupSessionsIterator;
};

} // namespace Credentials
} // namespace chip
