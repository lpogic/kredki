module Kredki
  module Pads
    # Event with position
    class PositionEvent < Event

      def initialize x, y, ...
        super(...)
        @x = x
        @y = y
        @drag = false
      end

      # Get X axis offset.
      def x
        @x
      end

      # Get Y axis offset.
      def y
        @y
      end

      # Get X and Y axes offset.
      def xy
        [@x, @y]
      end

      # Get main parameter.
      def param
        xy
      end

      # Get whether it is drag move. +:start+ is returned if it is initial drag move.
      def drag
        @drag
      end

      # :section: LEVEL 2

      def drag= drag
        @drag = drag
      end
    end

    class MouseButtonClickEvent < Event

      # Get event button.
      def button
        @source.button
      end

      # Get main parameter.
      def param
        @source.param
      end

      # Get binding button id.
      def input_id
        @source.input_id
      end

      # Get position along X axis.
      def x
        @source.x
      end

      # Get position along Y axis.
      def y
        @source.y
      end

      # Get position along X and Y axes.
      def xy
        [x, y]
      end

      def timestamp
        @source.timestamp
      end
    end

    class KeyClickEvent < Event
      include Keyboard::ModifiersDecoder
        
      # Get event key.
      def key
        @source&.key
      end

      # Get main parameter.
      def param
        @source&.param
      end

      # Get binding key id.
      def input_id
        @source&.input_id
      end

      # :section: LEVEL 2

      def modifiers
        @source.modifiers
      end
    end

    class FocusOfferEvent < Event
    end

    class ROIEvent < PositionEvent

      # Get width.
      def w
        @w
      end

      # Get height.
      def h
        @h
      end

      # Get width and height.
      def wh
        [@w, @h]
      end

      # :section: LEVEL 2
      
      def initialize w, h, ...
        super(...)
        @w = w
        @h = h
      end
      
    end

    module PadEvents

      def on event_type, early: false, always: false, do: nil, &block
        @event_manager.manager event_type, block || binding.local_variable_get(:do), early, always
      end

      # Create and attach key pressed event reaction.
      def on_key_press *filtered_keys, early: false, always: false, do: nil, &block
        keycodes = Kredki.keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyboardKeyPressEvent, keycodes, block || binding.local_variable_get(:do), early, always
      end

      # See #on_key_press.
      def on_key_press= param
        on_key_press do: param
      end

      # Create and attach key up event reaction.
      def on_key_release *filtered_keys, early: false, always: false, do: nil, &block
        keycodes = Kredki.keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyboardKeyReleaseEvent, keycodes, block || binding.local_variable_get(:do), early, always
      end

      # See #on_key_release.
      def on_key_release= param
        on_key_release do: param
      end

      # Create and attach key event reaction.
      def on_key *filtered_keys, early: false, always: false, do: nil, &block
        keycodes = Kredki.keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyClickEvent, keycodes, block || binding.local_variable_get(:do), early, always
      end

      # See #on_key.
      def on_key= param
        on_key do: param
      end

      def on_text_input ...
        on(TextInputEvent, ...)
      end

      # See #on_text_input.
      def on_text_input= param
        on_text_input do: param
      end
  
      # Create and attach mouse pressed event reaction.
      def on_mouse_press *filtered_buttons, early: false, always: false, do: nil, &block
        indexes = Kredki.mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonPressEvent, indexes, block || binding.local_variable_get(:do), early, always
      end

      # See #on_mouse_press.
      def on_mouse_press= param
        on_mouse_press do: param
      end
  
      # Create and attach mouse up event reaction.
      def on_mouse_release *filtered_buttons, early: false, always: false, do: nil, &block
        indexes = Kredki.mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonReleaseEvent, indexes, block || binding.local_variable_get(:do), early, always
      end

      # See #on_mouse_release.
      def on_mouse_release= param
        on_mouse_release do: param
      end

      # Create and attach mouse click event reaction.
      def on_mouse_click *filtered_buttons, early: false, always: false, do: nil, &block
        indexes = Kredki.mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonClickEvent, indexes, block || binding.local_variable_get(:do), early, always
      end

      # See #on_mouse_click.
      def on_mouse_click= param
        on_mouse_click do: param
      end

      # Create and attach mouse enter event reaction.
      def on_mouse_enter ...
        on(MousePointerEnterEvent, ...)
      end

      # See #on_mouse_enter.
      def on_mouse_enter= param
        on_mouse_enter do: param
      end

      # Create and attach mouse leave event reaction.
      def on_mouse_leave ...
        on(MousePointerLeaveEvent, ...)
      end

      # See #on_mouse_leave.
      def on_mouse_leave= param
        on_mouse_leave do: param
      end

      # Create and attach mouse move event reaction.
      def on_mouse_move ...
        on(MousePointerMoveEvent, ...)
      end

      # See #on_mouse_move.
      def on_mouse_move= param
        on_mouse_move do: param
      end

      # Create and attach mouse scroll event reaction.
      def on_mouse_scroll ...
        on(MouseWheelScrollEvent, ...)
      end

      # See #on_mouse_scroll.
      def on_mouse_scroll= param
        on_mouse_scroll do: param
      end
      
      # Create and attach joystick press event reaction.
      def on_joystick_press *buttons, joystick: nil, early: false, always: false, do: nil, &block
        j = Kredki.joystick joystick
        indexes = j.buttons buttons
        j = nil if joystick.nil?
        @event_manager.joystick_manager JoystickButtonPressEvent, j, indexes, block || binding.local_variable_get(:do), early, always
      end

      # See #on_joystick_press.
      def on_joystick_press= param
        on_joystick_press do: param
      end

      # Create and attach joystick release event reaction.
      def on_joystick_release *buttons, joystick: nil, early: false, always: false, do: nil, &block
        j = Kredki.joystick joystick
        indexes = j.buttons buttons
        j = nil if joystick.nil?
        @event_manager.joystick_manager JoystickButtonReleaseEvent, j, indexes, block || binding.local_variable_get(:do), early, always
      end

      # See #on_joystick_release.
      def on_joystick_release= param
        on_joystick_release do: param
      end

      # Create and attach joystick axis(axes) move event reaction.
      def on_joystick_move *axes, joystick: nil, early: false, always: false, do: nil, &block
        j = Kredki.joystick joystick
        indexes = j.axes axes
        j = nil if joystick.nil?
        @event_manager.joystick_manager JoystickAxisMoveEvent, j, indexes, block || binding.local_variable_get(:do), early, always
      end

      # See #on_joystick_move.
      def on_joystick_move= reaction
        on_joystick_move do: reaction
      end

      # Create and attach file drop event reaction.
      def on_drop ...
        on(DropEvent, ...)
      end

      # See #on_drop.
      def on_drop= reaction
        on_drop do: reaction
      end

      # Create and attach show event reaction.
      def on_show ...
        on(ShowEvent, ...)
      end

      # See #on_show.
      def on_show= param
        on_show do: param
      end

      # Create and attach hide event reaction.
      def on_hide ...
        on(HideEvent, ...)
      end

      # See #on_hide.
      def on_hide= param
        on_hide do: param
      end

      # Create and attach focus enter event reaction.
      def on_focus_enter ...
        on(FocusEnterEvent, ...)
      end

      # See #on_focus_enter.
      def on_focus_enter= param
        on_focus_enter do: param
      end

      # Create and attach focus leave event reaction.
      def on_focus_leave ...
        on(FocusLeaveEvent, ...)
      end

      # See #on_focus_leave.
      def on_focus_leave= param
        on_focus_leave do: param
      end
    end
  end
end