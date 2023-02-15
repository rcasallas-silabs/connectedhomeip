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
#include <credentials/GroupDataProviderImpl.h>
#include <crypto/CHIPCryptoPAL.h>
#include <lib/core/TLV.h>
#include <lib/support/CodeUtils.h>
#include <lib/support/CommonPersistentData.h>
#include <lib/support/DefaultStorageKeyAllocator.h>
#include <lib/support/PersistentData.h>
#include <lib/support/Pool.h>
#include <stdlib.h>

namespace chip {
namespace Credentials {

using GroupInfo     = GroupDataProvider::GroupInfo;
using GroupKey      = GroupDataProvider::GroupKey;
using GroupEndpoint = GroupDataProvider::GroupEndpoint;
using EpochKey      = GroupDataProvider::EpochKey;
using KeySet        = GroupDataProvider::KeySet;
using GroupSession  = GroupDataProvider::GroupSession;


//------------------------------------------------------------------------------
// Initialization
//------------------------------------------------------------------------------


CHIP_ERROR GroupDataProviderImpl::Init()
{
    if (mStorage == nullptr)
    {
        return CHIP_ERROR_INCORRECT_STATE;
    }
    return CHIP_NO_ERROR;
}

void GroupDataProviderImpl::Finish()
{
    mGroupInfoIterators.ReleaseAll();
    mGroupKeyIterators.ReleaseAll();
    mEndpointIterators.ReleaseAll();
    mKeySetIterators.ReleaseAll();
    mGroupSessionsIterator.ReleaseAll();
    mGroupKeyContexPool.ReleaseAll();
}

void GroupDataProviderImpl::SetStorageDelegate(PersistentStorageDelegate * storage)
{
    VerifyOrDie(storage != nullptr);
    mStorage = storage;
}

//------------------------------------------------------------------------------
// Group Table
//------------------------------------------------------------------------------


CHIP_ERROR GroupDataProviderImpl::SetGroupInfo(FabricIndex fabric_index, const GroupInfo & info)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetGroupInfo(FabricIndex fabric_index, GroupId group_id, GroupInfo & info)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveGroupInfo(FabricIndex fabric_index, GroupId group_id)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// By index

CHIP_ERROR GroupDataProviderImpl::SetGroupInfoAt(FabricIndex fabric_index, size_t index, const GroupInfo & info)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetGroupInfoAt(FabricIndex fabric_index, size_t index, GroupInfo & info)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveGroupInfoAt(FabricIndex fabric_index, size_t index)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
// Endpoints

bool GroupDataProviderImpl::HasEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id)
{
    return false;
}

CHIP_ERROR GroupDataProviderImpl::AddEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::RemoveEndpoint(FabricIndex fabric_index, GroupId group_id, EndpointId endpoint_id)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveEndpoint(FabricIndex fabric_index, EndpointId endpoint_id)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProvider::GroupInfoIterator * GroupDataProviderImpl::IterateGroupInfo(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupInfoIterators.CreateObject(*this, fabric_index);
}


GroupDataProvider::EndpointIterator * GroupDataProviderImpl::IterateEndpoints(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mEndpointIterators.CreateObject(*this, fabric_index);
}

//------------------------------------------------------------------------------
// Group-Key map
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::SetGroupKeyAt(FabricIndex fabric_index, size_t index, const GroupKey & info)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetGroupKeyAt(FabricIndex fabric_index, size_t index, GroupKey & info)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveGroupKeyAt(FabricIndex fabric_index, size_t index)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveGroupKeys(FabricIndex fabric_index)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


GroupDataProvider::GroupKeyIterator * GroupDataProviderImpl::IterateGroupKeys(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupKeyIterators.CreateObject(*this, fabric_index);
}

//------------------------------------------------------------------------------
// Key Sets
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::SetKeySet(FabricIndex fabric_index, const ByteSpan & compressed_fabric_id, const KeySet & keys)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetKeySet(FabricIndex fabric_index, KeysetId keyset_id, KeySet & keys)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::RemoveKeySet(FabricIndex fabric_index, KeysetId keyset_id)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


CHIP_ERROR GroupDataProviderImpl::GetIpkKeySet(FabricIndex fabric_index, KeySet & out_keyset)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


GroupDataProvider::KeySetIterator * GroupDataProviderImpl::IterateKeySets(FabricIndex fabric_index)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mKeySetIterators.CreateObject(*this, fabric_index);
}


