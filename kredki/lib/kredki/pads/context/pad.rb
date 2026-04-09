module Kredki
  module Pads
    module Context
      # Context menu items container pad.
      class Pad < RectanglePad

        # :section: LEVEL 2

        def mouse_enter e
          e.close
        end

        def mouse_move e
          e.close
        end

        def sketch
          super

          set_size Fit
          set_layout :yss
        end
      end
    end
  end#Pads
end#Kredki