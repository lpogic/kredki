module Kredki
  # General event.
  class Event

    # Make new event.
    def initialize target = nil, resolved = false
      @target = target
      @resolved = resolved
    end

    # See #param.
    def ~
      param
    end

    # Get event main parameter. Method overrided in inheriting classes.
    def param
      nil
    end
    
    # Get whether event is resolved.
    def resolved?
      @resolved
    end

    # Resolve event.
    def resolve
      @resolved = true
    end

    # Get current event resolver.
    def resolver
      Array === @resolver ? @resolver.last : @resolver
    end

    # Set whether all visited resolvers are collected. 
    def trace trace = true
      if trace
        @resolver = Util.cover @resolver
      else
        @resolver = resolver
      end
    end

    # :section: LEVEL 2

    attr_accessor :target

    def inspect
      "#{self.class}:#{object_id}"
    end

    def push_resolver resolver
      if Array === @resolver
        @resolver << resolver
      else
        @resolver = resolver
      end
    end
  end
end