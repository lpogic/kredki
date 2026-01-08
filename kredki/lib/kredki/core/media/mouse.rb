module Kredki
  # Mouse interface and configuration.
  class Mouse
    # Mouse button interface.
    class Button
      
      # Get button id.
      def id
        @id
      end

      # Get button code.
      def buttoncode
        @buttoncode
      end

      # :section: LEVEL 2

      def initialize id, buttoncode
        @id = id
        @buttoncode = buttoncode
      end
  
      def ==(other)
        Button === other &&
        @buttoncode == other.buttoncode &&
        @id == other.id
      end
    end

    # Get button codes.
    def indexes input
      input.map{ button(_1).buttoncode }.uniq
    end

    # Set scrollbar speed.
    def scrollbar_speed! speed = @scrollbar_speed
      return scrollbar_speed! yield @scrollbar_speed if block_given?
      @scrollbar_speed = speed
      true
    end

    # See #scrollbar_speed!.
    def scrollbar_speed= param
      scrollbar_speed! param
    end

    # Get scrollbar speed.
    def scrollbar_speed
      @scrollbar_speed
    end

    # Set alternative scrollbar speed.
    def scrollbar_alt_speed! speed = @scrollbar_alt_speed
      return scrollbar_alt_speed! yield @scrollbar_alt_speed if block_given?
      @scrollbar_alt_speed = speed
      true
    end

    # See #scrollbar_alt_speed!.
    def scrollbar_alt_speed= param
      scrollbar_alt_speed! param
    end

    # Get alternative scrollbar speed.
    def scrollbar_alt_speed
      @scrollbar_alt_speed
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

    # Get whether button is down.
    def down? id = :primary
      Pastele.mouse_get_button_state(button(id).buttoncode) != 0
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
      get_cursor_position
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
    
    # :section: LEVEL 2

    def initialize &block
      @button_map = {}
      @buttoncode_map = {}
      @scrollbar_speed = 0.3
      @scrollbar_alt_speed = 0.06
      alter &block
    end

    def get_cursor_position
      point = Pastele::Point.malloc(Fiddle::RUBY_FREE)
      Pastele.mouse_get_cursor_position point
      [point.x, point.y]
    end    
  end
end