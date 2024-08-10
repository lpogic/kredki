require_relative 'color'
require_relative 'shape'

module Kredki
  class Rectangle < Shape

    def initialize w = 100, h = 100, x = 100, y = 100, **params, &block
      @w = nil
      @h = nil
      @rx = 0
      @ry = 0
      super w:, h:, x:, y:, **params, &block
    end

    def w!(w) = set_w w
    alias_method :w=, :w!
    def w = @w
    alias_method :width=, :w!
    alias_method :width!, :w!
    alias_method :width, :w

    def h!(h) = set_h h
    alias_method :h=, :h!
    def h = @h
    alias_method :height=, :h!
    alias_method :height!, :h!
    alias_method :height, :h
      
    def rx!(rx) = set_rx rx
    alias_method :rx=, :rx!
    def rx = @rx
    alias_method :radius_x=, :rx!
    alias_method :radius_x!, :rx!
    alias_method :radius_x, :rx

    def ry!(ry) = set_ry ry
    alias_method :ry=, :ry!
    def ry = @ry
    alias_method :radius_y=, :ry!
    alias_method :radius_y!, :ry!
    alias_method :radius_y, :ry

    def r!(r) = set_r r
    alias_method :r=, :r!
    def r = [@rx, @ry].max
    alias_method :radius=, :r!
    alias_method :radius!, :r!
    alias_method :radius, :r

    private

    def reset!
      super
      if @w && @h
        rectangle_at! -@w / 2, -@h / 2, @w, @h, @rx || 0, @ry || 0
      end
      update
    end

    def set_w w
      if w != @w
        @w = w
        reset!
      end
    end

    def set_h h
      if h != @h
        @h = h
        reset!
      end
    end

    def set_rx rx
      if rx != @rx
        @rx = rx
        reset!
      end
    end

    def set_ry ry
      if ry != @ry
        @ry = ry
        reset!
      end
    end

    def set_r r
      if r != @rx || r != @ry
        @rx = @ry = r
        reset!
      end
    end
  end
end