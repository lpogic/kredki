require_relative 'event'

module Kredki
  class MouseScrollEvent < AbiEvent

    model :mouse, :abi!, :target!

    def x
      @abi.x
    end

    def y
      @abi.y
    end

    def xy
      [@abi.x, @abi.y]
    end

    def xory
      x == 0 ? y : x
    end

    def yorx
      y == 0 ? x : y
    end
  end
end