require 'kredki-core/event/key_event'
require 'kredki-core/event/text_event'
require 'kredki-core/event/mouse_button_event'
require 'kredki-core/event/mouse_move_event'
require 'kredki-core/event/mouse_scroll_event'
require 'kredki-core/event/joystick_event'
require 'kredki-core/event/drop_event'
require 'kredki-core/event/quit_event'
require 'kredki-core/event/window_event'
require 'kredki-core/event/step_event'
require 'forwardable'

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
        :symbol, :button, :repeat?, :clicks
    end

    class MouseMoveEvent < MouseEvent
      include OriginResolvingEvent

      model :drag, :<
    end

    class MouseButtonDownEvent < MouseEvent
      def_delegators :@origin,
        :button_number
    end

    class MouseButtonUpEvent < MouseEvent
      def_delegators :@origin,
        :button_number

        model :<, :drag
    end

    class MouseClickEvent < MouseEvent
      def button_number
        @origin&.button_number
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

    class EnterEvent < MouseEvent
      include OriginResolvingEvent
    end

    class LeaveEvent < MouseEvent
      include OriginResolvingEvent
    end

    class FocusGainEvent < Event
    end

    class FocusLoseEvent < Event
    end

    class KeyboardRequestEvent < Event
    end

    class EditEvent < Event
      model :selection_min, :selection_max, :string, :type, :<

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

      def on_text! aim: false, always: false, &block
        on! TextEvent, aim:, always:, &block
      end
  
      def on_mouse_down! *filtered_buttons, aim: false, always: false, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonDownEvent, indexes, block, aim, always
      end
  
      def on_mouse_up! *filtered_buttons, aim: false, always: false, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonUpEvent, indexes, block, aim, always
      end

      aliasing def on_click! *filtered_buttons, aim: false, always: false, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseClickEvent, indexes, block, aim, always
      end, :on_mouse_click!
  
      def on_mouse_move! aim: false, always: false, &block
        on! MouseMoveEvent, aim:, always:, &block
      end

      aliasing def on_scroll! aim: false, always: false, &block
        on! MouseScrollEvent, aim:, always:, &block
      end, :on_mouse_scroll!

      def on_external_drop! aim: false, always: false, &block
        on! FileDropEvent, aim:, always:, &block
      end

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

      def on_show! aim: false, always: false, &block
        on! ShowEvent, aim:, always:, &block
      end 

      def on_hide! aim: false, always: false, &block
        on! HideEvent, aim:, always:, &block
      end

      def on_move! aim: false, always: false, &block
        on! MoveEvent, aim:, always:, &block
      end

      def on_resize! aim: false, always: false, &block
        on! ResizeEvent, aim:, always:, &block
      end

      def on_mouse_enter! aim: false, always: false, &block
        on! EnterEvent, aim:, always:, &block
      end

      def on_mouse_leave! aim: false, always: false, &block
        on! LeaveEvent, aim:, always:, &block
      end

      def on_focus_gain! aim: false, always: false, &block
        on! FocusGainEvent, aim:, always:, &block
      end

      def on_focus_lose! aim: false, always: false, &block
        on! FocusLoseEvent, aim:, always:, &block
      end

      def on! event_type, aim: false, always: false, &block
        @event_manager.manager event_type, block, aim, always
      end
    end
  end
end