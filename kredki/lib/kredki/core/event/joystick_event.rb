module Kredki
  class JoystickEvent < PasteleEvent
    model :joystick
  end

  class JoystickConnectEvent < JoystickEvent
  end

  class JoystickDisconnectEvent < JoystickEvent
  end

  class JoystickButtonEvent < JoystickEvent

    def button
      @joystick.button @abi.button
    end

    def param
      button&.id
    end

    def input_id
      @abi.button
    end
  end

  class JoystickButtonDownEvent < JoystickButtonEvent
  end

  class JoystickButtonUpEvent < JoystickButtonEvent
  end

  class JoystickAxisEvent < JoystickEvent

    def axis
      @joystick.axis @abi.axis
    end

    def param
      axis&.id
    end

    def input_id
      @abi.axis
    end

    def value
      @abi.value
    end
  end
end