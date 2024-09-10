module Kredki
  class Property
    model do
      @callings = EventCallings.new
    end

    def on! &block
      block ? @callings.attach(block) : @callings
    end

    def push value
      @callings.call value
    end

    def <<(value)
      push value
    end
  end
end