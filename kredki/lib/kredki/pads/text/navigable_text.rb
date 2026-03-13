module Kredki
  module Pads
    class NavigableTextPad < TextPad
      
      # Set subject.
      def subject! subject = @subject, cursor_position = 0, &b
        if super(subject, &b) && @selection.size != @verses.size
          @selection.clear!
          @verses.each{ @selection.rectangle! fill: :text_selection, size_x: 0 }
        end
        set_cursor cursor_position
      end

      # Set font.
      def font! font = @verses.first.font
        return send_bundle :font!, yield(self.font) if block_given?
        @verses.count{ _1.font! font }.nonzero?
      end
      
      # See #font!.
      def font= param
        send_bundle :font!, param
      end

      # Get font
      def font
        @verses.first.text.font
      end

      # Get whether any text is selected.
      def selection?
        @selection_min != @selection_max
      end

      # Get selected content.
      def selected_content
        text[@selection_min...@selection_max]
      end

      # Set select range.
      def select min, max
        @selection_min = min
        @selection_max = @cursor_position = max
        layer&.break_layout
      end

      # :section: LEVEL 2

      attr :selection_min, :selection_max, :cursor
      attr_accessor :cursor_position

      def set_cursor position = 0
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
        length = text.length
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
      
      attr :selection

      def initialize
        super

        @cursor_position = @selection_min = @selection_max = 0
        @selection = @scene.scene!
        @cursor = @scene.rectangle! fill: :text, size_x: 1, show: false
      end

      def mouse_press e
      end

      def fit_size_x
        super + @cursor.size_x * 2
      end

      def set_size x, y # set_size must be called before get_x/get_y
        super
        update_cursor if @cursor.show?
      end

      def get_x clip_size, size, ax
        if @cursor.show?
          cx = @cursor.x + @cursor.size_x
          if sx + cx > size
            size - cx - @cursor.size_x / 2
          elsif sx + @cursor.x < 0
            @cursor.size_x / 2 - @cursor.x
          else
            sx
          end
        else
          super
        end
      end

      def get_y clip_size, size, ay
        if @cursor.show?
          cy = cursor.y + cursor.size_y
          if sy + cy > size
            size - cy
          elsif sy + cursor.y < 0
            -cursor.y
          else
            sy
          end
        else
          super
        end
      end

      def align_x reference_size_x, size_x
        case @verse_layout
        when :yss, :ysc, :yse
          @cursor.size_x
        when :yes, :yec, :yee
          size_x - reference_size_x - @cursor.size_x
        when :ycs, :ycc, :yce
          (size_x - reference_size_x + @cursor.size_x) * 0.5
        else raise_is @verse_layout
        end
      end

      def cursor_position_for_coordinates x, y
        total = 0
        last = @verses.last
        @verses.each do |v|
          if v.y + v.size_y < y && v != last
            total += v.content.length + 1
          else
            return total + v.nearest_character_index(x - v.x)
          end
        end
        total > 0 ? total - 1 : 0
      end

      def arrange_verses
        sx, sy = area_size
        size_v, space = verse_metrics sy
        @cursor.size_y! size_v
        if @verses.size > 0
          size_t = (size_v + space) * @verses.size - space
          y = align_y size_t, sy
          @verses.each do |v|
            v.size_y! size_v
            x = align_x v.size_x, sx
            v.xy! x.floor, y.floor
            y += size_v + space
          end
        end
        true
      end

      def scroll x, y
        if @verses.size > 0
          sx, sy = area_size

          scene_x = if x == 0
            @scene.x
          else
            fit = fit_size_x
            x0 = align_x fit, sx
            fit > sx ? (@scene.x + x).clamp(sx - fit - x0..-x0) : @scene.x
          end

          scene_y = if y == 0
            @scene.y
          else
            size_v, space = verse_metrics sy
            reference_size_y = (size_v + space) * @verses.size - space
            y0 = align_y reference_size_y, sy
            reference_size_y > sy ? (@scene.y + y).clamp(sy - reference_size_y - y0..-y0) : @scene.y
          end

          @scene.xy! scene_x.floor, scene_y.floor
        end
      end

      def process_drag e, speed = 1
        sx, sy = area_size

        reference_size_x = fit_size_x
        x0 = align_x reference_size_x, sx
        @sx0 = @scene.x if e.start? || !@sx0
        scene_x = reference_size_x > sx ? (@sx0 + (e.x - layer.pin_xy[0]) * speed).clamp(sx - reference_size_x - x0..-x0) : @scene.x

        size_v, space = verse_metrics sy
        reference_size_y = (size_v + space) * @verses.size - space
        y0 = align_y reference_size_y, sy
        @sy0 = @scene.y if e.start? || !@sy0
        scene_y = reference_size_y > sy ? (@sy0 + (e.y - layer.pin_xy[1]) * speed).clamp(sy - reference_size_y - y0..-y0) : @scene.y

        @scene.xy! scene_x.floor, scene_y.floor
      end

      def update_cursor
        total = -1
        @cursor.xy! align_x(@cursor.size_x * 0.5, area_size_x).floor, align_y(@cursor.size_y, area_size_y).floor
        @verses.each do |verse|
          total += 1
          if @cursor_position <= total + verse.content.length
            x = verse.substring_width @cursor_position - total
            @cursor.xy! (x + verse.x - @cursor.size_x * 0.5).floor, verse.y.floor
            break
          end
          total += verse.content.length
        end

        total = -1
        @verses.zip @selection.each_paint do |v, s|
          total += 1
          next_total = total + v.content.length
          if @selection_min == @selection_max || @selection_min > next_total || @selection_max <= total
            s.size_x! 0
          elsif @selection_min <= total && @selection_max >= next_total
            s.size! *v.size
            s.xy! *v.xy
          elsif @selection_max >= next_total
            x1 = v.substring_width @selection_min - total
            s.size! v.size_x - x1, v.size_y
            s.xy! v.x + x1, v.y
          elsif @selection_min <= total
            x1 = v.substring_width @selection_max - total
            s.size! x1, v.size_y
            s.xy! *v.xy
          else
            x1 = v.substring_width @selection_min - total
            x2 = v.substring_width @selection_max - total
            s.size! x2 - x1, v.size_y
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
          set_cursor cursor_position
        end
      end

      def cursor_end shift, ctrl
        cursor_position = if ctrl
          text.length
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
          set_cursor cursor_position
        end
      end
    end
  end
end