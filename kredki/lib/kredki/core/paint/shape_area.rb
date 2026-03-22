require_relative 'shape'
require_relative 'area'

module Kredki
  # Base class for Shape's with defined size.
  class ShapeArea < Shape
    include Area

    # Set a feature recognized by its class.
    def << feature
      case feature
      in [x, y]
        set_size x, y
      in Numeric
        set_size feature
      else
        super
      end
    end

    # Get features.
    def to_hash
      super.merge({
        size_x: @size_x,
        size_y: @size_y
      })
    end

    # :section: LEVEL 2

    def initialize
      @size_x = @size_y = 100
      @redraw_flag = true

      super
    end

    def pivot
      [@size_x * 0.5, @size_y * 0.5]
    end

    def update_stroke_width ...
      super
      @redraw_flag = true
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