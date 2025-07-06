require_relative 'pad/sort_pad'
require_relative 'slide'
require_relative 'layout/basic'

module Kredki
  module UI
    class ScrollPad < SortPad

      #internal api

      def sketch p0
        super
        
        # @corner existence is checked in put_pad
        corner = new Pad, in_layout: false, color: :gray, h: 10, w: 10, xy: 100r
        @xslide = new HorizontalSlide, in_layout: false, h: 10, x: 0, y: 100r
        @yslide = new VerticalSlide, in_layout: false, w: 10, y: 0, x: 100r
        @corner = corner

        @yslide.on_edit! do |e|
          layer&.break_layout
          e.resolve
        end

        @xslide.on_edit! do |e|
          layer&.break_layout
          e.resolve
        end

        on_scroll! do |e|
          ps = layout_pads
          if !ps.empty?
            jump = Kredki.mouse.scrollbar_speed keyboard.alt?
            xjump = 1.0 * p0.sw / @lw * jump
            yjump = 1.0 * p0.sh / @lh * jump
            xo, yo = if p0.sw < @lw && p0.sh < @lh
              keyboard.shift? ? [e.y, e.x] : e.xy
            elsif p0.sw < @lw
              keyboard.shift? ? [e.yorx, 0] : [e.xory, 0]
            elsif p0.sh < @lh
              keyboard.shift? ? [0, e.xory] : [0, e.yorx]
            else
              [0, 0]
            end
            e.resolve if (@xslide.value! @xslide.value - xo * xjump) | (@yslide.value! @yslide.value - yo * yjump)
          end
        end

        # on! ROIEvent do |e|
        #   ps = layout_pads
        #   if !ps.empty?
        #     pxw = ps.filter{ it.x == :auto }.max{ it.sw }
        #     pxh = ps.filter{ it.y == :auto }.max{ it.sh }
        #     if (l = e.x) < 0
        #       @xslide.value! 1.0 * (l - pxw.sx) / (pxw.sw - @xslide.sw)
        #     elsif (r = e.w + e.x) > sw
        #       @xslide.value! 1.0 * (r - @xslide.sw - pxw.sx) / (pxw.sw - @xslide.sw)
        #     end

        #     if (t = e.y) < 0
        #       @yslide.value! 1.0 * (t - pxh.sy) / (pxh.sh - @yslide.sh)
        #     elsif (b = e.h + e.y) > sh
        #       @yslide.value! 1.0 * (b - @yslide.sh - pxh.sy) / (pxh.sh - @yslide.sh)
        #     end
        #   end
        # end
      end

      def mouse_button_down e
      end

      def mouse_button_up e
      end

      def put_pad pad, at = nil
        super pad, at || @corner
      end

      def arrange_pads
        pads.take_while{ it != @xslide }
      end

      def cw
        super + @ocw
      end

      def ch
        super + @och
      end

      def arrange o = true
        @ocw = @och = 0 if o
        mx, my, @lw, @lh = super()
        ps = arrange_pads
        if !ps.empty?
          w = sw
          h = sh
          xscroll = w < @lw
          yscroll = h < @lh
          yscroll ||= xscroll && h - 10 < @lh
          xscroll ||= yscroll && w - 10 < @lw
          if o && (xscroll || yscroll)
            @ocw -= 10 if yscroll
            @och -= 10 if xscroll
            return arrange false
          end
          
          @xslide.show = xscroll
          if xscroll
            xs = yscroll ? w - 10 : w
            @xslide.set_size xs, 10
            @xslide.set_xy 0, h - 10
            @xslide.arrange @lw
            pad_x = ((xs - @lw) * @xslide.value).round
          else
            pad_x = 0
          end
          
          @yslide.show = yscroll
          if yscroll
            ys = xscroll ? h - 10 : h
            @yslide.set_size 10, ys
            @yslide.handle.set_size 10, (h.to_f / @lh * h).clamp(20, [h - 20, 20].max)
            @yslide.set_xy w - 10, 0
            @yslide.arrange
            pad_y = ((ys - @lh) * @yslide.value).round
          else
            pad_y = 0
          end
          
          ps.each do |p1|
            px = p1.auto_x? ? p1.sx + pad_x : p1.sx
            py = p1.auto_y? ? p1.sy + pad_y : p1.sy
            p1.set_xy px, py
          end
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