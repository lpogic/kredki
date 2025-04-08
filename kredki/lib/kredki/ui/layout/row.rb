require_relative 'layout'

module Kredki
  module UI
    class Row < Layout
      class << self
        def [](x = :begin, y = :begin)
          self.new.alter xy: [x, y]
        end
      end

      def initialize
        xy! :begin, :begin
      end

      def arrange pad
        sw = sh = 0
        pad.pads.each do |p1|
          p1.update_size
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
        sh = pad.sh
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
        return [x ? x + pad.sw : x, y]
      end

      def fit_w pad
        pad.pads.map{|p1| p1.pw }.sum || 0
      end
    end#Row

    class RowCenter < Row
      def initialize
        xy! :begin, :center
      end
    end#ColumnCenter
  end#UI
end#Kredki