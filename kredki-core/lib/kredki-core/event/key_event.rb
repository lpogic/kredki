module Kredki
  class KeyEvent < AbiEvent
    
    model :keyboard

    def key
      @keyboard.key(@abi.sym)
    end

    def symbol
      @keyboard.key(@abi.sym).to_sym
    end

    def keycode
      @abi.sym
    end

    def repeat?
      @abi.repeat != 0
    end

    def left_shift?
      @abi.mod & 0b0000_0000_0000_0001 != 0
    end

    def right_shift?
      @abi.mod & 0b0000_0000_0000_0010 != 0
    end

    def left_alt?
      @abi.mod & 0b0000_0001_0000_0000 != 0
    end

    def right_alt?
      @abi.mod & 0b0000_0010_0000_0000 != 0
    end

    def left_ctrl?
      @abi.mod & 0b0000_0010_0100_0000 == 0b0000_0000_0100_0000
    end

    def right_ctrl?
      @abi.mod & 0b0000_0000_1000_0000 != 0
    end

    def ctrl?
      left_ctrl? || right_ctrl?
    end

    def alt?
      left_alt? || right_alt?
    end

    def shift?
      left_shift? || right_shift?
    end

    def windows?
      @abi.mod & 0b0000_0100_0000_0000 != 0
    end

    def num?
      @abi.mod & 0b0001_0000_0000_0000 != 0
    end

    def caps?
      @abi.mod & 0b0010_0000_0000_0000 != 0
    end

    def scroll?
      @abi.mod & 0b1000_0000_0000_0000 != 0
    end

    def [](key = :symbol)
      send key
    end
  end

  class KeyDownEvent < KeyEvent
  end

  class KeyUpEvent < KeyEvent
  end
end