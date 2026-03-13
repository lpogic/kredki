module Kredki
  module Pads
    # Module to include in layout class.
    module Layout

      # :section: LEVEL 2

      def initialize x, y
        @x = x
        @y = y
      end

      def get_p cr, pc, sc
        case cr
        when Start
          0
        when Center
          (pc - sc) * 0.5
        when End
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
        csx = pad.clip_size_x
        csy = pad.clip_size_y

        lsx = lsy = 0
        lx = csx
        ly = csy
        
        pad.arranged_pads.each do |p1|
          psy = p1.get_size_y csy
          psx = p1.get_size_x csx, psy
          p1.set_size psx, psy
          px = p1.get_x csx, psx, (get_x @x, csx, psx)
          py = p1.get_y csy, psy, (get_y @y, csy, psy)
          p1.set_xy px, py
          p1.set_margin
          p1.arrange
          if p1.layoutic?
            lx = [lx, px].min
            ly = [ly, py].min
            lsx = [lsx, psx].max
            lsy = [lsy, psy].max
          end
        end

        [lx, ly, lsx, lsy]
      end

      def fit_size_x pad
        pad.layout_pads.map{|p1| p1.min_size_x }.max || 0
      end

      def fit_size_y pad
        pad.layout_pads.map{|p1| p1.min_size_y }.max || 0
      end

      def get_size_x_rational p0, p0w, p1, r
        r * p0w
      end

      def get_size_y_rational p0, p0h, p1, r
        r * p0h
      end
    end#Layout
  end#Pads
end#Kredki

require_relative "align"
require_relative "x_way"
require_relative "y_way"