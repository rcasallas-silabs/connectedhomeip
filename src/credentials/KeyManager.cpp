#include <lib/support/PersistentData.h>

namespace chip {
namespace Credentials {


KeyManager::KeyContext::KeyContext(KeyManager & manager): mManager(manager) {}

KeyManager::KeyContext::KeyContext(KeyManager & manager, 
                        const Crypto::GroupOperationalCredentials &creds):
                        mManager(manager), mKeyHash(hash)
{
    ReleaseKeys();
    // TODO: Load group keys to the session keystore upon loading from persistent storage
    //
    // Group keys should be transformed into a key handle as soon as possible or even
    // the key storage should be taken over by SessionKeystore interface, but this looks
    // like more work, so let's use the transitional code below for now.
    Crypto::SessionKeystore * keystore = mProvider.GetSessionKeystore();
    keystore->CreateKey(encryptionKey, mEncryptionKey);
    keystore->CreateKey(privacyKey, mPrivacyKey);
}

uint16_t KeyManager::KeyContext::GetKeyHash() { return mHash; }

CHIP_ERROR KeyManager::KeyContext::MessageEncrypt(const ByteSpan & plaintext, const ByteSpan & aad, const ByteSpan & nonce, MutableByteSpan & mic,
                        MutableByteSpan & ciphertext) const 
{
    uint8_t * output = ciphertext.data();
    return Crypto::AES_CCM_encrypt(plaintext.data(), plaintext.size(), aad.data(), aad.size(), mEncryptionKey, nonce.data(),
                                   nonce.size(), output, mic.data(), mic.size());
}

CHIP_ERROR KeyManager::KeyContext::MessageDecrypt(const ByteSpan & ciphertext, const ByteSpan & aad, const ByteSpan & nonce, const ByteSpan & mic,
                        MutableByteSpan & plaintext) const 
{
    uint8_t * output = plaintext.data();
    return Crypto::AES_CCM_decrypt(ciphertext.data(), ciphertext.size(), aad.data(), aad.size(), mic.data(), mic.size(),
                                   mEncryptionKey, nonce.data(), nonce.size(), output);
}

CHIP_ERROR KeyManager::KeyContext::PrivacyEncrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const 
{
    return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
}

CHIP_ERROR KeyManager::KeyContext::PrivacyDecrypt(const ByteSpan & input, const ByteSpan & nonce, MutableByteSpan & output) const 
{
    return Crypto::AES_CTR_crypt(input.data(), input.size(), mPrivacyKey, nonce.data(), nonce.size(), output.data());
}

void KeyManager::KeyContext::Release() 
{
    ReleaseKeys();
    mManage.mKeyContexPool.ReleaseObject(this);
}

void KeyManager::KeyContext::ReleaseKeys()
{
    Crypto::SessionKeystore * keystore = mProvider.GetSessionKeystore();
    keystore->DestroyKey(mEncryptionKey);
    keystore->DestroyKey(mPrivacyKey);
}

} // namespace Credentials
} // namespace chip
