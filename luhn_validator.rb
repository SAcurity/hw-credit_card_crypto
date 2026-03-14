# frozen_string_literal: true

# Defines the LuhnValidator module for checking the credit card's validaity
module LuhnValidator
  # Validates credit card number using Luhn Algorithm
  # arguments: none
  # assumes: a local String called 'number' exists
  # returns: true/false whether last digit is correct
  def validate_checksum
    nums_a = number.to_s.chars.map(&:to_i).reverse # adjust the head for computing

    # TODO: use the integers in nums_a to validate its last check digit

    # step1: double digits starting with the second to last digit (index 1, 3, 5, ...)
    # step2: if the “doubled result” is greater than 9 -> subtract 9
    # step3: sum all the numbers
    checknum = nums_a.each_with_index.sum { |num, idx| idx.odd? ? double_and_subtract(num) : num }

    # step4: use mod 10 to check if the last digit is correct
    checknum.modulo(10).zero?
  end

  def double_and_subtract(num)
    double = num * 2
    double > 9 ? double - 9 : double
  end
  private :double_and_subtract
end
