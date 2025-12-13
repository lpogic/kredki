module Kredki
  # Base class for mouse related events.
  class MouseEvent < PasteleEvent

    # :section: LEVEL 2
    
    def initialize mouse, ...
      super(...)

      @mouse = mouse
    end
  end

  # Base class for mouse button related events.
  class MouseButtonEvent < MouseEvent
    
    # Get event button.
    def button
      @mouse.button @abi.button
    end

    # Get main parameter.
    def param
      button&.id
    end

    # Get binding button id.
    def input_id
      @abi.button
    end

    # Get position along X axis.
    def x
      @abi.x
    end

    # Get position along Y axis.
    def y
      @abi.y
    end
  end

  # Event reported on mouse button down.
  class MouseButtonDownEvent < MouseButtonEvent
  end

  # Event reported on mouse button up.
  class MouseButtonUpEvent < MouseButtonEvent
  end

  # Event reported on mouse move.
  class MouseMoveEvent < MouseEvent

    # Get position along X axis.
    def x
      @abi.x
    end

    # Get position along Y axis.
    def y
      @abi.y
    end

    # Get position along X and Y axes.
    def xy
      [@abi.x, @abi.y]
    end

    # Get main parameter.
    def param
      xy
    end
  end

  # Event reported on mouse scroll move.
  class MouseScrollEvent < MouseEvent

    # Get position along X axis.
    def x
      @abi.x
    end

    # Get position along Y axis.
    def y
      @abi.y
    end

    # Get position along X and Y axes.
    def xy
      [@abi.x, @abi.y]
    end

    # Get move along X axis or Y if X is 0.
    def xory
      x == 0 ? y : x
    end

    # Get move along Y axis or X if Y is 0.
    def yorx
      y == 0 ? x : y
    end

    # Get main parameter
    def param
      xy
    end
  end
end