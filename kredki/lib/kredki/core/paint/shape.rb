module Kredki
  class Shape < Paint

    def initialize extended = false
      super Abi.shape_new
      ObjectSpace.define_finalizer(self, Shape.proc.finalize(@pointer))

      @out_w = 0
      out_join! :bevel
      @fill = Kredki.color
      set_fill *@fill
      @out_fill = Kredki.color
      set_out_fill *@out_fill
      @is_mask = false
      update unless extended
    end

    def to_hash
      super + {
        fill: @fill,
        out_w: @out_w,
        out_fill: @out_fill
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
  
      def rectangle! w, h = w, crbb = 0, creb = crbb, crbe = crbb, cree = crbb
        Abi.shape_append_round_rect @shape.pointer, @x - w * 0.5, @y - h * 0.5, w, h, crbb, creb, crbe, cree
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

    param def fill! *fill
      return fill! *Util.cover(yield @fill) if block_given?
      fill = Util.uncover fill
      return if @fill == fill && fill != :rand
      set_fill *Kredki.color(fill)
      @fill = fill
      update
    end

    class FillRule
      enum :winding, :even_odd
    end

    param def fill_rule! rule = @fill_rule
      return fill_rule! yield @fill_rule if block_given?
      return if @fill_rule == rule
      set_fill_rule FillRule[rule || :winding].to_i
      @fill_rule = rule
      update
    end

    param def out! *a, **na
      (
        a.map do
          case it
          when Hash
            out! **it
          when Numeric
            out_w! it
          else
            out_fill! *Util.cover(it)
          end
        end.each + 
        na.map do
          send "out_#{_1}!", *Util.cover(_2)
        end
      ).reduce(false){ _1 || _2 }
    end, def out
      [out_w, out_fill]
    end

    param def out_fill! *out_fill
      return out_fill! *Util.cover(yield @out_fill) if block_given?
      out_fill = Util.uncover out_fill
      return if @out_fill == out_fill && out_fill != :rand
      set_out_fill *Kredki.color(out_fill)
      @out_fill = out_fill
      update
    end

    param def out_w! out_w = @out_w
      return out_w! yield @out_w if block_given?
      return if @out_w == out_w
      set_out_w out_w.to_f
      @out_w = out_w
      update
    end

    class OutlineCap
      enum :square, :round, :butt
    end

    param def out_cap! out_cap = @out_cap
      return out_cap! yield @out_cap if block_given?
      return if @out_cap == out_cap
      set_out_cap OutlineCap[out_cap || :square].to_i
      @out_cap = out_cap
      update
    end

    class OutlineJoin
      enum :bevel, :round, :miter
    end

    param def out_join! out_join = @out_join
      return out_join! yield @out_join if block_given?
      return if @out_join == out_join
      if out_join.is_a? Numeric
        set_out_join OutlineJoin[:miter].to_i
        set_out_miter_limit out_join
      else
        set_out_join OutlineJoin[out_join || :bevel].to_i
      end
      @out_join = out_join
      update
    end

    param def out_pattern! *out_pattern
      return out_pattern! *Util.cover(yield @out_pattern) if block_given?
      return if @out_pattern == out_pattern
      set_out_pattern out_pattern
      @out_pattern = out_pattern
      update
    end

    flag def out_behind! value = true
      return if (c = out_behind) == (value = block_given? ? (yield c) : value == :not ? !c : value)
      set_out_behind value
      @out_behind = value
      true
    end

    class OutlineTrim
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

    param def out_trim! *out_trim
      return out_trim! *Util.cover(yield @out_trim) if block_given?
      out_trim = Util.uncover out_trim
      return if @out_trim == out_trim
      set_out_trim *OutlineTrim[out_trim].to_a
      @out_trim = out_trim
      update
    end

    #internal api

    def self.finalize pointer
      Abi.shape_delete pointer
    end

    def set_fill r, g, b, a
      Abi.shape_set_fill_color @pointer, r, g, b, a
    end

    def set_fill_rule rule
      Abi.shape_set_fill_rule @pointer, rule
    end

    def set_out_fill r, g, b, a
      Abi.shape_set_stroke_color @pointer, r, g, b, a
    end

    def set_out_w width
      Abi.shape_set_stroke_width @pointer, width
    end

    def set_out_join join
      Abi.shape_set_stroke_join @pointer, join
    end

    def set_out_miter_limit limit
      Abi.shape_set_stroke_miterlimit @pointer, limit
    end

    def set_out_cap cap
      Abi.shape_set_stroke_cap @pointer, cap
    end

    def set_out_pattern pattern
      Abi.shape_set_stroke_dash @pointer, Fiddle::Pointer[pattern.pack "f*"], pattern.length, 0
    end

    def set_out_behind behind
      Abi.shape_set_paint_order @pointer, behind ? 1 : 0
    end

    def set_out_trim start, finish, simultaneous
      Abi.shape_set_stroke_trim @pointer, start, finish, simultaneous ? 1 : 0
    end
  end
end 