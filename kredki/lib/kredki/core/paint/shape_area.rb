require_relative 'shape'
require_relative 'area'

module Kredki
  # Base class for Shape's with defined width and height.
  class ShapeArea < Shape
    include Area

    # Push the feature.
    def << feature
      case feature
      in [w, h]
        wh! w, h
      in Numeric
        wh! feature
      else
        super
      end
    end

    # Get features.
    def to_hash
      super + {
        w: @w,
        h: @h
      }
    end

    # :section: LEVEL 2

    def initialize
      @w = @h = 100
      @redraw_flag = true

      super
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