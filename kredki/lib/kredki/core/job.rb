module Kredki
  class Job

    def initialize pad, exclusive
      @begin = nil
      @step = nil
      @end = nil
      @param = nil
      @pad = pad
      @begin_delay = false
      @step_period = 0
      @next_step_ms = 0
      @state = :begin
      @exclusive = exclusive
    end

    attr_accessor :pad, :exclusive

    def begin! delay: false, &block
      @begin = block
      @begin_delay = delay
      self
    end

    def step! period = 0, &block
      @step = block
      @step_period = period
      self
    end

    def end! &block
      @end = block
      self
    end

    def terminate! result = nil
      instance_exec @param, result, &@end if @end
      @pad.action.remove_job self
      @param = nil
      @state = :terminate
    end

    def abort!
      @pad.action.remove_job self
      @param = nil
      @state = :terminate
    end

    def step ms
      dms = ms - @next_step_ms
      if dms >= 0
        if @begin && @state == :begin
          @state = :step
          instance_exec @param, &@begin
        elsif @step && @state != :terminate
          @step.call dms + @step_period, self
          if @step_period > 0
            @next_step_ms += @step_period * (1 + dms / @step_period) 
          else
            @next_step_ms += dms
          end
        end
      end
      @state != :terminate
    end

    def call param = nil
      action = @pad.action
      return if action.check_job_exclusion self
      @state = :begin
      if @begin_delay
        @param = param
        action.put_job self
        @next_step_ms = action.ms + @begin_delay
      else
        if @step || @begin
          @param = param
          @next_step_ms = action.ms
          action.action.put_job self
          step @next_step_ms
        end
      end
    end

    def to_proc
      proc{ call it }
    end

  end
end