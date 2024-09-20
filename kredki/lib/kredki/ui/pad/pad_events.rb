require 'forwardable'

module Kredki
  module UI
    class PadMouseEvent
      extend Forwardable

      model :origin, :x, :y do
        @x ||= @origin.x
        @y ||= @origin.y
      end

      def translate xo, yo
        self.class.new @origin, @x - xo, @y - yo
      end

      def xy
        [@x, @y]
      end

      def_delegators :@origin,
        :symbol, :button, :repeat?, :clicks
    end

    class PadMouseMoveEvent < PadMouseEvent
    end

    class PadMouseButtonDownEvent < PadMouseEvent
    end

    class PadMouseButtonUpEvent < PadMouseEvent
    end

    class PadDropEvent < PadMouseEvent
    end

    class PadClickEvent < PadMouseEvent
    end

    class PadDragEvent < PadMouseEvent
    end

    class PadShowEvent
    end

    class PadHideEvent
    end

    class PadMoveEvent
    end

    class PadResizeEvent
    end

    class PadEnterEvent
    end

    class PadLeaveEvent
    end

    class PadFocusGainEvent
    end

    class PadFocusLoseEvent
    end

    class PadStateEvent
    end

    class PadEditEvent
    end

    class PadChangeEvent
    end

    module PadEvents

      def on_key_down! *filtered_keys, &block
        keycodes = keyboard.keycodes *filtered_keys
        callings = (@on_event[KeyDownEvent] ||= KeyboardEventCallings.new)[*keycodes]
        block ? callings.attach!(block) : callings
      end

      alias_method :on_key!, :on_key_down!

      def on_key_up! *filtered_keys, &block
        keycodes = keyboard.keycodes *filtered_keys
        callings = (@on_event[KeyUpEvent] ||= KeyboardEventCallings.new)[*keycodes]
        block ? callings.attach!(block) : callings
      end

      def on_text! &block
        on_event! TextEvent, &block
      end

      def on_mouse_move! &block
        on_event! PadMouseMoveEvent, &block
      end

      def on_mouse_scroll! &block
        on_event! MouseScrollEvent, &block
      end

      alias_method :on_scroll!, :on_mouse_scroll!

      def on_mouse_button! *filtered_buttons, &block
        indexes = mouse.indexes *filtered_buttons
        callings = (@on_event[PadMouseButtonDownEvent] ||= MouseEventCallings.new)[*indexes]
        block ? callings.attach!(block) : callings
      end

      alias_method :on_mouse_button_down!, :on_mouse_button!

      def on_mouse_button_up! *filtered_buttons, &block
        indexes = mouse.indexes *filtered_buttons
        callings = (@on_event[PadMouseButtonUpEvent] ||= MouseEventCallings.new)[*indexes]
        block ? callings.attach!(block) : callings
      end

      def on_joystick_button_down! joystick, *filtered_buttons, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.buttons *filtered_buttons
        callings = (@on_event[JoystickButtonDownEvent] ||= JoystickEventCallings.new)[*indexes, joystick: action_joystick.joystick]
        block ? callings.attach!(block) : callings
      end

      alias_method :on_joystick_button!, :on_joystick_button_down!

      def on_joystick_button_up! joystick, *filtered_buttons, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.buttons *filtered_buttons
        callings = (@on_event[JoystickButtonUpEvent] ||= JoystickEventCallings.new)[*indexes, joystick: action_joystick.joystick]
        block ? callings.attach!(block) : callings
      end

      def on_joystick_axis! joystick, *filtered_axes, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.axes *filtered_axes
        callings = (@on_event[JoystickAxisEvent] ||= JoystickEventCallings.new)[*indexes, joystick: action_joystick.joystick]
        block ? callings.attach!(block) : callings
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

      def on_show! &block
        on_event! PadShowEvent, &block
      end 

      def on_hide! &block
        on_event! PadHideEvent, &block
      end

      def on_move! &block
        on_event! PadMoveEvent, &block
      end

      def on_resize! &block
        on_event! PadResizeEvent, &block
      end

      def on_enter! &block
        on_event! PadEnterEvent, &block
      end

      def on_leave! &block
        on_event! PadLeaveEvent, &block
      end

      def on_focus_gain! &block
        on_event! PadFocusGainEvent, &block
      end

      def on_focus_lose! &block
        on_event! PadFocusLoseEvent, &block
      end

      def on_click! &block
        on_event! PadClickEvent, &block
      end

      def on_drag! &block
        on_event! PadDragEvent, &block
      end

      def on_drop! &block
        on_event! PadDropEvent, &block
      end

      def on_state! &block
        on_event! PadStateEvent, &block
      end

      #internal api

      def on_event! event_type, &block
        callings = @on_event[event_type] ||= EventCallings.new
        block ? callings.attach!(block) : callings
      end

      def event event, instant = false
        if instant || !event_accumulator&.store(self, event)
          return @on_event[event.class]&.call(event) || 0
        else
          return 0
        end
      end
    end
  end
end