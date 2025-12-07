module Kredki
  module UI
    class Table
      class Column

        def initialize
          @w = :layout
          @limit = nil
        end

        def w! w = @w
          @w = w
          true
        end

        def w= param
          w! param
        end

        def w
          @w
        end

        def limit! limit = @limit
          @limit = limit
          true
        end

        def limit= param
          limit! param
        end

        def limit
          @limit
        end

        def << feature
          case feature
          when Numeric
            w! feature
          when Range
            limit! feature
          else raise_ia feature
          end
        end
      end
    end
  end
end