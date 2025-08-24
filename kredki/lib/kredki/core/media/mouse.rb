module Kredki
  class Mouse
    include Alterable
    extend HasParams

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

    param def scrollbar_speed! speed
      @scrollbar_speed = speed
    end

    param def scrollbar_alt_speed! speed
      @scrollbar_alt_speed = speed
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

    flag def relative! s = true
      c, n = relative? s
      return if c == n
      set_relative n
      @relative = n
      true
    end

    def scrollbar_speed alt = false
      alt ? @scrollbar_alt_speed : @scrollbar_speed
    end

    flag def in_window! s = true
      c, n = in_window? s
      return if c == n
      @in_window = n
      true
    end, def in_window
      get_in_window
    end

    #internal api

    private

    def is_button_down index
      Abi.mouse_get_button_state(index) != 0
    end

    def get_cursor_position
      point = Abi::Point.malloc(Fiddle::RUBY_FREE)
      Abi.mouse_get_cursor_position point
      [point.x, point.y]
    end

    def set_relative relative
      @relative = relative
      Abi.mouse_set_relative_mode relative ? 1 : 0
    end

    def get_in_window
      @in_window.nil? ? get_cursor_position != [0, 0] : @in_window
    end
  end
end