require_relative '../../core/event/key_event'
require_relative '../../core/event/text_event'
require_relative '../../core/event/mouse_event'
require_relative '../../core/event/joystick_event'
require_relative '../../core/event/drop_event'
require_relative '../../core/event/window_event'

module Kredki
  module UI

    # Base class for UI events.
    class Event
    
      # Create new Event.
      def initialize target = nil
        @target = target
        @resolved = false
      end

      # Get target.
      def target
        @target
      end

      # Get main parameter. Overrided in inheriting classes.
      def param
      end

      # See #param.
      def ~()
        param
      end

      def inspect
        "#{self.class}:#{object_id}"
      end
        
      # Get whether event is resolved.
      def resolved?
        @resolved
      end
  
      # Mark event as resolved.
      def resolve
        @resolved = true
      end

      # Get current event resolver.
      def resolver
        Array === @resolver ? @resolver.last : @resolver
      end

      # Push event resolver
      def push_resolver resolver
        if Array === @resolver
          @resolver << resolver
        else
          @resolver = resolver
        end
      end
  
      # Attach few events to identical resolvers.
      def self.each *event_managers, do: nil, &block
        attached = block || binding.local_variable_get(:do)
        event_managers.map{ it.attach! attached }
      end
    end

    # Event with position
    class PositionEvent < Event

      def initialize x, y, target = nil
        super(target)
        @x = x
        @y = y
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

      def param
        xy
      end
    end

    # Event which resolved state is primary maintained by origin event.
    module OriginResolvingEvent
      def resolved?
        @origin ? @origin.resolved? : super
      end

      def resolve
        @origin ? @origin.resolve : super
      end
    end

    # Common mouse event class.
    class MouseEvent < PositionEvent

      def initialize origin, x = origin&.x, y = origin&.y, target = nil
        super(target)
        @origin = origin
        @x = x
        @y = y
      end

      # Get input id.
      def input_id
        @origin.input_id
      end

      # Get button.
      def button
        @origin.button
      end
    end

    class MouseMoveEvent < MouseEvent
      include OriginResolvingEvent

      model :drag, :<
    end

    class MouseEnterEvent < MouseEvent
      include OriginResolvingEvent

      def move?
        @origin&.is_a? MouseMoveEvent
      end
    end

    class MouseLeaveEvent < MouseEvent
      include OriginResolvingEvent

      def move?
        @origin&.is_a? MouseMoveEvent
      end
    end

    class MouseButtonDownEvent < MouseEvent
      def_delegators :@origin,
        :input_id
    end

    class MouseButtonUpEvent < MouseEvent
      def_delegators :@origin,
        :input_id

        model :<, :drag
    end

    class MouseClickEvent < MouseEvent
      def input_id
        @origin&.input_id
      end
    end

    class KeyboardEvent < Event
      extend Forwardable

      model :origin, :<

      def_delegators :@origin, *Kredki::KeyEvent.instance_methods(false)
    end

    class KeyDownEvent < KeyboardEvent
    end

    class KeyUpEvent < KeyboardEvent
    end

    class KeyClickEvent < KeyboardEvent
      include OriginResolvingEvent
    end

    class ShowEvent < Event
    end

    class HideEvent < Event
    end

    class MoveEvent < Event
    end

    class ResizeEvent < Event
      model :w, :h, :<
    end

    class FocusEnterEvent < Event
    end

    class FocusLeaveEvent < Event
    end

    class KeyboardOfferEvent < Event
    end

    class EditEvent < Event
      model :selection_min, :selection_max, :string, :action, :<

      def [](key = :string)
        send key
      end
    end

    class ChangeEvent < Event
      model :new_value, :old_value, :<

      def [](key = :new_value)
        send key
      end

      def ~()
        @new_value
      end
    end

    class ROIEvent < PositionEvent
      model :w, :h, :<

      def wh
        [@w, @h]
      end
    end

    module PadEvents
      extend HasEventResolvers

      def on! event_type, aim: false, always: false, do: nil, &block
        @event_manager.manager event_type, block || binding.local_variable_get(:do), aim, always
      end

      def on_key_down! *filtered_keys, aim: false, always: false, do: nil, &block
        keycodes = Kredki.keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyDownEvent, keycodes, block || binding.local_variable_get(:do), aim, always
      end

      def on_key_up! *filtered_keys, aim: false, always: false, do: nil, &block
        keycodes = Kredki.keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyUpEvent, keycodes, block || binding.local_variable_get(:do), aim, always
      end

      def on_key! *filtered_keys, aim: false, always: false, do: nil, &block
        keycodes = Kredki.keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyClickEvent, keycodes, block || binding.local_variable_get(:do), aim, always
      end

      event_resolver :on_text!, TextEvent
  
      def on_mouse_down! *filtered_buttons, aim: false, always: false, do: nil, &block
        indexes = Kredki.mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonDownEvent, indexes, block || binding.local_variable_get(:do), aim, always
      end
  
      event_resolver def on_mouse_up! *filtered_buttons, aim: false, always: false, do: nil, &block
        indexes = Kredki.mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonUpEvent, indexes, block || binding.local_variable_get(:do), aim, always
      end

      def on_click! *filtered_buttons, aim: false, always: false, do: nil, &block
        indexes = Kredki.mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseClickEvent, indexes, block || binding.local_variable_get(:do), aim, always
      end

      alias_method :on_mouse_click!, :on_click!
  
      event_resolver :on_mouse_enter!, MouseEnterEvent
      event_resolver :on_mouse_leave!, MouseLeaveEvent
      event_resolver :on_mouse_move!, MouseMoveEvent
      event_resolver :on_mouse_scroll!, MouseScrollEvent
      
      event_resolver :on_file_drop!, FileDropEvent

      def on_joystick_down! joystick_id, *filtered_buttons, aim: false, always: false, do: nil, &block
        joystick = Kredki.joystick joystick_id
        indexes = joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickButtonDownEvent, joystick, indexes, block || binding.local_variable_get(:do), aim, always
      end

      def on_joystick_up! joystick_id, *filtered_buttons, aim: false, always: false, do: nil, &block
        joystick = Kredki.joystick joystick_id
        indexes = joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickButtonUpEvent, joystick, indexes, block || binding.local_variable_get(:do), aim, always
      end

      def on_joystick_axis! joystick_id, *filtered_axes, aim: false, always: false, do: nil, &block
        joystick = Kredki.joystick joystick_id
        indexes = joystick.axes filtered_axes
        @event_manager.joystick_manager JoystickAxisEvent, joystick, indexes, block || binding.local_variable_get(:do), aim, always
      end

      event_resolver :on_show!, ShowEvent
      event_resolver :on_hide!, HideEvent
      event_resolver :on_move!, MoveEvent
      event_resolver :on_resize!, ResizeEvent
      event_resolver :on_focus_enter!, FocusEnterEvent
      event_resolver :on_focus_leave!, FocusLeaveEvent
    end
  end
end