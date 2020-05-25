# frozen_string_literal: false

module Update
  # Names enum of items with custom processors
  class ConditionalNames
    AGED_BRIE = 'Aged Brie'.freeze
    BACKSTAGE_PASS = 'Backstage passes'.freeze
    SULFURAS = 'Sulfuras, Hand of Ragnaros'.freeze
    CONJURED = 'Conjured'.freeze
  end

  # Represents the update of an item
  class Processor
    attr_reader :item

    NAMES = {
      AGED_BRIE: 'Aged Brie',
      BACKSTAGE_PASS: 'Backstage passes',
      SULFURAS: 'Sulfuras, Hand of Ragnaros',
      CONJURED: 'Conjured'
    }

    def initialize(item)
      @item = item
      @processor = processor
    end

    def processor
      name = @item.name

      return ConjuredProcessor if name.start_with?(NAMES[:CONJURED])
      return BackstageProcessor if name.start_with?(NAMES[:BACKSTAGE_PASS])
      return AgedBrieProcessor if name == NAMES[:AGED_BRIE]
      return SulfurasProcessor if name == NAMES[:SULFURAS]

      return CommonProcessor
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
      item.quality = process_quality(item.sell_in, item.quality)

      item.sell_in -= 1
    end

    def process_quality(sell_in, quality)
      return 0 if sell_in.zero?

      quality += quality_increase_value(sell_in)

      quality = 50 if quality > 50

      return quality
    end

    def quality_increase_value(sell_in)
      return 3 if sell_in.between?(1, 6)
      return 2 if sell_in.between?(7, 10)

      return 1
    end
  end

  # Conjurer item update processor.
  class ConjuredProcessor
    def process(item)
      # Process the item update
      item.quality = process_quality(item.sell_in, item.quality)
      item.sell_in -= 1
    end

    def process_quality(sell_in, quality)
      return quality - 4 if sell_in.zero?

      return quality - 2
    end
  end

  # Common item update processor.
  class CommonProcessor
    def process(item)
      item.quality = process_quality(item.sell_in, item.quality)

      item.sell_in -= 1
    end

    def process_quality(sell_in, quality)
      return 0 if quality.zero?
      return quality - 1 if sell_in.positive?

      return quality - 2
    end
  end
end
