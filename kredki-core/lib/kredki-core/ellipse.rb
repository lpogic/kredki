require_relative 'color'
require_relative 'shape'

module Kredki
  class Ellipse < Shape

    def initialize
      super
      radius! 50
    end

    param def rx! rx
      @rx != rx and set_r rx, @ry
    end, :radius_x

    param def ry! ry
      @ry != ry and set_r @rx, ry
    end, :radius_y

    param def r! r
      @rx != r || @ry != r and set_r r, r
    end, :radius, get: def r
      [@rx, @ry].max
    end

    param def d! d
      r! d * 0.5
    end, :diameter, get: def d 
      r * 2
    end

    def <<(arg)
      case arg
      in [rx, ry]
        rx! rx
        ry! ry
      in Numeric
        r! arg
      else
        raise ArgumentError.new "#{arg} #{arg.class}"
      end
    end

    #internal api

    private

    def reset!
      super
      half_sw = stroke_width * 0.5
      ellipse_at! @rx, @ry, @rx - half_sw, @ry - half_sw if @rx && @ry
      update
    end

    def set_r rx, ry
      @rx = rx
      @ry = ry
      reset!
    end
    
    def set_stroke_width ...
      super
      reset!
    end
  end
end