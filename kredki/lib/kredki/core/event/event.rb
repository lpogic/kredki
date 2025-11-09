module Kredki
  class Event
    extend HasParams
    
    model :target, :@resolved

    def inspect
      "#{self.class}:#{object_id}"
    end
    
    def [](key)
      send key
    end

    def resolved?
      @resolved
    end

    def resolve
      @resolved = true
    end

    def trace
      Util.cover @resolver
    end

    param def resolver! resolver
      if Array === @resolver
        @resolver << resolver
      else
        @resolver = resolver
      end
      true
    end, def resolver
      Array === @resolver ? @resolver.last : @resolver
    end
  end

  class AbiEvent < Event
    
    model :abi, :<

    def timestamp
      @abi.timestamp
    end

    #internal api

    def clear
      @abi = nil
    end
  end
end