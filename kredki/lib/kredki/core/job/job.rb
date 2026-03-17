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
          self.loop do |it|
            it.release if block.call it.total_ms, subject
          end
        else
          self.loop do |it|
            if it.total_ms < subject
              block.call it.total_ms, subject
            else
              it.release
              block.call subject, subject
            end
          end
        end

      else
        self.loop do |it|
          it.release if subject.step it.total_ms, loop, &block
        end
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