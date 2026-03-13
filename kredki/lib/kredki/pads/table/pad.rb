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

        # Set spacer in X axis.
        def spacer_x! ...
          if @column_layout.space!(...)
            layer&.break_layout
            true
          end
        end

        # See #spacer_x!.
        def spacer_x= param
          send_bundle :spacer_x!, param
        end

        # Get spacer in X axis.
        def spacer_x
          @column_layout.space
        end

        # Set spacer in Y axis.
        def spacer_y! spacer_y = @spacer
          return spacer_y! yield @spacer if block_given?
          return if Util.eqr @spacer, spacer_y
          @spacer = spacer_y
          layer&.break_layout
          true
        end

        # See #spacer_y!.
        def spacer_y= param
          send_bundle :spacer_y!, param
        end

        # Get spacer in Y axis.
        def spacer_y
          @spacer
        end

        # Set spacer value.
        def spacer! spacer_x = @column_layout.space, spacer_y = spacer_x
          return spacer! yield(self.spacer) if block_given?
          spacer_x!(spacer_x) | spacer_y!(spacer_y)
        end

        # See #spacer!.
        def spacer= param
          send_bundle :spacer!, param
        end

        # Get spacer value.
        def spacer
          spacer_y
        end

        # Add new scroll rows.
        def scroll_rows! ...
          put(ScrollRows, :scroll_rows!, spacer: spacer_y).alter(...)
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
          size_y! Fit
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
