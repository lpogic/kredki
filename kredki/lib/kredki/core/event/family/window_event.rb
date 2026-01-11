module Kredki
  # Base class for window related events.
  class WindowEvent < PasteleEvent
  end

  # Event reported on window expose.
  class WindowExposeEvent < WindowEvent
  end

  # Event reported on move.
  class MoveEvent < PasteleEvent
  end

  # Event reported on resize.
  class ResizeEvent < PasteleEvent
    
    def w
      @source.data1
    end

    def h
      @source.data2
    end

    def wh
      [@source.data1, @source.data2]
    end

    def param
      wh
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