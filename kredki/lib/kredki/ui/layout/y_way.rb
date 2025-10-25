require_relative 'way'

module Kredki
  module UI
    module Layout
      class YWay < Way

        def get_span pad, h, pch
          case h
          when Rational
            [h, 0, Float::INFINITY, 0]
          when Array
            case h[0]
            when Range
              min = h[0].begin || 0
              max = h[0].end || Float::INFINITY
              [h[1], a = get_h(pad, min, pch), get_h(pad, max, pch), a]
            else raise_ia h
            end
          when Range
            min = h.begin || 0
            max = h.end || Float::INFINITY
            [1r, a = get_h(pad, min, pch), get_h(pad, max, pch), a]
          else
            [0, a = get_h(pad, h, pch), a, a]
          end
        end

        def arrange pad
          cw = pad.cw
          ch = pad.ch
          sp = pad.layout_pads.map{ get_span it, it.h, ch }
          measurement, sh = spans sp, ch, pad.mi || 0
 
          pad.layout_pads.zip measurement do |p1, m|
            pw = get_w p1, p1.w, cw
            p1.set_size pw, m
          end

          arrange_pads pad.arrange_pads, sh, cw, ch, pad.mi || 0
        end

        def arrange_pads pads, sh, cw, ch, space
          cy = case @y
          when :c
            (ch - sh) * 0.5
          when :b
            0
          when :e
            ch - sh
          when Rational 
            ch * @y
          when Proc
            @y[ch, sh]
          when Numeric
            @y
          else raise_is @y
          end

          lx = lxm = ly = lym = 0

          pads.each do |p1|
            if p1.layoutic?
              pw, ph, px, py = arrange_layoutic p1, cw, ch, cy
              cy += ph + space
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

        def arrange_layoutic pad, cw, ch, cy
          pw = pad.sw
          ph = pad.sh
          px = pad.get_x cw, pw, (get_x @x, cw, pw)
          py = pad.get_y ch, ph, cy
          pad.set_xy px, py
          pad.set_margin
          pad.arrange
          [pw, ph, px, py]
        end
        
        def fit_h pad
          space = pad.mi || 0
          pad.layout_pads.map{|p1| p1.min_h }.reduce{ _1 + space + _2 } || 0
        end
      end#YWay
    end#Layout
  end#UI
end#Kredki