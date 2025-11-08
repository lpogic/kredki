module Kredki
  module UI
    class Table
      class Cell < ShapePad

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