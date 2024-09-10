module Kredki
  class Event
    TRANSPARENT = Object.new

    model :abi

    def timestamp
      @abi.timestamp
    end

    def [](key)
      send key
    end

    #internal api

    def clear
      @abi = nil
    end
  end
end