# frozen_string_literal: true

require_relative '../credit_card'
require 'minitest/autorun'
require 'minitest/rg'

# Feel free to replace the contents of cards with data from your own yaml file
card_details = [
  { num: '4916603231464963',
    exp: 'Mar-30-2020',
    name: 'Soumya Ray',
    net: 'Visa' },
  { num: '6011580789725897',
    exp: 'Sep-30-2020',
    name: 'Nick Danks',
    net: 'Visa' },
  { num: '5423661657234057',
    exp: 'Feb-30-2020',
    name: 'Lee Chen',
    net: 'Mastercard' }
]

cards = card_details.map do |c|
  CreditCard.new(c[:num], c[:exp], c[:name], c[:net])
end

describe 'Test hashing requirements' do
  describe 'Check hashes are consistently produced' do
    # TODO: Check that each card produces the same hash if hashed repeatedly
    cards.each do |card|
      it "should produce the same hash for #{card}" do
        hash1 = card.hash
        hash2 = card.hash
        _(hash1).must_equal hash2
      end
    end
  end

  describe 'Check for unique hashes' do
    # TODO: Check that each card produces a different hash than other cards
    it 'should produce different hashes for different cards' do
      hashes = cards.map(&:hash)
      _(hashes.uniq.length).must_equal hashes.length
    end
  end
end
