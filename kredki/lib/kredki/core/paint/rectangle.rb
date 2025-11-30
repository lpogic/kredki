require_relative 'shape_area'

module Kredki
  class Rectangle < ShapeArea

    # Set X tail Y tail corner radius.
    def crtt! crtt = @crtt
      return crtt! yield @crtt if block_given?
      return if @crtt == crtt
      @crtt = crtt
      @redraw_flag = true
      update
    end

    # See #crtt!.
    def crtt= param
      Array === param ? (crtt! *param) : (crtt! param)
    end

    # Get X tail Y tail corner radius.
    def crtt
      @crtt
    end

    # Set X tail Y head corner radius.
    def crth! crth = @crth
      return crth! yield @crth if block_given?
      return if @crth == crth
      @crth = crth
      @redraw_flag = true
      update
    end

    # See #crth!.
    def crth= param
      Array === param ? (crth! *param) : (crth! param)
    end

    # Get X tail Y head corner radius.
    def crth
      @crth
    end

    # Set X head Y tail corner radius.
    def crht! crht = @crht
      return crht! yield @crht if block_given?
      return if @crht == crht
      @crht = crht
      @redraw_flag = true
      update
    end

    # See #crht!.
    def crht= param
      Array === param ? (crht! *param) : (crht! param)
    end

    # Get X head Y tail corner radius.
    def crht
      @crht
    end

    # Set X head Y head corner radius.
    def crhh! crhh = @crhh
      return crhh! yield @crhh if block_given?
      return if @crhh == crhh
      @crhh = crhh
      @redraw_flag = true
      update
    end

    # See #crhh!.
    def crhh= param
      Array === param ? (crhh! *param) : (crhh! param)
    end

    # Get X head Y head corner radius.
    def crhh
      @crhh
    end

    # Set X tail corners radius.
    def crxt! crtt = nil, crth = nil
      return crxt! *Util.cover(yield(self.crxt)) if block_given?
      if crtt
        crth ||= crtt
      else
        crtt ||= @crtt
        crth ||= @crth
      end
      return if @crtt == crtt && @crth == crth
      @crtt = crtt
      @crth = crth
      @redraw_flag = true
      update
    end

    # See #crxt!.
    def crxt= param
      Array === param ? (crxt! *param) : (crxt! param)
    end

    # Get X tail corners radius.
    def crxt
      [@crtt, @crth]
    end

    # Set X head corners radius.
    def crxh! crht = nil, crhh = nil
      return crxh! *Util.cover(yield(self.crxh)) if block_given?
      if crht
        crhh ||= crht
      else
        crht ||= @crht
        crhh ||= @crhh
      end
      return if @crht == crht && @crhh == crhh
      @crht = crht
      @crhh = crhh
      @redraw_flag = true
      update
    end

    # See #crxh!.
    def crxh= param
      Array === param ? (crxh! *param) : (crxh! param)
    end

    # Get X head corners radius.
    def crxh
      [@crht, @crhh]
    end


    # Set Y tail corners radius.
    def cryt! crtt = nil, crht = nil
      return cryt! *Util.cover(yield(self.cryt)) if block_given?
      if crtt
        crht ||= crtt
      else
        crtt ||= @crtt
        crht ||= @crht
      end
      return if @crtt == crtt && @crht == crht
      @crtt = crtt
      @crht = crht
      @redraw_flag = true
      update
    end
    
    # See #cryt!.
    def cryt= param
      Array === param ? (cryt! *param) : (cryt! param)
    end

    # Get Y tail corners radius.
    def cryt
      [@crtt, @crht]
    end

    # Set Y head corners radius.
    def cryh! crth = nil, crhh = nil
      return cryh! *Util.cover(yield(self.cryh)) if block_given?
      if crth
        crhh ||= crth
      else
        crth ||= @crth
        crhh ||= @crhh
      end
      return if @crth == crth && @crhh == crhh
      @crth = crth
      @crhh = crhh
      @redraw_flag = true
      update
    end
    
    # See #cryh!.
    def cryh= param
      Array === param ? (cryh! *param) : (cryh! param)
    end

    # Get Y head corners radius.
    def cryh
      [@crth, @crhh]
    end
    
    # Set corners radius.
    def cr! *cr
      return cr! *Util.cover(yield(self.cr)) if block_given?
      case cr.size
      when 0 then return
      when 1
        crtt = crth = crht = crhh = cr[0]
      when 2
        crtt = crth = cr[0]
        crht = crhh = cr[1]
      when 3
        crtt = cr[0]
        crth = cr[1]
        crht = crhh = cr[2]
      when 4
        crtt, crth, crht, crhh = *cr
      else
        raise_ia cr
      end
      return if @crtt == crtt && @crht == crht && @crth == crth && @crhh == crhh
      @crtt = crtt
      @crht = crht
      @crth = crth
      @crhh = crhh
      @redraw_flag = true
      update
    end

    # See #cr!.
    def cr= param
      Array === param ? (cr! *param) : (cr! param)
    end
    
    # Get corners radius.
    def cr
      [@crtt, @crht, @crth, @crhh]
    end

    # :section: LEVEL 2

    def initialize
      @crtt = @crth = @crht = @crhh = 0
      super
      update
    end

    def redraw
      draw!(true, @w * 0.5 , @h * 0.5).rectangle! @w - @outline_w, @h - @outline_w, @crtt, @crht, @crth, @crhh
    end

    def set_outline_w ...
      super
      @redraw_flag = true
    end
  end
end