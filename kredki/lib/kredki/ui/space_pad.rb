module Kredki
  module UI
    class SpacePad < Pad

      def << arg
        case arg
        in Numeric
          m! arg / 2
        in [Numeric, Numeric]
          m! arg[0] / 2, arg[1] / 2
        in [Numeric, Numeric, Numeric, Numeric]
          m! *arg
        else
          super
        end
      end

      #internal api

      def sketch p0
        super
        
        wh! Fit
      end

      def mouse_down e
      end

      def mouse_up e
      end
    end
  end
end