module Kredki
  class JoystickEvent < AbiEvent
    model :joystick
  end

  class JoystickConnectEvent < JoystickEvent
  end

  class JoystickDisconnectEvent < JoystickEvent
  end

  class JoystickButtonEvent < JoystickEvent
    def symbol
      @joystick.button(@abi.button).to_sym
    end

    def button
      @abi.button
    end

    def input_id
      @abi.button
    end

    def [](key = :symbol)
      send key
    end
  end

  class JoystickButtonDownEvent < JoystickButtonEvent
  end

  class JoystickButtonUpEvent < JoystickButtonEvent
  end

  class JoystickAxisEvent < JoystickEvent
    def symbol
      @joystick.axis(@abi.axis).to_sym
    end

    def axis
      @abi.axis
    end

    def input_id
      @abi.axis
    end

    def value
      @abi.value
    end
  end
end