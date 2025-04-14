module Kredki
  module UI
    class Layout
      include Alterable
      INSTANCE = self.new

      def initialize
        xy! :center, :center
      end

      param def x! x
        x = case x
        when :begin then 0
        when :center then PC
        when :end then PE
        else x
        end
        (neqr @x, x) and set_xy x, @y
      end

      param def y! y
        y = case y
        when :begin then 0
        when :center then PC
        when :end then PE
        else y
        end
        (neqr @y, y) and set_xy @x, y
      end

      param def xy! x, y = nil
        x = case x
        when :begin then 0
        when :center then PC
        when :end then PE
        else x
        end
        y = case y
        when :begin then 0
        when :center then PC
        when :end then PE
        else y
        end
        y ||= x
        (neqr @x, x) || (neqr @y, y) and set_xy x, y
      end

      def neqr a, b
        a != b || (Rational === a) != (Rational === b)
      end

      def set_xy x, y
        @x = x
        @y = y
      end
      
      class << self
        def [](x: :center, y: :center)
          self.new.alter x:, y:;
        end
      end

      def arrange pad
        pw = pad.cw
        ph = pad.ch
        pad.pads.each do |p1|
          x = case @x
          when Rational 
            r = (pw - p1.sw) * @x.to_f
            @x.denominator == 1 ? r / 100 : r
          when Proc
            @x[pw, p1.sw]
          when false
            p1.sx
          else
            @x
          end

          y = case @y
          when Rational 
            r = (ph - p1.sh) * @y.to_f
            @y.denominator == 1 ? r / 100 : r
          when Proc
            @y[ph, p1.sh]
          when false
            p1.sy
          else
            @y
          end
          p1.set_xy_s x, y
        end
        true
      end

      def fit_w pad
        pad.pads.map{|p1| p1.pw }.max || 0
      end

      def fit_h pad
        pad.pads.map{|p1| p1.ph }.max || 0
      end
    end#Layout
  end#UI
end#Kredki