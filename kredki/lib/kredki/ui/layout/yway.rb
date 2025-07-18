require_relative 'way'

module Kredki
  module UI
    module Layout
      class Yway < Way

        def get_fallback_span pad, h, pch
          [0, get_h(pad, h, pch), pad]
        end

        def arrange pad
          cw = pad.cw
          ch = pad.ch
          sh = 0
          span_pads = pad.layout_pads.map do
            span = get_span it, it.h, ch
            sh += span[1]
            span
          end.sort_by{ it[0] }
          span_pads_size = span_pads.size
          return if span_pads_size < 1
          space = @space || 0
          sh += space * (span_pads_size - 1)

          if span_pads.last[0] > 0
            dh = ch - sh
            if dh > 0
              span_pads.each_with_index do |sp, i|
                if sp[0] > 0
                  dhp = dh / (span_pads_size - i)
                  if sp[0] >= dhp
                    dh -= dhp
                    sp[1] += dhp
                    sh += dhp
                  else
                    dh -= sp[0]
                    sp[1] += sp[0]
                    sh += sp[0]
                  end
                end
              end
            end
          end
 
          span_pads.each do |sp|
            p1 = sp[2]
            pw = get_w p1, p1.w, cw
            p1.set_size pw, sp[1]
          end

          cy = case @y
          when Rational 
            r = (ch - sh) * @y.to_f
            @y.denominator == 1 ? r / 100 : r
          when Proc
            @y[ch, sh]
          when Numeric
            @y < 0 ? ch - sh + @y : @y
          else raise @y
          end

          lx = lxm = ly = lym = 0

          pad.arrange_pads.each do |p1|
            if p1.in_layout?
              pw = p1.sw
              ph = p1.sh
              px = p1.get_x cw, pw, (get_c @x, cw, pw)
              py = p1.get_y ch, ph, cy
              p1.set_xy px, py
              p1.set_margin
              p1.arrange
              cy += ph + space
              lx = [lx, px].min
              ly = [ly, py].min
              lxm = [lxm, px + pw].max
              lym = [lym, py + ph].max
            else
              pw = get_w p1, p1.w, cw
              ph = get_h p1, p1.h, ch
              p1.set_size pw, ph
              px = p1.get_x cw, pw, (get_c @x, cw, pw)
              py = p1.get_y ch, ph, (get_c @y, ch, ph)
              p1.set_xy px, py
              p1.set_margin
              p1.arrange
            end
          end
          
          [lx, ly, lxm - lx, lym - ly]
        end
        
        def fit_h pad
          space = @space || 0
          pad.layout_pads.map{|p1| p1.min_h }.reduce{ _1 + space + _2 } || 0
        end
      end#Yway
    end#Layout
  end#UI
end#Kredki