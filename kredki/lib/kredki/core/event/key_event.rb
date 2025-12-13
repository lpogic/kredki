module Kredki
  # Base class for keyboard related events.
  class KeyEvent < PasteleEvent
    
    # Get event key.
    def key
      @keyboard.key(@abi.sym)
    end

    # Get main parameter.
    def param
      key&.id
    end

    # Get binding key id.
    def input_id
      @abi.sym
    end

    # Get whether left shift is down.
    def left_shift?
      @abi.mod & 0b0000_0000_0000_0001 != 0
    end

    # Get whether right shift is down.
    def right_shift?
      @abi.mod & 0b0000_0000_0000_0010 != 0
    end

    # Get whether left alt is down.
    def left_alt?
      @abi.mod & 0b0000_0001_0000_0000 != 0
    end

    # Get whether right alt is down.
    def right_alt?
      @abi.mod & 0b0000_0010_0000_0000 != 0
    end

    # Get whether left ctrl is down.
    def left_ctrl?
      @abi.mod & 0b0000_0010_0100_0000 == 0b0000_0000_0100_0000
    end

    # Get whether right ctrl is down.
    def right_ctrl?
      @abi.mod & 0b0000_0000_1000_0000 != 0
    end

    # Get whether ctrl is down.
    def ctrl?
      left_ctrl? || right_ctrl?
    end

    # Get whether alt is down.
    def alt?
      left_alt? || right_alt?
    end

    # Get whether shift is down.
    def shift?
      left_shift? || right_shift?
    end

    # Get whether windows key is down.
    def windows?
      @abi.mod & 0b0000_0100_0000_0000 != 0
    end

    # Get whether num lock is on.
    def num_lock?
      @abi.mod & 0b0001_0000_0000_0000 != 0
    end

    # Get whether caps lock is on.
    def caps_lock?
      @abi.mod & 0b0010_0000_0000_0000 != 0
    end

    # Get whether scroll lock is on.
    def scroll_lock?
      @abi.mod & 0b1000_0000_0000_0000 != 0
    end

    # :section: LEVEL 2

    def initialize keyboard, ...
      super(...)
      @keyboard = keyboard
    end
  end

  # Event reported on key down.
  class KeyDownEvent < KeyEvent
  end

  # Event reported on key up.
  class KeyUpEvent < KeyEvent
  end
end