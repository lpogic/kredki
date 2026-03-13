module Kredki
  module Pads
    module Table
      # Table cell model.
      class Cell < RectanglePad

        # :section: LEVEL 2

        def sketch
          super

          size! 1r
        end

        def min_size_y
          fit_size_y
        end
        
      end
    end
  end
end