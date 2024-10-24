require_relative 'event/drop_event'
require_relative 'event/key_event'
require_relative 'event/mouse_button_event'
require_relative 'event/mouse_move_event'
require_relative 'event/mouse_scroll_event'
require_relative 'event/quit_event'
require_relative 'event/text_event'
require_relative 'event/window_event'
require_relative 'event/joystick_event'
require_relative 'event/event_director'

module Kredki
  class Arena
    def initialize
      @pointer = Abi.arena_new
      ObjectSpace.define_finalizer(self, Arena.proc.finalize(@pointer))

      @event_callback = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP], &proc.event)
      Abi.arena_set_event_handler @pointer, @event_callback
      @windows = {}
      @window_threads = {}
      @event_director = EventDirector.new
    end

    def window! action = nil, *a, **na, &b
      push_window(Window.new).action!(action).alter(*a, **na, &b)
    end

    def window key = nil
      key ? @windows[key] : @main_window
    end

    def run!
      # generate initial resize event
      @windows.values.each{|w| w.set_size *w.get_size }
      Abi.arena_run @pointer
      @result
    end

    def terminate! result = nil
      @result = result
      Abi.arena_terminate @pointer
    end

    #internal api

    def self.finalize pointer
      Abi.arena_delete pointer
    end

    attr :pointer, :event_director

    def event event_type, event_ptr
      event = case event_type
      when 768
        abi = Abi::KeyboardEvent.new event_ptr
        window_event abi.window_id, KeyDownEvent.new(Kredki.keyboard, abi)
      when 769
        abi = Abi::KeyboardEvent.new event_ptr
        window_event abi.window_id, KeyUpEvent.new(Kredki.keyboard, abi)
      when 1024
        abi = Abi::MouseMotionEvent.new event_ptr
        window_event abi.window_id, MouseMoveEvent.new(Kredki.mouse, abi)
      when 1027
        abi = Abi::MouseWheelEvent.new event_ptr
        window_event abi.window_id, MouseScrollEvent.new(Kredki.mouse, abi)
      when 1025
        abi = Abi::MouseButtonEvent.new event_ptr
        window_event abi.window_id, MouseButtonDownEvent.new(Kredki.mouse, abi)
      when 1026
        abi = Abi::MouseButtonEvent.new event_ptr
        window_event abi.window_id, MouseButtonUpEvent.new(Kredki.mouse, abi)
      when 771
        abi = Abi::TextInputEvent.new event_ptr
        window_event abi.window_id, TextEvent.new(event_ptr, abi)
      when 4096
        abi = Abi::DropEvent event_ptr
        window_event abi.window_id, FileDropEvent.new(abi)
      when 4098
        abi = Abi::DropEvent event_ptr
        window_event abi.window_id, DropBeginEvent.new(abi)
      when 4099
        abi = Abi::DropEvent event_ptr
        window_event abi.window_id, DropEndEvent.new(abi)
      when 512
        abi_event = Abi::WindowEvent.new event_ptr
        
        case abi_event.event
        when 1 then window_event abi_event.window_id, WindowShowEvent.new(abi_event)
        when 2 then window_event abi_event.window_id, WindowHideEvent.new(abi_event)
        when 3 then window_event abi_event.window_id, WindowExposeEvent.new(abi_event)
        when 4 then window_event abi_event.window_id, WindowMoveEvent.new(abi_event)
        when 5 then window_event abi_event.window_id, WindowResizeEvent.new(abi_event)
        when 6 then window_event abi_event.window_id, WindowSizeChangeEvent.new(abi_event)
        when 7 then window_event abi_event.window_id, WindowMinimizeEvent.new(abi_event)
        when 8 then window_event abi_event.window_id, WindowMaximizeEvent.new(abi_event)
        when 9 then window_event abi_event.window_id, WindowRestoreEvent.new(abi_event)
        when 10
          Kredki.mouse.in_window = true
          window_event abi_event.window_id, WindowEnterEvent.new(abi_event)
        when 11
          Kredki.mouse.in_window = false
          window_event abi_event.window_id, WindowLeaveEvent.new(abi_event)
        when 12 then window_event abi_event.window_id, WindowFocusGainEvent.new(abi_event)
        when 13 then window_event abi_event.window_id, WindowFocusLoseEvent.new(abi_event)
        when 14 
          window_event abi_event.window_id, WindowCloseEvent.new(abi_event) do
            @windows[abi_event.window_id]&.destroy!
          end
        when 15 then window_event abi_event.window_id, WindowTakeFocusEvent.new(abi_event)
        when 16 then window_event abi_event.window_id, WindowHitTestEvent.new(abi_event)
        when 17 then window_event abi_event.window_id, WindowIccprofChangeEvent.new(abi_event)
        when 18 then window_event abi_event.window_id, WindowDisplayChangeEvent.new(abi_event)
        else 0
        end
      when 256 then arena_event QuitEvent.new(abi_event)
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
        arena_event JoystickConnectEvent.new(joystick, abi_event) do
          device_id = Abi.joystick_open abi_event.which
          Kredki.opened_joysticks[device_id] = joystick
          joystick.device_id = device_id
        end
      when 1542
        abi_event = Abi::JoyDeviceEvent.new event_ptr
        device_id = abi_event.which
        joystick = Kredki.opened_joysticks[device_id]
        arena_event JoystickDisconnectEvent.new(joystick, abi_event) do
          joystick = Kredki.opened_joysticks.delete device_id
          joystick&.device_id = nil
        end
      else # unsupported event
        # p event_type
        nil
      end
      event&.resolved? ? 1 : 0
    end

    def push_window window
      window_id = Abi.arena_insert_window @pointer, window.pointer
      @windows[window_id] = window
      @main_window ||= window
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
      if @windows.empty?
        terminate!
      else
        @main_window = @windows.values.first if @main_window == window
      end
    end

    private

    def window_event window_id, event, &autoresolve
      @event_director.stem do
        @windows[window_id]&.resolve event
      end
      if !event.resolved? && autoresolve
        autoresolve.call event
        event.resolve
      end
      event
    end

    def arena_event event, &autoresolve
      @event_director.stem do
        @windows.values.each{ _1.resolve event }
      end
      if !event.resolved? && autoresolve
        autoresolve.call event
        event.resolve
      end
      event
    end
  end
end