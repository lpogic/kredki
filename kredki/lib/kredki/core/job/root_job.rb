module Kredki
  # Job executed instantly.
  class RootJob < Job

    # Run job.
    def run host, event = nil
      cancel
      @host = host
      @event = event || RunEvent.new(nil, nil, self)
      if RunEvent === @event
        if @block 
          result = @block.call self, @event.source || @event, @event.result
        else
          result = @event.result
        end
        @event_manager.report RunEvent.new result, @event.source || nil, @host
      else
        if @block
          result = @block.call self, @event
        else
          result = nil
        end
        @event_manager.report RunEvent.new result, @event, @host
      end
      @host = nil
      @event = nil
    end

    # Cancel all subjobs.
    def cancel event = nil
      @event_manager.report event || CancelEvent.new
      @host = nil
    end

    # :section: LEVEL 2

    def initialize block
      super()
      @block = block
    end
  end
end