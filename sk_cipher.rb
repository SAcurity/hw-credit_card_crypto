# frozen_string_literal: true

require 'base64'
require 'digest'
require 'rbnacl'
require 'securerandom'

# Defines Modern Symmetric Key Cipher for encrypting and decrypting
module ModernSymmetricCipher
  def self.generate_new_key
    # TODO: Return a new key as a Base64 string
    Base64.strict_encode64(SecureRandom.random_bytes(32))
  end

  def self.encrypt(document, key)
    # TODO: Return an encrypted string
    #       Use base64 for ciphertext so that it is sendable as text
    plaintext = document.to_s
    nonce = SecureRandom.random_bytes(RbNaCl::SecretBox.nonce_bytes)
    ciphertext = RbNaCl::SecretBox.new(normalize_key(key)).encrypt(nonce, plaintext)

    Base64.strict_encode64(nonce + ciphertext)
  end

  def self.decrypt(encrypted_cc, key)
    # TODO: Decrypt from encrypted message above
    #       Expect Base64 encrypted message and Base64 key
    raw = Base64.strict_decode64(encrypted_cc) # get nonce + ciphertext
    nonce_size = RbNaCl::SecretBox.nonce_bytes
    nonce = raw[0, nonce_size]
    ciphertext = raw[nonce_size..]

    RbNaCl::SecretBox.new(normalize_key(key)).decrypt(nonce, ciphertext)
  end

  # Convert the key to 32 bytes
  def self.normalize_key(key)
    # return key to original if it is already a valid key
    if base64_key?(key)
      decoded_key = Base64.strict_decode64(key)
      return decoded_key if decoded_key.bytesize == RbNaCl::SecretBox.key_bytes
    end

    # compress the key to 32 bytes if it's not a valid key
    Digest::SHA256.digest(key.to_s)
  end

  def self.base64_key?(key)
    return false unless key.is_a?(String)

    Base64.strict_encode64(Base64.strict_decode64(key)) == key
  end
end
