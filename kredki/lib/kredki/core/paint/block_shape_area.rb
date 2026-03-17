require_relative 'shape_area'

module Kredki
  class BlockShapeArea < ShapeArea

    # Helper for creating Shape path.
    class AreaCrayon < Crayon

      # Set [+x+, +y+] as crayon position.
      def xy! x, y = x
        x, y = parse_xy x, y
        super
      end
  
      # Make line from crayon position to [+x+, +y+] then set [+x+, +y+] as crayon position.
      def line! x, y
        x, y = parse_xy x, y
        super
      end
  
      # Make bezier curve from crayon position to [+x+, +y+] with leading points [+cx1+, +cy1+] and [+cx2+, +cy2+]. Then set [+x+, +y+] as crayon position.
      def bc! x, y, cx1, cy1, cx2, cy2
        x, y = parse_xy x, y
        cx1, cy1 = parse_xy cx1, cy1
        cx2, cy2 = parse_xy cx2, cy2
        super
      end

      # :section: LEVEL 2

      def parse_xy x, y
        x = case x
        when Rational
          @shape.size_x * x
        else
          x < 0 ? x + @shape.size_x : x
        end

        y = case y
        when Rational
          @shape.size_y * y
        else
          y < 0 ? y + @shape.size_y : y
        end

        [x, y]
      end

    end


    # :section: LEVEL 2

    def initialize &block
      @block = block
      super()
    end

    def redraw
      crayon = AreaCrayon.new self, true, @size_x * 0.5, @size_y * 0.5
      crayon.autoupdate = false
      crayon.instance_exec @size_x, @size_y, &@block
      crayon.commit
    end
  end
end