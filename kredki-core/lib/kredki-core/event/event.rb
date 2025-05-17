module Kredki
  class Event
    
    model :target do
      @resolved = false
      @break = false
      @mode = :default
    end

    attr_accessor :mode
    
    def [](key)
      send key
    end

    def resolved?
      @resolved
    end

    def resolve
      @resolved = true
    end

    def break?
      @break
    end

    def break
      @break = true
    end

    def unbreak
      @break = false
    end

    def trace
      @trace = true
    end

    def trace= enabled
      @trace = enabled
    end

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