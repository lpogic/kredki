require_relative 'event_reaction'
require_relative 'block_event_reaction'
require_relative 'method_event_reaction'
require_relative 'job_event_reaction'
require_relative 'event_manager_jobs'

module Kredki
  # Manage event reactions.
  class EventManager
    include EventManagerJobs

    # :section: LEVEL 2

    def initialize
      @reactions = []
    end

    attr :reactions

    def report event
      @reactions.reverse_each{ it.call event }
    end

    def attach attached = nil, always: false, last: false, &block
      attached ||= block
      reaction = case attached
      when Proc
        BlockEventReaction.new attached, self, always
      when Method
        MethodEventReaction.new attached, self, always
      when Job
        JobEventReaction.new attached, self, always
      when BlockEventReaction, MethodEventReaction, JobEventReaction
        attached.attach self, always
      else raise_is attached
      end
      if last
        @reactions.prepend reaction
      else
        @reactions.append reaction
      end
      reaction
    end

    def <<(attached)
      attach attached
      self
    end

    def detach reaction
      @reactions.delete reaction
    end
  end
end