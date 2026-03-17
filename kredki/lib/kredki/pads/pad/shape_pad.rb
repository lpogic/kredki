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

      # Set outline.
      def set_outline ...
        @area.set_outline(...)
      end

      # See #set_outline.
      def outline= param
        send_bundle :set_outline, param
      end

      # Set outline width.
      def set_outline_w ...
        @area.set_outline_w(...)
      end

      # See #set_outline_w.
      def outline_w= param
        send_bundle :set_outline_w, param
      end

      # Get outline width.
      def outline_w
        @area.outline_w
      end

      # Set outline fill.
      def set_outline_fill ...
        @area.set_outline_fill(...)
      end

      # See #set_outline_fill.
      def outline_fill= param
        send_bundle :set_outline_fill, param
      end

      # Get outline fill.
      def outline_fill
        @area.outline_fill
      end
      
      # Set outline join.
      def set_outline_join ...
        @area.set_outline_join(...)
      end

      # See #set_outline_join.
      def outline_join= param
        send_bundle :set_outline_join, param
      end

      # Get outline join.
      def outline_join
        @area.outline_join
      end

      # Set outline cap.
      def set_outline_cap ...
        @area.set_outline_cap(...)
      end

      # See #set_outline_cap.
      def outline_cap= param
        send_bundle :set_outline_cap, param
      end

      # Get outline cap.
      def outline_cap
        @area.outline_cap
      end

      # Set outline dash pattern.
      def set_outline_pattern ...
        @area.set_outline_pattern(...)
      end

      # See #set_outline_pattern.
      def outline_pattern= param
        send_bundle :set_outline_pattern, param
      end

      # Get outline dash pattern.
      def outline_pattern
        @area.outline_pattern
      end

      # Set outline trim.
      def set_outline_trim ...
        @area.set_outline_trim(...)
      end

      # See #set_outline_trim.
      def outline_trim= param
        send_bundle :set_outline_trim, param
      end

      # Get outline trim.
      def outline_trim
        @area.outline_trim
      end

      # Set whether outline is behind fill.
      def set_outline_behind ...
        @area.set_outline_behind(...)
      end

      # See #set_outline_behind.
      def outline_behind= param
        send_bundle :set_outline_behind, param
      end

      # Get whether outline is behind fill.
      def outline_behind
        @area.outline_behind
      end

      # See #outline_behind.
      def outline_behind?
        @area.outline_behind?
      end

      # :section: LEVEL 2

      def initialize_area
        @area = @scene.rectangle!
      end
    end
  end
end