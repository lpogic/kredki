module Kredki
  module UI
    class Table < ShapePad

      def column! ...
        @column_layout.column!(...) and layer&.break_layout
      end

      param def gap! x = 0, y = x
        return gap! *Util.cover(yield self.gap) if block_given?
        x_changed = @column_layout.space! x
        y_changed = mi! y
        layer&.break_layout if x_changed && !y_changed
        x_changed || y_changed
      end, def gap
        [@column_layout.space, mi]
      end

      def row
        {
          w: 1r,
          h: :fit,
          layout: @column_layout
        }
      end

      def row! ...
        new(Row, row, ...)
      end

      def scroll_rows! ...
        new(ScrollRows, layout: :ybb, mi: mi).alter(...)
      end

      #internal api

      def initialize
        super
        
        @column_layout = ColumnLayout.new self, 0, 0
      end

      def sketch
        super 

        fill! false
        layout! :ybb
        h! :fit
      end

      def arrange
        @column_layout.prepare
        super
        @column_layout.designate
        super
        @column_layout.release
      end

    end

    require_relative 'column'
    require_relative 'column_layout'
    require_relative 'cell'
    require_relative 'row'
    require_relative 'scroll_rows'
  end
end
