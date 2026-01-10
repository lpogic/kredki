module Kredki
  module UI
    module Table
      class Pad < RectanglePad

        # Add new column.
        def column! ...
          @column_layout.column!(...) and layer&.break_layout
        end

        # Get default row features.
        def row
          {
            w: 1r,
            h: :fit,
            layout: @column_layout
          }
        end

        # Add new row.
        def row! ...
          new(Row, row, ...)
        end

        # Add new scroll rows.
        def scroll_rows! ...
          new(ScrollRows, layout: :yss, mi: mi).alter(...)
        end

        # Set gap between columns.
        def gap_col! gap_col = @column_layout.space
          return send_ahp :gap_col!, yield(self.gap_col) if block_given?
          if @column_layout.space! gap_col
            layer&.break_layout
            true
          end
        end

        # See #gap_col!.
        def gap_col= param
          send_ahp :gap_col!, param
        end

        # Get gap between columns.
        def gap_col
          @column_layout.space
        end

        # Set gap between rows.
        def gap_row! gap_row = @rowumn_layout.space
          return send_ahp :gap_row!, yield(self.gap_row) if block_given?
          mi! gap_row
        end

        # See #gap_row!.
        def gap_row= param
          send_ahp :gap_row!, param
        end

        # Get gap between rowumns.
        def gap_row
          mi
        end

        # Set gap between columns and rows.
        def gap! gap_col = @column_layout.space, gap_row = gap_col
          return send_ahp :gap!, yield(self.gap) if block_given?
          gap_col!(gap_col) | gap_row!(gap_row)
        end

        # See #gap!.
        def gap= param
          send_ahp :gap!, param
        end

        # Get gap between columns and rows.
        def gap
          [gap_col, gap_row]
        end

        # :section: LEVEL 2

        def initialize
          super
          
          @column_layout = ColumnLayout.new self, 0, 0
        end

        def sketch
          super 

          fill! false
          layout! :yss
          h! :fit
        end

        def arrange
          @column_layout.prepare
          super
          @column_layout.designate
          super
          @column_layout.release
        end

      end#Pad

      require_relative 'column'
      require_relative 'column_layout'
      require_relative 'cell'
      require_relative 'row'
      require_relative 'scroll_rows'
    end#Table
  end#UI
end#Kredki
