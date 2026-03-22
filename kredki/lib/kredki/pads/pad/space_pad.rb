module Kredki
  module Pads
    # Pad that occupy some space.
    class SpacePad < Pad

      # Set a feature recognized by its class.
      def << feature
        case feature
        in Numeric
          set_margin feature * 0.5
        in [Numeric, Numeric]
          set_margin feature[0] * 0.5, feature[1] * 0.5
        else
          super
        end
      end

      # :section: LEVEL 2

      def sketch
        super
        
        set_size 1r
      end

      def mouse_press e
      end

      def mouse_release e
      end
    end
  end
end