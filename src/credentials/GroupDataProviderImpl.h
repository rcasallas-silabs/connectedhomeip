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
#include <lib/support/Pool.h>
#include <lib/support/CommonPersistentData.h>

namespace chip {
namespace Credentials {

class GroupDataProviderImpl : public GroupDataProviderBase
{
public:
    static constexpr size_t kIteratorsMax = CHIP_CONFIG_MAX_GROUP_CONCURRENT_ITERATORS;

    friend class GroupDataProviderV2;

    GroupDataProviderImpl() = default;
    GroupDataProviderImpl(uint16_t maxGroupsPerFabric, uint16_t maxGroupKeysPerFabric) :
        GroupDataProviderBase(maxGroupsPerFabric, maxGroupKeysPerFabric)
    {}
    ~GroupDataProviderImpl() override {}

    /**
     * @brief Set the storage implementation used for non-volatile storage of configuration data.
     *        This method MUST be called before Init().
     *
     * @param storage Pointer to storage instance to set. Cannot be nullptr, will assert.
     */
    void SetStorageDelegate(PersistentStorageDelegate * storage);

    void SetSessionKeystore(Crypto::SessionKeystore * keystore) { mSessionKeystore = keystore; }
    Crypto::SessionKeystore * GetSessionKeystore() const { return mSessionKeystore; }

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

    void Reset() override;
    void Debug() override;

protected:

    bool IsInitialized() { return (mStorage != nullptr); }
    CHIP_ERROR RemoveEndpoints(FabricIndex fabric_index, GroupId group_id);

    class GroupInfoIteratorImpl : public GroupInfoIterator
    {
    public:
        GroupInfoIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index);
        size_t Count() override;
        bool Next(GroupInfo & output) override;
        void Release() override;

    protected:
        GroupDataProviderImpl & mProvider;
        FabricIndex mFabric = kUndefinedFabricIndex;
        uint16_t mNextId    = 0;
        size_t mCount       = 0;
        size_t mTotal       = 0;
    };

    class GroupKeyIteratorImpl : public GroupKeyIterator
    {
    public:
        GroupKeyIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index);
        size_t Count() override;
        bool Next(GroupKey & output) override;
        void Release() override;

    protected:
        GroupDataProviderImpl & mProvider;
        FabricIndex mFabric = kUndefinedFabricIndex;
        uint16_t mNextId    = 0;
        size_t mCount       = 0;
        size_t mTotal       = 0;
    };

    class EndpointIteratorImpl : public EndpointIterator
    {
    public:
        EndpointIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index, std::optional<GroupId> group_id);
        size_t Count() override;
        bool Next(GroupEndpoint & output) override;
        void Release() override;

