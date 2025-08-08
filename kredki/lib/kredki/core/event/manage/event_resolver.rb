module Kredki
  class EventResolver
    model :block, :@manager, :always

    def on_resolve! &block
      @block = block
    end

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
      self.class.new model_fields.map{ send _1.name }, manager:, always:;
    end
  end
end