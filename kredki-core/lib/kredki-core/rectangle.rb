require_relative 'color'
require_relative 'shape'

module Kredki
  class Rectangle < Shape

    def initialize
      super
      @rx = 0
      @ry = 0
      size! 100, 100
    end

    aliasing def w! w
      set_w w
    end, :w=, :width!, :width=

    aliasing def w
      @w
    end, :width

    aliasing def h! h
      set_h h
    end, :h=, :height!, :height=

    aliasing def h
      @h
    end, :height

    aliasing def wh! w, h = nil
      set_size w, h || w
    end, :size!

    aliasing def wh=(wh)
      case wh
      when Array
        wh! *wh
      else
        wh! wh
      end
    end, :size=

    aliasing def wh
      [w, h]
    end, :size

    aliasing def rx! rx
      set_rx rx
    end, :rx=, :radius_x!, :radius_x=

    aliasing def rx
      @rx
    end, :radius_x

    aliasing def ry! ry
      set_ry ry
    end, :ry=, :radius_y!, :radius_y=

    aliasing def ry
      @ry
    end, :radius_y

    aliasing def r! r
      set_r r
    end, :r=, :radius!, :radius=

    aliasing def r
      [@rx, @ry].max
    end, :radius

    private

    def reset!
      super
      if @w && @h
        rectangle_at! 0, 0, @w, @h, @rx || 0, @ry || 0
      end
      update
    end

    def set_w w
      w != @w && begin
        @w = w
        reset!
        true
      end
    end

    def set_h h
      h != @h && begin
        @h = h
        reset!
        true
      end
    end

    def set_size w, h
      (w != @w || h != @h) && begin
        @w = w
        @h = h
        reset!
        true
      end
    end

    def set_rx rx
      rx != @rx && begin
        @rx = rx
        reset!
        true
      end
    end

    def set_ry ry
      ry != @ry && begin
        @ry = ry
        reset!
        true
      end
    end

    def set_r r
      (r != @rx || r != @ry) && begin
        @rx = @ry = r
        reset!
        true
      end
    end
  end
end