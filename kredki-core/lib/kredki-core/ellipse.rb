require_relative 'shape'

module Kredki
  class Ellipse < Shape

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
    end, :radius_x

    param def ry! ry
      return if @ry == ry
      @ry = ry
      @redraw_flag = true
      update
    end, :radius_y

    param def r! r
      return if @rx == r && @ry == r
      @rx = @ry = r
      @redraw_flag = true
      update
    end, :radius, get: def r
      [@rx, @ry].max
    end

    param def d! d
      r! d * 0.5
    end, :diameter, get: def d 
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
        raise ArgumentError.new "#{param} #{param.class}"
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
      half_sw = @stroke_width.to_f * 0.5
      rx = @rx.to_f
      ry = @ry.to_f
      draw!.ellipse! rx, ry, rx - half_sw, ry - half_sw
    end

    def set_stroke_width ...
      super
      @redraw_flag = true
    end
  end
end