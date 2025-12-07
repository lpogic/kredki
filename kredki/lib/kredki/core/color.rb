module Kredki
  # Immutable color model
  class Color

    # Get red channel value.
    def r
      @r
    end

    # Get green channel value.
    def g
      @g
    end

    # Get blue channel value.
    def b
      @b
    end

    # Get alpha channel value.
    def a
      @a
    end

    # Get color copy with RGB channels saturation increased by a +level+.
    def lighten level = 10
      Color.new *to_a(:rgb).map{ (_1 + level).clamp(0, 255) }, @a
    end

    # Get color copy with RGB channels saturation decreased by a +level+.
    def darken level = 10
      Color.new *to_a(:rgb).map{ (_1 - level).clamp(0, 255) }, @a
    end

    # Get color copy with changed Alpha channel saturation.
    def clarify a = 255
      a = (255 * a).to_i if a.is_a? Rational
      Color.new *to_a(:rgb), a
    end

    # Get color copy with tuned RGB channels saturation.
    def tune r = 0, g = 0, b = 0
      Color.new (@r + r).clamp(0, 255), (@g + g).clamp(0, 255), (@b + b).clamp(0, 255), @a
    end

    # :section: LEVEL 2

    def initialize r, g, b, a = 255
      @r = r
      @g = g
      @b = b
      @a = a
    end

    def self.parse *a
      case a = Util.uncover(a)
      when String
        a = a[1..] if a.start_with? "#"
        alpha = a.length > 6 ? a[6...8].to_i(16) : 255
        Color.new a[0...2].to_i(16), a[2...4].to_i(16), a[4...6].to_i(16), alpha
      when Array
        Color.new *a
      else raise_ia a
      end
    end

    def to_a mode = :rgba
      case mode
      when :rgb
        [@r, @g, @b]
      else
        [@r, @g, @b, @a]
      end
    end

    alias_method :to_ary, :to_a

    def ==(other)
      Color === other &&
      r == other.r && 
      g == other.g && 
      b == other.b && 
      a == other.a
    end

  end
end
