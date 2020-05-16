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
    before do
      @item_name = 'Aged Brie'
    end

    it 'increases quality' do
      items = [Item.new(@item_name, 10, 10)]
      GildedRose.new(items).update_quality
      expect(items.first.quality).to eq 11
    end

    it 'quality value cannot be higher than 50' do
      items = [Item.new(@item_name, 10, 50)]
      GildedRose.new(items).update_quality
      expect(items.first.quality).to      @item_name = 'Aged Brie'
      items = [Item.new(@item_name, 10, 50)]
      GildedRose.new(items).update_quality
      expect(items.first.sell_in).to eq 9
    end

    it 'sell_in value can be lower than zero' do
      items = [Item.new(@item_name, 0, 50)]
      GildedRose.new(items).update_quality
      expect(items.first.sell_in).to eq -1
    end
  end

  context 'when updates Sulfuras' do
    before do
      item_name = 'Sulfuras, Hand of Ragnaros'
      @items = [Item.new(item_name, 10, 80)]
      @gilded_rose = GildedRose.new(@items)
    end

    it 'quality is always 80' do
      @gilded_rose.update_quality
      expect(@items.first.quality).to eq 80

      @gilded_rose.update_quality
      expect(@items.first.quality).to eq 80
    end
  end

  context 'when updates Backstage Pass' do
    before do
      @item_name = 'Backstage passes to a TAFKAL80ETC concert'
    end

    it 'quality increases' do
      items = [Item.new(@item_name, 20, 11)]
      GildedRose.new(items).update_quality
      expect(items.first.quality).to eq 12
    end

    it 'quality value cannot be higher than 50' do
      items = [Item.new(@item_name, 20, 50)]
      GildedRose.new(items).update_quality
      expect(items.first.quality).to eq 50
    end

    it 'decreases sell_in' do
      items = [Item.new(@item_name, 20, 50)]
      GildedRose.new(items).update_quality
      expect(items.first.sell_in).to eq 19
    end

    it 'sell_in value can be lower than zero' do
      items = [Item.new(@item_name, 0, 50)]
      GildedRose.new(items).update_quality
      expect(items.first.sell_in).to eq -1
    end

    context 'between 6 to 10 days to concert' do
      before do
        @items = [Item.new(@item_name, 10, 0)]
        @gilded_rose = GildedRose.new(@items)
      end

      it 'quality increases by 2' do
        @gilded_rose.update_quality
        expect(@items.first.sell_in).to eq 9
        expect(@items.first.quality).to eq 2

        @gilded_rose.update_quality
        expect(@items.first.sell_in).to eq 8
        expect(@items.first.quality).to eq 4

        @gilded_rose.update_quality
        expect(@items.first.sell_in).to eq 7
        expect(@items.first.quality).to eq 6

        @gilded_rose.update_quality
        expect(@items.first.sell_in).to eq 6
        expect(@items.first.quality).to eq 8
      end
    end

    context '5 days or less to concert' do
      before do
        @items = [Item.new(@item_name, 5, 0)]
        @gilded_rose = GildedRose.new(@items)
      end

      it 'quality increases by 3' do
        @gilded_rose.update_quality
        expect(@items.first.sell_in).to eq 4
        expect(@items.first.quality).to eq 3

        @gilded_rose.update_quality
        expect(@items.first.sell_in).to eq 3
        expect(@items.first.quality).to eq 6

        @gilded_rose.update_quality
        expect(@items.first.sell_in).to eq 2
        expect(@items.first.quality).to eq 9

        @gilded_rose.update_quality
        expect(@items.first.sell_in).to eq 1
        expect(@items.first.quality).to eq 12

        @gilded_rose.update_quality
        expect(@items.first.sell_in).to eq 0
        expect(@items.first.quality).to eq 15
      end
    end

    context 'after the concert' do
      it 'quality drops to 0' do
        items = [Item.new(@item_name, 0, 50)]
        GildedRose.new(items).update_quality
        expect(items.first.sell_in).to be_negative
        expect(items.first.quality).to be_zero
      end
    end
  end

  context 'when updates Conjured' do
    before do
      @item_name = 'Conjured foo'
    end

    it 'quality decreases by 2' do
      items = [Item.new(@item_name, 20, 10)]
      GildedRose.new(items).update_quality
      expect(items.first.quality).to eq 8
    end

    it 'quality decreases by 4 once sell by date has passed' do
      items = [Item.new(@item_name, 0, 10)]
      GildedRose.new(items).update_quality
      expect(items.first.sell_in).to eq -1
      expect(items.first.quality).to eq 6
    end
  end
end
