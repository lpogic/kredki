module Kredki
  module Pads
    module Table
      # Table row model.
      class Row < RectanglePad

        # Add new cell.
        def cell! ...
          new(Cell).alter(...)
        end

        # :section: LEVEL 2

        def sketch
          super

          wh! 1r, :fit
          fill! false
        end

      end
    end
  end
end