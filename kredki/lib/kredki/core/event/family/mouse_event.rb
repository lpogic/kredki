module Kredki
  # Base class for mouse related events.
  class MouseEvent < PasteleEvent

    # :section: LEVEL 2
    
    def initialize device, ...
      super(...)

      @device = device
    end
  end

  # Base class for mouse button related events.
  class MouseButtonEvent < MouseEvent
    
    # Get event button.
    def button
      @device.button @source.button
    end

    # Get input id.
    def input_id
      @source.button
    end

    # Get main parameter.
    def param
      button&.id
    end

    # Get pointer position along X axis.
    def x
      @source.x
    end

    # Get pointer position along Y axis.
    def y
      @source.y
    end

    # Get pointer position along X and Y axes.
    def xy
      [@source.x, @source.y]
    end
  end

  # Event reported on mouse button press.
  class MouseButtonPressEvent < MouseButtonEvent
  end

  # Event reported on mouse button release.
  class MouseButtonReleaseEvent < MouseButtonEvent
    # Get whether it is drag move.
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

  # Event reported on mouse pointer move.
  class MousePointerMoveEvent < MouseEvent

    # Get pointer position along X axis.
    def x
      @source.x
    end

    # Get pointer position along Y axis.
    def y
      @source.y
    end

    # Get pointer position along X and Y axes.
    def xy
      [@source.x, @source.y]
    end

    # Get main parameter.
    def param
      xy
    end

    # Get whether it is drag move. +:start+ is returned if it is initial drag move event.
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

  # Event reported on mouse pointer enter.
  class MousePointerEnterEvent < MouseEvent

    # Get whether it is move sourced event.
    def move?
      @source&.is_a? MousePointerMoveEvent
    end
  end

  # Event reported on mouse pointer enter.
  class MousePointerLeaveEvent < MouseEvent

    # Get whether it is move sourced event.
    def move?
      @source&.is_a? MousePointerMoveEvent
    end
  end

  # Event reported on mouse wheel spin.
  class MouseWheelSpinEvent < MouseEvent

    # Get spin value along X axis.
    def x
      @source.x
    end

    # Get spin value along Y axis.
    def y
      @source.y
    end

    # Get spin value along X and Y axes.
    def xy
      [@source.x, @source.y]
    end

    # Get spin value along X axis or Y if X is 0.
    def xory
      x == 0 ? y : x
    end

    # Get spin value along Y axis or X if Y is 0.
    def yorx
      y == 0 ? x : y
    end

    # Get main parameter
    def param
      xy
    end
  end
end