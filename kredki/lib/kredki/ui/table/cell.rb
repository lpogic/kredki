module Kredki
  module UI
    module Table
      # Table cell model.
      class Cell < RectanglePad

        # :section: LEVEL 2

        def sketch
          super

          wh! 1r
        end

        def min_h
          fit_h
        end
        
      end
    end
  end
end