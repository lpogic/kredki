require_relative 'shape_area'

module Kredki
  class BlockShapeArea < ShapeArea

    # :section: LEVEL 2

    def initialize block
      @block = block
      super()
    end

    def redraw
      drawer = draw! true, @w * 0.5, @h * 0.5
      drawer.autoupdate = false
      drawer.instance_exec @w, @h, &@block
      drawer.commit!
    end
  end
end