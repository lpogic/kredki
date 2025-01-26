require_relative 'color'
require_relative 'shape'

module Kredki
  class Area < Shape

    aliasing def w! w
      @w != w and set_size w, @h
    end, :w=, :width!, :width=

    aliasing def w
      @w
    end, :width

    aliasing def h! h
      @h != h and set_size @w, h
    end, :h=, :height!, :height=

    aliasing def h
      @h
    end, :height

    aliasing def wh! w, h = nil
      h ||= w
      @w != w || @h != h and set_size w, h
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
      [@w, @h]
    end, :size

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