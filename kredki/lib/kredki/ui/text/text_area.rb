require_relative 'text'

module Kredki
  module UI
    class TextArea < Text

      class Line
        model :selection, :text
      end

      def initialize
        super

        @text_x = POSITION_START
        @cursor_position = @selection_min = @selection_max = 0
        @cursor = @scene.rectangle! x: 1, y: 0, color: :white, w: 2, h: 30
        @lines = []
      end

      def sketch p0
        super

        push_line

        p0.wh = @lines.first.text.wh
    
        on_key! :up do |e|
          cursor_up e.shift?
          e.resolve
        end

        on_key! :down do |e|
          cursor_down e.shift?
          e.resolve
        end

        on_focus_lose! do |e|
          @cursor.hide!
          @lines.each{ _1.selection.hide! }
          e.resolve
        end.resolve FocusLoseEvent.new

        on_focus_gain! do |e|
          @lines.each{ _1.selection.show! }
          @cursor.show!
          e.resolve
        end
      end

      def push_line
        p0 = self
        if last = @lines.last
          h = last.text.h
          y = last.text.y + h
        else
          h = 30
          y = 0
        end

        selection = @scene.rectangle! x: 0, y:, w: 0, h:, color: :blue do
          clip! p0.area
        end

        text = @scene.text! x: @cursor.w / 2, y:, color: :white, font: :arial, h: do
          clip! p0.area
        end

        line = Line.new selection, text
        @lines << line
        line
      end

      def cursor_position x, y
        total = -1
        @lines.each do |line|
          total += 1
          text = line.text
          if text.y + text.h < y && line != @lines.last
            total += text.string.length
          else
            return total + text.nearest_character_index(x - text.x)
          end
        end
        return total
      end

      def update_text w = nil
        cw = @cursor.w / 2
        y = 0
        @lines.each do |line|
          line.text.xy! @text_x.call(line.text.w, w) + cw, y
          line.selection.y! y
          y += line.text.h
        end
        update_cursor
      end

      def update_cursor
        total = -1
        @lines.each do |line|
          total += 1
          text = line.text
          if @cursor_position <= total + text.string.length
            x = text.substring_width @cursor_position - total
            if @cursor.xy! text.x + x - @cursor.w / 2, text.y
              report ROIEvent.new(*@cursor.wh, *translate(*@cursor.xy))
            end
            break
          end
          total += text.string.length
        end

        total = -1
        @lines.each do |line|
          total += 1
          next_total = total + line.text.string.length
          if @selection_min == @selection_max || @selection_min > next_total || @selection_max <= total
            line.selection.w = 0
          elsif @selection_min <= total && @selection_max >= next_total
            line.selection.w = line.text.w
            line.selection.x = line.text.x
          elsif @selection_max >= next_total
            x1 = line.text.substring_width @selection_min - total
            line.selection.w = line.text.w - x1
            line.selection.x = line.text.x + x1
          elsif @selection_min <= total
            x1 = line.text.substring_width @selection_max - total
            line.selection.w = x1
            line.selection.x = line.text.x
          else
            x1 = line.text.substring_width @selection_min - total
            x2 = line.text.substring_width @selection_max - total
            line.selection.w = x2 - x1
            line.selection.x = line.text.x + x1
          end
          total = next_total
        end
      end

      def cursor_up shift
        prev_text = nil
        cursor_position = @lines.reduce -1 do |total, line|
          total += 1
          text = line.text
          if total + text.string.length >= @cursor_position
            break prev_text ? total - prev_text.string.length + prev_text.nearest_character_index(@cursor.x - prev_text.x) - 1 : 0
          end
          prev_text = text
          total + text.string.length
        end
        if shift
          if @cursor_position == @selection_min
            @selection_min = @cursor_position = cursor_position
          elsif cursor_position >= @selection_min
            @selection_max = @cursor_position = cursor_position
          else
            @selection_max = @selection_min
            @selection_min = @cursor_position = cursor_position
          end
        else
          if @selection_min == @selection_max            
            @selection_min = @selection_max = @cursor_position = cursor_position
          else
            @cursor_position = @selection_max = @selection_min
          end
        end
        update_cursor
      end

      def cursor_down shift
        cursor_position = @lines.reduce -1 do |total, line|
          total += 1
          text = line.text
          if total > @cursor_position
            break total + text.nearest_character_index(@cursor.x - text.x)
          end
          total + text.string.length
        end
        if shift
          if @cursor_position == @selection_max
            @selection_max = @cursor_position = cursor_position
          elsif cursor_position <= @selection_max
            @selection_min = @cursor_position = cursor_position
          else
            @selection_min = @selection_max
            @selection_max = @cursor_position = cursor_position
          end
        else
          if @selection_min == @selection_max            
            @selection_min = @selection_max = @cursor_position = cursor_position
          else
            @cursor_position = @selection_min = @selection_max
          end
        end
        update_cursor
      end

      def cursor_home shift, ctrl
        cursor_position = if ctrl
          0
        else
          @lines.reduce -1 do |total, line|
            length = line.text.string.length
            total += 1
            break total if total + length >= @cursor_position
            total + length
          end
        end

        if shift
          if @cursor_position == @selection_max
            if cursor_position <= @selection_min
              @selection_max = @selection_min
              @selection_min = cursor_position
            else
              @selection_max = cursor_position
            end
          else
            @selection_min = cursor_position
          end
          @cursor_position = cursor_position
          update_cursor
        else
          reset_cursor cursor_position
        end
      end

      def cursor_end shift, ctrl
        cursor_position = if ctrl
          string_length
        else
          @lines.reduce -1 do |total, line|
            break total if total >= @cursor_position
            total + 1 + line.text.string.length
          end
        end

        if shift
          if @cursor_position == @selection_min
            if cursor_position >= @selection_max
              @selection_min = @selection_max
              @selection_max = cursor_position
            else
              @selection_min = cursor_position
            end
          else
            @selection_max = cursor_position
          end
          @cursor_position = cursor_position
          update_cursor
        else
          reset_cursor cursor_position
        end
      end

      aliasing def string! string = "", reset_cursor = true, &block
        string = string.to_s
        self.string != string && begin
          string += "\n" if string.empty? || string.end_with?("\n")
          texts = string.each_line chomp: true
          @lines = Enumerable.zip @lines, texts do |line, s|
            if line
              if s
                line.text.string! s
                line
              else
                line.text.detach!
                line.selection.detach!
                nil
              end
            else
              line = push_line
              line.text.string! s
              line
            end
          end.compact
          w = @lines.map{ _1.text.w }.max
          update_text w
          wh! w + @cursor.w, @lines.last.text.then{ _1.y + _1.h }
          self.reset_cursor if reset_cursor
          true
        end
      end, :string=

      def string
        @lines.map{ _1.text.string }.join "\n"
      end

      aliasing def color! ...
        @lines.each{ _1.text.color! ... }
      end, :color=

      def color
        @lines.first.text.color
      end

      aliasing def font! font
        @lines.each{ _1.text.font! font }
      end, :font=

      def font
        @lines.first.text.font
      end

      aliasing def tx! position
        position = case position
        when :l, :left then POSITION_START
        when :c, :center then POSITION_CENTER
        when :r, :right then POSITION_END
        when Proc then position
        else raise "Invalid #{position.class}[#{position}] given"
        end
        position != @text_x && begin
          @text_x = position
          update_text w - @cursor.w
          true
        end
      end, :tx=, :text_x!, :text_x=

      aliasing def tx
        @text_x
      end, :text_x

      aliasing def fh! height
        height != @lines.first.text.h && begin
          @lines.each do |line|
            line.text.h = line.selection.h = height
          end
          @cursor.h = height
          w = @lines.map{ _1.text.w }.max
          update_text w
          wh! w + @cursor.w, @lines.last.text.then{ _1.y + _1.h }
          true
        end
      end, :fh=, :font_height!, :font_height=

      aliasing def fh
        @lines.first.text.h
      end, :font_height

      def string_length
        @lines.map{ _1.text.string.length }.sum + @lines.length - 1
      end
    end
  end
end