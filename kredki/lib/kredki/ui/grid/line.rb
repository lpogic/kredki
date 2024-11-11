module Kredki
  module UI
    class GridPad
      class Line
        include Alterable
        model :grid, :limit, :offset, :size, :max

        def reset
          @offset = 0
          apply_limit @limit
        end

        def apply_limit limit
          case limit
          when Rational
            @size = @max = @grid.w * limit
          when Numeric
            @size = @max = limit
          when Range
            @size = limit.begin
            @max = limit.end || Float::INFINITY
          when Proc
            apply_limit limit
          else
            @size = 0
            @max = Float::INFINITY
          end
        end

        aliasing def limit! limit
          @limit != limit && begin
            @limit = limit
            @grid.update_pads
          end
        end, :limit=
      end
    end
  end
end