require_relative 'alterable'
require_relative 'paint'
require_relative 'color'

module Kredki
  class Shape < Paint
    include Alterable

    Kredki[self, :color] = :white

    def initialize x = 100, y = 100, **params, &block
      super Abi.shape_new
      ObjectSpace.define_finalizer(self, Shape.proc.finalize(@pointer))

      Shape.init_flags self
      
      alter x:, y:, color: Kredki[self.class, :color], **params, &block
    end

    def move_to! x, y
      Abi.shape_move_to @pointer, x, y
      update
    end

    def line_to! x, y
      Abi.shape_line_to @pointer, x, y
      update
    end

    def cubic_to! cx1, cy1, cx2, cy2, x, y
      Abi.shape_cubic_to @pointer, cx1, cy1, cx2, cy2, x, y
      update
    end

    def close!
      Abi.shape_close @pointer
      update
    end

    def ellipse_at! x, y, r1, r2 = r1
      Abi.shape_append_circle @pointer, x, y, r1, r2
      update
    end

    def rectangle_at! x, y, w, h = w, r1 = 0, r2 = r1
      Abi.shape_append_rect @pointer, x, y, w, h, r1, r2
      update
    end

    def reset!
      Abi.shape_reset @pointer
      update
    end

    def color! *color
      set_fill_color *Kredki.color(color.extract || Kredki[self.class, :color]).to_rgba_array
    end

    def color=(color)
      set_fill_color *Kredki.color(color || Kredki[self.class, :color]).to_rgba_array
    end

    alias_method :fill_color!, :color!
    alias_method :fill_color=, :color=

    class FillRule
      enum :winding, :even_odd
    end

    def fill_rule!(rule) = set_fill_rule FillRule[rule || :winding].to_i
    alias_method :fill_rule=, :fill_rule!
    
    def stroke_color! *color
      set_stroke_color *Kredki.color(color.extract).to_array
    end

    def stroke_color=(color)
      set_stroke_color *Kredki.color(color).to_array
    end


    def stroke_width!(width) = set_stroke_width width
    alias_method :stroke_width=, :stroke_width!

    class StrokeCap
      enum :square, :round, :butt
    end

    def stroke_cap!(cap) = set_stroke_cap StrokeCap[cap].to_i
    alias_method :stroke_cap=, :stroke_cap!

    class StrokeJoin
      enum :bevel, :round, :miter
    end

    def stroke_join!(join) = set_stroke_join StrokeCap[join].to_i
    alias_method :stroke_join=, :stroke_join!


    def stroke_dash=(dash_pattern)
      set_stroke_dash_pattern dash_pattern
    end

    def stroke_dash! *dash_pattern
      set_stroke_dash_pattern dash_pattern
    end

    def_flag :stroke_first

    # class StrokeTrim
    #   struct :begin, :end, :simultaneous
    # end

    # def stroke_trim(trim)
    #   set_stroke_trim *StrokeTrim[trim].to_a
    # end

    #internal api

    def self.finalize pointer
      Abi.shape_delete pointer
    end

    private

    def set_fill_color r, g, b, a
      Abi.shape_set_fill_color @pointer, r, g, b, a
      update
    end

    def set_fill_rule rule
      Abi.shape_set_fill_rule @pointer, rule
      update
    end

    def set_stroke_color r, g, b, a
      Abi.shape_set_stroke_color @pointer, r, g, b, a
      update
    end

    def set_stroke_width w
      Abi.shape_set_stroke_width @pointer, w
      update
    end

    def set_stroke_join join
      Abi.shape_set_stroke_join @pointer, join
      update
    end

    def set_stroke_cap cap
      Abi.shape_set_stroke_cap @pointer, cap
      update
    end

    def set_stroke_dash_pattern dash_pattern
      Abi.shape_set_stroke_dash @pointer, Fiddle::Pointer[dash_pattern.pack "f*"], dash_pattern.length, 0
      update
    end

    def set_stroke_first stroke_first
      Abi.shape_set_paint_order @pointer, stroke_first
      update
    end

    # def set_stroke_trim begin, end, simultaneous
    #   Abi.shape_set_stroke_trim
    # end
  end
end 