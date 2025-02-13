require_relative 'color'
require_relative 'shape'

module Kredki
  class Area < Shape

    param def w! w
      @w != w and set_size w, @h
    end, :width

    param def h! h
      @h != h and set_size @w, h
    end, :height

    param def wh! w, h = nil
      h ||= w
      @w != w || @h != h and set_size w, h
    end, :size, get: def wh
      [@w, @h]
    end

    def contain? x, y
      x >= 0 && y >= 0 && x <= @w && y <= @h
    end

    #internal api

    def reset!
      super
      repaint if @w && @h
      update
    end

    def set_size w, h
      @w = w
      @h = h
      reset!
    end
  end
end