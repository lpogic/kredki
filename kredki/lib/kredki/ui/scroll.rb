require_relative 'slide'

module Kredki
  module UI
    class Scroll < Pad

      class Car
        struct :pad, :on_resize
      end

      def sketch p0
        super

        @car = nil
        @corner = new_pad(Pad).alter color: :light_gray, h: 10, w: 10
        @xslide = new_pad(XSlide).alter h: 10, x: 0, y: h - 10
        @yslide = new_pad(YSlide).alter w: 10, y: 0, x: w - 10

        @yslide.on_edit! do
          pad = p0.car&.pad
          pad.y! ((p0.h - pad.h) * @yslide.value).round if pad
        end

        @xslide.on_edit! do
          pad = p0.car&.pad
          pad.x! ((p0.w - pad.w) * @xslide.value).round if pad
        end

        on_resize! do
          update_car
        end.call
        
        body.hide!
      end

      attr :car

      def push_pad pad, next_pad = nil
        if sketched?
          @car.pad.detach! if @car
          super pad, next_pad || @corner
          @car = Car.new pad, pad.on_resize!{ update_car }
          update_car
          pad
        else
          super
        end
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
        if @car
          pad = @car.pad
          pad.xy! ((w - pad.w) * @xslide.value).round, ((h - pad.h) * @yslide.value).round
          xscroll = w < pad.w
          yscroll = h < pad.h
          
          @xslide.show = xscroll
          if xscroll
            @xslide.w = yscroll ? w - 10 : w
            @xslide.handle.w = (w.to_f / pad.w * w).clamp(20, [w - 20, 20].max)
            @yslide.x = @corner.x = w - 10
          else
            pad.x = 0
            @yslide.x = @corner.x = pad.w - 10
          end

          
          @yslide.show = yscroll
          if yscroll
            @yslide.h = xscroll ? h - 10 : h
            @yslide.handle.h = (h.to_f / pad.h * h).clamp(20, [h - 20, 20].max)
            @xslide.y = @corner.y = h - 10
          else
            pad.y = 0
            @xslide.y = @corner.y = pad.h - 10
          end

          @corner.show = xscroll && yscroll
        else
          @xslide.hide!
          @yslide.hide!
        end
      end
    end
  end
end