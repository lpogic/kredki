module Kredki
  module Pads
    module Table
      # Table column model.
      class Column

        # Set size.
        def set_size size = @size
          return send_bundle :set_size, yield(self.size) if block_given?
          return if @size == size
          @size = size
          true
        end

        # See #set_size.
        def size= param
          send_bundle :set_size, param
        end

        # Get size.
        def size
          @size
        end

        # Set size limit.
        def set_limit limit = @limit
          return send_bundle :set_limit, yield(self.limit) if block_given?
          return if @limit == limit
          @limit = limit
          true
        end

        # See #set_limit.
        def limit= param
          send_bundle :set_limit, param
        end

        # Get size limit.
        def limit
          @limit
        end

        # Set a feature recognized by its class.
        def << feature
          case feature
          when Numeric
            set_size feature
          when Range
            set_limit feature
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