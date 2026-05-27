module Kredki
  # Graphical object with custom fill and stroke.
  class Shape < Paint

    # Helper for creating Shape path.
    class Crayon

      # Set [+x+, +y+] as crayon position.
      def jump x, y = x
        Pastele.shape_move_to @shape.pointer, x, y
        @x = x
        @y = y
        self
      end
  
      # Make line from crayon position to [+x+, +y+] then set [+x+, +y+] as crayon position.
      def line x, y
        Pastele.shape_line_to @shape.pointer, x, y
        @shape.update if @autoupdate
        @x = x
        @y = y
        self
      end
  
      # Make bezier curve from crayon position to [+x+, +y+] with control points [+cx1+, +cy1+] and [+cx2+, +cy2+]. Then set [+x+, +y+] as crayon position.
      def curve x, y, cx1, cy1, cx2, cy2
        Pastele.shape_cubic_to @shape.pointer, cx1, cy1, cx2, cy2, x, y
        @shape.update if @autoupdate
        @x = x
        @y = y
        self
      end

      # Make ellipse of +size_x+ and +size_y+ with the center at crayon position.
      def ellipse size_x, size_y = size_x
        Pastele.shape_append_circle @shape.pointer, @x, @y, size_x * 0.5, size_y * 0.5
        @shape.update if @autoupdate
        self
      end

      # Make rectangle of +w+ width and +h+ height with +corner_ss+, +corner_es+, +corner_se+ and +corner_ee+ corners. 
      # The rectangle is placed at crayon position.
      def rectangle w, h = w, corner_ss = 0, corner_es = corner_ss, corner_se = corner_ss, corner_ee = corner_ss
        Pastele.shape_append_round_rect @shape.pointer, @x - w * 0.5, @y - h * 0.5, w, h, corner_ss, corner_es, corner_se, corner_ee
        @shape.update if @autoupdate
        self
      end
  
      # Make line from the crayon position to the first path position.
      def close
        Pastele.shape_close @shape.pointer
        @shape.update if @autoupdate
        self
      end

      # :section: LEVEL 2

      def initialize shape, reset = true, x = 0, y = 0
        @shape = shape
        @autoupdate = true
        Pastele.shape_reset @shape.pointer if reset
        jump x, y
      end

      attr_accessor :autoupdate
      attr :shape

      # Publicate prepared path.
      def commit
        @shape.update
      end
    end

    # Get Crayon to create custom path.
    #
    # +block+ is called in Crayon context if given.
    def draw reset = true, x = 0, y = 0, &block
      crayon = Crayon.new self, reset, x, y
      if block
        crayon.autoupdate = false
        crayon.set &block
        crayon.commit
        crayon.autoupdate = true
      end
      crayon
    end

    feature :fill

    def set_fill *fill
      fill = Util.uncover fill
      return if @fill == fill && fill != :random
      norm_fill = Kredki.fill fill
      case norm_fill
      when Color
        Pastele.shape_set_fill_color @pointer, *norm_fill
      when LinearGradient
        Pastele.shape_set_fill_linear_gradient @pointer, *norm_fill.ffi
      when RadialGradient
        Pastele.shape_set_fill_radial_gradient @pointer, *norm_fill.ffi
      end
      @fill = fill
      update
    end

    def fill
      @fill
    end

    # Available fill rules.
    class FillRule
      class << self
        # Default fill rule.
        def winding = 0 
        def even_odd = 1
      end
    end
    
    feature :fill_rule

    def set_fill_rule rule
      return if @fill_rule == rule
      Pastele.shape_set_fill_rule @pointer, FillRule.send(rule || :winding)
      @fill_rule = rule
      update
    end
    
    def fill_rule
      @fill_rule
    end

    feature :stroke
    
    def set_stroke *a, **ka
      a.count do |it|
        case it
        when Numeric
          set_stroke_width it
        else
          mixed_set_stroke_fill it
        end
      end.zero?.not | nest_set(__method__, ka)
    end
    
    feature :stroke_fill
    
    def set_stroke_fill *stroke_fill
      stroke_fill = Util.uncover stroke_fill
      return if @stroke_fill == stroke_fill && stroke_fill != :random
      norm_fill = Kredki.fill stroke_fill
      case norm_fill
      when Color
        Pastele.shape_set_stroke_color @pointer, *norm_fill
      when LinearGradient
        Pastele.shape_set_stroke_linear_gradient @pointer, *norm_fill.ffi
      when RadialGradient
        Pastele.shape_set_stroke_radial_gradient @pointer, *norm_fill.ffi
      end
      @stroke_fill = stroke_fill
      update
    end

    def stroke_fill
      @stroke_fill
    end

    feature :stroke_width

    def set_stroke_width stroke_width
      return if @stroke_width == stroke_width
      update_stroke_width stroke_width
      update
    end

    def stroke_width
      @stroke_width
    end

    # Available stroke path ending methods.
    class StrokeCap
      class << self
        # Default stroke cap.
        def square = 0
        def round = 1
        def butt = 2
      end
    end

    feature :stroke_cap # Stroke path ending method.

    def set_stroke_cap stroke_cap
      return if @stroke_cap == stroke_cap
      Pastele.shape_set_stroke_cap @pointer, StrokeCap.send(stroke_cap || :square)
      @stroke_cap = stroke_cap
      update
    end
    
    def stroke_cap
      @stroke_cap
    end

    # Available stroke connection methods.
    class StrokeJoin
      class << self
        # Default stroke join.
        def bevel = 0
        def round = 1
        # def miter = 2 ### intentional commented out; miter is set when join is numeric
      end
    end

    feature :stroke_join # Stroke connection method.

    def set_stroke_join stroke_join
      return if @stroke_join == stroke_join
      if stroke_join.is_a? Numeric
        Pastele.shape_set_stroke_join @pointer, 2
        Pastele.shape_set_stroke_miterlimit @pointer, stroke_join
      else
        Pastele.shape_set_stroke_join @pointer, StrokeJoin.send(stroke_join || :bevel)
      end
      @stroke_join = stroke_join
      update
    end

    def stroke_join
      @stroke_join
    end

    feature :stroke_pattern # Stroke dash pattern.

    def set_stroke_pattern *stroke_pattern
      return if @stroke_pattern == stroke_pattern
      Pastele.shape_set_stroke_dash @pointer, Fiddle::Pointer[stroke_pattern.pack "f*"], stroke_pattern.length, 0
      @stroke_pattern = stroke_pattern
      update
    end

    def stroke_pattern
      @stroke_pattern
    end

    feature :stroke_behind # Whether stroke is drawn behind the fill.

    def set_stroke_behind value = true
      return if (c = stroke_behind) == (value = value == Not ? !c : value)
      Pastele.shape_set_paint_order @pointer, value ? 1 : 0
      @stroke_behind = value
      true
    end
    
    def stroke_behind
      @stroke_behind
    end

    feature :stroke_trim # Stroke displayed part.

    def set_stroke_trim *stroke_trim
      stroke_trim = Util.uncover stroke_trim
      return if @stroke_trim == stroke_trim
      start, finish, simultaneous = *StrokeTrim[stroke_trim].to_a
      Pastele.shape_set_stroke_trim @pointer, start, finish, simultaneous ? 1 : 0
      @stroke_trim = stroke_trim
      update
    end

    def stroke_trim
      @stroke_trim
    end

    # Get features.
    def to_hash
      super.merge({
        fill: @fill,
        stroke_width: @stroke_width,
        stroke_fill: @stroke_fill
      })
    end

    # :section: LEVEL 2

    class StrokeTrim

      def initialize start, finish, simultaneous
        @start = start
        @finish = finish
        @simultaneous = simultaneous
      end

      def self.[](param)
        case param
        in self
          param
        in [start, finish]
          self.new start, finish, false
        in [start, finish, simultaneous]
          self.new start, finish, simultaneous
        else raise_ia param
        end
      end

      def to_a
        [@start, @finish, @simultaneous]
      end
    end

    def initialize extended = false, pointer = nil
      super pointer || Pastele.shape_new
      ObjectSpace.define_finalizer(self, Shape.finalizer(@pointer)) unless pointer

      @stroke_width = 0
      set_stroke_join :bevel
      @fill = Kredki.color
      Pastele.shape_set_fill_color @pointer, *@fill
      @stroke_fill = Kredki.color
      Pastele.shape_set_stroke_color @pointer, *@stroke_fill
      @is_mask = false
      update unless extended
    end

    def self.finalizer pointer
      proc{ Pastele.shape_delete pointer }
    end

    def update_stroke_width stroke_width
      Pastele.shape_set_stroke_width @pointer, stroke_width.to_f
      @stroke_width = stroke_width
    end
  end
end 