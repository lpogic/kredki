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
            w: 1r,
            h: Fit,
            layout: @column_layout
          }
        end

        # Add new row.
        def row! ...
          new(Row, :row!, row, ...)
        end

        # Set X inner margin.
        def mxi! ...
          if @column_layout.space!(...)
            layer&.break_layout
            true
          end
        end

        # See #mxi!.
        def mxi= param
          send_ahp :mxi!, param
        end

        # Get X inner margin.
        def mxi
          @column_layout.space
        end

        # Set Y inner margin.
        def myi! myi = @mi
          return myi! yield @mi if block_given?
          return if Util.eqr @mi, myi
          @mi = myi
          layer&.break_layout
          true
        end

        # See #myi!.
        def myi= param
          send_ahp :myi!, param
        end

        # Get Y inner margin.
        def myi
          @mi
        end

        # Set inner margin.
        def mi! mxi = @column_layout.space, myi = mxi
          return mi! yield(self.mi) if block_given?
          mxi!(mxi) | myi!(myi)
        end

        # See #mi!.
        def mi= param
          send_ahp :mi!, param
        end

        # Get inner margin.
        def mi
          myi
        end

        # Add new scroll rows.
        def scroll_rows! ...
          new(ScrollRows, :scroll_rows!, layout: :yss, mi: myi).alter(...)
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
          h! Fit
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
