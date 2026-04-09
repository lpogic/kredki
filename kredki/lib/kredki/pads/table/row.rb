module Kredki
  module Pads
    module Table
      # Table row model.
      class Row < RectanglePad

        # Add new cell.
        def cell! ...
          put(Cell, __method__, ...)
        end

        # :section: LEVEL 2

        def sketch
          super

          set_size 1r, Fit
          set_fill false
        end

      end
    end
  end
end