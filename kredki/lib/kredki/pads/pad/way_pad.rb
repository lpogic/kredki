module Kredki
  module Pads
    # Pad with way layout.
    class WayPad < SpacePad
      
      def mixed_set feature
        case feature
        in Numeric
          set_layout_spacer feature
        else
          super
        end
      end
      
    end
  end
end