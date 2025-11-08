module Kredki
  module UI
    class NavigableText < TextPad

      attr :selection_min, :selection_max, :cursor
      attr_accessor :cursor_position
      
      def content! content = @content, reset_cursor = false, &b
        if super(content, &b) && @selection.size != @verses.size
          @selection.clear!
          @verses.each{ @selection.rectangle! fill_color: :text_selection, w: 0 }
        end
        self.reset_cursor if reset_cursor
      end

      param def font! font = nil
        return font! (yield self.font) if block_given?
        @lines.each{ _1.text.font! font }
      end, def font
        @lines.first.text.font
      end

      param_service def cursor
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
        @selection = @scene.scene!
        @cursor = @scene.rectangle! fill_color: :text, w: 2, show: false
      end

      def mouse_down e
      end

      def fit_w
        super + @cursor.w * 2
      end

      def set_size w, h # works until set_size is called before get_x/get_y
        super
        update_cursor if @cursor.show?
      end

      def get_x pcw, sw, ax
        if @cursor.show?
          cx = @cursor.x + @cursor.w
          if sx + cx > sw
            sw - cx - @cursor.w / 2
          elsif sx + @cursor.x < 0
            @cursor.w / 2 - @cursor.x
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
        when :ybb, :ybc, :ybe
          @cursor.w
        when :yeb, :yec, :yee
          w - tw - @cursor.w
        when :ycb, :ycc, :yce
          (w - tw + @cursor.w) * 0.5
        else raise_is @verse_layout
        end
      end

      def cursor_position_for_coordinates x, y
        total = 0
        last = @verses.last
        @verses.each do |v|
          if v.y + v.h < y && v != last
            total += v.content.length + 1
          else
            return total + v.nearest_character_index(x - v.x)
          end
        end
        total > 0 ? total - 1 : 0
      end

      def arrange_verses
        w, h = swh
        size, space = verse_metrics h
        @cursor.h! size
        if @verses.size > 0
          tsize = (size + space) * @verses.size - space
          y = align_y tsize, h
          @verses.each do |v|
            v.h! size
            x = align_x v.w, w
            v.xy! x, y
            y += size + space
          end
        end
        true
      end

      def update_cursor
        total = -1
        @cursor.xy! align_x(@cursor.w * 0.5, sw), align_y(@cursor.h, sh)
        @verses.each do |verse|
          total += 1
          if @cursor_position <= total + verse.content.length
            x = verse.substring_width @cursor_position - total
            @cursor.xy! x + verse.x - @cursor.w * 0.5, verse.y
            break
          end
          total += verse.content.length
        end

        total = -1
        @verses.zip @selection.each_paint do |v, s|
          total += 1
          next_total = total + v.content.length
          if @selection_min == @selection_max || @selection_min > next_total || @selection_max <= total
            s.w! 0
          elsif @selection_min <= total && @selection_max >= next_total
            s.wh! *v.wh
            s.xy! *v.xy
          elsif @selection_max >= next_total
            x1 = v.substring_width @selection_min - total
            s.wh! v.w - x1, v.h
            s.xy! v.x + x1, v.y
          elsif @selection_min <= total
            x1 = v.substring_width @selection_max - total
            s.wh! x1, v.h
            s.xy! *v.xy
          else
            x1 = v.substring_width @selection_min - total
            x2 = v.substring_width @selection_max - total
            s.wh! x2 - x1, v.h
            s.xy! v.x + x1, v.y
          end
          total = next_total
        end
      end

      def cursor_up shift
        prev_v = nil
        cursor_position = @verses.reduce -1 do |total, v|
          total += 1
          if total + v.content.length >= @cursor_position
            break prev_v ? total - prev_v.content.length + prev_v.nearest_character_index(@cursor.x - prev_v.x) - 1 : 0
          end
          prev_v = v
          total + v.content.length
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
        cursor_position = @verses.reduce -1 do |total, v|
          total += 1
          if total > @cursor_position
            break total + v.nearest_character_index(@cursor.x - v.x)
          end
          total + v.content.length
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
          @verses.reduce -1 do |total, v|
            length = v.content.length
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
          @verses.reduce -1 do |total, v|
            break total if total >= @cursor_position
            total + 1 + v.content.length
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