module Kredki
  module Pads
    # Pad with scrollable area.
    class ScrollPad < Pad

      # :section: LEVEL 2

      def sketch
        super
        
        # this component creation order is intentional; @corner existence is checked in put_pad
        corner = new RectanglePad, layoutic: false, fill: :gray, wh: 10, xy: End
        @xslide = new HorizontalSlide, layoutic: false, h: 10
        @yslide = new VerticalSlide, layoutic: false, w: 10
        @corner = corner
        @och = @oclw = 0
      end

      def behavior
        super
        p0 = self

        on Slide::EditEvent do |e|
          layer&.break_layout
          e.close
        end

        on_mouse_scroll do |e|
          ps = layout_pads
          if !ps.empty?
            w, h = p0.swh
            xo, yo = if w < @lw && h < @lh
              window.relative_scroll *e.xy
            elsif w < @lw
              [window.relative_scroll(*e.xy).find{|it| it.nonzero? }, 0]
            elsif h < @lh
              [0, window.relative_scroll(*e.xy).find{|it| it.nonzero? }]
            else
              [0, 0]
            end
            if @xslide.value!{|it| (it - xo * w / @lw).clamp(0..1) } | 
              @yslide.value!{|it| (it - yo * h / @lh).clamp(0..1) }
            then
              e.close
            end
          end
        end

        on_mouse_move do |e|
          if e.drag?
            speed = case e.button
            when :primary then -1
            when :scroll then 1
            end
            if speed
              @xslide.process_drag e, speed
              @yslide.process_drag e, speed
              e.close
            end
          end
        end

        on ROIEvent do |e|
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

      def mouse_press e
      end

      def mouse_release e
      end

      def put_pad pad, at = nil
        super pad, at || @corner
      end

      def arranged_pads
        pads.take_while{|it| it != @xslide }
      end

      def clw
        super() + @oclw
      end

      def clh
        super() + @och
      end

      def fit_w
        super + @yslide.get_w
      end

      def fit_h
        super + @xslide.get_h
      end

      def arrange prepare = true
        @oclw = @och = 0 if prepare
        mx, my, @lw, @lh = super()
        oh = @xslide.get_h
        ow = @yslide.get_w
        ps = arranged_pads
        if !ps.empty?
          w = sw
          h = sh
          xscroll = w < @lw
          yscroll = h < @lh
          yscroll ||= xscroll && h - oh < @lh
          xscroll ||= yscroll && w - ow < @lw
          if prepare && (xscroll || yscroll)
            @oclw -= oh if yscroll
            @och -= ow if xscroll
            return arrange false
          end
          
          @xslide.show = xscroll
          pad_x = 0
          if xscroll
            xs = yscroll ? w + @oclw : w
            @xslide.set_size xs, oh
            @xslide.set_xy 0, h - oh
            @xslide.arrange @lw
            pad_x += ((xs - @lw) * @xslide.value).round - mx
          end
          
          @yslide.show = yscroll
          pad_y = 0
          if yscroll
            ys = xscroll ? h + @och : h
            @yslide.set_size ow, ys
            @yslide.set_xy w - ow, 0
            @yslide.arrange @lh
            pad_y += ((ys - @lh) * @yslide.value).round - my
          end
          
          ps.each do |p1|
            px = p1.x == Auto ? p1.sx + pad_x : p1.sx
            py = p1.y == Auto ? p1.sy + pad_y : p1.sy
            p1.set_xy px, py
          end
          if @corner.show = xscroll && yscroll
            @corner.set_xy w - ow, h - oh
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