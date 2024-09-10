require_relative 'slide'

module Kredki
  class Margin < Pad

    class Car
      struct :pad, :on_resize
    end

    def sketch p0
      super

      @car = nil
      @t = @b = @l = @r = 0
      alter color: :transparent, w: @t + @b, h: @l + @r
    end

    aliasing def t! m
      @t != m && begin 
        @t = m
        update_car
        true
      end
    end, :t=, :top!, :top=

    aliasing def t
      @t
    end, :top

    aliasing def b! m
      @b != m && begin 
        @b = m
        updabe_car
        true
      end
    end, :b=, :bottom!, :bottom=

    aliasing def b
      @b
    end, :botttom

    aliasing def l! m
      @l != m && begin 
        @l = m
        update_car
        true
      end
    end, :l=, :left!, :left=

    aliasing def l
      @l
    end, :left

    aliasing def r! m
      @r != m && begin 
        @r = m
        update_car
        true
      end
    end, :r=, :right!, :right=

    aliasing def r
      @r
    end, :right

    aliasing def tb! m
      (@t != m || @b != m) && begin
        @t = @b = m
        update_car
        true
      end
    end, :tb=

    aliasing def lr! m
      (@l != m || @r != m) && begin
        @l = @r = m
        update_car
        true
      end
    end, :lr=

    aliasing def tblr! m
      (@t != m || @b != m || @l != m || @r != m) && begin
        @t = @b = @l = @r = m
        update_car
        true
      end
    end, :tblr=

    def push_pad pad, next_pad = nil
      if sketched? && @car
        @car.pad.detach!
      end
      super pad, next_pad, false
      if sketched?
        @car = Car.new pad, pad.on_resize!{ update_car }
        update_car
      end
      pad
    end

    def remove_pad pad
      if pad == @car&.pad
        @car.on_resize.detach!
        @car = nil
      end
      super
      update_car
    end

    def update_car
      pad = @car&.pad
      w = @l + @r
      h = @t + @b
      if pad
        pad.x = @l
        pad.y = @t
        w += pad.w
        h += pad.h
      end
      event PadResizeEvent.new if w!(w) | h!(h)
    end

  end
end