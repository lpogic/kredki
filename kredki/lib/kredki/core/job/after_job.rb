module Kredki
  # Job executed after given delay.
  class AfterJob < Job

    # Start job.
    def play param = nil
      stop
      @param = param
      @start_ms = Kredki.ms + @delay
      @action.put_job self
    end

    # Stop job and all subjobs.
    def stop
      @action.remove_job self
      @event_manager.resolve StopEvent.new
    end

    # :section: LEVEL 2

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
          result = @block.call self, @param
        else
          result = @param
        end
        @event_manager.resolve PlayEvent.new result
        return false
      end
      true
    end
  end
end