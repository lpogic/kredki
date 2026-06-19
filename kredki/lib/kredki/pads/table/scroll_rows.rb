module Kredki
  module Pads
    module Table

      class ScrollCell < Cell
        def fit_size_x
          fit = super
          if lower_pad.pads.last == self
            yslider = lower(ScrollRows)&.yslider
            fit += yslider.get_size_x + lower_pad.margin_xe if yslider.displayed
          end
          fit
        end

        def update_size x, y
          if lower_pad.pads.last == self
            yslider = lower(ScrollRows)&.yslider
            return super(x - yslider.get_size_x - lower_pad.margin_xe, y) if yslider.displayed
          end
          super
        end
      end

      class ScrollRow < Row
        def cell! ...
          put(ScrollCell, __method__, ...)
        end
      end

      # Scrolled table row set.
      class ScrollRows < ScrollPad

        # Add new row.
        def row! ...
          put(ScrollRow, __method__, lower.row, ...)
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