require_relative 'pad/sort_pad'
require_relative 'slide'

module Kredki
  module UI
    class ScrollPad < SortPad
      class ScrollPadLayout < Layout
        def fit_w pad
          super + 10
        end
  
        def fit_h pad
          super + 10
        end
      end

      #internal api

      def sketch p0
        super
        
        layout! ScrollPadLayout
        # @corner existence is checked in push_pad
        corner = new_pad Pad, color: :light_gray, h: 10, w: 10, xy: 100r
        @xslide = new_pad HorizontalSlide, h: 10, x: 0, y: 100r
        @yslide = new_pad VerticalSlide, w: 10, y: 0, x: 100r
        @corner = corner

        @yslide.on_edit! do |e|
          if pad = p0.pad
            off = @yslide.sh - pad.sh
            pad.y! (off * @yslide.value).round if off <= 0
          end
          e.resolve
        end

        @xslide.on_edit! do |e|
          if pad = p0.pad
            off = @xslide.sw - pad.sw
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
            xjump = 1.0 * p0.sw / p1.sw * jump
            yjump = 1.0 * p0.sh / p1.sh * jump
            xo, yo = if p0.sw < p1.sw && p0.sh < p1.sh
              keyboard.shift? ? [e.y, e.x] : e.xy
            elsif p0.sw < p1.sw
              keyboard.shift? ? [e.yorx, 0] : [e.xory, 0]
            elsif p0.sh < p1.sh
              keyboard.shift? ? [0, e.xory] : [0, e.yorx]
            else
              [0, 0]
            end
            e.resolve if (@xslide.value! @xslide.value - xo * xjump) | (@yslide.value! @yslide.value - yo * yjump)
          end
        end

        on! ROIEvent do |e|
          if (l = e.x) < 0
            @xslide.value! 1.0 * (l - pad.sx) / (pad.sw - @xslide.sw)
          elsif (r = e.w + e.x) > w
            @xslide.value! 1.0 * (r - @xslide.sw - pad.sx) / (pad.sw - @xslide.sw)
          end

          if (t = e.y) < 0
            @yslide.value! 1.0 * (t - pad.sy) / (pad.sh - @yslide.sh)
          elsif (b = e.h + e.y) > h
            @yslide.value! 1.0 * (b - @yslide.sh - pad.sy) / (pad.sh - @yslide.sh)
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

      def push_pad pad, at = nil
        if @corner
          pad&.detach! true
          super pad, at || @corner
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
          w = sw
          h = sh
          xscroll = w < pad.sw
          yscroll = h < pad.sh
          
          @xslide.show = xscroll
          if xscroll
            @xslide.w = yscroll ? w - 10 : w
            @xslide.handle.w = (w.to_f / pad.sw * w).clamp(20, [w - 20, 20].max)
            pad_x = ((@xslide.w - pad.sw) * @xslide.value).round
          else
            pad_x = 0
          end

          
          @yslide.show = yscroll
          if yscroll
            @yslide.h = xscroll ? h - 10 : h
            @yslide.handle.h = (h.to_f / pad.sh * h).clamp(20, [h - 20, 20].max)
            pad_y = ((@yslide.h - pad.sh) * @yslide.value).round
          else
            pad_y = 0
          end

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