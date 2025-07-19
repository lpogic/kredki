require_relative 'shape'
require_relative 'area'

module Kredki
  class ShapeArea < Shape
    include Area

    def initialize
      @w = 100
      @h = 100
      @redraw_flag = true

      super
    end

    def to_hash
      super + {
        w: @w,
        h: @h
      }
    end

    def update
      if @redraw_flag
        @redraw_flag = false
        redraw @w, @h
        true
      else
        super
      end
    end
  end
end