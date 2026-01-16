module Kredki
  # Base class for jobs.
  class Job
    
    # Create and attach Kredki::AfterJob.
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

    # Create and attach animation job.
    def animate subject, loop = false, &block
      case subject
      when Numeric
        if loop
          self.loop do
            it.break if block.call it.total_ms, subject
          end
        else
          self.loop do
            if it.total_ms > subject
              block.call subject, subject
              it.break
            else
              block.call it.total_ms, subject
            end
          end
        end

      else
        self.loop do
          it.break if animation.step it.total_ms, loop, &block
        end
      end
    end

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
      when RunEvent
        run event.target, event
      when CancelEvent
        cancel event
      else
        run event.target.window, event
      end
    end
  end
end