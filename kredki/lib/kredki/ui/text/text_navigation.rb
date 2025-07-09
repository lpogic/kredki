module Kredki
  module UI
    module TextNavigation
      attr :selection_min, :selection_max, :cursor_position, :cursor

      def text_sketch
    
        on_key! :left do |e|
          cursor_left e.shift?
          e.resolve
        end
    
        on_key! :right do |e|
          cursor_right e.shift?
          e.resolve
        end

        on_key! :home do |e|
          cursor_home e.shift?, e.ctrl?
          e.resolve
        end

        on_key! :keypad_seven do |e|
          unless e.num_lock?
            cursor_home e.shift?, e.ctrl?
            e.resolve
          end
        end

        on_key! :end do |e|
          cursor_end e.shift?, e.ctrl?
          e.resolve
        end

        on_key! :keypad_one do |e|
          unless e.num_lock?
            cursor_end e.shift?, e.ctrl?
            e.resolve
          end
        end

        on_key! :a do |e|
          if e.ctrl?
            select 0, content.length
            e.resolve
          end
        end

        on_key! :c do |e|
          if e.ctrl? && selection?
            clipboard.content = content[@selection_min...@selection_max]
            e.resolve
          end
        end

        on_mouse_button! :primary do |e|
          if keyboard.shift?
            drag e.x, e.y
          else
            if e.clicks < 2
              cursor_position = self.cursor_position e.x, e.y
              reset_cursor cursor_position
            end
          end
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
          if e.clicks == 2 && !keyboard.shift?
            sl = content.length
            unless @selection_min == 0 && sl == @selection_max && sl == @cursor_position
              select 0, sl
              e.resolve
            end
          end
        end
      end

      def selection?
        @selection_min != @selection_max
      end

      def reset_cursor position = 0
        @cursor_position = @selection_min = @selection_max = position
        layer&.break_layout
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
        length = content.length
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
    end
  end
end