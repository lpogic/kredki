require_relative 'basic'

module Kredki
  module UI
    module Layout
      class XLayout < Basic

        def get_span_w pad, w, pcw
          case w
          when Range
            b = case w.begin
            when Rational
              r = pcw * w.begin.to_f
              w.begin.denominator == 1 ? r / 100 : r
            when Numeric
              w.begin < 0 ? pcw + w.begin : w.begin
            when nil
              0
            else raise w.begin
            end
            e = case w.end
            when Rational
              r = pcw * w.end.to_f
              w.end.denominator == 1 ? r / 100 : r
            when Numeric
              w.end < 0 ? pcw + w.end : w.end
            when nil
              Float::INFINITY
            else raise w.end
            end
            [(e - b).abs, b, pad]
          else
            [0, get_w(pad, w, pcw), pad]
          end
        end

        def arrange pad
          cw = pad.cw
          ch = pad.ch
          sw = 0
          span_pads = pad.layout_pads.map do
            span = get_span_w it, it.w, cw
            sw += span[1]
            span
          end.sort_by{ it[0] }
          span_pads_size = span_pads.size
          return if span_pads_size < 1

          if span_pads.last[0] > 0
            dw = cw - sw
            if dw > 0
              span_pads.each_with_index do |sp, i|
                if sp[0] > 0
                  dwp = dw / (span_pads_size - i)
                  if sp[0] >= dwp
                    dw -= dwp
                    sp[1] += dwp
                    sw += dwp
                  else
                    dw -= sp[0]
                    sp[1] += sp[0]
                    sw += sp[0]
                  end
                end
              end
            end
          end

          span_pads.each do |sp|
            p1 = sp[2]
            ph = get_h p1, p1.h, ch
            p1.set_size sp[1], ph
          end

          cx = case @x
          when Rational 
            r = (cw - sw) * @x.to_f
            @x.denominator == 1 ? r / 100 : r
          when Proc
            @x[cw, sw]
          when Numeric
            @x < 0 ? cw - sw + @x : @x
          else raise @x
          end

          lx = lxm = ly = lym = 0

          pad.arrange_pads.each do |p1|
            if p1.in_layout?
              pw = p1.sw
              ph = p1.sh
              px = p1.get_x cw, pw, cx
              py = p1.get_y ch, ph, (get_c @y, ch, ph)
              p1.set_xy px, py
              p1.set_margin
              p1.arrange
              cx += pw
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

        def fit_w pad
          pad.layout_pads.map{|p1| p1.min_w }.sum || 0
        end
      end#XLayout
    end#Layout
  end#UI
end#Kredki