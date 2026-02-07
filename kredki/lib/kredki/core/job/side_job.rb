module Kredki
  # Job executed in separated thread.
  class SideJob < Job

    # Run job.
    def run host, event = nil
      cancel
      @host = host
      @event = event || RunEvent.new(nil, nil, self)
      @thread = Thread.new do
        if RunEvent === @event
          @block.call self, @event.source || @event, @event.result
        else
          @block.call self, @event
        end
      end
      @host.put_job self
    end

    # Report some partial result.
    def report &block
      @host.job &block
      nil # creating job tree in SideJob is not thread safe - nil returned to prevent such pattern
    end

    # Cancel job and all subjobs.
    def cancel event = nil
      @thread&.kill
      @thread = nil
      @host&.remove_job self
      @event_manager.report event || CancelEvent.new
      @host = nil
    end

    # :section: LEVEL 2

    def initialize block
      super()
      @block = block
      @threat = nil
    end

    def inspect
      "#{self.class}:#{object_id} #{@block}"
    end

    def tick ms
      if !@thread&.alive?
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
      true
    end
  end
end