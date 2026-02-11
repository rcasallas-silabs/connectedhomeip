#include "AuxiliaryACL.h"

namespace chip {
namespace Access {


CHIP_ERROR AuxiliaryChecker::Add(const AuxiliaryACL & acl)
{
    VerifyOrReturnError(mEntryCount < kMaxEntries, CHIP_ERROR_NO_MEMORY);
    VerifyOrReturnError(Has(acl), CHIP_NO_ERROR);
    mEntries[mEntryCount++] = acl;
    return CHIP_NO_ERROR;
}

CHIP_ERROR AuxiliaryChecker::Remove(const AuxiliaryACL & acl)
{
    VerifyOrReturnError(mEntryCount > 0, CHIP_NO_ERROR);
    uint16_t i = 0;
    for (; i < mEntryCount; ++i)
    {
        if (acl == mEntries[i])
        {
            break;
        }
    }
    for (uint16_t j = i; (j + 1) < mEntryCount; ++i)
    {
        mEntries[j] = mEntries[j + 1];
    }
    mEntryCount--;
    return CHIP_NO_ERROR;
}

bool AuxiliaryChecker::Has(const AuxiliaryACL & acl)
{
    for (uint16_t i = 0; i < mEntryCount; ++i) {
        if (acl == mEntries[i])
        {
            return true;
        }
    }
    return false;
}

CHIP_ERROR AuxiliaryChecker::Reset(FabricIndex fabric_index)
{
    VerifyOrReturnError(mEntryCount > 0, CHIP_NO_ERROR);
    AuxiliaryACL temp[kMaxEntries];
    memcpy((void*)temp, (void*)mEntries, mEntryCount * sizeof(AuxiliaryACL));
    uint16_t count = mEntryCount;

    mEntryCount = 0;
    for (uint16_t i = 0; i < count; ++i)
    {
        if (fabric_index != mEntries[i].fabric_index)
        {
            mEntries[mEntryCount++] = temp[i];
        }
    }
    return CHIP_NO_ERROR;
}

CHIP_ERROR AuxiliaryChecker::Check(const SubjectDescriptor & subjectDescriptor, const RequestPath & requestPath,
                        Privilege requestPrivilege)
{
    if ((Access::AuthMode::kGroup == subjectDescriptor.authMode) &&
        (Access::RequestType::kCommandInvokeRequest == requestPath.requestType) &&
        (Access::Privilege::kOperate == requestPrivilege))
    {
        AuxiliaryACL acl {subjectDescriptor.fabricIndex, GroupIdFromNodeId(subjectDescriptor.subject)};
        if(Has(acl))
        {
            return CHIP_NO_ERROR;
        }
    }
    return CHIP_ERROR_ACCESS_DENIED;
}

} // namespace Access
} // namespace chip
