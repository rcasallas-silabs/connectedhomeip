/*
 *
 *    Copyright (c) 2026 Project CHIP Authors
 *    All rights reserved.
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

#include "Privilege.h"
#include "RequestPath.h"
#include "SubjectDescriptor.h"
#include <lib/core/CHIPConfig.h>

namespace chip {
namespace Access {

struct AuxiliaryACL
{
    FabricIndex fabric_index;
    GroupId group_id;

    bool operator==(const AuxiliaryACL & other) const
    {
        return (this->fabric_index == other.fabric_index) && (this->group_id == other.group_id);
    }
    AuxiliaryACL & operator=(const AuxiliaryACL & other)
    {
        this->fabric_index = other.fabric_index;
        this->group_id     = other.group_id;
        return *this;
    }
};

struct AuxiliaryChecker
{
    static constexpr uint16_t kMaxEntries = CHIP_CONFIG_MAX_FABRICS * CHIP_CONFIG_MAX_GROUPS_PER_FABRIC;

    CHIP_ERROR Add(const AuxiliaryACL & acl);
    bool Has(const AuxiliaryACL & acl);
    CHIP_ERROR Reset(FabricIndex fabric_index);

    CHIP_ERROR Check(const SubjectDescriptor & subjectDescriptor, const RequestPath & requestPath, Privilege requestPrivilege);

private:
    uint16_t mEntryCount = 0;
    AuxiliaryACL mEntries[kMaxEntries];
};

} // namespace Access
} // namespace chip
