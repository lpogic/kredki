require_relative 'shape'
require_relative 'area'

module Kredki
  class ShapeArea < Shape
    include Area

    def initialize
      @w = @h = 100
      @redraw_flag = true

      super
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

    def to_hash
      super + {
        w: @w,
        h: @h
      }
    end

    def pxy
      [@w * 0.5, @h * 0.5]
    end

    def update
      if @redraw_flag
        @redraw_flag = false
        redraw
        true
      else
        super
      end
    end
  end
end