require_relative '../event/key_event'
require_relative '../event/text_event'
require_relative '../event/mouse_event'
require_relative '../event/joystick_event'
require_relative '../event/drop_event'
require_relative '../event/quit_event'
require_relative '../event/step_event'
require_relative '../event/window_event'

module Kredki
  # Set of methods for event resolving.
  module WindowSceneEvents

    # Create and attach generic event resolver.
    def on! event_type, do: nil, &block
      @event_manager.manager event_type, block || binding.local_variable_get(:do)
    end

    # Create and attach key down event resolver.
    def on_key_press! *selected_keys, do: nil, &block
      keycodes = Kredki.keyboard.keycodes selected_keys
      @event_manager.keyboard_manager KeyboardKeyPushEvent, keycodes, block || binding.local_variable_get(:do)
    end

    # See #on_key_press!.
    def on_key_press= resolver
      on_key_press! do: resolver
    end

    # Create and attach key up event resolver.
    def on_key_free! *selected_keys, do: nil, &block
      keycodes = Kredki.keyboard.keycodes selected_keys
      @event_manager.keyboard_manager KeyboardKeyFreeEvent, keycodes, block || binding.local_variable_get(:do)
    end

    # See #on_key_free!.
    def on_key_free= resolver
      on_key_free! do: resolver
    end

    # Create and attach text event resolver.
    def on_text_input! ...
      on!(TextInputEvent, ...)
    end

    # See #on_text_input!.
    def on_text_input= resolver
      on_text_input! do: resolver
    end

    # Create and attach mouse down event resolver.
    def on_mouse_press! *selected_buttons, do: nil, &block
      indexes = Kredki.mouse.indexes selected_buttons
      @event_manager.button_manager ButtonDownEvent, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_mouse_press!.
    def on_mouse_press= resolver
      on_mouse_press! do: resolver
    end

    # Create and attach mouse up event resolver.
    def on_mouse_free! *selected_buttons, do: nil, &block
      indexes = Kredki.mouse.indexes selected_buttons
      @event_manager.button_manager MouseButtonFreeEvent, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_mouse_free!.
    def on_mouse_free= resolver
      on_mouse_free! do: resolver
    end

    # Create and attach mouse enter event resolver.
    def on_mouse_enter! ...
      on!(PointerEnterEvent, ...)
    end

    # See #on_mouse_enter!.
    def on_mouse_enter= resolver
      on_mouse_enter! do: resolver
    end

    # Create and attach mouse leave event resolver.
    def on_mouse_leave! ...
      on!(PointerLeaveEvent, ...)
    end

    # See #on_mouse_leave!.
    def on_mouse_leave= resolver
      on_mouse_leave! do: resolver
    end

    # Create and attach mouse move event resolver.
    def on_mouse_move! ...
      on!(PointerMoveEvent, ...)
    end

    # See #on_mouse_move!.
    def on_mouse_move= resolver
      on_mouse_move! do: resolver
    end
    
    # Create and attach mouse spin event resolver.
    def on_mouse_spin! ...
      on!(MouseWheelSpinEvent, ...)
    end

    # See #on_mouse_spin!.
    def on_mouse_spin= resolver
      on_mouse_spin! do: resolver
    end

    # Create and attach joystick down event resolver.
    def on_joystick_press! joystick_id, *selected_buttons, do: nil, &block
      joystick = Kredki.joystick joystick_id
      indexes = joystick.buttons selected_buttons
      @event_manager.joystick_manager JoystickButtonDownEvent, joystick, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_joystick_press!.
    def on_joystick_press= resolver
      on_joystick_press! do: resolver
    end

    # Create and attach joystick up event resolver.
    def on_joystick_free! joystick_id, *selected_buttons, do: nil, &block
      joystick = Kredki.joystick joystick_id
      indexes = joystick.buttons selected_buttons
      @event_manager.joystick_manager JoystickMouseButtonFreeEvent, joystick, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_joystick_free!.
    def on_joystick_free= resolver
      on_joystick_free! do: resolver
    end

    # Create and attach joystick move event resolver.
    def on_joystick_move! joystick_id, *selected_axes, do: nil, &block
      joystick = Kredki.joystick joystick_id
      indexes = joystick.axes selected_axes
      @event_manager.joystick_manager JoystickAxisEvent, joystick, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_joystick_move!.
    def on_joystick_move= resolver
      on_joystick_move! do: resolver
    end

    # Create and attach drop begin event resolver.
    def on_drop_begin! ...
      on!(DropBeginEvent, ...)
    end

    # See #on_drop_begin!.
    def on_drop_begin= resolver
      on_drop_begin! do: resolver
    end

    # Create and attach file drop event resolver.
    def on_file_drop! ...
      on!(FileDropEvent, ...)
    end

    # See #on_file_drop!.
    def on_file_drop= resolver
      on_file_drop! do: resolver
    end

    # Create and attach drop end event resolver.
    def on_drop_end! ...
      on!(DropEndEvent, ...)
    end

    # See #on_drop_end!.
    def on_drop_end= resolver
      on_drop_end! do: resolver
    end

    # Create and attach step event resolver.
    def on_clock_step! ...
      on!(StepEvent, ...)
    end

    # See #on_clock_step!.
    def on_clock_step= resolver
      on_clock_step! do: resolver
    end

    # Create and attach quit event resolver.
    def on_quit! ...
      on!(QuitEvent, ...)
    end

    # See #on_quit!.
    def on_quit= resolver
      on_quit! do: resolver
    end

    # Create and attach window show event resolver.
    def on_window_show! ...
      on!(WindowShowEvent, ...)
    end

    # See #on_window_show!.
    def on_window_show= resolver
      on_window_show! do: resolver
    end

    # Create and attach window hide event resolver.
    def on_window_hide! ...
      on!(WindowHideEvent, ...)
    end

    # See #on_window_hide!.
    def on_window_hide= resolver
      on_window_hide! do: resolver
    end

    # Create and attach window expose event resolver.
    def on_window_expose! ...
      on!(WindowExposeEvent, ...)
    end

    # See #on_window_expose!.
    def on_window_expose= resolver
      on_window_expose! do: resolver
    end

    # Create and attach window move event resolver.
    def on_window_move! ...
      on!(MoveEvent, ...)
    end

    # See #on_window_move!.
    def on_window_move= resolver
      on_window_move! do: resolver
    end

    # Create and attach window resize event resolver.
    def on_window_resize! ...
      on!(ResizeEvent, ...)
    end

    # See #on_window_resize!.
    def on_window_resize= resolver
      on_window_resize! do: resolver
    end

    # Create and attach window size change event resolver.
    def on_window_size_change! ...
      on!(WindowSizeChangeEvent, ...)
    end

    # See #on_window_size_change!.
    def on_window_size_change= resolver
      on_window_size_change! do: resolver
    end

    # Create and attach window minimize event resolver.
    def on_window_minimize! ...
      on!(WindowMinimizeEvent, ...)
    end

    # See #on_window_minimize!.
    def on_window_minimize= resolver
      on_window_minimize! do: resolver
    end

    # Create and attach window maximize event resolver.
    def on_window_maximize! ...
      on!(WindowMaximizeEvent, ...)
    end

    # See #on_window_maximize!.
    def on_window_maximize= resolver
      on_window_maximize! do: resolver
    end

    # Create and attach window restore event resolver.
    def on_window_restore! ...
      on!(WindowRestoreEvent, ...)
    end

    # See #on_window_restore!.
    def on_window_restore= resolver
      on_window_restore! do: resolver
    end

    # Create and attach window close event resolver.
    def on_window_close! ...
      on!(WindowCloseEvent, ...)
    end

    # See #on_window_close!.
    def on_window_close= resolver
      on_window_close! do: resolver
    end

    # Create and attach focus enter event resolver.
    def on_focus_enter! ...
      on!(FocusEnterEvent, ...)
    end

    # See #on_focus_enter!.
    def on_focus_enter= resolver
      on_focus_enter! do: resolver
    end

    # Create and attach focus leave event resolver.
    def on_focus_leave! ...
      on!(FocusLeaveEvent, ...)
    end

    # See #on_focus_leave!.
    def on_focus_leave= resolver
      on_focus_leave! do: resolver
    end

    # Create and attach focus take event resolver.
    def on_focus_take! ...
      on!(WindowFocusTakeEvent, ...)
    end

    # See #on_focus_take!.
    def on_focus_take= resolver
      on_focus_take! do: resolver
    end

    # Create and attach hit test event resolver.
    def on_hit_test! ...
      on!(WindowHitTestEvent, ...)
    end

    # See #on_hit_test!.
    def on_hit_test= resolver
      on_hit_test! do: resolver
    end

    # Create and attach iccprof change event resolver.
    def on_iccprof_change! ...
      on!(WindowIccprofChange, ...)
    end

    # See #on_iccprof_change!.
    def on_iccprof_change= resolver
      on_iccprof_change! do: resolver
    end

    # Create and attach display change event resolver.
    def on_display_change! ...
      on!(WindowDisplayChangeEvent, ...)
    end

    # See #on_display_change!.
    def on_display_change= resolver
      on_display_change! do: resolver
    end
  end
end