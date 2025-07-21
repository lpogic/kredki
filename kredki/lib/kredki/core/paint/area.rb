module Kredki
  module Area
    extend HasParams

    param def w! w
      return if @w == w
      @w = w
      @redraw_flag = true
      update
    end

    param def h! h
      return if @h == h
      @h = h
      @redraw_flag = true
      update
    end

    param def wh! w, h = nil
      h ||= w
      return if @w == w && @h == h
      @w = w
      @h = h
      @redraw_flag = true
      update
    end, def wh
      [@w, @h]
    end

    def contain? x, y
      x >= 0 && y >= 0 && x <= @w && y <= @h
    end
  end
end