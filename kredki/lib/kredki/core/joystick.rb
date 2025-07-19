module Kredki
  class Joystick
    @@next_name = :joystick_1

    model :name, :buttons, :axes, keywords: true do
      @buttons ||= {}
      @inverted_buttons = @buttons.invert
      @axes ||= {}
      @inverted_axes = @axes.invert
      if @name.nil?
        @name = @@next_name
        @@next_name = @@next_name.next
      end
      @device_id = nil
    end

    def button param
      case param
      when Button
        param
      when Symbol
        Button.new @buttons[param] || (raise "Unknown joystick button symbol :#{param}"), param
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

    def axis param
      case param
      when Axis
        param
      when Symbol
        Axis.new self, @axes[param] || (raise "Unknown joystick axis symbol :#{param}"), param
      when Integer
        Axis.new self, param, @inverted_axes[param]
      end
    end

    class Axis
      model :index, :symbol
  
      def to_i
        @index
      end
  
      def to_sym
        @symbol
      end
  
      def ==(other)
        Axis === other &&
        index == other.index &&
        symbol == other.symbol
      end
    end

    def down? key
      return nil if !opened?
      is_button_down button(key).to_i
    end

    def value key
      return nil if !opened?
      get_axis_value axis(key).to_i
    end

    def opened?
      !!@device_id
    end

    #internal api

    def match device_index
      0
    end

    attr_accessor :device_id

    def is_button_down index
      Abi.joystick_get_button_state(@device_id, index) != 0
    end

    def get_axis_value index
      Abi.joystick_get_axis_value(@device_id, index)
    end

    private
  end
end