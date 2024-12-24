require_relative 'color'
require_relative 'area'

module Kredki
  class Rectangle < Area

    def initialize
      super
      @rx = 0
      @ry = 0
      size! 100, 100
    end

    aliasing def rx! rx
      set_r rx, @ry
    end, :rx=, :radius_x!, :radius_x=

    aliasing def rx
      @rx
    end, :radius_x

    aliasing def ry! ry
      set_r @rx, ry
    end, :ry=, :radius_y!, :radius_y=

    aliasing def ry
      @ry
    end, :radius_y

    aliasing def r! r
      set_r r, r
    end, :r=, :radius!, :radius=

    aliasing def r
      [@rx, @ry].max
    end, :radius

    #internal api

    def repaint
      half_sw = @stroke_width * 0.5
      rectangle_at! half_sw, half_sw, @w - half_sw, @h - half_sw, @rx || 0, @ry || 0
    end

    def set_r rx, ry
      rx != @rx || ry != @ry and begin
        @rx = rx
        @ry = ry
        reset!
        true
      end
    end
  end
end