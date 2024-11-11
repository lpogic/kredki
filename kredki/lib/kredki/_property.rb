module Kredki
  class Property
    model do
      @event_manager = EventManager.new
    end

    def on! &block
      block ? @event_manager.attach(block) : @event_manager
    end

    def push value
      @event_manager.call value
    end

    def <<(value)
      push value
    end
  end
end