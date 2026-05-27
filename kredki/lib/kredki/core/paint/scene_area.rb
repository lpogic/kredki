require_relative 'shape'
require_relative 'area'

module Kredki
  # Base class for Shape's with defined size.
  class SceneArea < Scene
    include Area
    
    def mixed_set feature
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

    def update
      if @redraw_flag
        @redraw_flag = false
        redraw
        true
      else
        super
      end
    end

    def draw &block
      @block = block
      @redraw_flag = true
      update
    end

    def redraw
      clear
      instance_exec @size_x, @size_y, &@block if @block
    end

  end
end