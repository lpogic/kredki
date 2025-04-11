require_relative 'shape_area'

module Kredki
  class Rectangle < ShapeArea

    def initialize
      super

      @blunt = 0
      update
    end

    param def blunt! blunt
      return if @blunt == blunt
      @blunt = blunt
      @redraw_flag = true
      update
    end

    def << param
      case param
      in [w, h]
        wh! w, h
      in Numeric
        wh! param
      else
        raise ArgumentError.new "#{param} #{param.class}"
      end
    end

    #internal api

    def redraw w, h
      half_sw = @stroke_width * 0.5
      draw!.rectangle! half_sw, half_sw, w - @stroke_width, h - @stroke_width, @blunt.to_f
    end

    def set_stroke_width ...
      super
      @redraw_flag = true
    end
  end
end