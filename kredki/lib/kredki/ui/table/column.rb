module Kredki
  module UI
    class Table
      class Column

        model :size

        def << param
          case param
          when Numeric, Range, Array
            @size = param
          else raise_ia param
          end
        end
      end
    end
  end
end