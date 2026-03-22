require_relative 'way'

module Kredki
  module Pads
    module Layout
      # A layout in which elements are positioned one next to another, along the X axis.
      class XWay < Way

        # :section: LEVEL 2

        def get_span pad, size_x, limit, lower_clip_size_x
          case size_x
          when Rational
            case limit
            when nil
              [size_x, 0, Float::INFINITY, 0]
            when Range
              sxv = limit.begin&.then{|it| pad.get_size_x_value it, lower_clip_size_x, nil } || 0
              limit_sxv = limit.end&.then{|it| pad.get_size_x_value it, lower_clip_size_x, nil } || Float::INFINITY
              [size_x, sxv, limit_sxv, sxv]
            else
              limit_sxv = pad.get_size_x_value limit, lower_clip_size_x, nil
              [size_x, 0, limit_sxv, 0]
            end
          when Auto
            case limit
            when nil
              [1r, 0, Float::INFINITY, 0]
            when Range
              sxv = limit.begin&.then{|it| pad.get_size_x_value it, lower_clip_size_x, nil } || 0
              limit_sxv = limit.end&.then{|it| pad.get_size_x_value it, lower_clip_size_x, nil } || Float::INFINITY
              [1r, sxv, limit_sxv, sxv]
            else
              limit_sxv = pad.get_size_x_value limit, lower_clip_size_x, nil
              [1r, 0, limit_sxv, 0]
            end
          else
            sxv = pad.get_size_x_limited size_x, limit, lower_clip_size_x
            [0, sxv, sxv, sxv]
          end
        end

        def arrange pad
          csx, csy = pad.clip_size
          sp = pad.pads_layoutic.map{|it| get_span it, it.size_x, it.size_x_limit, csx }
          measurement, sx = spans sp, csx, pad.spacer || 0
          
          pad.pads_layoutic.zip measurement do |p1, m|
            psy = p1.get_size_y csy, m
            p1.update_size m, psy
          end

          arrange_pads pad.arranged_pads, sx, csx, csy, pad.spacer || 0
        end

        def arrange_pads pads, sx, csx, csy, spacer
          cx = case @x
          when Start
            0
          when Center
            (csx - sx) * 0.5
          when End
            csx - sx
          when Rational 
            csx * @x
          when Proc
            @x[csx, sx]
          when Numeric
            @x
          else raise_ia @x
          end
          lx = lxm = ly = lym = 0
          
          pads.each do |p1|
            if p1.layoutic
              psx, psy, px, py = arrange_layoutic p1, csx, csy, cx
              cx += psx + spacer
              lx = [lx, px].min
              ly = [ly, py].min
              lxm = [lxm, px + psx].max
              lym = [lym, py + psy].max
            else
              arrange_non_layoutic p1, csx, csy
            end
          end

          [lx, ly, lxm - lx, lym - ly]
        end

        def arrange_layoutic pad, csx, csy, cx
          psx, psy = pad.area_size
          px = pad.get_x csx, psx, cx
          py = pad.get_y csy, psy, (get_y @y, csy, psy)
          pad.update_xy px, py
          pad.update_margin
          pad.arrange
          [psx, psy, px, py]
        end

        def fit_size_x pad
          spacer = pad.spacer || 0
          pad.pads_layoutic.map{|p1| p1.min_size_x }.reduce{ _1 + spacer + _2 } || 0
        end

        def get_size_x_rational p0, psx, p1, r
          index = p0.pads_layoutic.find_index{|it| it == p1 }
          if index
            sp = p0.pads_layoutic.map{|it| get_span it, it.size_x, it.size_x_limit, psx }
            measurement, sx = spans sp, psx, p0.spacer || 0
            measurement[index]
          else
            r * psx
          end
        end

      end#XWay
    end#Layout
  end#Pads
end#Kredki