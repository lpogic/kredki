module Kredki
  module UI
    # Pad that occupy some space.
    class SpacePad < Pad

      # Push the feature.
      def << feature
        case feature
        in Numeric
          m! feature * 0.5
        in [Numeric, Numeric]
          m! feature[0] * 0.5, feature[1] * 0.5
        else
          super
        end
      end

      # :section: LEVEL 2

      def sketch
        super
        
        wh! 1r
      end

      def mouse_press e
      end

      def mouse_free e
      end
    end
  end
end