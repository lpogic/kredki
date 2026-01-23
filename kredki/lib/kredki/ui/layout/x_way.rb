require_relative 'way'

module Kredki
  module UI
    module Layout
      # A layout in which elements are positioned one next to another, along the X axis.
      class XWay < Way

        # :section: LEVEL 2

        def get_span pad, w, limit, pclw
          case w
          when Rational
            case limit
            when nil
              [w, 0, Float::INFINITY, 0]
            when Range
              [w, wv = limit.begin&.then{|it| pad.get_wv(it, pclw, nil) } || 0, limit.end&.then{|it| pad.get_wv(it, pclw, nil) } || Float::INFINITY, wv]
            else
              [w, 0, pad.get_wv(limit, pclw, nil), 0]
            end
          when :layout
            case limit
            when nil
              [1r, 0, Float::INFINITY, 0]
            when Range
              [1r, wv = limit.begin&.then{|it| pad.get_wv(it, pclw, nil) } || 0, limit.end&.then{|it| pad.get_wv(it, pclw, nil) } || Float::INFINITY, wv]
            else
              [1r, 0, pad.get_wv(limit, pclw, nil), 0]
            end
          else
              [0, wv = pad.get_wl(w, limit, pclw), wv, wv]
          end
        end

        def arrange pad
          clw = pad.clw
          clh = pad.clh
          sp = pad.layout_pads.map{|it| get_span it, it.w, it.w_limit, clw }
          measurement, sw = spans sp, clw, pad.mi || 0
 
          pad.layout_pads.zip measurement do |p1, m|
            ph = p1.get_h clh, m
            p1.set_size m, ph
          end

          arrange_pads pad.arranged_pads, sw, clw, clh, pad.mi || 0
        end

        def arrange_pads pads, sw, clw, clh, space
          cx = case @x
          when :start
            0
          when :center
            (clw - sw) * 0.5
          when :end
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

        def get_wr p0, p0w, p1, r
          index = p0.layout_pads.find_index{|it| it == p1 }
          if index
            sp = p0.layout_pads.map{|it| get_span it, it.w, it.w_limit, p0w }
            measurement, sw = spans sp, p0w, p0.mi || 0
            measurement[index]
          else
            r * p0w
          end
        end

      end#XWay
    end#Layout
  end#UI
end#Kredki