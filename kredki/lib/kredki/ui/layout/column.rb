require_relative 'basic'

module Kredki
  module UI
    module Layout
      class Column < Basic
        
        def arrange pad
          sw = sh = 0
          pad.pads.each do |p1|
            sw += p1.sw
            sh += p1.sh
          end
          pw = pad.sw
          ph = pad.sh

          x = case @x
          when Rational 
            r = (pw - sw) * @x.to_f
            @x.denominator == 1 ? r / 100 : r
          when Proc
            @x[pw, sw]
          when :auto
            ax || @scene.x
          else
            @x
          end
          
          y = case @y
          when Rational 
            r = (ph - sh) * @y.to_f
            @y.denominator == 1 ? r / 100 : r
          when Proc
            @y[ph, sh]
          when :auto
            ay || @scene.y
          else
            @y
          end

          pad.pads.each do |p1|
            x, y = arrange_pad p1, x, y, pw, ph
          end
          true
        end

        def arrange_pad pad, x, y, pw, ph
          sw = pad.sw
          x = case @x
          when Rational 
            r = (pw - sw) * @x.to_f
            @x.denominator == 1 ? r / 100 : r
          when Proc
            @x[pw, sw]
          when :auto
            ax || @scene.x
          else
            @x
          end
          pad.set_xy_s x, y
          return [x, y ? y + pad.sh : y]
        end

        def fit_h pad
          pad.pads.map{|p1| p1.ph }.sum || 0
        end
      end#Column
    end#Layout
  end#UI
end#Kredki