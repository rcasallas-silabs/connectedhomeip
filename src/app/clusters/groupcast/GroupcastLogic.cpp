#include "GroupcastLogic.h"
#include <app/server/Server.h>

namespace chip {
namespace app {
namespace Clusters {

using chip::Groupcast::DataProvider;

CHIP_ERROR GroupcastLogic::ReadMembership(EndpointId endpoint, AttributeValueEncoder & aEncoder)
{
    DataProvider &provider = DataProvider::Instance();

    CHIP_ERROR err = aEncoder.EncodeList([&provider](const auto & encoder) -> CHIP_ERROR {
        CHIP_ERROR status = CHIP_NO_ERROR;
        for (auto & fabric : Server::GetInstance().GetFabricTable())
        {
            auto fabric_index = fabric.GetFabricIndex();
            auto iter         = provider.IterateGroups(fabric_index);
            VerifyOrReturnError(nullptr != iter, CHIP_ERROR_NO_MEMORY);
            chip::Groupcast::Group entry;
            while (iter->Next(entry) && (CHIP_NO_ERROR == status))
            {
                Groupcast::Structs::MembershipStruct::Type group;
                group.fabricIndex = fabric_index;
                group.groupID     = entry.group_id;
                group.endpoints   = DataModel::List<const chip::EndpointId>(entry.endpoints, entry.endpoint_count);
                status             = encoder.Encode(group);
            }
            iter->Release();
            VerifyOrReturnValue(CHIP_NO_ERROR == status, status);
        }
        return status;
    });
    return err;
}

CHIP_ERROR GroupcastLogic::ReadMaxMembershipCount(EndpointId endpoint, AttributeValueEncoder & aEncoder)
{
    return aEncoder.Encode(DataProvider::Instance().GetMaxMembershipCount());
}

CHIP_ERROR GroupcastLogic::JoinGroup(FabricIndex fabric_index, const Groupcast::Commands::JoinGroup::DecodableType & data)
{
    Server & server                          = Server::GetInstance();
    const FabricInfo * fabric = Server::GetInstance().GetFabricTable().FindFabricWithIndex(fabric_index);
    uint8_t compressed_fabric_id_buffer[sizeof(uint64_t)];
    MutableByteSpan compressed_fabric_id(compressed_fabric_id_buffer);
    DataProvider &provider = DataProvider::Instance();
    chip::Groupcast::Group group;
    uint8_t key[Crypto::CHIP_CRYPTO_SYMMETRIC_KEY_LENGTH_BYTES] = { 0 };
    size_t key_size   = 0;
    uint32_t grace_period = data.gracePeriod.HasValue() ?  data.gracePeriod.Value() : 0;

    // Collect arguments

    // Compressed fabric Id
    VerifyOrReturnValue(nullptr != fabric, CHIP_ERROR_INTERNAL);
    ReturnErrorOnFailure(fabric->GetCompressedFabricIdBytes(compressed_fabric_id));

    // Group
    group.group_id = data.groupID;

    // Endpoints
    group.endpoint_count = 0;
    {
        auto iter = data.endpoints.begin();
        while (iter.Next() && (group.endpoint_count < chip::Groupcast::kEndpointsMax))
        {
            group.endpoints[group.endpoint_count++] = iter.GetValue();
        }
    }

    // Parse Key
    VerifyOrReturnValue(data.key.size() == 2 * sizeof(key), CHIP_ERROR_INTERNAL);
    key_size = chip::Encoding::HexToBytes((char *) data.key.data(), data.key.size(), key, sizeof(key));
    VerifyOrReturnValue(key_size == sizeof(key), CHIP_ERROR_INTERNAL);

    // Store provider configuration
    ReturnErrorOnFailure(provider.AddGroup(fabric->GetFabricIndex(), compressed_fabric_id, group, ByteSpan(key), grace_period));

    // ACL
    ReturnErrorOnFailure(RegisterAccessControl(fabric->GetFabricIndex(), group.group_id));

    server.GetTransportManager().MulticastGroupJoinLeave(Transport::PeerAddress::Groupcast(), true);
    return CHIP_NO_ERROR;
}

CHIP_ERROR GroupcastLogic::LeaveGroup(FabricIndex fabric_index, chip::Groupcast::Group &old_group, const Groupcast::Commands::LeaveGroup::DecodableType & data,
                                  Groupcast::Commands::LeaveGroupResponse::Type &response)
{
    DataProvider &provider = DataProvider::Instance();
    old_group.group_id = data.groupID;

    response.groupID = old_group.group_id;
    ReturnErrorOnFailure(provider.GetGroup(fabric_index, old_group));
    if(data.endpoints.HasValue()) {
        // Remove endpoints
        chip::Groupcast::Group new_group(data.groupID);

        for(size_t i=0; i < old_group.endpoint_count; ++i) {
            bool found = false;
            auto iter = data.endpoints.Value().begin();
            while(!found && iter.Next()) {
                found = (old_group.endpoints[i] == iter.GetValue());
            }
            if(!found) {
                // Keep: not in the remove group
                new_group.endpoints[new_group.endpoint_count++] = old_group.endpoints[i];
            }
        }
        if(new_group.endpoint_count > 0) {
            return provider.SetEndpoints(fabric_index, new_group);
        }
    }

    // Remove whole group
    DataModel::List<const chip::EndpointId> endpoints(old_group.endpoints, old_group.endpoint_count);
    response.endpoints.SetValue(endpoints);
    return provider.RemoveGroup(fabric_index, data.groupID);

}

CHIP_ERROR GroupcastLogic::UpdateGroupKey(FabricIndex fabric_index, const Groupcast::Commands::UpdateGroupKey::DecodableType & data)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupcastLogic::ExpireGracePeriod(FabricIndex fabric_index, const Groupcast::Commands::ExpireGracePeriod::DecodableType & data)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupcastLogic::ConfigureAuxiliaryACL(FabricIndex fabric_index, const Groupcast::Commands::ConfigureAuxiliaryACL::DecodableType & data)
{
    return CHIP_ERROR_NOT_IMPLEMENTED;
}

CHIP_ERROR GroupcastLogic::RegisterAccessControl(FabricIndex fabric_index, GroupId group_id)
{
    Access::AccessControl::Delegate *access = Access::Groupcast::GetAccessControlDelegate();
    VerifyOrReturnError(nullptr != access, CHIP_ERROR_INTERNAL);
    Access::AccessControl::Entry e;
    ReturnErrorOnFailure(access->PrepareEntry(e));
    size_t index = 0; // TODO: GetEntryCount(size_t & value)
    if(CHIP_NO_ERROR == access->ReadEntry(index, e, &fabric_index)) {
        // Existing entry
        size_t subject_count = 0;
        NodeId subject = 0;
        // Check if the given group is already a subject
        ReturnErrorOnFailure(e.GetSubjectCount(subject_count));
        bool found = false;
        for(size_t i=0; !found && (i < subject_count); ++i) {
            ReturnErrorOnFailure(e.GetSubject(i, subject));
            found = (subject == group_id);
        }
        // ChipLogDetail(DeviceLayer, "~~~ GROUPCAST: EXISTING: %u", (unsigned)found);
        if(!found) {
            // New group subject
            size_t subject_index = 0;
            ReturnErrorOnFailure(e.AddSubject(&subject_index, group_id));
            ReturnErrorOnFailure(access->UpdateEntry(index, e, &fabric_index));
        }
    }
    else {
        // New entry
        e.SetFabricIndex(fabric_index);
        e.SetPrivilege(Access::Privilege::kOperate);
        e.SetAuthMode(Access::AuthMode::kGroup);
        e.AddSubject(&index, group_id);
        ReturnErrorOnFailure(access->CreateEntry(&index, e, &fabric_index));
        // ChipLogDetail(DeviceLayer, "~~~ GROUPCAST: NEW: #%04x, i:%u", (unsigned)err.AsInteger(), (unsigned)index);
        VerifyOrReturnError(0 == index, CHIP_ERROR_SENTINEL);
    }
    return CHIP_NO_ERROR;
}

} // namespace Clusters
} // namespace app
} // namespace chip