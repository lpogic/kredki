module Kredki

  class MouseEvent < AbiEvent
    model :mouse, :<
  end

  class MouseButtonEvent < MouseEvent
    
    def button
      @mouse.button(@abi.button).to_sym
    end

    def symbol
      button
    end

    def button_number
      @abi.button
    end

    def repeat?
      @abi.clicks > 0
    end

    def clicks
      @abi.clicks
    end

    def x
      @abi.x
    end

    def y
      @abi.y
    end

    def ~()
      button
    end
  end

  class MouseButtonDownEvent < MouseButtonEvent
  end

  class MouseButtonUpEvent < MouseButtonEvent
  end

  class MouseMoveEvent < MouseEvent

    def x
      @abi.x
    end

    def y
      @abi.y
    end

    def xy
      [@abi.x, @abi.y]
    end

    def ~()
      xy
    end
  end

  class MouseScrollEvent < MouseEvent

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

    def ~()
      xy
    end
  end
end