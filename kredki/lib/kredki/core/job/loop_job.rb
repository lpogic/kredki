module Kredki
  # Job executed in a loop.
  class LoopJob < Job

    # Get last iteration duration in milliseconds.
    def ms
      @ms
    end

    # Get total duration in milliseconds.
    def total_ms
      @total_ms
    end

    # Break loop.
    def break result = nil
      @break = true
      @result = result
    end

    # Run job.
    def run host, event = nil
      cancel
      @host = host
      @event = event || RunEvent.new(nil, nil, self)
      @next_ms = @host.application.ms
      @total_ms = 0
      @host.put_job self
    end

    # Cancel job and all subjobs.
    def cancel event = nil
      @host&.remove_job self
      @event_manager.report event || CancelEvent.new
      @host = nil
    end

    # :section: LEVEL 2

    def initialize block, period
      super()
      @block = block
      @period = period
      @next_ms = 0
      @break = false
      @result = nil
      @ms = nil
    end

    def tick ms
      dms = ms - @next_ms
      if dms >= 0
        @ms = dms + @period
        @total_ms += @ms
        if RunEvent === @event
          @block.call self, @event.source || @event, @event.result
        else
          @block.call self, @event
        end
        if @period > 0
          @next_ms += @period * (1 + dms / @period) 
        else
          @next_ms += dms
        end
        if @break
          @break = false
          if RunEvent === @event
            @event_manager.report RunEvent.new @result, @event.source || nil, @host
          else
            @event_manager.report RunEvent.new @result, @event, @host
          end
          @host = nil
          @event = nil
          @result = nil
          return false
        end
      end
      true
    end
  end
end