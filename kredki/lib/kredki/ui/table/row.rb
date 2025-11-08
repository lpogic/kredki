module Kredki
  module UI
    class Table
      class Row < ShapePad

        def sketch
          super

          wh! 1r, :fit
          color! false
        end

        def cell! ...
          new(Cell).alter(...)
        end

      end
    end
  end
end