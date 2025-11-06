#include <credentials/KeyManagerImpl.h>
#include <lib/support/PersistentData.h>
#include <lib/support/CommonPersistentData.h>

namespace chip {
namespace Credentials {

constexpr size_t kPersistentBufferMax = 128;

struct FabricList : public CommonPersistentData::FabricList
{
    CHIP_ERROR UpdateKey(StorageKeyName & key) const override
    {
        key = DefaultStorageKeyAllocator::GroupFabricList();
        return CHIP_NO_ERROR;
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
    SecurityPolicy policy = SecurityPolicy::kCacheAndSync;
    uint16_t keyset_id    = 0;
    uint8_t keys_count    = 0;
    chip::KeysetId next            = kInvalidKeysetId;
    chip::KeysetId prev            = kInvalidKeysetId;
    bool first                     = true;
    Crypto::GroupOperationalCredentials operational_keys[KeySet::kEpochKeysMax];

    KeySetData() = default;
    KeySetData(chip::FabricIndex fabric, chip::KeysetId id) : fabric_index(fabric) { keyset_id = id; }
    KeySetData(chip::FabricIndex fabric, chip::KeysetId id, SecurityPolicy policy_id, uint8_t num_keys) :
        fabric_index(fabric), policy(policy_id), keyset_id(id), keys_count(num_keys)
    {}

    CHIP_ERROR UpdateKey(StorageKeyName & key) const override
    {
        VerifyOrReturnError(kUndefinedFabricIndex != fabric_index, CHIP_ERROR_INVALID_FABRIC_INDEX);
        VerifyOrReturnError(kInvalidKeysetId != keyset_id, CHIP_ERROR_INVALID_KEY_ID);
        key = DefaultStorageKeyAllocator::FabricKeyset(fabric_index, keyset_id);
        return CHIP_NO_ERROR;
    }

    void Clear() override
    {
        policy     = SecurityPolicy::kCacheAndSync;
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

    // bool Find(PersistentStorageDelegate * storage, const FabricData & fabric, size_t target_id)
    // {
    //     uint16_t count = 0;

    //     fabric_index = fabric.fabric_index;
    //     keyset_id    = fabric.first_keyset;
    //     first        = true;

    //     while (count++ < fabric.keyset_count)
    //     {
    //         if (CHIP_NO_ERROR != Load(storage))
    //         {
    //             break;
    //         }

    //         if (keyset_id == target_id)
    //         {
    //             // Target id found
    //             return true;
    //         }

    //         first     = false;
    //         prev      = keyset_id;
    //         keyset_id = next;
    //     }

    //     return false;
    // }
};

//
// KeyManagerImpl
//

constexpr size_t Credentials::EpochKey::kLengthBytes;

CHIP_ERROR KeyManagerImpl::SetKeySet(chip::FabricIndex fabric_index, const ByteSpan & compressed_fabric_id,
                                            const KeySet & in_keyset)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);

    FabricData fabric(fabric_index);
    KeySetData keyset;

    // Load fabric, defaults to zero
    CHIP_ERROR err = fabric.Load(mStorage);
    VerifyOrReturnError(CHIP_NO_ERROR == err || CHIP_ERROR_NOT_FOUND == err, err);

    // Search existing keyset
    bool found = keyset.Find(mStorage, fabric, in_keyset.keyset_id);

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
        return keyset.Save(mStorage);
    }

    // New keyset
    VerifyOrReturnError(fabric.keyset_count < mMaxGroupKeysPerFabric, CHIP_ERROR_INVALID_LIST_LENGTH);

    // Insert first
    keyset.next = fabric.first_keyset;
    ReturnErrorOnFailure(keyset.Save(mStorage));
    // Update fabric
    fabric.keyset_count++;
    fabric.first_keyset = in_keyset.keyset_id;
    return fabric.Save(mStorage);
}

CHIP_ERROR KeyManagerImpl::GetKeySet(chip::FabricIndex fabric_index, uint16_t target_id, KeySet & out_keyset)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);

    FabricData fabric(fabric_index);
    KeySetData keyset;

    ReturnErrorOnFailure(fabric.Load(mStorage));
    VerifyOrReturnError(keyset.Find(mStorage, fabric, target_id), CHIP_ERROR_NOT_FOUND);

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

