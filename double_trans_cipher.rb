# frozen_string_literal: true

# Defines Double Transposition Cipher for encrypting and decrypting
module DoubleTranspositionCipher
  # fill up for the empty space in the matrix
  PAD_CHAR = "\0"

  def self.encrypt(document, key)
    # TODO: FILL THIS IN!

    ## Suggested steps for double transposition cipher
    # 1. find number of rows/cols such that matrix is almost square
    cols, rows = calculate_cols_and_rows(document)

    # 2. break plaintext into evenly sized blocks
    blocks = break_into_blocks(document, cols, rows)

    # 3. sort rows in predictibly random way using key as seed
    fix_random = Random.new(key)
    row_order = (0...rows).to_a.shuffle(random: fix_random)
    blocks = row_order.map { |row_idx| blocks[row_idx] }

    # 4. sort columns in a predictably random way across all rows
    col_order = (0...cols).to_a.shuffle(random: fix_random)
    blocks.map! { |row| col_order.map { |col_idx| row[col_idx] } }

    # 5. return joined cyphertext
    blocks.join
  end

  def self.decrypt(ciphertext, key)
    # TODO: FILL THIS IN!

    # 1. find number of rows/cols to make the matrix
    cols, rows = calculate_cols_and_rows(ciphertext)

    # 2. break ciphertext into evenly sized blocks
    blocks = break_into_blocks(ciphertext, cols, rows)

    # 3. rebuild the same row/column order from the key
    fix_random = Random.new(key)
    row_order = (0...rows).to_a.shuffle(random: fix_random)
    col_order = (0...cols).to_a.shuffle(random: fix_random)

    # 4. reverse col and row to the original order
    restored_col = restore_columns(blocks, col_order)
    original_blocks = restore_rows(restored_col, row_order, rows)

    # 5. return joined plaintext``
    original_blocks.join.sub(/#{Regexp.escape(PAD_CHAR)}+\z/, '')
  end

  # ----- helper methods -----

  # calculates the number of columns and rows for the matrix
  def self.calculate_cols_and_rows(text)
    length = text.to_s.length
    cols = Math.sqrt(length).ceil
    rows = (length.to_f / cols).ceil
    [cols, rows]
  end

  # breaks text into blocks of size cols x rows
  def self.break_into_blocks(text, cols, rows)
    chars = text.to_s.chars

    # check how many padding chars we need
    padding_size = (cols * rows) - chars.length

    # add padding chars to the end, then breaks into blocks
    padded_chars = chars + ([PAD_CHAR] * padding_size)
    padded_chars.each_slice(cols).to_a
  end

  # get the inverse order of the shuffled order (e.g. [2, 0, 1] -> [1, 2, 0])
  def self.inverse_order(order)
    inverse_order = Array.new(order.length)
    order.each_with_index { |original_idx, shuffled_idx| inverse_order[original_idx] = shuffled_idx }
    inverse_order
  end

  # reverses back to the original column order
  def self.restore_columns(blocks, col_order)
    inverse_col_order = inverse_order(col_order)
    blocks.map { |row| inverse_col_order.map { |col_idx| row[col_idx] } }
  end

  # reverses back to the original row order
  def self.restore_rows(blocks, row_order, rows)
    restored_blocks = Array.new(rows)
    blocks.each_with_index { |row, encrypted_idx| restored_blocks[row_order[encrypted_idx]] = row }
    restored_blocks
  end
end
