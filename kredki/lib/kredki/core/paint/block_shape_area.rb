require_relative 'shape_area'

module Kredki
  class BlockShapeArea < ShapeArea

    def initialize block
      @block = block
      super()
    end

    def redraw
      drawer = draw!
      drawer.autoupdate = false
      drawer.instance_exec @xs, @ys, &@block
      drawer.commit!
    end
  end
end