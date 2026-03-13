module Kredki
  module Pads
    module Table
      # Column layout.
      class ColumnLayout < Layout::XWay
        
        # Add new column.
        def column! ...
          @columns << Column.new.alter(...)
        end
        
        # Set space between columns.
        def space! space = @space
          return if @space == space
          @space = space
          true
        end

        # See #space!.
        def space= param
          send_bundle :space!, param
        end

        # Get space between columns.
        def space
          @space
        end

        # :section: LEVEL 2
        
        def initialize table, x, y
          super(x, y)
          @table = table
          @columns = []
          @measurement = nil
          @spans = nil
        end
  
        def arrange pad
          @measurement ? proper_arrange(pad) : measure_arrange(pad)
        end

        def measure_arrange pad
          csx = @table.clip_size_x

          @spans = pad.layout_pads.zip(@columns, @spans).map do |p1, column, span|
            n = get_span p1, column.size, column.limit, csx
            span ? [n[0], a = [n[1], span[1]].max, [n[2], span[2]].min, a] : n
          end
        end

        def proper_arrange pad
          client_size_y = pad.clip_size_y
          client_size_x = @table.clip_size_x
          size_x = @size_x

          pad.layout_pads.zip @measurement do |p1, measured|
            if measured
              sx = measured
            else
              sx = client_size_x - size_x
              size_x = client_size_x
            end
            sy = p1.get_size_y client_size_y
            p1.set_size sx, sy
          end

          arrange_pads pad.arranged_pads, size_x, client_size_x, client_size_y, @space || 0
        end
  
        def prepare
          @measurement = nil
          @spans = []
        end
  
        def designate
          @measurement, @size_x = spans @spans, @table.clip_size_x, @space || 0
        end
  
        def release
          @measurement = nil
          @spans = nil
        end
        
      end
    end
  end
end