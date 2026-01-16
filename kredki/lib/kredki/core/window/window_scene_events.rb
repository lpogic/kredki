module Kredki
  # Set of methods for event resolving.
  module WindowSceneEvents

    # Create and attach generic event reaction.
    def on event_type, do: nil, &block
      @event_manager.manager event_type, block || binding.local_variable_get(:do)
    end

    # Create and attach key(s) press event reaction.
    def on_key_press *selected_keys, do: nil, &block
      keycodes = Kredki.keyboard.keycodes selected_keys
      @event_manager.keyboard_manager KeyboardKeyPressEvent, keycodes, block || binding.local_variable_get(:do)
    end

    # See #on_key_press.
    def on_key_press= reaction
      on_key_press do: reaction
    end

    # Create and attach key(s) release event reaction.
    def on_key_release *selected_keys, do: nil, &block
      keycodes = Kredki.keyboard.keycodes selected_keys
      @event_manager.keyboard_manager KeyboardKeyReleaseEvent, keycodes, block || binding.local_variable_get(:do)
    end

    # See #on_key_release.
    def on_key_release= reaction
      on_key_release do: reaction
    end

    # Create and attach text event reaction.
    def on_text_input ...
      on(TextInputEvent, ...)
    end

    # See #on_text_input.
    def on_text_input= reaction
      on_text_input do: reaction
    end

    # Create and attach mouse button(s) press event reaction.
    def on_mouse_press *selected_buttons, do: nil, &block
      indexes = Kredki.mouse.indexes selected_buttons
      @event_manager.mouse_manager MouseButtonPressEvent, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_mouse_press.
    def on_mouse_press= reaction
      on_mouse_press do: reaction
    end

    # Create and attach mouse button(s) release event reaction.
    def on_mouse_release *selected_buttons, do: nil, &block
      indexes = Kredki.mouse.indexes selected_buttons
      @event_manager.mouse_manager MouseButtonReleaseEvent, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_mouse_release.
    def on_mouse_release= reaction
      on_mouse_release do: reaction
    end

    # Create and attach mouse pointer enter event reaction.
    def on_mouse_enter ...
      on(MousePointerEnterEvent, ...)
    end

    # See #on_mouse_enter.
    def on_mouse_enter= reaction
      on_mouse_enter do: reaction
    end

    # Create and attach mouse pointer leave event reaction.
    def on_mouse_leave ...
      on(MousePointerLeaveEvent, ...)
    end

    # See #on_mouse_leave.
    def on_mouse_leave= reaction
      on_mouse_leave do: reaction
    end

    # Create and attach mouse pointer move event reaction.
    def on_mouse_move ...
      on(MousePointerMoveEvent, ...)
    end

    # See #on_mouse_move.
    def on_mouse_move= reaction
      on_mouse_move do: reaction
    end
    
    # Create and attach mouse wheel scroll event reaction.
    def on_mouse_scroll ...
      on(MouseWheelScrollEvent, ...)
    end

    # See #on_mouse_scroll.
    def on_mouse_scroll= reaction
      on_mouse_scroll do: reaction
    end

    # Create and attach joystick button(s) press event reaction.
    def on_joystick_press *buttons, joystick: nil, do: nil, &block
      j = Kredki.joystick joystick
      indexes = j.buttons buttons
      j = nil if joystick.nil?
      @event_manager.joystick_manager JoystickButtonPressEvent, j, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_joystick_press.
    def on_joystick_press= reaction
      on_joystick_press do: reaction
    end

    # Create and attach joystick button(s) release event reaction.
    def on_joystick_release *buttons, joystick: nil, do: nil, &block
      j = Kredki.joystick joystick
      indexes = j.buttons buttons
      j = nil if joystick.nil?
      @event_manager.joystick_manager JoystickButtonReleaseEvent, j, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_joystick_release.
    def on_joystick_release= reaction
      on_joystick_release do: reaction
    end

    # Create and attach joystick axis(axes) move event reaction.
    def on_joystick_move *axes, joystick: nil, do: nil, &block
      j = Kredki.joystick joystick
      indexes = j.axes axes
      j = nil if joystick.nil?
      @event_manager.joystick_manager JoystickAxisMoveEvent, j, indexes, block || binding.local_variable_get(:do)
    end

    # See #on_joystick_move.
    def on_joystick_move= reaction
      on_joystick_move do: reaction
    end

    # Create and attach drop begin event reaction.
    def on_drop_begin ...
      on(DropBeginEvent, ...)
    end

    # See #on_drop_begin.
    def on_drop_begin= reaction
      on_drop_begin do: reaction
    end

    # Create and attach file drop event reaction.
    def on_drop ...
      on(DropEvent, ...)
    end

    # See #on_drop.
    def on_drop= reaction
      on_drop do: reaction
    end

    # Create and attach drop cancel event reaction.
    def on_drop_cancel ...
      on(DropCancelEvent, ...)
    end

    # See #on_drop_cancel.
    def on_drop_cancel= reaction
      on_drop_cancel do: reaction
    end

    # Create and attach tick event reaction.
    def on_tick ...
      on(TickEvent, ...)
    end

    # See #on_tick.
    def on_tick= reaction
      on_tick do: reaction
    end

    # Create and attach quit event reaction.
    def on_exit ...
      on(ExitEvent, ...)
    end

    # See #on_exit.
    def on_exit= reaction
      on_exit do: reaction
    end

    # Create and attach window show event reaction.
    def on_show ...
      on(ShowEvent, ...)
    end

    # See #on_show.
    def on_show= reaction
      on_show do: reaction
    end

    # Create and attach window hide event reaction.
    def on_hide ...
      on(HideEvent, ...)
    end

    # See #on_hide.
    def on_hide= reaction
      on_hide do: reaction
    end

    # Create and attach window expose event reaction.
    def on_expose ...
      on(WindowExposeEvent, ...)
    end

    # See #on_expose.
    def on_expose= reaction
      on_expose do: reaction
    end

    # Create and attach window move event reaction.
    def on_move ...
      on(MoveEvent, ...)
    end

    # See #on_move.
    def on_move= reaction
      on_move do: reaction
    end

    # Create and attach window resize event reaction.
    def on_resize ...
      on(ResizeEvent, ...)
    end

    # See #on_resize.
    def on_resize= reaction
      on_resize do: reaction
    end

    # Create and attach window size change event reaction.
    def on_size_change ...
      on(WindowSizeChangeEvent, ...)
    end

    # See #on_size_change.
    def on_size_change= reaction
      on_size_change do: reaction
    end

    # Create and attach window minimize event reaction.
    def on_minimize ...
      on(WindowMinimizeEvent, ...)
    end

    # See #on_minimize.
    def on_minimize= reaction
      on_minimize do: reaction
    end

    # Create and attach window maximize event reaction.
    def on_maximize ...
      on(WindowMaximizeEvent, ...)
    end

    # See #on_maximize.
    def on_maximize= reaction
      on_maximize do: reaction
    end

    # Create and attach window restore event reaction.
    def on_restore ...
      on(WindowRestoreEvent, ...)
    end

    # See #on_restore.
    def on_restore= reaction
      on_restore do: reaction
    end

    # Create and attach window close event reaction.
    def on_close ...
      on(WindowCloseEvent, ...)
    end

    # See #on_close.
    def on_close= reaction
      on_close do: reaction
    end

    # Create and attach focus enter event reaction.
    def on_focus_enter ...
      on(FocusEnterEvent, ...)
    end

    # See #on_focus_enter.
    def on_focus_enter= reaction
      on_focus_enter do: reaction
    end

    # Create and attach focus leave event reaction.
    def on_focus_leave ...
      on(FocusLeaveEvent, ...)
    end

    # See #on_focus_leave.
    def on_focus_leave= reaction
      on_focus_leave do: reaction
    end

    # Create and attach focus take event reaction.
    def on_focus_take ...
      on(WindowFocusTakeEvent, ...)
    end

    # See #on_focus_take.
    def on_focus_take= reaction
      on_focus_take do: reaction
    end

    # Create and attach hit test event reaction.
    def on_hit_test ...
      on(WindowHitTestEvent, ...)
    end

    # See #on_hit_test.
    def on_hit_test= reaction
      on_hit_test do: reaction
    end

    # Create and attach iccprof change event reaction.
    def on_iccprof_change ...
      on(WindowIccprofChange, ...)
    end

    # See #on_iccprof_change.
    def on_iccprof_change= reaction
      on_iccprof_change do: reaction
    end

    # Create and attach display change event reaction.
    def on_display_change ...
      on(WindowDisplayChangeEvent, ...)
    end

    # See #on_display_change.
    def on_display_change= reaction
      on_display_change do: reaction
    end
  end
end