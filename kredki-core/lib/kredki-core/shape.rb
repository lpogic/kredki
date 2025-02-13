require_relative 'paint'
require_relative 'color'

module Kredki
  class Shape < Paint
    include Alterable

    def initialize
      super Abi.shape_new
      ObjectSpace.define_finalizer(self, Shape.proc.finalize(@pointer))
      
      color! :white
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

    param_prefix :fill

    param def color! *color
      color = Kredki.color color.extract
      @color != color and set_fill_color color
    end, :fill_color

    class FillRule
      enum :winding, :even_odd
    end

    param def fill_rule! rule
      rule = FillRule[rule || :winding]
      fill_rule != rule and set_fill_rule rule
    end, get: def fill_rule
      FillRule[@fill_rule || :winding]
    end

    param_prefix :stroke

    param def stroke_color! *color
      color = Kredki.color color.extract
      @stroke_color != color and set_stroke_color color
    end

    param def stroke_width! width
      @stroke_width != width and set_stroke_width width
    end, get: def stroke_width
      @stroke_width || 0
    end

    class StrokeCap
      enum :square, :round, :butt
    end

    param def stroke_cap! cap
      cap = StrokeCap[cap || :square]
      stroke_cap != cap and set_stroke_cap cap
    end, get: def stroke_cap
      StrokeCap[@stroke_cap || :square]
    end

    class StrokeJoin
      enum :bevel, :miter, :round
    end

    param def stroke_join! join
      join = StrokeJoin[join || :bevel]
      stroke_join != join and set_stroke_join join
    end, get: def stroke_join
      StrokeJoin[@stroke_join || :bevel]
    end


    param def stroke_dash! *dash_pattern
      @stroke_dash != dash_pattern and set_stroke_dash_pattern dash_pattern
    end

    def_flag :stroke_behind, set: :set_stroke_behind

    class StrokeTrim
      model :start, :finish, :simultaneous

      def self.[](*params)
        case params
        in [self]
          params
        else
          self.new *params
        end
      end
    end

    param def stroke_trim! *trim
      trim = StrokeTrim[*trim]
      @stroke_trim != trim and set_stroke_trim trim
    end

    #internal api

    def self.finalize pointer
      Abi.shape_delete pointer
    end

    private

    def set_fill_color color
      Abi.shape_set_fill_color @pointer, *color.to_rgba_array
      @color = color
      update
    end

    def set_fill_rule rule
      Abi.shape_set_fill_rule @pointer, rule.to_i
      @fill_rule = rule
      update
    end

    def set_stroke_color color
      Abi.shape_set_stroke_color @pointer, *color.to_rgba_array
      @stroke_color = color
      update
    end

    def set_stroke_width w
      Abi.shape_set_stroke_width @pointer, w
      @stroke_width = w
      update
    end

    def set_stroke_join join
      Abi.shape_set_stroke_join @pointer, join.to_i
      @stroke_join = join
      update
    end

    def set_stroke_cap cap
      Abi.shape_set_stroke_cap @pointer, cap.to_i
      @stroke_cap = cap
      update
    end

    def set_stroke_dash_pattern pattern
      Abi.shape_set_stroke_dash @pointer, Fiddle::Pointer[pattern.pack "f*"], pattern.length, 0
      @stroke_dash = pattern
      update
    end

    def set_stroke_behind behind
      Abi.shape_set_paint_order @pointer, behind ? 1 : 0
      @stroke_behind = behind
      update
    end

    def set_stroke_trim trim
      Abi.shape_set_stroke_trim @pointer, trim.start, trim.finish, trim.simultaneous ? 1 : 0
      @stroke_trim = trim
      update
    end
  end
end 