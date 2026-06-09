module Kredki
  module Pads
    module Table
      # Table column model.
      class Column

        def mixed_set feature
          case feature
          when Numeric
            set_size feature
          when Range
            set_limit feature
          else super
          end
        end

        feature :size

        def set_size size = @size
          return if @size == size
          @size = size
          true
        end
        
        def size
          @size
        end

        feature :limit

        def set_limit limit = @limit
          return if @limit == limit
          @limit = limit
          true
        end

        def limit
          @limit
        end
        
        # :section: LEVEL 2

        def initialize
          @size = Auto
          @limit = nil
        end
      end
    end
  end
end