require_relative 'shape_area'

module Kredki
  class BlockShapeArea < ShapeArea

    # :section: LEVEL 2

    def initialize &block
      @block = block
      super()
    end

    def redraw
      crayon = draw! true, @w * 0.5, @h * 0.5
      crayon.autoupdate = false
      crayon.instance_exec @w, @h, &@block
      crayon.commit!
    end
  end
end