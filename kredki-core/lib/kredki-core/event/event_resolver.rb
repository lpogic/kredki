module Kredki
  class EventResolver
    model :block, :manager_av!, :force

    def on_resolve! &block
      @block = block
    end

    def resolve event = nil
      return if !@force && event&.resolved?
      p @block if event&.track?
      @block.call event, self
    end

    def resolve! event = nil
      resolve event
      self
    end

    def detach!
      @manager&.detach! self
      @manager = nil
    end

    def attach! manager, force = false
      self.class.new model_fields.map{ send _1.name }, manager:, force:;
    end
  end
end