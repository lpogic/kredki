module Kredki
  class RootJob < Job

    def initialize action, block
      super(action)
      @block = block
    end

    def play param = nil
      stop
      @param = param
      result = @block&.call self
      @event_manager.resolve PlayEvent.new result
    end

    def stop
      @event_manager.resolve StopEvent.new
    end
  end
end