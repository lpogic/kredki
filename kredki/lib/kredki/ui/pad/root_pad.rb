module Kredki
  module UI
    class RootPad < Pad
      def sketch p0
        super

        keyboardy!
      end

      def translate x, y, target = nil
        if target
          xy = target.translate -x, -y
          [-xy[0], -xy[1]]
        else
          [x, y]
        end
      end
    end
  end
end