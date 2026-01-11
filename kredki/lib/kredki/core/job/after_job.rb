module Kredki
  # Job executed after given delay.
  class AfterJob < Job

    # Run job.
    def run host, event = nil
      cancel
      @host = host
      @event = event || RunEvent.new(nil, nil, self)
      @run_ms = @host.application.ms + @delay
      @host.put_job self
    end

    # Cancel job and all subjobs.
    def cancel event = nil
      @host&.remove_job self
      @event_manager.report event || CancelEvent.new
      @host = nil
    end

    # :section: LEVEL 2

    def initialize block, delay
      super()
      @block = block
      @delay = delay
      @run_ms = 0
    end

    def tick ms
      dms = ms - @run_ms
      if dms >= 0
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
        return false
      end
      true
    end
  end
end