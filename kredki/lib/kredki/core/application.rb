module Kredki
  class Application
    
    # Create new window.
    def window! *a, show: true, **na, &b
      w = Window.new
      s = put_window(w).scene!(*a, **na, &b)
      w.show! if show
      s
    end

    # Get window.
    def window key = nil
      (key ? @windows[key] : @main_window)&.then{ it.scene }
    end

    # Start event loop.
    def run
      @run_ms = Kredki.ms
      Pastele.application_run @pointer
      @result
    end

    def run_ms
      @run_ms
    end

    def ms
      Kredki.ms - (@run_ms || 0)
    end

    # Break event loop.
    def exit result = nil
      @result = result
      Pastele.application_exit @pointer
    end

    # :section: LEVEL 2

    def initialize
      @pointer = Pastele.application_new
      ObjectSpace.define_finalizer(self, Application.finalizer(@pointer))

      @event_callback = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP], &method(:event))
      Pastele.application_set_event_handler @pointer, @event_callback
      @windows = {}
      @window_threads = {}
      @early_close_next_text_event = false
    end

    def self.finalizer pointer
      proc{ Pastele.application_delete pointer }
    end

    def event event_type, event_ptr
      event = case event_type
      when 768
        abi = Pastele::KeyboardEvent.new event_ptr
        window_event abi.window_id, KeyboardKeyPressEvent.new(Kredki.keyboard, abi) do |event|
          @early_close_next_text_event = event.closed? && (32..122).include?(event.input_id)
        end
      when 769
        abi = Pastele::KeyboardEvent.new event_ptr
        window_event abi.window_id, KeyboardKeyReleaseEvent.new(Kredki.keyboard, abi)
      when 1024
        abi = Pastele::MouseMotionEvent.new event_ptr
        event = MousePointerMoveEvent.new Kredki.mouse, abi
        if window = @windows[abi.window_id]
          window.report event
        end
        event
      when 1027
        abi = Pastele::MouseWheelEvent.new event_ptr
        window_event abi.window_id, MouseWheelSpinEvent.new(Kredki.mouse, abi)
      when 1025
        abi = Pastele::MouseButtonEvent.new event_ptr
        event = MouseButtonPressEvent.new Kredki.mouse, abi
        if window = @windows[abi.window_id]
          window.report event
        end
        event
      when 1026
        abi = Pastele::MouseButtonEvent.new event_ptr
        event = MouseButtonReleaseEvent.new Kredki.mouse, abi
        if window = @windows[abi.window_id]
          window.report event
        end
        event
      when 771
        abi = Pastele::TextInputEvent.new event_ptr
        text_event = TextInputEvent.new(event_ptr, abi)
        @early_close_next_text_event &&= text_event.close && false
        window_event abi.window_id, text_event
      when 4096
        abi = Pastele::DropEvent event_ptr
        window_event abi.window_id, FileDropEvent.new(abi)
      when 4098
        abi = Pastele::DropEvent event_ptr
        window_event abi.window_id, DropBeginEvent.new(abi)
      when 4099
        abi = Pastele::DropEvent event_ptr
        window_event abi.window_id, DropEndEvent.new(abi)
      when 0x202
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, ShowEvent.new(abi)
      when 0x203
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, HideEvent.new(abi)
      when 0x204
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, WindowExposeEvent.new(abi)
      when 0x205
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, MoveEvent.new(abi)
      when 0x206
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, ResizeEvent.new(abi)
      when 0x209
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, WindowMinimizeEvent.new(abi)
      when 0x20A
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, WindowMaximizeEvent.new(abi)
      when 0x20B
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, WindowRestoreEvent.new(abi)
      when 0x20C
        abi = Pastele::WindowEvent.new event_ptr
        event = MousePointerEnterEvent.new abi
        if window = @windows[abi.window_id]
          window.set_mouse_in true
          window.report event
        end
        event
      when 0x20D
        abi = Pastele::WindowEvent.new event_ptr
        event = MousePointerLeaveEvent.new abi
        if window = @windows[abi.window_id]
          window.set_mouse_in false
          window.report event
        end
        event
      when 0x20E
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, FocusEnterEvent.new(abi)
      when 0x20F
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, FocusLeaveEvent.new(abi)
      when 0x210
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, WindowCloseEvent.new(abi) do |event|
          unless event.closed?
            @windows[abi.window_id]&.close!
            event.close
          end
        end
      when 0x211
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, WindowHitTestEvent.new(abi)
      when 0x212
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, WindowIccprofChangeEvent.new(abi)
      when 0x213
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, WindowDisplayChangeEvent.new(abi)
      when 256
        application_event ExitEvent.new(Pastele::QuitEvent.new event_ptr)
      when 1539
        abi_event = Pastele::JoyButtonEvent.new event_ptr
        application_event JoystickButtonPressEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 1540
        abi_event = Pastele::JoyButtonEvent.new event_ptr
        application_event JoystickMouseButtonReleaseEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 1536
        abi_event = Pastele::JoyAxisEvent.new event_ptr
        application_event JoystickAxisEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 1541
        abi_event = Pastele::JoyDeviceEvent.new event_ptr
        joystick = (Kredki.joysticks - Kredki.opened_joysticks.values).max{ _1.match abi_event.which } || Joystick.new
        application_event JoystickConnectEvent.new(joystick, abi_event) do |event|
          unless event.closed?
            device_id = Pastele.joystick_open abi_event.which
            Kredki.opened_joysticks[device_id] = joystick
            joystick.device_id = device_id
            event.close
          end
        end
      when 1542
        abi_event = Pastele::JoyDeviceEvent.new event_ptr
        device_id = abi_event.which
        joystick = Kredki.opened_joysticks[device_id]
        application_event JoystickDisconnectEvent.new(joystick, abi_event) do |event|
          unless event.closed?
            joystick = Kredki.opened_joysticks.delete device_id
            joystick&.device_id = nil
            event.close
          end
        end
      when 32769
        abi = Pastele::UserEvent.new event_ptr
        window_event abi.window_id, TickEvent.new(abi)
      else # unsupported event
        # puts event_type
        nil
      end
      event&.closed? ? 1 : 0
    end

    def put_window window
      window_id = Pastele.application_insert_window @pointer, window.pointer
      @windows[window_id] = window
      @main_window ||= window
      window.application = self
      @window_threads[window_id] = Thread.new do
        loop do
          sleep 0.02
          Pastele.window_update window.pointer
        end
      end
      window
    end

    def remove_window window
      window_id = Pastele.application_erase_window(@pointer, window.pointer)
      @window_threads.delete(window_id)&.kill
      @windows.delete window_id
      window.application = nil
      if @windows.empty?
        exit
      else
        @main_window = @windows.values.first if @main_window == window
      end
    end

    def window_event window_id, event, &post_process
      @windows[window_id]&.report event
      post_process&.call event
      event
    end

    def application_event event, &post_process
      @windows.values.each{ it.report event }
      post_process&.call event
      event
    end
  end
end