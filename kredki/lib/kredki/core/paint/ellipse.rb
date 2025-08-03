require_relative 'shape_area'

module Kredki
  class Ellipse < ShapeArea
    extend HasParams
    
    def initialize
      super

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
      draw!.ellipse! w - @stroke_size, h - @stroke_size
    end

    def set_stroke_size ...
      super
      @redraw_flag = true
    end
  end
end