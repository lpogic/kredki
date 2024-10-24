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

    def track
      @track = true
    end

    def track= enabled
      @track = enabled
    end

    def track?
      !!@track
    end
  end

  class AbiEvent < Event
    
    model :abi

    def timestamp
      @abi.timestamp
    end

    #internal api

    def clear
      @abi = nil
    end
  end
end