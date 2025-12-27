module Kredki
  module UI
    # Module to include in layout class.
    module Layout

      # :section: LEVEL 2

      def initialize x, y
        @x = x
        @y = y
      end

      def get_p cr, pc, sc
        case cr
        when :c
          (pc - sc) * 0.5
        when :s
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

      def arrange pad
        clw = pad.clw
        clh = pad.clh

        lw = lh = 0
        lx = clw
        ly = clh
        
        pad.arranged_pads.each do |p1|
          pw = p1.get_w clw
          ph = p1.get_h clh
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