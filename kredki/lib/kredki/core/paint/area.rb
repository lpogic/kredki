module Kredki
  module Area
    extend HasParams

    param def w! s
      return if @w == s
      @w = s
      @redraw_flag = true
      update
    end

    param def h! s
      return if @h == s
      @h = s
      @redraw_flag = true
      update
    end

    param def wh! w, h = w
      return if @w == w && @h == h
      @w = w
      @h = h
      @redraw_flag = true
      update
    end, def wh
      [@w, @h]
    end

    def contain? x, y
      x <= @w && y <= @h && x >= 0 && y >= 0
    end
  end
end