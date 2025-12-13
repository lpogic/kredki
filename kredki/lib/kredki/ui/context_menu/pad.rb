module Kredki
  module UI
    module Context
      # Context menu root pad.
      class Pad < RectanglePad

        # :section: LEVEL 2

        def mouse_enter e
          e.resolve
        end

        def mouse_move e
          e.resolve
        end

        def sketch
          super

          wh! :fit
          layout! Y
        end
      end
    end
  end#UI
end#Kredki