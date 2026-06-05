module Kredki
  # Job executed in a loop.
  class PlayLoopAnimationJob < Job

    # Get the period between the last two iterations in milliseconds.
    def ms
      @ms
    end

    # Get the period between the first and the last iteration in milliseconds.
    def total_ms
      @total_ms
    end

    # Get play progress.
    def progress
      @total_ms * @speed / @animation.duration
    end

    # Release job.
    def release result = nil
      super
      @released = true
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
      @host&.delete_job self
      @event_manager.report event || CancelEvent.new
      @host = nil
      @result = nil
    end

    # :section: LEVEL 2

    def initialize block, animation, speed
      super()
      @block = block
      @animation = animation
      @speed = speed
      @next_ms = 0
      @released = false
      @ms = nil
    end

    def inspect
      "#{self.class}:#{object_id} #{@block}"
    end

    def tick ms
      dms = ms - @next_ms
      if dms >= 0
        unless @released
          @ms = dms
          @total_ms += @ms
          if !@block
            frame = progress.modulo 1
          elsif RunEvent === @event
            frame = @block.call self, @event.source || @event, @event.result
          else
            frame = @block.call self, @event
          end
          @animation.set_frame frame if frame
          @next_ms += dms
        end
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