module Kredki
  # Job executed instantly.
  class RootJob < Job

    # Start job.
    def play param = nil
      stop
      @param = param
      result = @block ? @block.call(self, param) : param
      @event_manager.resolve PlayEvent.new result
    end

    # Stop all subjobs.
    def stop
      @event_manager.resolve StopEvent.new
    end

    # :section: LEVEL 2

    def initialize scene, block
      super(scene)
      @block = block
    end
  end
end