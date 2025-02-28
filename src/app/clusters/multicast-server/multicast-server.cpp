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

#include "multicast-server.h"

#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/cluster-objects.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/CommandHandler.h>
#include <app/reporting/reporting.h>
#include <app/util/config.h>
#include <inttypes.h>
#include <lib/support/CodeUtils.h>
#include <tracing/macros.h>
// #include <credentials/GroupDataProvider.h>

using namespace chip;
using namespace app::Clusters;
using namespace app::Clusters::Multicast;
using Protocols::InteractionModel::Status;

namespace chip {
namespace Multicast {

CHIP_ERROR MulticastTargetList::UpdateKey(StorageKeyName & key)
{
    VerifyOrReturnError(kUndefinedFabricIndex != mFabric, CHIP_ERROR_INVALID_FABRIC_INDEX);
    key = DefaultStorageKeyAllocator::MulticastTargets(mFabric);
    return CHIP_NO_ERROR;
}

void MulticastTargetList::Clear(Target & entry)
{
}

CHIP_ERROR MulticastTargetList::Serialize(TLV::TLVWriter & writer, const Target & entry) const
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR MulticastTargetList::Deserialize(TLV::TLVReader & reader, Target & entry)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

} // namespace chip
} // namespace Multicast

// #error RJ-SERVER-1

void emberAfMulticastClusterServerInitCallback(chip::EndpointId endpoint) {}


bool emberAfMulticastClusterAddTargetCallback(
    chip::app::CommandHandler * commandObj, const chip::app::ConcreteCommandPath & commandPath,
    const chip::app::Clusters::Multicast::Commands::AddTarget::DecodableType & commandData)
{
    return false;
}
