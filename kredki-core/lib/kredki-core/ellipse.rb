require_relative 'color'
require_relative 'shape'

module Kredki
  class Ellipse < Shape

    def initialize
      super
      radius! 50
    end

    aliasing def rx! rx
      set_rx rx
    end, :rx=, :radius_x!, :radius_x=

    aliasing def rx
      @rx
    end, :radius_x

    aliasing def ry! ry
      set_ry ry
    end, :ry=, :radius_y!, :radius_y=

    aliasing def ry
      @ry
    end, :radius_y

    aliasing def r! r
      set_r r
    end, :r=, :radius!, :radius=

    aliasing def r
      @rx == @ry ? @rx : [@rx, @ry].max
    end, :radius

    aliasing def d! d
      set_r d / 2
    end, :d=, :diameter!, :diameter=
    
    aliasing def d 
      r * 2
    end, :diameter

    #internal api

    private

    def reset!
      super
      result = false
      if @rx && @ry
        ellipse_at! 0, 0, @rx, @ry
        result = true
      end
      update
      result
    end

    def set_rx rx
      rx != @rx && begin
        @rx = rx
        reset!
      end
    end

    def set_ry ry
      ry != @ry && begin
        @ry = ry
        reset!
      end
    end

    def set_r r
      (r != @rx || r != @ry) && begin
        @rx = @ry = r
        reset!
      end
    end
  end
end