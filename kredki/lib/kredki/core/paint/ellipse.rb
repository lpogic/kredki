require_relative 'shape_area'

module Kredki
  class Ellipse < ShapeArea
    extend HasParams
    
    def initialize
      super
      update
    end

    #internal api

    def redraw
      draw!(true, @w * 0.5, @h * 0.5).ellipse! @w - @stroke_size, @h - @stroke_size
    end

    def set_stroke_size ...
      super
      @redraw_flag = true
    end
  end
end