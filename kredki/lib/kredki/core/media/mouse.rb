module Kredki
  class Mouse
    extend HasFeatures

    class Button
      model :id, :buttoncode
  
      def to_i
        @buttoncode
      end
  
      def to_sym
        @id
      end
  
      def ==(other)
        Button === other &&
        @buttoncode == other.buttoncode &&
        @id == other.id
      end
    end

    def initialize &block
      @button_map = {}
      @buttoncode_map = {}
      @scrollbar_speed = 0.3
      @scrollbar_alt_speed = 0.06
      alter &block
    end

    feature def scrollbar_speed! speed = @scrollbar_speed
      return scrollbar_speed! yield @scrollbar_speed if block_given?
      @scrollbar_speed = speed
      true
    end

    feature def scrollbar_alt_speed! speed = @scrollbar_alt_speed
      return scrollbar_alt_speed! yield @scrollbar_alt_speed if block_given?
      @scrollbar_alt_speed = speed
      true
    end

    def button! id, code
      button = @button_map[id] = Button.new id, code
      @buttoncode_map[code] ||= button
    end

    def button param
      case param
      when Button
        param
      else
        @buttoncode_map[param] or @button_map[param] or raise "Unknown button #{param.inspect}"
      end
    end

    def down? button_id = :primary
      is_button_down button(button_id).to_i
    end

    def x
      xy[0]
    end

    def y
      xy[1]
    end

    def xy
      get_cursor_position
    end
    
    flag def relative! value = true
      return if (c = relative) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      set_relative value
      @relative = value
      true
    end

    def scrollbar_speed alt = false
      alt ? @scrollbar_alt_speed : @scrollbar_speed
    end

    flag def in_window! value = true
      return if (c = in_window) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      @in_window = value
      true
    end, def in_window
      get_in_window
    end

    # :section: LEVEL 2

    private

    def is_button_down index
      Pastele.mouse_get_button_state(index) != 0
    end

    def get_cursor_position
      point = Pastele::Point.malloc(Fiddle::RUBY_FREE)
      Pastele.mouse_get_cursor_position point
      [point.x, point.y]
    end

    def set_relative relative
      @relative = relative
      Pastele.mouse_set_relative_mode relative ? 1 : 0
    end

    def get_in_window
      @in_window.nil? ? get_cursor_position != [0, 0] : @in_window
    end
  end
end