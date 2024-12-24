require_relative 'color'
require_relative 'area'

module Kredki
  class Rectangle < Area

    def initialize
      super
      @blunt = 0
      size! 100, 100
    end

    aliasing def blunt! blunt
      @blunt != blunt and set_blunt blunt
    end, :blunt=

    aliasing def blunt
      @blunt
    end

    def <<(arg)
      case arg
      in [x, y, w, h]
        xy! x, y
        wh! w, h
      else
        raise ArgumentError.new "#{arg} #{arg.class}"
      end
    end

    #internal api

    def repaint
      half_sw = @stroke_width * 0.5
      rectangle_at! half_sw, half_sw, @w - @stroke_width, @h - @stroke_width, @blunt || 0
    end

    def set_blunt blunt
      @blunt = blunt
      reset!
    end

    def set_stroke_width ...
      super
      reset!
    end
  end
end