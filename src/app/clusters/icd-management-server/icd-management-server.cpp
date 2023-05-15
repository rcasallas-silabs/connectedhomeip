/**
 *
 *    Copyright (c) 2023 Project CHIP Authors
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

#include "icd-management-server.h"

#include "app/server/Server.h"
#include <app-common/zap-generated/attributes/Accessors.h>
#include <app-common/zap-generated/cluster-objects.h>
#include <app-common/zap-generated/ids/Clusters.h>
#include <app/AttributeAccessInterface.h>
#include <app/CommandHandler.h>
#include <app/ConcreteAttributePath.h>
#include <app/util/IcdMonitoringTable.h>
#include <app/util/af.h>
#include <app/util/attribute-storage.h>

using namespace chip;
using namespace chip::app;
using namespace chip::app::Clusters;
using namespace chip::app::Clusters::IcdManagement;
using namespace Protocols;


//==============================================================================

namespace {

/**
 * @brief Implementation of attribute access for IcdManagement cluster
 */
class IcdManagementAttributeAccess : public app::AttributeAccessInterface
{
public:
    IcdManagementAttributeAccess() : AttributeAccessInterface(MakeOptional(kRootEndpointId), IcdManagement::Id) {}

    CHIP_ERROR Read(const ConcreteReadAttributePath & aPath, AttributeValueEncoder & aEncoder) override;
    CHIP_ERROR Write(const ConcreteDataAttributePath & aPath, AttributeValueDecoder & aDecoder) override;

private:
    CHIP_ERROR ReadExpectedClients(EndpointId endpoint, AttributeValueEncoder & encoder);
};

CHIP_ERROR IcdManagementAttributeAccess::Read(const ConcreteReadAttributePath & aPath, AttributeValueEncoder & aEncoder)
{
    VerifyOrDie(aPath.mClusterId == IcdManagement::Id);

    switch (aPath.mAttributeId)
    {
    case IcdManagement::Attributes::RegisteredClients::Id:
        return ReadExpectedClients(aPath.mEndpointId, aEncoder);

    default:
        break;
    }

    return CHIP_NO_ERROR;
}

CHIP_ERROR IcdManagementAttributeAccess::Write(const ConcreteDataAttributePath & aPath, AttributeValueDecoder & aDecoder)
{
    return CHIP_IM_GLOBAL_STATUS(UnsupportedWrite);
}

CHIP_ERROR IcdManagementAttributeAccess::ReadExpectedClients(EndpointId endpoint, AttributeValueEncoder & encoder)
{
    FabricIndex fabric = encoder.AccessingFabricIndex();

    return encoder.EncodeList([fabric](const auto & subEncoder) -> CHIP_ERROR {

        auto storage = & chip::Server::GetInstance().GetPersistentStorage();
        IcdMonitoringTable table(storage, fabric);
        CHIP_ERROR err = table.Load(storage);

        if (err == CHIP_NO_ERROR)
        {
            for(uint16_t i = 0; i < table.Count(); ++i) {
                auto e = table.At(i);
                ReturnErrorOnFailure(subEncoder.Encode(e));                
            }
        }
        else if (err == CHIP_ERROR_PERSISTED_STORAGE_VALUE_NOT_FOUND)
        {
            // No Entries saved for this fabric. Return empty list
            err = CHIP_NO_ERROR;
        }

        return err;
        return CHIP_NO_ERROR;
    });
}

IcdManagementAttributeAccess gAttribute;


} //namespace


//==============================================================================

InteractionModel::Status IcdManagementServer::RegisterClient(
        chip::app::CommandHandler * commandObj, const chip::app::ConcreteCommandPath & commandPath,
        const chip::app::Clusters::IcdManagement::Commands::RegisterClient::DecodableType & commandData)
{
    FabricIndex fabric = commandObj->GetAccessingFabricIndex();
    IcdMonitoringTable table(& chip::Server::GetInstance().GetPersistentStorage(), fabric);

    IcdMonitoringEntry entry;

    entry.fabricIndex = fabric;
    entry.checkInNodeID = commandData.checkInNodeID;
    entry.monitoredSubject = commandData.monitoredSubject;
    entry.key = commandData.key;
    CHIP_ERROR err = table.Set(entry, true);
    ChipLogDetail(Zcl, "RegisterClient: 0x%lx\n", err.AsInteger());
    VerifyOrReturnError(CHIP_NO_ERROR == err, InteractionModel::Status::Failure);

    return InteractionModel::Status::Success;
}


InteractionModel::Status IcdManagementServer::UnregisterClient(
        chip::app::CommandHandler * commandObj, const chip::app::ConcreteCommandPath & commandPath,
        const chip::app::Clusters::IcdManagement::Commands::UnregisterClient::DecodableType & commandData)
{
    FabricIndex fabric = commandObj->GetAccessingFabricIndex();
    IcdMonitoringTable table(& chip::Server::GetInstance().GetPersistentStorage(), fabric);

    IcdMonitoringEntry entry;

    entry.fabricIndex = fabric;
    entry.checkInNodeID = commandData.checkInNodeID;
    CHIP_ERROR err = table.Remove(entry);
    ChipLogDetail(Zcl, "UnregisterClient: 0x%lx\n", err.AsInteger());
    VerifyOrReturnError(CHIP_NO_ERROR == err, InteractionModel::Status::Failure);

    return InteractionModel::Status::Success;
}


InteractionModel::Status IcdManagementServer::StayActive(const chip::app::ConcreteCommandPath & commandPath)
{
    // TODO: Implementent stay awake logic for end device
    return InteractionModel::Status::UnsupportedCommand;
}

//==============================================================================

/**
 * @brief Client Monitoring Cluster RegisterClient Command callback (from client)
 *
 */
bool emberAfIcdManagementClusterRegisterClientCallback(
    chip::app::CommandHandler * commandObj, const chip::app::ConcreteCommandPath & commandPath,
    const chip::app::Clusters::IcdManagement::Commands::RegisterClient::DecodableType & commandData)
{
    IcdManagementServer server;
    InteractionModel::Status status = server.RegisterClient(commandObj, commandPath, commandData);

    commandObj->AddStatus(commandPath, status);
    return true;
}

/**
 * @brief Client Monitoring Cluster UregisterClient Command callback (from client)
 *
 */
bool emberAfIcdManagementClusterUnregisterClientCallback(
    chip::app::CommandHandler * commandObj, const chip::app::ConcreteCommandPath & commandPath,
    const chip::app::Clusters::IcdManagement::Commands::UnregisterClient::DecodableType & commandData)
{
    IcdManagementServer server;
    InteractionModel::Status status = server.UnregisterClient(commandObj, commandPath, commandData);

    commandObj->AddStatus(commandPath, status);
    return true;
}

/**
 * @brief Client Monitoring Cluster StayActiveRequest Command callback (from client)
 */
bool emberAfIcdManagementClusterStayActiveRequestCallback(
    chip::app::CommandHandler * commandObj, const chip::app::ConcreteCommandPath & commandPath,
    const chip::app::Clusters::IcdManagement::Commands::StayActiveRequest::DecodableType & commandData)
{
    IcdManagementServer server;
    InteractionModel::Status status = server.StayActive(commandPath);

    commandObj->AddStatus(commandPath, status);
    return true;
}

void MatterIcdManagementPluginServerInitCallback()
{
    registerAttributeAccessOverride(&gAttribute);
}
