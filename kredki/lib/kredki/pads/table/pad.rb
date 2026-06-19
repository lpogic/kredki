module Kredki
  module Pads
    module Table
      class Pad < RectanglePad

        # Add new column.
        def column! ...
          @column_layout.column!(...) and layer&.break_layout
        end

        # Get default row features.
        def row
          {
            size_x: 1r,
            size_y: Fit,
            layout: @column_layout
          }
        end

        # Add new row.
        def row! ...
          put(Row, :row!, row, ...)
        end

        feature :layout_spacer_x # Layout spacer in X axis.

        def set_layout_spacer_x ...
          if @column_layout.set_spacer(...)
            layer&.break_layout
            true
          end
        end

        def layout_spacer_x
          @column_layout.space
        end

        feature :layout_spacer_y # Layout spacer in Y axis.
        
        def set_layout_spacer_y layout_spacer_y
          return if Util.eqr @layout_spacer, layout_spacer_y
          @layout_spacer = layout_spacer_y
          layer&.break_layout
          true
        end

        def layout_spacer_y
          @layout_spacer
        end

        feature :layout_spacer # Nest of layout spacers.

        def set_layout_spacer layout_spacer_x = self.layout_spacer_x, layout_spacer_y = layout_spacer_x, **ka
          set_layout_spacer_x(layout_spacer_x) | 
          set_layout_spacer_y(layout_spacer_y) |
          nest_set(__method__, ka)
        end
        
        def layout_spacer
          layout_spacer_y
        end

        # Add new scroll rows.
        def scroll_rows! ...
          put(ScrollRows, :scroll_rows!, layout_spacer: layout_spacer_y).set(...)
        end

        # :section: LEVEL 2

        def initialize
          super
          
          @column_layout = ColumnLayout.new self, 0, 0
        end

        def sketch
          super 

          set_fill false
          set_layout :yss
          set_size_y Fit
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
  end#Pads
end#Kredki
