module Kredki
  # Graphical object with custom fill and outline.
  class Shape < Paint

    # Helper for creating Shape path.
    class Crayon

      # Set [+x+, +y+] as crayon position.
      def xy! x, y = x
        Pastele.shape_move_to @shape.pointer, x, y
        @x = x
        @y = y
        self
      end
  
      # Make line from crayon position to [+x+, +y+] then set [+x+, +y+] as crayon position.
      def line! x, y
        Pastele.shape_line_to @shape.pointer, x, y
        @shape.update if @autoupdate
        @x = x
        @y = y
        self
      end
  
      # Make bezier curve from crayon position to [+x+, +y+] with control points [+cx1+, +cy1+] and [+cx2+, +cy2+]. Then set [+x+, +y+] as crayon position.
      def curve! x, y, cx1, cy1, cx2, cy2
        Pastele.shape_cubic_to @shape.pointer, cx1, cy1, cx2, cy2, x, y
        @shape.update if @autoupdate
        @x = x
        @y = y
        self
      end

      # Make ellipse of +w+ width and +h+ height with the center at crayon position.
      def ellipse! w, h = w
        Pastele.shape_append_circle @shape.pointer, @x, @y, w * 0.5, h * 0.5
        @shape.update if @autoupdate
        self
      end

      # Make rectangle of +w+ width and +h+ height with +corner_ss+, +corner_es+, +corner_se+ and +corner_ee+ corners. 
      # The rectangle is placed at crayon position.
      def rectangle! w, h = w, corner_ss = 0, corner_es = corner_ss, corner_se = corner_ss, corner_ee = corner_ss
        Pastele.shape_append_round_rect @shape.pointer, @x - w * 0.5, @y - h * 0.5, w, h, corner_ss, corner_es, corner_se, corner_ee
        @shape.update if @autoupdate
        self
      end
  
      # Make line from the crayon position to the first path position.
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

    # Get Crayon to create custom path.
    #
    # +block+ is called in Crayon context if given.
    def draw! reset = true, x = 0, y = 0, &block
      crayon = Crayon.new self, reset, x, y
      if block
        crayon.autoupdate = false
        crayon.alter &block
        crayon.commit!
        crayon.autoupdate = true
      end
      crayon
    end

    # Set fill.
    def fill! *fill
      return send_ahp :fill!, yield(self.fill) if block_given?
      fill = Util.uncover fill
      return if @fill == fill && fill != :rand
      Pastele.shape_set_fill_color @pointer, *Kredki.color(fill)
      @fill = fill
      update
    end

    # See #fill!.
    def fill= param
      send_ahp :fill!, param
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
      Pastele.shape_set_fill_rule @pointer, FillRule.send(rule || :winding)
      @fill_rule = rule
      update
    end

    # See #fill_rule!.
    def fill_rule= param
      send_ahp :fill_rule!, param
    end

    # Get fill rule.
    def fill_rule
      @fill_rule
    end

    # Set outline features.
    def outline! *a, **na
      a.map do |it|
        case it
        when Hash
          outline! **it
        when Numeric
          outline_w! it
        else
          send_ahp :outline_fill!, it
        end
      end.any? | send_branch(:outline, na)
    end
    
    # See #outline!.
    def outline= param
      send_ahp :outline!, param
    end

    # Set outline fill.
    def outline_fill! *outline_fill
      return send_ahp :outline_fill!, yield(self.outline_fill) if block_given?
      outline_fill = Util.uncover outline_fill
      return if @outline_fill == outline_fill && outline_fill != :rand
      Pastele.shape_set_stroke_color @pointer, *Kredki.color(outline_fill)
      @outline_fill = outline_fill
      update
    end

    # See #outline_fill!.
    def outline_fill= param
      send_ahp :outline_fill!, param
    end

    # Get outline fill.
    def outline_fill
      @outline_fill
    end

    # Set outline width.
    def outline_w! outline_w = @outline_w
      return outline_w! yield @outline_w if block_given?
      return if @outline_w == outline_w
      Pastele.shape_set_stroke_width @pointer, outline_w.to_f
      @outline_w = outline_w
      update
    end

    # See #outline_w!.
    def outline_w= param
      send_ahp :outline_w!, param
    end

    # Get outline width.
    def outline_w
      @outline_w
    end

    # Available path ending methods.
    class OutlineCap
      def self.square = 0
      def self.round = 1
      def self.butt = 2
    end

    # Set outline path ending method.
    def outline_cap! outline_cap = @outline_cap
      return outline_cap! yield @outline_cap if block_given?
      return if @outline_cap == outline_cap
      Pastele.shape_set_stroke_cap @pointer, OutlineCap.send(outline_cap || :square)
      @outline_cap = outline_cap
      update
    end

    # See #outline_cap!.
    def outline_cap= param
      send_ahp :outline_cap!, param
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
        Pastele.shape_set_stroke_join @pointer, 2
        Pastele.shape_set_stroke_miterlimit @pointer, outline_join
      else
        Pastele.shape_set_stroke_join @pointer, OutlineJoin.send(outline_join || :bevel)
      end
      @outline_join = outline_join
      update
    end

    # See #outline_join!.
    def outline_join= param
      send_ahp :outline_join!, param
    end

    # Get outline path connection method.
    def outline_join
      @outline_join
    end

    # Set outline dash pattern.
    def outline_pattern! *outline_pattern
      return send_ahp :outline_pattern!, yield(self.outline_pattern) if block_given?
      return if @outline_pattern == outline_pattern
      Pastele.shape_set_stroke_dash @pointer, Fiddle::Pointer[outline_pattern.pack "f*"], outline_pattern.length, 0
      @outline_pattern = outline_pattern
      update
    end

    # See #outline_pattern!.
    def outline_pattern= param
      send_ahp :outline_pattern!, param
    end

    # Get outline dash pattern.
    def outline_pattern
      @outline_pattern
    end

    # Set whether outline is drawn behind the fill.
    def outline_behind! value = true
      return if (c = outline_behind) == (value = block_given? ? yield(c) : value == :not ? !c : value)
      Pastele.shape_set_paint_order @pointer, value ? 1 : 0
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
      return send_ahp :outline_trim!, yield(self.outline_trim) if block_given?
      outline_trim = Util.uncover outline_trim
      return if @outline_trim == outline_trim
      start, finish, simultaneous = *OutlineTrim[outline_trim].to_a
      Pastele.shape_set_stroke_trim @pointer, start, finish, simultaneous ? 1 : 0
      @outline_trim = outline_trim
      update
    end

    # See #outline_trim!.
    def outline_trim= param
      send_ahp :outline_trim!, param
    end

    # Get outline displayed part.
    def outline_trim
      @outline_trim
    end

    # Get features.
    def to_hash
      super.merge({
        fill: @fill,
        outline_w: @outline_w,
        outline_fill: @outline_fill
      })
    end

    # :section: LEVEL 2

    class OutlineTrim

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
        else
          raise ArgumentError.new "#{param}"
        end
      end

      def to_a
        [@start, @finish, @simultaneous]
      end
    end

    def initialize extended = false, pointer = nil
      super pointer || Pastele.shape_new
      ObjectSpace.define_finalizer(self, Shape.finalizer(@pointer)) unless pointer

      @outline_w = 0
      outline_join! :bevel
      @fill = Kredki.color
      Pastele.shape_set_fill_color @pointer, *@fill
      @outline_fill = Kredki.color
      Pastele.shape_set_stroke_color @pointer, *@outline_fill
      @is_mask = false
      update unless extended
    end

    def self.finalizer pointer
      proc{ Pastele.shape_delete pointer }
    end
  end
end 