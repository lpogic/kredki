require_relative 'shape_area'

module Kredki
  class Ellipse < ShapeArea
    extend HasFeatures
    
    # :section: LEVEL 2

    def initialize
      super
      update
    end

    def redraw
      draw!(true, @w * 0.5, @h * 0.5).ellipse! @w - @outline_w, @h - @outline_w
    end

    def set_outline_w ...
      super
      @redraw_flag = true
    end
  end
end