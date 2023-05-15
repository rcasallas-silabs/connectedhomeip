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
#include <lib/core/CHIPConfig.h>
#include <lib/core/CHIPPersistentStorageDelegate.h>
#include <lib/core/DataModelTypes.h>
#include <lib/support/CodeUtils.h>
// #include <lib/support/PersistentData.h>
#include "PersistentArray.h"

constexpr size_t kPersistentBufferMax = 1024;


namespace chip {

struct IcdMonitoringEntry : chip::app::Clusters::IcdManagement::Structs::MonitoringRegistrationStruct::Type
{
    bool IsValid() { return this->checkInNodeID != kUndefinedNodeId && this->fabricIndex != kUndefinedFabricIndex; }

    bool operator==(const IcdMonitoringEntry & other) const
    {
        return (this->fabricIndex == other.fabricIndex) && (this->checkInNodeID == other.checkInNodeID);
    }
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

struct IcdMonitoringTable: public PersistentArray<kPersistentBufferMax, CHIP_CONFIG_MAX_FABRICS, IcdMonitoringEntry> {

    IcdMonitoringTable(PersistentStorageDelegate * storage, FabricIndex fabric): 
        PersistentArray<kPersistentBufferMax, CHIP_CONFIG_MAX_FABRICS, IcdMonitoringEntry>(storage),
        mFabric(fabric) {}

    CHIP_ERROR UpdateKey(StorageKeyName & key) override;

    void Clear(IcdMonitoringEntry & entry) override;
    CHIP_ERROR Serialize(TLV::TLVWriter & writer, const IcdMonitoringEntry & entry) const override;
    CHIP_ERROR Deserialize(TLV::TLVReader & reader, IcdMonitoringEntry & entry) override;

    FabricIndex mFabric;
};

} // chip