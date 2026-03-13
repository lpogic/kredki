module Kredki
  module Pads
    module Context
      # Context menu root pad.
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

          size! Fit
          layout! :yss
        end
      end
    end
  end#Pads
end#Kredki