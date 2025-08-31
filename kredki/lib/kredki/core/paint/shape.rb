module Kredki
  class Shape < Paint

    def initialize extended = false
      super Abi.shape_new
      ObjectSpace.define_finalizer(self, Shape.proc.finalize(@pointer))

      @stroke_size = 0
      @stroke_color = nil
      stroke_join! :bevel
      @fill_color = Kredki.color
      @is_mask = false
      set_fill_color *@fill_color.to_rgba_array
      update unless extended
    end

    def to_hash
      super + {
        fill_color: @fill_color,
        stroke_size: @stroke_size,
        stroke_color: @stroke_color
      }
    end

    class Drawer

      def initialize shape, reset = true, x = 0, y = 0
        @shape = shape
        @autoupdate = true
        Abi.shape_reset @shape.pointer if reset
        xy! x, y
      end

      attr_accessor :autoupdate
      attr :shape

      def xy! x, y = x
        Abi.shape_move_to @shape.pointer, x, y
        @x = x
        @y = y
        self
      end
  
      def line! x, y
        Abi.shape_line_to @shape.pointer, x, y
        @shape.update if @autoupdate
        @x = x
        @y = y
        self
      end
  
      def curve! x, y, cx1, cy1, cx2, cy2
        Abi.shape_cubic_to @shape.pointer, cx1, cy1, cx2, cy2, x, y
        @shape.update if @autoupdate
        @x = x
        @y = y
        self
      end

      def ellipse! w, h = w
        Abi.shape_append_circle @shape.pointer, @x, @y, w * 0.5, h * 0.5
        @shape.update if @autoupdate
        self
      end
  
      def rectangle! w, h = w, rbb = 0, reb = rbb, rbe = rbb, ree = rbb
        Abi.shape_append_rect1 @shape.pointer, @x - w * 0.5, @y - h * 0.5, w, h, rbb, reb, rbe, ree
        @shape.update if @autoupdate
        self
      end
  
      def close!
        Abi.shape_close @shape.pointer
        @shape.update if @autoupdate
        self
      end

      def commit!
        @shape.update
      end
    end

    def draw! reset = true, x = 0, y = 0,  &block
      drawer = Drawer.new self, reset, x, y
      if block
        drawer.autoupdate = false
        drawer.alter &block
        drawer.commit!
        drawer.autoupdate = true
      end
      drawer
    end

    param_prefix :fill

    param def fill_color! *color
      color = color.pick
      return if @fill_color == color && color != :rand
      set_fill_color *Kredki.color(color).to_rgba_array
      @fill_color = color
      update
    end

    class FillRule
      enum :winding, :even_odd
    end

    param def fill_rule! rule
      return if @fill_rule == rule
      set_fill_rule FillRule[rule || :winding].to_i
      @fill_rule = rule
      update
    end

    param_prefix :stroke

    param def stroke_color! *color
      color = color.pick
      return if @stroke_color == color && color != :rand
      set_stroke_color *Kredki.color(color).to_rgba_array
      @stroke_color = color
      update
    end

    param def stroke_size! size
      return if @stroke_size == size
      set_stroke_size size.to_f
      @stroke_size = size
      update
    end

    class StrokeCap
      enum :square, :round, :butt
    end

    param def stroke_cap! cap
      return if @stroke_cap == cap
      set_stroke_cap StrokeCap[cap || :square].to_i
      @stroke_cap = cap
      update
    end

    class StrokeJoin
      enum :bevel, :round, :miter
    end

    param def stroke_join! join
      return if @stroke_join == join
      if join.is_a? Numeric
        set_stroke_join StrokeJoin[:miter].to_i
        set_stroke_miter_limit join
      else
        set_stroke_join StrokeJoin[join || :bevel].to_i
      end
      @stroke_join = join
      update
    end

    param def stroke_dash! *dash
      return if @stroke_dash == dash
      set_stroke_dash_pattern dash
      @stroke_dash = dash
      update
    end

    flag def stroke_behind! s = true
      c, n = stroke_behind? s
      return if c == n
      set_stroke_behind n
      @stroke_behind = n
      true
    end

    class StrokeTrim
      model :start, :finish, :simultaneous

      def self.[](param)
        case param
        in self
          param
        in [start, finish, simultaneous]
          self.new start, finish, simultaneous
        else
          raise ArgumentError.new "#{param}"
        end
      end

      def to_a
        [@start, @finish, @simultaneous]
      end
    end

    param def stroke_trim! *trim
      trim = trim.pick
      return if @stroke_trim == trim
      set_stroke_trim *StrokeTrim[trim].to_a
      @stroke_trim = trim
      update
    end

    #internal api

    def self.finalize pointer
      Abi.shape_delete pointer
    end

    def set_fill_color r, g, b, a
      Abi.shape_set_fill_color @pointer, r, g, b, a
    end

    def set_fill_rule rule
      Abi.shape_set_fill_rule @pointer, rule
    end

    def set_stroke_color r, g, b, a
      Abi.shape_set_stroke_color @pointer, r, g, b, a
    end

    def set_stroke_size width
      Abi.shape_set_stroke_width @pointer, width
    end

    def set_stroke_join join
      Abi.shape_set_stroke_join @pointer, join
    end

    def set_stroke_miter_limit limit
      Abi.shape_set_stroke_miterlimit @pointer, limit
    end

    def set_stroke_cap cap
      Abi.shape_set_stroke_cap @pointer, cap
    end

    def set_stroke_dash_pattern pattern
      Abi.shape_set_stroke_dash @pointer, Fiddle::Pointer[pattern.pack "f*"], pattern.length, 0
    end

    def set_stroke_behind behind
      Abi.shape_set_paint_order @pointer, behind ? 1 : 0
    end

    def set_stroke_trim start, finish, simultaneous
      Abi.shape_set_stroke_trim @pointer, start, finish, simultaneous ? 1 : 0
    end
  end
end 