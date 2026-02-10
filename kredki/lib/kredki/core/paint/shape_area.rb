require_relative 'shape'
require_relative 'area'

module Kredki
  # Base class for Shape's with defined width and height.
  class ShapeArea < Shape
    include Area

    # Set outline width.
    def outline_w! outline_w = @outline_w
      return outline_w! yield @outline_w if block_given?
      return if @outline_w == outline_w
      Pastele.shape_set_stroke_width @pointer, outline_w.to_f
      @outline_w = outline_w
      @redraw_flag = true
      update
    end

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
      super.merge({
        w: @w,
        h: @h
      })
    end

    # :section: LEVEL 2

    def initialize
      @w = @h = 100
      @redraw_flag = true

      super
    end

    def pivot_xy
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