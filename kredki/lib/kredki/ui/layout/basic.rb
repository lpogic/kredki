module Kredki
  module UI
    module Layout
      class Basic
        model :x, :y

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
      end#Base
    end#Layout
  end#UI
end#Kredki