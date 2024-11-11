require_relative '../pad/sort_pad'

module Kredki
  module UI
    class GridPad < SortPad
      require_relative 'cell'
      require_relative 'line'

      def_flag :autosized, :set_autosized

      def cursor! col = 0, row = 0
        @current_col = col
        @current_row = row
      end

      def cursor
        [@current_col, @current_row]
      end

      def col! col_index = @current_col, row_index = @current_row, **na, &block
        direction, @direction = @direction, :row
        @current_col = col_index
        @current_row = row_index
        col = @cols[col_index] ||= Line.new self
        col.alter **na
        if block
          instance_exec &block
          @current_col = col_index + 1
          @current_row = row_index
        end
        @direction = direction
        col
      end

      def row! row_index = @current_row, col_index = @current_col, **na, &block
        direction, @direction = @direction, :col
        @current_col = col_index
        @current_row = row_index
        row = @rows[row_index] ||= Line.new self
        row.alter **na
        if block
          instance_exec &block
          @current_col = col_index
          @current_row = row_index + 1
        end
        @direction = direction
        row
      end

      def cell! ...
        altered = alter_begin
        cell = new_pad(Cell, ...)
        cell.col ||= @current_col
        cell.row ||= @current_row
        (cell.min_col..cell.max_col).each do |i|
          @cols[i] ||= Line.new self
        end
        (cell.min_row..cell.max_row).each do |i|
          @rows[i] ||= Line.new self
        end
        case @direction
        when :col
          @current_col = cell.max_col + 1
          @current_row = cell.min_row
        when :row
          @current_col = cell.min_col
          @current_row = cell.max_row + 1
        end
        alter_commit if altered
        cell
      end

      def col index
        @cols[index]
      end

      def row index
        @rows[index]
      end

      #internal api

      def initialize ...
        super

        @cols = {}
        @rows = {}
        @current_col = 0
        @current_row = 0
        @direction = :col

        GridPad.init_flags self

        autosized! true
      end

      def sketch p0
        super

        on_resize! do |e|
          update_pads unless autosized?
        end
      end

      def push_pad pad, index = nil
        unless pad.is_a? Cell
          alter!{ cell!.push_pad pad }
          return pad
        end
        super
        update_pads
        pad
      end

      attr_accessor :direction

      def set_autosized sized
        @autosized != sized && begin
          @autosized = sized
          report SizeModeEvent.new
          true
        end
      end

      def remove_pad pad, transfer = false
        removed = super
        update_pads
        removed
      end

      def update_lines array, min, max, target_size
        if min >= max
          c = array[min]
          c.size = target_size.clamp(c.size, c.max)
        else
          current_size = 0
          bc = (min..max).map{ array[_1] }.filter do |c|
            current_size += c.size
            c.size < c.max
          end
          while bc.size > 0 && current_size < target_size
            w_per_c = (target_size - current_size) / bc.size
            break if w_per_c < 1
            bc = bc.filter do |c|
              size = c.size + w_per_c
              if size < c.max
                current_size += w_per_c
                c.size = size
                true
              else
                current_size += c.max - c.size
                c.size = c.max
                false
              end
            end
          end
        end
      end

      def update_pads
        return if altered? :update_pads
        p "XD"
  
        @cols.each_value{ _1.reset }
        @rows.each_value{ _1.reset }

        @pads.sort{|a, b| a.colspan <=> b.colspan }.each do |pad|
          update_lines @cols, pad.min_col, pad.max_col, pad.max_x
        end
        update_lines @cols, 0, @cols.size - 1, w unless autosized?

        @pads.sort{|a, b| a.rowspan <=> b.rowspan }.each do |pad|
          update_lines @rows, pad.min_row, pad.max_row, pad.max_y
        end
        update_lines @rows, 0, @rows.size - 1, h unless autosized?
        
        w = @cols.keys.sort.reduce 0 do |offset, key|
          @cols[key].then{|col| (col.offset = offset) + col.size }
        end
        h = @rows.keys.sort.reduce 0 do |offset, key|
          @rows[key].then{|row| (row.offset = offset) + row.size }
        end
        event_director.stem do
          mouse_pad_refresh = false
          @pads.each do |pad|
            if pad.set_size @cols[pad.max_col].then{ _1.offset + _1.size } - @cols[pad.min_col].offset, 
              @rows[pad.max_row].then{ _1.offset + _1.size } - @rows[pad.min_row].offset
            then
              pad.report ResizeEvent.new, false
              mouse_pad_refresh = true
            end
            if pad.set_xy @cols[pad.min_col].offset, @rows[pad.min_row].offset
              pad.report MoveEvent.new, false
              mouse_pad_refresh = true
            end
          end
          wh! w, h if autosized?
          action.update_mouse_pad if mouse_pad_refresh && mousy? && show?
        end
      end
    end
  end
end