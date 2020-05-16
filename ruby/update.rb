# frozen_string_literal: false

module Update
  # Names enum of items with custom processors
  class ConditionalNames
    AGED = 'Aged Brie'.freeze
    BACK = 'Backstage passes'.freeze
    SULF = 'Sulfuras, Hand of Ragnaros'.freeze
    CONJ = 'Conjured'.freeze
  end

  # Represents the update of an item
  class Processor
    attr_reader :item

    def initialize(item)
      @item = item
      @processor = processor
    end

    def processor
      name = @item.name

      return AgedBrieProcessor if name == ConditionalNames::AGED
      return SulfurasProcessor if name == ConditionalNames::SULF
      return BackstageProcessor if name.start_with?(ConditionalNames::BACK)
      return ConjuredProcessor if name.start_with?(ConditionalNames::CONJ)

      CommonProcessor
    end

    def process
      @processor.new.process(@item)
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

  # Backstage Pass update processor.
  class BackstageProcessor
    def process(item)
      item.quality = quality_value(item.sell_in, item.quality)

      item.sell_in -= 1
    end

    def quality_value(sell_in, quality)
      return 0 if sell_in.zero?

      quality += quality_increase_value(sell_in)

      50 if quality > 50
    end

    def quality_increase_value(sell_in)
      return 3 if sell_in.between?(1, 6)
      return 2 if sell_in.between?(7, 10)

      1
    end
  end

  # Strategy to process a Conjurer item update.
  class ConjuredProcessor
    def process(item)
      # Process the item update
      item.quality = quality_value(item.sell_in, item.quality)
      item.sell_in -= 1
    end

    def quality_value(sell_in, quality)
      return quality - 4 if sell_in.zero?

      quality - 2
    end
  end

  # Common item update processor.
  class CommonProcessor
    def process(item)
      item.quality = quality_value(item.sell_in, item.quality)

      item.sell_in -= 1
    end

    def quality_value(sell_in, quality)
      return 0 if quality.zero?
      return quality - 1 if sell_in.positive?

      quality - 2
    end
  end
end
