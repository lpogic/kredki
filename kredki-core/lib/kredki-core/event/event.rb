module Kredki
  class Event
    
    model :target do
      @resolved = false
      @forward = false
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

    def forward?
      @forward
    end

    def forward f = true
      @forward = f
    end

    def break?
      @break
    end

    def break b = true
      @break = b
    end

    def break_forward
      @break = true
      @forward = true
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