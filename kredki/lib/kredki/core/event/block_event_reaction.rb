module Kredki
  # Block based event reaction.
  class BlockEventReaction < EventReaction

    # Attach copy of reaction to another manager.
    def attach manager, always = false
      self.class.new @block, manager, always
    end

    # Cancel reaction.
    def cancel
      super
      @block = nil
    end

    # :section: LEVEL 2

    def initialize block, ...
      super(...)
      @block = block
    end

    attr_accessor :block

    def call event = nil
      return if !@always && event&.closed?
      event&.reaction = self
      @block.call event
    end

    def inspect
      "#{self.class}:#{object_id} #{[@block.binding.receiver, @block]}"
    end
  end
end