CHIP_ERROR KeyManagerImpl::RemoveKeySet(chip::FabricIndex fabric_index, uint16_t target_id)
{
    VerifyOrReturnError(IsInitialized(), CHIP_ERROR_INTERNAL);

    FabricData fabric(fabric_index);
    KeySetData keyset;

    ReturnErrorOnFailure(fabric.Load(mStorage));
    VerifyOrReturnError(keyset.Find(mStorage, fabric, target_id), CHIP_ERROR_NOT_FOUND);
    ReturnErrorOnFailure(keyset.Delete(mStorage));

    if (keyset.first)
    {
        // Remove first keyset
        fabric.first_keyset = keyset.next;
    }
    else
    {
        // Remove intermediate keyset, update previous
        KeySetData prev_data(fabric_index, keyset.prev);
        ReturnErrorOnFailure(prev_data.Load(mStorage));
        prev_data.next = keyset.next;
        ReturnErrorOnFailure(prev_data.Save(mStorage));
    }
    if (fabric.keyset_count > 0)
    {
        fabric.keyset_count--;
    }
    // Update fabric info
    ReturnErrorOnFailure(fabric.Save(mStorage));

    // Removing a key set also removes the associated group mappings
    KeyMapData map;
    uint16_t original_count = fabric.map_count;
    for (uint16_t i = 0; i < original_count; ++i)
    {
        fabric.Load(mStorage);
        size_t idx = map.Find(mStorage, fabric, target_id);
        if (idx == std::numeric_limits<size_t>::max())
        {
            break;
        }
        // NOTE: It's unclear what should happen here if we have removed the key set
        // and possibly some mappings before failing. For now, ignoring errors, but
        // open to suggestsions for the correct behavior.
        RemoveGroupKeyAt(fabric_index, idx);
    }
    return CHIP_NO_ERROR;
}

KeyContext *KeyManagerImpl::CreateKeyContext(const Crypto::GroupOperationalCredentials &creds)
{
    return mKeyContexPool.CreateObject(*this, creds);
}

//
// IPK
//

CHIP_ERROR KeyManagerImpl::GetIpkKeySet(FabricIndex fabric_index, KeySet & out_keyset)
{
    // FabricData fabric(fabric_index);
    // VerifyOrReturnError(CHIP_NO_ERROR == fabric.Load(mStorage), CHIP_ERROR_NOT_FOUND);

    // KeyMapData mapping(fabric.fabric_index, fabric.first_map);

    // // Fabric found, get the keyset
    // KeySetData keyset;
    // VerifyOrReturnError(keyset.Find(mStorage, fabric, kIdentityProtectionKeySetId), CHIP_ERROR_NOT_FOUND);

    // // If the keyset ID doesn't match, we have a ... problem.
    // VerifyOrReturnError(keyset.keyset_id == kIdentityProtectionKeySetId, CHIP_ERROR_INTERNAL);

    // out_keyset.keyset_id     = keyset.keyset_id;
    // out_keyset.num_keys_used = keyset.keys_count;
    // out_keyset.policy        = keyset.policy;

    // for (size_t key_idx = 0; key_idx < MATTER_ARRAY_SIZE(out_keyset.epoch_keys); ++key_idx)
    // {
    //     out_keyset.epoch_keys[key_idx].Clear();
    //     if (key_idx < keyset.keys_count)
    //     {
    //         out_keyset.epoch_keys[key_idx].start_time = keyset.operational_keys[key_idx].start_time;
    //         memcpy(&out_keyset.epoch_keys[key_idx].key[0], keyset.operational_keys[key_idx].encryption_key, EpochKey::kLengthBytes);
    //     }
    // }

    return CHIP_NO_ERROR;
}

//
// IterateKeySets
//

GroupDataProvider::KeySetIterator * KeyManagerImpl::IterateKeySets(chip::FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mKeySetIterators.CreateObject(*this, fabric_index);
}

KeyManagerImpl::KeySetIteratorImpl::KeySetIteratorImpl(KeySetIteratorImpl & provider, chip::FabricIndex fabric_index) :
    mProvider(provider), mFabric(fabric_index)
{
    FabricData fabric(fabric_index);
    if (CHIP_NO_ERROR == fabric.Load(provider.mStorage))
    {
        mNextId = fabric.first_keyset;
        mTotal  = fabric.keyset_count;
        mCount  = 0;
    }
}

size_t KeyManagerImpl::KeySetIteratorImpl::Count()
{
    return mTotal;
}

bool KeyManagerImpl::KeySetIteratorImpl::Next(KeySet & output)
{
    VerifyOrReturnError(mCount < mTotal, false);

    KeySetData keyset(mFabric, mNextId);
    VerifyOrReturnError(CHIP_NO_ERROR == keyset.Load(mProvider.mStorage), false);

    mCount++;
    mNextId = keyset.next;
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

void KeyManagerImpl::KeySetIteratorImpl::Release()
{
    mProvider.mKeySetIterators.ReleaseObject(this);
}

} // namespace Credentials
} // namespace chip
