# frozen_string_literal: false

require File.join(File.dirname(__FILE__), 'update')

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      Update::Processor.new(item).process
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
