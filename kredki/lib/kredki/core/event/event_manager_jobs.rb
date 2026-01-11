module Kredki
  # Job reaction methods.
  module EventManagerJobs

    # Add new job tree.
    def job &block
      job = RootJob.new block
      attach job
      job
    end

    # Create and attach Kredki::AfterJob.
    def after ...
      job.after(...)
    end

    # Create and attach Kredki::LoopJob.
    def loop ...
      job.loop(...)
    end

    # Create and attach Kredki::SideJob.
    def side ...
      job.side(...)
    end
  end
end