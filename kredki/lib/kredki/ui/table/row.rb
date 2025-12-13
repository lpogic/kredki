module Kredki
  module UI
    class Table
      class Row < RectanglePad

        def sketch
          super

          wh! 1r, :fit
          fill! false
        end

        def cell! ...
          new(Cell).alter(...)
        end

      end
    end
  end
end