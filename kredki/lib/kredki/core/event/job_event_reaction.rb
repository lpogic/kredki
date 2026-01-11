module Kredki
  # Job based event reaction.
  class JobEventReaction < EventReaction

    # Attach copy of reaction to another manager.
    def attach manager, always = false
      self.class.new @job, manager, always
    end

    # Cancel reaction.
    def cancel
      super
      @job = nil
    end

    # :section: LEVEL 2

    def initialize job, ...
      super(...)
      @job = job
    end

    attr_accessor :job

    def call event = nil
      return if !@always && event&.closed?
      event&.reaction = self
      @job.call event
    end

    def inspect
      "#{self.class}:#{object_id} #{@job}"
    end
  end
end