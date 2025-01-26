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
      end
  
      def trace= enabled
        @trace = enabled
      end
  
      def trace?
        !!@trace
      end
    end

    class PositionEvent < Event
      model :x, :y

      def xy
        [@x, @y]
      end
    end

    class MouseEvent < PositionEvent
      extend Forwardable

      model :origin do
        @x ||= @origin.x
        @y ||= @origin.y
      end

      def_delegators :@origin,
        :symbol, :button, :repeat?, :clicks
    end

    class MouseMoveEvent < MouseEvent
    end

    class MouseButtonDownEvent < MouseEvent
      def_delegators :@origin,
        :button_number
    end

    class MouseButtonUpEvent < MouseEvent
      def_delegators :@origin,
        :button_number
    end

    class DropEvent < MouseEvent
    end

    class ClickEvent < MouseEvent
    end

    class DragEvent < MouseEvent
    end

    class ShowEvent < Event
    end

    class HideEvent < Event
    end

    class MoveEvent < Event
    end

    class ResizeEvent < Event
      model :w, :h
    end

    class EnterEvent < Event
    end

    class LeaveEvent < Event
    end

    class FocusGainEvent < Event
    end

    class FocusLoseEvent < Event
    end

    class RepaintEvent < Event
    end

    class EditEvent < Event
      model :selection_min, :selection_max, :string, :type

      def [](key = :string)
        send key
      end
    end

    class ChangeEvent < Event
    end

    class ROIEvent < PositionEvent
      model :w, :h

      def wh
        [@w, @h]
      end
    end

    class SizeModeEvent < Event
    end

    module PadEvents

      aliasing def on_key! *filtered_keys, aim: false, force: false, &block
        keycodes = keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyDownEvent, keycodes, block, aim, force
      end, :on_key_down!

      def on_key_up! *filtered_keys, aim: false, force: false, &block
        keycodes = keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyUpEvent, keycodes, block, aim, force
      end

      def on_text! aim: false, force: false, &block
        on! TextEvent, aim:, force:, &block
      end
  
      aliasing def on_mouse_button! *filtered_buttons, aim: false, force: false, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonDownEvent, indexes, block, aim, force
      end, :on_mouse_button_down!
  
      def on_mouse_button_up! *filtered_buttons, aim: false, force: false, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonUpEvent, indexes, block, aim, force
      end
  
      def on_mouse_move! aim: false, force: false, &block
        on! MouseMoveEvent, aim:, force:, &block
      end

      aliasing def on_scroll! aim: false, force: false, &block
        on! MouseScrollEvent, aim:, force:, &block
      end, :on_mouse_scroll!

      def on_external_drop! aim: false, force: false, &block
        on! FileDropEvent, aim:, force:, &block
      end

      aliasing def on_joystick_button! joystick, *filtered_buttons, aim: false, force: false, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickButtonDownEvent, action_joystick.joystick, indexes, block, aim, force
      end, :on_joystick_button_down!

      def on_joystick_button_up! joystick, *filtered_buttons, aim: false, force: false, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickButtonUpEvent, action_joystick.joystick, indexes, block, aim, force
      end

      def on_joystick_axis! joystick, *filtered_axes, aim: false, force: false, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.axes filtered_axes
        @event_manager.joystick_manager JoystickAxisEvent, action_joystick.joystick, indexes, block, aim, force
      end

      def on_show! aim: false, force: false, &block
        on! ShowEvent, aim:, force:, &block
      end 

      def on_hide! aim: false, force: false, &block
        on! HideEvent, aim:, force:, &block
      end

      def on_move! aim: false, force: false, &block
        on! MoveEvent, aim:, force:, &block
      end

      def on_resize! aim: false, force: false, &block
        on! ResizeEvent, aim:, force:, &block
      end

      def on_enter! aim: false, force: false, &block
        on! EnterEvent, aim:, force:, &block
      end

      def on_leave! aim: false, force: false, &block
        on! LeaveEvent, aim:, force:, &block
      end

      def on_focus_gain! aim: false, force: false, &block
        on! FocusGainEvent, aim:, force:, &block
      end

      def on_focus_lose! aim: false, force: false, &block
        on! FocusLoseEvent, aim:, force:, &block
      end

      def on_click! aim: false, force: false, &block
        on! ClickEvent, aim:, force:, &block
      end

      def on_drag! aim: false, force: false, &block
        on! DragEvent, aim:, force:, &block
      end

      def on_drop! aim: false, force: false, &block
        on! DropEvent, aim:, force:, &block
      end

      def on_repaint! aim: false, force: false, &block
        on! RepaintEvent, aim:, force:, &block
      end

      def on! event_type, aim: false, force: false, &block
        @event_manager.manager event_type, block, aim, force
      end

      def event_director
        Kredki.event_director
      end
    end
  end
end