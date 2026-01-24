module Kredki
  module Pads
    module Table
      # Scrolled table row set.
      class ScrollRows < ScrollPad

        # Add new row.
        def row! ...
          put! parent.row!().alter(...)
        end

        # :section: LEVEL 2

        def sketch
          super

          w! 1r
        end
        
      end
    end
  end
end