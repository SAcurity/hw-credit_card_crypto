# frozen_string_literal: true

module SubstitutionCipher
  # Defines Ceasar Cipher for encrypting and decrypting
  module Caesar
    # Encrypts document using key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.encrypt(document, key)
      # TODO: encrypt string using caesar cipher

      # 1. get the ascii for each char
      # 2. add the key to the ascii value
      # 3. convert the new ascii value back to a char
      # 4. join all the converted chars
      document.to_s.chars.map { |char| (char.ord + key).chr }.join
    end

    # Decrypts String document using integer key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.decrypt(document, key)
      # TODO: decrypt string using caesar cipher

      # same as encrypt but subtract the key instead of adding
      document.to_s.chars.map { |char| (char.ord - key).chr }.join
    end
  end

  # Defines Permutation Cipher for encrypting and decrypting
  module Permutation
    # Encrypts document using key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.encrypt(document, key)
      # TODO: encrypt string using a permutation cipher
      # assume you can replace with any characters values from 0-127 (ord)

      # 1. create a lookup table of characters by randomly "shuffling" the numbers 0-127 using the key
      lookup = create_lookup(key)

      # 2. get the ascii for each char
      # 3. replace by the corresponding char in the lookup table
      # 4. join all the converted chars
      document.to_s.chars.map { |char| lookup[char.ord].chr }.join
    end

    # Decrypts String document using integer key
    # Arguments:
    #   document: String
    #   key: Fixnum (integer)
    # Returns: String
    def self.decrypt(document, key)
      # TODO: decrypt string using a permutation cipher

      # same as encrypt but create a reverse lookup table to get the original char
      lookup = create_lookup(key)

      reverse_lookup = lookup.each_with_index.to_h # [[number, index], ...] -> {number => index, ...}
      document.to_s.chars.map { |char| reverse_lookup[char.ord].chr }.join
    end

    # ----- helper methods -----

    def self.create_lookup(key)
      fix_random = Random.new(key)
      (0..127).to_a.shuffle(random: fix_random)
    end
  end
end
