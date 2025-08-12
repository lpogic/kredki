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

    #internal api

    def redraw
      draw!.xy!(@w * 0.5 , @h * 0.5).rectangle! @w - @stroke_size, @h - @stroke_size, @blunt.to_f
    end

    def set_stroke_size ...
      super
      @redraw_flag = true
    end
  end
end