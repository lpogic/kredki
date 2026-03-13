module Kredki
  module Pads
    module Table
      # Table column model.
      class Column

        # Set size.
        def size! size = @size
          return send_bundle :size!, yield(self.size) if block_given?
          return if @size == size
          @size = size
          true
        end

        # See #size!.
        def size= param
          send_bundle :size!, param
        end

        # Get size.
        def size
          @size
        end

        # Set size limit.
        def limit! limit = @limit
          return send_bundle :limit!, yield(self.limit) if block_given?
          return if @limit == limit
          @limit = limit
          true
        end

        # See #limit!.
        def limit= param
          send_bundle :limit!, param
        end

        # Get size limit.
        def limit
          @limit
        end

        # Push the feature.
        def << feature
          case feature
          when Numeric
            size! feature
          when Range
            limit! feature
          else raise_ia feature
          end
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