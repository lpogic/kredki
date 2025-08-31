module Kredki
  class RootJob < Job

    def initialize action, block
      super(action)
      @block = block
      @last_job = nil
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

    def after ...
      @last_job = @last_job&.after(...) || super
      self
    end

    def loop ...
      @last_job = @last_job&.loop(...) || super
      self
    end

    def side ...
      @last_job = @last_job&.side(...) || super
      self
    end
  end
end