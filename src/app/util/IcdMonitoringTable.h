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
#pragma once

#include <app-common/zap-generated/cluster-objects.h>
#include <app-common/zap-generated/attributes/Accessors.h>
#include <lib/core/CHIPConfig.h>
#include <lib/core/CHIPPersistentStorageDelegate.h>
#include <lib/core/DataModelTypes.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/PersistentData.h>
#include <stddef.h>


namespace chip {

constexpr size_t kIcdMonitoringBufferSize = 1024;



struct IcdMonitoringEntry: public PersistentData<kIcdMonitoringBufferSize>, chip::app::Clusters::IcdManagement::Structs::MonitoringRegistrationStruct::Type
{

    IcdMonitoringEntry(FabricIndex fabric = kUndefinedFabricIndex, NodeId nodeId = kUndefinedNodeId)
    {
        this->fabricIndex = fabric;
        this->checkInNodeID = nodeId;
        this->monitoredSubject = nodeId;
    }

    bool IsValid() { return this->checkInNodeID != kUndefinedNodeId && this->fabricIndex != kUndefinedFabricIndex; }

    bool operator==(const IcdMonitoringEntry & other) const
    {
        return (this->fabricIndex == other.fabricIndex) && (this->checkInNodeID == other.checkInNodeID);
    }

    CHIP_ERROR UpdateKey(StorageKeyName & key) override;
    CHIP_ERROR Serialize(TLV::TLVWriter & writer) const override;
    CHIP_ERROR Deserialize(TLV::TLVReader & reader) override;
    void Clear();

    void Debug() const {
        ChipLogDetail(Zcl, "Entry[%u] f:%u id:#%lx, k(%lu)", this->index, this->fabricIndex, (unsigned long)this->checkInNodeID, (unsigned long)this->key.size());
        ChipLogByteSpan(Zcl, this->key);
    }

    uint16_t index = 0;
};


/**
 * @brief IcdMonitoringTable exists to manage the persistence of entries in the ClientMonitoring Cluster.
 *        To access persisted data with the IcdMonitoringTable class, instantiate an instance of this class
 *        and call the LoadFromStorage function.
 *
 *        This class can only manage one fabric at a time. The flow is load a fabric, execute necessary operations,
 *        save it if there are any changes and load another fabric.
 *
 *        Issue to refactor the class to use one entry for the entire table
 *        https://github.com/project-chip/connectedhomeip/issues/24288
 */

struct IcdMonitoringTable
{
    IcdMonitoringTable(PersistentStorageDelegate * storage, FabricIndex fabric):
        mStorage(storage),
        mFabric(fabric),
        mLimit(1)
    {
        chip::app::Clusters::IcdManagement::Attributes::ClientsSupportedPerFabric::Get(0, &mLimit);
    }
    CHIP_ERROR Get(uint16_t index, IcdMonitoringEntry & entry);
    CHIP_ERROR Set(uint16_t index, IcdMonitoringEntry & entry);
    CHIP_ERROR Find(NodeId id, IcdMonitoringEntry & entry);
    CHIP_ERROR Remove(NodeId id);
    // uint16_t Count();
    uint16_t Limit();

    PersistentStorageDelegate * mStorage;
    FabricIndex mFabric;
    uint16_t mLimit = 0;
};

} // chip