module Kredki
  # Graphical object with custom fill and outline.
  class Shape < Paint

    # Helper for creating Shape path.
    class Drawer

      # Set current coortinates to [+x+, +y+].
      def xy! x, y = x
        Pastele.shape_move_to @shape.pointer, x, y
        @x = x
        @y = y
        self
      end
  
      # Make line from current coortinates to [+x+, +y+] and sets the current coortinates to given ones.
      def line! x, y
        Pastele.shape_line_to @shape.pointer, x, y
        @shape.update if @autoupdate
        @x = x
        @y = y
        self
      end
  
      # Make bezier curve from current coortinates to [+x+, +y+] with leading points [+cx1+, +cy1+] and [+cx2+, +cy2+]. Then sets the current coortinates to [+x+, +y+].
      def curve! x, y, cx1, cy1, cx2, cy2
        Pastele.shape_cubic_to @shape.pointer, cx1, cy1, cx2, cy2, x, y
        @shape.update if @autoupdate
        @x = x
        @y = y
        self
      end

      # Make ellipse of +w+ width and +h+ height with the center at the current coortinates.
      def ellipse! w, h = w
        Pastele.shape_append_circle @shape.pointer, @x, @y, w * 0.5, h * 0.5
        @shape.update if @autoupdate
        self
      end

      # Make rectangle of +w+ width and +h+ height with +crtt+, +crht+, +crth+ and +crhh+ corner radiuses. 
      # The rectangle is placed at the current coortinates.
      def rectangle! w, h = w, crtt = 0, crht = crtt, crth = crtt, crhh = crtt
        Pastele.shape_append_round_rect @shape.pointer, @x - w * 0.5, @y - h * 0.5, w, h, crtt, crht, crth, crhh
        @shape.update if @autoupdate
        self
      end
  
      # Make line from the current position to the first path position.
      def close!
        Pastele.shape_close @shape.pointer
        @shape.update if @autoupdate
        self
      end

      # :section: LEVEL 2

      def initialize shape, reset = true, x = 0, y = 0
        @shape = shape
        @autoupdate = true
        Pastele.shape_reset @shape.pointer if reset
        xy! x, y
      end

      attr_accessor :autoupdate
      attr :shape

      # Publicate prepared path.
      def commit!
        @shape.update
      end
    end

    # Get Drawer to create custom path.
    #
    # +block+ is called in Drawer context if given.
    def draw! reset = true, x = 0, y = 0, &block
      drawer = Drawer.new self, reset, x, y
      if block
        drawer.autoupdate = false
        drawer.alter &block
        drawer.commit!
        drawer.autoupdate = true
      end
      drawer
    end

    # Set fill.
    def fill! *fill
      return fill! *Util.cover(yield @fill) if block_given?
      fill = Util.uncover fill
      return if @fill == fill && fill != :rand
      set_fill *Kredki.color(fill)
      @fill = fill
      update
    end

    # See #fill!.
    def fill= param
      Array === param ? (fill! *param) : (fill! param)
    end

    # Get fill.
    def fill
      @fill
    end

    # Available fill rules.
    class FillRule
      def self.winding = 0
      def self.even_odd = 1
    end
    
    # Set fill rule.
    def fill_rule! rule = @fill_rule
      return fill_rule! yield @fill_rule if block_given?
      return if @fill_rule == rule
      set_fill_rule FillRule.send(rule || :winding)
      @fill_rule = rule
      update
    end

    # See #fill_rule!.
    def fill_rule= param
      Array === param ? (fill_rule! *param) : (fill_rule! param)
    end

    # Get fill rule.
    def fill_rule
      @fill_rule
    end

    # Set outline features.
    def outline! *a, **na
      amap = a.map do
        case it
        when Hash
          outline! **it
        when Numeric
          outline_w! it
        else
          outline_fill! *Util.cover(it)
        end
      end
      namap = na.map do
        send "outline_#{_1}!", *Util.cover(_2)
      end
      amap.any? || namap.any?
    end
    
    # See #outline!.
    def outline= param
      Array === param ? (outline! *param) : (outline! param)
    end

    # Set outline fill.
    def outline_fill! *outline_fill
      return outline_fill! *Util.cover(yield @outline_fill) if block_given?
      outline_fill = Util.uncover outline_fill
      return if @outline_fill == outline_fill && outline_fill != :rand
      set_outline_fill *Kredki.color(outline_fill)
      @outline_fill = outline_fill
      update
    end

    # See #outline_fill!.
    def outline_fill= param
      Array === param ? (outline_fill! *param) : (outline_fill! param)
    end

    # Get outline fill.
    def outline_fill
      @outline_fill
    end

    # Set outline width.
    def outline_w! outline_w = @outline_w
      return outline_w! yield @outline_w if block_given?
      return if @outline_w == outline_w
      set_outline_w outline_w.to_f
      @outline_w = outline_w
      update
    end

    # See #outline_w!.
    def outline_w= param
      Array === param ? (outline_w! *param) : (outline_w! param)
    end

    # Get outline width.
    def outline_w
      @outline_w
    end

    # LAvailable path ending methods.
    class OutlineCap
      def self.square = 0
      def self.round = 1
      def self.butt = 2
    end

    # Set outline path ending method.
    def outline_cap! outline_cap = @outline_cap
      return outline_cap! yield @outline_cap if block_given?
      return if @outline_cap == outline_cap
      set_outline_cap OutlineCap.send(outline_cap || :square)
      @outline_cap = outline_cap
      update
    end

    # See #outline_cap!.
    def outline_cap= param
      Array === param ? (outline_cap! *param) : (outline_cap! param)
    end

    # Get outline path ending method.
    def outline_cap
      @outline_cap
    end

    # Available path connection methods.
    class OutlineJoin
      # Bevel path connection method (default).
      def self.bevel = 0
      def self.round = 1
      # def self.miter = 2 ### miter is set when join is numeric
    end

    # Set outline path connection method.
    def outline_join! outline_join = @outline_join
      return outline_join! yield @outline_join if block_given?
      return if @outline_join == outline_join
      if outline_join.is_a? Numeric
        set_outline_join 2
        set_outline_miter_limit outline_join
      else
        set_outline_join OutlineJoin.send(outline_join || :bevel)
      end
      @outline_join = outline_join
      update
    end

    # See #outline_join!.
    def outline_join= param
      Array === param ? (outline_join! *param) : (outline_join! param)
    end

    # Get outline path connection method.
    def outline_join
      @outline_join
    end

    # Set outline dash pattern.
    def outline_pattern! *outline_pattern
      return outline_pattern! *Util.cover(yield @outline_pattern) if block_given?
      return if @outline_pattern == outline_pattern
      set_outline_pattern outline_pattern
      @outline_pattern = outline_pattern
      update
    end

    # See #outline_pattern!.
    def outline_pattern= param
      Array === param ? (outline_pattern! *param) : (outline_pattern! param)
    end

    # Get outline dash pattern.
    def outline_pattern
      @outline_pattern
    end

    # Set whether outline is drawn behind the fill.
    def outline_behind! value = true
      return if (c = outline_behind) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      set_outline_behind value
      @outline_behind = value
      true
    end

    # See #outline_behind!.
    def outline_behind= value
      outline_behind! value
    end
    
    # Get whether outline is drawn behind the fill.
    def outline_behind
      @outline_behind
    end

    # See #outline_behind.
    def outline_behind?
      !!outline_behind
    end

    # Set outline displayed part.
    def outline_trim! *outline_trim
      return outline_trim! *Util.cover(yield @outline_trim) if block_given?
      outline_trim = Util.uncover outline_trim
      return if @outline_trim == outline_trim
      set_outline_trim *OutlineTrim[outline_trim].to_a
      @outline_trim = outline_trim
      update
    end

    # See #outline_trim!.
    def outline_trim= param
      Array === param ? (outline_trim! *param) : (outline_trim! param)
    end

    # Get outline displayed part.
    def outline_trim
      @outline_trim
    end

    # Get features.
    def to_hash
      super + {
        fill: @fill,
        outline_w: @outline_w,
        outline_fill: @outline_fill
      }
    end

    # :section: LEVEL 2

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

    def initialize extended = false
      super Pastele.shape_new
      ObjectSpace.define_finalizer(self, Shape.proc.finalize(@pointer))

      @outline_w = 0
      outline_join! :bevel
      @fill = Kredki.color
      set_fill *@fill
      @outline_fill = Kredki.color
      set_outline_fill *@outline_fill
      @is_mask = false
      update unless extended
    end

    def self.finalize pointer
      Pastele.shape_delete pointer
    end

    def set_fill r, g, b, a
      Pastele.shape_set_fill_color @pointer, r, g, b, a
    end

    def set_fill_rule rule
      Pastele.shape_set_fill_rule @pointer, rule
    end

    def set_outline_fill r, g, b, a
      Pastele.shape_set_stroke_color @pointer, r, g, b, a
    end

    def set_outline_w width
      Pastele.shape_set_stroke_width @pointer, width
    end

    def set_outline_join join
      Pastele.shape_set_stroke_join @pointer, join
    end

    def set_outline_miter_limit limit
      Pastele.shape_set_stroke_miterlimit @pointer, limit
    end

    def set_outline_cap cap
      Pastele.shape_set_stroke_cap @pointer, cap
    end

    def set_outline_pattern pattern
      Pastele.shape_set_stroke_dash @pointer, Fiddle::Pointer[pattern.pack "f*"], pattern.length, 0
    end

    def set_outline_behind behind
      Pastele.shape_set_paint_order @pointer, behind ? 1 : 0
    end

    def set_outline_trim start, finish, simultaneous
      Pastele.shape_set_stroke_trim @pointer, start, finish, simultaneous ? 1 : 0
    end
  end
end 