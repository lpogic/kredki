module Kredki
  # Mouse device model.
  class Mouse
    # Mouse button model.
    class Button
      
      # Get button id.
      def id
        @id
      end

      # Get button code.
      def code
        @code
      end

      # :section: LEVEL 2

      def initialize id, code
        @id = id
        @code = code
      end
  
      def ==(other)
        Button === other &&
        @code == other.code &&
        @id == other.id
      end
    end

    # Get button codes.
    def indexes input
      input.map{ button(_1).code }.uniq
    end

    # Set wheel speed.
    def scroll_speed! speed = @scroll_speed
      return scroll_speed! yield @scroll_speed if block_given?
      @scroll_speed = speed
      true
    end

    # See #scroll_speed!.
    def scroll_speed= param
      scroll_speed! param
    end

    # Get wheel speed.
    def scroll_speed
      @scroll_speed
    end

    # Set alternative wheel speed.
    def scroll_speed_alt! speed = @scroll_speed_alt
      return scroll_speed_alt! yield @scroll_speed_alt if block_given?
      @scroll_speed_alt = speed
      true
    end

    # See #scroll_speed_alt!.
    def scroll_speed_alt= param
      scroll_speed_alt! param
    end

    # Get alternative wheel speed.
    def scroll_speed_alt
      @scroll_speed_alt
    end

    # Set button.
    def button! id, code
      button = @button_map[id] = Button.new id, code
      @buttoncode_map[code] ||= button
    end

    # Get button.
    def button param
      case param
      when Button
        param
      else
        @buttoncode_map[param] or @button_map[param] or raise "Unknown button #{param.inspect}"
      end
    end

    # Get whether button is pressed.
    def pressed? id = :primary
      b = button id
      Pastele.mouse_get_button_state(b.code) != 0 if b
    end

    # Get pointer position along X axis.
    def x
      xy[0]
    end

    # Get pointer position along Y axis.
    def y
      xy[1]
    end

    # Get pointer position along X and Y axes.
    def xy
      point = Pastele::Point.malloc(Fiddle::RUBY_FREE)
      Pastele.mouse_get_cursor_position point
      [point.x, point.y]
    end

    # Set whether capture mode is on.
    def capture! value = true
      return if (c = capture) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.mouse_set_capture capture ? 1 : 0
      true
    end

    # See #capture!.
    def capture= param
      caupture! param
    end

    # Set cursor.
    def cursor! cursor = @cursor
      return send_ahp :cursor!, yield(self.cursor) if block_given?
      return if @cursor == cursor
      @cursor = cursor
      set_cursor cursor
      true
    end

    # See #cursor!.
    def cursor= param
      send_ahp :cursor!, param
    end

    # Get cursor.
    def cursor
      @cursor
    end
    
    # :section: LEVEL 2

    def initialize
      @button_map = {}
      @buttoncode_map = {}
      @scroll_speed = 0.3
      @scroll_speed_alt = 0.06
      @cursor = nil
      @system_cursors = {}
    end

    def wheel_scroll_event pastele_event
      MouseWheelScrollEvent.new self, pastele_event
    end

    def pointer_move_event pastele_event
      MousePointerMoveEvent.new self, pastele_event
    end

    def button_press_event pastele_event
      MouseButtonPressEvent.new self, pastele_event
    end

    def button_release_event pastele_event
      MouseButtonReleaseEvent.new self, pastele_event
    end

    def set_cursor cursor
      Pastele.mouse_set_cursor case cursor
      when nil, :default then system_cursor 0
      when :text then system_cursor 1
      when :wait then system_cursor 2
      when :crosshair then system_cursor 3
      when :progress then system_cursor 4
      when :resize_ssee, :resize_eess then system_cursor 5
      when :resize_sees, :resize_esse then system_cursor 6
      when :resize_x then system_cursor 7
      when :resize_y then system_cursor 8
      when :move then system_cursor 9
      when :not_allowed then system_cursor 10
      when :pointer then system_cursor 11
      when :resize_ss then system_cursor 12
      when :resize_ys then system_cursor 13
      when :resize_es then system_cursor 14
      when :resize_xe then system_cursor 15
      when :resize_ee then system_cursor 16
      when :resize_ye then system_cursor 17
      when :resize_se then system_cursor 18
      when :resize_xs then system_cursor 19
      when :count then system_cursor 20
      end
    end

    def system_cursor cursor
      @system_cursors[cursor] ||= Pastele.mouse_create_system_cursor cursor
    end
  end
end