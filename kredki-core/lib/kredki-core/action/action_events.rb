require_relative '../event/event_callings'
require_relative '../event/keyboard_event_callings'
require_relative '../event/mouse_event_callings'
require_relative '../event/joystick_event_callings'
require_relative '../event/drop_event'
require_relative '../event/key_event'
require_relative '../event/mouse_button_event'
require_relative '../event/mouse_move_event'
require_relative '../event/mouse_scroll_event'
require_relative '../event/quit_event'
require_relative '../event/text_event'
require_relative '../event/window_event'
require_relative '../event/joystick_event'

require_relative '../event/step_event'

module Kredki
  module ActionEvents

    def on_key_down! *filtered_keys, &block
      keycodes = keyboard.keycodes *filtered_keys
      callings = (@on_event[KeyDownEvent] ||= KeyboardEventCallings.new)[*keycodes]
      block ? callings.attach(block) : callings
    end

    alias_method :on_key!, :on_key_down!

    def on_key_up! *filtered_keys, &block
      keycodes = keyboard.keycodes *filtered_keys
      callings = (@on_event[KeyUpEvent] ||= KeyboardEventCallings.new)[*keycodes]
      block ? callings.attach(block) : callings
    end

    def on_text! &block
      on_event! TextEvent, &block
    end

    def on_mouse_move! &block
      on_event! MouseMoveEvent, &block
    end

    def on_mouse_scroll! &block
      on_event! MouseScrollEvent, &block
    end

    alias_method :on_scroll!, :on_mouse_scroll!

    def on_mouse_button! *filtered_buttons, &block
      indexes = mouse.indexes *filtered_buttons
      callings = (@on_event[MouseButtonDownEvent] ||= MouseEventCallings.new)[*indexes]
      block ? callings.attach(block) : callings
    end

    alias_method :on_mouse_button_down!, :on_mouse_button!

    def on_mouse_button_up! *filtered_buttons, &block
      indexes = mouse.indexes *filtered_buttons
      callings = (@on_event[MouseButtonUpEvent] ||= MouseEventCallings.new)[*indexes]
      block ? callings.attach(block) : callings
    end

    def on_joystick_button_down! joystick, *filtered_buttons, &block
      action_joystick = self.joystick joystick
      indexes = action_joystick.buttons *filtered_buttons
      callings = (@on_event[JoystickButtonDownEvent] ||= JoystickEventCallings.new)[*indexes, joystick: action_joystick.joystick]
      block ? callings.attach(block) : callings
    end

    alias_method :on_joystick_button!, :on_joystick_button_down!

    def on_joystick_button_up! joystick, *filtered_buttons, &block
      action_joystick = self.joystick joystick
      indexes = action_joystick.buttons *filtered_buttons
      callings = (@on_event[JoystickButtonUpEvent] ||= JoystickEventCallings.new)[*indexes, joystick: action_joystick.joystick]
      block ? callings.attach(block) : callings
    end

    def on_joystick_axis! joystick, *filtered_axes, &block
      action_joystick = self.joystick joystick
      indexes = action_joystick.axes *filtered_axes
      callings = (@on_event[JoystickAxisEvent] ||= JoystickEventCallings.new)[*indexes, joystick: action_joystick.joystick]
      block ? callings.attach(block) : callings
    end

    def on_drop_begin! &block
      on_event! DropBeginEvent, &block
    end

    def on_drop! &block
      on_event! FileDropEvent, &block
    end

    def on_drop_end! &block
      on_event! DropEndEvent, &block
    end

    def on_quit! &block
      on_event! QuitEvent, &block
    end

    def on_show! &block
      on_event! WindowShowEvent, &block
    end 

    def on_hide! &block
      on_event! WindowHideEvent, &block
    end

    def on_expose! &block
      on_event! WindowExposeEvent, &block
    end

    def on_move! &block
      on_event! WindowMoveEvent, &block
    end

    def on_resize! &block
      on_event! WindowResizeEvent, &block
    end

    def on_size_change! &block
      on_event! WindowSizeChangeEvent, &block
    end

    def on_minimize! &block
      on_event! WindowMinimizeEvent, &block
    end

    def on_maximize! &block
      on_event! WindowMaximizeEvent, &block
    end

    def on_restore! &block
      on_event! WindowRestoreEvent, &block
    end

    def on_enter! &block
      on_event! WindowEnterEvent, &block
    end

    def on_leave! &block
      on_event! WindowLeaveEvent, &block
    end

    def on_focus_gain! &block
      on_event! WindowFocusGainEvent, &block
    end

    def on_focus_lose! &block
      on_event! WindowFocusLoseEvent, &block
    end

    def on_close! &block
      on_event! WindowCloseEvent, &block
    end

    def on_take_focus! &block
      on_event! WindowTakeFocusEvent, &block
    end

    def on_hit_test! &block
      on_event! WindowHitTestEvent, &block
    end

    def on_iccprof_change! &block
      on_event! WindowIccprofChangeEvent, &block
    end

    def on_display_change! &block
      on_event! WindowDisplayChangeEvent, &block
    end

    def on_step! &block
      on_event! StepEvent, &block
    end

    #internal api

    def on_event! event_type, &block
      callings = @on_event[event_type] ||= EventCallings.new
      block ? callings.attach(block) : callings
    end
  end
end