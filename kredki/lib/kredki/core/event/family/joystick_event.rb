module Kredki
  # Base class for joystick related events.
  class JoystickEvent < PasteleEvent

    # :section: LEVEL 2

    def initialize joystick, ...
      super(...)
      @joystick = joystick
    end

    attr :joystick
  end

  # Event reported on joystick connect.
  class JoystickConnectEvent < JoystickEvent
  end

  # Event reported on joystick disconnect.
  class JoystickDisconnectEvent < JoystickEvent
  end

  # Base class for joystick button related events.
  class JoystickButtonEvent < JoystickEvent

    # Get event button.
    def button
      @joystick.button @source.button
    end

    # Get main parameter.
    def param
      button&.id
    end

    # Get binding input id.
    def input_id
      @source.button
    end
  end

  # Event reported on joystick button press.
  class JoystickButtonPressEvent < JoystickButtonEvent
  end

  # Event reported on joystick button release.
  class JoystickButtonReleaseEvent < JoystickButtonEvent
  end

  # Event reported on joystick axis move.
  class JoystickAxisMoveEvent < JoystickEvent

    # Get event axis.
    def axis
      @joystick.axis @source.axis
    end

    # Get main parameter.
    def param
      value
    end

    # Get binding input id.
    def input_id
      @source.axis
    end

    # Get axis value.
    def value
      @source.value
    end
  end

  # Event reported on joystick hat switch.
  class JoystickHatSwitchEvent < JoystickEvent

    # Get event hat.
    def hat
      @joystick.hat @source.hat
    end

    # Get main parameter.
    def param
      value
    end

    # Get binding input id.
    def input_id
      @source.hat
    end

    # Get binding hat value.
    def input_value
      @source.value
    end

    # Get hat value.
    def value
      hat&.state input_value
    end
  end
end