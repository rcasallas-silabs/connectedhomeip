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

template <size_t kMaxSerializedSize, size_t kMaxListSize, typename EntryType>
struct PersistentList: public PersistentData<kMaxSerializedSize> {

    PersistentList(PersistentStorageDelegate * storage): PersistentData<kMaxSerializedSize>(storage) {}

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
protected:
    uint16_t mLimit = kMaxListSize;
    uint16_t mCount = 0;

private:
    uint8_t mBitmap[kMaxListSize / 8 + 1] = { 0 };
};


template <size_t kMaxSerializedSize, size_t kMaxListSize, typename EntryType>
struct PersistentArray: public PersistentList<kMaxSerializedSize, kMaxListSize, EntryType> {

    struct Entry
    {
        PersistentId id = 0;
        EntryType value;
    };

    PersistentArray(PersistentStorageDelegate * storage): PersistentList<kMaxSerializedSize, kMaxListSize, EntryType>(storage) {}

    void Clear() override
    {
        // Clear bitmap
        PersistentList<kMaxSerializedSize, kMaxListSize, EntryType>::Clear();
        // Clear entries
        for (size_t i = 0; i < this->mLimit; ++i)
        {
            Entry & e = mEntries[i];
            e.id = 0;
            this->Clear(e.value);
        }
        this->mCount = 0;
    }

    CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
    {
        TLV::TLVType container, list, entry;
        ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, container));

        // Count
        ReturnErrorOnFailure(writer.Put(TLV::ContextTag(PersistentTags::kCount), static_cast<uint16_t>(this->mCount)));

        // Entries
        ReturnErrorOnFailure(writer.StartContainer(TLV::ContextTag(PersistentTags::kList), TLV::kTLVType_List, list));
        for (size_t i = 0; (i < this->mCount) && (i < this->mLimit); ++i)
        {
            ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, entry));
            const Entry & e = mEntries[i];
            // Entry Id
            ReturnErrorOnFailure(writer.Put(TLV::ContextTag(PersistentTags::kEntryId), e.id));
            // Entry data
            ReturnErrorOnFailure(Serialize(writer, e.value));
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
        ReturnErrorOnFailure(reader.Get(this->mCount));

        // Entries
        ReturnErrorOnFailure(reader.Next(TLV::ContextTag(PersistentTags::kList)));
        VerifyOrReturnError(TLV::kTLVType_List == reader.GetType(), CHIP_ERROR_INTERNAL);

        ReturnErrorOnFailure(reader.EnterContainer(list));
        for (size_t i = 0; i < this->mCount && i < this->mLimit; ++i)
        {
            ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
            VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);
            ReturnErrorOnFailure(reader.EnterContainer(entry));
            Entry & e = mEntries[i];
            // Entry Id
            ReturnErrorOnFailure(reader.Next(TLV::ContextTag(PersistentTags::kEntryId)));
            ReturnErrorOnFailure(reader.Get(e.id));
            // Entry data
            ReturnErrorOnFailure(Deserialize(reader, e.value));
            ReturnErrorOnFailure(reader.ExitContainer(entry));
            this->SetId(e.id, true);
        }
        ReturnErrorOnFailure(reader.ExitContainer(list));

        return reader.ExitContainer(container);
    }

    CHIP_ERROR Set(size_t index, const EntryType & value)
    {
        CHIP_ERROR err = this->Load();
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND == err || CHIP_NO_ERROR == err, err);

        // Check existing
        for(size_t i = 0; i < this->mCount; ++i)
        {
            Entry & e = mEntries[i];
            if(this->Compare(value, e.value))
            {
                // Existing value, index must match
                VerifyOrReturnError(i == index, CHIP_ERROR_DUPLICATE_KEY_ID);
                e.value = value;
                return this->Save();
            }
        }

        // New value
        VerifyOrReturnError(this->mCount < this->mLimit, CHIP_ERROR_INVALID_LIST_LENGTH);
        VerifyOrReturnError(index <= this->mCount, CHIP_ERROR_INVALID_ARGUMENT);
        if(index < this->mCount) {
            // Override (implicit remove)
            EntryType old_value = mEntries[index].value;
            mEntries[index].value = value;
            ReturnErrorOnFailure(this->Save());
            OnEntryRemoved(old_value);
        }
        else {
            // Insert last
            PersistentId next_id = 0;
            ReturnErrorOnFailure(this->GetId(next_id));
            Entry & e = mEntries[this->mCount++];
            e.id = next_id;
            e.value = value;
            ReturnErrorOnFailure(this->Save());
        }
        OnEntryAdded(value);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Set(const EntryType & value, bool do_override = true)
    {
        CHIP_ERROR err = this->Load();
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND == err || CHIP_NO_ERROR == err, err);
        
        // Check existing
        for(size_t i = 0; i < this->mCount; ++i)
        {
            Entry & e = mEntries[i];
            if(this->Compare(value, e.value))
            {
                // Already registered
                VerifyOrReturnError(do_override, CHIP_ERROR_DUPLICATE_KEY_ID);
                e.value = value;
                return this->Save();
            }
        }
        // Insert last
        PersistentId next_id = 0;
        VerifyOrReturnError(this->mCount < this->mLimit, CHIP_ERROR_INVALID_LIST_LENGTH);
        ReturnErrorOnFailure(this->GetId(next_id));
        Entry & e = mEntries[this->mCount++];
        e.id = next_id;
        e.value = value;
        ReturnErrorOnFailure(this->Save());
        OnEntryAdded(value);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Get(size_t index, EntryType & value, PersistentId & id)
    {
        ReturnErrorOnFailure(this->Load());
        VerifyOrReturnError(index < this->mLimit, CHIP_ERROR_NOT_FOUND);
        VerifyOrReturnError(index < this->mCount, CHIP_ERROR_NOT_FOUND);
        Entry & e = mEntries[index];
        id = e.id;
        value = e.value;
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Get(EntryType & value, PersistentId & id, bool do_create = false)
    {
        CHIP_ERROR err = this->Load();
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND == err || CHIP_NO_ERROR == err, err);

        // Check existing
        for(size_t i = 0; i < this->mCount; ++i)
        {
            Entry & e = mEntries[i];
            if(this->Compare(value, e.value))
            {
                value = e.value;
                return CHIP_NO_ERROR;
            }
        }
        // Insert last ?
        VerifyOrReturnError(do_create, CHIP_ERROR_NOT_FOUND);
        VerifyOrReturnError(this->mCount < this->mLimit, CHIP_ERROR_INVALID_LIST_LENGTH);
        mEntries[this->mCount++].value = value;
        return this->Save();
    }

    CHIP_ERROR Remove(size_t index)
    {
        ReturnErrorOnFailure(this->Load());
        VerifyOrReturnError(index < this->mLimit, CHIP_ERROR_NOT_FOUND);
        VerifyOrReturnError(index < this->mCount, CHIP_ERROR_NOT_FOUND);
        Entry old = mEntries[index];
        this->mCount--;
        for(size_t i = index; i < this->mCount; ++i)
        {
            mEntries[i] = mEntries[i + 1];
        }
        Entry & last = mEntries[this->mCount];
        last.id = 0;
        Clear(last.value);
        ReturnErrorOnFailure(this->Save());
        this->SetId(old.id, false);
        OnEntryRemoved(old.value);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Remove(EntryType & value)
    {
        ReturnErrorOnFailure(this->Load());
        for(size_t i = 0; i < this->mCount; ++i)
        {
            if(this->Compare(mEntries[i].value, value))
            {
                return Remove(i);
            }
        }
        return CHIP_NO_ERROR;
    }
    
    virtual bool Compare(const EntryType & a, const EntryType & b) const
    {
        return a == b;
    }
    virtual void Clear(EntryType & entry) = 0;
    virtual CHIP_ERROR Serialize(TLV::TLVWriter & writer, const EntryType & entry) const = 0;
    virtual CHIP_ERROR Deserialize(TLV::TLVReader & reader, EntryType & entry) = 0;

protected:
    virtual void OnEntryAdded(const EntryType & entry) {}
    virtual void OnEntryRemoved(const EntryType & entry) {}

private:
    // Entry & At(size_t index) { return (index < this->mLimit) ? mEntries[index] : mEntries[0]; }
    Entry mEntries[kMaxListSize];
};


} // namespace chip
