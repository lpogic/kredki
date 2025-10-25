require_relative 'shape_area'

module Kredki
  class Rectangle < ShapeArea

    def initialize
      @rbb = @rbe = @reb = @ree = 0
      super
      update
    end

    param def rbb! r = @rbb
      return rbb! yield @rbb if block_given?
      return if @rbb == r
      @rbb = r
      @redraw_flag = true
      update
    end

    param def rbe! r = @rbe
      return rbe! yield @rbe if block_given?
      return if @rbe == r
      @rbe = r
      @redraw_flag = true
      update
    end

    param def reb! r = @reb
      return reb! yield @reb if block_given?
      return if @reb == r
      @reb = r
      @redraw_flag = true
      update
    end

    param def ree! r = @ree
      return ree! yield @ree if block_given?
      return if @ree == r
      @ree = r
      @redraw_flag = true
      update
    end

    param def rxb! rbb = nil, rbe = nil
      return rxb! *Util.cover(yield self.rxb) if block_given?
      if rbb
        rbe ||= rbb
      else
        rbb ||= @rbb
        rbe ||= @rbe
      end
      return if @rbb == rbb && @rbe == rbe
      @rbb = rbb
      @rbe = rbe
      @redraw_flag = true
      update
    end, def rxb
      [@rbb, @rbe]
    end

    param def rxe! reb = nil, ree = nil
      return rxe! *Util.cover(yield self.rxe) if block_given?
      if reb
        ree ||= reb
      else
        reb ||= @reb
        ree ||= @ree
      end
      return if @reb == reb && @ree == ree
      @reb = reb
      @ree = ree
      @redraw_flag = true
      update
    end, def rxe
      [@reb, @ree]
    end

    param def ryb! rbb = nil, reb = nil
      return ryb! *Util.cover(yield self.ryb) if block_given?
      if rbb
        reb ||= rbb
      else
        rbb ||= @rbb
        reb ||= @reb
      end
      return if @rbb == rbb && @reb == reb
      @rbb = rbb
      @reb = reb
      @redraw_flag = true
      update
    end, def ryb
      [@rbb, @reb]
    end

    param def rye! rbe = nil, ree = nil
      return rye! *Util.cover(yield self.rye) if block_given?
      if rbe
        ree ||= rbe
      else
        rbe ||= @rbe
        ree ||= @ree
      end
      return if @rbe == rbe && @ree == ree
      @rbe = rbe
      @ree = ree
      @redraw_flag = true
      update
    end, def rye
      [@rbe, @ree]
    end
    
    param def r! *r
      return r! *Util.cover(yield self.r) if block_given?
      case r.size
      when 0 then return
      when 1
        rbb = rbe = reb = ree = r[0]
      when 2
        rbb = rbe = r[0]
        reb = ree = r[1]
      when 3
        rbb = r[0]
        rbe = r[1]
        reb = ree = r[2]
      when 4
        rbb, rbe, reb, ree = *r
      else
        raise_ia r
      end
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