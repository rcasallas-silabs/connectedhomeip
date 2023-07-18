#include "IcdManagementServer.h"
#include "IcdMonitoringTable.h"
#include <lib/core/CHIPConfig.h>

using namespace chip;
using namespace chip::Protocols;

namespace {

class IcdManagementServerImpl : public chip::IcdManagementServer
{
public:
    ~IcdManagementServerImpl() {}

    uint32_t GetIdleModeInterval() override { return CHIP_CONFIG_ICD_IDLE_MODE_INTERVAL; }

    uint32_t GetActiveModeInterval() override { return CHIP_CONFIG_ICD_ACTIVE_MODE_INTERVAL; }

    uint16_t GetActiveModeThreshold() override { return CHIP_CONFIG_ICD_ACTIVE_MODE_THRESHOLD; }

    uint32_t GetICDCounter() override { return mIcdCounter; }

    void SetICDCounter(uint32_t count) override { mIcdCounter = count; }

    uint16_t GetClientsSupportedPerFabric() override { return CHIP_CONFIG_ICD_CLIENTS_SUPPORTED_PER_FABRIC; }

    Status RegisterClient(PersistentStorageDelegate & storage, FabricIndex fabric_index, chip::NodeId node_id,
                          uint64_t monitored_subject, chip::ByteSpan key, Optional<chip::ByteSpan> verification_key,
                          bool is_admin) override
    {
        IcdMonitoringTable table(storage, fabric_index, GetClientsSupportedPerFabric());

        // Get current entry, if exists
        IcdMonitoringEntry entry;
        CHIP_ERROR err = table.Find(node_id, entry);
        if (CHIP_NO_ERROR == err)
        {
            // Existing entry: Validate Key if, and only if, the ISD has NOT administrator permissions
            if (!is_admin)
            {
                VerifyOrReturnError(verification_key.HasValue(), InteractionModel::Status::Failure);
                VerifyOrReturnError(verification_key.Value().data_equal(entry.key), InteractionModel::Status::Failure);
            }
        }
        else if (CHIP_ERROR_NOT_FOUND == err)
        {
            // New entry
            VerifyOrReturnError(entry.index < table.Limit(), InteractionModel::Status::ResourceExhausted);
        }
        else
        {
            // Error
            return InteractionModel::Status::Failure;
        }

        // Save
        entry.checkInNodeID    = node_id;
        entry.monitoredSubject = monitored_subject;
        entry.key              = key;
        err                    = table.Set(entry.index, entry);
        VerifyOrReturnError(CHIP_ERROR_INVALID_ARGUMENT != err, InteractionModel::Status::ConstraintError);
        VerifyOrReturnError(CHIP_NO_ERROR == err, InteractionModel::Status::Failure);

        return InteractionModel::Status::Success;
    }

    Status UnregisterClient(PersistentStorageDelegate & storage, FabricIndex fabric_index, chip::NodeId node_id,
                            Optional<chip::ByteSpan> key, bool is_admin) override
    {
        IcdMonitoringTable table(storage, fabric_index, GetClientsSupportedPerFabric());

        // Get current entry, if exists
        IcdMonitoringEntry entry;
        CHIP_ERROR err = table.Find(node_id, entry);
        VerifyOrReturnError(CHIP_ERROR_NOT_FOUND != err, InteractionModel::Status::NotFound);
        VerifyOrReturnError(CHIP_NO_ERROR == err, InteractionModel::Status::Failure);

        // Existing entry: Validate Key if, and only if, the ISD has NOT administrator permissions
        if (!is_admin)
        {
            VerifyOrReturnError(key.HasValue(), InteractionModel::Status::Failure);
            VerifyOrReturnError(key.Value().data_equal(entry.key), InteractionModel::Status::Failure);
        }

        err = table.Remove(entry.index);
        VerifyOrReturnError(CHIP_NO_ERROR == err, InteractionModel::Status::Failure);

        return InteractionModel::Status::Success;
    }

    Status StayActiveRequest(FabricIndex fabric_index) override
    {
        // TODO: Implementent stay awake logic for end device
        return InteractionModel::Status::UnsupportedCommand;
    }

private:
    uint32_t mIcdCounter = 0;
};

IcdManagementServerImpl gIcdManagementServer;

} // namespace

namespace chip {

IcdManagementServer & GetIcdManagementServer()
{
    return gIcdManagementServer;
}

} // namespace chip
