require_relative 'color'
require_relative 'shape'

module Kredki
  class Ellipse < Shape

    def initialize
      super
      radius! 50
    end

    aliasing def rx! rx
      @rx != rx and set_r rx, @ry
    end, :rx=, :radius_x!, :radius_x=

    aliasing def rx
      @rx
    end, :radius_x

    aliasing def ry! ry
      @ry != ry and set_r @rx, ry
    end, :ry=, :radius_y!, :radius_y=

    aliasing def ry
      @ry
    end, :radius_y

    aliasing def r! r
      @rx != r || @ry != r and set_r r, r
    end, :r=, :radius!, :radius=

    aliasing def r
      [@rx, @ry].max
    end, :radius

    aliasing def d! d
      r = d * 0.5
      set_r r, r
    end, :d=, :diameter!, :diameter=
    
    aliasing def d 
      r * 2
    end, :diameter

    def <<(arg)
      case arg
      in [x, y, r]
        xy! x, y
        r! r
      else
        raise ArgumentError.new "#{arg} #{arg.class}"
      end
    end

    #internal api

    private

    def reset!
      super
      half_sw = @stroke_width * 0.5
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