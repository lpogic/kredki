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

    # Break job loop.
    def break
      @break = true
    end

    # Start job.
    def play param = nil
      stop
      @param = param
      @next_ms = Kredki.ms
      @total_ms = 0
      @action.put_job self
    end

    # Stop job and all subjobs.
    def stop
      @action.remove_job self
      @event_manager.resolve StopEvent.new
    end

    # :section: LEVEL 2

    def initialize action, block, period
      super(action)
      @block = block
      @period = period
      @next_ms = 0
      @break = false

      @ms = nil
    end

    def step ms
      dms = ms - @next_ms
      if dms >= 0
        @ms = dms + @period
        @total_ms += @ms
        @block.call self, @param
        if @period > 0
          @next_ms += @period * (1 + dms / @period) 
        else
          @next_ms += dms
        end
        if @break
          @break = false
          @event_manager.resolve PlayEvent.new
          return false
        end
      end
      true
    end
  end
end