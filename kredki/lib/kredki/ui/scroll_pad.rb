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
        corner = new Pad, layoutic: false, color: :gray, h: 10, w: 10, xy: :e
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
            dw = cw * 0.5 - e.w
            if x.abs > dw
              if x < 0
                @xslide.value += (x + dw) / range
              else
                @xslide.value += (x - dw) / range
              end
            end
          end

          if (range = (@lh || 0) - sh) > 0
            dh = ch * 0.5 - e.h
            if y.abs > dh
              if y < 0
                @yslide.value += (y + dh) / range
              else
                @yslide.value += (y - dh) / range
              end
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
        super() - @ocw
      end

      def ch
        super() + @och
      end

      def arrange prepare = true
        @ocw = @och = 0 if prepare
        mx, my, @lw, @lh = super()
        oh = @xslide.get_h
        ow = @yslide.get_w
        ps = arrange_pads
        if !ps.empty?
          w = sw
          h = sh
          xscroll = w < @lw
          yscroll = h < @lh
          yscroll ||= xscroll && h - 10 < @lh
          xscroll ||= yscroll && w - 10 < @lw
          if prepare && (xscroll || yscroll)
            @ocw -= oh if yscroll
            @och -= ow if xscroll
            return arrange false
          end
          
          @xslide.show = xscroll
          pad_x = @ocw * 0.5
          if xscroll
            xs = w + @ocw
            @xslide.set_size xs, oh
            @xslide.set_xy (xs - w) * 0.5, (h - oh) * 0.5
            @xslide.arrange @lw
            pad_x += ((xs - @lw) * (@xslide.value - 0.5)).round
          end
          
          @yslide.show = yscroll
          pad_y = @och * 0.5
          if yscroll
            ys = h + @och
            @yslide.set_size ow, ys
            @yslide.set_xy (w - ow) * 0.5, (ys - h) * 0.5
            @yslide.arrange @lh
            pad_y += ((ys - @lh) * (@yslide.value - 0.5)).round
          end
          
          ps.each do |p1|
            px = p1.x == :layout ? p1.sx + pad_x : p1.sx
            py = p1.y == :layout ? p1.sy + pad_y : p1.sy
            p1.set_xy px, py
          end
          if @corner.show = xscroll && yscroll
            @corner.set_xy (w - ow) * 0.5, (h - oh) * 0.5
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