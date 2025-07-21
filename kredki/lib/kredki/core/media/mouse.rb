module Kredki
  class Mouse
    extend HasFlags

    model :buttons, :scrollbar_speed, :scrollbar_alt_speed, keywords: true do
      @inverted_buttons = @buttons.reverse_each.map{ [_2, _1] }.to_h
    end

    def button param
      case param
      when Button
        param
      when Symbol
        Button.new @buttons[param] || (raise "Unknown mouse button symbol :#{param}"), param
      when Integer
        Button.new param, @inverted_buttons[param]
      end
    end

    class Button
      model :index, :symbol
  
      def to_i
        @index
      end
  
      def to_sym
        @symbol
      end
  
      def ==(other)
        Button === other &&
        index == other.index &&
        symbol == other.symbol
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

    flag :relative, set: :set_relative

    def scrollbar_speed alt = false
      alt ? @scrollbar_alt_speed : @scrollbar_speed
    end

    flag :in_window, get: :get_in_window

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