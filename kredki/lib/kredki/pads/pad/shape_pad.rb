module Kredki
  module Pads
    # Pad with shape area.
    class ShapePad < Pad

      # Set fill.
      def set_fill ...
        @area.set_fill(...)
      end

      # See #set_fill.
      def fill= param
        send_bundle :set_fill, param
      end

      # Get fill.
      def fill
        @area.fill
      end

      # Set stroke.
      def set_stroke ...
        @area.set_stroke(...)
      end

      # See #set_stroke.
      def stroke= param
        send_bundle :set_stroke, param
      end

      # Set stroke width.
      def set_stroke_width ...
        @area.set_stroke_width(...)
      end

      # See #set_stroke_width.
      def stroke_width= param
        send_bundle :set_stroke_width, param
      end

      # Get stroke width.
      def stroke_width
        @area.stroke_width
      end

      # Set stroke fill.
      def set_stroke_fill ...
        @area.set_stroke_fill(...)
      end

      # See #set_stroke_fill.
      def stroke_fill= param
        send_bundle :set_stroke_fill, param
      end

      # Get stroke fill.
      def stroke_fill
        @area.stroke_fill
      end
      
      # Set stroke join.
      def set_stroke_join ...
        @area.set_stroke_join(...)
      end

      # See #set_stroke_join.
      def stroke_join= param
        send_bundle :set_stroke_join, param
      end

      # Get stroke join.
      def stroke_join
        @area.stroke_join
      end

      # Set stroke cap.
      def set_stroke_cap ...
        @area.set_stroke_cap(...)
      end

      # See #set_stroke_cap.
      def stroke_cap= param
        send_bundle :set_stroke_cap, param
      end

      # Get stroke cap.
      def stroke_cap
        @area.stroke_cap
      end

      # Set stroke dash pattern.
      def set_stroke_pattern ...
        @area.set_stroke_pattern(...)
      end

      # See #set_stroke_pattern.
      def stroke_pattern= param
        send_bundle :set_stroke_pattern, param
      end

      # Get stroke dash pattern.
      def stroke_pattern
        @area.stroke_pattern
      end

      # Set stroke trim.
      def set_stroke_trim ...
        @area.set_stroke_trim(...)
      end

      # See #set_stroke_trim.
      def stroke_trim= param
        send_bundle :set_stroke_trim, param
      end

      # Get stroke trim.
      def stroke_trim
        @area.stroke_trim
      end

      # Set whether stroke is behind fill.
      def set_stroke_behind ...
        @area.set_stroke_behind(...)
      end

      # See #set_stroke_behind.
      def stroke_behind= param
        send_bundle :set_stroke_behind, param
      end

      # Get whether stroke is behind fill.
      def stroke_behind
        @area.stroke_behind
      end

      # See #stroke_behind.
      def stroke_behind?
        @area.stroke_behind?
      end

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.new_rectangle
      end
    end
  end
end