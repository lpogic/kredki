module Kredki
  # Method based event resolver.
  class MethodEventResolver

    # Stop resolving events.
    def detach!
      @manager&.detach! self
      @manager = nil
      @method = nil
    end

    # :section: LEVEL 2

    def initialize method, manager, always
      @method = method
      @manager = manager
      @always = always
    end

    attr_accessor :method
    attr_accessor :always

    def resolve event = nil
      return if !@always && event&.resolved?
      event&.push_resolver self
      @method.call event
    end

    def inspect
      "#{self.class}:#{object_id} #{@method.source_location}"
    end

    def resolve! event = nil
      resolve event
      self
    end

    def attach! manager, always = false
      self.class.new @method, manager, always
    end
  end
end