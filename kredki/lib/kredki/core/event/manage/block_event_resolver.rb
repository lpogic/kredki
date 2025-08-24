module Kredki
  class BlockEventResolver
    model :block, :@manager, :always

    def resolve event = nil
      return if !@always && event&.resolved?
      if event&.trace?
        puts [@block.binding.receiver, @block]
      end
      @block.call event, self
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