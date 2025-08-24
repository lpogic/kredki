require_relative 'shape_area'

module Kredki
  class Rectangle < ShapeArea

    def initialize
      @rbb = @reb = @rbe = @ree = 0
      super
      update
    end

    param def rbb! r
      return if @rbb == r
      @rbb = r
      @redraw_flag = true
      update
    end

    param def reb! r
      return if @reb == r
      @reb = r
      @redraw_flag = true
      update
    end

    param def rbe! r
      return if @rbe == r
      @rbe = r
      @redraw_flag = true
      update
    end

    param def ree! r
      return if @ree == r
      @ree = r
      @redraw_flag = true
      update
    end

    param def rxb! rbb, rbe = rbb
      return if @rbb == rbb && @rbe == rbe
      @rbb = rbb
      @rbe = rbe
      @redraw_flag = true
      update
    end, def rxb
      [@rbb, @rbe]
    end

    param def rxe! reb, ree = reb
      return if @reb == reb && @ree == ree
      @reb = reb
      @ree = ree
      @redraw_flag = true
      update
    end, def rxe
      [@reb, @ree]
    end

    param def ryb! rbb, reb = rbb
      return if @rbb == rbb && @reb == reb
      @rbb = rbb
      @reb = reb
      @redraw_flag = true
      update
    end, def ryb
      [@rbb, @reb]
    end

    param def rye! rbe, ree = rbe
      return if @rbe == rbe && @ree == ree
      @rbe = rbe
      @ree = ree
      @redraw_flag = true
      update
    end, def rye
      [@rbe, @ree]
    end
    
    param def r! rbb, reb = rbb, rbe = rbb, ree = rbb
      return if @rbb == rbb && @reb == reb && @rbe == rbe && @ree == ree
      @rbb = rbb
      @reb = reb
      @rbe = rbe
      @ree = ree
      @redraw_flag = true
      update
    end, def r
      [@rbb, @reb, @rbe, @ree]
    end

    #internal api

    def redraw
      draw!(true, @w * 0.5 , @h * 0.5).rectangle! @w - @stroke_size, @h - @stroke_size, @rbb, @reb, @rbe, @ree
    end

    def set_stroke_size ...
      super
      @redraw_flag = true
    end
  end
end