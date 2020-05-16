# frozen_string_literal: false

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe '#update_quality' do
  it 'does not change the name' do
    items = [Item.new('foo', 0, 0)]
    GildedRose.new(items).update_quality
    expect(items.first.name).to eq 'foo'
  end

  context 'when updates a common item' do
    it 'decreases quality' do
      items = [Item.new('foo', 10, 10)]
      GildedRose.new(items).update_quality
      expect(items.first.quality).to eq 9
    end

    it 'decreases quality twice once sell by date has passed' do
      items = [Item.new('foo', 0, 10)]
      GildedRose.new(items).update_quality
      expect(items.first.quality).to eq 8
    end

    it 'quality value cannot be lower than zero' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items.first.quality).to eq 0
    end

    it 'decreases sell_in' do
      items = [Item.new('foo', 10, 0)]
      GildedRose.new(items).update_quality
      expect(items.first.sell_in).to eq 9
    end

    it 'sell_in value can be lower than zero' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality
      expect(items.first.sell_in).to eq -1
    end
  end

  context 'when updates Aged Brie' do
    it 'increases quality'
    it 'quality value cannot be higher than 50'
    it 'decreases sell_in'
    it 'sell_in value can be lower than zero'
  end

  context 'when updates Sulfuras' do
    it 'quality is always 80'
  end

  context 'when updates Backstage Pass' do
    it 'quality increases'
    it 'quality value cannot be higher than 50'
    it 'decreases sell_in'
    it 'sell_in value can be lower than zero'

    context 'between 6 to 10 days to concert' do
      it 'quality increases by 2'
    end

    context '5 days or less to concert' do
      it 'quality increases by 3'
    end

    context 'after the concert' do
      it 'quality drops to 0'
    end
  end

  context 'when updates Conjured' do
    it 'quality decreases by 2'
    it 'quality decreases by 4 once sell by date has passed'
  end
end
