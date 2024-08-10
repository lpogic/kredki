require_relative 'event/drop_event'
require_relative 'event/key_event'
require_relative 'event/mouse_button_event'
require_relative 'event/mouse_move_event'
require_relative 'event/mouse_scroll_event'
require_relative 'event/quit_event'
require_relative 'event/text_event'
require_relative 'event/window_event'
require_relative 'event/joystick_event'

module Kredki
  class Arena
    def initialize
      @pointer = Abi.arena_new
      ObjectSpace.define_finalizer(self, self.class.proc.finalize(@pointer))

      @event_callback = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP], &proc.event)
      Abi.arena_set_event_handler @pointer, @event_callback
      @windows = {}
      @window_threads = {}
    end

    def window! ...
      push_window(Window.new).alter(...)
    end

    def window key = nil
      @windows[key || @main_window]
    end

    def run!
      Abi.arena_run @pointer
    end

    def terminate!
      Abi.arena_terminate @pointer
    end

    #internal api

    def self.finalize pointer
      Abi.arena_delete pointer
    end

    attr :pointer

    def event event_type, event_ptr
      case event_type
      when 768
        window_event KeyDownEvent.new(Kredki.keyboard, Abi::KeyboardEvent.new(event_ptr))
      when 769
        window_event KeyUpEvent.new(Kredki.keyboard, Abi::KeyboardEvent.new(event_ptr))
      when 1024
        window_event MouseMoveEvent.new(Kredki.mouse, Abi::MouseMotionEvent.new(event_ptr))
      when 1027
        window_event MouseScrollEvent.new(Kredki.mouse, Abi::MouseWheelEvent.new(event_ptr))
      when 1025
        window_event MouseButtonDownEvent.new(Kredki.mouse, Abi::MouseButtonEvent.new(event_ptr))
      when 1026
        window_event MouseButtonUpEvent.new(Kredki.mouse, Abi::MouseButtonEvent.new(event_ptr))
      when 771
        window_event TextEvent.new(event_ptr, Abi::TextInputEvent.new(event_ptr))
      when 4096
        window_event FileDropEvent.new(Abi::DropEvent.new(event_ptr))
      when 4098
        window_event DropBeginEvent.new(Abi::DropEvent.new(event_ptr))
      when 4099
        window_event DropEndEvent.new(Abi::DropEvent.new(event_ptr))
      when 512
        abi_event = Abi::WindowEvent.new event_ptr
        
        case abi_event.event
        when 1 then window_event WindowShowEvent.new abi_event
        when 2 then window_event WindowHideEvent.new abi_event
        when 3 then window_event WindowExposeEvent.new abi_event
        when 4 then window_event WindowMoveEvent.new abi_event
        when 5 then window_event WindowResizeEvent.new abi_event
        when 6 then window_event WindowSizeChangeEvent.new abi_event
        when 7 then window_event WindowMinimizeEvent.new abi_event
        when 8 then window_event WindowMaximizeEvent.new abi_event
        when 9 then window_event WindowRestoreEvent.new abi_event
        when 10 then window_event WindowEnterEvent.new abi_event
        when 11 then window_event WindowLeaveEvent.new abi_event
        when 12 then window_event WindowFocusGainEvent.new abi_event
        when 13 then window_event WindowFocusLoseEvent.new abi_event
        when 14 
          events_called = window_event WindowCloseEvent.new abi_event
          @windows[abi_event.window_id]&.destroy! if events_called == 0
          events_called
        when 15 then window_event WindowTakeFocusEvent.new abi_event
        when 16 then window_event WindowHitTestEvent.new abi_event
        when 17 then window_event WindowIccprofChangeEvent.new abi_event
        when 18 then window_event WindowDisplayChangeEvent.new abi_event
        else 0
        end
      when 256 then arena_event QuitEvent.new abi_event
      when 1539
        abi_event = Abi::JoyButtonEvent.new event_ptr
        arena_event JoystickButtonDownEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 1540
        abi_event = Abi::JoyButtonEvent.new event_ptr
        arena_event JoystickButtonUpEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 1536
        abi_event = Abi::JoyAxisEvent.new event_ptr
        arena_event JoystickAxisEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 1541
        abi_event = Abi::JoyDeviceEvent.new event_ptr
        joystick = (Kredki.joysticks - Kredki.opened_joysticks.values).max{ _1.match abi_event.which } || Joystick.new
        events_called = arena_event JoystickConnectEvent.new(joystick, abi_event)
        if events_called == 0
          device_id = Abi.joystick_open abi_event.which
          Kredki.opened_joysticks[device_id] = joystick
          joystick.device_id = device_id
        end
        events_called
      when 1542
        abi_event = Abi::JoyDeviceEvent.new event_ptr
        device_id = abi_event.which
        joystick = Kredki.opened_joysticks[device_id]
        events_called = arena_event JoystickDisconnectEvent.new(joystick, abi_event)
        if events_called == 0
          joystick = Kredki.opened_joysticks.delete device_id
          joystick&.device_id = nil
        end
        events_called
      else
        # p event_type
        0
      end
    end

    def push_window window
      window_id = Abi.arena_insert_window @pointer, window.pointer
      @windows[window_id] = window
      @main_window ||= window_id
      window.arena = self
      @window_threads[window_id] = Thread.new do
        loop do
          sleep 0.0162
          Abi.window_update window.pointer
        end
      end
      window
    end

    def remove_window window
      window_id = Abi.arena_erase_window(@pointer, window.pointer)
      @window_threads.delete(window_id)&.kill
      @windows.delete window_id
      window.arena = nil
      terminate! if @windows.empty?
    end

    private

    def window_event event
      call_cnt = @windows[event.window_id]&.event(event) || 0
      event.clear
      call_cnt
    end

    def arena_event event
      call_cnt = @windows.values.map{ _1.event(event) }.sum
      event.clear
      call_cnt
    end
  end
end