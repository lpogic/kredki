module Kredki
  module UI
    class SpacePad < Pad

      def << arg
        case arg
        in Numeric
          margin! arg * 0.5
        in [Numeric, Numeric]
          margin! arg[0] * 0.5, arg[1] * 0.5
        in [Numeric, Numeric, Numeric, Numeric]
          margin! *arg
        else
          super
        end
      end

      # :section: LEVEL 2

      def sketch
        super
        
        wh! :fit
      end

      def mouse_down e
      end

      def mouse_up e
      end
    end
  end
end