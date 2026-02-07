module Kredki
  class LinearGradient

    def initialize colors, ex, ey = 0, x = 0, y = 0, offsets: nil, spread: nil
      @x = x
      @y = y
      @ex = ex
      @ey = ey
      @colors = colors
      @offsets = offsets
      @spread = spread
    end

    # :section: LEVEL 2

    def inspect
      "#{self.class}:#{object_id}"
    end

    def ffi
      rgbas = @colors.map{|color| Kredki.color(color).to_rgba }.flatten
      offsets = @offsets || (0...@colors.size).map{|it| it.to_f / (@colors.size - 1) }
      spread = case @spread
      when :pad, nil, 0 then 0
      when :reflect, 1 then 1
      when :repeat, 2 then 2
      else raise_is @spread
      end
      [
        @x, @y, @ex, @ey,
        Fiddle::Pointer[rgbas.pack "C*"],
        Fiddle::Pointer[offsets.pack "f*"],
        @colors.size,
        spread
      ]
    end

  end#LinearGradient
end#Kredki
