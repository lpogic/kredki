module Kredki
  class Color
    model :r, :g, :b, :a do
      @a ||= 255
    end

    NAMED_COLORS = {
      red: Color.new(222, 0, 0, 255),
      green: Color.new(0, 222, 0, 255),
      blue: Color.new(0, 0, 222, 255),
      light_gray: Color.new(211, 211, 211, 255),
      gray: Color.new(111, 111, 111, 255),
      white: Color.new(255, 255, 255, 255),
      black: Color.new(0, 0, 0, 255),
      yellow: Color.new(222, 222, 0, 255),
    }

    def self.[](param)
      case param
      when Color
        param
      when :rand
        Color.new rand(255), rand(255), rand(255)
      when Symbol
        NAMED_COLORS[param]
      when Array
        Color.new *param
      end
    end

    def to_rgba_array
      [@r, @g, @b, @a]
    end

    def to_rgb_array
      [@r, @g, @b]
    end

    alias_method :to_array, :to_rgba_array

    def ==(other)
      Color === other &&
      r == other.r && 
      g == other.g && 
      b == other.b && 
      a == other.a
    end
  end
end
