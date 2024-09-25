require_relative 'event'

module Kredki
  class WindowEvent < AbiEvent
  end

  class WindowShowEvent < WindowEvent
  end

  class WindowHideEvent < WindowEvent
  end

  class WindowExposeEvent < WindowEvent
  end

  class WindowMoveEvent < WindowEvent
  end

  class WindowResizeEvent < WindowEvent
    def w
      @abi.data1
    end

    def h
      @abi.data2
    end

    def wh
      [w, h]
    end
  end

  class WindowSizeChangeEvent < WindowEvent
  end

  class WindowMinimizeEvent < WindowEvent
  end

  class WindowMaximizeEvent < WindowEvent
  end

  class WindowRestoreEvent < WindowEvent
  end

  class WindowEnterEvent < WindowEvent
  end

  class WindowLeaveEvent < WindowEvent
  end

  class WindowFocusGainEvent < WindowEvent
  end

  class WindowFocusLoseEvent < WindowEvent
  end

  class WindowCloseEvent < WindowEvent
  end

  class WindowTakeFocusEvent < WindowEvent
  end

  class WindowHitTestEvent < WindowEvent
  end

  class WindowIccprofChangeEvent < WindowEvent
  end

  class WindowDisplayChangeEvent < WindowEvent
  end
end