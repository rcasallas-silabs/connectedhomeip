/**
 *
 *    Copyright (c) 2020 Project CHIP Authors
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

#include <app/util/basic-types.h>
#include <app/storage/FabricTableImpl.h> // nogncheck
#include <app/storage/TableEntry.h> // nogncheck
#include <crypto/CHIPCryptoPAL.h>
#include <crypto/SessionKeystore.h>
#include <lib/core/CHIPPersistentStorageDelegate.h>
#include <lib/support/CommonIterator.h>
#include <lib/support/Pool.h>
#include <lib/support/Span.h>
#include <string.h>
#include <functional>

namespace chip {
namespace Groupcast {

constexpr size_t kMaxMembershipCount   = CHIP_CONFIG_MAX_GROUPCAST_MEMBERSHIP_COUNT;
constexpr size_t kMaxGroupsPerFabric   = kMaxMembershipCount;
constexpr size_t kMaxEndpointsPerGroup = kMaxGroupsPerFabric;


struct GroupDataId
{
    // Identifies group within the scope of the given fabric
    GroupId mGroupId = kUndefinedGroupId;

    GroupDataId(GroupId groupId = kUndefinedGroupId) : mGroupId(groupId) {}

    void Clear()
    {
        mGroupId = kUndefinedGroupId;
    }

    bool IsValid() { return (mGroupId != kUndefinedGroupId); }

    bool operator==(const GroupDataId & other) const { return (mGroupId == other.mGroupId); }
};


struct GroupData
{
    GroupData() = default;
    GroupData(GroupId gid) : groupID(gid) {}
    GroupData(GroupId gid, KeysetId kid) : groupID(gid), keyID(kid) {}

    GroupData & operator=(const GroupData & t)
    {
        this->groupID       = t.groupID;
        this->endpointCount = t.endpointCount;
        memcpy(this->endpoints, t.endpoints, this->endpointCount * sizeof(EndpointId));
        return *this;
    }

    void Clear()
    {
        groupID = kUndefinedGroupId;
        keyID = 0;
        endpointCount = 0;
        memset(endpoints, 0, sizeof(endpoints));
    }

    GroupId groupID        = kUndefinedGroupId;
    KeysetId keyID         = 0;
    uint16_t endpointCount = 0;
    EndpointId endpoints[kMaxEndpointsPerGroup];
};


class GroupList: public app::Storage::FabricTableImpl<GroupDataId, GroupData>
{
public:
    using Super = app::Storage::FabricTableImpl<GroupDataId, GroupData>;
    using Entry = app::Storage::Data::TableEntryRef<GroupDataId, GroupData>;

    GroupList() : Super(kMaxGroupsPerFabric, kMaxEndpointsPerGroup) {
        SetEndpoint(kRootEndpointId);
    }
    ~GroupList() { Finish(); };
};


struct DataProvider
{
    using KeyContext = chip::Crypto::SymmetricKeyContext;
    using IteratorCallback = std::function<CHIP_ERROR(CommonIterator<GroupData> & iterator)>;

    DataProvider() = default;

    static DataProvider & Instance();
    CHIP_ERROR Initialize(PersistentStorageDelegate * storage, chip::Crypto::SessionKeystore * keystore);
    bool IsInitialized();
    uint8_t GetMaxMembershipCount();
    CHIP_ERROR SetGroup(chip::FabricIndex fabric_index, GroupData & group);
    CHIP_ERROR GetGroup(FabricIndex fabric_index, GroupData & group);
    CHIP_ERROR RemoveGroup(FabricIndex fabric_index, GroupId groupID);
    CHIP_ERROR SetEndpoints(FabricIndex fabric_index, GroupData & group);

    CHIP_ERROR IterateGroups(FabricIndex fabric, IteratorCallback iterateFn);
    // CHIP_ERROR IterateGroups(FabricIndex fabric);
    // chip::Crypto::SymmetricKeyContext * CreateKeyContext(FabricIndex fabric, GroupId groupId);
    // KeyIterator * IterateKeys(FabricTable *fabrics, GroupId groupID, uint16_t session_id);
    // GroupIterator * IterateGroups(FabricIndex fabric);

private:
    GroupList mList;
    PersistentStorageDelegate * mStorage      = nullptr;
    chip::Crypto::SessionKeystore * mKeystore = nullptr;
};

} // namespace Groupcast
} // namespace chip
