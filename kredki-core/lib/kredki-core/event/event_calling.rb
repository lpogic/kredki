module Kredki
  class EventCalling
    model :block

    def on_call! &block
      @block = block
    end

    def call event
      case @block.call(event, self)
      when Event::TRANSPARENT
        0
      else
        1
      end
    end

    def detach!
      @director&.detach self
    end

    #internal api

    attr_accessor :director
  end
end