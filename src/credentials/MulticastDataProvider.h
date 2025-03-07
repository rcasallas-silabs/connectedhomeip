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
 #include <credentials/FabricTable.h>
 #include <crypto/CHIPCryptoPAL.h>
 #include <crypto/SessionKeystore.h>
 #include <lib/support/Span.h>
 #include <lib/core/CHIPPersistentStorageDelegate.h>

 namespace chip {
 namespace Multicast {
 
 constexpr size_t kEndpointsMax = 8;
 
struct Target
{
    Target() = default;
    Target(GroupId id): mTargetId(id) {}

    bool operator==(const Target & other) const
    {
        return this->mTargetId == other.mTargetId;
    }

    GroupId mTargetId = kUndefinedGroupId;
    uint16_t mEndpointCount = 0;
    EndpointId mEndpoints[kEndpointsMax];
    Crypto::Aes128KeyHandle mEncryptionKey;
    Crypto::Aes128KeyHandle mPrivacyKey;
};
 
struct DataProvider
{
    DataProvider() = default;

    static DataProvider &Instance();
    CHIP_ERROR Initialize(PersistentStorageDelegate *storage, chip::Crypto::SessionKeystore *keystore);
    CHIP_ERROR SetTarget(const FabricInfo *fabric, const ByteSpan &key, Target &target);
    CHIP_ERROR GetTarget(FabricIndex fabric_idx, Target &target);
    chip::Crypto::SymmetricKeyContext *CreateKeyContext(FabricIndex fabric, GroupId groupId);

private:
    PersistentStorageDelegate *mStorage = nullptr;
    chip::Crypto::SessionKeystore *mKeystore = nullptr;
};
 
 } // namespace chip
 } // namespace Multicast
 