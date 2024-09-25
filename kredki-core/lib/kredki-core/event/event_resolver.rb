module Kredki
  class EventResolver
    model :block

    def on_resolve! &block
      @block = block
    end

    def resolve event = nil
      @block.call event, self
    end

    def resolve! event = nil
      resolve event
      self
    end

    def detach!
      @manager&.detach! self
    end

    #internal api

    attr_accessor :manager
  end
end