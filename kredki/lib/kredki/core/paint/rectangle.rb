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
        super
      end
    end

    #internal api

    def redraw w, h
      draw!.rectangle! w - @stroke_size, h - @stroke_size, @blunt.to_f
    end

    def set_stroke_size ...
      super
      @redraw_flag = true
    end
  end
end