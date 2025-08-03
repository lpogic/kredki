module Kredki
  module UI
    module Layout
      class Basic
        model :@x, :@y

        def tune
          self
        end

        def get_c cr, pc, sc
          case cr
          when Rational 
            r = pc * cr.to_f
            cr.denominator == 1 ? r / 100 : r
          when Proc
            cr[pc, sc]
          else
            cr
          end
        end

        def get_d d, pcd
          case d
          when Rational
            r = pcd * d.to_f
            d.denominator == 1 ? r / 100 : r
          when Proc
            d[pcd]
          when Range
            b = case d.begin
            when Rational
              r = pcd * d.begin.to_f
              d.begin.denominator == 1 ? r / 100 : r
            when Numeric
              d.begin < 0 ? pcd + d.begin : d.begin
            when nil
              0
            else raise d.begin
            end
            e = case d.end
            when Rational
              r = pcd * d.end.to_f
              d.end.denominator == 1 ? r / 100 : r
            when Numeric
              d.end < 0 ? pcd + d.end : d.end
            when nil
              nil
            else raise d.end
            end
            if e
              b, e = *[b, e].minmax
              [[e, pcd].min, b].max
            else
              [b, pcd].max
            end
          when Numeric
            d < 0 ? [pcd + d, 0].max : d
          else
            raise d
          end
        end

        def get_w pad, w, pcw
          case w
          when :fit
            pad.fit_w
          else
            get_d w, pcw
          end
        end

        def get_h pad, h, pch
          case h
          when :fit
            pad.fit_h
          else
            get_d h, pch
          end
        end

        def arrange pad
          cw = pad.cw
          ch = pad.ch

          lx = lw = ly = lh = 0

          pad.arrange_pads.each do |p1|
            pw = get_w p1, p1.w, cw
            ph = get_h p1, p1.h, ch
            p1.set_size pw, ph
            px = p1.get_x cw, pw, (get_c @x, cw, pw)
            py = p1.get_y ch, ph, (get_c @y, ch, ph)
            p1.set_xy px, py
            p1.set_margin
            p1.arrange
            if p1.layoutic?
              lx = [lx, px].min
              ly = [ly, py].min
              lw = [lw, pw].max
              lh = [lh, ph].max
            end
          end

          [lx, ly, lw, lh]
        end

        def fit_w pad
          pad.layout_pads.map{|p1| p1.min_w }.max || 0
        end

        def fit_h pad
          pad.layout_pads.map{|p1| p1.min_h }.max || 0
        end
      end#Basic
    end#Layout
  end#UI
end#Kredki