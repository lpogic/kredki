module Kredki
  # Base class for joystick related events.
  class JoystickEvent < PasteleEvent

    # :section: LEVEL 2

    def initialize joystick, ...
      super(...)
      @joystick = joystick
    end
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
  class JoystickMouseButtonReleaseEvent < JoystickButtonEvent
  end

  # Event reported on joystick axis change.
  class JoystickAxisEvent < JoystickEvent

    # Get event axis.
    def axis
      @joystick.axis @source.axis
    end

    # Get main parameter.
    def param
      axis&.id
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
end