require_relative 'shape_area'

module Kredki
  class Rectangle < ShapeArea

    def initialize
      @crbb = @crbe = @creb = @cree = 0
      super
      update
    end

    param def crbb! crbb = @crbb
      return crbb! yield @crbb if block_given?
      return if @crbb == crbb
      @crbb = crbb
      @redraw_flag = true
      update
    end

    param def crbe! crbe = @crbe
      return crbe! yield @crbe if block_given?
      return if @crbe == crbe
      @crbe = crbe
      @redraw_flag = true
      update
    end

    param def creb! creb = @creb
      return creb! yield @creb if block_given?
      return if @creb == creb
      @creb = creb
      @redraw_flag = true
      update
    end

    param def cree! cree = @cree
      return cree! yield @cree if block_given?
      return if @cree == cree
      @cree = cree
      @redraw_flag = true
      update
    end

    param def crxb! crbb = nil, crbe = nil
      return crxb! *Util.cover(yield self.crxb) if block_given?
      if crbb
        crbe ||= crbb
      else
        crbb ||= @crbb
        crbe ||= @crbe
      end
      return if @crbb == crbb && @crbe == crbe
      @crbb = crbb
      @crbe = crbe
      @redraw_flag = true
      update
    end, def crxb
      [@crbb, @crbe]
    end

    param def crxe! creb = nil, cree = nil
      return crxe! *Util.cover(yield self.crxe) if block_given?
      if creb
        cree ||= creb
      else
        creb ||= @creb
        cree ||= @cree
      end
      return if @creb == creb && @cree == cree
      @creb = creb
      @cree = cree
      @redraw_flag = true
      update
    end, def crxe
      [@creb, @cree]
    end

    param def cryb! crbb = nil, creb = nil
      return cryb! *Util.cover(yield self.cryb) if block_given?
      if crbb
        creb ||= crbb
      else
        crbb ||= @crbb
        creb ||= @creb
      end
      return if @crbb == crbb && @creb == creb
      @crbb = crbb
      @creb = creb
      @redraw_flag = true
      update
    end, def cryb
      [@crbb, @creb]
    end

    param def crye! crbe = nil, cree = nil
      return crye! *Util.cover(yield self.crye) if block_given?
      if crbe
        cree ||= crbe
      else
        crbe ||= @crbe
        cree ||= @cree
      end
      return if @crbe == crbe && @cree == cree
      @crbe = crbe
      @cree = cree
      @redraw_flag = true
      update
    end, def crye
      [@crbe, @cree]
    end
    
    param def cr! *cr
      return cr! *Util.cover(yield self.cr) if block_given?
      case cr.size
      when 0 then return
      when 1
        crbb = crbe = creb = cree = cr[0]
      when 2
        crbb = crbe = cr[0]
        creb = cree = cr[1]
      when 3
        crbb = cr[0]
        crbe = cr[1]
        creb = cree = cr[2]
      when 4
        crbb, crbe, creb, cree = *cr
      else
        raise_ia cr
      end
      return if @crbb == crbb && @creb == creb && @crbe == crbe && @cree == cree
      @crbb = crbb
      @creb = creb
      @crbe = crbe
      @cree = cree
      @redraw_flag = true
      update
    end, def cr
      [@crbb, @creb, @crbe, @cree]
    end

    #internal api

    def redraw
      draw!(true, @w * 0.5 , @h * 0.5).rectangle! @w - @out_w, @h - @out_w, @crbb, @creb, @crbe, @cree
    end

    def set_out_w ...
      super
      @redraw_flag = true
    end
  end
end