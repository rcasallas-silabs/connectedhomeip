/*
 *
 *    Copyright (c) 2021-2022 Project CHIP Authors
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
#include <credentials/GroupDataProviderBase.h>
#include <crypto/CHIPCryptoPAL.h>
#include <lib/core/TLV.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/CommonPersistentData.h>
#include <lib/support/DefaultStorageKeyAllocator.h>
#include <lib/support/PersistentData.h>
#include <lib/support/PersistentArray.h>
#include <lib/support/Pool.h>
#include <stdlib.h>

namespace chip {
    
char mDebugBuffer[256][PersistentStorageDelegate::kKeyLengthMax + 1];
size_t mDebugCount = 0;
size_t mDebugMax = 0;

bool Register(const char * value)
{
    // if(mDebugCount < 256)
    // {
    //     for(size_t i = 0; i < mDebugCount; i++)
    //     {
    //         if(0 == strncmp(mDebugBuffer[i], value, PersistentStorageDelegate::kKeyLengthMax))
    //         {
    //             return false;
    //         }
    //     }
    //     size_t len = strlen(value);
    //     if(len > mDebugMax) { mDebugMax = len; }
    //     strcpy(mDebugBuffer[mDebugCount++], value);
    //     ChipLogProgress(Zcl, "~~~ [%u] '%s'(%u/%u)", (unsigned)mDebugCount, value, (unsigned)len, (unsigned)mDebugMax);
    //     return true;
    // }
    return false;
}

namespace Credentials {

using GroupKey      = GroupDataProvider::GroupKey;
using GroupSession  = GroupDataProvider::GroupSession;


void GroupDataProviderBase::GroupKeyContext::Release()
{
    ReleaseKeys();
    mProvider.mGroupKeyContexPool.ReleaseObject(this);
}

CHIP_ERROR GroupDataProviderBase::GroupKeyContext::MessageEncrypt(const ByteSpan & plaintext, const ByteSpan & aad,
                                                                  const ByteSpan & nonce, MutableByteSpan & mic,
                                                                  MutableByteSpan & ciphertext) const
{
    uint8_t * output = ciphertext.data();
    return Crypto::AES_CCM_encrypt(plaintext.data(), plaintext.size(), aad.data(), aad.size(), mEncryptionKey, nonce.data(),
                                   nonce.size(), output, mic.data(), mic.size());
}

CHIP_ERROR GroupDataProviderBase::GroupKeyContext::MessageDecrypt(const ByteSpan & ciphertext, const ByteSpan & aad,
                                                                  const ByteSpan & nonce, const ByteSpan & mic,
                                                                  MutableByteSpan & plaintext) const
{
    uint8_t * output = plaintext.data();
    return Crypto::AES_CCM_decrypt(ciphertext.data(), ciphertext.size(), aad.data(), aad.size(), mic.data(), mic.size(),
                                   mEncryptionKey, nonce.data(), nonce.size(), output);
}

CHIP_ERROR GroupDataProviderBase::GroupKeyContext::PrivacyEncrypt(const ByteSpan & input, const ByteSpan & nonce,
                                                                  MutableByteSpan & output) const
{
    return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
}

CHIP_ERROR GroupDataProviderBase::GroupKeyContext::PrivacyDecrypt(const ByteSpan & input, const ByteSpan & nonce,
                                                                  MutableByteSpan & output) const
{
    return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
}

void GroupDataProviderBase::DebugFabric(FabricIndex fabric_index)
{
    ChipLogProgress(Zcl, "~~~ FABRIC[%u]", (unsigned) fabric_index);

    // GroupInfo
    size_t index = 0;
    GroupDataProvider::GroupInfo group;
    auto it  = this->IterateGroupInfo(fabric_index);
    ChipLogProgress(Zcl, "~~~   GROUPS(%u)", (unsigned) it->Count());
    while (it->Next(group))
    {
        ChipLogProgress(Zcl, "~~~     GROUP[%u] gid:%u, name:\"%s\"", (unsigned)index++, (unsigned) group.group_id, group.name);
    }
    it->Release();

    // Endpoints
    index = 0;
    GroupDataProvider::GroupEndpoint endpoint;
    auto it2  = this->IterateEndpoints(fabric_index);
    ChipLogProgress(Zcl, "~~~   ENDPOINTS(%u)", (unsigned) it2->Count());
    while (it2->Next(endpoint))
    {
        ChipLogProgress(Zcl, "~~~     END[%u] gid:%u, end:%u", (unsigned)index++, (unsigned)endpoint.group_id, (unsigned) endpoint.endpoint_id);
    }
    it2->Release();

    // GroupKeys
    index = 0;
    GroupDataProvider::GroupKey pair;
    auto it3  = this->IterateGroupKeys(fabric_index);
    ChipLogProgress(Zcl, "~~~   MAPPINGS(%u)", (unsigned) it3->Count());
    while (it3->Next(pair))
    {
        ChipLogProgress(Zcl, "~~~     MAP[%u] gid:%u, kid:%u", (unsigned)index++, (unsigned) pair.group_id, (unsigned) pair.keyset_id);
    }
    it3->Release();

    // KeySets
    index = 0;
    GroupDataProvider::KeySet keyset;
    auto it4  = this->IterateKeySets(fabric_index);
    ChipLogProgress(Zcl, "~~~   KEYSETS(%u)", (unsigned) it4->Count());
    while (it4->Next(keyset))
    {
        ChipLogProgress(Zcl, "~~~     KEYSET[%u] id:%u, n:%u", (unsigned)index++, (unsigned)keyset.keyset_id, (unsigned) keyset.num_keys_used);
        for(size_t i = 0; i < keyset.num_keys_used; ++i)
        {
            EpochKey &key = keyset.epoch_keys[i];
            ChipLogProgress(Zcl, "~~~       KEY[%u] t:%u, %02x %02x...", (unsigned)i, (unsigned)key.start_time, key.key[0], key.key[1]);
        }
    }
    it4->Release();
}



namespace {
GroupDataProvider * gGroupsProvider = nullptr;
} // namespace

GroupDataProvider * GetGroupDataProvider()
{
    return gGroupsProvider;
}

void SetGroupDataProvider(GroupDataProvider * provider)
{
    gGroupsProvider = provider;
}

} // namespace Credentials
} // namespace chip
