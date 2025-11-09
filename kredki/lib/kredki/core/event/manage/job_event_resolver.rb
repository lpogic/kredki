module Kredki
  class JobEventResolver
    model :job, :@manager, :always

    def resolve event = nil
      return if !@always && event&.resolved?
      event&.resolver! self
      @job.call event
    end

    def inspect
      "#{self.class}:#{object_id} #{@job}"
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