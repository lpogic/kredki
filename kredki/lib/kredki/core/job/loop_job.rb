module Kredki
  class LoopJob < Job

    def initialize action, block, period
      super(action)
      @block = block
      @period = period
      @next_ms = 0
      @break = false

      @ms = nil
    end

    def ms
      @ms
    end

    def total_ms
      @total_ms
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

    def break
      @break = true
    end

    def play param = nil
      stop
      @param = param
      @next_ms = Kredki.ms
      @total_ms = 0
      @action.put_job self
    end

    def stop
      @action.remove_job self
      @event_manager.resolve StopEvent.new
    end

    def pause
      @action.remove_job self
    end

    def to_proc
      proc{ call it }
    end

  end
end