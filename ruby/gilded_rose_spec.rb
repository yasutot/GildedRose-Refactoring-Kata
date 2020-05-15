# frozen_string_literal: false

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe '#update_quality' do
  before do
    @common_items = [Item.new('foo', 0, 0)]
  end

  it 'does not change the name' do
    GildedRose.new(@common_items).update_quality
    expect(@common_items.first.name).to eq 'foo'
  end
end
