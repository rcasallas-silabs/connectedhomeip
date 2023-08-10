
#pragma once

#include <lib/core/DataModelTypes.h>
#include <lib/core/CHIPError.h>
// #include <lib/core/CHIPVendorIdentifiers.hpp>
// #include <lib/core/Optional.h>
// #include <lib/support/CodeUtils.h>
// #include <lib/support/SafePointerCast.h>
#include <lib/support/Span.h>
#include <psa/crypto.h>


namespace chip {
namespace Crypto {

/**
 * @brief Wrapper for PSA key derivation API.
 */
class PsaKdf
{
public:
    ~PsaKdf()
    {
        psa_key_derivation_abort(&mOperation);
        psa_destroy_key(mSecretKeyId);
    }

    /**
     * @brief Initializes the key derivation operation.
     */
    CHIP_ERROR Init(psa_algorithm_t algorithm, const ByteSpan & secret, const ByteSpan & salt, const ByteSpan & info);

    /**
     * @brief Derives raw key material from the operation.
     *
     * This method together with @p DeriveKeys can be called multiple times to
     * derive several keys.
     *
     * @param[out] output Span that provides location and length for the derived key material.
     *
     * @retval CHIP_NO_ERROR       On success.
     * @retval CHIP_ERROR_INTERNAL On PSA crypto API error.
     */
    CHIP_ERROR DeriveBytes(const MutableByteSpan & output);

    /**
     * @brief Derives a key from the operation.
     *
     * This method together with @p DeriveBytes can be called multiple times to
     * derive several keys.
     *
     * @param[in] attributes Attributes of the derived key.
     * @param[out] keyId     PSA key ID of the derived key.
     *
     * @retval CHIP_NO_ERROR       On success.
     * @retval CHIP_ERROR_INTERNAL On PSA crypto API error.
     */
    CHIP_ERROR DeriveKey(const psa_key_attributes_t & attributes, psa_key_id_t & keyId);

private:
    psa_key_id_t mSecretKeyId                 = 0;
    psa_key_derivation_operation_t mOperation = PSA_KEY_DERIVATION_OPERATION_INIT;
};

} // namespace Crypto
} // namespace chip
