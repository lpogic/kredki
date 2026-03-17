require_relative 'way'

module Kredki
  module Pads
    module Layout
      # A layout in which elements are positioned one next to another, along the Y axis.
      class YWay < Way

        # :section: LEVEL 2

        def get_span pad, size_y, limit, lower_clip_size_y
          case size_y
          when Rational
            case limit
            when nil
              [size_y, 0, Float::INFINITY, 0]
            when Range
              syv = limit.begin&.then{|it| pad.get_size_y_value it, lower_clip_size_y, nil } || 0
              limit_syv = limit.end&.then{|it| pad.get_size_y_value it, lower_clip_size_y, nil } || Float::INFINITY
              [size_y, syv, limit_syv, syv]
            else
              limit_syv = pad.get_size_y_value limit, lower_clip_size_y, nil
              [size_y, 0, limit_syv, 0]
            end
          when Auto
            case limit
            when nil
              [1r, 0, Float::INFINITY, 0]
            when Range
              syv = limit.begin&.then{|it| pad.get_size_y_value it, lower_clip_size_y, nil } || 0
              limit_syv = limit.end&.then{|it| pad.get_size_y_value it, lower_clip_size_y, nil } || Float::INFINITY
              [1r, syv, limit_syv, syv]
            else
              limit_syv = pad.get_size_y_value limit, lower_clip_size_y, nil
              [1r, 0, limit_syv, 0]
            end
          else
            syv = pad.get_size_y_limited size_y, limit, lower_clip_size_y
            [0, syv, syv, syv]
          end
        end

        def arrange pad
          csx, csy = pad.clip_size
          sp = pad.layout_pads.map{|it| get_span it, it.size_y, it.size_y_limit, csy }
          measurement, sy = spans sp, csy, pad.spacer || 0
          
          pad.layout_pads.zip measurement do |p1, measured|
            psx = p1.get_size_x csx, measured
            p1.update_size psx, measured
          end

          arrange_pads pad.arranged_pads, sy, csx, csy, pad.spacer || 0
        end

        def arrange_pads pads, sy, csx, csy, spacer
          cy = case @y
          when Start
            0
          when Center
            (csy - sy) * 0.5
          when End
            csy - sy
          when Rational 
            csy * @y
          when Proc
            @y[csy, sy]
          when Numeric
            @y
          else raise_is @y
          end

          lx = lxm = ly = lym = 0

          pads.each do |p1|
            if p1.layoutic?
              psx, psy, px, py = arrange_layoutic p1, csx, csy, cy
              cy += psy + spacer
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

        def arrange_layoutic pad, csx, csy, cy
          asx, asy = pad.area_size
          px = pad.get_x csx, asx, (get_x @x, csx, asx)
          py = pad.get_y csy, asy, cy
          pad.update_xy px, py
          pad.update_margin
          pad.arrange
          [asx, asy, px, py]
        end
        
        def fit_size_y pad
          spacer = pad.spacer || 0
          pad.layout_pads.map{|p1| p1.min_size_y }.reduce{ _1 + spacer + _2 } || 0
        end

        def get_size_y_rational p0, psy, p1, r
          index = p0.layout_pads.find_index{|it| it == p1 }
          if index
            sp = p0.layout_pads.map{|it| get_span it, it.size_y, it.size_y_limit, psy }
            measurement, sy = spans sp, psy, p0.spacer || 0
            measurement[index]
          else
            r * psy
          end
        end

      end#YWay
    end#Layout
  end#Pads
end#Kredki