module Kredki
  # Base class for window related events.
  class WindowEvent < PasteleEvent
  end

  # Event reported on window show.
  class WindowShowEvent < WindowEvent
  end

  # Event reported on window hide.
  class WindowHideEvent < WindowEvent
  end

  # Event reported on window expose.
  class WindowExposeEvent < WindowEvent
  end

  # Event reported on window move.
  class WindowMoveEvent < WindowEvent
  end

  # Event reported on window resize.
  class WindowResizeEvent < WindowEvent
    
    def w
      @abi.data1
    end

    def h
      @abi.data2
    end

    def wh
      [@abi.data1, @abi.data2]
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

  # Event reported on mouse enter window.
  class WindowMouseEnterEvent < WindowEvent
  end

  # Event reported on mouse leave window.
  class WindowMouseLeaveEvent < WindowEvent
  end

  # Event reported on window gain focus.
  class WindowFocusGainEvent < WindowEvent
  end

  # Event reported on window lose focus.
  class WindowFocusLoseEvent < WindowEvent
  end

  # Event reported on window is about to close. Closing will continue if the event is not resolved.
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