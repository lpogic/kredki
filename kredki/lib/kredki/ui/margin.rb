module Kredki
  module UI
    class Margin < Pad

      class Car
        struct :pad, :on_resize
      end

      def sketch p0
        super

        @car = nil
        @t = @b = @l = @r = 0
        body.hide!
        alter w: 0, h: 0
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
          update_car
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

      aliasing def w! m
        (@l != m || @r != m) && begin
          @l = @r = m
          update_car
          true
        end
      end, :w=

      aliasing def h! m
        (@t != m || @b != m) && begin
          @t = @b = m
          update_car
          true
        end
      end, :h=

      aliasing def wh! m
        (@t != m || @b != m || @l != m || @r != m) && begin
          @t = @b = @l = @r = m
          update_car
          true
        end
      end, :wh=

      #internal api

      def push_pad pad, next_pad = nil
        @car.pad.detach! if @car
        super pad, next_pad, false
        @car = Car.new pad, pad.on_resize!{ update_car }
        update_car
        pad
      end

      def remove_pad pad, transfer
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
        set_size w, h
      end

      def autosized?
        true
      end

    end
  end
end