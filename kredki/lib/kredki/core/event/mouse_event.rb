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
      @mouse.button @source.button
    end

    # Get main parameter.
    def param
      button&.id
    end

    # Get binding button id.
    def input_id
      @source.button
    end

    # Get position along X axis.
    def x
      @source.x
    end

    # Get position along Y axis.
    def y
      @source.y
    end

    # Get position along X and Y axes.
    def xy
      [@source.x, @source.y]
    end
  end

  # Event reported on mouse button down.
  class MouseButtonDownEvent < MouseButtonEvent
  end

  # Event reported on mouse button up.
  class MouseButtonUpEvent < MouseButtonEvent
    # Get whether it is drag move. +:start+ is returned if it is initial drag move.
    def drag
      @drag
    end

    # :section: LEVEL 2

    def initialize ...
      super
      @drag = false
    end

    def drag= drag
      @drag = drag
    end
  end

  # Event reported on mouse move.
  class MouseMoveEvent < MouseEvent

    # Get position along X axis.
    def x
      @source.x
    end

    # Get position along Y axis.
    def y
      @source.y
    end

    # Get position along X and Y axes.
    def xy
      [@source.x, @source.y]
    end

    # Get main parameter.
    def param
      xy
    end

    # Get whether it is drag move. +:start+ is returned if it is initial drag move.
    def drag
      @drag
    end

    # :section: LEVEL 2

    def initialize ...
      super
      @drag = false
    end

    def drag= drag
      @drag = drag
    end
  end

  class MouseEnterEvent < MouseEvent
    def move?
      @source&.is_a? MouseMoveEvent
    end
  end

  class MouseLeaveEvent < MouseEvent
    def move?
      @source&.is_a? MouseMoveEvent
    end
  end

  # Event reported on mouse scroll move.
  class MouseScrollEvent < MouseEvent

    # Get position along X axis.
    def x
      @source.x
    end

    # Get position along Y axis.
    def y
      @source.y
    end

    # Get position along X and Y axes.
    def xy
      [@source.x, @source.y]
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