module Kredki
  # Collection of event managers used as a single entity.
  class CompositeEventManager
    include EventManagerJobs

    # :section: LEVEL 2

    def initialize managers
      @managers = managers
    end

    def attach attached, always: false
      reaction = case attached
      when BlockEventReaction
        BlockEventReaction.new attached.block, self, always
      when MethodEventReaction
        MethodEventReaction.new attached.method, self, always
      when JobEventReaction
        JobEventReaction.new attached.job, self, always
      when Proc
        BlockEventReaction.new attached, self, always
      else raise_ia attached
      end
      @managers.each{|it| it.reactions << reaction }
      reaction
    end

    def <<(attached)
      attach attached
      self
    end

    def detach reaction
      @managers.each{|it| it.detach reaction }
    end
  end
end