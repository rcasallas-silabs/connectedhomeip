/*
 *    Copyright (c) 2025 Project CHIP Authors
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

#include <credentials/KeyManager.h>

namespace chip {
namespace Credentials {

class KeyManagerImpl: public KeyManager {

    class KeySetIteratorImpl : public KeySetIterator
    {
    public:
        KeySetIteratorImpl(KeyManagerImpl & manager, FabricTable *fabrics, FabricIndex fabric_index);
        size_t Count() override;
        bool Next(KeySet & output) override;
        void Release() override;

    protected:
        KeyManagerImpl & mManager;
        FabricTable *mFabrics = nullptr;
        FabricIndex mFabric = kUndefinedFabricIndex;
        uint16_t mNextId    = 0;
        size_t mCount       = 0;
        size_t mTotal       = 0;
    };

    virtual CHIP_ERROR SetKeySet(FabricIndex fabric_index, const ByteSpan & compressed_fabric_id, const KeySet & keys) override;
    virtual CHIP_ERROR GetKeySet(FabricIndex fabric_index, KeysetId keyset_id, KeySet & keys)                          override;
    virtual CHIP_ERROR RemoveKeySet(FabricIndex fabric_index, KeysetId keyset_id)                                      override;
    virtual KeySetIterator * IterateKeySets(FabricIndex fabric_index)                                                  override;
    KeyContext *CreateKeyContext(const Crypto::GroupOperationalCredentials &creds)                                     override;
    virtual CHIP_ERROR GetIpkKeySet(FabricIndex fabric_index, KeySet & out_keyset)                                     override;

private:
    ObjectPool<KeySetIteratorImpl, kIteratorsMax> mKeySetIteratorPool;
    ObjectPool<KeyContext, kIteratorsMax> mKeyContexPool;
};

} // namespace Credentials
} // namespace chip
