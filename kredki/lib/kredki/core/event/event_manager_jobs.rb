module Kredki
  # Job reaction methods.
  module EventManagerJobs

    # Create and attach Kredki::AfterJob.
    def after delay = 0, &block
      job = AfterJob.new block, delay
      attach job
      job
    end

    # Create and attach Kredki::LoopJob.
    def loop period = 0, &block
      job = LoopJob.new block, period
      attach job
      job
    end

    # Create and attach Kredki::SideJob.
    def side &block
      job = SideJob.new block
      attach job
      job
    end

    # Create and attach animation job.
    def animate subject, loop = false, &block
      case subject
      when Numeric
        self.loop do |it|
          if it.total_ms < subject
            block.call it.total_ms, subject
          else
            block.call subject, subject
            it.release
          end
        end
      else
        self.loop do |it|
          it.release if animation.step it.total_ms, loop, &block
        end
      end
    end
  end
end