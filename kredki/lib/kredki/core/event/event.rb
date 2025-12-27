module Kredki
  # General event.
  class Event

    # Attach few events to identical resolvers.
    def self.each *event_managers, do: nil, &block
      attached = block || binding.local_variable_get(:do)
      event_managers.map{ it.attach! attached }
    end

    # Make new event.
    def initialize source = nil, target = nil, resolved = false
      @source = source
      @target = target
      @resolved = resolved
    end

    # Set target.
    def target= target
      @target = target
    end

    # Get target.
    def target
      @target
    end

    # Set source.
    def source= source
      @source = source
    end

    # Get source.
    def source
      @source
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