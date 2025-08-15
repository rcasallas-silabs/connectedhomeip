// DO NOT EDIT MANUALLY - Generated file
//
// Cluster metadata information for cluster Groupcast (cluster code: 100/0x64)
// based on src/controller/data_model/controller-clusters.matter
#pragma once

#include <app/data-model-provider/MetadataTypes.h>
#include <lib/core/DataModelTypes.h>

#include <cstdint>

#include <clusters/Groupcast/Ids.h>

namespace chip {
namespace app {
namespace Clusters {
namespace Groupcast {

inline constexpr uint32_t kRevision = 1;

namespace Attributes {
namespace Membership {
inline constexpr DataModel::AttributeEntry
    kMetadataEntry(Membership::Id, BitFlags<DataModel::AttributeQualityFlags>(DataModel::AttributeQualityFlags::kListAttribute),
                   Access::Privilege::kView, std::nullopt);
} // namespace Membership
namespace MaxMembershipCount {
inline constexpr DataModel::AttributeEntry kMetadataEntry(MaxMembershipCount::Id, BitFlags<DataModel::AttributeQualityFlags>(),
                                                          Access::Privilege::kView, std::nullopt);
} // namespace MaxMembershipCount

} // namespace Attributes

namespace Commands {
namespace JoinGroup {
inline constexpr DataModel::AcceptedCommandEntry
    kMetadataEntry(JoinGroup::Id, BitFlags<DataModel::CommandQualityFlags>(DataModel::CommandQualityFlags::kFabricScoped),
                   Access::Privilege::kAdminister);
} // namespace JoinGroup
namespace LeaveGroup {
inline constexpr DataModel::AcceptedCommandEntry
    kMetadataEntry(LeaveGroup::Id, BitFlags<DataModel::CommandQualityFlags>(DataModel::CommandQualityFlags::kFabricScoped),
                   Access::Privilege::kAdminister);
} // namespace LeaveGroup
namespace LeaveAllGroups {
inline constexpr DataModel::AcceptedCommandEntry
    kMetadataEntry(LeaveAllGroups::Id, BitFlags<DataModel::CommandQualityFlags>(DataModel::CommandQualityFlags::kFabricScoped),
                   Access::Privilege::kAdminister);
} // namespace LeaveAllGroups

} // namespace Commands

namespace Events {} // namespace Events
} // namespace Groupcast
} // namespace Clusters
} // namespace app
} // namespace chip
