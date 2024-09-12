module Kredki
  class Color
    model :r, :g, :b, :a do
      @a ||= 255
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

    def light level = 10
      Color.new @r + level, @g + level, @b + level, @a
    end
  end
end
