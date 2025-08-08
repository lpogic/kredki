module Kredki
  module Area
    extend HasParams

    param def xs! s
      return if @xs == s
      @xs = s
      @redraw_flag = true
      update
    end

    param def ys! s
      return if @ys == s
      @ys = s
      @redraw_flag = true
      update
    end

    param def w! w
      xs! w * 0.5
    end, def w
      @xs * 2
    end

    param def h! h
      ys! h * 0.5
    end, def h
      @ys * 2
    end

    param def wh! w, h = w
      w *= 0.5
      h *= 0.5
      return if @xs == w && @ys == h
      @xs = w
      @ys = h
      @redraw_flag = true
      update
    end, def wh
      [@xs * 2, @ys * 2]
    end

    def contain? x, y
      x.abs <= @xs && y.abs <= @ys
    end
  end
end