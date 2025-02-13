require_relative 'color'
require_relative 'area'

module Kredki
  class Rectangle < Area

    def initialize
      super
      size! 100, 100
    end

    param def blunt! blunt
      @blunt != blunt and set_blunt blunt
    end, get: def blunt
      @blunt || 0
    end

    def <<(arg)
      case arg
      in [w, h]
        wh! w, h
      in Numeric
        wh! arg
      else
        raise ArgumentError.new "#{arg} #{arg.class}"
      end
    end

    #internal api

    def repaint
      sw = stroke_width
      half_sw = sw * 0.5
      rectangle_at! half_sw, half_sw, @w - sw, @h - sw, blunt
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