    protected:
        GroupDataProviderImpl & mProvider;
        FabricIndex mFabric   = kUndefinedFabricIndex;
        GroupId mFirstGroup   = kUndefinedGroupId;
        uint16_t mGroup       = 0;
        size_t mGroupIndex    = 0;
        size_t mGroupCount    = 0;
        uint16_t mEndpoint    = 0;
        size_t mEndpointIndex = 0;
        size_t mEndpointCount = 0;
        bool mFirstEndpoint   = true;
    };

    class KeySetIteratorImpl : public KeySetIterator
    {
    public:
        KeySetIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index);
        size_t Count() override;
        bool Next(KeySet & output) override;
        void Release() override;

    protected:
        GroupDataProviderImpl & mProvider;
        FabricIndex mFabric = kUndefinedFabricIndex;
        uint16_t mNextId    = 0;
        size_t mCount       = 0;
        size_t mTotal       = 0;
    };

    class GroupSessionIteratorImpl : public GroupSessionIterator
    {
    public:
        GroupSessionIteratorImpl(GroupDataProviderImpl & provider, uint16_t session_id);
        size_t Count() override;
        bool Next(GroupSession & output) override;
        void Release() override;

    protected:
        GroupDataProviderImpl & mProvider;
        uint16_t mSessionId      = 0;
        FabricIndex mFirstFabric = kUndefinedFabricIndex;
        FabricIndex mFabric      = kUndefinedFabricIndex;
        uint16_t mFabricCount    = 0;
        uint16_t mFabricTotal    = 0;
        uint16_t mMapping        = 0;
        uint16_t mMapCount       = 0;
        uint16_t mKeyIndex       = 0;
        uint16_t mKeyCount       = 0;
        bool mFirstMap           = true;
        GroupKeyContext mGroupKeyContext;
    };


    class GroupKeyContext : public Crypto::SymmetricKeyContext
    {
    public:
        GroupKeyContext(GroupDataProviderImpl & provider) : mProvider(provider) {}

        GroupKeyContext(GroupDataProviderImpl & provider, const Crypto::Symmetric128BitsKeyByteArray & encryptionKey, uint16_t hash,
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
        GroupDataProviderImpl & mProvider;
        uint16_t mKeyHash = 0;
        Crypto::Aes128KeyHandle mEncryptionKey;
        Crypto::Aes128KeyHandle mPrivacyKey;
    };

    struct FabricList : public CommonPersistentData::FabricList
    {
        CHIP_ERROR UpdateKey(StorageKeyName & key) override
        {
            key = DefaultStorageKeyAllocator::GroupFabricList();
            return CHIP_NO_ERROR;
        }
    };

    static constexpr size_t kPersistentBufferMax = 128;

    struct LinkedData : public PersistentData<kPersistentBufferMax>
    {
        static constexpr uint16_t kMinLinkId = 1;

        LinkedData() = default;
        LinkedData(uint16_t linked_id) : id(linked_id) {}
        uint16_t id     = kMinLinkId;
        uint16_t index  = 0;
        uint16_t next   = 0;
        uint16_t prev   = 0;
        uint16_t max_id = 0;
        bool first      = true;
    };

    struct FabricData : public PersistentData<kPersistentBufferMax>
    {
        static constexpr TLV::Tag TagFirstGroup() { return TLV::ContextTag(1); }
        static constexpr TLV::Tag TagGroupCount() { return TLV::ContextTag(2); }
        static constexpr TLV::Tag TagFirstMap() { return TLV::ContextTag(3); }
        static constexpr TLV::Tag TagMapCount() { return TLV::ContextTag(4); }
        static constexpr TLV::Tag TagFirstKeyset() { return TLV::ContextTag(5); }
        static constexpr TLV::Tag TagKeysetCount() { return TLV::ContextTag(6); }
        static constexpr TLV::Tag TagNext() { return TLV::ContextTag(7); }

        chip::FabricIndex fabric_index = kUndefinedFabricIndex;
        chip::GroupId first_group      = kUndefinedGroupId;
        uint16_t group_count           = 0;
        uint16_t first_map             = 0;
        uint16_t map_count             = 0;
        chip::KeysetId first_keyset    = kInvalidKeysetId;
        uint16_t keyset_count          = 0;
        chip::FabricIndex next         = kUndefinedFabricIndex;

        FabricData() = default;
        FabricData(chip::FabricIndex fabric) : fabric_index(fabric) {}

        CHIP_ERROR UpdateKey(StorageKeyName & key) override
        {
            VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);
            key = DefaultStorageKeyAllocator::FabricGroups(fabric_index);
            return CHIP_NO_ERROR;
        }

        void Clear() override
        {
            first_group  = kUndefinedGroupId;
            group_count  = 0;
            first_keyset = kInvalidKeysetId;
            keyset_count = 0;
            next         = kUndefinedFabricIndex;
        }

        CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
        {
            TLV::TLVType container;
            ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, container));

            ReturnErrorOnFailure(writer.Put(TagFirstGroup(), static_cast<uint16_t>(first_group)));
            ReturnErrorOnFailure(writer.Put(TagGroupCount(), static_cast<uint16_t>(group_count)));
            ReturnErrorOnFailure(writer.Put(TagFirstMap(), static_cast<uint16_t>(first_map)));
            ReturnErrorOnFailure(writer.Put(TagMapCount(), static_cast<uint16_t>(map_count)));
            ReturnErrorOnFailure(writer.Put(TagFirstKeyset(), static_cast<uint16_t>(first_keyset)));
            ReturnErrorOnFailure(writer.Put(TagKeysetCount(), static_cast<uint16_t>(keyset_count)));
            ReturnErrorOnFailure(writer.Put(TagNext(), static_cast<uint16_t>(next)));

            return writer.EndContainer(container);
        }
        CHIP_ERROR Deserialize(TLV::TLVReader & reader) override
        {
            ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
            VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

            TLV::TLVType container;
            ReturnErrorOnFailure(reader.EnterContainer(container));

            // first_group
            ReturnErrorOnFailure(reader.Next(TagFirstGroup()));
            ReturnErrorOnFailure(reader.Get(first_group));
            // group_count
            ReturnErrorOnFailure(reader.Next(TagGroupCount()));
            ReturnErrorOnFailure(reader.Get(group_count));
            // first_map
            ReturnErrorOnFailure(reader.Next(TagFirstMap()));
            ReturnErrorOnFailure(reader.Get(first_map));
            // map_count
            ReturnErrorOnFailure(reader.Next(TagMapCount()));
            ReturnErrorOnFailure(reader.Get(map_count));
            // first_keyset
            ReturnErrorOnFailure(reader.Next(TagFirstKeyset()));
            ReturnErrorOnFailure(reader.Get(first_keyset));
            // keyset_count
            ReturnErrorOnFailure(reader.Next(TagKeysetCount()));
            ReturnErrorOnFailure(reader.Get(keyset_count));
            // next
            ReturnErrorOnFailure(reader.Next(TagNext()));
            ReturnErrorOnFailure(reader.Get(next));

            return reader.ExitContainer(container);
        }

        // Register the fabric in the fabrics' linked-list
        CHIP_ERROR Register(PersistentStorageDelegate * storage)
        {
            FabricList fabric_list;
            CHIP_ERROR err = fabric_list.Load(storage);
            if (CHIP_ERROR_NOT_FOUND == err)
            {
                // New fabric list
                fabric_list.first_entry = fabric_index;
                fabric_list.entry_count = 1;
                return fabric_list.Save(storage);
            }
            ReturnErrorOnFailure(err);

            // Existing fabric list, search for existing entry
            FabricData fabric(fabric_list.first_entry);
            for (size_t i = 0; i < fabric_list.entry_count; i++)
            {
                err = fabric.Load(storage);
                if (CHIP_NO_ERROR != err)
                {
                    break;
                }
                if (fabric.fabric_index == this->fabric_index)
                {
                    // Fabric already registered
                    return CHIP_NO_ERROR;
                }
                fabric.fabric_index = fabric.next;
            }
            // Add this fabric to the fabric list
            this->next              = fabric_list.first_entry;
            fabric_list.first_entry = this->fabric_index;
            fabric_list.entry_count++;
            return fabric_list.Save(storage);
        }

        // Remove the fabric from the fabrics' linked list
        CHIP_ERROR Unregister(PersistentStorageDelegate * storage) const
        {
            FabricList fabric_list;
            CHIP_ERROR err = fabric_list.Load(storage);
            VerifyOrReturnError(CHIP_NO_ERROR == err || CHIP_ERROR_NOT_FOUND == err, err);

            // Existing fabric list, search for existing entry
            FabricData fabric(fabric_list.first_entry);
            FabricData prev;

            for (size_t i = 0; i < fabric_list.entry_count; i++)
            {
                err = fabric.Load(storage);
                if (CHIP_NO_ERROR != err)
                {
                    break;
                }
                if (fabric.fabric_index == this->fabric_index)
                {
                    // Fabric found
                    if (i == 0)
                    {
                        // Remove first fabric
                        fabric_list.first_entry = this->next;
                    }
                    else
                    {
                        // Remove intermediate fabric
                        prev.next = this->next;
                        ReturnErrorOnFailure(prev.Save(storage));
                    }
                    VerifyOrReturnError(fabric_list.entry_count > 0, CHIP_ERROR_INTERNAL);
                    fabric_list.entry_count--;
                    return fabric_list.Save(storage);
                }
                prev                = fabric;
                fabric.fabric_index = fabric.next;
            }
            // Fabric not in the list
            return CHIP_ERROR_NOT_FOUND;
        }

        // Check the fabric is registered in the fabrics' linked list
        CHIP_ERROR Validate(PersistentStorageDelegate * storage) const
        {
            FabricList fabric_list;
            ReturnErrorOnFailure(fabric_list.Load(storage));

            // Existing fabric list, search for existing entry
            FabricData fabric(fabric_list.first_entry);

            for (size_t i = 0; i < fabric_list.entry_count; i++)
            {
                ReturnErrorOnFailure(fabric.Load(storage));
                if (fabric.fabric_index == this->fabric_index)
                {
                    return CHIP_NO_ERROR;
                }
                fabric.fabric_index = fabric.next;
            }
            // Fabric not in the list
            return CHIP_ERROR_NOT_FOUND;
        }

        CHIP_ERROR Save(PersistentStorageDelegate * storage) override
        {
            ReturnErrorOnFailure(Register(storage));
            return PersistentData::Save(storage);
        }

        CHIP_ERROR Delete(PersistentStorageDelegate * storage) override
        {
            ReturnErrorOnFailure(Unregister(storage));
            return PersistentData::Delete(storage);
        }
    };

    struct GroupData : public GroupDataProvider::GroupInfo, PersistentData<kPersistentBufferMax>
    {
        static constexpr TLV::Tag TagName() { return TLV::ContextTag(1); }
        static constexpr TLV::Tag TagFirstEndpoint() { return TLV::ContextTag(2); }
        static constexpr TLV::Tag TagEndpointCount() { return TLV::ContextTag(3); }
        static constexpr TLV::Tag TagNext() { return TLV::ContextTag(4); }

        chip::FabricIndex fabric_index  = kUndefinedFabricIndex;
        chip::EndpointId first_endpoint = kInvalidEndpointId;
        uint16_t endpoint_count         = 0;
        uint16_t index                  = 0;
        chip::GroupId next              = 0;
        chip::GroupId prev              = 0;
        bool first                      = true;

        GroupData() : GroupInfo(nullptr){};
        GroupData(chip::FabricIndex fabric) : fabric_index(fabric) {}
        GroupData(chip::FabricIndex fabric, chip::GroupId group) : GroupInfo(group, nullptr), fabric_index(fabric) {}

        CHIP_ERROR UpdateKey(StorageKeyName & key) override
        {
            VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);
            key = DefaultStorageKeyAllocator::FabricGroup(fabric_index, group_id);
            return CHIP_NO_ERROR;
        }

        void Clear() override
        {
            SetName(CharSpan());
            first_endpoint = kInvalidEndpointId;
            endpoint_count = 0;
            next           = 0;
        }

        CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
        {
            TLV::TLVType container;
            ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, container));

            size_t name_size = strnlen(name, GroupDataProvider::GroupInfo::kGroupNameMax);
            ReturnErrorOnFailure(writer.PutString(TagName(), name, static_cast<uint32_t>(name_size)));
            ReturnErrorOnFailure(writer.Put(TagFirstEndpoint(), static_cast<uint16_t>(first_endpoint)));
            ReturnErrorOnFailure(writer.Put(TagEndpointCount(), static_cast<uint16_t>(endpoint_count)));
            ReturnErrorOnFailure(writer.Put(TagNext(), static_cast<uint16_t>(next)));
            return writer.EndContainer(container);
        }

        CHIP_ERROR Deserialize(TLV::TLVReader & reader) override
        {
            ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
            VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

            TLV::TLVType container;
            ReturnErrorOnFailure(reader.EnterContainer(container));

            // name
            ReturnErrorOnFailure(reader.Next(TagName()));
            ReturnErrorOnFailure(reader.GetString(name, sizeof(name)));
            size_t size = strnlen(name, kGroupNameMax);
            name[size]  = 0;
            // first_endpoint
            ReturnErrorOnFailure(reader.Next(TagFirstEndpoint()));
            ReturnErrorOnFailure(reader.Get(first_endpoint));
            // endpoint_count
            ReturnErrorOnFailure(reader.Next(TagEndpointCount()));
            ReturnErrorOnFailure(reader.Get(endpoint_count));
            // next
            ReturnErrorOnFailure(reader.Next(TagNext()));
            ReturnErrorOnFailure(reader.Get(next));

            return reader.ExitContainer(container);
        }

        bool Get(PersistentStorageDelegate * storage, const FabricData & fabric, size_t target_index)
        {
            fabric_index = fabric.fabric_index;
            group_id     = fabric.first_group;
            index        = 0;
            first        = true;

            while (index < fabric.group_count)
            {
                if (CHIP_NO_ERROR != Load(storage))
                {
                    break;
                }
                if (index == target_index)
                {
                    // Target index found
                    return true;
                }

                first    = false;
                prev     = group_id;
                group_id = next;
                index++;
            }

            return false;
        }

        bool Find(PersistentStorageDelegate * storage, const FabricData & fabric, chip::GroupId target_group)
        {
            fabric_index = fabric.fabric_index;
            group_id     = fabric.first_group;
            index        = 0;
            first        = true;

            while (index < fabric.group_count)
            {
                if (CHIP_NO_ERROR != Load(storage))
                {
                    break;
                }
                if (group_id == target_group)
                {
                    // Target index found
                    return true;
                }
                first    = false;
                prev     = group_id;
                group_id = next;
                index++;
            }
            return false;
        }
    };

    struct KeyMapData : public GroupDataProvider::GroupKey, LinkedData
    {
        static constexpr TLV::Tag TagGroupId() { return TLV::ContextTag(1); }
        static constexpr TLV::Tag TagKeysetId() { return TLV::ContextTag(2); }
        static constexpr TLV::Tag TagNext() { return TLV::ContextTag(3); }

        chip::FabricIndex fabric_index = kUndefinedFabricIndex;
        chip::GroupId group_id         = kUndefinedGroupId;
        chip::KeysetId keyset_id       = 0;

        KeyMapData(){};
        KeyMapData(chip::FabricIndex fabric, uint16_t link_id = 0, chip::GroupId group = kUndefinedGroupId, chip::KeysetId keyset = 0) :
            GroupKey(group, keyset), LinkedData(link_id), fabric_index(fabric)
        {}

        CHIP_ERROR UpdateKey(StorageKeyName & key) override
        {
            VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);
            key = DefaultStorageKeyAllocator::FabricGroupKey(fabric_index, id);
            return CHIP_NO_ERROR;
        }

        void Clear() override {}

        CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
        {
            TLV::TLVType container;
            ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, container));

            ReturnErrorOnFailure(writer.Put(TagGroupId(), static_cast<uint16_t>(group_id)));
            ReturnErrorOnFailure(writer.Put(TagKeysetId(), static_cast<uint16_t>(keyset_id)));
            ReturnErrorOnFailure(writer.Put(TagNext(), static_cast<uint16_t>(next)));
            return writer.EndContainer(container);
        }

        CHIP_ERROR Deserialize(TLV::TLVReader & reader) override
        {
            ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
            VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

            TLV::TLVType container;
            ReturnErrorOnFailure(reader.EnterContainer(container));

            // first_endpoint
            ReturnErrorOnFailure(reader.Next(TagGroupId()));
            ReturnErrorOnFailure(reader.Get(group_id));
            // endpoint_count
            ReturnErrorOnFailure(reader.Next(TagKeysetId()));
            ReturnErrorOnFailure(reader.Get(keyset_id));
            // next
            ReturnErrorOnFailure(reader.Next(TagNext()));
            ReturnErrorOnFailure(reader.Get(next));

            return reader.ExitContainer(container);
        }

        bool Get(PersistentStorageDelegate * storage, const FabricData & fabric, size_t target_index)
        {
            fabric_index = fabric.fabric_index;
            id           = fabric.first_map;
            max_id       = 0;
            index        = 0;
            first        = true;

            while (index < fabric.map_count)
            {
                if (CHIP_NO_ERROR != Load(storage))
                {
                    break;
                }
                if (index == target_index)
                {
                    // Target index found
                    return true;
                }
                max_id = std::max(id, max_id);
                first  = false;
                prev   = id;
                id     = next;
                index++;
            }

            id = static_cast<uint16_t>(max_id + 1);
            return false;
        }

        bool Find(PersistentStorageDelegate * storage, const FabricData & fabric, const GroupKey & map)
        {
            fabric_index = fabric.fabric_index;
            id           = fabric.first_map;
            max_id       = 0;
            index        = 0;
            first        = true;

            while (index < fabric.map_count)
            {
                if (CHIP_NO_ERROR != Load(storage))
                {
                    break;
                }
                if ((group_id == map.group_id) && (keyset_id == map.keyset_id))
                {
                    // Match found
                    return true;
                }
                max_id = std::max(id, max_id);
                first  = false;
                prev   = id;
                id     = next;
                index++;
            }

            id = static_cast<uint16_t>(max_id + 1);
            return false;
        }

        // returns index if the find_id is found, otherwise std::numeric_limits<size_t>::max
        size_t Find(PersistentStorageDelegate * storage, const FabricData & fabric, const KeysetId find_id)
        {
            fabric_index = fabric.fabric_index;
            id           = fabric.first_map;
            max_id       = 0;
            index        = 0;
            first        = true;

            while (index < fabric.map_count)
            {
                if (CHIP_NO_ERROR != Load(storage))
                {
                    break;
                }
                if (keyset_id == find_id)
                {
                    // Match found
                    return index;
                }
                max_id = std::max(id, max_id);
                first  = false;
                prev   = id;
                id     = next;
                index++;
            }

            id = static_cast<uint16_t>(max_id + 1);
            return std::numeric_limits<size_t>::max();
        }
    };

    struct EndpointData : GroupDataProvider::GroupEndpoint, PersistentData<kPersistentBufferMax>
    {
        static constexpr TLV::Tag TagEndpoint() { return TLV::ContextTag(1); }
        static constexpr TLV::Tag TagNext() { return TLV::ContextTag(2); }

        chip::FabricIndex fabric_index = kUndefinedFabricIndex;
        uint16_t index                 = 0;
        chip::EndpointId next          = 0;
        chip::EndpointId prev          = 0;
        bool first                     = true;

        EndpointData() = default;
        EndpointData(chip::FabricIndex fabric, chip::GroupId group = kUndefinedGroupId,
                    chip::EndpointId endpoint = kInvalidEndpointId) :
            GroupEndpoint(group, endpoint),
            fabric_index(fabric)
        {}

        CHIP_ERROR UpdateKey(StorageKeyName & key) override
        {
            VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);
            key = DefaultStorageKeyAllocator::FabricGroupEndpoint(fabric_index, group_id, endpoint_id);
            return CHIP_NO_ERROR;
        }

        void Clear() override { next = kInvalidEndpointId; }

        CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
        {
            TLV::TLVType container;
            ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, container));

            ReturnErrorOnFailure(writer.Put(TagEndpoint(), static_cast<uint16_t>(endpoint_id)));
            ReturnErrorOnFailure(writer.Put(TagNext(), static_cast<uint16_t>(next)));

            return writer.EndContainer(container);
        }
        CHIP_ERROR Deserialize(TLV::TLVReader & reader) override
        {
            ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
            VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

            TLV::TLVType container;
            ReturnErrorOnFailure(reader.EnterContainer(container));

            // endpoint_id
            ReturnErrorOnFailure(reader.Next(TagEndpoint()));
            ReturnErrorOnFailure(reader.Get(endpoint_id));
            // next
            ReturnErrorOnFailure(reader.Next(TagNext()));
            ReturnErrorOnFailure(reader.Get(next));

            return reader.ExitContainer(container);
        }

        bool Find(PersistentStorageDelegate * storage, const FabricData & fabric, const GroupData & group, chip::EndpointId target_id)
        {
            fabric_index = fabric.fabric_index;
            group_id     = group.group_id;
            endpoint_id  = group.first_endpoint;
            index        = 0;
            first        = true;

            while (index < group.endpoint_count)
            {
                if (CHIP_NO_ERROR != Load(storage))
                {
                    break;
                }
                if (this->endpoint_id == target_id)
                {
                    // Match found
                    return true;
                }

                first       = false;
                prev        = endpoint_id;
                endpoint_id = next;
                index++;
            }

            return false;
        }
    };

    struct KeySetData : PersistentData<kPersistentBufferMax>
    {
        static constexpr TLV::Tag TagPolicy() { return TLV::ContextTag(1); }
        static constexpr TLV::Tag TagNumKeys() { return TLV::ContextTag(2); }
        static constexpr TLV::Tag TagGroupCredentials() { return TLV::ContextTag(3); }
        static constexpr TLV::Tag TagStartTime() { return TLV::ContextTag(4); }
        static constexpr TLV::Tag TagKeyHash() { return TLV::ContextTag(5); }
        static constexpr TLV::Tag TagKeyValue() { return TLV::ContextTag(6); }
        static constexpr TLV::Tag TagNext() { return TLV::ContextTag(7); }

        chip::FabricIndex fabric_index = kUndefinedFabricIndex;
        chip::KeysetId next            = kInvalidKeysetId;
        chip::KeysetId prev            = kInvalidKeysetId;
        bool first                     = true;

        uint16_t keyset_id                       = 0;
        GroupDataProvider::SecurityPolicy policy = GroupDataProvider::SecurityPolicy::kCacheAndSync;
        uint8_t keys_count                       = 0;
        Crypto::GroupOperationalCredentials operational_keys[KeySet::kEpochKeysMax];

        KeySetData() = default;
        KeySetData(chip::FabricIndex fabric, chip::KeysetId id) : fabric_index(fabric) { keyset_id = id; }
        KeySetData(chip::FabricIndex fabric, chip::KeysetId id, GroupDataProvider::SecurityPolicy policy_id, uint8_t num_keys) :
            fabric_index(fabric), keyset_id(id), policy(policy_id), keys_count(num_keys)
        {}

        CHIP_ERROR UpdateKey(StorageKeyName & key) override
        {
            VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);
            VerifyOrReturnError(kInvalidKeysetId != keyset_id, CHIP_ERROR_INVALID_KEY_ID);
            key = DefaultStorageKeyAllocator::FabricKeyset(fabric_index, keyset_id);
            return CHIP_NO_ERROR;
        }

        void Clear() override
        {
            policy     = GroupDataProvider::SecurityPolicy::kCacheAndSync;
            keys_count = 0;
            memset(operational_keys, 0x00, sizeof(operational_keys));
            next = kInvalidKeysetId;
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

        CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
        {
            TLV::TLVType container;
            ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, container));

            // policy
            ReturnErrorOnFailure(writer.Put(TagPolicy(), static_cast<uint16_t>(policy)));
            // keys_count
            ReturnErrorOnFailure(writer.Put(TagNumKeys(), static_cast<uint16_t>(keys_count)));
            // operational_keys
            {
                TLV::TLVType array, item;
                ReturnErrorOnFailure(writer.StartContainer(TagGroupCredentials(), TLV::kTLVType_Array, array));
                uint8_t keyCount   = 0;
                uint64_t startTime = 0;
                uint16_t hash      = 0;
                uint8_t encryptionKey[Crypto::CHIP_CRYPTO_SYMMETRIC_KEY_LENGTH_BYTES];
                for (auto & key : operational_keys)
                {
                    startTime = 0;
                    hash      = 0;
                    memset(encryptionKey, 0, sizeof(encryptionKey));
                    ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, item));

                    if (keyCount++ < keys_count)
                    {
                        startTime = key.start_time;
                        hash      = key.hash;
                        memcpy(encryptionKey, key.encryption_key, sizeof(encryptionKey));
                    }
                    ReturnErrorOnFailure(writer.Put(TagStartTime(), static_cast<uint64_t>(startTime)));
                    ReturnErrorOnFailure(writer.Put(TagKeyHash(), hash));
                    ReturnErrorOnFailure(writer.Put(TagKeyValue(), ByteSpan(encryptionKey)));

                    ReturnErrorOnFailure(writer.EndContainer(item));
                }
                ReturnErrorOnFailure(writer.EndContainer(array));
            }
            // next keyset
            ReturnErrorOnFailure(writer.Put(TagNext(), static_cast<uint16_t>(next)));

            return writer.EndContainer(container);
        }

        CHIP_ERROR Deserialize(TLV::TLVReader & reader) override
        {
            ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
            VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

            TLV::TLVType container;
            ReturnErrorOnFailure(reader.EnterContainer(container));

            // policy
            ReturnErrorOnFailure(reader.Next(TagPolicy()));
            ReturnErrorOnFailure(reader.Get(policy));
            // keys_count
            ReturnErrorOnFailure(reader.Next(TagNumKeys()));
            ReturnErrorOnFailure(reader.Get(keys_count));
            // TODO(#21614): Enforce maximum number of 3 keys in a keyset
            {
                // operational_keys
                ReturnErrorOnFailure(reader.Next(TagGroupCredentials()));
                VerifyOrReturnError(TLV::kTLVType_Array == reader.GetType(), CHIP_ERROR_INTERNAL);

                TLV::TLVType array, item;
                ReturnErrorOnFailure(reader.EnterContainer(array));
                for (auto & key : operational_keys)
                {
                    ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
                    VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

                    ReturnErrorOnFailure(reader.EnterContainer(item));
                    // start_time
                    ReturnErrorOnFailure(reader.Next(TagStartTime()));
                    ReturnErrorOnFailure(reader.Get(key.start_time));
                    // key hash
                    ReturnErrorOnFailure(reader.Next(TagKeyHash()));
                    ReturnErrorOnFailure(reader.Get(key.hash));
                    // key value
                    ByteSpan encryption_key;
                    ReturnErrorOnFailure(reader.Next(TagKeyValue()));
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
            // next keyset
            ReturnErrorOnFailure(reader.Next(TagNext()));
            ReturnErrorOnFailure(reader.Get(next));

            return reader.ExitContainer(container);
        }

        bool Find(PersistentStorageDelegate * storage, const FabricData & fabric, size_t target_id)
        {
            uint16_t count = 0;

            fabric_index = fabric.fabric_index;
            keyset_id    = fabric.first_keyset;
            first        = true;

            while (count++ < fabric.keyset_count)
            {
                if (CHIP_NO_ERROR != Load(storage))
                {
                    break;
                }

                if (keyset_id == target_id)
                {
                    // Target id found
                    return true;
                }

                first     = false;
                prev      = keyset_id;
                keyset_id = next;
            }

            return false;
        }
    };

    PersistentStorageDelegate * mStorage       = nullptr;
    Crypto::SessionKeystore * mSessionKeystore = nullptr;
    ObjectPool<GroupInfoIteratorImpl, kIteratorsMax> mGroupInfoIterators;
    ObjectPool<GroupKeyIteratorImpl, kIteratorsMax> mGroupKeyIterators;
    ObjectPool<EndpointIteratorImpl, kIteratorsMax> mEndpointIterators;
    ObjectPool<KeySetIteratorImpl, kIteratorsMax> mKeySetIterators;
    ObjectPool<GroupSessionIteratorImpl, kIteratorsMax> mGroupSessionsIterator;
    ObjectPool<GroupKeyContext, kIteratorsMax> mGroupKeyContexPool;
};

} // namespace Credentials
} // namespace chip
