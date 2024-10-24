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
        @mode = :default
      end
  
      attr_accessor :mode
      
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

      def track
        @track = true
      end
  
      def track= enabled
        @track = enabled
      end
  
      def track?
        !!@track
      end
    end
  
    class MouseEvent < Event
      extend Forwardable

      model :origin, :x, :y do
        @x ||= @origin.x
        @y ||= @origin.y
      end

      def xy
        [@x, @y]
      end

      def_delegators :@origin,
        :symbol, :button, :repeat?, :clicks
    end

    class MouseMoveEvent < MouseEvent
    end

    class MouseButtonDownEvent < MouseEvent
    end

    class MouseButtonUpEvent < MouseEvent
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

      def w?
        !!@w
      end

      def h?
        !!@h
      end
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
    
    class ContentChangeEvent < Event
    end

    class ReboundEvent < Event
    end

    module PadEvents

      aliasing def on_key! *filtered_keys, mode: :default, &block
        keycodes = keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyDownEvent, keycodes, block, mode
      end, :on_key_down!

      def on_key_up! *filtered_keys, mode: :default, &block
        keycodes = keyboard.keycodes filtered_keys
        @event_manager.keyboard_manager KeyUpEvent, keycodes, block, mode
      end

      def on_text! mode: :default, &block
        on! TextEvent, &block
      end
  
      aliasing def on_mouse_button! *filtered_buttons, mode: :default, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonDownEvent, indexes, block, mode
      end, :on_mouse_button_down!
  
      def on_mouse_button_up! *filtered_buttons, mode: :default, &block
        indexes = mouse.indexes filtered_buttons
        @event_manager.mouse_manager MouseButtonUpEvent, indexes, block, mode
      end
  
      def on_mouse_move! mode: :default, &block
        on! MouseMoveEvent, mode:, &block
      end

      aliasing def on_scroll! mode: :default, &block
        on! MouseScrollEvent, mode:, &block
      end, :on_mouse_scroll!

      def on_external_drop! mode: :default, &block
        on! FileDropEvent, mode:, &block
      end

      aliasing def on_joystick_button! joystick, *filtered_buttons, mode: :default, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickButtonDownEvent, action_joystick.joystick, indexes, block, mode
      end, :on_joystick_button_down!

      def on_joystick_button_up! joystick, *filtered_buttons, mode: :default, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.buttons filtered_buttons
        @event_manager.joystick_manager JoystickButtonUpEvent, action_joystick.joystick, indexes, block, mode
      end

      def on_joystick_axis! joystick, *filtered_axes, mode: :default, &block
        action_joystick = self.joystick joystick
        indexes = action_joystick.axes filtered_axes
        @event_manager.joystick_manager JoystickAxisEvent, action_joystick.joystick, indexes, block, mode
      end

      def on_show! mode: :default, &block
        on! ShowEvent, mode:, &block
      end 

      def on_hide! mode: :default, &block
        on! HideEvent, mode:, &block
      end

      def on_move! mode: :default, &block
        on! MoveEvent, mode:, &block
      end

      def on_resize! mode: :default, &block
        on! ResizeEvent, mode:, &block
      end

      def on_enter! mode: :default, &block
        on! EnterEvent, mode:, &block
      end

      def on_leave! mode: :default, &block
        on! LeaveEvent, mode:, &block
      end

      def on_focus_gain! mode: :default, &block
        on! FocusGainEvent, mode:, &block
      end

      def on_focus_lose! mode: :default, &block
        on! FocusLoseEvent, mode:, &block
      end

      def on_click! mode: :default, &block
        on! ClickEvent, mode:, &block
      end

      def on_drag! mode: :default, &block
        on! DragEvent, mode:, &block
      end

      def on_drop! mode: :default, &block
        on! DropEvent, mode:, &block
      end

      def on_repaint! mode: :default, &block
        on! RepaintEvent, mode:, &block
      end

      def on! event_type, mode: :default, &block
        @event_manager.manager event_type, block, mode
      end

      def event_director
        Kredki.event_director
      end
    end
  end
end