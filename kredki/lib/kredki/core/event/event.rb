module Kredki
  # General event.
  class Event

    # Attach few events to identical reaction.
    def self.each *event_managers, do: nil, &block
      attached = block || binding.local_variable_get(:do)
      event_managers.map{|it| it.attach attached }
    end

    # Make new event.
    def initialize source = nil, target = nil
      @source = source
      @target = target
      @closed = false
      @reaction = nil
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
    
    # Get whether event is closed.
    def closed?
      @closed
    end

    # Close event.
    def close
      @closed = true
    end

    # Get current event reaction.
    def reaction
      Array === @reaction ? @reaction.last : @reaction
    end

    # Set whether all visited reactions are collected. 
    def trace= trace
      if trace
        @reaction = Util.cover @reaction
      else
        @reaction = reaction
      end
    end

    # :section: LEVEL 2

    def inspect
      "#{self.class}:#{object_id}"
    end

    def reaction= reaction
      if Array === @reaction
        @reaction << reaction
      else
        @reaction = reaction
      end
    end

    def reactions
      @reaction
    end
  end
end