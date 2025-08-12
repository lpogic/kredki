require_relative 'layout/basic'

module Kredki
  module UI
    class ColumnLayout < Layout::Basic
      model :column, :< do
        @space = 0
        @tmp_column = {}
        @measurement = nil
      end
      attr_accessor :space

      def get_span_w i, w, pcw
        case w
        when Range
          b = case w.begin
          when Rational
            pcw * w.begin
          when Numeric
            w.begin < 0 ? pcw + w.begin : w.begin
          when nil
            0
          else raise w.begin
          end
          e = case w.end
          when Rational
            pcw * w.end
          when Numeric
            w.end < 0 ? pcw + w.end : w.end
          when nil
            Float::INFINITY
          else raise w.end
          end
          [(e - b).abs, b, i]
        else
          [0, get_d(w, pcw), i]
        end
      end

      def arrange pad
        @measurement ? proper_arrange(pad) : measure_arrange(pad)
      end

      def measure_arrange pad
        cw = pad.cw
        ch = pad.ch
        sw = 0
        spans = @column.each_with_index.map do |c, i|
          span = get_span_w i, c, cw
          sw += span[1] + @space
          span
        end.sort_by{ it[0] }
        spans_size = spans.size
        return if spans_size < 1
        sw -= @space

        if spans.last[0] > 0
          dw = cw - sw
          if dw > 0
            spans.each_with_index do |sp, i|
              if sp[0] > 0
                dwp = dw / (spans_size - i)
                if sp[0] >= dwp
                  dw -= dwp
                  sp[1] += dwp
                  sw += dwp
                else
                  dw -= sp[0]
                  sp[1] += sp[0]
                  sw += sp[0]
                end
              end
            end
          end
        end

        @tmp_column[pad] = spans.sort_by{ it[2] }.map{ it[1] }

        pads = pad.layout_pads
        span_widths = spans.map do |sp|
          if p1 = pads[sp[2]]
            ph = get_h p1, p1.h, ch
            pw = get_w p1, p1.w, sp[1]
            p1.set_size pw, ph
            [p1, sp[1]]
          end
        end.compact.to_h

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
        
        pad.layout_pads.zip @measurement do |a|
          p1 = a[0]
          ph = get_h p1, p1.h, ch
          pw = get_w p1, p1.w, a[1]
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
            cx += (@measurement[i] || pw) + @space
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
        @column.map{ get_span_w(0, it, 0)[1] }.sum + (@column.size - 1) * @space
      end
    end

    class Table < Pad
      extend HasParams

      param def column! *column
        return if @column == column
        @column = column
        @_column_layout = ColumnLayout.new(@column, 0, 0)
        layer&.break_layout
        true
      end

      param def column_space! space
        return if @_column_layout.space == space
        @_column_layout.space = space
        layer&.break_layout
        true
      end, def column_space
        @_column_layout.space
      end

      def row
        {
          w: :fit,
          h: :fit,
          layout: @_column_layout
        }
      end

      def column_layout
        @_column_layout
      end

      def initialize
        super

        @column = nil
        @_column_layout = nil
      end

      def sketch p0
        super 

        layout! :y
        column! 100
      end

      def arrange
        @_column_layout.prepare_arrange
        super
        @_column_layout.measurement
        super
        @_column_layout.reset_arrange
      end

    end
  end
end