module Kredki
  class BlockEventResolver
    model :block, :@manager, :always

    def resolve event = nil
      return if !@always && event&.resolved?
      event&.resolver! self
      @block.call event
    end

    def inspect
      "#{self.class}:#{object_id} #{[@block.binding.receiver, @block]}"
    end

    def resolve! event = nil
      resolve event
      self
    end

    def detach!
      @manager&.detach! self
      @manager = nil
      @block = nil
    end

    def attach! manager, always = false
      self.class.new @block, manager, always
    end
  end
end