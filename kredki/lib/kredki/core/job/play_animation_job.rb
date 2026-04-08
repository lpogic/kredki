module Kredki
  # Job executed in a loop.
  class PlayAnimationJob < PlayLoopAnimationJob

    # Get play progress.
    def progress
      progress = @total_ms * @speed / @period
      progress > 1 ? 1.0 : progress
    end

    def tick ms
      dms = ms - @next_ms
      if dms >= 0
        unless @released
          @ms = dms
          @total_ms += @ms
          if !@block
            frame = progress
          elsif RunEvent === @event
            frame = @block.call self, @event.source || @event, @event.result
          else
            frame = @block.call self, @event
          end
          @animation.set_frame frame if frame
          @next_ms += dms
        end
        release if !@released && @animation.duration <= @total_ms
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