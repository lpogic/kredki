module Kredki
  # Job executed in a loop.
  class PlayJob < PlayLoopJob

    # Get play progress.
    def progress
      progress = @total_ms * @speed / @duration
      progress > 1 ? 1.0 : progress
    end

    def tick ms
      dms = ms - @next_ms
      if dms >= 0
        unless @released
          @ms = dms
          @total_ms += @ms
          if RunEvent === @event
            @block.call self, @event.source || @event, @event.result
          else
            @block.call self, @event
          end
          @next_ms += dms
        end
        release if !@released && @duration <= @total_ms
        if @released
          @released = false
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