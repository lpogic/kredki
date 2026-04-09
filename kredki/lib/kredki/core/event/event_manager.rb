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
      @reactions.each{|it| it.call event }
    end

    def attach attached = nil, always: false, at: true, &block
      attached ||= block
      reaction = case attached
      when Proc
        BlockEventReaction.new attached, self, always
      when Method
        MethodEventReaction.new attached, self, always
      when Job
        JobEventReaction.new attached, self, always
      when EventReaction
        attached.attach self, always
      else raise_is attached
      end
      case at
      when true
        @reactions.prepend reaction
      when Integer
        @reactions.insert at, service
      when EventReaction
        @reactions.insert @reactions.index(at), service
      when :last
        @reactions.append reaction
      else raise_ia at
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