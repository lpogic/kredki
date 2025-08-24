module Kredki
  module UI
    class ContextPad < ShapePad

      def mouse_enter e
        e.resolve
      end

      def mouse_move e
        e.resolve
      end

      def sketch p0
        super

        wh! Fit
        layout! Y
      end
    end
  end
end