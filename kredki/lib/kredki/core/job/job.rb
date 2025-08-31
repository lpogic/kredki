module Kredki
  class Job
    extend HasParams

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

    param def param! param
      @param = param
    end

    def ~
      param
    end

    def -@
      StopJob.new self
    end

    def after delay = 0, &block
      job = AfterJob.new @action, block, delay
      @event_manager << job
      job
    end

    def loop period = 0, &block
      job = LoopJob.new @action, block, period
      @event_manager << job
      job
    end

    def side &block
      job = SideJob.new @action, block
      @event_manager << job
      job
    end
  end
end