require_relative 'color'
require_relative 'shape'

module Kredki
  class Ellipse < Shape

    def initialize r = 50, x = 100, y = 100, **params, &block
      @rx = nil
      @ry = nil
      super x:, y:, r:, **params, &block
    end

    def rx! rx
      set_rx rx
    end

    alias_method :rx=, :rx!

    def rx
      @rx
    end

    alias_method :radius_x=, :rx=
    alias_method :radius_x!, :rx!
    alias_method :radius_x, :rx

    def ry! ry
      set_ry ry
    end

    alias_method :ry=, :ry!

    def ry
      @ry
    end

    alias_method :radius_y=, :ry=
    alias_method :radius_y!, :ry!
    alias_method :radius_y, :ry

    def r! r
      set_r r
    end

    alias_method :r=, :r!

    def r
      @rx == @ry ? @rx : [@rx, @ry].max
    end

    alias_method :radius=, :r=
    alias_method :radius!, :r!
    alias_method :radius, :r

    def d! d
      set_r d / 2
    end

    alias_method :d=, :d!

    def d 
      r * 2
    end

    alias_method :diameter=, :d=
    alias_method :diameter!, :d!
    alias_method :diameter, :d

    private

    def reset!
      super
      if @rx && @ry
        ellipse_at! 0, 0, @rx, @ry
      end
      update
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