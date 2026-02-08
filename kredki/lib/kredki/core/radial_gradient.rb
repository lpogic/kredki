module Kredki
  class RadialGradient

    def initialize colors, cx, cy, r, fx = cx, fy = cy, fr = 0, offsets: nil, spread: nil
      @fx = fx
      @fy = fy
      @fr = fr
      @cx = cx
      @cy = cy
      @r = r
      @colors = colors
      @offsets = offsets
      @spread = spread
    end

    def self.[](...)
      self.new(...)
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
        @cx, @cy, @r, @fx, @fy, @fr,
        Fiddle::Pointer[rgbas.pack "C*"],
        Fiddle::Pointer[offsets.pack "f*"],
        @colors.size,
        spread
      ]
    end

  end#RadialGradient
end#Kredki
