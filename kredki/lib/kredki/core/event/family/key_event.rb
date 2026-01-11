module Kredki
  # Base class for keyboard key related events.
  class KeyEvent < PasteleEvent
    include Keyboard::ModifiersDecoder
    
    # Get event key.
    def key
      @keyboard.key(@source.sym)
    end

    # Get main parameter.
    def param
      key&.id
    end

    # Get binding key id.
    def input_id
      @source.sym
    end

    # :section: LEVEL 2

    def initialize keyboard, ...
      super(...)
      @keyboard = keyboard
    end

    def modifiers
      @source.mod
    end
  end

  # Event reported on key press.
  class KeyboardKeyPressEvent < KeyEvent
  end

  # Event reported on key release.
  class KeyboardKeyReleaseEvent < KeyEvent
  end
end