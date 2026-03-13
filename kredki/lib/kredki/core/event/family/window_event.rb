module Kredki
  # Base class for window related events.
  class WindowEvent < PasteleEvent
  end

  # Event reported on window expose.
  class WindowExposeEvent < WindowEvent
  end

  # Event reported on move.
  class MoveEvent < PasteleEvent

    # Get X position.
    def x
      @x
    end

    # Get Y position.
    def y
      @y
    end

    # Get X and Y position.
    def xy
      [@x, @y]
    end

    # Get main parameter.
    def param
      xy
    end
    
    # :section: LEVEL 2

    def initialize x, y, ...
      super(...)
      @x = x
      @y = y
    end
  end

  # Event reported on resize.
  class ResizeEvent < PasteleEvent

    # Get size in the X axis.
    def size_x
      @size[0]
    end

    # Get size in the Y axis.
    def size_y
      @size[1]
    end

    # Get size.
    def size
      @size
    end

    # Get main parameter.
    def param
      size
    end
    
    # :section: LEVEL 2

    def initialize size_x, size_y, ...
      super(...)
      @size = [size_x, size_y]
    end
  end

  # Event reported on window size change.
  class WindowSizeChangeEvent < WindowEvent
  end

  # Event reported on window minimize.
  class WindowMinimizeEvent < WindowEvent
  end

  # Event reported on window maximize.
  class WindowMaximizeEvent < WindowEvent
  end

  # Event reported on window restore.
  class WindowRestoreEvent < WindowEvent
  end

  # Event reported on window is about to close. Window closing will continue if the event is not closed.
  class WindowCloseEvent < WindowEvent
  end

  # Event reported on window take focus.
  class WindowTakeFocusEvent < WindowEvent
  end

  # Event reported on window hit test.
  class WindowHitTestEvent < WindowEvent
  end

  # Event reported on window icc porfile change.
  class WindowIccprofChangeEvent < WindowEvent
  end

  # Event reported on window display change.
  class WindowDisplayChangeEvent < WindowEvent
  end
end