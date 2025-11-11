require_relative 'way'

module Kredki
  module UI
    module Layout
      class XWay < Way

        def get_span pad, w, pclw
          case w
          when Rational
            [w, 0, Float::INFINITY, 0]
          when Array
            case w[0]
            when Range
              min = w[0].begin || 0
              max = w[0].end || Float::INFINITY
              [w[1], a = get_w(pad, min, pclw), get_w(pad, max, pclw), a]
            else raise_ia w
            end
          when Range
            min = w.begin || 0
            max = w.end || Float::INFINITY
            [1r, a = get_w(pad, min, pclw), get_w(pad, max, pclw), a]
          else
            [0, a = get_w(pad, w, pclw), a, a]
          end
        end

        def arrange pad
          clw = pad.clw
          clh = pad.clh
          sp = pad.layout_pads.map{ get_span it, it.w, clw }
          measurement, sw = spans sp, clw, pad.mi || 0
 
          pad.layout_pads.zip measurement do |p1, m|
            ph = get_h p1, p1.h, clh
            p1.set_size m, ph
          end

          arrange_pads pad.arrange_pads, sw, clw, clh, pad.mi || 0
        end

        def arrange_pads pads, sw, clw, clh, space
          cx = case @x
          when :c
            (clw - sw) * 0.5
          when :b
            0
          when :e
            clw - sw
          when Rational 
            clw * @x
          when Proc
            @x[clw, sw]
          when Numeric
            @x
          else raise_ia @x
          end
          lx = lxm = ly = lym = 0
          
          pads.each do |p1|
            if p1.layoutic?
              pw, ph, px, py = arrange_layoutic p1, clw, clh, cx
              cx += pw + space
              lx = [lx, px].min
              ly = [ly, py].min
              lxm = [lxm, px + pw].max
              lym = [lym, py + ph].max
            else
              arrange_non_layoutic p1, clw, clh
            end
          end

          [lx, ly, lxm - lx, lym - ly]
        end

        def arrange_layoutic pad, clw, clh, cx
          pw = pad.sw
          ph = pad.sh
          px = pad.get_x clw, pw, cx
          py = pad.get_y clh, ph, (get_y @y, clh, ph)
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