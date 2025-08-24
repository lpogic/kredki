module Kredki
  class JobEventResolver
    model :job, :@manager, :always

    def resolve event = nil
      return if !@always && event&.resolved?
      if event&.trace?
        puts @job
      end
      @job.call event
    end

    def resolve! event = nil
      resolve event
      self
    end

    def detach!
      @manager&.detach! self
      @manager = nil
      @job = nil
    end

    def attach! manager, always = false
      self.class.new @job, manager, always
    end
  end
end