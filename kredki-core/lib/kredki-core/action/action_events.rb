require_relative '../event/key_event'
require_relative '../event/text_event'
require_relative '../event/mouse_button_event'
require_relative '../event/mouse_move_event'
require_relative '../event/mouse_scroll_event'
require_relative '../event/joystick_event'
require_relative '../event/drop_event'
require_relative '../event/quit_event'
require_relative '../event/window_event'
require_relative '../event/step_event'

module Kredki
  module ActionEvents

    aliasing def on_key! *filtered_keys, &block
      keycodes = keyboard.keycodes filtered_keys
      @event_manager.keyboard_manager KeyDownEvent, keycodes, block
    end, :on_key_down!

    def on_key_up! *filtered_keys, &block
      keycodes = keyboard.keycodes filtered_keys
      @event_manager.keyboard_manager KeyUpEvent, keycodes, block
    end

    def on_text! &block
      on! TextEvent, &block
    end

    aliasing def on_mouse_button! *filtered_buttons, &block
      indexes = mouse.indexes filtered_buttons
      @event_manager.mouse_manager MouseButtonDownEvent, indexes, block
    end, :on_mouse_button_down!

    def on_mouse_button_up! *filtered_buttons, &block
      indexes = mouse.indexes filtered_buttons
      @event_manager.mouse_manager MouseButtonUpEvent, indexes, block
    end

    def on_mouse_move! &block
      on! MouseMoveEvent, &block
    end

    aliasing def on_scroll! &block
      on! MouseScrollEvent, &block
    end, :on_mouse_scroll!

    aliasing def on_joystick_button! joystick, *filtered_buttons, &block
      action_joystick = self.joystick joystick
      indexes = action_joystick.buttons filtered_buttons
      @event_manager.joystick_manager JoystickButtonDownEvent, action_joystick.joystick, indexes, block
    end, :on_joystick_button_down!

    def on_joystick_button_up! joystick, *filtered_buttons, &block
      action_joystick = self.joystick joystick
      indexes = action_joystick.buttons filtered_buttons
      @event_manager.joystick_manager JoystickButtonUpEvent, action_joystick.joystick, indexes, block
    end

    def on_joystick_axis! joystick, *filtered_axes, &block
      action_joystick = self.joystick joystick
      indexes = action_joystick.axes filtered_axes
      @event_manager.joystick_manager JoystickAxisEvent, action_joystick.joystick, indexes, block
    end

    def on_drop_begin! &block
      on! DropBeginEvent, &block
    end

    def on_drop! &block
      on! FileDropEvent, &block
    end

    def on_drop_end! &block
      on! DropEndEvent, &block
    end

    def on_quit! &block
      on! QuitEvent, &block
    end

    def on_show! &block
      on! WindowShowEvent, &block
    end 

    def on_hide! &block
      on! WindowHideEvent, &block
    end

    def on_expose! &block
      on! WindowExposeEvent, &block
    end

    def on_move! &block
      on! WindowMoveEvent, &block
    end

    def on_resize! &block
      on! WindowResizeEvent, &block
    end

    def on_size_change! &block
      on! WindowSizeChangeEvent, &block
    end

    def on_minimize! &block
      on! WindowMinimizeEvent, &block
    end

    def on_maximize! &block
      on! WindowMaximizeEvent, &block
    end

    def on_restore! &block
      on! WindowRestoreEvent, &block
    end

    def on_mouse_enter! &block
      on! WindowMouseEnterEvent, &block
    end

    def on_mouse_leave! &block
      on! WindowMouseLeaveEvent, &block
    end

    def on_focus_gain! &block
      on! WindowFocusGainEvent, &block
    end

    def on_focus_lose! &block
      on! WindowFocusLoseEvent, &block
    end

    def on_close! &block
      on! WindowCloseEvent, &block
    end

    def on_take_focus! &block
      on! WindowTakeFocusEvent, &block
    end

    def on_hit_test! &block
      on! WindowHitTestEvent, &block
    end

    def on_iccprof_change! &block
      on! WindowIccprofChangeEvent, &block
    end

    def on_display_change! &block
      on! WindowDisplayChangeEvent, &block
    end

    def on_step! &block
      on! StepEvent, &block
    end

    def on! event_type, &block
      @event_manager.manager event_type, block
    end
  end
end