module Kredki
  # Base class for jobs.
  class Job
    
    # Create and attach Kredki::AfterJob.
    def after delay = 0, &block
      job = AfterJob.new block, delay
      @event_manager << job
      job
    end

    # Create and attach Kredki::LoopJob.
    def loop period = 0, &block
      job = LoopJob.new block, period
      @event_manager << job
      job
    end

    # Create and attach Kredki::SideJob.
    def side &block
      job = SideJob.new block
      @event_manager << job
      job
    end

    # Get event.
    def event
      @event
    end

    # Get host.
    def host
      @host
    end

    # :section: LEVEL 2

    class RunEvent < Event
      def initialize result, ...
        super(...)
        @result = result
      end

      def result
        @result
      end
    end

    class CancelEvent < Event
    end

    def initialize
      @event_manager = EventManager.new
      @host = nil
      @event = nil
    end

    def call event
      case event
      when CancelEvent
        cancel event
      when RunEvent
        run event.target, event
      else
        run event.target.window, event
      end
    end
  end
end