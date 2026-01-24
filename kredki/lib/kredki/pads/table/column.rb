module Kredki
  module Pads
    module Table
      # Table column model.
      class Column

        # Set width.
        def w! w = @w
          return send_ahp :w!, yield(self.w) if block_given?
          return if @w == w
          @w = w
          true
        end

        # See #w!.
        def w= param
          send_ahp :w!, param
        end

        # Get width.
        def w
          @w
        end

        # Set width limit.
        def limit! limit = @limit
          return send_ahp :limit!, yield(self.limit) if block_given?
          return if @limit == limit
          @limit = limit
          true
        end

        # See #limit!.
        def limit= param
          send_ahp :limit!, param
        end

        # Get width limit.
        def limit
          @limit
        end

        # Push the feature.
        def << feature
          case feature
          when Numeric
            w! feature
          when Range
            limit! feature
          else raise_ia feature
          end
        end

        # :section: LEVEL 2

        def initialize
          @w = :layout
          @limit = nil
        end
      end
    end
  end
end