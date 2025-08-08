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
      draw!.rectangle! @xs * 2 - @stroke_size, @ys * 2 - @stroke_size, @blunt.to_f
    end

    def set_stroke_size ...
      super
      @redraw_flag = true
    end
  end
end