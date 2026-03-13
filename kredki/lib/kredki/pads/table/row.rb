module Kredki
  module Pads
    module Table
      # Table row model.
      class Row < RectanglePad

        # Add new cell.
        def cell! ...
          put(Cell, :cell!, ...)
        end

        # :section: LEVEL 2

        def sketch
          super

          size! 1r, Fit
          fill! false
        end

      end
    end
  end
end