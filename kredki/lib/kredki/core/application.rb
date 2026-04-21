module Kredki
  class Application
    
    # Run application event loop.
    def run
      @run_ms = Kredki.ms
      Pastele.application_run @pointer
      Kredki.clear_app
      @result
    end

    # Open window in application.
    def open opened = nil, *a, hidden: false, **ka, &b
      case opened
      when Window
        window = opened
        result = put_window(window).pane!.set(*a, **ka, &b)
        window.show unless hidden
      else
        window = default_window
        pane = opened || window.default_pane
        result = put_window(window).set_pane(pane).set(*a, **ka, &b)
        window.show unless hidden
      end
      result
    end

    # Get window.
    def window key = nil
      (key ? @windows[key] : @main_window)&.then{|it| it.scene }
    end

    # Get milliseconds since run.
    def ms
      Kredki.ms - (@run_ms || 0)
    end

    # Break event loop.
    def return result = nil
      @result = result
      @windows.each_value{|it| delete_window it, false }
      Pastele.application_exit @pointer
    end

    # General event exception handler.
    def rescue &block
      @rescue = block if block
      @rescue
    end

    # :section: LEVEL 2

    class DropData
      def initialize source, text, type
        @source = source
        @text = text
        @type = type
      end

      attr_accessor :source
      attr_accessor :text
      attr_accessor :type
    end

    def initialize
      @pointer = Pastele.application_new
      ObjectSpace.define_finalizer(self, Application.finalizer(@pointer))

      @event_callback = Fiddle::Closure::BlockCaller.new(Fiddle::TYPE_INT, [Fiddle::TYPE_INT, Fiddle::TYPE_VOIDP], &method(:event))
      Pastele.application_set_event_handler @pointer, @event_callback
      @rescue = nil
      @windows = {}
      @early_close_next_text_event = false
      @drop_data = nil
    end

    def self.finalizer pointer
      proc{ Pastele.application_delete pointer }
    end

    def run_ms
      @run_ms
    end

    def event event_type, event_ptr
      event = case event_type
      when 0x202
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, ShowEvent.new(abi)
      when 0x203
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, HideEvent.new(abi)
      when 0x204
        abi = Pastele::WindowEvent.new event_ptr
        application_event WindowExposeEvent.new(abi)
      when 0x205
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, MoveEvent.new(abi.data1, abi.data2, abi)
      when 0x206
        abi = Pastele::WindowEvent.new event_ptr
        window_event abi.window_id, ResizeEvent.new(abi.data1, abi.data2, abi)
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
          window.update_mouse_in true
          window.report event
        end
        event
      when 0x20D
        abi = Pastele::WindowEvent.new event_ptr
        event = MousePointerLeaveEvent.new abi
        if window = @windows[abi.window_id]
          window.update_mouse_in false
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
          unless event.closed
            window = @windows[abi.window_id]
            delete_window window if window
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
      when 0x300 # SDL_EVENT_KEY_DOWN
        abi = Pastele::KeyboardEvent.new event_ptr
        if keyboard = Kredki.keyboard
          event = keyboard.key_press_event abi
          window_event abi.window_id, event do |event|
            @early_close_next_text_event = event.closed && (32..122).include?(event.code)
          end
        end
      when 0x301 # SDL_EVENT_KEY_UP
        abi = Pastele::KeyboardEvent.new event_ptr
        if keyboard = Kredki.keyboard
          event = keyboard.key_release_event abi
          window_event abi.window_id, event
        end
      when 0x400 # SDL_EVENT_MOUSE_MOTION
        abi = Pastele::MouseMotionEvent.new event_ptr
        if mouse = Kredki.mouse
          event = mouse.pointer_move_event abi
          window_event abi.window_id, event
        end
      when 0x401 # SDL_EVENT_MOUSE_BUTTON_DOWN
        abi = Pastele::MouseButtonEvent.new event_ptr
        if mouse = Kredki.mouse
          event = mouse.button_press_event abi
          window_event abi.window_id, event
        end
      when 0x402 # SDL_EVENT_MOUSE_BUTTON_UP
        abi = Pastele::MouseButtonEvent.new event_ptr
        if mouse = Kredki.mouse
          event = mouse.button_release_event abi
          window_event abi.window_id, event
          event
        end
      when 0x403 # SDL_EVENT_MOUSE_WHEEL
        abi = Pastele::MouseWheelEvent.new event_ptr
        if mouse = Kredki.mouse
          event = Kredki.mouse.wheel_scroll_event abi
          window_event abi.window_id, event
        end
      when 0x303 # SDL_EVENT_TEXT_EDITING
        abi = Pastele::TextInputEvent.new event_ptr
        event = TextInputEvent.new event_ptr, abi
        @early_close_next_text_event &&= event.close && false
        window_event abi.window_id, event
      when 0x600 # SDL_EVENT_JOYSTICK_AXIS_MOTION
        abi_event = Pastele::JoyAxisEvent.new event_ptr
        application_event JoystickAxisMoveEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 0x602 # SDL_EVENT_JOYSTICK_HAT_MOTION
        abi_event = Pastele::JoyHatEvent.new event_ptr
        application_event JoystickHatSwitchEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 0x603 # SDL_EVENT_JOYSTICK_BUTTON_DOWN
        abi_event = Pastele::JoyButtonEvent.new event_ptr
        application_event JoystickButtonPressEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 0x604 # SDL_EVENT_JOYSTICK_BUTTON_UP
        abi_event = Pastele::JoyButtonEvent.new event_ptr
        application_event JoystickButtonReleaseEvent.new(Kredki.opened_joysticks[abi_event.which], abi_event)
      when 0x605 # SDL_EVENT_JOYSTICK_ADDED
        abi_event = Pastele::JoyDeviceEvent.new event_ptr
        joystick = (Kredki.joysticks.values - Kredki.opened_joysticks.values).max{ _1.match abi_event.which } || Joystick.new
        application_event JoystickConnectEvent.new(joystick, abi_event) do |event|
          unless event.closed
            device_id = Pastele.joystick_open abi_event.which
            Kredki.opened_joysticks[device_id] = joystick
            joystick.device_id = device_id
            event.close
          end
        end
      when 0x606 # SDL_EVENT_JOYSTICK_REMOVED
        abi_event = Pastele::JoyDeviceEvent.new event_ptr
        device_id = abi_event.which
        joystick = Kredki.opened_joysticks[device_id]
        application_event JoystickDisconnectEvent.new(joystick, abi_event) do |event|
          unless event.closed
            joystick = Kredki.opened_joysticks.delete device_id
            joystick&.device_id = nil
            event.close
          end
        end
      when 0x1000 # SDL_EVENT_DROP_FILE
        abi = Pastele::DropEvent.new event_ptr
        @drop_data << DropData.new(
          abi.source.then{|it| it.null? ? nil : it.to_s.force_encoding("utf-8") },
          abi.data.to_s.force_encoding("utf-8"),
          :file,
        )
        nil
      when 0x1001 # SDL_EVENT_DROP_TEXT
        abi = Pastele::DropEvent.new event_ptr
        @drop_data << DropData.new(
          abi.source.then{|it| it.null? ? nil : it.to_s.force_encoding("utf-8") },
          abi.data.to_s.force_encoding("utf-8"),
          :text,
        )
        nil
      when 0x1002 # SDL_EVENT_DROP_BEGIN
        @drop_data = []
        abi = Pastele::DropEvent.new event_ptr
        window_event abi.window_id, DropBeginEvent.new(abi)
      when 0x1003 # SDL_EVENT_DROP_COMPLETE
        abi = Pastele::DropEvent.new event_ptr
        if @drop_data.empty?
          window_event abi.window_id, DropCancelEvent.new(abi)
        else
          window_event abi.window_id, DropEvent.new(@drop_data, abi)
        end
      when 0x1004 # SDL_EVENT_DROP_POSITION
        abi = Pastele::DropEvent.new event_ptr
        event = MousePointerDropEvent.new Kredki.mouse, abi
        window_event abi.window_id, event
      when 256
        application_event ExitEvent.new(Pastele::QuitEvent.new event_ptr)
      when 0x8001 # USEREVENT_UPDATEWINDOW
        abi = Pastele::UserEvent.new event_ptr
        window_event abi.window_id, TickEvent.new(abi)
      when 0x8007 # Close window Event
        abi = Pastele::UserEvent.new event_ptr
        window_event abi.window_id, TickEvent.new(abi)
      when 0x8008 # USEREVENT_UPDATECOMPLETEWINDOW
        abi = Pastele::UserEvent.new event_ptr
        window_event abi.window_id, UpdateCompleteEvent.new(abi)
      else # unsupported event
        # puts event_type.to_s 16
        nil
      end
      event&.closed ? 1 : 0
    end

    def put_window window
      window_id = Pastele.application_insert_window @pointer, window.pointer
      @windows[window_id] = window
      @main_window ||= window
      window.attach self
      window
    end

    def delete_window window, last_exit = true
      window.hide
      window_id = Pastele.application_erase_window(@pointer, window.pointer)
      @windows.delete window_id
      window.detach
      if last_exit && @windows.empty?
        self.return
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
      @windows.values.each{|it| it.report event }
      post_process&.call event
      event
    end

    def default_window
      Window.new
    end
  end
end