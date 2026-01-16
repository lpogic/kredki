require_relative 'way'

module Kredki
  module UI
    module Layout
      # A layout in which elements are positioned one next to another, along the Y axis.
      class YWay < Way

        # :section: LEVEL 2

        def get_span pad, h, limit, pclh
          case h
          when Rational
            case limit
            when nil
              [h, 0, Float::INFINITY, 0]
            when Range
              [h, hv = limit.begin&.then{ pad.get_hv(it, pclh, nil) } || 0, limit.end&.then{ pad.get_hv(it, pclh, nil) } || Float::INFINITY, hv]
            else
              [h, 0, pad.get_hv(limit, pclh, nil), 0]
            end
          when :layout
            case limit
            when nil
              [1r, 0, Float::INFINITY, 0]
            when Range
              [1r, hv = limit.begin&.then{ pad.get_hv(it, pclh, nil) } || 0, limit.end&.then{ pad.get_hv(it, pclh, nil) } || Float::INFINITY, hv]
            else
              [1r, 0, pad.get_hv(limit, pclh, nil), 0]
            end
          else
              [0, hv = pad.get_hl(h, limit, pclh), hv, hv]
          end
        end

        def arrange pad
          clw = pad.clw
          clh = pad.clh
          sp = pad.layout_pads.map{ get_span it, it.h, it.h_limit, clh }
          measurement, sh = spans sp, clh, pad.mi || 0
 
          pad.layout_pads.zip measurement do |p1, m|
            pw = p1.get_w clw, m
            p1.set_size pw, m
          end

          arrange_pads pad.arranged_pads, sh, clw, clh, pad.mi || 0
        end

        def arrange_pads pads, sh, clw, clh, space
          cy = case @y
          when :start
            0
          when :center
            (clh - sh) * 0.5
          when :end
            clh - sh
          when Rational 
            clh * @y
          when Proc
            @y[clh, sh]
          when Numeric
            @y
          else raise_is @y
          end

          lx = lxm = ly = lym = 0

          pads.each do |p1|
            if p1.layoutic?
              pw, ph, px, py = arrange_layoutic p1, clw, clh, cy
              cy += ph + space
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

        def arrange_layoutic pad, clw, clh, cy
          pw = pad.sw
          ph = pad.sh
          px = pad.get_x clw, pw, (get_x @x, clw, pw)
          py = pad.get_y clh, ph, cy
          pad.set_xy px, py
          pad.set_margin
          pad.arrange
          [pw, ph, px, py]
        end
        
        def fit_h pad
          space = pad.mi || 0
          pad.layout_pads.map{|p1| p1.min_h }.reduce{ _1 + space + _2 } || 0
        end

        def get_hr p0, p0h, p1, r
          index = p0.layout_pads.find_index{ it == p1 }
          if index
            sp = p0.layout_pads.map{ get_span it, it.h, it.h_limit, p0h }
            measurement, sh = spans sp, p0h, p0.mi || 0
            measurement[index]
          else
            r * p0h
          end
        end

      end#YWay
    end#Layout
  end#UI
end#Kredki