//------------------------------------------------------------------------------
// Fabrics
//------------------------------------------------------------------------------

CHIP_ERROR GroupDataProviderImpl::RemoveFabric(FabricIndex fabric_index)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}


GroupDataProvider::GroupSessionIterator * GroupDataProviderImpl::IterateGroupSessions(uint16_t session_id)
{
    VerifyOrReturnError(IsInitialized(), nullptr);
    return mGroupSessionsIterator.CreateObject(*this, session_id);
}


Crypto::SymmetricKeyContext * GroupDataProviderImpl::GetKeyContext(FabricIndex fabric_index, GroupId group_id)
{
    return nullptr;
}

//------------------------------------------------------------------------------
// Iterators
//------------------------------------------------------------------------------


GroupDataProviderImpl::GroupInfoIteratorImpl::GroupInfoIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index) :
    mProvider(provider),
    mFabric(fabric_index)
{

}


size_t GroupDataProviderImpl::GroupInfoIteratorImpl::Count()
{
    return 0;
}


bool GroupDataProviderImpl::GroupInfoIteratorImpl::Next(GroupInfo & output)
{
    return false;
}


void GroupDataProviderImpl::GroupInfoIteratorImpl::Release()
{
    mProvider.mGroupInfoIterators.ReleaseObject(this);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProviderImpl::GroupKeyIteratorImpl::GroupKeyIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index) :
    mProvider(provider),
    mFabric(fabric_index)
{
}


size_t GroupDataProviderImpl::GroupKeyIteratorImpl::Count()
{
    return 0;
}


bool GroupDataProviderImpl::GroupKeyIteratorImpl::Next(GroupKey & output)
{
    return false;
}


void GroupDataProviderImpl::GroupKeyIteratorImpl::Release()
{
    mProvider.mGroupKeyIterators.ReleaseObject(this);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProviderImpl::EndpointIteratorImpl::EndpointIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index) :
    mProvider(provider),
    mFabric(fabric_index)
{
}


size_t GroupDataProviderImpl::EndpointIteratorImpl::Count()
{
    return 0;
}


bool GroupDataProviderImpl::EndpointIteratorImpl::Next(GroupEndpoint & output)
{
    return false;
}


void GroupDataProviderImpl::EndpointIteratorImpl::Release()
{
    mProvider.mEndpointIterators.ReleaseObject(this);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProviderImpl::KeySetIteratorImpl::KeySetIteratorImpl(GroupDataProviderImpl & provider, FabricIndex fabric_index) :
    mProvider(provider), mFabric(fabric_index)
{
}

size_t GroupDataProviderImpl::KeySetIteratorImpl::Count()
{
    return 0;
}


bool GroupDataProviderImpl::KeySetIteratorImpl::Next(KeySet & output)
{
    return false;
}


void GroupDataProviderImpl::KeySetIteratorImpl::Release()
{
    mProvider.mKeySetIterators.ReleaseObject(this);
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

GroupDataProviderImpl::GroupSessionIteratorImpl::GroupSessionIteratorImpl(GroupDataProviderImpl & provider, uint16_t session_id):
    mProvider(provider), mSessionId(session_id), mGroupKeyContext(provider)
{
}


size_t GroupDataProviderImpl::GroupSessionIteratorImpl::Count()
{
    return 0;
}


bool GroupDataProviderImpl::GroupSessionIteratorImpl::Next(GroupSession & output)
{
    return false;
}


void GroupDataProviderImpl::GroupSessionIteratorImpl::Release()
{
    mProvider.mGroupSessionsIterator.ReleaseObject(this);
}


//------------------------------------------------------------------------------
// Encryption
//------------------------------------------------------------------------------



CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::MessageEncrypt(const ByteSpan & plaintext, const ByteSpan & aad, const ByteSpan & nonce, MutableByteSpan & mic,
                            MutableByteSpan & ciphertext) const
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::MessageDecrypt(const ByteSpan & ciphertext, const ByteSpan & aad, const ByteSpan & nonce, const ByteSpan & mic,
                            MutableByteSpan & plaintext) const
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::PrivacyEncrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const

{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupDataProviderImpl::GroupKeyContext::PrivacyDecrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

void GroupDataProviderImpl::GroupKeyContext::Release()
{
    memset(mEncryptionKey, 0, sizeof(mEncryptionKey));
    memset(mPrivacyKey, 0, sizeof(mPrivacyKey));
    mProvider.mGroupKeyContexPool.ReleaseObject(this);
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
