require_relative 'layout/basic'

module Kredki
  module UI
    class Table < ShapePad
      extend HasParams

      class Column

        model :size

        def << param
          case param
          when Numeric, Range
            @size = param
          else raise_ia param
          end
        end
      end
  
      class ColumnLayout < Layout::Basic
        extend HasParams

        model :< do
          @columns = []
          @space = 0
          @tmp_column = {}
          @measurement = nil
        end
        
        param def space! space
          return if @space == space
          @space = space
        end

        def column! ...
          @columns << Column.new.alter(...)
        end
  
        def get_span_w i, column, pcw
          w = column.size
          case w
          when Rational
            [w, 0, i]
          else
            [0, get_d(w, pcw), i]
          end
        end
  
        def arrange pad
          @measurement ? proper_arrange(pad) : measure_arrange(pad)
        end

        def space_arrange
          case @space
          when Numeric
            [0, @space, 0]
          when Array
            case @space.size
            when 1
              [@space[0], @space[0], @space[0]]
            when 2
              [@space[0], @space[1], @space[0]]
            when 3
              [@space[0], @space[1], @space[2]]
            else raise_is @space
            end
          when nil
            [0, 0, 0]
          else raise_is @space
          end
        end
  
        def measure_arrange pad
          cw = pad.cw
          ch = pad.ch
          sw = 0
          total_span = 0
          first_space, inner_space, last_space = space_arrange
          spans = @columns.each_with_index.map do |c, i|
            span = get_span_w i, c, cw
            sw += span[1] + inner_space
            total_span += span[0]
            span
          end
          spans_size = spans.size
          return if spans_size < 1
          sw = sw - inner_space + first_space + last_space
  
          dw = cw - sw
          if total_span > 0 && dw > 0
            spans.each do |sp|
              sp[1] += dw * sp[0] / total_span
            end
            sw = cw
          end
  
          @tmp_column[pad] = spans.sort_by{ it[2] }.map{ it[1] }
  
          pads = pad.layout_pads
          spans.map do |sp|
            if p1 = pads[sp[2]]
              ph = get_h p1, p1.h, ch
              pw = get_w p1, p1.w, sp[1]
              p1.set_size pw, ph
            end
          end
  
          pad.arrange_pads.each do |p1|
            if p1.layoutic?
              p1.arrange
            end
          end
  
          nil
        end
  
        def proper_arrange pad
          cw = pad.cw
          ch = pad.ch
          sw = pad.sw
          first_space, inner_space, last_space = space_arrange
          
          pad.layout_pads.zip @measurement do |a|
            p1 = a[0]
            ph = get_h p1, p1.h, ch
            pw = get_w p1, p1.w, a[1] || (cw - @measurement.sum - @measurement.size * inner_space)
            p1.set_size pw, ph
          end
  
          cx = case @x
          when Rational
            @x * cw - sw * 0.5
          when Proc
            @x[cw, sw]
          when Numeric
            @x
          else raise @x
          end
  
          lx = lxm = ly = lym = 0
          cx += first_space
          
          i = 0
          pad.arrange_pads.each do |p1|
            if p1.layoutic?
              pw = p1.sw
              ph = p1.sh
              px = p1.get_x cw, pw, cx
              py = p1.get_y ch, ph, (get_y @y, ch, ph)
              p1.set_xy px, py
              p1.set_margin
              p1.arrange
              cx += (@measurement[i] || pw) + inner_space
              i += 1
              lx = [lx, px].min
              ly = [ly, py].min
              lxm = [lxm, px + pw].max
              lym = [lym, py + ph].max
            else
              pw = get_w p1, p1.w, cw
              ph = get_h p1, p1.h, ch
              p1.set_size pw, ph
              px = p1.get_x cw, pw, (get_x @x, cw, pw)
              py = p1.get_y ch, ph, (get_y @y, ch, ph)
              p1.set_xy px, py
              p1.set_margin
              p1.arrange
            end
          end
  
          [lx, ly, lxm - lx, lym - ly]
        end
  
        def prepare_arrange
          @tmp_column = {}
          @measurement = nil
        end
  
        def measurement
          @measurement = @tmp_column.each_value.reduce do |a, col|
            a.zip(col).map{ it.min }
          end
        end
  
        def reset_arrange
          @tmp_column = nil
        end
  
        def fit_w pad
          first_space, inner_space, last_space = space_arrange
          sum = @columns.map{ get_span_w(0, it, 0)[1] }.sum
          inners = @columns.size - 1
          return 0 if inners < 0
          first_space + sum + inners * inner_space + last_space
        end

        def fit_h pad
          pad.layout_pads.map{|p1| p1.fit_h }.max || 0
        end
      end

      class Row < SpacePad

        def sketch p1
          super

          wh! 1r, Fit
        end

        def cell! ...
          new(ShapePad, wh: 1r, color: false).alter(...)
        end
      end

      class ScrollRows < ScrollPad

        def sketch p0
          super

          w! 1r
        end

        def row! ...
          put! parent.row!().alter(...)
        end
      end

      param def column! ...
        @column_layout.column!(...) and layer&.break_layout
      end, def column_space
        @column_layout.space
      end

      param def column_space! space
        @column_layout.space! space and layer&.break_layout
      end, def column_space
        @column_layout.space
      end

      param def gap! x, y = x
        xc = @column_layout.space! x
        yc = layout! layout, y
        layer&.break_layout if xc && !yc
        xc || yc
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

      def initialize
        super
        
        @column_layout = ColumnLayout.new 0, 0
      end

      def sketch p0
        super 

        color! false
        layout! Y/Begin/Begin
        h! Fit
      end

      def arrange
        @column_layout.prepare_arrange
        super
        @column_layout.measurement
        super
        @column_layout.reset_arrange
      end

    end
  end
end