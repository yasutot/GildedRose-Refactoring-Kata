require 'pry'

# frozen_string_literal: false

# Represents Gilded Rose inn items
class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      Updater.new(item).process
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

# Names enum of items with custom processors
class ConditionalItemNames
  AGED = 'Aged Brie'.freeze
  BACK = 'Backstage passes to a TAFKAL80ETC concert'.freeze
  SULF = 'Sulfuras, Hand of Ragnaros'.freeze
  CONJ = 'Conjured'.freeze
end

# Represents the update of an item
class Updater
  attr_reader :item

  def initialize(item)
    @item = item
    @processor = processor
  end

  def processor
    name = @item.name

    AgedBrieProcessor.new if name == ConditionalItemNames::AGED
  end

  def process
    @processor.process(@item)
  end
end

# Aged Brie update processor.
class AgedBrieProcessor
  def process(item)
    item.quality += 1 unless item.quality == 50
    item.sell_in -= 1
  end
end
