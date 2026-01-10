module Kredki
  # Job executed in separated thread.
  class SideJob < Job

    # Start job.
    def play param = nil
      stop
      @param = param
      @thread = Thread.new do
        @result = @block.call self, @param
      end
      @scene.put_job self
    end

    # Stop job and all subjobs.
    def stop
      @thread&.kill
      @thread = nil
      @scene.remove_job self
      @event_manager.resolve StopEvent.new
    end

    # Break thread.
    def break result = nil
      @result = result
      @thread&.kill
    end

    # :section: LEVEL 2

    def initialize scene, block
      super(scene)
      @block = block
      @threat = nil
      @result = nil
    end

    def step ms
      if !@thread&.alive?
        @event_manager.resolve PlayEvent.new @result
        return false
      end
      true
    end
  end
end