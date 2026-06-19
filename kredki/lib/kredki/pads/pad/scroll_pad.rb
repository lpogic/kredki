module Kredki
  module Pads
    # Pad with scrollable area.
    class ScrollPad < Pad

      # :section: LEVEL 2

      def initialize
        super
        
        # this component creation order is intentional; @corner existence is checked in put_pad
        corner = put RectanglePad, layoutic: false, fill: :gray, size: 10, xy: End
        @xslider = put Xslider, layoutic: false, size_y: 10
        @yslider = put SliderY, layoutic: false, size_x: 10
        @corner = corner
        @clip_size_y_offset = @clip_size_x_offset = 0
      end

      def xslider
        @xslider
      end

      def yslider
        @yslider
      end

      def corner
        @corner
      end

      def behavior
        super
        p0 = self

        on Slider::EditEvent do |e|
          layer&.break_layout
          e.close
        end

        on_mouse_scroll do |e|
          ps = layoutic_pads
          if !ps.empty?
            size_x, size_y = p0.area_size
            xo, yo = if size_x < @layout_size_x && size_y < @layout_size_y
              Kredki.relative_scroll *e.xy
            elsif size_x < @layout_size_x
              [Kredki.relative_scroll(*e.xy).find{|it| it.nonzero? }, 0]
            elsif size_y < @layout_size_y
              [0, Kredki.relative_scroll(*e.xy).find{|it| it.nonzero? }]
            else
              [0, 0]
            end
            x_change = @xslider.set_value (@xslider.value - 0.3 * xo * size_x / @layout_size_x).clamp(0..1)
            y_change = @yslider.set_value (@yslider.value - 0.3 * yo * size_y / @layout_size_y).clamp(0..1)
            e.close if x_change || y_change
          end
        end

        on_mouse_move do |e|
          if e.drag?
            speed = case e.button
            when :primary then -1
            when :scroll then 1
            end
            if speed
              @xslider.process_drag e, speed
              @yslider.process_drag e, speed
              e.close
            end
          end
        end

        on VisionOfferEvent do |e|
          x, y = e.target.translate *e.xy, self

          if (range = (@layout_size_x || 0) - area_size_x) > 0
            if x < 0 || (x += e.size_x - area_size_x) > 0
              @xslider.value += 1.0 * x / range
            end
          end

          if (range = (@layout_size_y || 0) - area_size_y) > 0
            if y < 0 || (y += e.size_y - area_size_y) > 0
              @yslider.value += 1.0 * y / range
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
        pads.take_while{|it| it != @corner }
      end

      def clip_size_x
        super() + @clip_size_x_offset
      end

      def clip_size_y
        super() + @clip_size_y_offset
      end

      def fit_size_x
        super + @yslider.get_size_x
      end

      def fit_size_y
        super + @xslider.get_size_y
      end

      def arrange prepare = true
        @clip_size_x_offset = @clip_size_y_offset = 0 if prepare
        offset_x, offset_y, @layout_size_x, @layout_size_y = super()
        slide_size_y = @xslider.get_size_y
        slide_size_x = @yslider.get_size_x
        ps = arranged_pads
        if !ps.empty?
          asx, asy = area_size
          xscroll = asx < @layout_size_x
          yscroll = asy < @layout_size_y
          yscroll ||= xscroll && asy - slide_size_y < @layout_size_y
          xscroll ||= yscroll && asx - slide_size_x < @layout_size_x
          if prepare && (xscroll || yscroll)
            @clip_size_x_offset -= slide_size_y if yscroll
            @clip_size_y_offset -= slide_size_x if xscroll
            return arrange false
          end
          @xslider.set_scenic xscroll
          pad_x = 0
          if xscroll
            xs = yscroll ? asx + @clip_size_x_offset : asx
            @xslider.update_size xs, slide_size_y
            @xslider.update_xy 0, asy - slide_size_y
            @xslider.arrange @layout_size_x
            pad_x += ((xs - @layout_size_x) * @xslider.value).round - offset_x
          end
          
          @yslider.set_scenic yscroll
          pad_y = 0
          if yscroll
            ys = xscroll ? asy + @clip_size_y_offset : asy
            @yslider.update_size slide_size_x, ys
            @yslider.update_xy asx - slide_size_x, 0
            @yslider.arrange @layout_size_y
            pad_y += ((ys - @layout_size_y) * @yslider.value).round - offset_y
          end
          
          ps.each do |p1|
            px = p1.x == Auto ? p1.area_x + pad_x : p1.area_x
            py = p1.y == Auto ? p1.area_y + pad_y : p1.area_y
            p1.update_xy px.ceil, py.ceil
          end
          if @corner.scenic = xscroll && yscroll
            @corner.update_xy asx - slide_size_x, asy - slide_size_y
          end
        else
          @xslider.set_scenic false
          @yslider.set_scenic false
          @corner.set_scenic false
        end
      end

    end
  end
end