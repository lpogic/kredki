module Kredki
  module Pads
    # Pad with shape area.
    class ShapePad < Pad

      feature :fill
      
      def set_fill ...
        @area.set_fill(...)
      end
      
      def fill
        @area.fill
      end

      feature :stroke
      
      def set_stroke ...
        @area.set_stroke(...)
      end
      
      feature :stroke_width
      
      def set_stroke_width ...
        @area.set_stroke_width(...)
      end
      
      def stroke_width
        @area.stroke_width
      end

      feature :stroke_fill

      def set_stroke_fill ...
        @area.set_stroke_fill(...)
      end
      
      def stroke_fill
        @area.stroke_fill
      end

      feature :stroke_join
      
      def set_stroke_join ...
        @area.set_stroke_join(...)
      end
      
      def stroke_join
        @area.stroke_join
      end

      feature :stroke_cap
      
      def set_stroke_cap ...
        @area.set_stroke_cap(...)
      end
      
      def stroke_cap
        @area.stroke_cap
      end
      
      feature :stroke_pattern
      
      def set_stroke_pattern ...
        @area.set_stroke_pattern(...)
      end
      
      def stroke_pattern
        @area.stroke_pattern
      end

      feature :stroke_trim
      
      def set_stroke_trim ...
        @area.set_stroke_trim(...)
      end
      
      def stroke_trim
        @area.stroke_trim
      end

      feature :stroke_behind # Whether stroke is behind fill.

      def set_stroke_behind ...
        @area.set_stroke_behind(...)
      end
      
      def stroke_behind
        @area.stroke_behind
      end

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.new_rectangle
      end
    end
  end
end