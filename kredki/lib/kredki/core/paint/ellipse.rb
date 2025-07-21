require_relative 'shape'

module Kredki
  class Ellipse < Shape
    extend HasParams

    def initialize
      super true

      @rx = @ry = 50
      @redraw_flag = true
      update
    end

    param def rx! rx
      return if @rx == rx
      @rx = rx
      @redraw_flag = true
      update
    end

    param def ry! ry
      return if @ry == ry
      @ry = ry
      @redraw_flag = true
      update
    end

    param def r! r
      return if @rx == r && @ry == r
      @rx = @ry = r
      @redraw_flag = true
      update
    end, def r
      @rx == @ry ? @rx : [@rx, @ry]
    end

    param def d! d
      r! d * 0.5
    end, def d 
      r * 2
    end

    def << param
      case param
      in [rx, ry]
        rx! rx
        ry! ry
      in Numeric
        r! param
      else
        super
      end
    end

    #internal api

    def update
      if @redraw_flag
        @redraw_flag = false
        redraw
        true
      else
        super
      end
    end

    def redraw
      hs = @stroke_size.to_f * 0.5
      rx = @rx.to_f
      ry = @ry.to_f
      draw!.ellipse! rx, ry, rx - hs, ry - hs
    end

    def set_stroke_size ...
      super
      @redraw_flag = true
    end
  end
end