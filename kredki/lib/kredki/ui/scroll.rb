require_relative 'pad/sort_pad'
require_relative 'slide'

module Kredki
  module UI
    class Scroll < SortPad

      #internal api

      class Car
        struct :pad, :on_resize
      end

      def sketch p0
        super

        @car = nil
        @corner = new_pad(Pad).alter color: :light_gray, h: 10, w: 10
        @xslide = new_pad(XSlide).alter h: 10, x: 0, y: h - 10
        @yslide = new_pad(YSlide).alter w: 10, y: 0, x: w - 10

        @yslide.on_edit! do |e|
          if pad = p0.car&.pad
            off = p0.h - pad.h
            pad.y! (off * @yslide.value).round if off <= 0
          end
          e.resolve
        end

        @xslide.on_edit! do |e|
          if pad = p0.car&.pad
            off = p0.w - pad.w
            pad.x! (off * @xslide.value).round if off <= 0
          end
          e.resolve
        end

        on_resize!{ update_car }
        on_scroll! do |e|
          if p1 = p0.car&.pad
            jump = Kredki.mouse.scrollbar_speed keyboard.alt?
            xjump = 1.0 * p0.w / p1.w * jump
            yjump = 1.0 * p0.h / p1.h * jump
            xo, yo = if p0.w < p1.w && p0.h < p1.h
              keyboard.shift? ? [e.y, e.x] : e.xy
            elsif p0.w < p1.w
              keyboard.shift? ? [e.yorx, 0] : [e.xory, 0]
            elsif p0.h < p1.h
              keyboard.shift? ? [0, e.xory] : [0, e.yorx]
            else
              [0, 0]
            end
            e.resolve if (@xslide.value! @xslide.value - xo * xjump) | (@yslide.value! @yslide.value - yo * yjump)
          end
        end
      end

      attr :car

      def mouse_button_down e
      end

      def mouse_button_up e
      end

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

      def remove_pad pad, transfer
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
          else
            pad.x = 0
          end
          @yslide.x = @corner.x = w - 10

          
          @yslide.show = yscroll
          if yscroll
            @yslide.h = xscroll ? h - 10 : h
            @yslide.handle.h = (h.to_f / pad.h * h).clamp(20, [h - 20, 20].max)
          else
            pad.y = 0
          end
          @xslide.y = @corner.y = h - 10

          @corner.show = xscroll && yscroll
        else
          @xslide.hide!
          @yslide.hide!
        end
      end
    end
  end
end