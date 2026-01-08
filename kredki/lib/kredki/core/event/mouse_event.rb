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
  class MouseButtonPushEvent < MouseButtonEvent
  end

  # Event reported on mouse button up.
  class MouseButtonFreeEvent < MouseButtonEvent
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

  # Event reported on mouse pointer move.
  class MousePointerMoveEvent < MouseEvent

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

  class MousePointerEnterEvent < MouseEvent
    def move?
      @source&.is_a? MousePointerMoveEvent
    end
  end

  class MousePointerLeaveEvent < MouseEvent
    def move?
      @source&.is_a? MousePointerMoveEvent
    end
  end

  # Event reported on mouse wheel spin.
  class MouseWheelSpinEvent < MouseEvent

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