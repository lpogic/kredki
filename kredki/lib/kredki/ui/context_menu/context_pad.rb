module Kredki
  module UI
    class ContextPad < RectanglePad

      def mouse_enter e
        e.resolve
      end

      def mouse_move e
        e.resolve
      end

      def sketch
        super

        wh! :fit
        layout! Y
      end
    end
  end
end