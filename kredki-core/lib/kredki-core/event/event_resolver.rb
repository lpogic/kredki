module Kredki
  class EventResolver
    model :block, :@manager

    def on_resolve! &block
      @block = block
    end

    def resolve event = nil
      p @block if event&.track?
      @block.call event, self
    end

    def resolve! event = nil
      resolve event
      self
    end

    def detach!
      @manager&.detach! self
    end

    def attach! manager
      detach!
      @manager = manager
    end
  end
end