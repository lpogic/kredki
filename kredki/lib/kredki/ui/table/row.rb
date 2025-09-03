module Kredki
  module UI
    class Table
      class Row < ShapePad

        def sketch p1
          super

          wh! 1r, Fit
          color! false
        end

        def cell! ...
          new(Cell).alter(...)
        end

      end
    end
  end
end