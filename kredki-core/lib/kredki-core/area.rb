require_relative 'color'
require_relative 'shape'

module Kredki
  class Area < Shape

    def initialize
      super true

      @w = 100
      @h = 100
      @redraw_flag = true
    end

    param def w! w
      return if @w == w
      @w = w
      @redraw_flag = true
      update
    end, :width

    param def h! h
      return if @h == h
      @h = h
      @redraw_flag = true
      update
    end, :height

    param def wh! w, h = nil
      h ||= w
      return if @w == w && @h == h
      @w = w
      @h = h
      @redraw_flag = true
      update
    end, :size, get: def wh
      [@w, @h]
    end

    def contain? x, y
      x >= 0 && y >= 0 && x <= @w && y <= @h
    end
  end
end