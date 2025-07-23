require_relative '../event/key_event'
require_relative '../event/text_event'
require_relative '../event/mouse_event'
require_relative '../event/joystick_event'
require_relative '../event/drop_event'
require_relative '../event/quit_event'
require_relative '../event/window_event'
require_relative '../event/step_event'

module Kredki
  module ActionEvents
    extend HasEventResolvers

    def on! event_type, do: nil, &block
      @event_manager.manager event_type, block || binding.local_variable_get(:do)
    end

    event_resolver def on_key_down! *filtered_keys, &block
      keycodes = keyboard.keycodes filtered_keys
      @event_manager.keyboard_manager KeyDownEvent, keycodes, block
    end

    event_resolver def on_key_up! *filtered_keys, &block
      keycodes = keyboard.keycodes filtered_keys
      @event_manager.keyboard_manager KeyUpEvent, keycodes, block
    end

    event_resolver :on_text!, TextEvent

    event_resolver def on_mouse_down! *filtered_buttons, &block
      indexes = mouse.indexes filtered_buttons
      @event_manager.mouse_manager MouseButtonDownEvent, indexes, block
    end

    event_resolver def on_mouse_up! *filtered_buttons, do: nil, &block
      indexes = mouse.indexes filtered_buttons
      @event_manager.mouse_manager MouseButtonUpEvent, indexes, block || binding.local_variable_get(:do)
    end

    event_resolver :on_mouse_enter!, WindowMouseEnterEvent
    event_resolver :on_mouse_leave!, WindowMouseLeaveEvent
    event_resolver :on_mouse_move!, MouseMoveEvent
    event_resolver :on_mouse_scroll!, MouseScrollEvent

    event_resolver def on_joystick_down! joystick, *filtered_buttons, &block
      action_joystick = self.joystick joystick
      indexes = action_joystick.buttons filtered_buttons
      @event_manager.joystick_manager JoystickButtonDownEvent, action_joystick.joystick, indexes, block
    end

    event_resolver def on_joystick_up! joystick, *filtered_buttons, &block
      action_joystick = self.joystick joystick
      indexes = action_joystick.buttons filtered_buttons
      @event_manager.joystick_manager JoystickButtonUpEvent, action_joystick.joystick, indexes, block
    end

    event_resolver def on_joystick_move! joystick, *filtered_axes, &block
      action_joystick = self.joystick joystick
      indexes = action_joystick.axes filtered_axes
      @event_manager.joystick_manager JoystickAxisEvent, action_joystick.joystick, indexes, block
    end

    event_resolver :on_drop_begin!, DropBeginEvent
    event_resolver :on_file_drop!, FileDropEvent
    event_resolver :on_drop_end!, DropEndEvent
    event_resolver :on_quit!, QuitEvent
    event_resolver :on_window_show!, WindowShowEvent
    event_resolver :on_window_hide!, WindowHideEvent
    event_resolver :on_window_expose!, WindowExposeEvent
    event_resolver :on_window_move!, WindowMoveEvent
    event_resolver :on_window_resize!, WindowResizeEvent
    event_resolver :on_window_size_change!, WindowSizeChangeEvent
    event_resolver :on_window_minimize!, WindowMinimizeEvent
    event_resolver :on_window_maximize!, WindowMaximizeEvent
    event_resolver :on_window_restore!, WindowRestoreEvent
    event_resolver :on_window_close!, WindowCloseEvent

    event_resolver :on_focus_enter!, WindowFocusGainEvent
    event_resolver :on_focus_leave!, WindowFocusLoseEvent
    event_resolver :on_focus_take!, WindowTakeFocusEvent
    event_resolver :on_hit_test!, WindowHitTestEvent
    event_resolver :on_iccprof_change!, WindowIccprofChangeEvent
    event_resolver :on_display_change!, WindowDisplayChangeEvent

    event_resolver :on_step!, StepEvent
  end
end