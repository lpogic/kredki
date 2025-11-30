module Kredki
  module UI
    class Table
      class Column

        model :size

        def << feature
          case feature
          when Numeric, Range, Array
            @size = feature
          else raise_ia feature
          end
        end
      end
    end
  end
end