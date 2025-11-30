module Kredki
  module UI
    module Layout
      def initialize x, y
        @x = x
        @y = y
      end

      def get_p cr, pc, sc
        case cr
        when :c
          (pc - sc) * 0.5
        when :b
          0
        when :e
          pc - sc
        when Rational
          cr * pc - sc * 0.5
        when Proc
          cr[pc, sc]
        when Numeric
          cr
        else raise_ia cr
        end
      end

      def get_x cr, pc, sc
        get_p cr, pc, sc
      end

      def get_y cr, pc, sc
        get_p cr, pc, sc
      end

      def get_w pad, w, pclw
        case w
        when :fit
          pad.fit_w
        when :layout
          pad.sw
        when Rational
          pclw * w
        when Proc
          w[pclw]
        when Range
          b = get_w pad, w.begin || 0, pclw
          e = get_w pad, w.end || Float::INFINITY, pclw
          min, max = [b, e].minmax
          pclw > min ? pclw < max ? pclw : max : min
        when Numeric
          w < 0 ? [pclw + w, 0].max : w
        when Array
          get_w pad, w[0], pclw * (w[1] || 1)
        else
          raise_ia w
        end
      end

      def get_h pad, h, pch
        case h
        when :fit
          pad.fit_h
        when :layout
          pad.sh
        when Rational
          pch * h
        when Proc
          h[pch]
        when Range
          b = get_h pad, h.begin || 0, pch
          e = get_h pad, h.end || Float::INFINITY, pch
          min, max = [b, e].minmax
          pch > min ? pch < max ? pch : max : min
        when Numeric
          h < 0 ? [pch + h, 0].max : h
        when Array
          get_h pad, h[0], pch * (h[1] || 1)
        else
          raise_ia h
        end
      end

      def arrange pad
        clw = pad.clw
        clh = pad.clh

        lw = lh = 0
        lx = clw
        ly = clh
        
        pad.arrange_pads.each do |p1|
          pw = get_w p1, p1.w, clw
          ph = get_h p1, p1.h, clh
          p1.set_size pw, ph
          px = p1.get_x clw, pw, (get_x @x, clw, pw)
          py = p1.get_y clh, ph, (get_y @y, clh, ph)
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
    end#Layout
  end#UI
end#Kredki

require_relative "align"
require_relative "x_way"
require_relative "y_way"