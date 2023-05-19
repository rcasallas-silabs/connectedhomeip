/**
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

// Disable CM cluster table until update is done
// https://github.com/project-chip/connectedhomeip/issues/24425
#include "IcdMonitoringTable.h"
#include <lib/support/DefaultStorageKeyAllocator.h>


namespace chip {

    enum class IcdTags : uint8_t
    {
        kRegisteredClient = static_cast<uint8_t>(PersistentTags::kEntryData) + 1,
        kKey,
    };


    CHIP_ERROR IcdMonitoringTable::UpdateKey(StorageKeyName & key)
    {
        VerifyOrReturnError(kUndefinedFabricIndex != mFabric, CHIP_ERROR_INVALID_FABRIC_INDEX);
        key = DefaultStorageKeyAllocator::IcdManagementTableEntry(mFabric);
        // ChipLogDetail(Zcl, "IcdMonitoringTable::UpdateKey: '%s'\n", key.KeyName());
        return CHIP_NO_ERROR;
    }

    void IcdMonitoringTable::Clear(IcdMonitoringEntry & entry)
    {
        entry.checkInNodeID = 0;
        entry.key = ByteSpan();
    }

    CHIP_ERROR IcdMonitoringTable::Serialize(TLV::TLVWriter & writer, const IcdMonitoringEntry & entry) const
    {
        ReturnErrorOnFailure(entry.EncodeForWrite(writer, TLV::ContextTag(IcdTags::kRegisteredClient)));
        return CHIP_NO_ERROR;

    }

    CHIP_ERROR IcdMonitoringTable::Deserialize(TLV::TLVReader & reader, IcdMonitoringEntry & entry)
    {
        ReturnErrorOnFailure(reader.Next(TLV::ContextTag(IcdTags::kRegisteredClient)));
        ReturnErrorOnFailure(entry.Decode(reader));
        entry.fabricIndex = mFabric;
        return CHIP_NO_ERROR;
    }


} // chip