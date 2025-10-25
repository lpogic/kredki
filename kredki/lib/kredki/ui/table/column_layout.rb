module Kredki
  module UI
    class Table
      class ColumnLayout < Layout::XWay
        extend HasParams
        
        def initialize table, x, y
          super(x, y)
          @table = table
          @columns = []
          @measurement = nil
        end
        
        def column! *a, **na, &b
          @columns << Column.new(Util.uncover a).alter(**na, &b)
        end

        param def space! space
          return if @space == space
          @space = space
          true
        end
  
        def arrange pad
          @measurement ? proper_arrange(pad) : measure_arrange(pad)
        end

        def measure_arrange pad
          cw = @table.cw

          @spans = pad.layout_pads.zip(@columns, @spans).map do |p1, c, s|
            n = get_span p1, c.size, cw
            s ? [n[0], a = [n[1], s[1]].max, [n[2], s[2]].min, a] : n
          end
        end

        def proper_arrange pad
          ch = pad.ch
          cw = @table.cw
          sw = @sw

          pad.layout_pads.zip @measurement do |p1, m|
            if m
              w = m
            else
              w = cw - sw
              sw = cw
            end
            ph = get_h p1, p1.h, ch
            p1.set_size w, ph
          end

          arrange_pads pad.arrange_pads, sw, cw, ch, @space || 0
        end
  
        def prepare
          @measurement = nil
          @spans = []
        end
  
        def designate
          @measurement, @sw = spans @spans, @table.cw, @space || 0
        end
  
        def release
          @measurement = nil
          @spans = nil
        end
        
      end
    end
  end
end