module Kredki
  module UI
    class Table < ShapePad
      extend HasParams

      def column! ...
        @column_layout.column!(...) and layer&.break_layout
      end

      param def gap! x, y = x
        x_changed = @column_layout.space! x
        y_changed = layout! layout, y
        layer&.break_layout if x_changed && !y_changed
        x_changed || y_changed
      end, def gap
        [@column_layout.space, layout.space]
      end

      def row
        {
          w: 1r,
          h: Fit,
          layout: @column_layout
        }
      end

      def row! ...
        new(Row, row, ...)
      end

      def scroll_rows! ...
        new(ScrollRows, layout: [Y/Begin/Begin, @_layout.space]).alter(...)
      end

      #internal api

      def initialize
        super
        
        @column_layout = ColumnLayout.new self, 0, 0
      end

      def sketch p0
        super 

        color! false
        layout! Y/Begin/Begin
        h! Fit
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
