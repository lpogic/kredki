require_relative 'pad/sort_pad'
require_relative 'slide'

module Kredki
  module UI
    class ScrollPad < SortPad

      #internal api

      def sketch p0
        super
        
        @corner = new_pad(Pad).alter color: :light_gray, h: 10, w: 10
        @xslide = new_pad(HorizontalSlide).alter h: 10, x: 0, y: h - 10
        @yslide = new_pad(VerticalSlide).alter w: 10, y: 0, x: w - 10

        @yslide.on_edit! do |e|
          if pad = p0.pad
            off = @yslide.h - pad.h
            pad.y! (off * @yslide.value).round if off <= 0
          end
          e.resolve
        end

        @xslide.on_edit! do |e|
          if pad = p0.pad
            off = @xslide.w - pad.w
            pad.x! (off * @xslide.value).round if off <= 0
          end
          e.resolve
        end

        on_resize! do |e|
          update_pad
          e.resolve unless e.target == self
        end

        on_scroll! do |e|
          if p1 = p0.pad
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

        on! ROIEvent do |e|
          if (l = e.x) < 0
            @xslide.value! 1.0 * (l - pad.x) / (pad.w - @xslide.w)
          elsif (r = e.w + e.x) > w
            @xslide.value! 1.0 * (r - @xslide.w - pad.x) / (pad.w - @xslide.w)
          end

          if (t = e.y) < 0
            @yslide.value! 1.0 * (t - pad.y) / (pad.h - @yslide.h)
          elsif (b = e.h + e.y) > h
            @yslide.value! 1.0 * (b - @yslide.h - pad.y) / (pad.h - @yslide.h)
          end
        end
      end
      
      def pad
        @pads.first
      end

      def mouse_button_down e
      end

      def mouse_button_up e
      end

      def push_pad pad, index = nil
        if sketched?
          pad&.detach! true
          super pad, index || -4
          update_pad
          pad
        else
          super
        end
      end

      def remove_pad pad, transfer
        super
        update_pad unless transfer
        pad
      end

      def update_pad
        if pad = self.pad
          xscroll = w < pad.w
          yscroll = h < pad.h
          
          @xslide.show = xscroll
          if xscroll
            @xslide.w = yscroll ? w - 10 : w
            @xslide.handle.w = (w.to_f / pad.w * w).clamp(20, [w - 20, 20].max)
            pad_x = ((@xslide.w - pad.w) * @xslide.value).round
          else
            pad_x = 0
          end
          @yslide.x = @corner.x = w - 10

          
          @yslide.show = yscroll
          if yscroll
            @yslide.h = xscroll ? h - 10 : h
            @yslide.handle.h = (h.to_f / pad.h * h).clamp(20, [h - 20, 20].max)
            pad_y = ((@yslide.h - pad.h) * @yslide.value).round
          else
            pad_y = 0
          end
          @xslide.y = @corner.y = h - 10

          pad.xy! pad_x, pad_y
          @corner.show = xscroll && yscroll
        else
          @xslide.hide!
          @yslide.hide!
          @corner.hide!
        end
      end
    end
  end
end