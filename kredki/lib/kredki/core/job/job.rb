module Kredki
  # Base class for jobs.
  class Job
    
    # Create and attach job after.
    def after delay = 0, &block
      case delay
      when Numeric
        job = AfterJob.new block, delay
        @event_manager << job
        job
      when Job
        @event_manager << delay
        delay
      when Proc
        job = AfterJob.new delay, 0
        @event_manager << job
        job
      else raise_ia delay
      end
    end

    # Create and attach Kredki::LoopJob.
    def loop period = 0, &block
      after LoopJob.new block, period
    end

    # Create and attach Kredki::SideJob.
    def side &block
      after SideJob.new block
    end

    # Create and attach play job.
    def play subject, speed: 1, &block
      case subject
      when Numeric
        after PlayJob.new block, subject, speed
      else
        after PlayAnimationJob.new block, subject, speed
      end
    end

    # Create and attach play in loop job.
    def play_loop subject, speed: 1, &block
      case subject
      when Numeric
        after PlayLoopJob.new block, subject, speed
      else
        after PlayLoopAnimationJob.new block, subject, speed
      end
    end

    # Push job after.
    def << job
      after job
    end


    # Get event.
    def event
      @event
    end

    # Get host.
    def host
      @host
    end

    # Release result.
    def release result = nil
      @result = result
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
      @result = nil
    end

    def call event
      case event
      when RunEvent
        run event.target, event
      when CancelEvent
        cancel event
      else
        run event.target.pane, event
      end
    end
  end
end