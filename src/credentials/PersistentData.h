/*
 *
 *    Copyright (c) 2022 Project CHIP Authors
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

#include <lib/core/CHIPPersistentStorageDelegate.h>
#include <lib/core/TLV.h>
#include <lib/support/DefaultStorageKeyAllocator.h>

namespace chip {

/// @brief Interface to Persistent Storage Delegate allowing storage of data of variable size such as TLV.
/// @tparam kMaxSerializedSize size of the buffer necessary to retrieve an entry from the storage. Varies with the type of data
/// stored. Will be allocated on the stack so the implementation needs to be aware of this when choosing this value.
template <size_t kMaxSerializedSize>
struct PersistentData
{
    PersistentData(PersistentStorageDelegate * storage): mStorage(storage) {}
    virtual ~PersistentData() = default;
    
    virtual void UpdateKey(StorageKeyName & key)          = 0;
    virtual CHIP_ERROR Serialize(TLV::TLVWriter & writer) const = 0;
    virtual CHIP_ERROR Deserialize(TLV::TLVReader & reader)     = 0;
    virtual void Clear()                                        = 0;

    virtual CHIP_ERROR Save()
    {
        VerifyOrReturnError(nullptr != mStorage, CHIP_ERROR_INVALID_ARGUMENT);

        StorageKeyName key                 = StorageKeyName::Uninitialized();
        UpdateKey(key);

        // Serialize the data
        TLV::TLVWriter writer;
        writer.Init(mBuffer, sizeof(mBuffer));
        ReturnErrorOnFailure(Serialize(writer));

        // Save serialized data
        return mStorage->SyncSetKeyValue(key.KeyName(), mBuffer, static_cast<uint16_t>(writer.GetLengthWritten()));
    }

    CHIP_ERROR Load(bool force = false)
    {
        VerifyOrReturnError(!mLoaded || (mLoaded && force), CHIP_NO_ERROR);
        VerifyOrReturnError(nullptr != mStorage, CHIP_ERROR_INVALID_ARGUMENT);

        StorageKeyName key                 = StorageKeyName::Uninitialized();
        UpdateKey(key);

        // Set data to defaults
        Clear();

        // Load the serialized data
        uint16_t size  = static_cast<uint16_t>(sizeof(mBuffer));
        CHIP_ERROR err = mStorage->SyncGetKeyValue(key.KeyName(), mBuffer, size);
        VerifyOrReturnError(CHIP_ERROR_PERSISTED_STORAGE_VALUE_NOT_FOUND != err, CHIP_ERROR_NOT_FOUND);
        if(CHIP_NO_ERROR == err)
        {
            // Decode serialized data
            TLV::TLVReader reader;
            reader.Init(mBuffer, sizeof(mBuffer));;
            err = Deserialize(reader);
        }
        mLoaded = (CHIP_NO_ERROR == err);
        return err;
    }

    virtual CHIP_ERROR Delete()
    {
        VerifyOrReturnError(nullptr != mStorage, CHIP_ERROR_INVALID_ARGUMENT);

        StorageKeyName key                 = StorageKeyName::Uninitialized();
        UpdateKey(key);
        return mStorage->SyncDeleteKeyValue(key.KeyName());
    }

private:
    uint8_t mBuffer[kMaxSerializedSize] = { 0 };
    PersistentStorageDelegate * mStorage = nullptr;
    bool mLoaded = false;
};



enum class PersistentTags : uint8_t
{
    kCount = 1,
    kList = 2,
    kEntryId = 3,
    kEntryData = 10,
};


using PersistentId = uint16_t;

struct PersistentEntry {

    PersistentEntry(): id(0) {}
    PersistentEntry(PersistentId id): id(id) {}
    virtual ~PersistentEntry() = default;
    virtual void Clear() = 0;
    virtual CHIP_ERROR Serialize(TLV::TLVWriter & writer) const = 0;
    virtual CHIP_ERROR Deserialize(TLV::TLVReader & reader) = 0;

    PersistentId id = 0;
};


template <size_t kMaxSerializedSize, size_t kMaxListSize, typename EntryType>
struct PersistentList: public PersistentData<kMaxSerializedSize> {

    PersistentList(PersistentStorageDelegate * storage): PersistentData<kMaxSerializedSize>(storage) {}

    virtual bool Compare(const EntryType & a, const EntryType & b) const = 0;

    void Clear() override
    {
        for (size_t i = 0; i < sizeof(mBitmap); ++i)
        {
            mBitmap[i] = 0;
        }
    }

    void SetId(PersistentId id, bool active)
    {
        VerifyOrReturn(id-- > 0);
        size_t byte = id / 8;
        uint8_t bit = id % 8;
        uint8_t mask = static_cast<uint8_t>(1 << bit);
        if(active) {
            mBitmap[byte] |= mask; 
        }
        else {
            mBitmap[byte] &= ~mask; 
        }
    }

    CHIP_ERROR GetId(PersistentId & id)
    {
        size_t i = 0, j = 0;
        while( (i < sizeof(mBitmap)) && (0xff == mBitmap[i]))
        {
            i++;
        }
        VerifyOrReturnError(i < sizeof(mBitmap), CHIP_ERROR_NOT_FOUND);
        while( (j < 8) && (mBitmap[i] & (1 << j) ))
        {
            j++;
        }
        id = static_cast<PersistentId>(8 * i + j + 1);
        SetId(id, true);
        return CHIP_NO_ERROR;
    }

private:
    uint8_t mBitmap[kMaxListSize / 8 + 1] = { 0 };
};


template <size_t kMaxSerializedSize, size_t kMaxListSize, typename EntryType>
struct PersistentArray: public PersistentList<kMaxSerializedSize, kMaxListSize, EntryType> {

    PersistentArray(PersistentStorageDelegate * storage): PersistentList<kMaxSerializedSize, kMaxListSize, EntryType>(storage) {}

    void Clear() override
    {
        PersistentList<kMaxSerializedSize, kMaxListSize, EntryType>::Clear();
        for (size_t i = 0; i < mLimit; ++i)
        {
            At(i).id = 0;
            At(i).Clear();
        }
        mCount = 0;
    }

    CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
    {
        TLV::TLVType container, list, entry;
        ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, container));

        // Count
        ReturnErrorOnFailure(writer.Put(TLV::ContextTag(PersistentTags::kCount), static_cast<uint16_t>(mCount)));

        // Entries
        ReturnErrorOnFailure(writer.StartContainer(TLV::ContextTag(PersistentTags::kList), TLV::kTLVType_List, list));
        for (size_t i = 0; (i < mCount) && (i < mLimit); ++i)
        {
            ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, entry));
            const EntryType & e = mEntries[i];
            // Entry Id
            ReturnErrorOnFailure(writer.Put(TLV::ContextTag(PersistentTags::kEntryId), e.id));
            // Entry data
            ReturnErrorOnFailure(e.Serialize(writer));
            ReturnErrorOnFailure(writer.EndContainer(entry));
        }
        ReturnErrorOnFailure(writer.EndContainer(list));

        return writer.EndContainer(container);
    }

    CHIP_ERROR Deserialize(TLV::TLVReader & reader) override
    {
        ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
        VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

        TLV::TLVType container, list, entry;
        ReturnErrorOnFailure(reader.EnterContainer(container));

        // Count
        ReturnErrorOnFailure(reader.Next(TLV::ContextTag(PersistentTags::kCount)));
        ReturnErrorOnFailure(reader.Get(mCount));

        // Entries
        ReturnErrorOnFailure(reader.Next(TLV::ContextTag(PersistentTags::kList)));
        VerifyOrReturnError(TLV::kTLVType_List == reader.GetType(), CHIP_ERROR_INTERNAL);

        ReturnErrorOnFailure(reader.EnterContainer(list));
        for (size_t i = 0; i < mCount && i < mLimit; ++i)
        {
            ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
            VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);
            ReturnErrorOnFailure(reader.EnterContainer(entry));
            EntryType & e = At(i);
            // Entry Id
            ReturnErrorOnFailure(reader.Next(TLV::ContextTag(PersistentTags::kEntryId)));
            ReturnErrorOnFailure(reader.Get(e.id));
            // Entry data
            ReturnErrorOnFailure(e.Deserialize(reader));
            ReturnErrorOnFailure(reader.ExitContainer(entry));
            this->SetId(e.id, true);
        }
        ReturnErrorOnFailure(reader.ExitContainer(list));

        return reader.ExitContainer(container);
    }

    CHIP_ERROR Set(size_t index, EntryType & entry)
    {
        CHIP_ERROR err = this->Load();
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND == err || CHIP_NO_ERROR == err, err);

        // Check existing
        for(size_t i = 0; i < mCount; ++i)
        {
            EntryType & e = At(i);
            if(this->Compare(e, entry))
            {
                // Existing entry, index must match
                VerifyOrReturnError(i == index, CHIP_ERROR_DUPLICATE_KEY_ID);
                e = entry;
                return this->Save();
            }
        }

        // New entry
        VerifyOrReturnError(mCount < mLimit, CHIP_ERROR_INVALID_LIST_LENGTH);
        VerifyOrReturnError(index <= mCount, CHIP_ERROR_INVALID_ARGUMENT);
        if(index < mCount) {
            // Override (implicit remove)
            EntryType old = At(index);
            entry.id = old.id;
            At(index) = entry;
            ReturnErrorOnFailure(this->Save());
            OnEntryRemoved(old);
        }
        else {
            // Insert last
            ReturnErrorOnFailure(this->GetId(entry.id));
            At(mCount++) = entry;
            ReturnErrorOnFailure(this->Save());
        }
        OnEntryAdded(entry);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Set(EntryType & entry, bool do_override = true)
    {
        CHIP_ERROR err = this->Load();
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND == err || CHIP_NO_ERROR == err, err);
        
        // Check existing
        for(size_t i = 0; i < mCount; ++i)
        {
            EntryType & e = At(i);
            if(this->Compare(e, entry))
            {
                // Already registered
                VerifyOrReturnError(do_override, CHIP_ERROR_DUPLICATE_KEY_ID);
                e = entry;
                return this->Save();
            }
        }
        // Insert last
        size_t next_id = 0;
        VerifyOrReturnError(mCount < mLimit, CHIP_ERROR_INVALID_LIST_LENGTH);
        ReturnErrorOnFailure(this->GetId(entry.id));
        At(mCount++) = entry;
        ReturnErrorOnFailure(this->Save());
        OnEntryAdded(entry);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Get(size_t index, EntryType & entry)
    {
        ReturnErrorOnFailure(this->Load());
        VerifyOrReturnError(index < mLimit, CHIP_ERROR_NOT_FOUND);
        VerifyOrReturnError(index < mCount, CHIP_ERROR_NOT_FOUND);
        entry = At(index);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Get(EntryType & entry, bool do_create = false)
    {
        CHIP_ERROR err = this->Load();
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND == err || CHIP_NO_ERROR == err, err);

        // Check existing
        for(size_t i = 0; i < mCount; ++i)
        {
            EntryType & e = At(i);
            if(this->Compare(e, entry))
            {
                entry = e;
                return CHIP_NO_ERROR;
            }
        }
        // Insert last ?
        VerifyOrReturnError(do_create, CHIP_ERROR_NOT_FOUND);
        VerifyOrReturnError(mCount < mLimit, CHIP_ERROR_INVALID_LIST_LENGTH);
        At(mCount++) = entry;
        return this->Save();
    }

    CHIP_ERROR Remove(size_t index)
    {
        ReturnErrorOnFailure(this->Load());
        VerifyOrReturnError(index < mLimit, CHIP_ERROR_NOT_FOUND);
        VerifyOrReturnError(index < mCount, CHIP_ERROR_NOT_FOUND);
        EntryType old = At(index);
        mCount--;
        for(size_t i = index; i < mCount; ++i)
        {
            At(i) = At(i + 1);
        }
        At(mCount).id = 0;
        At(mCount).Clear();
        ReturnErrorOnFailure(this->Save());
        this->SetId(old.id, false);
        OnEntryRemoved(old);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Remove(EntryType & entry)
    {
        ReturnErrorOnFailure(this->Load());
        for(size_t i = 0; i < mCount; ++i)
        {
            if(this->Compare(At(i), entry))
            {
                return Remove(i);
            }
        }
        return CHIP_NO_ERROR;
    }
    
protected:
    virtual void OnEntryAdded(const EntryType & entry) {}
    virtual void OnEntryRemoved(const EntryType & entry) {}

private:
    EntryType & At(size_t index) { return (index < mLimit) ? mEntries[index] : mEntries[0]; }
    
    EntryType mEntries[kMaxListSize];
    uint16_t mLimit = kMaxListSize;
    uint16_t mCount = 0;
};


} // namespace chip
