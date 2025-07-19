require_relative 'event'

module Kredki
  class MouseMoveEvent < AbiEvent

    model :mouse, :<

    def x
      @abi.x
    end

    def y
      @abi.y
    end

    def xy
      [x, y]
    end
  end
end