require_relative 'shape_area'

module Kredki
  class Ellipse < ShapeArea
    
    # :section: LEVEL 2

    def initialize
      super
      update
    end

    def redraw
      draw!(true, @size_x * 0.5, @size_y * 0.5).ellipse! @size_x - @outline_w, @size_y - @outline_w
    end

    def set_outline_w ...
      super
      @redraw_flag = true
    end
  end
end