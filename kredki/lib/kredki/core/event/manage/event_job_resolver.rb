module Kredki
  class EventJobResolver
    model :job, :@manager, :always

    def resolve event = nil
      return if !@always && event&.resolved?
      if event&.trace?
        p @job
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
      self.class.new model_fields.map{ send _1.name }, manager:, always:;
    end
  end
end