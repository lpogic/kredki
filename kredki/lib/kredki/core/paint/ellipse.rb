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
      draw!.ellipse! @xs * 2 - @stroke_size, @ys * 2 - @stroke_size
    end

    def set_stroke_size ...
      super
      @redraw_flag = true
    end
  end
end