require_relative 'way'

module Kredki
  module UI
    module Layout
      class XWay < Way

        def get_span pad, w, pcw
          case w
          when Rational
            [w, 0, Float::INFINITY, 0]
          when Array
            case w[0]
            when Range
              min = w[0].begin || 0
              max = w[0].end || Float::INFINITY
              [w[1], a = get_w(pad, min, pcw), get_w(pad, max, pcw), a]
            else raise_ia w
            end
          when Range
            min = w.begin || 0
            max = w.end || Float::INFINITY
            [1r, a = get_w(pad, min, pcw), get_w(pad, max, pcw), a]
          else
            [0, a = get_w(pad, w, pcw), a, a]
          end
        end

        def arrange pad
          cw = pad.cw
          ch = pad.ch
          sp = pad.layout_pads.map{ get_span it, it.w, cw }
          measurement, sw = spans sp, cw, pad.mi || 0
 
          pad.layout_pads.zip measurement do |p1, m|
            ph = get_h p1, p1.h, ch
            p1.set_size m, ph
          end

          arrange_pads pad.arrange_pads, sw, cw, ch, pad.mi || 0
        end

        def arrange_pads pads, sw, cw, ch, space
          cx = case @x
          when :c
            (cw - sw) * 0.5
          when :b
            0
          when :e
            cw - sw
          when Rational 
            cw * @x
          when Proc
            @x[cw, sw]
          when Numeric
            @x
          else raise_ia @x
          end
          lx = lxm = ly = lym = 0
          
          pads.each do |p1|
            if p1.layoutic?
              pw, ph, px, py = arrange_layoutic p1, cw, ch, cx
              cx += pw + space
              lx = [lx, px].min
              ly = [ly, py].min
              lxm = [lxm, px + pw].max
              lym = [lym, py + ph].max
            else
              arrange_non_layoutic p1, cw, ch
            end
          end

          [lx, ly, lxm - lx, lym - ly]
        end

        def arrange_layoutic pad, cw, ch, cx
          pw = pad.sw
          ph = pad.sh
          px = pad.get_x cw, pw, cx
          py = pad.get_y ch, ph, (get_y @y, ch, ph)
          pad.set_xy px, py
          pad.set_margin
          pad.arrange
          [pw, ph, px, py]
        end

        def fit_w pad
          space = pad.mi || 0
          pad.layout_pads.map{|p1| p1.min_w }.reduce{ _1 + space + _2 } || 0
        end
      end#XWay
    end#Layout
  end#UI
end#Kredki