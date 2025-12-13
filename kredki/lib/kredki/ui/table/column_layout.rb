module Kredki
  module UI
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
          send_ahp :space!, param
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
          clw = @table.clw

          @spans = pad.layout_pads.zip(@columns, @spans).map do |p1, c, s|
            n = get_span p1, c.w, c.limit, clw
            s ? [n[0], a = [n[1], s[1]].max, [n[2], s[2]].min, a] : n
          end
        end

        def proper_arrange pad
          clh = pad.clh
          clw = @table.clw
          sw = @sw

          pad.layout_pads.zip @measurement do |p1, m|
            if m
              w = m
            else
              w = clw - sw
              sw = clw
            end
            ph = p1.get_h clh
            p1.set_size w, ph
          end

          arrange_pads pad.arrange_pads, sw, clw, clh, @space || 0
        end
  
        def prepare
          @measurement = nil
          @spans = []
        end
  
        def designate
          @measurement, @sw = spans @spans, @table.clw, @space || 0
        end
  
        def release
          @measurement = nil
          @spans = nil
        end
        
      end
    end
  end
end