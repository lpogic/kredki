module Kredki
  class Event
    
    model :target, :trace, :@resolved#, :@break

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

    # def break?
    #   @break
    # end

    # def break
    #   @break = true
    # end

    # def unbreak
    #   @break = false
    # end

    def trace?
      !!@trace
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