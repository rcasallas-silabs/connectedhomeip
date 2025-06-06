/*
 *
 *    Copyright (c) 2022 Project CHIP Authors
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

#include "DeviceInstanceInfoProviderImpl.h"

#include <platform/Linux/PosixConfig.h>
#include <platform/internal/GenericDeviceInstanceInfoProvider.ipp>

namespace chip {
namespace DeviceLayer {

CHIP_ERROR DeviceInstanceInfoProviderImpl::GetVendorId(uint16_t & vendorId)
{
    return Internal::PosixConfig::ReadConfigValue(Internal::PosixConfig::kConfigKey_VendorId, vendorId);
}

CHIP_ERROR DeviceInstanceInfoProviderImpl::GetProductId(uint16_t & productId)
{
    return Internal::PosixConfig::ReadConfigValue(Internal::PosixConfig::kConfigKey_ProductId, productId);
}

} // namespace DeviceLayer
} // namespace chip
