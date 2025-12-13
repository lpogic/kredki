module Kredki
  # Base class for jobs.
  class Job
    
    # Create and attach Kredki::AfterJob.
    def after delay = 0, &block
      job = AfterJob.new @action, block, delay
      @event_manager << job
      job
    end

    # Create and attach Kredki::LoopJob.
    def loop period = 0, &block
      job = LoopJob.new @action, block, period
      @event_manager << job
      job
    end

    # Create and attach Kredki::SideJob.
    def side &block
      job = SideJob.new @action, block
      @event_manager << job
      job
    end

    # Get main parameter.
    def param
      @param
    end

    # See #param.
    def ~
      param
    end

    # :section: LEVEL 2

    class PlayEvent < Event
    end

    class StopEvent < Event
    end

    def initialize action
      @action = action
      @event_manager = EventManager.new
      @param = nil
    end

    def call event
      case event
      when StopEvent
        stop
      when PlayEvent
        play event.target
      else
        play event
      end
    end
  end
end