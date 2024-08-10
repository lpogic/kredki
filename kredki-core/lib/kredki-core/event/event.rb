module Kredki
  class Event
    TRANSPARENT = Object.new

    model :@abi, :data

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

  module EventWithWindowId
    def window_id
      @abi.window_id
    end
  end
end