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

#pragma once

#include <app/util/basic-types.h>
#include <lib/core/CHIPPersistentStorageDelegate.h>
#include <lib/core/Optional.h>
#include <lib/support/Span.h>
#include <protocols/interaction_model/StatusCode.h>

namespace chip {

using chip::Protocols::InteractionModel::Status;

class IcdManagementServer
{
public:
    virtual ~IcdManagementServer(){};
    virtual uint32_t GetIdleModeInterval()          = 0;
    virtual uint32_t GetActiveModeInterval()        = 0;
    virtual uint16_t GetActiveModeThreshold()       = 0;
    virtual uint32_t GetICDCounter()                = 0;
    virtual void SetICDCounter(uint32_t count)      = 0;
    virtual uint16_t GetClientsSupportedPerFabric() = 0;

    virtual Status RegisterClient(PersistentStorageDelegate & storage, FabricIndex fabric_index, chip::NodeId node_id,
                                  uint64_t monitored_subject, chip::ByteSpan key, Optional<chip::ByteSpan> verification_key,
                                  bool is_admin) = 0;

    virtual Status UnregisterClient(PersistentStorageDelegate & storage, FabricIndex fabric_index, chip::NodeId node_id,
                                    Optional<chip::ByteSpan> key, bool is_admin) = 0;

    virtual Status StayActiveRequest(FabricIndex fabric_index) = 0;
};

IcdManagementServer & GetIcdManagementServer();

} // namespace chip
