require_relative 'shape_area'

module Kredki
  class BlockShapeArea < ShapeArea

    # Helper for creating Shape path.
    class AreaCrayon < Crayon

      # Set [+x+, +y+] as crayon position.
      def jump x, y = x
        x, y = parse_xy x, y
        super
      end
  
      # Make line from crayon position to [+x+, +y+] then set [+x+, +y+] as crayon position.
      def line x, y
        x, y = parse_xy x, y
        super
      end
  
      # Make bezier curve from crayon position to [+x+, +y+] with leading points [+cx1+, +cy1+] and [+cx2+, +cy2+]. Then set [+x+, +y+] as crayon position.
      def curve x, y, cx1, cy1, cx2, cy2
        x, y = parse_xy x, y
        cx1, cy1 = parse_xy cx1, cy1
        cx2, cy2 = parse_xy cx2, cy2
        super
      end

      # Make ellipse of +size_x+ and +size_y+ with the center at crayon position.
      def ellipse size_x, size_y = size_x
        size_x = parse_size_x size_x
        size_y = parse_size_y size_y
        super
      end

      # Make rectangle of +size_x+ and +size_y+ with +corner_ss+, +corner_es+, +corner_se+ and +corner_ee+ corners. 
      # The rectangle is placed at crayon position.
      def rectangle size_x, size_y = size_x, corner_ss = 0, corner_es = corner_ss, corner_se = corner_ss, corner_ee = corner_ss
        size_x = parse_size_x size_x
        size_y = parse_size_y size_y
        super
      end

      # :section: LEVEL 2

      def parse_xy x, y
        x = case x
        when Rational
          (@shape.size_x - @shape.stroke_width) * x
        else
          x
        end

        y = case y
        when Rational
          (@shape.size_y - @shape.stroke_width) * y
        else
          y
        end

        offset = @shape.stroke_width * 0.5
        [x + offset, y + offset]
      end

      def parse_size_x size_x
        case size_x
        when Rational
          (@shape.size_x - @shape.stroke_width) * size_x
        else
          size_x
        end
      end

      def parse_size_y size_y
        case size_y
        when Rational
          (@shape.size_y - @shape.stroke_width) * size_y
        else
          size_y
        end
      end

    end


    # :section: LEVEL 2

    def initialize &block
      @block = block
      super()
    end

    def redraw
      sx = @size_x - @stroke_width
      sy = @size_y - @stroke_width
      crayon = AreaCrayon.new self, true, sx * 0.5, sy * 0.5
      crayon.autoupdate = false
      crayon.instance_exec sx, sy, &@block
      crayon.commit
    end
  end
end