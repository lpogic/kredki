module Kredki
  # Method based event reaction.
  class MethodEventReaction < EventReaction

    # Attach copy of reaction to another manager.
    def attach manager, always = false
      self.class.new @method, manager, always
    end

    # Cancel reaction.
    def cancel
      super
      @method = nil
    end

    # :section: LEVEL 2

    def initialize method, ...
      super(...)
      @method = method
    end

    attr_accessor :method

    def call event = nil
      return if !@always && event&.closed?
      event&.reaction = self
      begin
        @method.call event
      rescue => e
        raise inspect
      end
    end

    def inspect
      "#{self.class}:#{object_id} #{@method.source_location}"
    end


  end
end