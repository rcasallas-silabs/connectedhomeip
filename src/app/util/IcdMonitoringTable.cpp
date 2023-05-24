#include "IcdMonitoringTable.h"
#include <lib/support/CodeUtils.h>

namespace chip {


CHIP_ERROR IcdMonitoringEntry::UpdateKey(StorageKeyName & skey)
{
    VerifyOrReturnError(kUndefinedFabricIndex != this->fabricIndex, CHIP_ERROR_INVALID_FABRIC_INDEX);
    skey = DefaultStorageKeyAllocator::IcdManagementTableEntry(this->fabricIndex, index);
    return CHIP_NO_ERROR;
}

CHIP_ERROR IcdMonitoringEntry::Serialize(TLV::TLVWriter & writer) const
{
    return this->EncodeForWrite(writer, TLV::AnonymousTag());
}


CHIP_ERROR IcdMonitoringEntry::Deserialize(TLV::TLVReader & reader)
{
    ReturnErrorOnFailure(reader.Next(TLV::AnonymousTag()));
    return this->Decode(reader);
}


void IcdMonitoringEntry::Clear()
{
    this->fabricIndex = kUndefinedFabricIndex;
    this->checkInNodeID = kUndefinedNodeId;
}


CHIP_ERROR IcdMonitoringTable::Get(uint16_t index, IcdMonitoringEntry & entry)
{
    entry.fabricIndex = this->mFabric;
    entry.index = index;

    ReturnErrorOnFailure(entry.Load(this->mStorage));
    entry.fabricIndex = this->mFabric;
    return CHIP_NO_ERROR;
}

CHIP_ERROR IcdMonitoringTable::Find(NodeId id, IcdMonitoringEntry & entry)
{
    uint16_t index = 0;
    while(index < this->Limit())
    {
        ReturnErrorOnFailure(this->Get(index++, entry));
        if(id == entry.checkInNodeID)
        {
            return CHIP_NO_ERROR;
        }
    }
    entry.index = index;
    return CHIP_ERROR_NOT_FOUND;
}

CHIP_ERROR IcdMonitoringTable::Set(uint16_t index, IcdMonitoringEntry & entry)
{
    entry.fabricIndex = this->mFabric;
    entry.index = index;
    return entry.Save(this->mStorage);
}


CHIP_ERROR IcdMonitoringTable::Remove(NodeId id)
{
    IcdMonitoringEntry entry;
    ReturnErrorOnFailure(this->Find(id, entry));
    // Shift remaining entries down one position
    uint16_t index = entry.index;
    while(CHIP_NO_ERROR == this->Get(index + 1, entry))
    {
        ChipLogProgress(Zcl, "REMOVE[%u]", index);
        entry.Debug();
        this->Set(index++, entry);
    }
    // Remove
    entry.fabricIndex = this->mFabric;
    entry.index = index;
    return entry.Delete(this->mStorage);
}

uint16_t IcdMonitoringTable::Limit() {
    return mLimit;
}

} // namespace chip