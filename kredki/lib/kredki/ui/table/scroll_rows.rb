module Kredki
  module UI
    class Table
      class ScrollRows < ScrollPad

        def sketch p0
          super

          w! 1r
        end

        def row! ...
          put! parent.row!().alter(...)
        end
        
      end
    end
  end
end