module Kredki
  module UI
    class RootPad < Pad
      def sketch p0
        super

        keyboardy!
      end

      def translate x, y
        [x, y]
      end
    end
  end
end