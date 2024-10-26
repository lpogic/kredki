module Kredki
  module UI
    class NLabel < Pad

      class Line
        model :selection, :text
      end

      def initialize
        super

        @text_place = proc{ 0 }
        Label.init_flags self
      end

      def sketch p0
        super

        body.hide!
        keyboardy!

        @cursor_position = @selection_min = @selection_max = 0

        @lines = []
        push_line

        @cursor = rectangle! x: 0, y: 0, color: :black, w: 2, h: @lines.first.text.h

        p0.wh = @lines.first.text.wh
    
        on_key! :left do |e|
          cursor_left e.shift?
          e.resolve
        end
    
        on_key! :right do |e|
          cursor_right e.shift?
          e.resolve
        end

        on_key! :up do |e|
          cursor_up e.shift?
          e.resolve
        end

        on_key! :down do |e|
          cursor_down e.shift?
          e.resolve
        end

        on_key! :home do |e|
          cursor_home e.shift?, e.ctrl?
          e.resolve
        end

        on_key! :keypad_seven do |e|
          unless e.num?
            cursor_home e.shift?, e.ctrl?
            e.resolve
          end
        end

        on_key! :end do |e|
          cursor_end e.shift?, e.ctrl?
          e.resolve
        end

        on_key! :keypad_one do |e|
          unless e.num?
            cursor_end e.shift?, e.ctrl?
            e.resolve
          end
        end

        on_key! :a do |e|
          if e.ctrl?
            @selection_min = 0
            @selection_max = @cursor_position = string_length
            update_cursor true
            e.resolve
          end
        end

        on_key! :c do |e|
          if e.ctrl? && selection?
            clipboard.string = string[@selection_min...@selection_max]
            e.resolve
          end
        end

        on_mouse_button! do |e|
          if keyboard.shift?
            drag e.x, e.y
          else
            cursor_position = self.cursor_position e.x, e.y
            reset_cursor cursor_position, true, true
          end
          e.resolve
        end

        on_drag! do |e|
          drag e.x, e.y
          e.resolve
        end

        on_drop! do |e|
          @cursor_position = cursor_position e.x, e.y
          e.resolve
        end

        on_click! do |e|
          if e.clicks > 1 && !keyboard.shift?
            @selection_min = 0
            @cursor_position = @selection_max = @lines.map{ _1.text.string.length }.sum + @lines.length - 1
            update_cursor
            @cursor.hide!
          end
          e.resolve
        end

        on_scroll! do |e|
          if keyboard_top?
            # scroll e.xory
            # drag mouse.x if mouse.down?
          end
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

      attr :text, :selection_min, :selection_max, :cursor_position

      def << arg
        case arg
        when String
          s! arg
        else
          super
        end
      end

      def push_line
        p0 = self
        y = @lines.last&.then{ _1.text.y + _1.text.h } || 0
        selection = rectangle! x: 0, y:, w: 0, h: 30, color: :blue do
          clip! p0.body
        end

        text = text! x: 0, y:, color: :white, font: :arial, h: 30 do
          clip! p0.body
        end

        line = Line.new selection, text
        @lines << line
        line
      end

      def selection?
        @selection_min != @selection_max
      end

      def cursor_position x, y
        total = -1
        @lines.each do |line|
          total += 1
          text = line.text
          if text.y + text.h < y
            total += text.string.length
          else
            return total + text.nearest_character_index(x - text.x)
          end
        end
        return total
      end

      

      def update_cursor move = false, show = true
        @cursor.show! if show
        total = -1
        @lines.each do |line|
          total += 1
          text = line.text
          if @cursor_position <= total + text.string.length
            @cursor.y = text.y
            x = text.substring_width @cursor_position - total
            if move
              if text.x + x > w
                @cursor.x = @text_place.(text.w, w) + w - 1
                @lines.each{ _1.text.x = @text_place.(_1.text.w, w) + w - x }
              elsif text.x + x < 0
                @cursor.x = @text_place.(text.w, w) - 1
                @lines.each{ _1.text.x = @text_place.(_1.text.w, w) - x }
              else
                @cursor.x = text.x + x - 1
              end
            else
              if x <= w
                @cursor.x = @text_place.(text.w, w) + x - 1
                @lines.each{ _1.text.x = @text_place.(_1.text.w, w) }
              elsif text.x + x < w && text.x + x > 0
                @cursor.x = text.x + x - 1
              else
                cursor.x = @text_place.(text.w, w) + w / 2 - 1
                @lines.each{ _1.text.x = @text_place.(_1.text.w, w) + w / 2 - x }
              end
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

      def reset_cursor position = 0, move = false, show = false
        @cursor_position = @selection_min = @selection_max = position
        update_cursor move, show
      end

      def scroll move
        offset = 0
        if move > 0
          if @text.x < 0
            offset = [@text.x + move * @text.h, 0].min - @text.x
          end
        elsif move < 0
          min_text_x = w - @text.w
          if @text.x > min_text_x
            offset = @text.x - [@text.x - move * @text.h, min_text_x].max
          end
        end
        if offset != 0
          @text.x += offset
          @selection.x += offset if selection?
          @cursor.hide!
        end
      end

      def drag x, y
        cursor_position = self.cursor_position x, y
        if cursor_position != @cursor_position
          if @cursor_position == @selection_min
            if cursor_position <= @selection_max
              @selection_min = @cursor_position = cursor_position
            else
              @selection_min = @selection_max
              @selection_max = @cursor_position = cursor_position
            end
          elsif @cursor_position == @selection_max
            if cursor_position >= @selection_min
              @selection_max = @cursor_position = cursor_position
            else
              @selection_max = @selection_min
              @selection_min = @cursor_position = cursor_position
            end
          end
          update_cursor true
        end
      end

      def cursor_left shift
        if shift
          if @cursor_position > 0
            if @cursor_position == @selection_min
              @selection_min = @cursor_position -= 1
            elsif @cursor_position == @selection_max
              @selection_max = @cursor_position -= 1
            end
          end
        else
          if @selection_min == @selection_max            
            @cursor_position -= 1 if @cursor_position > 0
            @selection_min = @selection_max = @cursor_position
          else
            @cursor_position = @selection_max = @selection_min
          end
        end
        update_cursor true
      end

      def cursor_right shift
        length = string_length
        if shift
          if @cursor_position < length
            if @cursor_position == @selection_max
              @selection_max = @cursor_position += 1
            elsif @cursor_position == @selection_min
              @selection_min = @cursor_position += 1
            end
          end
        else
          if @selection_min == @selection_max            
            @cursor_position += 1 if @cursor_position < length
            @selection_min = @selection_max = @cursor_position
          else
            @cursor_position = @selection_min = @selection_max
          end
        end
        update_cursor true
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
        update_cursor true
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
        update_cursor true
      end

      def cursor_home shift
        if shift
          @selection_max = @selection_min if @cursor_position == @selection_max
          @selection_min = @cursor_position = 0
          update_cursor true
        else
          reset_cursor 0, true
        end
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
          update_cursor true
        else
          reset_cursor cursor_position, true
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
          update_cursor true
        else
          reset_cursor cursor_position, true
        end
      end

      aliasing def s! str = "", reset_cursor = true, &block
        string = self.string
        str = block.call string, str if block
        string != str && begin
          str += "\n" if str.empty? || str.end_with?("\n")
          texts = str.each_line chomp: true
          @lines = Enumerable.zip @lines, texts do |line, s|
            if line
              if s
                line.text.s! s
                line
              else
                line.text.detach!
                line.selection.detach!
                nil
              end
            else
              line = push_line
              line.text.s! s
              line
            end
          end.compact
          wh! @lines.map{ _1.text.w.ceil }.max, @lines.last.text.then{ _1.y + _1.h } if autosized?
          self.reset_cursor if reset_cursor
          true
        end
      end, :s=, :string!, :string=

      aliasing def s
        @lines.map{ _1.text.string }.join "\n"
      end, :string

      aliasing def color! ...
        @lines.each{ _1.text.color! ... }
      end, :color=

      def color
        @lines.first.text.color
      end

      aliasing def text_place! place
        @text_place = case place
        when :l, :left then proc{ 0 }
        when :c, :center then proc{ (_2 - _1) / 2 }
        when :r, :right then proc{ _2 - _1 }
        when Proc then place
        else raise "Invalid #{place.class}[#{place}] given"
        end
      end, :text_place=

      def_flag :autosized!, true, true

      def string_length
        @lines.map{ _1.text.string.length }.sum + @lines.length - 1
      end
    end
  end
end