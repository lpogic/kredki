module Kredki
  module Pads
    module Table

      class ScrollCell < Cell
        def fit_size_x
          fit = super
          if lower_pad.pads.last == self
            yslide = find_lower(ScrollRows)&.yslide
            fit += yslide.get_size_x + lower_pad.margin_xe if yslide.scenic?
          end
          fit
        end

        def update_size x, y
          if lower_pad.pads.last == self
            yslide = find_lower(ScrollRows)&.yslide
            return super(x - yslide.get_size_x - lower_pad.margin_xe, y) if yslide.scenic?
          end
          super
        end
      end

      class ScrollRow < Row
        def cell! ...
          put(ScrollCell, :cell!, ...)
        end
      end

      # Scrolled table row set.
      class ScrollRows < ScrollPad

        # Add new row.
        def row! ...
          put(ScrollRow, :row!, lower.row, ...)
        end

        # :section: LEVEL 2

        def sketch
          super

          set_size_x 1r
          set_layout :yss
        end
        
      end
    end
  end
end