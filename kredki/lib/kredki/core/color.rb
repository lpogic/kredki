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

    def lighten level = 10
      Color.new *to_rgb_array.map{ (_1 + level).clamp(0, 255) }, @a
    end

    def darken level = 10
      Color.new *to_rgb_array.map{ (_1 - level).clamp(0, 255) }, @a
    end

    def clarify a = 255
      Color.new *to_rgb_array, a
    end

    def tune r = 0, g = 0, b = 0
      Color.new (@r + r).clamp(0, 255), (@g + g).clamp(0, 255), (@b + b).clamp(0, 255), @a
    end
  end
end
