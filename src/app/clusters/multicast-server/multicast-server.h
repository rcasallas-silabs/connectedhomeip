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
#include <lib/support/Span.h>

#include <credentials/PersistentData.h>
#include <lib/support/DefaultStorageKeyAllocator.h>

namespace chip {
namespace Multicast {

constexpr size_t kPersistentBufferMax = 1024;

struct Target
{
    Target() = default;
    Target(FabricIndex fabric, GroupId id, const ByteSpan &key):
        mFabric(fabric), mTargetId(id), mKey(key) {}
    
    FabricIndex mFabric;
    GroupId mTargetId = kUndefinedGroupId;
    const ByteSpan mKey;

    bool operator==(const Target & other) const
    {
        return this->mTargetId == other.mTargetId;
    }
};

struct MulticastTargetList: public PersistentArray<kPersistentBufferMax, CHIP_CONFIG_MAX_FABRICS, Target> {

    MulticastTargetList(FabricIndex fabric, PersistentStorageDelegate * storage):
        PersistentArray<kPersistentBufferMax, CHIP_CONFIG_MAX_FABRICS, Target>(storage),
        mFabric(fabric) {}

    CHIP_ERROR UpdateKey(StorageKeyName & key) override;
    void Clear(Target & entry) override;
    CHIP_ERROR Serialize(TLV::TLVWriter & writer, const Target & entry) const override;
    CHIP_ERROR Deserialize(TLV::TLVReader & reader, Target & entry) override;

private:
    FabricIndex mFabric;
};

} // namespace chip
} // namespace Multicast
