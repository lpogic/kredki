module Kredki
  # Job reaction methods.
  module EventManagerJobs

    # Create and attach job after.
    def after delay = 0, &block
      case delay
      when Numeric
        job = AfterJob.new block, delay
        attach job
        job
      when Job
        attach delay
        delay
      when Proc
        job = AfterJob.new delay, 0
        attach job
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
  end
end