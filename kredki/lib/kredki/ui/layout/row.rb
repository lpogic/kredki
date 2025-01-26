require_relative 'layout'

module Kredki
  module UI
    class Row < Layout
      class << self
        def [](x: :begin, y: :begin)
          self.new.alter x:, y:;
        end
      end

      def initialize
        xy! :begin, :begin
      end

      def arrange pad
        sw = sh = 0
        pad.pads.each do |p1|
          p1.set_size_impl
          sw += p1.w
          sh += p1.h
        end
        pw = pad.w
        ph = pad.h

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
        sh = pad.h
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
        
        pad.update_xy x, y
        return [x ? x + pad.w : x, y]
      end

      def fit_w pad
        pad.pads.map{|p1| p1.pw }.sum || 0
      end
    end#Row
  end#UI
end#Kredki