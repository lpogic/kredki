module Kredki
  class AfterJob < Job

    def initialize action, block, delay
      super(action)
      @block = block
      @delay = delay
      @start_ms = 0
    end

    def step ms
      dms = ms - @start_ms
      if dms >= 0
        if @block
          result = @block.call dms + @start_ms, self
        else
          result = @param
        end
        @event_manager.resolve PlayEvent.new result
        return false
      end
      true
    end

    def play param = nil
      stop
      @param = param
      @start_ms = @action.ms + @delay
      @action.put_job self
    end

    def stop
      @action.remove_job self
      @event_manager.resolve StopEvent.new
    end

    def to_proc
      proc{ call it }
    end

  end
end