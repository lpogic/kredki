module Kredki
  module Pads
    module Table

      class ScrollCell < Cell
        def fit_size_x
          fit = super
          if lower_pad.pads.last == self
            slider_y = lower(ScrollRows)&.slider_y
            fit += slider_y.get_size_x + lower_pad.margin_xe if slider_y.displayed
          end
          fit
        end

        def update_size x, y
          if lower_pad.pads.last == self
            slider_y = lower(ScrollRows)&.slider_y
            return super(x - slider_y.get_size_x - lower_pad.margin_xe, y) if slider_y.displayed
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