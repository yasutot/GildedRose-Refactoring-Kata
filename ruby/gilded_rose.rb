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

    return AgedBrieProcessor.new if name == ConditionalItemNames::AGED
    return SulfurasProcessor.new if name == ConditionalItemNames::SULF

    CommonProcessor.new
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

# Sulfuras update processor.
class SulfurasProcessor
  def process(item)
    item.quality = 80
  end
end

# Common item update processor.
class CommonProcessor
  def process(item)
    item.quality = quality_value(item.sell_in, item.quality)

    item.sell_in = -1
  end

  def quality_value(sell_in, quality)
    return 0 if quality.zero?
    return quality - 1 if sell_in.positive?

    quality - 2
  end
end
