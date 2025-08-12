require_relative '../../core/event/key_event'
require_relative '../../core/event/text_event'
require_relative '../../core/event/mouse_event'
require_relative '../../core/event/joystick_event'
require_relative '../../core/event/drop_event'
require_relative '../../core/event/quit_event'
require_relative '../../core/event/window_event'
require_relative '../../core/event/step_event'

module Kredki
  module UI

    class Event
    
      model :target do
        @resolved = false
        @break = false
      end

      def inspect
        "#{self.class}:#{object_id}"
      end
      
      def [](key)
        send key
      end
  
      def resolved?
        @resolved
      end
  
      def resolve
        @resolved = true
      end
  
      def break?
        @break
      end
  
      def break
        @break = true
      end
  
      def unbreak
        @break = false
      end  

      def trace
        @trace = true
        self
      end
  
      def trace= trace
        @trace = trace
      end
  
      def trace?
        !!@trace
      end

      def self.group *event_managers, &block
        event_managers.map{ it.attach! block }
      end
    end

    class PositionEvent < Event
      model :x, :y, :<

      def xy
        [@x, @y]
      end

      def ~()
        xy
      end
    end

    module OriginResolvingEvent
      def resolved?
        @origin ? @origin.resolved? : super
      end

      def resolve
        @origin ? @origin.resolve : super
      end

      def trace?
        super || @origin&.trace?
      end
    end

    class MouseEvent < PositionEvent
      extend Forwardable

      model :origin, :< do
        @x ||= @origin&.x
        @y ||= @origin&.y
      end

      def_delegators :@origin,
        :button_id, :button, :repeat?, :clicks
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
        :button_code
    end

    class MouseButtonUpEvent < MouseEvent
      def_delegators :@origin,
        :button_code

        model :<, :drag
    end

    class MouseClickEvent < MouseEvent
      def button_code
        @origin&.button_code
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
      extend HasParams
      extend HasEventResolvers

      def on! event_type, do: nil, aim: false, always: false, &block
        @event_manager.manager event_type, block || binding.local_variable_get(:do), aim, always
      end

      def on_key_down! *filtered_keys, aim: false, always: false, &block
        keycodes = keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyDownEvent, keycodes, block, aim, always
      end

      def on_key_up! *filtered_keys, aim: false, always: false, &block
        keycodes = keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyUpEvent, keycodes, block, aim, always
      end

      def on_key! *filtered_keys, aim: false, always: false, &block
        keycodes = keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyClickEvent, keycodes, block, aim, always
      end

      event_resolver :on_text!, TextEvent
  
      def on_mouse_down! *filtered_buttons, aim: false, always: false, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonDownEvent, indexes, block, aim, always
      end
  
      event_resolver def on_mouse_up! *filtered_buttons, aim: false, always: false, do: nil, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonUpEvent, indexes, block || binding.local_variable_get(:do), aim, always
      end

      aliasing def on_click! *filtered_buttons, aim: false, always: false, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseClickEvent, indexes, block, aim, always
      end, :on_mouse_click!
  
      event_resolver :on_mouse_enter!, MouseEnterEvent
      event_resolver :on_mouse_leave!, MouseLeaveEvent
      event_resolver :on_mouse_move!, MouseMoveEvent
      event_resolver :on_mouse_scroll!, MouseScrollEvent
      
      event_resolver :on_file_drop!, FileDropEvent

      def on_joystick_down! joystick, *filtered_buttons, aim: false, always: false, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickButtonDownEvent, action_joystick.joystick, indexes, block, aim, always
      end

      def on_joystick_up! joystick, *filtered_buttons, aim: false, always: false, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickButtonUpEvent, action_joystick.joystick, indexes, block, aim, always
      end

      def on_joystick_axis! joystick, *filtered_axes, aim: false, always: false, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.axes filtered_axes
        @event_manager.joystick_manager JoystickAxisEvent, action_joystick.joystick, indexes, block, aim, always
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