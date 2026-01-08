require_relative '../../core/event/key_event'
require_relative '../../core/event/text_event'
require_relative '../../core/event/mouse_event'
require_relative '../../core/event/joystick_event'
require_relative '../../core/event/drop_event'
require_relative '../../core/event/window_event'

module Kredki
  module UI

    # Event with position
    class PositionEvent < Event

      def initialize x, y, source = nil, target = nil, resolved = false
        super(source, target, resolved)
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

      # Get whether left shift is down.
      def left_shift?
        @source&.left_shift?
      end

      # Get whether right shift is down.
      def right_shift?
        @source&.right_shift?
      end

      # Get whether left alt is down.
      def left_alt?
        @source&.left_alt?
      end

      # Get whether right alt is down.
      def right_alt?
        @source&.right_alt?
      end

      # Get whether left ctrl is down.
      def left_ctrl?
        @source&.left_ctrl?
      end

      # Get whether right ctrl is down.
      def right_ctrl?
        @source&.right_ctrl?
      end

      # Get whether ctrl is down.
      def ctrl?
        @source&.ctrl?
      end

      # Get whether alt is down.
      def alt?
        @source&.alt?
      end

      # Get whether shift is down.
      def shift?
        @source&.shift?
      end

      # Get whether windows key is down.
      def windows?
        @source&.windows?
      end

      # Get whether num lock is on.
      def num_lock?
        @source&.num_lock?
      end

      # Get whether caps lock is on.
      def caps_lock?
        @source&.caps_lock?
      end

      # Get whether scroll lock is on.
      def scroll_lock?
        @source&.scroll_lock?
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
      
      def initialize w, h, x, y, target = nil, resolved = false
        super(target, resolved)
        @w = w
        @h = h
      end
      
    end

    module PadEvents

      def on! event_type, aim: false, always: false, do: nil, &block
        @event_manager.manager event_type, block || binding.local_variable_get(:do), aim, always
      end

      # Create and attach key down event resolver.
      def on_key_press! *filtered_keys, aim: false, always: false, do: nil, &block
        keycodes = Kredki.keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyboardKeyPushEvent, keycodes, block || binding.local_variable_get(:do), aim, always
      end

      # See #on_key_press!.
      def on_key_press= param
        on_key_press! do: param
      end

      # Create and attach key up event resolver.
      def on_key_free! *filtered_keys, aim: false, always: false, do: nil, &block
        keycodes = Kredki.keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyboardKeyFreeEvent, keycodes, block || binding.local_variable_get(:do), aim, always
      end

      # See #on_key_free!.
      def on_key_free= param
        on_key_free! do: param
      end

      # Create and attach key event resolver.
      def on_key! *filtered_keys, aim: false, always: false, do: nil, &block
        keycodes = Kredki.keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyClickEvent, keycodes, block || binding.local_variable_get(:do), aim, always
      end

      # See #on_key!.
      def on_key= param
        on_key! do: param
      end

      def on_text_input! ...
        on!(TextInputEvent, ...)
      end

      # See #on_text_input!.
      def on_text_input= param
        on_text_input! do: param
      end
  
      # Create and attach mouse down event resolver.
      def on_mouse_push! *filtered_buttons, aim: false, always: false, do: nil, &block
        indexes = Kredki.mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonPushEvent, indexes, block || binding.local_variable_get(:do), aim, always
      end

      # See #on_mouse_push!.
      def on_mouse_push= param
        on_mouse_push! do: param
      end
  
      # Create and attach mouse up event resolver.
      def on_mouse_free! *filtered_buttons, aim: false, always: false, do: nil, &block
        indexes = Kredki.mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonFreeEvent, indexes, block || binding.local_variable_get(:do), aim, always
      end

      # See #on_mouse_free!.
      def on_mouse_free= param
        on_mouse_free! do: param
      end

      # Create and attach mouse click event resolver.
      def on_mouse_click! *filtered_buttons, aim: false, always: false, do: nil, &block
        indexes = Kredki.mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonClickEvent, indexes, block || binding.local_variable_get(:do), aim, always
      end

      # See #on_mouse_click!.
      def on_mouse_click= param
        on_mouse_click! do: param
      end

      # Create and attach mouse enter event resolver.
      def on_mouse_enter! ...
        on!(MousePointerEnterEvent, ...)
      end

      # See #on_mouse_enter!.
      def on_mouse_enter= param
        on_mouse_enter! do: param
      end

      # Create and attach mouse leave event resolver.
      def on_mouse_leave! ...
        on!(MousePointerLeaveEvent, ...)
      end

      # See #on_mouse_leave!.
      def on_mouse_leave= param
        on_mouse_leave! do: param
      end

      # Create and attach mouse move event resolver.
      def on_mouse_move! ...
        on!(MousePointerMoveEvent, ...)
      end

      # See #on_mouse_move!.
      def on_mouse_move= param
        on_mouse_move! do: param
      end

      # Create and attach mouse scroll event resolver.
      def on_mouse_spin! ...
        on!(MouseWheelSpinEvent, ...)
      end

      # See #on_mouse_spin!.
      def on_mouse_spin= param
        on_mouse_spin! do: param
      end
      
      # Create and attach joystick down event resolver.
      def on_joystick_push! joystick_id, *filtered_buttons, aim: false, always: false, do: nil, &block
        joystick = Kredki.joystick joystick_id
        indexes = joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickButtonDownEvent, joystick, indexes, block || binding.local_variable_get(:do), aim, always
      end

      # See #on_joystick_push!.
      def on_joystick_push= param
        on_joystick_push! do: param
      end

      # Create and attach joystick up event resolver.
      def on_joystick_free! joystick_id, *filtered_buttons, aim: false, always: false, do: nil, &block
        joystick = Kredki.joystick joystick_id
        indexes = joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickMouseButtonFreeEvent, joystick, indexes, block || binding.local_variable_get(:do), aim, always
      end

      # See #on_joystick_free!.
      def on_joystick_free= param
        on_joystick_free! do: param
      end

      # Create and attach joystick axis event resolver.
      def on_joystick_axis! joystick_id, *filtered_axes, aim: false, always: false, do: nil, &block
        joystick = Kredki.joystick joystick_id
        indexes = joystick.axes filtered_axes
        @event_manager.joystick_manager JoystickAxisEvent, joystick, indexes, block || binding.local_variable_get(:do), aim, always
      end

      # See #on_joystick_axis!.
      def on_joystick_axis= param
        on_joystick_axis! do: param
      end

      # Create and attach show event resolver.
      def on_show! ...
        on!(ShowEvent, ...)
      end

      # See #on_show!.
      def on_show= param
        on_show! do: param
      end

      # Create and attach hide event resolver.
      def on_hide! ...
        on!(HideEvent, ...)
      end

      # See #on_hide!.
      def on_hide= param
        on_hide! do: param
      end

      # Create and attach focus enter event resolver.
      def on_focus_enter! ...
        on!(FocusEnterEvent, ...)
      end

      # See #on_focus_enter!.
      def on_focus_enter= param
        on_focus_enter! do: param
      end

      # Create and attach focus leave event resolver.
      def on_focus_leave! ...
        on!(FocusLeaveEvent, ...)
      end

      # See #on_focus_leave!.
      def on_focus_leave= param
        on_focus_leave! do: param
      end
    end
  end
end