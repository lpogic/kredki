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
        corner = new Pad, layoutic: false, color: :gray, h: 10, w: 10
        @xslide = new HorizontalSlide, layoutic: false, h: 10
        @yslide = new VerticalSlide, layoutic: false, w: 10
        @corner = corner

        @yslide.on_edit! do |e|
          layer&.break_layout
          e.resolve
        end

        @xslide.on_edit! do |e|
          layer&.break_layout
          e.resolve
        end

        on_mouse_scroll! do |e|
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

        on! ROIEvent do |e|
          x, y = e.target.translate *e.xy, self

          if (range = (@lw || 0) - sw) > 0
            if x < 0 || (x += e.w - sw) > 0
              @xslide.value += 1.0 * x / range
            end
          end

          if (range = (@lh || 0) - sh) > 0
            if y < 0 || (y += e.h - sh) > 0
              @yslide.value += 1.0 * y / range
            end
          end
        end
      end

      def mouse_down e
      end

      def mouse_up e
      end

      def put_pad pad, at = nil
        super pad, at || @corner
      end

      def arrange_pads
        pads.take_while{ it != @xslide }
      end

      def cw
        super() + @ocw
      end

      def ch
        super() + @och
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
            px = p1.x == :layout ? p1.sx + pad_x : p1.sx
            py = p1.y == :layout ? p1.sy + pad_y : p1.sy
            p1.set_xy px, py
          end
          if @corner.show = xscroll && yscroll
            @corner.set_xy w - 10, h - 10
          end
        else
          @xslide.hide!
          @yslide.hide!
          @corner.hide!
        end
      end

    end
  end
end