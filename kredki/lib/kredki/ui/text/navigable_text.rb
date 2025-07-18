require_relative 'text_navigation'

module Kredki
  module UI
    class NavigableText < TextPad
      include TextNavigation

      attr :selection_min, :selection_max, :cursor
      attr_accessor :cursor_position
      
      def content! content = @content, reset_cursor = false, &b
        super(content, &b) and begin
          if @selection.size != @text.size
            @selection.each{ it.detach! }
            @selection = @text.map{ @scene.rectangle! color: :text_selection, at: @cursor }
          end
          true
        end
        self.reset_cursor if reset_cursor
      end

      param def font! font
        @lines.each{ _1.text.font! font }
      end, get: def font
        @lines.first.text.font
      end

      def cursor! ...
        @cursor.alter(...)
      end

      def cursor
        @cursor
      end

      def selection?
        @selection_min != @selection_max
      end

      def selected_content
        content[@selection_min...@selection_max]
      end

      def reset_cursor position = 0
        @cursor_position = @selection_min = @selection_max = position
        layer&.break_layout
      end

      def drag x, y
        cursor_position = cursor_position_for_coordinates x, y
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
          layer&.break_layout
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
        layer&.break_layout
      end

      def cursor_right shift
        length = content.to_s.length
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
        layer&.break_layout
      end

      def select min, max
        @selection_min = min
        @selection_max = @cursor_position = max
        layer&.break_layout
      end

      #internal api

      attr :selection

      def initialize
        super

        @cursor_position = @selection_min = @selection_max = 0
        @cursor = @scene.rectangle! color: :text, w: 2, show: false
        @selection = []
      end

      def arrange
        super
        update_cursor
      end

      def get_x pcw, sw, ax
        if @cursor.show?
          cx = @cursor.x + @cursor.w
          if sx + cx > sw
            sw - cx - @cursor.w / 2
          elsif sx + @cursor.x < 0
            -@cursor.x + @cursor.w / 2
          else
            sx
          end
        else
          super
        end
      end

      def get_y pch, sh, ay
        if @cursor.show?
          cy = cursor.y + cursor.h
          if sy + cy > sh
            sh - cy
          elsif sy + cursor.y < 0
            -cursor.y
          else
            sy
          end
        else
          super
        end
      end

      def align_x tw, w
        case @verse_layout
        when :c, :cc, :cn, :cs
          (w - tw - @cursor.w) / 2
        when :e, :ec, :en, :es
          w - tw - @cursor.w
        else
          @cursor.w
        end
      end

      def cursor_position_for_coordinates x, y
        total = 0
        last = @text.last
        @text.each do |text|
          if text.y + text.h < y && text != last
            total += text.content.length + 1
          else
            return total + text.nearest_character_index(x - text.x)
          end
        end
        total > 0 ? total - 1 : 0
      end

      def update_cursor
        total = -1
        @cursor.h! @vh if @vh != :auto
        @cursor.xy! align_x(@cursor.w / 2, sw), align_y(@cursor.h, sh)
        @text.each do |text|
          total += 1
          if @cursor_position <= total + text.content.length
            x = text.substring_width @cursor_position - total
            @cursor.h! text.h
            @cursor.xy! text.x + x - @cursor.w / 2, text.y
            break
          end
          total += text.content.length
        end

        total = -1
        @text.each_with_index do |text, i|
          total += 1
          next_total = total + text.content.length
          if @selection_min == @selection_max || @selection_min > next_total || @selection_max <= total
            @selection[i].w! 0
          elsif @selection_min <= total && @selection_max >= next_total
            @selection[i].wh! *text.wh
            @selection[i].xy! *text.xy
          elsif @selection_max >= next_total
            x1 = text.substring_width @selection_min - total
            @selection[i].wh! text.w - x1, text.h
            @selection[i].xy! text.x + x1, text.y
          elsif @selection_min <= total
            x1 = text.substring_width @selection_max - total
            @selection[i].wh! x1, text.h
            @selection[i].xy! *text.xy
          else
            x1 = text.substring_width @selection_min - total
            x2 = text.substring_width @selection_max - total
            @selection[i].wh! x2 - x1, text.h
            @selection[i].xy! text.x + x1, text.y
          end
          total = next_total
        end
      end

      def cursor_up shift
        prev_text = nil
        cursor_position = @text.reduce -1 do |total, text|
          total += 1
          if total + text.content.length >= @cursor_position
            break prev_text ? total - prev_text.content.length + prev_text.nearest_character_index(@cursor.x - prev_text.x) - 1 : 0
          end
          prev_text = text
          total + text.content.length
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
        @scene.x = 0
        layer&.break_layout
      end

      def cursor_down shift
        cursor_position = @text.reduce -1 do |total, text|
          total += 1
          if total > @cursor_position
            break total + text.nearest_character_index(@cursor.x - text.x)
          end
          total + text.content.length
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
        @scene.x = 0
        layer&.break_layout
      end

      def cursor_home shift, ctrl
        cursor_position = if ctrl
          0
        else
          @text.reduce -1 do |total, text|
            length = text.content.length
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
          layer&.break_layout
        else
          reset_cursor cursor_position
        end
      end

      def cursor_end shift, ctrl
        cursor_position = if ctrl
          content.length
        else
          @text.reduce -1 do |total, text|
            break total if total >= @cursor_position
            total + 1 + text.content.length
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
          layer&.break_layout
        else
          reset_cursor cursor_position
        end
      end
    end
  end
end