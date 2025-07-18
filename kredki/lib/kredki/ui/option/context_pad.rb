module Kredki
  module UI
    class ContextPad < Pad

      def mouse_enter e
        e.resolve
      end

      def mouse_move e
        e.resolve
      end

      def sketch p0
        super

        wh! :fit
        layout! :y
      end
    end
  end
end