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
#include <lib/support/PersistentData.h>


namespace chip {

enum class PersistentTags : uint8_t
{
    kCount = 1,
    kList = 2,
    kEntryId = 3,
    kEntryData = 10,
};


template <size_t kMaxSerializedSize, size_t kMaxListSize, typename EntryType>
struct PersistentArray: public PersistentData<kMaxSerializedSize> {

    PersistentArray(PersistentStorageDelegate * storage): PersistentData<kMaxSerializedSize>(), mStorage(storage) {}

    size_t Limit() { return mLimit; }
    size_t Count() { return mCount; }
    EntryType & Get(size_t index) { return mEntries[index]; }

    void Clear() override
    {
        // Clear entries
        for (size_t i = 0; i < this->mLimit; ++i)
        {
            this->Clear(this->Get(i));
        }
        this->mCount = 0;
    }

    CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override
    {
        TLV::TLVType container, list;
        ReturnErrorOnFailure(writer.StartContainer(TLV::AnonymousTag(), TLV::kTLVType_Structure, container));

        // Count
        ReturnErrorOnFailure(writer.Put(TLV::ContextTag(PersistentTags::kCount), static_cast<uint16_t>(this->mCount)));

        // Entries
        ReturnErrorOnFailure(writer.StartContainer(TLV::ContextTag(PersistentTags::kList), TLV::kTLVType_List, list));
        for (size_t i = 0; (i < this->mCount) && (i < this->mLimit); ++i)
        {
            ReturnErrorOnFailure(Serialize(writer, mEntries[i]));
        }
        ReturnErrorOnFailure(writer.EndContainer(list));

        return writer.EndContainer(container);
    }

    CHIP_ERROR Deserialize(TLV::TLVReader & reader) override
    {
        ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
        VerifyOrReturnError(TLV::kTLVType_Structure == reader.GetType(), CHIP_ERROR_INTERNAL);

        TLV::TLVType container, list;
        ReturnErrorOnFailure(reader.EnterContainer(container));

        // Count
        uint16_t count = 0;
        ReturnErrorOnFailure(reader.Next(TLV::ContextTag(PersistentTags::kCount)));
        ReturnErrorOnFailure(reader.Get(count));
        this->mCount = count;

        // Entries
        ReturnErrorOnFailure(reader.Next(TLV::ContextTag(PersistentTags::kList)));
        VerifyOrReturnError(TLV::kTLVType_List == reader.GetType(), CHIP_ERROR_INTERNAL);

        ReturnErrorOnFailure(reader.EnterContainer(list));
        for (size_t i = 0; i < this->mCount && i < this->mLimit; ++i)
        {
            ReturnErrorOnFailure(Deserialize(reader, this->Get(i)));
        }
        ReturnErrorOnFailure(reader.ExitContainer(list));

        return reader.ExitContainer(container);
    }

    CHIP_ERROR Store(size_t index, const EntryType & value)
    {
        CHIP_ERROR err = this->Load(this->mStorage);
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND == err || CHIP_NO_ERROR == err, err);

        // Check existing
        for(size_t i = 0; i < this->mCount; ++i)
        {
            EntryType & e = this->Get(i);
            if(this->Compare(value, e))
            {
                // Existing value, index must match
                VerifyOrReturnError(i == index, CHIP_ERROR_DUPLICATE_KEY_ID);
                e = value;
                return this->Save(this->mStorage);
            }
        }

        // New value
        VerifyOrReturnError(this->mCount < this->mLimit, CHIP_ERROR_INVALID_LIST_LENGTH);
        VerifyOrReturnError(index <= this->mCount, CHIP_ERROR_INVALID_ARGUMENT);
        if(index < this->mCount) {
            // Override (implicit remove)
            EntryType old_value = this->Get(index);
            this->Get(index) = value;
            ReturnErrorOnFailure(this->Save(this->mStorage));
            OnEntryRemoved(old_value);
        }
        else {
            // Insert last
            this->Get(this->mCount++) = value;
            ReturnErrorOnFailure(this->Save(this->mStorage));
        }
        OnEntryAdded(value);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Store(const EntryType & value, bool do_override = true)
    {
        CHIP_ERROR err = this->Load(this->mStorage);
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND == err || CHIP_NO_ERROR == err, err);

        // Check existing
        for(size_t i = 0; i < this->mCount; ++i)
        {
            EntryType & e = this->Get(i);
            if(this->Compare(value, e))
            {
                // Already registered
                VerifyOrReturnError(do_override, CHIP_ERROR_DUPLICATE_KEY_ID);
                e = value;
                return this->Save(this->mStorage);
            }
        }
        // Insert last
        VerifyOrReturnError(this->mCount < this->mLimit, CHIP_ERROR_INVALID_LIST_LENGTH);
       this->Get(this->mCount++) = value;
        ReturnErrorOnFailure(this->Save(this->mStorage));
        OnEntryAdded(value);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Find(size_t index, EntryType & value)
    {
        ReturnErrorOnFailure(this->Load(this->mStorage));
        VerifyOrReturnError(index < this->mLimit, CHIP_ERROR_NOT_FOUND);
        VerifyOrReturnError(index < this->mCount, CHIP_ERROR_NOT_FOUND);
        value = this->Get(index);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Find(EntryType & value, bool do_create = false)
    {
        CHIP_ERROR err = this->Load(this->mStorage);
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND == err || CHIP_NO_ERROR == err, err);

        // Check existing
        for(size_t i = 0; i < this->mCount; ++i)
        {
            EntryType & e = this->Get(i);
            if(this->Compare(value, e))
            {
                value = e;
                return CHIP_NO_ERROR;
            }
        }
        // Insert last ?
        VerifyOrReturnError(do_create, CHIP_ERROR_NOT_FOUND);
        VerifyOrReturnError(this->mCount < this->mLimit, CHIP_ERROR_INVALID_LIST_LENGTH);
        this->Get(this->mCount++) = value;
        return this->Save(this->mStorage);
    }

    CHIP_ERROR Remove(size_t index)
    {
        ReturnErrorOnFailure(this->Load(this->mStorage));
        VerifyOrReturnError(index < this->mLimit, CHIP_ERROR_NOT_FOUND);
        VerifyOrReturnError(index < this->mCount, CHIP_ERROR_NOT_FOUND);
        EntryType old = this->Get(index);
        this->mCount--;
        for(size_t i = index; i < this->mCount; ++i)
        {
            mEntries[i] = mEntries[i + 1];
        }
        EntryType & last = this->Get(this->mCount);
        Clear(last);
        ReturnErrorOnFailure(this->Save(this->mStorage));
        OnEntryRemoved(old);
        return CHIP_NO_ERROR;
    }

    CHIP_ERROR Remove(EntryType & value)
    {
        ReturnErrorOnFailure(this->Load(this->mStorage));
        for(size_t i = 0; i < this->mCount; ++i)
        {
            if(this->Compare(this->Get(i), value))
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
    PersistentStorageDelegate * mStorage = nullptr;
    EntryType mEntries[kMaxListSize];
    size_t mLimit = kMaxListSize;
    size_t mCount = 0;
};


} // namespace chip
