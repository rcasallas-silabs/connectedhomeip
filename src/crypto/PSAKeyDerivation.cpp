#include "PSAKeyDerivation.h"

namespace chip {
namespace Crypto {

CHIP_ERROR PsaKdf::Init(psa_algorithm_t algorithm, const ByteSpan & secret, const ByteSpan & salt, const ByteSpan & info)
{
    psa_status_t status        = PSA_SUCCESS;
    psa_key_attributes_t attrs = PSA_KEY_ATTRIBUTES_INIT;

    psa_set_key_type(&attrs, PSA_KEY_TYPE_DERIVE);
    psa_set_key_algorithm(&attrs, PSA_ALG_HKDF(PSA_ALG_SHA_256));
    psa_set_key_usage_flags(&attrs, PSA_KEY_USAGE_DERIVE);

    status = psa_import_key(&attrs, secret.data(), secret.size(), &mSecretKeyId);
    psa_reset_key_attributes(&attrs);
    VerifyOrReturnError(status == PSA_SUCCESS, CHIP_ERROR_INTERNAL);

    status = psa_key_derivation_setup(&mOperation, algorithm);
    VerifyOrReturnError(status == PSA_SUCCESS, CHIP_ERROR_INTERNAL);

    if (salt.size() > 0)
    {
        status = psa_key_derivation_input_bytes(&mOperation, PSA_KEY_DERIVATION_INPUT_SALT, salt.data(), salt.size());
        VerifyOrReturnError(status == PSA_SUCCESS, CHIP_ERROR_INTERNAL);
    }

    status = psa_key_derivation_input_key(&mOperation, PSA_KEY_DERIVATION_INPUT_SECRET, mSecretKeyId);
    VerifyOrReturnError(status == PSA_SUCCESS, CHIP_ERROR_INTERNAL);

    status = psa_key_derivation_input_bytes(&mOperation, PSA_KEY_DERIVATION_INPUT_INFO, info.data(), info.size());
    VerifyOrReturnError(status == PSA_SUCCESS, CHIP_ERROR_INTERNAL);

    return CHIP_NO_ERROR;
}

CHIP_ERROR PsaKdf::DeriveBytes(const MutableByteSpan & output)
{
    psa_status_t status = psa_key_derivation_output_bytes(&mOperation, output.data(), output.size());
    VerifyOrReturnError(status == PSA_SUCCESS, CHIP_ERROR_INTERNAL);

    return CHIP_NO_ERROR;
}

CHIP_ERROR PsaKdf::DeriveKey(const psa_key_attributes_t & attributes, psa_key_id_t & keyId)
{
    psa_status_t status = psa_key_derivation_output_key(&attributes, &mOperation, &keyId);
    VerifyOrReturnError(status == PSA_SUCCESS, CHIP_ERROR_INTERNAL);

    return CHIP_NO_ERROR;
}

} // namespace Crypto
} // namespace chip
