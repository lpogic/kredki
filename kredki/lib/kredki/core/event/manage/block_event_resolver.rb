module Kredki
  # Block based event resolver.
  class BlockEventResolver

    # Stop resolving events.
    def detach!
      @manager&.detach! self
      @manager = nil
      @block = nil
    end

    # :section: LEVEL 2

    def initialize block, manager, always
      @block = block
      @managet = manager
      @always = always
    end

    attr_accessor :block
    attr_accessor :always

    def resolve event = nil
      return if !@always && event&.resolved?
      event&.push_resolver self
      @block.call event
    end

    def inspect
      "#{self.class}:#{object_id} #{[@block.binding.receiver, @block]}"
    end

    def resolve! event = nil
      resolve event
      self
    end

    def attach! manager, always = false
      self.class.new @block, manager, always
    end
  end
end