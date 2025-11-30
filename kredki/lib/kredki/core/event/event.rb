module Kredki
  class Event
    extend HasFeatures
    
    model :target, :@resolved

    def ~
      param
    end

    def param
      nil
    end
    
    def resolved?
      @resolved
    end

    def resolve
      @resolved = true
    end

    def resolver
      Array === @resolver ? @resolver.last : @resolver
    end

    def trace
      @resolver = Util.cover @resolver
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

  class PasteleEvent < Event
    
    def timestamp
      @abi.timestamp
    end

    # :section: LEVEL 2

    model :abi, :<

    def clear
      @abi = nil
    end
  end
end