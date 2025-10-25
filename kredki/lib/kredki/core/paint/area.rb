module Kredki
  module Area
    extend HasParams

    param def w! s = @w
      return w! yield @w if block_given?
      return if @w == s
      @w = s
      @redraw_flag = true
      update
    end

    param def h! s
      return h! yield @h if block_given?
      return if @h == s
      @h = s
      @redraw_flag = true
      update
    end

    param def wh! w = nil, h = nil
      return wh! *Util.cover(yield self.wh) if block_given?
      if w
        h ||= w
      else
        w ||= @w
        h ||= @h
      end
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