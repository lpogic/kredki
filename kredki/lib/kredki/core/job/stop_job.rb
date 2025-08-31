module Kredki
  class StopJob < Job
    extend Forwardable

    def initialize job
      @job = job
    end

    def call event
      @job.stop
    end

    def -@
      @job
    end
      
    def_delegators :@job, :param, :~, :after, :loop, :job
  end
end